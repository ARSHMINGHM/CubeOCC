`timescale 1ns/1ps

module cubeocc_top (
    input  logic       pclk,
    input  logic       rst_n,

    input  logic       cam_vsync,
    input  logic       cam_href,
    input  logic [7:0] cam_pixel_data,

    output logic [7:0] m_axis_tdata,
    output logic       m_axis_tvalid,
    input  logic       m_axis_tready,
    output logic       m_axis_tlast,
    output logic       m_axis_tuser,

    output logic       roi_valid,
    output logic       roi_tracking_active,
    output logic [9:0] roi_x,
    output logic [9:0] roi_y,
    output logic [9:0] roi_width,
    output logic [9:0] roi_height,
    output logic [9:0] roi_tl_x,
    output logic [9:0] roi_tl_y,
    output logic [9:0] roi_tr_x,
    output logic [9:0] roi_tr_y,
    output logic [9:0] roi_br_x,
    output logic [9:0] roi_br_y,
    output logic [9:0] roi_bl_x,
    output logic [9:0] roi_bl_y
);

    logic [7:0] axis_cam_tdata;
    logic       axis_cam_tvalid;
    logic       axis_cam_tready;
    logic       axis_cam_tlast;
    logic       axis_cam_tuser;

    logic [7:0] hls_axis_tdata;
    logic       hls_axis_tvalid;
    logic       hls_axis_tlast;
    logic       hls_axis_tuser;
    logic [6:0] out_col_count;
    logic       out_fire;

    logic [5:0]  hls_awaddr;
    logic        hls_awvalid;
    logic        hls_awready;
    logic [31:0] hls_wdata;
    logic [3:0]  hls_wstrb;
    logic        hls_wvalid;
    logic        hls_wready;
    logic [1:0]  hls_bresp;
    logic        hls_bvalid;
    logic [5:0]  hls_araddr;
    logic        hls_arvalid;
    logic        hls_arready;
    logic [31:0] hls_rdata;
    logic [1:0]  hls_rresp;
    logic        hls_rvalid;

    typedef enum logic [3:0] {
        HLS_INIT_SEND,
        HLS_INIT_RESP,
        HLS_INIT_DONE
    } hls_init_state_e;

    hls_init_state_e hls_init_state;
    logic [1:0] hls_init_index;
    logic       hls_aw_done;
    logic       hls_w_done;
    logic [5:0] hls_next_addr;
    logic [31:0] hls_next_data;

    always_comb begin
        case (hls_init_index)
            2'd0: begin
                hls_next_addr = 6'h10;
                hls_next_data = 32'd92160;
            end
            2'd1: begin
                hls_next_addr = 6'h18;
                hls_next_data = 32'd127;
            end
            2'd2: begin
                hls_next_addr = 6'h20;
                hls_next_data = 32'd0;
            end
            default: begin
                hls_next_addr = 6'h00;
                hls_next_data = 32'h00000081;
            end
        endcase
    end

    always_ff @(posedge pclk or negedge rst_n) begin
        if (!rst_n) begin
            hls_init_state <= HLS_INIT_SEND;
            hls_init_index <= 2'd0;
            hls_aw_done <= 1'b0;
            hls_w_done <= 1'b0;
            hls_awaddr <= 6'd0;
            hls_awvalid <= 1'b0;
            hls_wdata <= 32'd0;
            hls_wstrb <= 4'hf;
            hls_wvalid <= 1'b0;
        end else begin
            hls_awvalid <= 1'b0;
            hls_wvalid <= 1'b0;

            case (hls_init_state)
                HLS_INIT_SEND: begin
                    hls_awaddr <= hls_next_addr;
                    hls_wdata <= hls_next_data;

                    if (!hls_aw_done) begin
                        hls_awvalid <= 1'b1;
                    end
                    if (!hls_w_done) begin
                        hls_wvalid <= 1'b1;
                    end

                    if (hls_awready) begin
                        hls_aw_done <= 1'b1;
                    end
                    if (hls_wready) begin
                        hls_w_done <= 1'b1;
                    end

                    if ((hls_aw_done || hls_awready) && (hls_w_done || hls_wready)) begin
                        hls_init_state <= HLS_INIT_RESP;
                    end
                end

                HLS_INIT_RESP: begin
                    if (hls_bvalid) begin
                        hls_aw_done <= 1'b0;
                        hls_w_done <= 1'b0;
                        if (hls_init_index == 2'd3) begin
                            hls_init_state <= HLS_INIT_DONE;
                        end else begin
                            hls_init_index <= hls_init_index + 1'b1;
                            hls_init_state <= HLS_INIT_SEND;
                        end
                    end
                end

                HLS_INIT_DONE: begin
                    if (hls_bvalid) begin
                        hls_init_state <= HLS_INIT_DONE;
                    end
                end
            endcase
        end
    end

    assign hls_araddr = 6'd0;
    assign hls_arvalid = 1'b0;
    assign out_fire = hls_axis_tvalid && m_axis_tready;

    always_ff @(posedge pclk or negedge rst_n) begin
        if (!rst_n) begin
            out_col_count <= 7'd0;
        end else if (out_fire) begin
            if (out_col_count == 7'd127) begin
                out_col_count <= 7'd0;
            end else begin
                out_col_count <= out_col_count + 1'b1;
            end
        end
    end

    assign m_axis_tdata = hls_axis_tdata;
    assign m_axis_tvalid = hls_axis_tvalid;
    assign m_axis_tlast = hls_axis_tvalid && (out_col_count == 7'd127);
    assign m_axis_tuser = hls_axis_tuser;

    // Camera 1 tracking runs beside the DVP-to-AXIS data path. The current
    // constants are V1 test defaults and become camera-control registers
    // when Camera 2 ROI I2C programming is integrated.
    roi_start_detector u_roi_tracker (
        .pclk(pclk),
        .rst_n(rst_n),
        .vsync(cam_vsync),
        .href(cam_href),
        .pixel_data(cam_pixel_data),
        .bright_threshold(8'd180),
        .min_line_run(10'd20),
        .min_roi_height(10'd12),
        .full_off_max_pixels(32'd0),
        .roi_valid,
        .tracking_active(roi_tracking_active),
        .frame_done(),
        .roi_x,
        .roi_y,
        .roi_width,
        .roi_height,
        .roi_tl_x,
        .roi_tl_y,
        .roi_tr_x,
        .roi_tr_y,
        .roi_br_x,
        .roi_br_y,
        .roi_bl_x,
        .roi_bl_y
    );

    dvp_to_axis u_dvp_to_axis (
        .pclk(pclk),
        .rst_n(rst_n),
        .vsync(cam_vsync),
        .href(cam_href),
        .pixel_data(cam_pixel_data),
        .m_axis_tdata(axis_cam_tdata),
        .m_axis_tvalid(axis_cam_tvalid),
        .m_axis_tready(axis_cam_tready),
        .m_axis_tlast(axis_cam_tlast),
        .m_axis_tuser(axis_cam_tuser)
    );

    cubeocc_hls_0 u_cubeocc_hls (
        .s_axi_CTRL_AWADDR(hls_awaddr),
        .s_axi_CTRL_AWVALID(hls_awvalid),
        .s_axi_CTRL_AWREADY(hls_awready),
        .s_axi_CTRL_WDATA(hls_wdata),
        .s_axi_CTRL_WSTRB(hls_wstrb),
        .s_axi_CTRL_WVALID(hls_wvalid),
        .s_axi_CTRL_WREADY(hls_wready),
        .s_axi_CTRL_BRESP(hls_bresp),
        .s_axi_CTRL_BVALID(hls_bvalid),
        .s_axi_CTRL_BREADY(1'b1),
        .s_axi_CTRL_ARADDR(hls_araddr),
        .s_axi_CTRL_ARVALID(hls_arvalid),
        .s_axi_CTRL_ARREADY(hls_arready),
        .s_axi_CTRL_RDATA(hls_rdata),
        .s_axi_CTRL_RRESP(hls_rresp),
        .s_axi_CTRL_RVALID(hls_rvalid),
        .s_axi_CTRL_RREADY(1'b1),
        .ap_clk(pclk),
        .ap_rst_n(rst_n),
        .interrupt(),
        .s_axis_TVALID(axis_cam_tvalid),
        .s_axis_TREADY(axis_cam_tready),
        .s_axis_TDATA(axis_cam_tdata),
        .s_axis_TDEST(1'b0),
        .s_axis_TKEEP(1'b1),
        .s_axis_TSTRB(1'b1),
        .s_axis_TUSER(axis_cam_tuser),
        .s_axis_TLAST(axis_cam_tlast),
        .s_axis_TID(1'b0),
        .m_axis_TVALID(hls_axis_tvalid),
        .m_axis_TREADY(m_axis_tready),
        .m_axis_TDATA(hls_axis_tdata),
        .m_axis_TDEST(),
        .m_axis_TKEEP(),
        .m_axis_TSTRB(),
        .m_axis_TUSER(hls_axis_tuser),
        .m_axis_TLAST(hls_axis_tlast),
        .m_axis_TID()
    );

endmodule
