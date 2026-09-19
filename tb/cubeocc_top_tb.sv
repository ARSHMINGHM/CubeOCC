`timescale 1ns/1ps

module cubeocc_top_tb;
  import camera_regs_pkg::*;

  localparam int ROI_WIDTH  = 160;
  localparam int ROI_HEIGHT = 120;

  logic clk, rst_n;
  logic reg_wr_en;
  logic [15:0] reg_addr, reg_wdata;
  logic reg_rd_en;
  logic [15:0] reg_raddr, reg_rdata;

  logic pclk, vsync, href, sof;
  logic [7:0] pixel_data;
  logic       symbols_valid;
  logic [63:0] symbols_data;
  logic       roi_valid;
  logic       roi_tracking_active;
  logic [9:0] roi_x, roi_y, roi_width, roi_height;
  logic [9:0] roi_tl_x, roi_tl_y, roi_tr_x, roi_tr_y, roi_br_x, roi_br_y, roi_bl_x, roi_bl_y;

  dvp_camera_model cam (
    .clk(clk), .rst_n(rst_n),
    .reg_wr_en(reg_wr_en), .reg_addr(reg_addr), .reg_wdata(reg_wdata),
    .reg_rd_en(reg_rd_en), .reg_raddr(reg_raddr), .reg_rdata(reg_rdata),
    .pclk(pclk), .vsync(vsync), .href(href), .pixel_data(pixel_data), .sof(sof)
  );

  cubeocc_top dut (
    .pclk(pclk), .rst_n(rst_n),
    .cam_vsync(vsync), .cam_href(href), .cam_pixel_data(pixel_data),
    .roi_valid(roi_valid), .roi_tracking_active(roi_tracking_active),
    .roi_x(roi_x), .roi_y(roi_y), .roi_width(roi_width), .roi_height(roi_height),
    .roi_tl_x(roi_tl_x), .roi_tl_y(roi_tl_y), .roi_tr_x(roi_tr_x), .roi_tr_y(roi_tr_y),
    .roi_br_x(roi_br_x), .roi_br_y(roi_br_y), .roi_bl_x(roi_bl_x), .roi_bl_y(roi_bl_y),
    .symbols_valid(symbols_valid), .symbols_data(symbols_data)
  );

  initial clk = 1'b0;
  always #5 clk = ~clk;

  task automatic reg_write(input camera_reg_addr_e a, input [15:0] d);
    begin
      @(posedge clk);
      reg_wr_en = 1'b1; reg_addr = a; reg_wdata = d;
      @(posedge clk);
      reg_wr_en = 1'b0;
    end
  endtask

  int frame_count;

  always @(posedge pclk) begin
    if (symbols_valid) begin
      $display("--------------------------------------------------");
      $display(" Frame %0d Grid Symbols: %b", frame_count, symbols_data);
      frame_count <= frame_count + 1;
    end
  end

  initial begin
    rst_n = 0;
    reg_wr_en = 0; reg_addr = 0; reg_wdata = 0;
    reg_rd_en = 0; reg_raddr = 0;
    frame_count = 0;

    repeat (10) @(posedge clk);
    rst_n = 1;

    $display("================================================================");
    $display(" CubeOCC Dynamic Threshold Test (160x120 Math Pattern)");
    $display("================================================================");

    reg_write(REG_STREAM_ENABLE, 16'h0000);
    reg_write(REG_ROI_HSTART, 16'd0);
    reg_write(REG_ROI_VSTART, 16'd0);
    reg_write(REG_ROI_HSIZE, ROI_WIDTH[15:0]);
    reg_write(REG_ROI_VSIZE, ROI_HEIGHT[15:0]);
    reg_write(REG_STREAM_ENABLE, 16'h0001);
    repeat (500000) @(posedge pclk);

    if (frame_count > 0) begin
      $display(" Result: PIPELINE PASS (Processed %0d frames)", frame_count);
    end else begin
      $display(" Result: PIPELINE FAIL (No frames processed)");
    end

    $display("================================================================");
    $finish;
  end

endmodule : cubeocc_top_tb