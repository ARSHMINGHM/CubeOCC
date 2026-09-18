`timescale 1ns/1ps

module grayscale_grid_8x8_image_tb;
    localparam int FRAME_WIDTH = 160;
    localparam int FRAME_HEIGHT = 120;
    localparam int FRAME_PIXELS = FRAME_WIDTH * FRAME_HEIGHT;

    logic pclk = 1'b0, rst_n = 1'b0;
    logic in_vsync = 1'b1, in_href = 1'b0;
    logic [7:0] in_gray = 8'd0;
    logic [9:0] tl_x, tr_x, br_x, bl_x, tl_y, tr_y, br_y, bl_y;
    logic warp_busy, warp_vsync, warp_href, warp_done;
    logic [7:0] warp_gray;
    logic grid_pixel_valid, grid_frame_done;
    logic [7:0] grid_pixel_gray;
    logic [2:0] grid_col, grid_row;
    logic [5:0] grid_cell;
    logic [9:0] pixel_x, pixel_y;
    logic [7:0] frame_mem [0:FRAME_PIXELS-1];

    integer min_x [0:63]; integer min_y [0:63];
    integer max_x [0:63]; integer max_y [0:63];
    integer count [0:63]; integer sum_gray [0:63];
    integer i, frame_index, list_file, result_file, warped_file, parsed;
    integer tl_x_i, tl_y_i, tr_x_i, tr_y_i, br_x_i, br_y_i, bl_x_i, bl_y_i;
    string file_list_path, result_path, warped_path, mem_path;

    always #5 pclk = ~pclk;

    perspective_warp_160x120 warp (
        .pclk, .rst_n, .in_vsync, .in_href, .in_gray,
        .rectify_enable(1'b1),
        .tl_x, .tl_y, .tr_x, .tr_y, .br_x, .br_y, .bl_x, .bl_y,
        .busy(warp_busy), .out_vsync(warp_vsync), .out_href(warp_href),
        .out_gray(warp_gray), .out_frame_done(warp_done)
    );

    grayscale_grid_8x8 grid (
        .pclk, .rst_n, .vsync(warp_vsync), .href(warp_href),
        .pixel_gray(warp_gray), .frame_width(10'(FRAME_WIDTH)),
        .frame_height(10'(FRAME_HEIGHT)), .grid_pixel_valid,
        .grid_pixel_gray, .grid_col, .grid_row, .grid_cell,
        .pixel_x, .pixel_y, .frame_done(grid_frame_done)
    );

    always @(posedge pclk) begin
        if (!warp_vsync && warp_href)
            $fwrite(warped_file, "%02x\n", warp_gray);
        if (grid_pixel_valid) begin
            if (count[grid_cell] == 0) begin
                min_x[grid_cell] = pixel_x; max_x[grid_cell] = pixel_x;
                min_y[grid_cell] = pixel_y; max_y[grid_cell] = pixel_y;
            end else begin
                if (pixel_x < min_x[grid_cell]) min_x[grid_cell] = pixel_x;
                if (pixel_y < min_y[grid_cell]) min_y[grid_cell] = pixel_y;
                if (pixel_x > max_x[grid_cell]) max_x[grid_cell] = pixel_x;
                if (pixel_y > max_y[grid_cell]) max_y[grid_cell] = pixel_y;
            end
            count[grid_cell] = count[grid_cell] + 1;
            sum_gray[grid_cell] = sum_gray[grid_cell] + grid_pixel_gray;
        end
    end

    task automatic clear_results;
        begin
            for (i = 0; i < 64; i = i + 1) begin
                min_x[i] = FRAME_WIDTH; min_y[i] = FRAME_HEIGHT;
                max_x[i] = -1; max_y[i] = -1; count[i] = 0; sum_gray[i] = 0;
            end
        end
    endtask

    task automatic send_frame;
        integer row, col;
        begin
            clear_results();
            @(negedge pclk); in_vsync = 1'b0;
            for (row = 0; row < FRAME_HEIGHT; row = row + 1) begin
                for (col = 0; col < FRAME_WIDTH; col = col + 1) begin
                    @(negedge pclk); in_href = 1'b1;
                    in_gray = frame_mem[row * FRAME_WIDTH + col];
                end
                @(negedge pclk); in_href = 1'b0; in_gray = 8'd0;
            end
            @(negedge pclk); in_vsync = 1'b1;
            @(posedge grid_frame_done);
            repeat (2) @(posedge pclk);
        end
    endtask

    initial begin
        if (!$value$plusargs("FILE_LIST=%s", file_list_path)) file_list_path = "frame_list.txt";
        if (!$value$plusargs("RESULT=%s", result_path)) result_path = "grid_results.csv";
        if (!$value$plusargs("WARPED=%s", warped_path)) warped_path = "warped_pixels.hex";
        list_file = $fopen(file_list_path, "r");
        result_file = $fopen(result_path, "w");
        warped_file = $fopen(warped_path, "w");
        if (!list_file || !result_file || !warped_file) $fatal(1, "Cannot open warp/grid files");
        $fwrite(result_file, "frame,cell,row,col,left,top,right,bottom,pixels,avg_gray\n");
        repeat (4) @(posedge pclk); rst_n = 1'b1; frame_index = 0;
        while (!$feof(list_file)) begin
            parsed = $fscanf(list_file, "%s %d %d %d %d %d %d %d %d\n", mem_path,
                tl_x_i, tl_y_i, tr_x_i, tr_y_i, br_x_i, br_y_i, bl_x_i, bl_y_i);
            if (parsed == 9) begin
                tl_x = tl_x_i; tl_y = tl_y_i; tr_x = tr_x_i; tr_y = tr_y_i;
                br_x = br_x_i; br_y = br_y_i; bl_x = bl_x_i; bl_y = bl_y_i;
                $readmemh(mem_path, frame_mem);
                send_frame();
                for (i = 0; i < 64; i = i + 1)
                    $fwrite(result_file, "%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d\n",
                        frame_index, i, i / 8, i % 8, min_x[i], min_y[i], max_x[i], max_y[i], count[i],
                        count[i] ? sum_gray[i] / count[i] : 0);
                frame_index = frame_index + 1;
            end
        end
        $fclose(list_file); $fclose(result_file); $fclose(warped_file);
        $display("FPGA WARP + GRAYSCALE GRID PASS: %0d frame(s)", frame_index);
        $finish;
    end
endmodule
