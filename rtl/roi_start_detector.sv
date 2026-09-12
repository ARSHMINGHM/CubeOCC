`timescale 1ns/1ps

// V1 Camera 1 ROI detector.
//
// This block is intentionally a single-pixel-per-clock, low-resource design.
// It finds the longest bright run on each DVP line, keeps the tallest nearby
// group of qualifying lines, then exports that group's axis-aligned bounds.
// Those bounds map directly to a Camera 2 sensor ROI: x, y, width, height.
module roi_start_detector #(
    parameter int X_BITS = 10,
    parameter int Y_BITS = 10,
    parameter int MAX_ROW_GAP = 2
) (
    input  logic              pclk,
    input  logic              rst_n,
    input  logic              vsync,       // 1 = blanking, 0 = active frame
    input  logic              href,        // 1 = active pixel
    input  logic [7:0]        pixel_data,
    input  logic [7:0]        bright_threshold,
    input  logic [X_BITS-1:0] min_line_run,
    input  logic [Y_BITS-1:0] min_roi_height,

    output logic              roi_valid,
    output logic              frame_done,
    output logic [X_BITS-1:0] roi_x,
    output logic [Y_BITS-1:0] roi_y,
    output logic [X_BITS-1:0] roi_width,
    output logic [Y_BITS-1:0] roi_height
);

    logic vsync_d;
    logic href_d;
    logic [X_BITS-1:0] x;
    logic [Y_BITS-1:0] y;

    logic [X_BITS-1:0] run_start;
    logic [X_BITS-1:0] run_length;
    logic [X_BITS-1:0] longest_start;
    logic [X_BITS-1:0] longest_length;

    logic              band_active;
    logic [Y_BITS-1:0] band_last_y;
    logic [X_BITS-1:0] band_left;
    logic [X_BITS-1:0] band_right;
    logic [Y_BITS-1:0] band_top;
    logic [Y_BITS-1:0] band_bottom;

    logic [Y_BITS-1:0] best_height;
    logic [X_BITS-1:0] best_left;
    logic [X_BITS-1:0] best_right;
    logic [Y_BITS-1:0] best_top;
    logic [Y_BITS-1:0] best_bottom;

    function automatic logic [Y_BITS-1:0] height_of(
        input logic [Y_BITS-1:0] top,
        input logic [Y_BITS-1:0] bottom
    );
        height_of = bottom - top + 1'b1;
    endfunction

    always_ff @(posedge pclk or negedge rst_n) begin
        if (!rst_n) begin
            vsync_d <= 1'b1;
            href_d <= 1'b0;
            x <= '0;
            y <= '0;
            run_start <= '0;
            run_length <= '0;
            longest_start <= '0;
            longest_length <= '0;
            band_active <= 1'b0;
            band_last_y <= '0;
            band_left <= '0;
            band_right <= '0;
            band_top <= '0;
            band_bottom <= '0;
            best_height <= '0;
            best_left <= '0;
            best_right <= '0;
            best_top <= '0;
            best_bottom <= '0;
            roi_valid <= 1'b0;
            frame_done <= 1'b0;
            roi_x <= '0;
            roi_y <= '0;
            roi_width <= '0;
            roi_height <= '0;
        end else begin
            vsync_d <= vsync;
            href_d <= href;
            frame_done <= 1'b0;

            // Start a new camera frame. The old result remains valid until a
            // new frame ends, which keeps the Camera 2 control stable.
            if (vsync_d && !vsync) begin
                x <= '0;
                y <= '0;
                run_start <= '0;
                run_length <= '0;
                longest_start <= '0;
                longest_length <= '0;
                band_active <= 1'b0;
                best_height <= '0;
            end

            if (!vsync && href) begin
                if (pixel_data >= bright_threshold) begin
                    if (run_length == '0) begin
                        run_start <= x;
                    end
                    run_length <= run_length + 1'b1;
                    if (run_length >= longest_length) begin
                        longest_length <= run_length + 1'b1;
                        longest_start <= (run_length == '0) ? x : run_start;
                    end
                end else begin
                    run_length <= '0;
                end
                x <= x + 1'b1;
            end

            // The first blanking clock after a line finalizes the line's
            // longest run. A short reflection becomes a short band and loses
            // to the tall screen band without a frame buffer.
            if (!vsync && href_d && !href) begin
                if (longest_length >= min_line_run) begin
                    if (!band_active || y - band_last_y > MAX_ROW_GAP + 1) begin
                        if (band_active && height_of(band_top, band_bottom) > best_height) begin
                            best_height <= height_of(band_top, band_bottom);
                            best_left <= band_left;
                            best_right <= band_right;
                            best_top <= band_top;
                            best_bottom <= band_bottom;
                        end
                        band_active <= 1'b1;
                        band_left <= longest_start;
                        band_right <= longest_start + longest_length - 1'b1;
                        band_top <= y;
                        band_bottom <= y;
                    end else begin
                        if (longest_start < band_left) band_left <= longest_start;
                        if (longest_start + longest_length - 1'b1 > band_right) band_right <= longest_start + longest_length - 1'b1;
                        band_bottom <= y;
                    end
                    band_last_y <= y;
                end else if (band_active && y - band_last_y > MAX_ROW_GAP) begin
                    if (height_of(band_top, band_bottom) > best_height) begin
                        best_height <= height_of(band_top, band_bottom);
                        best_left <= band_left;
                        best_right <= band_right;
                        best_top <= band_top;
                        best_bottom <= band_bottom;
                    end
                    band_active <= 1'b0;
                end

                x <= '0;
                y <= y + 1'b1;
                run_start <= '0;
                run_length <= '0;
                longest_start <= '0;
                longest_length <= '0;
            end

            // Latch the taller of the best completed band and current band.
            // This is one clock after the final active line, so no pixel is
            // dropped and the result is ready at end-of-frame.
            if (!vsync_d && vsync) begin
                frame_done <= 1'b1;
                if (band_active && height_of(band_top, band_bottom) >= best_height && height_of(band_top, band_bottom) >= min_roi_height) begin
                    roi_valid <= 1'b1;
                    roi_x <= band_left;
                    roi_y <= band_top;
                    roi_width <= band_right - band_left + 1'b1;
                    roi_height <= height_of(band_top, band_bottom);
                end else if (best_height >= min_roi_height) begin
                    roi_valid <= 1'b1;
                    roi_x <= best_left;
                    roi_y <= best_top;
                    roi_width <= best_right - best_left + 1'b1;
                    roi_height <= best_height;
                end else begin
                    roi_valid <= 1'b0;
                end
            end
        end
    end

endmodule
