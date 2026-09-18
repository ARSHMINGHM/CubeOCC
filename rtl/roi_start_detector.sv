`timescale 1ns/1ps

// Camera 1 ROI tracker for the CubeOCC START/DATA/full-off protocol.
// WAIT_FOR_START acquires the dense all-white START region and records its
// four diagonal corners. TRACKING follows local marker windows around those
// corners. No raw frame buffer is used; each input pixel is handled in one
// pclk cycle.
module roi_start_detector #(
    parameter int X_BITS = 10,
    parameter int Y_BITS = 10,
    parameter int MAX_ROW_GAP = 2,
    parameter int MAX_EDGE_STEP = 2,
    parameter int MAX_EDGE_HEIGHT_DELTA = 28,
    parameter int MAX_CORNER_SHIFT = 10,
    parameter int THRESHOLD_MARGIN = 32,
    parameter int START_THRESHOLD_MARGIN = 68
) (
    input  logic                   pclk,
    input  logic                   rst_n,
    input  logic                   vsync,
    input  logic                   href,
    input  logic [7:0]             pixel_data,
    input  logic [7:0]             bright_threshold,
    input  logic [X_BITS-1:0]      min_line_run,
    input  logic [Y_BITS-1:0]      min_roi_height,
    input  logic [31:0]            full_off_max_pixels,
    output logic                   roi_valid,
    output logic                   tracking_active,
    output logic                   frame_done,
    output logic [X_BITS-1:0]      roi_x,
    output logic [Y_BITS-1:0]      roi_y,
    output logic [X_BITS-1:0]      roi_width,
    output logic [Y_BITS-1:0]      roi_height,
    output logic [X_BITS-1:0]      roi_tl_x,
    output logic [Y_BITS-1:0]      roi_tl_y,
    output logic [X_BITS-1:0]      roi_tr_x,
    output logic [Y_BITS-1:0]      roi_tr_y,
    output logic [X_BITS-1:0]      roi_br_x,
    output logic [Y_BITS-1:0]      roi_br_y,
    output logic [X_BITS-1:0]      roi_bl_x,
    output logic [Y_BITS-1:0]      roi_bl_y
);

    localparam int SCORE_BITS = ((X_BITS > Y_BITS) ? X_BITS : Y_BITS) + 1;

    logic vsync_d, href_d;
    logic [X_BITS-1:0] x;
    logic [Y_BITS-1:0] y;

    // START-frame longest-run/tallest-band acquisition state.
    logic [X_BITS-1:0] run_start, run_length, longest_start, longest_length;
    // Left and right screen edges are tracked independently. Under
    // perspective their top and bottom endpoints occur on different rows.
    logic left_edge_active, right_edge_active;
    logic [Y_BITS-1:0] left_edge_last_y, right_edge_last_y;
    logic [Y_BITS-1:0] left_edge_top_y, left_edge_bottom_y;
    logic [Y_BITS-1:0] right_edge_top_y, right_edge_bottom_y;
    logic [X_BITS-1:0] left_edge_top_x, left_edge_bottom_x;
    logic [X_BITS-1:0] right_edge_top_x, right_edge_bottom_x;
    logic [Y_BITS-1:0] best_left_height, best_right_height;
    logic [Y_BITS-1:0] best_left_top_y, best_left_bottom_y;
    logic [Y_BITS-1:0] best_right_top_y, best_right_bottom_y;
    logic [X_BITS-1:0] best_left_top_x, best_left_bottom_x;
    logic [X_BITS-1:0] best_right_top_x, best_right_bottom_x;

    // DATA-frame corner-marker state. Each marker is searched only in a
    // bounded window around its last accepted location. A marker must form a
    // short multi-row bright box; isolated bright pixels are not evidence.
    // This prevents payload cells, monitor edges, and reflections elsewhere
    // in the frame from becoming a false ROI corner without a frame buffer.
    logic [X_BITS-1:0] anchor_tl_x, anchor_tr_x, anchor_br_x, anchor_bl_x;
    logic [Y_BITS-1:0] anchor_tl_y, anchor_tr_y, anchor_br_y, anchor_bl_y;
    logic [31:0] bright_pixel_count;

    logic [X_BITS-1:0] marker_run_start [0:3];
    logic [X_BITS-1:0] marker_run_length [0:3];
    logic [X_BITS-1:0] marker_longest_start [0:3];
    logic [X_BITS-1:0] marker_longest_length [0:3];
    logic marker_band_active [0:3];
    logic [Y_BITS-1:0] marker_band_last_y [0:3];
    logic [Y_BITS-1:0] marker_band_rows [0:3];
    logic [X_BITS-1:0] marker_left [0:3], marker_right [0:3];
    logic [Y_BITS-1:0] marker_top [0:3], marker_bottom [0:3];
    logic [Y_BITS-1:0] marker_best_rows [0:3];
    logic [X_BITS-1:0] marker_best_left [0:3], marker_best_right [0:3];
    logic [Y_BITS-1:0] marker_best_top [0:3], marker_best_bottom [0:3];

    logic [7:0] detector_threshold;
    logic [X_BITS-1:0] marker_final_left [0:3], marker_final_right [0:3];
    logic [Y_BITS-1:0] marker_final_top [0:3], marker_final_bottom [0:3];
    logic [Y_BITS-1:0] marker_final_rows [0:3];
    logic [X_BITS-1:0] marker_min_run;
    logic [Y_BITS-1:0] marker_min_rows;
    logic [3:0] marker_box_valid;
    logic [X_BITS-1:0] candidate_left, candidate_right;
    logic [Y_BITS-1:0] candidate_top, candidate_bottom;
    logic [SCORE_BITS-1:0] allowed_shift;
    logic candidate_plausible;
    logic [3:0] in_marker_window;
    logic [X_BITS-1:0] line_right;
    logic left_edge_coherent, right_edge_coherent;
    logic [Y_BITS-1:0] final_left_height, final_right_height;
    logic [Y_BITS-1:0] final_left_top_y, final_left_bottom_y;
    logic [Y_BITS-1:0] final_right_top_y, final_right_bottom_y;
    logic [X_BITS-1:0] final_left_top_x, final_left_bottom_x;
    logic [X_BITS-1:0] final_right_top_x, final_right_bottom_x;
    logic [X_BITS-1:0] start_candidate_left, start_candidate_right;
    logic [Y_BITS-1:0] start_candidate_top, start_candidate_bottom;
    logic [Y_BITS-1:0] start_tl_y, start_tr_y, start_br_y, start_bl_y;
    logic start_candidate_valid;

    function automatic logic [Y_BITS-1:0] height_of(
        input logic [Y_BITS-1:0] top,
        input logic [Y_BITS-1:0] bottom
    );
        height_of = bottom - top + 1'b1;
    endfunction

    function automatic logic [X_BITS-1:0] min_x4(input logic [X_BITS-1:0] a, b, c, d);
        logic [X_BITS-1:0] low;
        begin
            low = (a < b) ? a : b;
            low = (low < c) ? low : c;
            min_x4 = (low < d) ? low : d;
        end
    endfunction

    function automatic logic [X_BITS-1:0] max_x4(input logic [X_BITS-1:0] a, b, c, d);
        logic [X_BITS-1:0] high;
        begin
            high = (a > b) ? a : b;
            high = (high > c) ? high : c;
            max_x4 = (high > d) ? high : d;
        end
    endfunction

    function automatic logic [Y_BITS-1:0] min_y4(input logic [Y_BITS-1:0] a, b, c, d);
        logic [Y_BITS-1:0] low;
        begin
            low = (a < b) ? a : b;
            low = (low < c) ? low : c;
            min_y4 = (low < d) ? low : d;
        end
    endfunction

    function automatic logic [Y_BITS-1:0] max_y4(input logic [Y_BITS-1:0] a, b, c, d);
        logic [Y_BITS-1:0] high;
        begin
            high = (a > b) ? a : b;
            high = (high > c) ? high : c;
            max_y4 = (high > d) ? high : d;
        end
    endfunction

    function automatic logic [SCORE_BITS-1:0] abs_x_diff(input logic [X_BITS-1:0] a, b);
        abs_x_diff = (a >= b) ? a - b : b - a;
    endfunction

    function automatic logic [SCORE_BITS-1:0] abs_y_diff(input logic [Y_BITS-1:0] a, b);
        abs_y_diff = (a >= b) ? a - b : b - a;
    endfunction

    always_comb begin : marker_combinational
        integer marker_index;
        detector_threshold = !tracking_active
            ? ((bright_threshold > START_THRESHOLD_MARGIN) ? bright_threshold - START_THRESHOLD_MARGIN : 8'd1)
            : ((bright_threshold > THRESHOLD_MARGIN) ? bright_threshold - THRESHOLD_MARGIN : 8'd1);
        line_right = longest_start + longest_length - 1'b1;
        left_edge_coherent = left_edge_active &&
            (y - left_edge_last_y <= MAX_ROW_GAP + 1) &&
            (abs_x_diff(longest_start, left_edge_bottom_x) <= MAX_EDGE_STEP);
        right_edge_coherent = right_edge_active &&
            (y - right_edge_last_y <= MAX_ROW_GAP + 1) &&
            (abs_x_diff(line_right, right_edge_bottom_x) <= MAX_EDGE_STEP);

        if (left_edge_active && height_of(left_edge_top_y, left_edge_bottom_y) >= best_left_height) begin
            final_left_height = height_of(left_edge_top_y, left_edge_bottom_y);
            final_left_top_x = left_edge_top_x;
            final_left_top_y = left_edge_top_y;
            final_left_bottom_x = left_edge_bottom_x;
            final_left_bottom_y = left_edge_bottom_y;
        end else begin
            final_left_height = best_left_height;
            final_left_top_x = best_left_top_x;
            final_left_top_y = best_left_top_y;
            final_left_bottom_x = best_left_bottom_x;
            final_left_bottom_y = best_left_bottom_y;
        end
        if (right_edge_active && height_of(right_edge_top_y, right_edge_bottom_y) >= best_right_height) begin
            final_right_height = height_of(right_edge_top_y, right_edge_bottom_y);
            final_right_top_x = right_edge_top_x;
            final_right_top_y = right_edge_top_y;
            final_right_bottom_x = right_edge_bottom_x;
            final_right_bottom_y = right_edge_bottom_y;
        end else begin
            final_right_height = best_right_height;
            final_right_top_x = best_right_top_x;
            final_right_top_y = best_right_top_y;
            final_right_bottom_x = best_right_bottom_x;
            final_right_bottom_y = best_right_bottom_y;
        end
        start_tl_y = final_left_top_y;
        start_bl_y = final_left_bottom_y;
        start_tr_y = final_right_top_y;
        start_br_y = final_right_bottom_y;
        if (final_left_height + MAX_EDGE_HEIGHT_DELTA < final_right_height) begin
            start_tl_y = final_right_top_y;
            start_bl_y = final_right_bottom_y;
        end else if (final_right_height + MAX_EDGE_HEIGHT_DELTA < final_left_height) begin
            start_tr_y = final_left_top_y;
            start_br_y = final_left_bottom_y;
        end
        start_candidate_left = min_x4(final_left_top_x, final_right_top_x, final_right_bottom_x, final_left_bottom_x);
        start_candidate_right = max_x4(final_left_top_x, final_right_top_x, final_right_bottom_x, final_left_bottom_x);
        start_candidate_top = min_y4(start_tl_y, start_tr_y, start_br_y, start_bl_y);
        start_candidate_bottom = max_y4(start_tl_y, start_tr_y, start_br_y, start_bl_y);
        start_candidate_valid = (final_left_height >= min_roi_height) &&
            (final_right_height >= min_roi_height) && (final_right_top_x > final_left_top_x);
        for (marker_index = 0; marker_index < 4; marker_index = marker_index + 1) begin
            if (marker_band_active[marker_index] &&
                (marker_band_rows[marker_index] >= marker_best_rows[marker_index])) begin
                marker_final_left[marker_index] = marker_left[marker_index];
                marker_final_right[marker_index] = marker_right[marker_index];
                marker_final_top[marker_index] = marker_top[marker_index];
                marker_final_bottom[marker_index] = marker_bottom[marker_index];
                marker_final_rows[marker_index] = marker_band_rows[marker_index];
            end else begin
                marker_final_left[marker_index] = marker_best_left[marker_index];
                marker_final_right[marker_index] = marker_best_right[marker_index];
                marker_final_top[marker_index] = marker_best_top[marker_index];
                marker_final_bottom[marker_index] = marker_best_bottom[marker_index];
                marker_final_rows[marker_index] = marker_best_rows[marker_index];
            end
        end
        candidate_left = min_x4(marker_final_left[0], marker_final_left[1], marker_final_left[2], marker_final_left[3]);
        candidate_right = max_x4(marker_final_right[0], marker_final_right[1], marker_final_right[2], marker_final_right[3]);
        candidate_top = min_y4(marker_final_top[0], marker_final_top[1], marker_final_top[2], marker_final_top[3]);
        candidate_bottom = max_y4(marker_final_bottom[0], marker_final_bottom[1], marker_final_bottom[2], marker_final_bottom[3]);
        allowed_shift = MAX_CORNER_SHIFT;
        marker_min_run = (roi_width < roi_height ? roi_width : roi_height) >> 5;
        if (marker_min_run < 3) marker_min_run = 3;
        marker_min_rows = marker_min_run;
        for (marker_index = 0; marker_index < 4; marker_index = marker_index + 1) begin
            marker_box_valid[marker_index] =
                (marker_final_rows[marker_index] >= marker_min_rows) &&
                (marker_final_right[marker_index] - marker_final_left[marker_index] + 1'b1 >= marker_min_run) &&
                (marker_final_bottom[marker_index] - marker_final_top[marker_index] + 1'b1 >= marker_min_rows);
        end
        // Every marker pixel was already collected inside a fixed START-anchor
        // window, so repeating eight anchor-distance checks wastes LUTs.
        candidate_plausible = &marker_box_valid;
        in_marker_window[0] = (abs_x_diff(x, anchor_tl_x) <= allowed_shift) && (abs_y_diff(y, anchor_tl_y) <= allowed_shift);
        in_marker_window[1] = (abs_x_diff(x, anchor_tr_x) <= allowed_shift) && (abs_y_diff(y, anchor_tr_y) <= allowed_shift);
        in_marker_window[2] = (abs_x_diff(x, anchor_br_x) <= allowed_shift) && (abs_y_diff(y, anchor_br_y) <= allowed_shift);
        in_marker_window[3] = (abs_x_diff(x, anchor_bl_x) <= allowed_shift) && (abs_y_diff(y, anchor_bl_y) <= allowed_shift);
    end

    always_ff @(posedge pclk or negedge rst_n) begin : marker_sequential
        integer marker_index;
        if (!rst_n) begin
            vsync_d <= 1'b1;
            href_d <= 1'b0;
            x <= '0;
            y <= '0;
            run_start <= '0;
            run_length <= '0;
            longest_start <= '0;
            longest_length <= '0;
            anchor_tl_x <= '0;
            anchor_tl_y <= '0;
            anchor_tr_x <= '0;
            anchor_tr_y <= '0;
            anchor_br_x <= '0;
            anchor_br_y <= '0;
            anchor_bl_x <= '0;
            anchor_bl_y <= '0;
            bright_pixel_count <= '0;
            roi_valid <= 1'b0;
            tracking_active <= 1'b0;
            frame_done <= 1'b0;
            roi_x <= '0;
            roi_y <= '0;
            roi_width <= '0;
            roi_height <= '0;
            roi_tl_x <= '0;
            roi_tl_y <= '0;
            roi_tr_x <= '0;
            roi_tr_y <= '0;
            roi_br_x <= '0;
            roi_br_y <= '0;
            roi_bl_x <= '0;
            roi_bl_y <= '0;
            for (marker_index = 0; marker_index < 4; marker_index = marker_index + 1) begin
                marker_run_start[marker_index] <= '0;
                marker_run_length[marker_index] <= '0;
                marker_longest_start[marker_index] <= '0;
                marker_longest_length[marker_index] <= '0;
                marker_band_active[marker_index] <= 1'b0;
                marker_band_last_y[marker_index] <= '0;
                marker_band_rows[marker_index] <= '0;
                marker_left[marker_index] <= '0;
                marker_right[marker_index] <= '0;
                marker_top[marker_index] <= '0;
                marker_bottom[marker_index] <= '0;
                marker_best_rows[marker_index] <= '0;
                marker_best_left[marker_index] <= '0;
                marker_best_right[marker_index] <= '0;
                marker_best_top[marker_index] <= '0;
                marker_best_bottom[marker_index] <= '0;
            end
            left_edge_active <= 1'b0;
            right_edge_active <= 1'b0;
            left_edge_last_y <= '0;
            right_edge_last_y <= '0;
            left_edge_top_y <= '0;
            left_edge_bottom_y <= '0;
            right_edge_top_y <= '0;
            right_edge_bottom_y <= '0;
            left_edge_top_x <= '0;
            left_edge_bottom_x <= '0;
            right_edge_top_x <= '0;
            right_edge_bottom_x <= '0;
            best_left_height <= '0;
            best_right_height <= '0;
            best_left_top_y <= '0;
            best_left_bottom_y <= '0;
            best_right_top_y <= '0;
            best_right_bottom_y <= '0;
            best_left_top_x <= '0;
            best_left_bottom_x <= '0;
            best_right_top_x <= '0;
            best_right_bottom_x <= '0;
        end else begin
            vsync_d <= vsync;
            href_d <= href;
            frame_done <= 1'b0;

            if (vsync_d && !vsync) begin
                x <= '0;
                y <= '0;
                run_start <= '0;
                run_length <= '0;
                longest_start <= '0;
                longest_length <= '0;
                bright_pixel_count <= '0;
                left_edge_active <= 1'b0;
                right_edge_active <= 1'b0;
                best_left_height <= '0;
                best_right_height <= '0;
                for (marker_index = 0; marker_index < 4; marker_index = marker_index + 1) begin
                    marker_run_start[marker_index] <= '0;
                    marker_run_length[marker_index] <= '0;
                    marker_longest_start[marker_index] <= '0;
                    marker_longest_length[marker_index] <= '0;
                    marker_band_active[marker_index] <= 1'b0;
                    marker_band_rows[marker_index] <= '0;
                    marker_best_rows[marker_index] <= '0;
                end
            end

            if (!vsync && href) begin
                if (pixel_data >= detector_threshold) begin
                    bright_pixel_count <= bright_pixel_count + 1'b1;
                    if (!tracking_active) begin
                        if (run_length == '0) run_start <= x;
                        run_length <= run_length + 1'b1;
                        if (run_length >= longest_length) begin
                            longest_length <= run_length + 1'b1;
                            longest_start <= (run_length == '0) ? x : run_start;
                        end
                    end else begin
                        for (marker_index = 0; marker_index < 4; marker_index = marker_index + 1) begin
                            if (in_marker_window[marker_index]) begin
                                if (marker_run_length[marker_index] == '0) marker_run_start[marker_index] <= x;
                                marker_run_length[marker_index] <= marker_run_length[marker_index] + 1'b1;
                                if (marker_run_length[marker_index] >= marker_longest_length[marker_index]) begin
                                    marker_longest_length[marker_index] <= marker_run_length[marker_index] + 1'b1;
                                    marker_longest_start[marker_index] <= (marker_run_length[marker_index] == '0) ? x : marker_run_start[marker_index];
                                end
                            end else begin
                                marker_run_length[marker_index] <= '0;
                            end
                        end
                    end
                end else begin
                    if (!tracking_active) run_length <= '0;
                    else begin
                        for (marker_index = 0; marker_index < 4; marker_index = marker_index + 1) begin
                            marker_run_length[marker_index] <= '0;
                        end
                    end
                end
                x <= x + 1'b1;
            end

            if (!tracking_active && !vsync && href_d && !href) begin
                if (longest_length >= min_line_run) begin
                    if (!left_edge_coherent) begin
                        if (left_edge_active && height_of(left_edge_top_y, left_edge_bottom_y) > best_left_height) begin
                            best_left_height <= height_of(left_edge_top_y, left_edge_bottom_y);
                            best_left_top_x <= left_edge_top_x;
                            best_left_top_y <= left_edge_top_y;
                            best_left_bottom_x <= left_edge_bottom_x;
                            best_left_bottom_y <= left_edge_bottom_y;
                        end
                        left_edge_active <= 1'b1;
                        left_edge_top_x <= longest_start;
                        left_edge_top_y <= y;
                        left_edge_bottom_x <= longest_start;
                        left_edge_bottom_y <= y;
                    end else begin
                        left_edge_bottom_x <= longest_start;
                        left_edge_bottom_y <= y;
                    end
                    left_edge_last_y <= y;
                    if (!right_edge_coherent) begin
                        if (right_edge_active && height_of(right_edge_top_y, right_edge_bottom_y) > best_right_height) begin
                            best_right_height <= height_of(right_edge_top_y, right_edge_bottom_y);
                            best_right_top_x <= right_edge_top_x;
                            best_right_top_y <= right_edge_top_y;
                            best_right_bottom_x <= right_edge_bottom_x;
                            best_right_bottom_y <= right_edge_bottom_y;
                        end
                        right_edge_active <= 1'b1;
                        right_edge_top_x <= line_right;
                        right_edge_top_y <= y;
                        right_edge_bottom_x <= line_right;
                        right_edge_bottom_y <= y;
                    end else begin
                        right_edge_bottom_x <= line_right;
                        right_edge_bottom_y <= y;
                    end
                    right_edge_last_y <= y;
                end else begin
                    if (left_edge_active && y - left_edge_last_y > MAX_ROW_GAP) begin
                        if (height_of(left_edge_top_y, left_edge_bottom_y) > best_left_height) begin
                            best_left_height <= height_of(left_edge_top_y, left_edge_bottom_y);
                            best_left_top_x <= left_edge_top_x;
                            best_left_top_y <= left_edge_top_y;
                            best_left_bottom_x <= left_edge_bottom_x;
                            best_left_bottom_y <= left_edge_bottom_y;
                        end
                        left_edge_active <= 1'b0;
                    end
                    if (right_edge_active && y - right_edge_last_y > MAX_ROW_GAP) begin
                        if (height_of(right_edge_top_y, right_edge_bottom_y) > best_right_height) begin
                            best_right_height <= height_of(right_edge_top_y, right_edge_bottom_y);
                            best_right_top_x <= right_edge_top_x;
                            best_right_top_y <= right_edge_top_y;
                            best_right_bottom_x <= right_edge_bottom_x;
                            best_right_bottom_y <= right_edge_bottom_y;
                        end
                        right_edge_active <= 1'b0;
                    end
                end
                x <= '0;
                y <= y + 1'b1;
                run_start <= '0;
                run_length <= '0;
                longest_start <= '0;
                longest_length <= '0;
            end else if (tracking_active && !vsync && href_d && !href) begin
                for (marker_index = 0; marker_index < 4; marker_index = marker_index + 1) begin
                    if (marker_longest_length[marker_index] >= marker_min_run) begin
                        if (!marker_band_active[marker_index] ||
                            (y - marker_band_last_y[marker_index] > MAX_ROW_GAP + 1)) begin
                            if (marker_band_active[marker_index] &&
                                (marker_band_rows[marker_index] > marker_best_rows[marker_index])) begin
                                marker_best_rows[marker_index] <= marker_band_rows[marker_index];
                                marker_best_left[marker_index] <= marker_left[marker_index];
                                marker_best_right[marker_index] <= marker_right[marker_index];
                                marker_best_top[marker_index] <= marker_top[marker_index];
                                marker_best_bottom[marker_index] <= marker_bottom[marker_index];
                            end
                            marker_band_active[marker_index] <= 1'b1;
                            marker_band_rows[marker_index] <= 1'b1;
                            marker_left[marker_index] <= marker_longest_start[marker_index];
                            marker_right[marker_index] <= marker_longest_start[marker_index] + marker_longest_length[marker_index] - 1'b1;
                            marker_top[marker_index] <= y;
                            marker_bottom[marker_index] <= y;
                        end else begin
                            marker_band_rows[marker_index] <= marker_band_rows[marker_index] + 1'b1;
                            if (marker_longest_start[marker_index] < marker_left[marker_index])
                                marker_left[marker_index] <= marker_longest_start[marker_index];
                            if (marker_longest_start[marker_index] + marker_longest_length[marker_index] - 1'b1 > marker_right[marker_index])
                                marker_right[marker_index] <= marker_longest_start[marker_index] + marker_longest_length[marker_index] - 1'b1;
                            marker_bottom[marker_index] <= y;
                        end
                        marker_band_last_y[marker_index] <= y;
                    end else if (marker_band_active[marker_index] &&
                                 (y - marker_band_last_y[marker_index] > MAX_ROW_GAP)) begin
                        if (marker_band_rows[marker_index] > marker_best_rows[marker_index]) begin
                            marker_best_rows[marker_index] <= marker_band_rows[marker_index];
                            marker_best_left[marker_index] <= marker_left[marker_index];
                            marker_best_right[marker_index] <= marker_right[marker_index];
                            marker_best_top[marker_index] <= marker_top[marker_index];
                            marker_best_bottom[marker_index] <= marker_bottom[marker_index];
                        end
                        marker_band_active[marker_index] <= 1'b0;
                    end
                    marker_run_start[marker_index] <= '0;
                    marker_run_length[marker_index] <= '0;
                    marker_longest_start[marker_index] <= '0;
                    marker_longest_length[marker_index] <= '0;
                end
                x <= '0;
                y <= y + 1'b1;
            end

            if (!vsync_d && vsync) begin
                frame_done <= 1'b1;
                if (!tracking_active) begin
                    if (start_candidate_valid) begin
                        tracking_active <= 1'b1;
                        roi_valid <= 1'b1;
                        roi_x <= start_candidate_left;
                        roi_y <= start_candidate_top;
                        roi_width <= start_candidate_right - start_candidate_left + 1'b1;
                        roi_height <= start_candidate_bottom - start_candidate_top + 1'b1;
                        roi_tl_x <= final_left_top_x;
                        roi_tl_y <= start_tl_y;
                        roi_tr_x <= final_right_top_x;
                        roi_tr_y <= start_tr_y;
                        roi_br_x <= final_right_bottom_x;
                        roi_br_y <= start_br_y;
                        roi_bl_x <= final_left_bottom_x;
                        roi_bl_y <= start_bl_y;
                        anchor_tl_x <= final_left_top_x;
                        anchor_tl_y <= start_tl_y;
                        anchor_tr_x <= final_right_top_x;
                        anchor_tr_y <= start_tr_y;
                        anchor_br_x <= final_right_bottom_x;
                        anchor_br_y <= start_br_y;
                        anchor_bl_x <= final_left_bottom_x;
                        anchor_bl_y <= start_bl_y;
                    end
                end else if (bright_pixel_count <= full_off_max_pixels) begin
                    tracking_active <= 1'b0;
                    roi_valid <= 1'b0;
                end else if (candidate_plausible) begin
                    roi_valid <= 1'b1;
                    roi_x <= candidate_left;
                    roi_y <= candidate_top;
                    roi_width <= candidate_right - candidate_left + 1'b1;
                    roi_height <= candidate_bottom - candidate_top + 1'b1;
                    roi_tl_x <= marker_final_left[0];
                    roi_tl_y <= marker_final_top[0];
                    roi_tr_x <= marker_final_right[1];
                    roi_tr_y <= marker_final_top[1];
                    roi_br_x <= marker_final_right[2];
                    roi_br_y <= marker_final_bottom[2];
                    roi_bl_x <= marker_final_left[3];
                    roi_bl_y <= marker_final_bottom[3];
                end
            end
        end
    end

endmodule
