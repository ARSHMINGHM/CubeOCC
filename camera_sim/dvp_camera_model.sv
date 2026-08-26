`timescale 1ns/1ps

module dvp_camera_model
  import camera_regs_pkg::*;
#(
  parameter int  SENSOR_MAX_WIDTH  = 2592,
  parameter int  SENSOR_MAX_HEIGHT = 1944,
  parameter int  HBLANK            = 688,
  parameter real PCLK_PERIOD_NS    = 10.0,
  parameter int  VBLANK            = 10
)(
  input  logic                  clk,
  input  logic                  rst_n,
  input  logic                  reg_wr_en,
  input  logic [15:0]           reg_addr,
  input  logic [15:0]           reg_wdata,
  input  logic                  reg_rd_en,
  input  logic [15:0]           reg_raddr,
  output logic [15:0]           reg_rdata,

  output logic                  pclk,
  output logic                  vsync,
  output logic                  href,
  output logic [7:0]            pixel_data,
  output logic                  sof
);

  logic        stream_enable;
  logic [15:0] roi_x_start, roi_y_start, roi_width, roi_height;
  logic        frame_active, line_active;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      stream_enable <= 1'b0;
      roi_x_start   <= 16'd0;
      roi_y_start   <= 16'd0;
      roi_width     <= SENSOR_MAX_WIDTH[15:0];
      roi_height    <= SENSOR_MAX_HEIGHT[15:0];
    end else if (reg_wr_en) begin
      case (reg_addr)
        REG_STREAM_ENABLE: stream_enable <= reg_wdata[0];
        REG_ROI_HSTART:    roi_x_start   <= reg_wdata;
        REG_ROI_VSTART:    roi_y_start   <= reg_wdata;
        REG_ROI_HSIZE:     roi_width     <= reg_wdata;
        REG_ROI_VSIZE:      roi_height    <= reg_wdata;
        default: ;
      endcase
    end
  end

  always_comb begin
    reg_rdata = 16'h0000;
    if (reg_rd_en) begin
      case (reg_raddr)
        REG_STREAM_ENABLE: reg_rdata = {15'd0, stream_enable};
        REG_ROI_HSTART:    reg_rdata = roi_x_start;
        REG_ROI_VSTART:    reg_rdata = roi_y_start;
        REG_ROI_HSIZE:     reg_rdata = roi_width;
        REG_ROI_VSIZE:      reg_rdata = roi_height;
        default: reg_rdata = 16'hFFFF;
      endcase
    end
  end

  initial pclk = 1'b0;
  always #(PCLK_PERIOD_NS/2.0) pclk = ~pclk;

  initial begin
    vsync        = 1'b1; 
    href         = 1'b0;
    pixel_data   = '0;
    sof          = 1'b0;
    frame_active = 1'b0;
    line_active  = 1'b0;
    wait (rst_n === 1'b1);
    forever begin
      if (stream_enable) begin
        drive_one_frame(roi_x_start, roi_y_start, roi_width, roi_height);
      end else begin
        @(posedge pclk);
      end
    end
  end

  task automatic drive_one_frame(
    input int unsigned x0, input int unsigned y0,
    input int unsigned w,  input int unsigned h
  );
    int row, col;
    begin
      // Drive DVP outputs on negedge pclk so the DUT never samples a
      // blocking-assign change in the same time step as posedge pclk.
      frame_active = 1'b1;
      @(negedge pclk);
      vsync = 1'b0;

      sof = 1'b1;
      @(negedge pclk);
      sof = 1'b0;

      for (row = 0; row < h; row++) begin
        line_active = 1'b1;
        href = 1'b0;
        repeat (HBLANK) @(negedge pclk);
        href = 1'b1;
        for (col = 0; col < w; col++) begin
          pixel_data = test_pixel(y0 + row, x0 + col);
          @(negedge pclk);
        end
        href = 1'b0;
        line_active = 1'b0;
      end

      @(negedge pclk);
      vsync = 1'b1;

      repeat (VBLANK) begin
        repeat (w + HBLANK) @(posedge pclk);
      end

      frame_active = 1'b0;
    end
  endtask

endmodule : dvp_camera_model