`timescale 1ns/1ps

// Full-chain smoke test: camera raster -> ROI -> warp -> grid -> both models.
module cubeocc_dual_classifier_image_tb;
    localparam integer W = 160;
    localparam integer H = 120;
    localparam integer PIXELS = W * H;
    localparam integer FRAME_LIMIT = 13;

    logic pclk = 0, rst_n = 0;
    logic cam_vsync = 1, cam_href = 0;
    logic [7:0] cam_gray = 0;
    logic roi_valid, tracking;
    logic [9:0] roi_x, roi_y, roi_width, roi_height;
    logic [9:0] tl_x, tl_y, tr_x, tr_y, br_x, br_y, bl_x, bl_y;
    logic symbols_valid;
    logic [63:0] symbols_old, symbols_pca;
    logic [2:0] symbols_kind;
    logic [7:0] frame_mem [0:PIXELS-1];
    integer row, col, frame_index, list_file, result_file, parsed;
    string line, mem_path;

    always #5 pclk = ~pclk;

    cubeocc_dual_classifier_top dut (
        .pclk(pclk), .rst_n(rst_n), .cam_vsync(cam_vsync),
        .cam_href(cam_href), .cam_pixel_data(cam_gray),
        .roi_valid(roi_valid), .roi_tracking_active(tracking),
        .roi_x(roi_x), .roi_y(roi_y), .roi_width(roi_width), .roi_height(roi_height),
        .roi_tl_x(tl_x), .roi_tl_y(tl_y), .roi_tr_x(tr_x), .roi_tr_y(tr_y),
        .roi_br_x(br_x), .roi_br_y(br_y), .roi_bl_x(bl_x), .roi_bl_y(bl_y),
        .symbols_valid(symbols_valid), .symbols_old_poly(symbols_old),
        .symbols_pca30(symbols_pca), .symbols_kind(symbols_kind)
    );

    task automatic reset_dut;
        begin
            @(negedge pclk); rst_n = 0; cam_vsync = 1; cam_href = 0; cam_gray = 0;
            repeat (5) @(posedge pclk);
            @(negedge pclk); rst_n = 1;
        end
    endtask

    task automatic send_frame;
        begin
            @(negedge pclk); cam_vsync = 0;
            for (row = 0; row < H; row = row + 1) begin
                for (col = 0; col < W; col = col + 1) begin
                    @(negedge pclk); cam_href = 1; cam_gray = frame_mem[row*W+col];
                end
                @(negedge pclk); cam_href = 0; cam_gray = 0;
            end
            @(negedge pclk); cam_vsync = 1;
            @(posedge dut.u_pipeline.detector_frame_done); #1;
            if (roi_valid) begin
                @(posedge symbols_valid); #1;
                $fwrite(result_file, "%0d,%0d,%016h,%016h,%0d\n",
                        frame_index, roi_valid, symbols_old, symbols_pca, symbols_kind);
            end else begin
                $fwrite(result_file, "%0d,0,0000000000000000,0000000000000000,0\n", frame_index);
            end
        end
    endtask

    initial begin
        list_file = $fopen("frame_list.txt", "r");
        result_file = $fopen("dual_top_results.csv", "w");
        if (!list_file || !result_file) $fatal(1, "Cannot open smoke-test files");
        $fwrite(result_file, "frame,roi_valid,old_poly,pca30,kind\n");
        frame_index = 0;
        reset_dut();
        while (!$feof(list_file) && frame_index < FRAME_LIMIT) begin
            line = "";
            parsed = $fgets(line, list_file);
            parsed = $sscanf(line, "%s", mem_path);
            if (parsed == 1 && mem_path != "---") begin
                $readmemh(mem_path, frame_mem);
                send_frame();
                frame_index = frame_index + 1;
            end
        end
        $display("DUAL_TOP_SMOKE_RESULT frames=%0d", frame_index);
        $fclose(list_file);
        $fclose(result_file);
        $finish;
    end
endmodule
