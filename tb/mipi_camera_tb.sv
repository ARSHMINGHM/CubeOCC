`timescale 1ns/1ps

module mipi_camera_tb;
  import camera_regs_pkg::*;

  logic clk;
  logic rst_n;
  logic reg_wr_en;
  logic [15:0] reg_addr;
  logic [15:0] reg_wdata;
  logic reg_rd_en;
  logic [15:0] reg_raddr;
  logic [15:0] reg_rdata;

  logic byte_clk, byte_valid, sop, eop;
  logic [7:0] byte_data, packet_di;
  logic frame_valid, line_valid, sof;
  logic [7:0] pixel_data;

  mipi_camera_model dut (
    .clk(clk), .rst_n(rst_n),
    .reg_wr_en(reg_wr_en), .reg_addr(reg_addr), .reg_wdata(reg_wdata),
    .reg_rd_en(reg_rd_en), .reg_raddr(reg_raddr), .reg_rdata(reg_rdata),
    .byte_clk(byte_clk), .byte_valid(byte_valid), .byte_data(byte_data),
    .sop(sop), .eop(eop), .packet_di(packet_di),
    .frame_valid(frame_valid), .line_valid(line_valid),
    .pixel_data(pixel_data), .sof(sof)
  );

  initial clk = 1'b0;
  always #5 clk = ~clk; // 100 MHz register-bus clock

  task automatic reg_write(input camera_reg_addr_e a, input [15:0] d);
    begin
      @(posedge clk);
      reg_wr_en = 1'b1; reg_addr = a; reg_wdata = d;
      @(posedge clk);
      reg_wr_en = 1'b0;
    end
  endtask

  task automatic program_roi(input int x0, input int y0, input int w, input int h);
    begin
      reg_write(REG_ROI_HSTART, x0[15:0]);
      reg_write(REG_ROI_VSTART, y0[15:0]);
      reg_write(REG_ROI_HSIZE,  w[15:0]);
      reg_write(REG_ROI_VSIZE,   h[15:0]);
    end
  endtask

  task automatic run_case(
    input string name,
    input int x0, input int y0, input int w, input int h
  );
    int local_pix;
    real t0, t1, frame_time_ns;
    begin
      $display("------------------------------------------------------------------");
      $display(" Case: %s", name);
      $display(" Window: (%0d,%0d) - (%0d,%0d) = %0dx%0d", x0, y0, x0+w-1, y0+h-1, w, h);
      $display("------------------------------------------------------------------");

      reg_write(REG_STREAM_ENABLE, 16'h0000);
      program_roi(x0, y0, w, h);

      @(posedge clk);
      reg_write(REG_STREAM_ENABLE, 16'h0001);

      @(posedge sof);
      t0 = $realtime;
      
      local_pix = 0;
      fork : count_pixels
        begin
          forever begin
            @(posedge byte_clk);
            if (line_valid) local_pix++;
          end
        end
      join_none
      
      @(posedge sof);
      t1 = $realtime;
      
      disable count_pixels;

      reg_write(REG_STREAM_ENABLE, 16'h0000);

      frame_time_ns = t1 - t0;
      $display(" Measured frame time: %.1f ns (%.1f us)", frame_time_ns, frame_time_ns/1000.0);
      $display(" Measured FPS: ~%0d", (frame_time_ns > 0.0) ? int'(1.0e9 / frame_time_ns) : 0);
      $display(" Active pixels counted: %0d (expected %0d)", local_pix, w*h);

      if (local_pix == w*h)
        $display(" Result: PASS");
      else
        $display(" Result: FAIL (pixel count mismatch)");
      $display("");
    end
  endtask

  initial begin
    reg_wr_en = 0; reg_addr = 0; reg_wdata = 0;
    reg_rd_en = 0; reg_raddr = 0;
    rst_n = 0;
    repeat (5) @(posedge clk);
    rst_n = 1;

    $display("================================================================");
    $display(" OV5640 MIPI Camera Model - Register-Driven ROI Regression");
    $display("================================================================");

    run_case("A: Full res (2592x1944)",   0,   0, 2592, 1944);
    run_case("B: Half-height (2592x972)", 0, 486, 2592,  972);
    run_case("C: Tall-narrow (128x720)",  0,   0,  128,  720);

    $display("================================================================");
    $display(" OVERALL: DONE");
    $display("================================================================");
    $finish;
  end

endmodule : mipi_camera_tb