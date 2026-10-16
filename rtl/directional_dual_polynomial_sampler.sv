`timescale 1ns/1ps

// Experimental dual classifier for the same rectified 8x8 grayscale stream.
// One shared degree-2 term generator evaluates two trained decision rules:
//   old_poly    : grouped-CV error 293/40800 (0.7181%)
//   pca30_fused : grouped-CV error 253/40800 (0.6201%)
// PCA is a training-only transform. Its weights are fused back into the 35
// polynomial terms, so no 30-output matrix multiply exists in this RTL.
module directional_dual_polynomial_sampler #(
    // 0: keep both models, 1: old degree-2 SVM only, 2: PCA30-fused SVM only.
    // This is a synthesis-time parameter. Disabled model logic is trimmed.
    parameter integer MODEL_SELECT = 0
) (
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
    input  logic       roi_valid,
    input  logic       guard_frame_checked,
    input  logic       guard_start,
    input  logic       guard_data_valid,
    input  logic       guard_end,
    input  logic       guard_discarded,
    output logic       results_valid,
    input  logic       results_ready,
    output logic [63:0] symbols_old_poly,
    output logic [63:0] symbols_pca30,
    output logic [2:0] symbols_kind
);
    `include "generated/dual_directional_coefficients.svh"

    localparam [63:0] START_WORD = 64'hFFFF_FFFF_FFFF_FFFF;
    localparam [63:0] END_WORD   = 64'h0100_0000_0000_0081;
    localparam integer SCORE_W = 56;
    localparam integer MODEL_BOTH = 0;
    localparam integer MODEL_OLD_POLY = 1;
    localparam integer MODEL_PCA30 = 2;

    localparam [3:0] M_IDLE      = 4'd0;
    localparam [3:0] M_PREP      = 4'd1;
    localparam [3:0] M_GATHER    = 4'd2;
    localparam [3:0] M_TERM_MAKE = 4'd3;
    localparam [3:0] M_TERM_MUL  = 4'd4;
    localparam [3:0] M_TERM_ACC  = 4'd5;
    localparam [3:0] M_DECIDE    = 4'd6;
    localparam [3:0] M_FINISH    = 4'd7;

    logic [3:0] mode;
    logic [14:0] sum_acc [0:63];
    logic [14:0] start_sum [0:63];
    logic start_valid;
    logic [14:0] feature [0:6];
    logic [14:0] selected_feature;
    logic [14:0] white_value;
    logic [11:0] scaled_feature [0:6];
    logic [11:0] scaled_white;
    logic [5:0] cidx;
    logic [2:0] feature_index;
    logic [5:0] term_index;
    logic [23:0] term_value;
    logic signed [42:0] product_old, product_pca;
    logic signed [SCORE_W-1:0] score_old;
    logic signed [SCORE_W-1:0] score_pca;
    logic [63:0] work_old, work_pca;
    logic lat_start, lat_data, lat_end, lat_discarded;

    logic [9:0] col_origin, row_origin;
    logic [4:0] lx, abs_dx;
    logic [3:0] ly, abs_dy;
    logic [11:0] dist_sq;
    logic [2:0] cell_row, cell_col;
    logic cell_is_corner;

    integer i;

    assign col_origin = grid_col * 10'd20;
    assign row_origin = grid_row * 10'd15;
    assign lx = (grid_pixel_x - col_origin) & 5'h1f;
    assign ly = (grid_pixel_y - row_origin) & 4'h0f;
    assign abs_dx = (lx >= 5'd10) ? (lx - 5'd10) : (5'd10 - lx);
    assign abs_dy = (ly >= 4'd7) ? (ly - 4'd7) : (4'd7 - ly);
    assign dist_sq = (abs_dx * abs_dx) + (abs_dy * abs_dy);
    assign cell_row = cidx[5:3];
    assign cell_col = cidx[2:0];
    assign cell_is_corner = (cidx == 6'd0) || (cidx == 6'd7) ||
                            (cidx == 6'd56) || (cidx == 6'd63);
    assign scaled_white = white_value >> DUAL_VALUE_SHIFT;

    genvar g;
    generate
        for (g = 0; g < 7; g = g + 1) begin : g_scale
            assign scaled_feature[g] = feature[g] >> DUAL_VALUE_SHIFT;
        end
    endgenerate

    // Missing edge neighbors use the center cell, matching the Python model.
    always @* begin
        selected_feature = sum_acc[cidx];
        case (feature_index)
            3'd0: selected_feature = sum_acc[cidx];                                  // center
            3'd1: selected_feature = (cell_row != 0) ? sum_acc[cidx - 8] : sum_acc[cidx]; // N
            3'd2: selected_feature = (cell_row != 7 && cell_col != 7) ? sum_acc[cidx + 9] : sum_acc[cidx]; // SE
            3'd3: selected_feature = (cell_row != 7) ? sum_acc[cidx + 8] : sum_acc[cidx]; // S
            3'd4: selected_feature = (cell_row != 7 && cell_col != 0) ? sum_acc[cidx + 7] : sum_acc[cidx]; // SW
            3'd5: selected_feature = (cell_col != 0) ? sum_acc[cidx - 1] : sum_acc[cidx]; // W
            3'd6: selected_feature = (cell_row != 0 && cell_col != 0) ? sum_acc[cidx - 9] : sum_acc[cidx]; // NW
            default: selected_feature = sum_acc[cidx];
        endcase
    end

    function automatic [2:0] pair_left(input logic [4:0] index);
        integer left, right, count;
        begin
            pair_left = 0;
            count = 0;
            for (left = 0; left < 7; left = left + 1)
                for (right = left; right < 7; right = right + 1) begin
                    if (count == index) pair_left = left[2:0];
                    count = count + 1;
                end
        end
    endfunction

    function automatic [2:0] pair_right(input logic [4:0] index);
        integer left, right, count;
        begin
            pair_right = 0;
            count = 0;
            for (left = 0; left < 7; left = left + 1)
                for (right = left; right < 7; right = right + 1) begin
                    if (count == index) pair_right = right[2:0];
                    count = count + 1;
                end
        end
    endfunction

    always @(posedge clk) begin
        if (!rst_n) begin
            mode <= M_IDLE;
            cidx <= 0;
            feature_index <= 0;
            term_index <= 0;
            term_value <= 0;
            product_old <= 0;
            product_pca <= 0;
            white_value <= 0;
            score_old <= 0;
            score_pca <= 0;
            work_old <= 0;
            work_pca <= 0;
            start_valid <= 0;
            results_valid <= 0;
            symbols_old_poly <= 0;
            symbols_pca30 <= 0;
            symbols_kind <= 0;
            lat_start <= 0;
            lat_data <= 0;
            lat_end <= 0;
            lat_discarded <= 0;
            for (i = 0; i < 64; i = i + 1) begin
                sum_acc[i] <= 0;
                start_sum[i] <= 0;
            end
            for (i = 0; i < 7; i = i + 1) feature[i] <= 0;
        end else begin
            if (results_valid && results_ready) results_valid <= 0;

            if (guard_frame_checked) begin
                lat_start <= guard_start;
                lat_data <= guard_data_valid;
                lat_end <= guard_end;
                lat_discarded <= guard_discarded;
            end

            if (grid_pixel_valid && roi_valid && mode == M_IDLE && dist_sq <= 12'd25)
                sum_acc[grid_cell] <= sum_acc[grid_cell] + grid_pixel_gray;

            case (mode)
                M_IDLE: if (grid_frame_done) begin
                    cidx <= 0;
                    work_old <= 0;
                    work_pca <= 0;
                    mode <= M_PREP;
                end

                M_PREP: begin
                    white_value <= start_valid ? start_sum[cidx] :
                        (({2'b00, sum_acc[0]} + {2'b00, sum_acc[7]} +
                          {2'b00, sum_acc[56]} + {2'b00, sum_acc[63]}) >> 2);
                    feature_index <= 0;
                    mode <= M_GATHER;
                end

                M_GATHER: begin
                    feature[feature_index] <= selected_feature;
                    if (feature_index == 6) begin
                        term_index <= 0;
                        mode <= M_TERM_MAKE;
                    end else feature_index <= feature_index + 1'b1;
                end

                M_TERM_MAKE: begin
                    if (term_index == 0)
                        term_value <= scaled_white * scaled_white;
                    else if (term_index <= 7)
                        term_value <= scaled_feature[term_index - 1] * scaled_white;
                    else
                        term_value <= scaled_feature[pair_left(term_index - 8)] *
                                      scaled_feature[pair_right(term_index - 8)];
                    mode <= M_TERM_MUL;
                end

                M_TERM_MUL: begin
                    if (MODEL_SELECT != MODEL_PCA30)
                        product_old <= $signed(coefficient_old_poly(term_index)) *
                                       $signed({1'b0, term_value});
                    else
                        product_old <= 0;
                    if (MODEL_SELECT != MODEL_OLD_POLY)
                        product_pca <= $signed(coefficient_pca30_fused(term_index)) *
                                       $signed({1'b0, term_value});
                    else
                        product_pca <= 0;
                    mode <= M_TERM_ACC;
                end

                M_TERM_ACC: begin
                    if (term_index == 0) begin
                        score_old <= product_old;
                        score_pca <= product_pca;
                    end else begin
                        score_old <= score_old + product_old;
                        score_pca <= score_pca + product_pca;
                    end
                    if (term_index == 35) mode <= M_DECIDE;
                    else begin
                        term_index <= term_index + 1'b1;
                        mode <= M_TERM_MAKE;
                    end
                end

                M_DECIDE: begin
                    work_old[cidx] <= (MODEL_SELECT == MODEL_PCA30) ? 1'b0 :
                                      (cell_is_corner ? 1'b1 : (score_old > 0));
                    work_pca[cidx] <= (MODEL_SELECT == MODEL_OLD_POLY) ? 1'b0 :
                                      (cell_is_corner ? 1'b1 : (score_pca > 0));
                    if (cidx == 63) mode <= M_FINISH;
                    else begin
                        cidx <= cidx + 1'b1;
                        mode <= M_PREP;
                    end
                end

                default: begin // M_FINISH
                    if (lat_start) begin
                        symbols_old_poly <= START_WORD;
                        symbols_pca30 <= START_WORD;
                        symbols_kind <= 1;
                        for (i = 0; i < 64; i = i + 1) start_sum[i] <= sum_acc[i];
                        start_valid <= 1;
                    end else if (lat_end) begin
                        symbols_old_poly <= END_WORD;
                        symbols_pca30 <= END_WORD;
                        symbols_kind <= 3;
                    end else if (lat_data) begin
                        symbols_old_poly <= work_old;
                        symbols_pca30 <= work_pca;
                        symbols_kind <= 2;
                    end else if (lat_discarded) begin
                        symbols_old_poly <= work_old;
                        symbols_pca30 <= work_pca;
                        symbols_kind <= 4;
                    end else begin
                        symbols_old_poly <= work_old;
                        symbols_pca30 <= work_pca;
                        symbols_kind <= 0;
                    end
                    for (i = 0; i < 64; i = i + 1) sum_acc[i] <= 0;
                    lat_start <= 0;
                    lat_data <= 0;
                    lat_end <= 0;
                    lat_discarded <= 0;
                    results_valid <= 1;
                    mode <= M_IDLE;
                end
            endcase
        end
    end
endmodule
