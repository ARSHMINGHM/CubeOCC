`timescale 1ns/1ps

module directional_dual_polynomial_sampler_tb;
    logic clk = 0;
    logic rst_n = 0;
    logic grid_pixel_valid = 0;
    logic [7:0] grid_pixel_gray = 0;
    logic [5:0] grid_cell = 0;
    logic [2:0] grid_col = 0, grid_row = 0;
    logic [9:0] grid_pixel_x = 0, grid_pixel_y = 0;
    logic grid_frame_done = 0, roi_valid = 1;
    logic guard_frame_checked = 0, guard_start = 0, guard_data_valid = 0;
    logic guard_end = 0, guard_discarded = 0;
    logic results_valid;
    logic [63:0] symbols_old_poly, symbols_pca30;
    logic [2:0] symbols_kind;

    integer input_file, parsed, sum_value;
    integer frames, failures, cell_idx, x, y, quotient, remainder, emitted;
    integer expected_kind;
    reg [63:0] expected_old, expected_pca;
    reg [7:0] pixel;
    reg [31:0] cell_sum [0:63];
    string token;

    always #5 clk = ~clk;

    directional_dual_polynomial_sampler dut (
        .clk(clk), .rst_n(rst_n),
        .grid_pixel_valid(grid_pixel_valid), .grid_pixel_gray(grid_pixel_gray),
        .grid_cell(grid_cell), .grid_col(grid_col), .grid_row(grid_row),
        .grid_pixel_x(grid_pixel_x), .grid_pixel_y(grid_pixel_y),
        .grid_frame_done(grid_frame_done), .roi_valid(roi_valid),
        .guard_frame_checked(guard_frame_checked), .guard_start(guard_start),
        .guard_data_valid(guard_data_valid), .guard_end(guard_end),
        .guard_discarded(guard_discarded), .results_valid(results_valid),
        .results_ready(1'b1), .symbols_old_poly(symbols_old_poly),
        .symbols_pca30(symbols_pca30), .symbols_kind(symbols_kind)
    );

    task automatic reset_dut;
        begin
            @(negedge clk); rst_n = 0; grid_pixel_valid = 0; grid_frame_done = 0;
            guard_frame_checked = 0;
            repeat (4) @(posedge clk);
            @(negedge clk); rst_n = 1;
        end
    endtask

    task automatic send_frame;
        integer index;
        begin
            for (cell_idx = 0; cell_idx < 64; cell_idx = cell_idx + 1) begin
                quotient = cell_sum[cell_idx] / 81;
                remainder = cell_sum[cell_idx] % 81;
                index = 0;
                for (y = 0; y < 15; y = y + 1)
                    for (x = 0; x < 20; x = x + 1)
                        if (((x-10)*(x-10) + (y-7)*(y-7)) <= 25) begin
                            pixel = quotient + ((index < remainder) ? 1 : 0);
                            @(negedge clk);
                            grid_pixel_valid = 1;
                            grid_pixel_gray = pixel;
                            grid_cell = cell_idx;
                            grid_row = cell_idx >> 3;
                            grid_col = cell_idx & 7;
                            grid_pixel_x = (cell_idx & 7) * 20 + x;
                            grid_pixel_y = (cell_idx >> 3) * 15 + y;
                            index = index + 1;
                        end
            end
            @(negedge clk);
            grid_pixel_valid = 0;
            grid_frame_done = 1;
            guard_frame_checked = 1;
            guard_start = (expected_kind == 1);
            guard_data_valid = (expected_kind == 2);
            guard_end = (expected_kind == 3);
            @(negedge clk);
            grid_frame_done = 0;
            guard_frame_checked = 0;
            guard_start = 0;
            guard_data_valid = 0;
            guard_end = 0;
            wait (results_valid);
            #1;
            if (symbols_kind !== expected_kind[2:0] ||
                symbols_old_poly !== expected_old || symbols_pca30 !== expected_pca) begin
                failures = failures + 1;
                $display("FAIL frame=%0d kind=%0d/%0d old=%016h/%016h pca=%016h/%016h",
                         frames, symbols_kind, expected_kind, symbols_old_poly, expected_old,
                         symbols_pca30, expected_pca);
            end
            frames = frames + 1;
            @(posedge clk);
        end
    endtask

    initial begin
        input_file = $fopen("rtl/generated/dual_sampler_vectors.txt", "r");
        if (!input_file) $fatal(1, "Cannot open dual_sampler_vectors.txt");
        frames = 0; failures = 0; emitted = 0;
        reset_dut();
        while (!$feof(input_file)) begin
            token = "";
            parsed = $fscanf(input_file, "%s", token);
            if (parsed == 1 && token == "R") begin
                reset_dut();
            end else if (parsed == 1 && token == "F") begin
                parsed = $fscanf(input_file, "%d %h %h", expected_kind, expected_old, expected_pca);
                if (parsed != 3) $fatal(1, "Malformed frame header");
                for (cell_idx = 0; cell_idx < 64; cell_idx = cell_idx + 1) begin
                    parsed = $fscanf(input_file, "%d", sum_value);
                    if (parsed != 1) $fatal(1, "Malformed cell sum");
                    cell_sum[cell_idx] = sum_value;
                end
                send_frame();
            end else if (parsed == 1 && token.substr(0, 0) == "#") begin
                parsed = $fgets(token, input_file);
            end
        end
        $fclose(input_file);
        $display("DUAL_SAMPLER_RESULT frames=%0d failures=%0d", frames, failures);
        if (failures != 0) $fatal(1, "Dual sampler regression failed");
        $finish;
    end
endmodule
