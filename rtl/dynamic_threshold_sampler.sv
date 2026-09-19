`timescale 1ns/1ps

module dynamic_threshold_sampler (
    input  logic       clk,
    input  logic       rst_n,

    input  logic       grid_pixel_valid,
    input  logic [7:0] grid_pixel_gray,
    input  logic [5:0] grid_cell,
    input  logic [2:0] grid_col,
    input  logic [2:0] grid_row,
    input  logic [9:0] grid_pixel_x,
    input  logic [9:0] grid_pixel_y,
    input  logic       grid_frame_done,

    output logic       m_axis_tvalid,
    input  logic       m_axis_tready,
    output logic [63:0] m_axis_tdata,
    output logic       m_axis_tlast
);
    logic [1:0] state;
    localparam STATE_IDLE       = 2'd0;
    localparam STATE_LEARNING   = 2'd1;
    localparam STATE_PROCESSING = 2'd2;

    logic [31:0] sum_acc [0:63];

    logic [31:0] corner_sum;
    logic [31:0] corner_count;
    logic [15:0] dynamic_thresh;

    logic [9:0] col_origin; 
    logic [9:0] row_origin; 
    logic [4:0] lx;
    logic [3:0] ly;
    logic [4:0] abs_dx;
    logic [3:0] abs_dy;
    logic [11:0] dist_sq;

    assign col_origin = grid_col * 10'd20;
    assign row_origin = grid_row * 10'd15;
    assign lx = (grid_pixel_x - col_origin) & 5'h1f; 
    assign ly = (grid_pixel_y - row_origin) & 4'h0f;
    assign abs_dx = (lx >= 5'd10) ? (lx - 5'd10) : (5'd10 - lx);
    assign abs_dy = (ly >= 4'd7)  ? (ly - 4'd7)  : (4'd7 - ly);
    assign dist_sq = (abs_dx * abs_dx) + (abs_dy * abs_dy);

    logic [31:0] limit;
    assign limit = dynamic_thresh * 81;

    logic [63:0] symbols_reg;
    logic        valid_out;

    // Check if current cell is one of the 4 corners (0, 7, 56, 63)
    logic is_corner;
    assign is_corner = (grid_cell == 6'd0 || grid_cell == 6'd7 || grid_cell == 6'd56 || grid_cell == 6'd63);

    integer i;
    always @(posedge clk) begin
        if (!rst_n) begin
            state <= STATE_IDLE;
            corner_sum <= 0;
            corner_count <= 0;
            dynamic_thresh <= 8'd128;
            valid_out <= 0;
            for (i=0; i<64; i=i+1) sum_acc[i] <= 32'd0;
        end else begin
            if (valid_out && m_axis_tready) valid_out <= 1'b0;

            if (grid_pixel_valid && state == STATE_IDLE) begin
                state <= STATE_LEARNING;
            end

            // LEARNING: Accumulate brightness ONLY for the 4 corner cells
            if (grid_pixel_valid && state == STATE_LEARNING && is_corner) begin
                corner_sum <= corner_sum + grid_pixel_gray;
                corner_count <= corner_count + 1;
            end

            if (grid_pixel_valid && dist_sq <= 25) begin
                sum_acc[grid_cell] <= sum_acc[grid_cell] + grid_pixel_gray;
            end

            if (grid_frame_done) begin
                if (state == STATE_LEARNING) begin
                    if (corner_count > 0) begin
                        dynamic_thresh <= (corner_sum / corner_count) >> 1;
                    end
                    state <= STATE_PROCESSING;
                end

                for (i=0; i<64; i=i+1) begin
                    symbols_reg[i] <= (sum_acc[i] > limit) ? 1'b1 : 1'b0;
                    sum_acc[i] <= 32'd0;
                end
                valid_out <= 1'b1;
            end
        end
    end

    assign m_axis_tvalid = valid_out;
    assign m_axis_tdata  = symbols_reg;
    assign m_axis_tlast  = 1'b1;
endmodule