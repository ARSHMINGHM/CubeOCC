`timescale 1ns/1ps

// Nearest-neighbor four-corner rectifier for the current 160x120 grayscale
// camera raster. A full input frame is buffered because output pixels require
// non-sequential source reads. The rectified output is a DVP-style stream.
module perspective_warp_160x120 #(
    parameter X_BITS = 10,
    parameter Y_BITS = 10,
    parameter FRAC_BITS = 16
)(
    input  logic              pclk,
    input  logic              rst_n,
    input  logic              in_vsync,
    input  logic              in_href,
    input  logic [7:0]        in_gray,
    input  logic              rectify_enable,
    input  logic [X_BITS-1:0] tl_x, tr_x, br_x, bl_x,
    input  logic [Y_BITS-1:0] tl_y, tr_y, br_y, bl_y,
    output logic              busy,
    output logic              out_vsync,
    output logic              out_href,
    output logic [7:0]        out_gray,
    output logic              out_frame_done
);
    localparam integer WIDTH = 160;
    localparam integer HEIGHT = 120;
    localparam integer PIXELS = WIDTH * HEIGHT;
    localparam signed [31:0] Q_ONE = 32'sd1 <<< FRAC_BITS;
    localparam signed [31:0] Q_HALF = 32'sd1 <<< (FRAC_BITS - 1);

    (* ram_style = "block" *) logic [7:0] frame_mem [0:PIXELS-1];

    typedef enum logic [1:0] {WAIT_FRAME, LINE_SETUP, WARP_LINE, LINE_GAP} state_t;
    state_t state;
    logic prev_vsync;
    logic [14:0] write_addr;
    logic [7:0] out_x;
    logic [6:0] out_y;

    logic signed [31:0] left_x_q, left_y_q, right_x_q, right_y_q;
    logic signed [31:0] left_dx_q, left_dy_q, right_dx_q, right_dy_q;
    logic signed [31:0] source_x_q, source_y_q, source_dx_q, source_dy_q;
    logic signed [31:0] rounded_x, rounded_y;
    logic [7:0] source_x;
    logic [6:0] source_y;
    logic [14:0] read_addr;

    always_ff @(posedge pclk) begin
        if (state == WAIT_FRAME && !in_vsync && in_href && write_addr < PIXELS)
            frame_mem[write_addr] <= in_gray;
    end

    always_ff @(posedge pclk) begin
        if (state == WARP_LINE)
            out_gray <= frame_mem[read_addr];
    end

    always_comb begin
        rounded_x = (source_x_q + Q_HALF) >>> FRAC_BITS;
        rounded_y = (source_y_q + Q_HALF) >>> FRAC_BITS;
        if (rounded_x < 0)
            source_x = 8'd0;
        else if (rounded_x > WIDTH - 1)
            source_x = WIDTH - 1;
        else
            source_x = rounded_x[7:0];
        if (rounded_y < 0)
            source_y = 7'd0;
        else if (rounded_y > HEIGHT - 1)
            source_y = HEIGHT - 1;
        else
            source_y = rounded_y[6:0];
        read_addr = ({{8{1'b0}}, source_y} << 7)
                  + ({{8{1'b0}}, source_y} << 5)
                  + {{7{1'b0}}, source_x};
    end

    always_ff @(posedge pclk or negedge rst_n) begin
        if (!rst_n) begin
            state <= WAIT_FRAME;
            prev_vsync <= 1'b1;
            write_addr <= 15'd0;
            out_x <= 8'd0;
            out_y <= 7'd0;
            busy <= 1'b0;
            out_vsync <= 1'b1;
            out_href <= 1'b0;
            out_frame_done <= 1'b0;
            left_x_q <= 0; left_y_q <= 0; right_x_q <= 0; right_y_q <= 0;
            left_dx_q <= 0; left_dy_q <= 0; right_dx_q <= 0; right_dy_q <= 0;
            source_x_q <= 0; source_y_q <= 0; source_dx_q <= 0; source_dy_q <= 0;
        end else begin
            prev_vsync <= in_vsync;
            out_frame_done <= 1'b0;

            if (state == WAIT_FRAME) begin
                out_vsync <= 1'b1;
                out_href <= 1'b0;
                busy <= 1'b0;
                if (prev_vsync && !in_vsync)
                    write_addr <= 15'd0;
                if (!in_vsync && in_href && write_addr < PIXELS)
                    write_addr <= write_addr + 1'b1;
                if (!prev_vsync && in_vsync && write_addr >= PIXELS && rectify_enable) begin
                    left_x_q <= $signed({1'b0, tl_x}) * Q_ONE;
                    left_y_q <= $signed({1'b0, tl_y}) * Q_ONE;
                    right_x_q <= $signed({1'b0, tr_x}) * Q_ONE;
                    right_y_q <= $signed({1'b0, tr_y}) * Q_ONE;
                    left_dx_q <= (($signed({1'b0, bl_x}) - $signed({1'b0, tl_x})) * Q_ONE) / (HEIGHT - 1);
                    left_dy_q <= (($signed({1'b0, bl_y}) - $signed({1'b0, tl_y})) * Q_ONE) / (HEIGHT - 1);
                    right_dx_q <= (($signed({1'b0, br_x}) - $signed({1'b0, tr_x})) * Q_ONE) / (HEIGHT - 1);
                    right_dy_q <= (($signed({1'b0, br_y}) - $signed({1'b0, tr_y})) * Q_ONE) / (HEIGHT - 1);
                    out_x <= 8'd0;
                    out_y <= 7'd0;
                    busy <= 1'b1;
                    out_vsync <= 1'b0;
                    state <= LINE_SETUP;
                end
            end else if (state == LINE_SETUP) begin
                source_x_q <= left_x_q;
                source_y_q <= left_y_q;
                source_dx_q <= (right_x_q - left_x_q) / (WIDTH - 1);
                source_dy_q <= (right_y_q - left_y_q) / (WIDTH - 1);
                out_x <= 8'd0;
                out_href <= 1'b0;
                state <= WARP_LINE;
            end else if (state == WARP_LINE) begin
                out_href <= 1'b1;
                if (out_x == WIDTH - 1) begin
                    state <= LINE_GAP;
                end else begin
                    out_x <= out_x + 1'b1;
                    source_x_q <= source_x_q + source_dx_q;
                    source_y_q <= source_y_q + source_dy_q;
                end
            end else begin
                out_href <= 1'b0;
                if (out_y == HEIGHT - 1) begin
                    out_vsync <= 1'b1;
                    out_frame_done <= 1'b1;
                    busy <= 1'b0;
                    state <= WAIT_FRAME;
                end else begin
                    out_y <= out_y + 1'b1;
                    left_x_q <= left_x_q + left_dx_q;
                    left_y_q <= left_y_q + left_dy_q;
                    right_x_q <= right_x_q + right_dx_q;
                    right_y_q <= right_y_q + right_dy_q;
                    state <= LINE_SETUP;
                end
            end
        end
    end
endmodule
