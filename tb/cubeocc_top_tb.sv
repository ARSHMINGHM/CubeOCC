`timescale 1ns/1ps

module cubeocc_top_tb;
  import camera_regs_pkg::*;

  localparam int ROI_WIDTH  = 128;
  localparam int ROI_HEIGHT = 720;
  localparam int ROI_PIXELS = ROI_WIDTH * ROI_HEIGHT;

  logic clk;
  logic rst_n;

  logic reg_wr_en;
  logic [15:0] reg_addr;
  logic [15:0] reg_wdata;
  logic reg_rd_en;
  logic [15:0] reg_raddr;
  logic [15:0] reg_rdata;

  logic pclk;
  logic vsync;
  logic href;
  logic sof;
  logic [7:0] pixel_data;

  logic [7:0] axis_tdata;
  logic axis_tvalid;
  logic axis_tready;
  logic axis_tlast;
  logic axis_tuser;

  dvp_camera_model cam (
    .clk(clk),
    .rst_n(rst_n),
    .reg_wr_en(reg_wr_en),
    .reg_addr(reg_addr),
    .reg_wdata(reg_wdata),
    .reg_rd_en(reg_rd_en),
    .reg_raddr(reg_raddr),
    .reg_rdata(reg_rdata),
    .pclk(pclk),
    .vsync(vsync),
    .href(href),
    .pixel_data(pixel_data),
    .sof(sof)
  );

  cubeocc_top dut (
    .pclk(pclk),
    .rst_n(rst_n),
    .cam_vsync(vsync),
    .cam_href(href),
    .cam_pixel_data(pixel_data),
    .m_axis_tdata(axis_tdata),
    .m_axis_tvalid(axis_tvalid),
    .m_axis_tready(axis_tready),
    .m_axis_tlast(axis_tlast),
    .m_axis_tuser(axis_tuser)
  );

  initial clk = 1'b0;
  always #5 clk = ~clk;

  task automatic reg_write(input camera_reg_addr_e a, input [15:0] d);
    begin
      @(posedge clk);
      reg_wr_en = 1'b1;
      reg_addr = a;
      reg_wdata = d;
      @(posedge clk);
      reg_wr_en = 1'b0;
    end
  endtask

  int axis_pix_count;
  int axis_line_count;

  always @(posedge pclk) begin
    if (axis_tvalid && axis_tready) begin
      axis_pix_count <= axis_pix_count + 1;
      if (axis_tlast) begin
        axis_line_count <= axis_line_count + 1;
      end
    end
  end

  initial begin
    reg_wr_en = 1'b0;
    reg_addr = 16'd0;
    reg_wdata = 16'd0;
    reg_rd_en = 1'b0;
    reg_raddr = 16'd0;
    rst_n = 1'b0;
    axis_tready = 1'b1;
    axis_pix_count = 0;
    axis_line_count = 0;

    repeat (10) @(posedge clk);
    rst_n = 1'b1;

    $display("================================================================");
    $display(" CubeOCC top-level DVP camera to HLS/AXIS integration test");
    $display("================================================================");

    reg_write(REG_STREAM_ENABLE, 16'h0000);
    reg_write(REG_ROI_HSTART, 16'h0000);
    reg_write(REG_ROI_VSTART, 16'h0000);
    reg_write(REG_ROI_HSIZE, ROI_WIDTH[15:0]);
    reg_write(REG_ROI_VSIZE, ROI_HEIGHT[15:0]);
    reg_write(REG_STREAM_ENABLE, 16'h0001);

    fork
      begin : timeout_block
        #50000000;
        $display(" Result: FAIL (timeout waiting for cubeocc_top output frame)");
        $finish;
      end
      begin : wait_frames
        @(posedge axis_tuser);
        axis_pix_count = 0;
        axis_line_count = 0;
        @(posedge axis_tuser);
        $display(" Output pixels: %0d (expected %0d)", axis_pix_count, ROI_PIXELS);
        $display(" Output lines:  %0d (expected %0d)", axis_line_count, ROI_HEIGHT);

        if (axis_pix_count == ROI_PIXELS && axis_line_count == ROI_HEIGHT) begin
          $display(" Result: CUBEOCC TOP PASS");
        end else begin
          $display(" Result: CUBEOCC TOP FAIL");
        end
        $finish;
      end
    join_any
  end

endmodule : cubeocc_top_tb
