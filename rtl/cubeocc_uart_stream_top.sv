`timescale 1ns/1ps

// Camera-to-UART research top. The FPGA classifies the optical frame and sends
// the raw 64-cell result to an external decoder over one UART TX pin.
module cubeocc_uart_stream_top #(
    parameter integer CLASSIFIER_MODEL = 2,
    parameter integer CLOCK_HZ = 100_000_000,
    parameter integer UART_BAUD = 115_200
) (
    input  logic       pclk,
    input  logic       rst_n,
    input  logic       cam_vsync,
    input  logic       cam_href,
    input  logic [7:0] cam_pixel_data,
    output logic       uart_tx
);
    logic roi_valid;
    logic tracking;
    logic [9:0] roi_x, roi_y, roi_width, roi_height;
    logic [9:0] tl_x, tl_y, tr_x, tr_y, br_x, br_y, bl_x, bl_y;
    logic symbols_valid;
    logic [63:0] symbols_old, symbols_pca, selected_symbols;
    logic [2:0] symbols_kind;
    logic frame_ready;
    logic uart_busy;
    logic uart_overflow;

    assign selected_symbols = (CLASSIFIER_MODEL == 1) ? symbols_old : symbols_pca;

    cubeocc_dual_classifier_top #(.MODEL_SELECT(CLASSIFIER_MODEL)) u_classifier (
        .pclk(pclk), .rst_n(rst_n), .cam_vsync(cam_vsync),
        .cam_href(cam_href), .cam_pixel_data(cam_pixel_data),
        .roi_valid(roi_valid), .roi_tracking_active(tracking),
        .roi_x(roi_x), .roi_y(roi_y), .roi_width(roi_width), .roi_height(roi_height),
        .roi_tl_x(tl_x), .roi_tl_y(tl_y), .roi_tr_x(tr_x), .roi_tr_y(tr_y),
        .roi_br_x(br_x), .roi_br_y(br_y), .roi_bl_x(bl_x), .roi_bl_y(bl_y),
        .symbols_valid(symbols_valid), .symbols_old_poly(symbols_old),
        .symbols_pca30(symbols_pca), .symbols_kind(symbols_kind)
    );

    cubeocc_uart_frame_streamer #(
        .CLOCK_HZ(CLOCK_HZ), .BAUD(UART_BAUD),
        .MODEL_ID(CLASSIFIER_MODEL == 1 ? 8'd1 : 8'd2)
    ) u_streamer (
        .clk(pclk), .rst_n(rst_n), .frame_valid(symbols_valid),
        .frame_kind(symbols_kind), .frame_symbols(selected_symbols),
        .frame_ready(frame_ready), .tx(uart_tx), .busy(uart_busy),
        .overflow(uart_overflow)
    );
endmodule
