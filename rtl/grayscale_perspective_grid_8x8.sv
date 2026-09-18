`timescale 1ns/1ps

// Frame-buffered nearest-neighbor quadrilateral rectifier and 8x8 grid mapper.
// The four corners are expressed in the incoming 160x120 sensor-ROI raster.
// Geometry uses a bilinear quadrilateral map, evaluated incrementally in Q16.
module grayscale_perspective_grid_8x8 #(
    parameter integer FRAME_WIDTH = 160,
    parameter integer FRAME_HEIGHT = 120,
    parameter integer X_BITS = 10,
    parameter integer Y_BITS = 10,
    parameter integer FRAC_BITS = 16
)(
    input  logic              pclk,
    input  logic              rst_n,
    input  logic              vsync,
    input  logic              href,
    input  logic [7:0]        pixel_gray,
    input  logic [X_BITS-1:0] tl_x, tl_y,
    input  logic [X_BITS-1:0] tr_x, tr_y,
    input  logic [X_BITS-1:0] br_x, br_y,
    input  logic [X_BITS-1:0] bl_x, bl_y,
    output logic              busy,
    output logic              out_valid,
    output logic [7:0]        out_gray,
    output logic [X_BITS-1:0] out_x,
    output logic [Y_BITS-1:0] out_y,
    output logic [2:0]        grid_col,
    output logic [2:0]        grid_row,
    output logic [5:0]        grid_cell,
    output logic              frame_done
);
    localparam integer FRAME_PIXELS = FRAME_WIDTH * FRAME_HEIGHT;
    localparam integer FP_BITS = X_BITS + FRAC_BITS + 2;
    localparam integer CELL_WIDTH = FRAME_WIDTH / 8;
    localparam integer CELL_HEIGHT = FRAME_HEIGHT / 8;

    (* ram_style = "block" *) logic [7:0] frame_mem [0:FRAME_PIXELS-1];
    typedef enum logic [2:0] {WAIT_FRAME, CAPTURE, PREP_FRAME, PREP_ROW, EMIT} state_t;
    state_t state;
    logic prev_vsync;
    logic prev_href;
    logic [X_BITS-1:0] cap_x;
    logic [Y_BITS-1:0] cap_y;
    logic [X_BITS-1:0] c_tl_x, c_tr_x, c_br_x, c_bl_x;
    logic [Y_BITS-1:0] c_tl_y, c_tr_y, c_br_y, c_bl_y;
    logic signed [FP_BITS-1:0] left_x_fp, left_y_fp, right_x_fp, right_y_fp;
    logic signed [FP_BITS-1:0] left_x_step, left_y_step, right_x_step, right_y_step;
    logic signed [FP_BITS-1:0] src_x_fp, src_y_fp, src_x_step, src_y_step;
    logic [X_BITS-1:0] emit_x;
    logic [Y_BITS-1:0] emit_y;
    integer signed delta_value;
    integer source_x;
    integer source_y;
    integer source_addr;

    function automatic integer clamp_x(input integer value);
        begin
            if (value < 0) clamp_x = 0;
            else if (value >= FRAME_WIDTH) clamp_x = FRAME_WIDTH - 1;
            else clamp_x = value;
        end
    endfunction

    function automatic integer clamp_y(input integer value);
        begin
            if (value < 0) clamp_y = 0;
            else if (value >= FRAME_HEIGHT) clamp_y = FRAME_HEIGHT - 1;
            else clamp_y = value;
        end
    endfunction

    always_comb begin
        source_x = clamp_x(src_x_fp >>> FRAC_BITS);
        source_y = clamp_y(src_y_fp >>> FRAC_BITS);
        source_addr = source_y * FRAME_WIDTH + source_x;
    end

    always_ff @(posedge pclk or negedge rst_n) begin
        if (!rst_n) begin
            state <= WAIT_FRAME; prev_vsync <= 1'b1; prev_href <= 1'b0; cap_x <= '0; cap_y <= '0;
            busy <= 1'b0; out_valid <= 1'b0; frame_done <= 1'b0;
            out_gray <= '0; out_x <= '0; out_y <= '0;
            grid_col <= '0; grid_row <= '0; grid_cell <= '0;
            emit_x <= '0; emit_y <= '0;
            left_x_fp <= '0; left_y_fp <= '0; right_x_fp <= '0; right_y_fp <= '0;
            left_x_step <= '0; left_y_step <= '0; right_x_step <= '0; right_y_step <= '0;
            src_x_fp <= '0; src_y_fp <= '0; src_x_step <= '0; src_y_step <= '0;
        end else begin
            prev_vsync <= vsync;
            prev_href <= href;
            out_valid <= 1'b0;
            frame_done <= 1'b0;

            case (state)
                WAIT_FRAME: begin
                    busy <= 1'b0;
                    if (prev_vsync && !vsync) begin
                        cap_x <= '0; cap_y <= '0; busy <= 1'b1;
                        c_tl_x <= tl_x; c_tl_y <= tl_y; c_tr_x <= tr_x; c_tr_y <= tr_y;
                        c_br_x <= br_x; c_br_y <= br_y; c_bl_x <= bl_x; c_bl_y <= bl_y;
                        state <= CAPTURE;
                    end
                end

                CAPTURE: begin
                    if (!vsync && href) begin
                        frame_mem[cap_y * FRAME_WIDTH + cap_x] <= pixel_gray;
                        if (cap_x == FRAME_WIDTH - 1) cap_x <= '0;
                        else cap_x <= cap_x + 1'b1;
                    end
                    if (!vsync && prev_href && !href && cap_y < FRAME_HEIGHT - 1)
                        cap_y <= cap_y + 1'b1;
                    if (!prev_vsync && vsync) state <= PREP_FRAME;
                end

                PREP_FRAME: begin
                    left_x_fp <= $signed({1'b0,c_tl_x}) <<< FRAC_BITS;
                    left_y_fp <= $signed({1'b0,c_tl_y}) <<< FRAC_BITS;
                    right_x_fp <= $signed({1'b0,c_tr_x}) <<< FRAC_BITS;
                    right_y_fp <= $signed({1'b0,c_tr_y}) <<< FRAC_BITS;
                    delta_value = $signed({1'b0,c_bl_x}) - $signed({1'b0,c_tl_x});
                    left_x_step <= (delta_value <<< FRAC_BITS) / (FRAME_HEIGHT - 1);
                    delta_value = $signed({1'b0,c_bl_y}) - $signed({1'b0,c_tl_y});
                    left_y_step <= (delta_value <<< FRAC_BITS) / (FRAME_HEIGHT - 1);
                    delta_value = $signed({1'b0,c_br_x}) - $signed({1'b0,c_tr_x});
                    right_x_step <= (delta_value <<< FRAC_BITS) / (FRAME_HEIGHT - 1);
                    delta_value = $signed({1'b0,c_br_y}) - $signed({1'b0,c_tr_y});
                    right_y_step <= (delta_value <<< FRAC_BITS) / (FRAME_HEIGHT - 1);
                    emit_x <= '0; emit_y <= '0;
                    state <= PREP_ROW;
                end

                PREP_ROW: begin
                    src_x_fp <= left_x_fp;
                    src_y_fp <= left_y_fp;
                    src_x_step <= (right_x_fp - left_x_fp) / (FRAME_WIDTH - 1);
                    src_y_step <= (right_y_fp - left_y_fp) / (FRAME_WIDTH - 1);
                    emit_x <= '0;
                    state <= EMIT;
                end

                EMIT: begin
                    out_valid <= 1'b1;
                    out_gray <= frame_mem[source_addr];
                    out_x <= emit_x;
                    out_y <= emit_y;
                    grid_col <= emit_x / CELL_WIDTH;
                    grid_row <= emit_y / CELL_HEIGHT;
                    grid_cell <= (emit_y / CELL_HEIGHT) * 8 + (emit_x / CELL_WIDTH);
                    if (emit_x == FRAME_WIDTH - 1) begin
                        if (emit_y == FRAME_HEIGHT - 1) begin
                            frame_done <= 1'b1; busy <= 1'b0; state <= WAIT_FRAME;
                        end else begin
                            emit_y <= emit_y + 1'b1;
                            left_x_fp <= left_x_fp + left_x_step;
                            left_y_fp <= left_y_fp + left_y_step;
                            right_x_fp <= right_x_fp + right_x_step;
                            right_y_fp <= right_y_fp + right_y_step;
                            state <= PREP_ROW;
                        end
                    end else begin
                        emit_x <= emit_x + 1'b1;
                        src_x_fp <= src_x_fp + src_x_step;
                        src_y_fp <= src_y_fp + src_y_step;
                    end
                end
                default: state <= WAIT_FRAME;
            endcase
        end
    end
endmodule
