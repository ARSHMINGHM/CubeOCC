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
    output logic       m_axis_tuser
);

    logic [7:0] axis_cam_tdata;
    logic       axis_cam_tvalid;
    logic       axis_cam_tready;
    logic       axis_cam_tlast;
    logic       axis_cam_tuser;

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
        .m_axis_TVALID(m_axis_tvalid),
        .m_axis_TREADY(m_axis_tready),
        .m_axis_TDATA(m_axis_tdata),
        .m_axis_TDEST(),
        .m_axis_TKEEP(),
        .m_axis_TSTRB(),
        .m_axis_TUSER(m_axis_tuser),
        .m_axis_TLAST(m_axis_tlast),
        .m_axis_TID()
    );

endmodule
