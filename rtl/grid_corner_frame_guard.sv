`timescale 1ns/1ps

// Post-grid frame validator for the V1 grayscale protocol.
//
// The first complete, all-white START grid calibrates the white level. Later
// DATA frames are committed only when all four corner-cell averages remain
// above a dynamic fraction of that START reference. The module stores only
// 64 cell sums plus frame diagnostics; downstream logic should accumulate a
// candidate frame and commit it only when data_frame_valid pulses.
module grid_corner_frame_guard #(
    parameter int CELL_PIXELS = 300,
    parameter int FRAME_PIXELS = 19200,
    parameter int START_MIN_AVG = 96,
    parameter int MIN_WHITE_THRESHOLD = 48
)(
    input  logic       pclk,
    input  logic       rst_n,
    input  logic       grid_pixel_valid,
    input  logic [7:0] grid_pixel_gray,
    input  logic [5:0] grid_cell,
    input  logic       grid_frame_done,

    output logic       transfer_active,
    output logic       frame_checked,
    output logic       start_frame_learned,
    output logic       data_frame_valid,
    output logic       frame_discarded,
    output logic       end_frame_detected,
    output logic       frame_ignored,
    output logic [2:0] discard_reason,
    output logic [7:0] learned_white_level,
    output logic [7:0] dynamic_white_threshold,
    output logic [7:0] corner_tl_average,
    output logic [7:0] corner_tr_average,
    output logic [7:0] corner_bl_average,
    output logic [7:0] corner_br_average
);
    localparam int CELL_SUM_BITS = $clog2(CELL_PIXELS * 255 + 1);
    localparam int FRAME_SUM_BITS = $clog2(FRAME_PIXELS * 255 + 1);
    localparam int FRAME_COUNT_BITS = $clog2(FRAME_PIXELS + 1);

    localparam logic [2:0] REASON_NONE = 3'd0;
    localparam logic [2:0] REASON_NOT_CALIBRATED = 3'd1;
    localparam logic [2:0] REASON_PIXEL_COUNT = 3'd2;
    localparam logic [2:0] REASON_DARK_CORNER = 3'd3;

    logic [CELL_SUM_BITS-1:0] cell_sum [0:63];
    logic [FRAME_SUM_BITS-1:0] frame_sum;
    logic [FRAME_COUNT_BITS-1:0] frame_pixel_count;
    integer i;

    logic [7:0] frame_average_calc;
    logic [7:0] tl_average_calc, tr_average_calc;
    logic [7:0] bl_average_calc, br_average_calc;
    logic [7:0] start_corner_min;
    logic [10:0] scaled_start_white;
    logic [7:0] threshold_from_start;
    logic pixel_count_ok;
    logic start_candidate;
    logic corners_are_white;
    logic end_candidate;

    always_comb begin
        frame_average_calc = frame_sum / FRAME_PIXELS;
        tl_average_calc = cell_sum[0] / CELL_PIXELS;
        tr_average_calc = cell_sum[7] / CELL_PIXELS;
        bl_average_calc = cell_sum[56] / CELL_PIXELS;
        br_average_calc = cell_sum[63] / CELL_PIXELS;

        start_corner_min = tl_average_calc;
        if (tr_average_calc < start_corner_min)
            start_corner_min = tr_average_calc;
        if (bl_average_calc < start_corner_min)
            start_corner_min = bl_average_calc;
        if (br_average_calc < start_corner_min)
            start_corner_min = br_average_calc;

        // 5/8 of the weakest white START corner. Constant shifts/adds avoid a
        // run-time divider or multiplier in the threshold path.
        scaled_start_white = ({3'b000, start_corner_min} << 2)
                           + {3'b000, start_corner_min};
        threshold_from_start = scaled_start_white >> 3;
        if (threshold_from_start < MIN_WHITE_THRESHOLD)
            threshold_from_start = MIN_WHITE_THRESHOLD;

        pixel_count_ok = frame_pixel_count == FRAME_PIXELS;
        start_candidate = pixel_count_ok
                       && frame_average_calc >= START_MIN_AVG
                       && start_corner_min >= START_MIN_AVG;
        corners_are_white = tl_average_calc >= dynamic_white_threshold
                         && tr_average_calc >= dynamic_white_threshold
                         && bl_average_calc >= dynamic_white_threshold
                         && br_average_calc >= dynamic_white_threshold;

        // END is mostly black, with TL/TR/BL still visible and BR off. The
        // half-threshold test tolerates blur while remaining distinct from a
        // valid DATA frame, whose BR marker must meet the full threshold.
        end_candidate = frame_average_calc < (dynamic_white_threshold >> 1)
                     && br_average_calc < (dynamic_white_threshold >> 1)
                     && tl_average_calc >= (dynamic_white_threshold >> 1)
                     && tr_average_calc >= (dynamic_white_threshold >> 1)
                     && bl_average_calc >= (dynamic_white_threshold >> 1);
    end

    always_ff @(posedge pclk or negedge rst_n) begin
        if (!rst_n) begin
            transfer_active <= 1'b0;
            frame_checked <= 1'b0;
            start_frame_learned <= 1'b0;
            data_frame_valid <= 1'b0;
            frame_discarded <= 1'b0;
            end_frame_detected <= 1'b0;
            frame_ignored <= 1'b0;
            discard_reason <= REASON_NONE;
            learned_white_level <= 8'd0;
            dynamic_white_threshold <= MIN_WHITE_THRESHOLD;
            corner_tl_average <= 8'd0;
            corner_tr_average <= 8'd0;
            corner_bl_average <= 8'd0;
            corner_br_average <= 8'd0;
            frame_sum <= '0;
            frame_pixel_count <= '0;
            for (i = 0; i < 64; i = i + 1)
                cell_sum[i] <= '0;
        end else begin
            frame_checked <= 1'b0;
            start_frame_learned <= 1'b0;
            data_frame_valid <= 1'b0;
            frame_discarded <= 1'b0;
            end_frame_detected <= 1'b0;
            frame_ignored <= 1'b0;

            if (grid_pixel_valid) begin
                cell_sum[grid_cell] <= cell_sum[grid_cell] + grid_pixel_gray;
                frame_sum <= frame_sum + grid_pixel_gray;
                if (frame_pixel_count < FRAME_PIXELS)
                    frame_pixel_count <= frame_pixel_count + 1'b1;
            end

            if (grid_frame_done) begin
                frame_checked <= 1'b1;
                corner_tl_average <= tl_average_calc;
                corner_tr_average <= tr_average_calc;
                corner_bl_average <= bl_average_calc;
                corner_br_average <= br_average_calc;

                if (!pixel_count_ok) begin
                    frame_discarded <= transfer_active;
                    frame_ignored <= !transfer_active;
                    discard_reason <= REASON_PIXEL_COUNT;
                end else if (!transfer_active) begin
                    if (start_candidate) begin
                        discard_reason <= REASON_NONE;
                        learned_white_level <= start_corner_min;
                        dynamic_white_threshold <= threshold_from_start;
                        transfer_active <= 1'b1;
                        start_frame_learned <= 1'b1;
                    end else begin
                        frame_ignored <= 1'b1;
                        discard_reason <= REASON_NOT_CALIBRATED;
                    end
                end else if (end_candidate) begin
                    discard_reason <= REASON_NONE;
                    transfer_active <= 1'b0;
                    end_frame_detected <= 1'b1;
                end else if (corners_are_white) begin
                    discard_reason <= REASON_NONE;
                    data_frame_valid <= 1'b1;
                end else begin
                    frame_discarded <= 1'b1;
                    discard_reason <= REASON_DARK_CORNER;
                end

                frame_sum <= '0;
                frame_pixel_count <= '0;
                for (i = 0; i < 64; i = i + 1)
                    cell_sum[i] <= '0;
            end
        end
    end
endmodule
