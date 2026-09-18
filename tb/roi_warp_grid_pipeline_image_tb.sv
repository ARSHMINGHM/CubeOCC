`timescale 1ns/1ps

module roi_warp_grid_pipeline_image_tb;
    localparam int W = 160;
    localparam int H = 120;
    localparam int PIXELS = W * H;

    logic pclk = 1'b0, rst_n = 1'b0;
    logic cam_vsync = 1'b1, cam_href = 1'b0;
    logic [7:0] cam_gray = 8'd0;
    logic roi_valid, tracking_active, detector_frame_done;
    logic [9:0] roi_x, roi_y, roi_width, roi_height;
    logic [9:0] roi_tl_x, roi_tl_y, roi_tr_x, roi_tr_y;
    logic [9:0] roi_br_x, roi_br_y, roi_bl_x, roi_bl_y;
    logic warp_busy, warp_vsync, warp_href, warp_frame_done;
    logic [7:0] warp_gray;
    logic grid_pixel_valid, grid_frame_done;
    logic [7:0] grid_pixel_gray;
    logic [2:0] grid_col, grid_row;
    logic [5:0] grid_cell;
    logic [9:0] grid_pixel_x, grid_pixel_y;
    logic [7:0] frame_mem [0:PIXELS-1];

    integer min_x[0:63], min_y[0:63], max_x[0:63], max_y[0:63];
    integer count[0:63], sum_gray[0:63];
    integer i, row, col, frame_index, emitted_index;
    integer list_file, frame_file, grid_file, warped_file, parsed;
    string line, mem_path;

    always #5 pclk = ~pclk;

    roi_warp_grid_pipeline dut (
        .pclk, .rst_n, .cam_vsync, .cam_href, .cam_gray,
        .bright_threshold(8'd180), .min_line_run(10'd8),
        .min_roi_height(10'd4), .full_off_max_pixels(32'd0),
        .roi_valid, .tracking_active, .detector_frame_done,
        .roi_x, .roi_y, .roi_width, .roi_height,
        .roi_tl_x, .roi_tl_y, .roi_tr_x, .roi_tr_y,
        .roi_br_x, .roi_br_y, .roi_bl_x, .roi_bl_y,
        .warp_busy, .warp_vsync, .warp_href, .warp_gray, .warp_frame_done,
        .grid_pixel_valid, .grid_pixel_gray, .grid_col, .grid_row, .grid_cell,
        .grid_pixel_x, .grid_pixel_y, .grid_frame_done
    );

    always @(posedge pclk) begin
        if (!warp_vsync && warp_href)
            $fwrite(warped_file, "%02x\n", warp_gray);
        if (grid_pixel_valid) begin
            if (count[grid_cell] == 0) begin
                min_x[grid_cell] = grid_pixel_x; max_x[grid_cell] = grid_pixel_x;
                min_y[grid_cell] = grid_pixel_y; max_y[grid_cell] = grid_pixel_y;
            end else begin
                if (grid_pixel_x < min_x[grid_cell]) min_x[grid_cell] = grid_pixel_x;
                if (grid_pixel_y < min_y[grid_cell]) min_y[grid_cell] = grid_pixel_y;
                if (grid_pixel_x > max_x[grid_cell]) max_x[grid_cell] = grid_pixel_x;
                if (grid_pixel_y > max_y[grid_cell]) max_y[grid_cell] = grid_pixel_y;
            end
            count[grid_cell] = count[grid_cell] + 1;
            sum_gray[grid_cell] = sum_gray[grid_cell] + grid_pixel_gray;
        end
    end

    task automatic clear_stats;
        begin
            for (i = 0; i < 64; i = i + 1) begin
                min_x[i] = W; min_y[i] = H; max_x[i] = -1; max_y[i] = -1;
                count[i] = 0; sum_gray[i] = 0;
            end
        end
    endtask

    task automatic reset_pipeline;
        begin
            @(negedge pclk); rst_n = 1'b0; cam_vsync = 1'b1; cam_href = 1'b0; cam_gray = 0;
            repeat (5) @(posedge pclk);
            @(negedge pclk); rst_n = 1'b1;
        end
    endtask

    task automatic send_frame;
        begin
            clear_stats();
            @(negedge pclk); cam_vsync = 1'b0;
            for (row = 0; row < H; row = row + 1) begin
                for (col = 0; col < W; col = col + 1) begin
                    @(negedge pclk); cam_href = 1'b1; cam_gray = frame_mem[row * W + col];
                end
                @(negedge pclk); cam_href = 1'b0; cam_gray = 0;
            end
            @(negedge pclk); cam_vsync = 1'b1;
            @(posedge detector_frame_done); #1;
            $fwrite(frame_file,
                "%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d\n",
                frame_index, roi_valid, tracking_active, roi_x, roi_y, roi_width, roi_height,
                roi_tl_x, roi_tl_y, roi_tr_x, roi_tr_y, roi_br_x, roi_br_y, roi_bl_x, roi_bl_y,
                roi_valid);
            if (roi_valid) begin
                @(posedge grid_frame_done); repeat (2) @(posedge pclk);
                for (i = 0; i < 64; i = i + 1)
                    $fwrite(grid_file,
                        "%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d\n",
                        frame_index, i, i / 8, i % 8, min_x[i], min_y[i], max_x[i], max_y[i],
                        count[i], count[i] ? sum_gray[i] / count[i] : 0);
                emitted_index = emitted_index + 1;
            end
        end
    endtask

    initial begin
        list_file = $fopen("frame_list.txt", "r");
        frame_file = $fopen("pipeline_frames.csv", "w");
        grid_file = $fopen("grid_results.csv", "w");
        warped_file = $fopen("warped_pixels.hex", "w");
        if (!list_file || !frame_file || !grid_file || !warped_file)
            $fatal(1, "Cannot open direct-pipeline files");
        $fwrite(frame_file,
            "frame,roi_valid,tracking_active,roi_x,roi_y,roi_width,roi_height,tl_x,tl_y,tr_x,tr_y,br_x,br_y,bl_x,bl_y,grid_emitted\n");
        $fwrite(grid_file, "frame,cell,row,col,left,top,right,bottom,pixels,avg_gray\n");
        reset_pipeline(); frame_index = 0; emitted_index = 0;
        while (!$feof(list_file)) begin
            line = ""; void'($fgets(line, list_file)); parsed = $sscanf(line, "%s", mem_path);
            if (parsed == 1) begin
                if (mem_path == "---") begin
                    reset_pipeline();
                end else begin
                    $readmemh(mem_path, frame_mem);
                    send_frame(); frame_index = frame_index + 1;
                end
            end
        end
        $fclose(list_file); $fclose(frame_file); $fclose(grid_file); $fclose(warped_file);
        $display("DIRECT FPGA ROI + WARP + GRID PASS: %0d frames, %0d emitted", frame_index, emitted_index);
        $finish;
    end
endmodule
