`timescale 1ns/1ps

module i2c_cam_tb;
  import camera_regs_pkg::*;

  logic clk;
  logic rst_n;

  // I2C Master (DUT) signals
  logic        start;
  logic [15:0] reg_addr;
  logic [15:0] reg_data;
  logic        busy;
  logic        done;
  logic        ack_error;
  
  // I2C physical wires (sda is now a simple logic, no inout/pullup)
  logic        scl;
  wire         sda; // ??? ?? ????? ???
  pullup(sda);     // ??? ?? ?? ????? ??
  // Camera Model signals
  logic        reg_wr_en;
  logic [15:0] cam_reg_addr;
  logic [15:0] cam_reg_wdata;
  logic        reg_rd_en = 0;
  logic [15:0] reg_raddr = 0;
  logic [15:0] reg_rdata;

  logic        pclk, vsync, href, sof;
  logic [7:0]  pixel_data;

  i2c_master dut_master (
    .clk(clk), .rst_n(rst_n),
    .start(start), .reg_addr(reg_addr), .reg_data(reg_data),
    .busy(busy), .done(done), .ack_error(ack_error),
    .scl(scl), .sda(sda)
  );

  // 2. Instantiate the Camera Model
  dvp_camera_model cam (
    .clk(clk), .rst_n(rst_n),
    .reg_wr_en(reg_wr_en), .reg_addr(cam_reg_addr), .reg_wdata(cam_reg_wdata),
    .reg_rd_en(reg_rd_en), .reg_raddr(reg_raddr), .reg_rdata(reg_rdata),
    .pclk(pclk), .vsync(vsync), .href(href), .pixel_data(pixel_data), .sof(sof)
  );

  i2c_camera_slave_model cam_i2c_slave (
    .rst_n(rst_n),
    .scl(scl),
    .sda(sda),
    .reg_wr_en(reg_wr_en),
    .reg_addr(cam_reg_addr),
    .reg_wdata(cam_reg_wdata)
  );

  initial clk = 1'b0;
  always #5 clk = ~clk; 

  task automatic i2c_write(input [15:0] addr, input [15:0] data);
    begin
      @(posedge clk);
      reg_addr <= addr;
      reg_data <= data;
      start <= 1'b1;
      @(posedge clk);
      start <= 1'b0;
      wait (done == 1'b1);
      if (ack_error) begin
        $display(" I2C NACK ERROR: addr=0x%04X data=0x%04X", addr, data);
        $finish;
      end
      @(posedge clk);
    end
  endtask

  // Pixel counter (Fixed Race Condition)
  logic        count_en = 0;
  int local_pix;
  always @(posedge pclk) begin
    if (count_en && href) local_pix <= local_pix + 1;
  end

  initial begin
    rst_n = 0;
    start = 0;
    reg_addr = 0;
    reg_data = 0;
    local_pix = 0;
    count_en = 0;
    repeat (10) @(posedge clk);
    rst_n = 1;

    $display("================================================================");
    $display(" FPGA RTL to Camera Model Integration Test");
    $display("================================================================");

    $display(" FPGA -> I2C -> Writing ROI HSTART (0x3800)...");
    i2c_write(16'h3800, 16'h0000);
    $display(" FPGA -> I2C -> Writing ROI VSTART (0x3802)...");
    i2c_write(16'h3802, 16'h0000);
    $display(" FPGA -> I2C -> Writing ROI WIDTH (0x3804) to 128...");
    i2c_write(16'h3804, 16'h0080); 
    $display(" FPGA -> I2C -> Writing ROI HEIGHT (0x3806) to 720...");
    i2c_write(16'h3806, 16'h02D0); 
    $display(" FPGA -> I2C -> Enabling Stream (0x3008)...");
    i2c_write(16'h3008, 16'h0001);

    $display(" Waiting for camera to stream the ROI frame...");
    
    fork
      begin : timeout_block
        #50000000; // 50 ms timeout
        $display(" Result: INTEGRATION FAIL (Timeout waiting for SOF)");
        $finish;
      end
      begin : wait_sof
        @(posedge sof);
        $display(" Frame 1 started. Waiting for Frame 2...");
        count_en = 1;
        local_pix = 0;
        @(posedge sof); 
        count_en = 0;
        $display(" Frame 2 received.");
        $display(" Active pixels counted: %0d (expected %0d)", local_pix, 128 * 720);
        if (local_pix == 128 * 720)
          $display(" Result: INTEGRATION PASS");
        else
          $display(" Result: INTEGRATION FAIL (Pixel count mismatch)");
        $finish;
      end
    join_any
  end

endmodule : i2c_cam_tb
