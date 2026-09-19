`timescale 1ns/1ps

module cubeocc_top (
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
    output logic [63:0] symbols_data
);

    logic        grid_pixel_valid;
    logic [7:0]  grid_pixel_gray;
    logic [5:0]  grid_cell;
    logic        grid_frame_done;
    logic [9:0]  grid_pixel_x;
    logic [9:0]  grid_pixel_y;
    logic [2:0]  grid_col;
    logic [2:0]  grid_row;

    logic        sampler_tready;
    logic        sampler_tlast;

    roi_warp_grid_pipeline #(.X_BITS(10), .Y_BITS(10)) u_pipeline (
        .pclk(pclk), .rst_n(rst_n),
        .cam_vsync(cam_vsync), .cam_href(cam_href), .cam_gray(cam_pixel_data),
        .bright_threshold(8'd180), .min_line_run(10'd20), .min_roi_height(10'd12), .full_off_max_pixels(32'd0),
        .roi_valid(roi_valid), .tracking_active(roi_tracking_active),
        .roi_x(roi_x), .roi_y(roi_y), .roi_width(roi_width), .roi_height(roi_height),
        .roi_tl_x(roi_tl_x), .roi_tl_y(roi_tl_y), .roi_tr_x(roi_tr_x), .roi_tr_y(roi_tr_y),
        .roi_br_x(roi_br_x), .roi_br_y(roi_br_y), .roi_bl_x(roi_bl_x), .roi_bl_y(roi_bl_y),
        .grid_pixel_valid(grid_pixel_valid), .grid_pixel_gray(grid_pixel_gray),
        .grid_col(grid_col), .grid_row(grid_row), .grid_cell(grid_cell),
        .grid_pixel_x(grid_pixel_x), .grid_pixel_y(grid_pixel_y), .grid_frame_done(grid_frame_done)
    );
    dynamic_threshold_sampler u_sampler (
        .clk(pclk), .rst_n(rst_n),
        .grid_pixel_valid(grid_pixel_valid), .grid_pixel_gray(grid_pixel_gray),
        .grid_cell(grid_cell), .grid_col(grid_col), .grid_row(grid_row),
        .grid_pixel_x(grid_pixel_x), .grid_pixel_y(grid_pixel_y), .grid_frame_done(grid_frame_done),
        .m_axis_tvalid(symbols_valid), .m_axis_tready(sampler_tready),
        .m_axis_tdata(symbols_data), .m_axis_tlast(sampler_tlast)
    );

    assign sampler_tready = 1'b1; 

endmodule