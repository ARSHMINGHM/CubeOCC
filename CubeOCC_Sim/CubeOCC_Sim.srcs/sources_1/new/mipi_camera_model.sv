`timescale 1ns/1ps

module mipi_camera_model
  import camera_regs_pkg::*;
#(
  parameter int  SENSOR_MAX_WIDTH  = 2592,
  parameter int  SENSOR_MAX_HEIGHT = 1944,
  parameter real BYTE_PERIOD_NS    = 2.5,   // Abstracted deserialized byte rate
  parameter int  LINE_GAP_BYTES    = 32,    // Inter-line packet gap (blanking)
  parameter int  FRAME_GAP_BYTES   = 128    // Inter-frame packet gap (blanking)
)(
  input  logic                  clk,
  input  logic                  rst_n,
  input  logic                  reg_wr_en,
  input  logic [15:0]           reg_addr,
  input  logic [15:0]           reg_wdata,
  input  logic                  reg_rd_en,
  input  logic [15:0]           reg_raddr,
  output logic [15:0]           reg_rdata,

  // ---- raw CSI-2-like byte-serial view ----
  output logic                  byte_clk,
  output logic                  byte_valid,
  output logic [7:0]            byte_data,
  output logic                  sop,
  output logic                  eop,
  output logic [7:0]            packet_di,

  // ---- DVP-shaped convenience view ----
  output logic                  frame_valid,
  output logic                  line_valid,
  output logic [7:0]            pixel_data,
  output logic                  sof
);

  localparam logic [7:0] DI_FRAME_START = 8'h00;
  localparam logic [7:0] DI_FRAME_END   = 8'h01;
  localparam logic [7:0] DI_RAW8        = 8'h2A;

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

  initial byte_clk = 1'b0;
  always #(BYTE_PERIOD_NS/2.0) byte_clk = ~byte_clk;

  initial begin
    byte_valid = 1'b0; byte_data = '0; sop = 1'b0; eop = 1'b0; packet_di = '0;
    frame_valid = 1'b0; line_valid = 1'b0; pixel_data = '0; sof = 1'b0;
    frame_active = 1'b0; line_active = 1'b0;
    wait (rst_n === 1'b1);
    forever begin
      if (stream_enable) begin
        drive_one_frame(roi_x_start, roi_y_start, roi_width, roi_height);
      end else begin
        @(posedge byte_clk);
      end
    end
  end

  task automatic send_short_packet(input logic [7:0] di, input logic [15:0] wc);
    begin
      sop = 1'b1; packet_di = di;
      byte_valid = 1'b1; byte_data = di;           @(posedge byte_clk);
      byte_data  = wc[7:0];                        @(posedge byte_clk);
      byte_data  = wc[15:8];                        @(posedge byte_clk);
      byte_data  = 8'h00; eop = 1'b1;               @(posedge byte_clk);
      byte_valid = 1'b0; sop = 1'b0; eop = 1'b0;
    end
  endtask

  task automatic send_long_packet_line(
    input int unsigned x0, input int unsigned row, input int unsigned w
  );
    int col;
    begin
      sop = 1'b1; packet_di = DI_RAW8;
      byte_valid = 1'b1;
      byte_data = DI_RAW8;                          @(posedge byte_clk);
      byte_data = w[7:0];                            @(posedge byte_clk);
      byte_data = w[15:8];                           @(posedge byte_clk);
      byte_data = 8'h00;                             @(posedge byte_clk);
      sop = 1'b0;

      line_active = 1'b1;
      for (col = 0; col < w; col++) begin
        byte_data  = test_pixel(row, x0 + col);
        pixel_data = byte_data;
        line_valid = 1'b1;
        @(posedge byte_clk);
      end
      line_valid = 1'b0;

      byte_data = 8'h00; @(posedge byte_clk); // checksum byte 0
      eop = 1'b1;
      byte_data = 8'h00; @(posedge byte_clk); // checksum byte 1
      byte_valid = 1'b0; eop = 1'b0;
      line_active = 1'b0;

      repeat (LINE_GAP_BYTES) @(posedge byte_clk);
    end
  endtask

  task automatic drive_one_frame(
    input int unsigned x0, input int unsigned y0,
    input int unsigned w,  input int unsigned h
  );
    int row;
    begin
      frame_active = 1'b1;
      frame_valid  = 1'b1;

      send_short_packet(DI_FRAME_START, 16'h0000);
      sof = 1'b1; @(posedge byte_clk); sof = 1'b0;

      for (row = 0; row < h; row++)
        send_long_packet_line(x0, y0 + row, w);

      send_short_packet(DI_FRAME_END, 16'h0000);
      repeat (FRAME_GAP_BYTES) @(posedge byte_clk);

      frame_active = 1'b0;
      frame_valid  = 1'b0;
    end
  endtask

endmodule : mipi_camera_model