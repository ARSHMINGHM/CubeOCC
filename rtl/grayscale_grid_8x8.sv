`timescale 1ns/1ps

// Streaming 8x8 grid mapper for a grayscale camera ROI.
// Camera 2 is expected to have already cropped the sensor output to frame_width
// by frame_height. No image buffer or divider is used: phase accumulators map
// every accepted pixel to floor(x*8/width), floor(y*8/height).
module grayscale_grid_8x8 #(
    parameter X_BITS = 10,
    parameter Y_BITS = 10
)(
    input  logic              pclk,
    input  logic              rst_n,
    input  logic              vsync,
    input  logic              href,
    input  logic [7:0]        pixel_gray,
    input  logic [X_BITS-1:0] frame_width,
    input  logic [Y_BITS-1:0] frame_height,
    output logic              grid_pixel_valid,
    output logic [7:0]        grid_pixel_gray,
    output logic [2:0]        grid_col,
    output logic [2:0]        grid_row,
    output logic [5:0]        grid_cell,
    output logic [X_BITS-1:0] pixel_x,
    output logic [Y_BITS-1:0] pixel_y,
    output logic              frame_done
);
    logic prev_vsync;
    logic prev_href;
    logic [X_BITS:0] col_phase;
    logic [Y_BITS:0] row_phase;
    logic [2:0] current_col;
    logic [2:0] current_row;
    logic [X_BITS-1:0] scan_x;
    logic [Y_BITS-1:0] scan_y;
    logic [X_BITS:0] col_phase_step;
    logic [Y_BITS:0] row_phase_step;

    always_comb begin
        col_phase_step = col_phase + 4'd8;
        row_phase_step = row_phase + 4'd8;
    end

    always_ff @(posedge pclk or negedge rst_n) begin
        if (!rst_n) begin
            prev_vsync      <= 1'b1;
            prev_href       <= 1'b0;
            col_phase       <= '0;
            row_phase       <= '0;
            current_col     <= 3'd0;
            current_row     <= 3'd0;
            scan_x          <= '0;
            scan_y          <= '0;
            pixel_x         <= '0;
            pixel_y         <= '0;
            grid_pixel_valid <= 1'b0;
            grid_pixel_gray <= '0;
            grid_col        <= 3'd0;
            grid_row        <= 3'd0;
            grid_cell       <= 6'd0;
            frame_done      <= 1'b0;
        end else begin
            prev_vsync       <= vsync;
            prev_href        <= href;
            grid_pixel_valid <= 1'b0;
            frame_done       <= 1'b0;

            if (prev_vsync && !vsync) begin
                col_phase   <= '0;
                row_phase   <= '0;
                current_col <= 3'd0;
                current_row <= 3'd0;
                scan_x      <= '0;
                scan_y      <= '0;
            end

            if (!vsync && href && frame_width != 0 && frame_height != 0) begin
                grid_pixel_valid <= 1'b1;
                grid_pixel_gray  <= pixel_gray;
                grid_col         <= current_col;
                grid_row         <= current_row;
                grid_cell        <= {current_row, current_col};
                pixel_x          <= scan_x;
                pixel_y          <= scan_y;

                if (scan_x + 1'b1 < frame_width) begin
                    scan_x <= scan_x + 1'b1;
                    if (col_phase_step >= frame_width && current_col != 3'd7) begin
                        col_phase   <= col_phase_step - frame_width;
                        current_col <= current_col + 1'b1;
                    end else begin
                        col_phase <= col_phase_step;
                    end
                end
            end

            if (!vsync && prev_href && !href) begin
                scan_x      <= '0;
                col_phase   <= '0;
                current_col <= 3'd0;
                if (scan_y + 1'b1 < frame_height) begin
                    scan_y <= scan_y + 1'b1;
                    if (row_phase_step >= frame_height && current_row != 3'd7) begin
                        row_phase   <= row_phase_step - frame_height;
                        current_row <= current_row + 1'b1;
                    end else begin
                        row_phase <= row_phase_step;
                    end
                end
            end

            if (!prev_vsync && vsync)
                frame_done <= 1'b1;
        end
    end
endmodule
