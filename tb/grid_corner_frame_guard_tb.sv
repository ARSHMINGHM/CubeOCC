`timescale 1ns/1ps

module grid_corner_frame_guard_tb;
    localparam int CELL_PIXELS = 4;
    localparam int FRAME_PIXELS = 64 * CELL_PIXELS;

    logic pclk = 1'b0;
    logic rst_n = 1'b0;
    logic grid_pixel_valid = 1'b0;
    logic [7:0] grid_pixel_gray = 8'd0;
    logic [5:0] grid_cell = 6'd0;
    logic grid_frame_done = 1'b0;
    logic transfer_active, frame_checked, start_frame_learned;
    logic data_frame_valid, frame_discarded, end_frame_detected, frame_ignored;
    logic [2:0] discard_reason;
    logic [7:0] learned_white_level, dynamic_white_threshold;
    logic [7:0] corner_tl_average, corner_tr_average;
    logic [7:0] corner_bl_average, corner_br_average;
    logic [7:0] cells [0:63];
    integer cell_index, sample;
    logic saw_start, saw_valid, saw_discard, saw_end;

    always #5 pclk = ~pclk;

    grid_corner_frame_guard #(
        .CELL_PIXELS(CELL_PIXELS), .FRAME_PIXELS(FRAME_PIXELS),
        .START_MIN_AVG(96), .MIN_WHITE_THRESHOLD(48)
    ) dut (.*);

    always @(posedge pclk) begin
        if (start_frame_learned) saw_start <= 1'b1;
        if (data_frame_valid) saw_valid <= 1'b1;
        if (frame_discarded) saw_discard <= 1'b1;
        if (end_frame_detected) saw_end <= 1'b1;
    end

    task automatic send_cells;
        begin
            saw_start = 1'b0; saw_valid = 1'b0; saw_discard = 1'b0; saw_end = 1'b0;
            for (cell_index = 0; cell_index < 64; cell_index = cell_index + 1)
                for (sample = 0; sample < CELL_PIXELS; sample = sample + 1) begin
                    @(negedge pclk);
                    grid_pixel_valid = 1'b1;
                    grid_cell = cell_index[5:0];
                    grid_pixel_gray = cells[cell_index];
                end
            @(negedge pclk);
            grid_pixel_valid = 1'b0;
            grid_frame_done = 1'b1;
            @(negedge pclk);
            grid_frame_done = 1'b0;
            repeat (2) @(posedge pclk);
        end
    endtask

    task automatic fill(input logic [7:0] value);
        begin
            for (cell_index = 0; cell_index < 64; cell_index = cell_index + 1)
                cells[cell_index] = value;
        end
    endtask

    initial begin
        repeat (4) @(posedge pclk);
        @(negedge pclk); rst_n = 1'b1;

        fill(8'd200);
        send_cells();
        if (!saw_start || !transfer_active || learned_white_level != 200 || dynamic_white_threshold != 125)
            $fatal(1, "START calibration failed: active=%0d white=%0d threshold=%0d",
                transfer_active, learned_white_level, dynamic_white_threshold);

        fill(8'd40);
        cells[0] = 180; cells[7] = 175; cells[56] = 170; cells[63] = 165;
        send_cells();
        if (!saw_valid || saw_discard)
            $fatal(1, "valid DATA frame was not accepted");

        fill(8'd40);
        cells[0] = 180; cells[7] = 175; cells[56] = 170; cells[63] = 80;
        send_cells();
        if (!saw_discard || saw_valid || discard_reason != 3)
            $fatal(1, "dark-corner DATA frame was not discarded");

        fill(8'd0);
        cells[0] = 180; cells[7] = 175; cells[56] = 170; cells[63] = 0;
        send_cells();
        if (!saw_end || transfer_active)
            $fatal(1, "END frame was not detected");

        $display("GRID CORNER FRAME GUARD PASS");
        $finish;
    end
endmodule
