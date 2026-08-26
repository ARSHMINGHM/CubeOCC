`timescale 1ns/1ps

// Verifies the DVP camera model streams a loaded image file correctly:
// every AXIS pixel must match the .mem contents at the ROI coordinate.
module image_file_tb;
  import camera_regs_pkg::*;

  localparam int IMG_W = 128;
  localparam int IMG_H = 720;

  logic clk, rst_n;
  logic reg_wr_en;
  logic [15:0] reg_addr, reg_wdata;
  logic reg_rd_en = 0;
  logic [15:0] reg_raddr = 0;
  logic [15:0] reg_rdata;
  logic pclk, vsync, href, sof;
  logic [7:0] pixel_data;
  logic [7:0] axis_tdata;
  logic axis_tvalid, axis_tready, axis_tlast, axis_tuser;

  // Golden copy of the same image file
  logic [7:0] expect_mem [0:IMG_W*IMG_H-1];
  initial $readmemh("image_test.mem", expect_mem);

  dvp_camera_model #(
    .IMAGE_FILE  ("image_test.mem"),
    .IMAGE_WIDTH (IMG_W),
    .IMAGE_HEIGHT(IMG_H)
  ) cam (
    .clk(clk), .rst_n(rst_n),
    .reg_wr_en(reg_wr_en), .reg_addr(reg_addr), .reg_wdata(reg_wdata),
    .reg_rd_en(reg_rd_en), .reg_raddr(reg_raddr), .reg_rdata(reg_rdata),
    .pclk(pclk), .vsync(vsync), .href(href), .pixel_data(pixel_data), .sof(sof)
  );

  dvp_to_axis bridge (
    .pclk(pclk), .rst_n(rst_n),
    .vsync(vsync), .href(href), .pixel_data(pixel_data),
    .m_axis_tdata(axis_tdata), .m_axis_tvalid(axis_tvalid),
    .m_axis_tready(axis_tready), .m_axis_tlast(axis_tlast), .m_axis_tuser(axis_tuser)
  );

  initial clk = 0;
  always #5 clk = ~clk;

  int pix_count = 0, line_count = 0, errors = 0;
  int row = 0, col = 0;
  logic [7:0] exp;

  always @(posedge pclk) begin
    if (axis_tvalid && axis_tready) begin
      if (axis_tuser) begin
        row = 0; col = 0;
      end
      exp = expect_mem[row*IMG_W + col];
      if (axis_tdata !== exp) begin
        errors++;
        if (errors <= 10)
          $display(" MISMATCH @(%0d,%0d): got %02x expected %02x", row, col, axis_tdata, exp);
      end
      pix_count++;
      col++;
      if (axis_tlast) begin
        line_count++;
        col = 0;
        row++;
      end
    end
  end

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

  initial begin
    rst_n = 0;
    reg_wr_en = 0;
    reg_addr = 0;
    reg_wdata = 0;
    axis_tready = 1'b1;
    repeat (10) @(posedge clk);
    rst_n = 1;

    $display(" Image file streaming test (128x720 via IMAGE_FILE)");
    reg_write(REG_STREAM_ENABLE, 16'h0000);
    reg_write(REG_ROI_HSTART, 16'h0000);
    reg_write(REG_ROI_VSTART, 16'h0000);
    reg_write(REG_ROI_HSIZE, IMG_W[15:0]);
    reg_write(REG_ROI_VSIZE, IMG_H[15:0]);
    reg_write(REG_STREAM_ENABLE, 16'h0001);

    fork
      begin : timeout_block
        #100000000;
        $display(" Result: FAIL (timeout)");
        $finish;
      end
      begin : wait_frames
        @(posedge axis_tuser);
        pix_count = 0; line_count = 0; errors = 0; row = 0; col = 0;
        @(posedge axis_tuser);
        $display(" Frame 2: pixels=%0d lines=%0d mismatched=%0d", pix_count, line_count, errors);
        if (pix_count == IMG_W*IMG_H && line_count == IMG_H && errors == 0) begin
          $display(" Result: IMAGE FILE TEST PASS");
        end else begin
          $display(" Result: IMAGE FILE TEST FAIL");
        end
        $finish;
      end
    join_any
  end

endmodule : image_file_tb
