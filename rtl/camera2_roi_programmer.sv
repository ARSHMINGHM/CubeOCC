`timescale 1ns/1ps

// Converts four Camera 2 coordinate-space corners into an axis-aligned sensor
// window and programs the generic Camera 2 ROI register interface.
// A physical two-camera system must map Camera 1 coordinates into Camera 2
// coordinates before asserting roi_valid.
module camera2_roi_programmer #(
    parameter COORD_BITS = 12
)(
    input  logic                  clk,
    input  logic                  rst_n,
    input  logic                  roi_valid,
    input  logic [COORD_BITS-1:0] tl_x, tl_y,
    input  logic [COORD_BITS-1:0] tr_x, tr_y,
    input  logic [COORD_BITS-1:0] br_x, br_y,
    input  logic [COORD_BITS-1:0] bl_x, bl_y,
    input  logic                  i2c_busy,
    input  logic                  i2c_done,
    input  logic                  i2c_ack_error,
    output logic                  i2c_start,
    output logic [15:0]           i2c_reg_addr,
    output logic [15:0]           i2c_reg_data,
    output logic                  busy,
    output logic                  stream_ready,
    output logic                  error,
    output logic [COORD_BITS-1:0] roi_x,
    output logic [COORD_BITS-1:0] roi_y,
    output logic [COORD_BITS-1:0] roi_width,
    output logic [COORD_BITS-1:0] roi_height
);
    typedef enum logic [2:0] {IDLE, ISSUE, WAIT_DONE, FINISH} state_t;
    state_t state;
    logic [2:0] write_index;
    logic [COORD_BITS-1:0] min_x, max_x, min_y, max_y;

    function automatic [COORD_BITS-1:0] min4(
        input [COORD_BITS-1:0] a, b, c, d);
        reg [COORD_BITS-1:0] ab, cd;
        begin ab = a < b ? a : b; cd = c < d ? c : d; min4 = ab < cd ? ab : cd; end
    endfunction

    function automatic [COORD_BITS-1:0] max4(
        input [COORD_BITS-1:0] a, b, c, d);
        reg [COORD_BITS-1:0] ab, cd;
        begin ab = a > b ? a : b; cd = c > d ? c : d; max4 = ab > cd ? ab : cd; end
    endfunction

    always_comb begin
        min_x = min4(tl_x, tr_x, br_x, bl_x);
        max_x = max4(tl_x, tr_x, br_x, bl_x);
        min_y = min4(tl_y, tr_y, br_y, bl_y);
        max_y = max4(tl_y, tr_y, br_y, bl_y);
        i2c_reg_addr = 16'h3008;
        i2c_reg_data = 16'h0001;
        case (write_index)
            3'd0: begin i2c_reg_addr = 16'h3800; i2c_reg_data = {{(16-COORD_BITS){1'b0}}, roi_x}; end
            3'd1: begin i2c_reg_addr = 16'h3802; i2c_reg_data = {{(16-COORD_BITS){1'b0}}, roi_y}; end
            3'd2: begin i2c_reg_addr = 16'h3804; i2c_reg_data = {{(16-COORD_BITS){1'b0}}, roi_width}; end
            3'd3: begin i2c_reg_addr = 16'h3806; i2c_reg_data = {{(16-COORD_BITS){1'b0}}, roi_height}; end
            default: begin i2c_reg_addr = 16'h3008; i2c_reg_data = 16'h0001; end
        endcase
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE; write_index <= 3'd0; i2c_start <= 1'b0;
            busy <= 1'b0; stream_ready <= 1'b0; error <= 1'b0;
            roi_x <= '0; roi_y <= '0; roi_width <= '0; roi_height <= '0;
        end else begin
            i2c_start <= 1'b0;
            case (state)
                IDLE: begin
                    busy <= 1'b0;
                    if (roi_valid) begin
                        roi_x <= min_x; roi_y <= min_y;
                        roi_width <= max_x - min_x + 1'b1;
                        roi_height <= max_y - min_y + 1'b1;
                        write_index <= 3'd0; busy <= 1'b1;
                        stream_ready <= 1'b0; error <= 1'b0; state <= ISSUE;
                    end
                end
                ISSUE: if (!i2c_busy) begin i2c_start <= 1'b1; state <= WAIT_DONE; end
                WAIT_DONE: if (i2c_done) begin
                    if (i2c_ack_error) begin error <= 1'b1; busy <= 1'b0; state <= IDLE; end
                    else if (write_index == 3'd4) state <= FINISH;
                    else begin write_index <= write_index + 1'b1; state <= ISSUE; end
                end
                FINISH: begin busy <= 1'b0; stream_ready <= 1'b1; state <= IDLE; end
                default: state <= IDLE;
            endcase
        end
    end
endmodule
