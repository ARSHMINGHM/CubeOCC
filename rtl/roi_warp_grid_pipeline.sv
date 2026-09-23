`timescale 1ns/1ps

// Direct Camera 1 pipeline: ROI detection, four-corner rectification, and
// grayscale 8x8 mapping run in one FPGA design. The one-cycle camera delay
// lets roi_start_detector publish its new corners before the warp sees the
// end-of-frame edge and latches them.
module roi_warp_grid_pipeline #(
    parameter X_BITS = 10,
    parameter Y_BITS = 10
)(
    input  logic              pclk,
    input  logic              rst_n,
    input  logic              cam_vsync,
    input  logic              cam_href,
    input  logic [7:0]        cam_gray,
    input  logic [7:0]        bright_threshold,
    input  logic [X_BITS-1:0] min_line_run,
    input  logic [Y_BITS-1:0] min_roi_height,
    input  logic [31:0]       full_off_max_pixels,
    output logic              roi_valid,
    output logic              tracking_active,
    output logic              detector_frame_done,
    output logic [X_BITS-1:0] roi_x,
    output logic [Y_BITS-1:0] roi_y,
    output logic [X_BITS-1:0] roi_width,
    output logic [Y_BITS-1:0] roi_height,
    output logic [X_BITS-1:0] roi_tl_x, roi_tr_x, roi_br_x, roi_bl_x,
    output logic [Y_BITS-1:0] roi_tl_y, roi_tr_y, roi_br_y, roi_bl_y,
    output logic              warp_busy,
    output logic              warp_vsync,
    output logic              warp_href,
    output logic [7:0]        warp_gray,
    output logic              warp_frame_done,
    output logic              grid_pixel_valid,
    output logic [7:0]        grid_pixel_gray,
    output logic [2:0]        grid_col,
    output logic [2:0]        grid_row,
    output logic [5:0]        grid_cell,
    output logic [X_BITS-1:0] grid_pixel_x,
    output logic [Y_BITS-1:0] grid_pixel_y,
    output logic              grid_frame_done,
    output logic              guard_transfer_active,
    output logic              guard_frame_checked,
    output logic              guard_start_learned,
    output logic              guard_data_valid,
    output logic              guard_frame_discarded,
    output logic              guard_end_detected,
    output logic              guard_frame_ignored,
    output logic [2:0]        guard_discard_reason,
    output logic [7:0]        guard_learned_white,
    output logic [7:0]        guard_white_threshold,
    output logic [7:0]        guard_tl_average,
    output logic [7:0]        guard_tr_average,
    output logic [7:0]        guard_bl_average,
    output logic [7:0]        guard_br_average
);
    logic delayed_vsync, delayed_href;
    logic [7:0] delayed_gray;

    always_ff @(posedge pclk or negedge rst_n) begin
        if (!rst_n) begin
            delayed_vsync <= 1'b1;
            delayed_href <= 1'b0;
            delayed_gray <= 8'd0;
        end else begin
            delayed_vsync <= cam_vsync;
            delayed_href <= cam_href;
            delayed_gray <= cam_gray;
        end
    end

    roi_start_detector #(.X_BITS(X_BITS), .Y_BITS(Y_BITS), .MAX_ROW_GAP(2)) detector (
        .pclk, .rst_n, .vsync(cam_vsync), .href(cam_href), .pixel_data(cam_gray),
        .bright_threshold, .min_line_run, .min_roi_height, .full_off_max_pixels,
        .roi_valid, .tracking_active, .frame_done(detector_frame_done),
        .roi_x, .roi_y, .roi_width, .roi_height,
        .roi_tl_x, .roi_tl_y, .roi_tr_x, .roi_tr_y,
        .roi_br_x, .roi_br_y, .roi_bl_x, .roi_bl_y
    );

    projective_warp_160x120 #(.X_BITS(X_BITS), .Y_BITS(Y_BITS)) warp (
        .pclk, .rst_n,
        .in_vsync(delayed_vsync), .in_href(delayed_href), .in_gray(delayed_gray),
        .rectify_enable(roi_valid),
        .tl_x(roi_tl_x), .tl_y(roi_tl_y), .tr_x(roi_tr_x), .tr_y(roi_tr_y),
        .br_x(roi_br_x), .br_y(roi_br_y), .bl_x(roi_bl_x), .bl_y(roi_bl_y),
        .busy(warp_busy), .out_vsync(warp_vsync), .out_href(warp_href),
        .out_gray(warp_gray), .out_frame_done(warp_frame_done)
    );

    grayscale_grid_8x8 #(.X_BITS(X_BITS), .Y_BITS(Y_BITS)) grid (
        .pclk, .rst_n, .vsync(warp_vsync), .href(warp_href),
        .pixel_gray(warp_gray), .frame_width(X_BITS'(160)),
        .frame_height(Y_BITS'(120)), .grid_pixel_valid,
        .grid_pixel_gray, .grid_col, .grid_row, .grid_cell,
        .pixel_x(grid_pixel_x), .pixel_y(grid_pixel_y),
        .frame_done(grid_frame_done)
    );

    grid_corner_frame_guard guard (
        .pclk, .rst_n, .grid_pixel_valid, .grid_pixel_gray, .grid_cell,
        .grid_frame_done, .transfer_active(guard_transfer_active),
        .frame_checked(guard_frame_checked),
        .start_frame_learned(guard_start_learned),
        .data_frame_valid(guard_data_valid),
        .frame_discarded(guard_frame_discarded),
        .end_frame_detected(guard_end_detected),
        .frame_ignored(guard_frame_ignored),
        .discard_reason(guard_discard_reason),
        .learned_white_level(guard_learned_white),
        .dynamic_white_threshold(guard_white_threshold),
        .corner_tl_average(guard_tl_average),
        .corner_tr_average(guard_tr_average),
        .corner_bl_average(guard_bl_average),
        .corner_br_average(guard_br_average)
    );
endmodule
