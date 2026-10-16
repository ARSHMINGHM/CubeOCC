`timescale 1ns/1ps

// Alternate research top. The ROI/warp/grid front-end is shared; both trained
// polynomial classifiers receive exactly the same grid stream.
module cubeocc_dual_classifier_top #(
    // 0 = both, 1 = old degree-2 SVM only, 2 = PCA30-fused SVM only.
    parameter integer MODEL_SELECT = 0
) (
    input  logic       pclk,
    input  logic       rst_n,
    input  logic       cam_vsync,
    input  logic       cam_href,
    input  logic [7:0] cam_pixel_data,
    output logic       roi_valid,
    output logic       roi_tracking_active,
    output logic [9:0] roi_x,
    output logic [9:0] roi_y,
    output logic [9:0] roi_width,
    output logic [9:0] roi_height,
    output logic [9:0] roi_tl_x,
    output logic [9:0] roi_tl_y,
    output logic [9:0] roi_tr_x,
    output logic [9:0] roi_tr_y,
    output logic [9:0] roi_br_x,
    output logic [9:0] roi_br_y,
    output logic [9:0] roi_bl_x,
    output logic [9:0] roi_bl_y,
    output logic       symbols_valid,
    output logic [63:0] symbols_old_poly,
    output logic [63:0] symbols_pca30,
    output logic [2:0] symbols_kind
);
    logic grid_pixel_valid, grid_frame_done;
    logic [7:0] grid_pixel_gray;
    logic [5:0] grid_cell;
    logic [2:0] grid_col, grid_row;
    logic [9:0] grid_pixel_x, grid_pixel_y;
    logic guard_frame_checked, guard_start_learned, guard_data_valid;
    logic guard_frame_discarded, guard_end_detected;
    logic detector_frame_done_unused;
    logic warp_busy_unused;
    logic warp_vsync_unused, warp_href_unused, warp_frame_done_unused;
    logic [7:0] warp_gray_unused;
    logic guard_transfer_active_unused, guard_frame_ignored_unused;
    logic [2:0] guard_discard_reason_unused;
    logic [7:0] guard_learned_white_unused, guard_white_threshold_unused;
    logic [7:0] guard_tl_unused, guard_tr_unused, guard_bl_unused, guard_br_unused;

    roi_warp_grid_pipeline #(.X_BITS(10), .Y_BITS(10)) u_pipeline (
        .pclk(pclk), .rst_n(rst_n),
        .cam_vsync(cam_vsync), .cam_href(cam_href), .cam_gray(cam_pixel_data),
        .bright_threshold(8'd180), .min_line_run(10'd20),
        .min_roi_height(10'd12), .full_off_max_pixels(32'd0),
        .detector_frame_done(detector_frame_done_unused),
        .warp_busy(warp_busy_unused),
        .warp_vsync(warp_vsync_unused), .warp_href(warp_href_unused),
        .warp_gray(warp_gray_unused), .warp_frame_done(warp_frame_done_unused),
        .roi_valid(roi_valid), .tracking_active(roi_tracking_active),
        .roi_x(roi_x), .roi_y(roi_y), .roi_width(roi_width), .roi_height(roi_height),
        .roi_tl_x(roi_tl_x), .roi_tl_y(roi_tl_y), .roi_tr_x(roi_tr_x), .roi_tr_y(roi_tr_y),
        .roi_br_x(roi_br_x), .roi_br_y(roi_br_y), .roi_bl_x(roi_bl_x), .roi_bl_y(roi_bl_y),
        .grid_pixel_valid(grid_pixel_valid), .grid_pixel_gray(grid_pixel_gray),
        .grid_col(grid_col), .grid_row(grid_row), .grid_cell(grid_cell),
        .grid_pixel_x(grid_pixel_x), .grid_pixel_y(grid_pixel_y),
        .grid_frame_done(grid_frame_done),
        .guard_frame_checked(guard_frame_checked), .guard_start_learned(guard_start_learned),
        .guard_data_valid(guard_data_valid), .guard_frame_discarded(guard_frame_discarded),
        .guard_end_detected(guard_end_detected),
        .guard_transfer_active(guard_transfer_active_unused),
        .guard_frame_ignored(guard_frame_ignored_unused),
        .guard_discard_reason(guard_discard_reason_unused),
        .guard_learned_white(guard_learned_white_unused),
        .guard_white_threshold(guard_white_threshold_unused),
        .guard_tl_average(guard_tl_unused), .guard_tr_average(guard_tr_unused),
        .guard_bl_average(guard_bl_unused), .guard_br_average(guard_br_unused)
    );

    directional_dual_polynomial_sampler #(.MODEL_SELECT(MODEL_SELECT)) u_dual_sampler (
        .clk(pclk), .rst_n(rst_n),
        .grid_pixel_valid(grid_pixel_valid), .grid_pixel_gray(grid_pixel_gray),
        .grid_cell(grid_cell), .grid_col(grid_col), .grid_row(grid_row),
        .grid_pixel_x(grid_pixel_x), .grid_pixel_y(grid_pixel_y),
        .grid_frame_done(grid_frame_done), .roi_valid(roi_valid),
        .guard_frame_checked(guard_frame_checked), .guard_start(guard_start_learned),
        .guard_data_valid(guard_data_valid), .guard_end(guard_end_detected),
        .guard_discarded(guard_frame_discarded),
        .results_valid(symbols_valid), .results_ready(1'b1),
        .symbols_old_poly(symbols_old_poly), .symbols_pca30(symbols_pca30),
        .symbols_kind(symbols_kind)
    );
endmodule
