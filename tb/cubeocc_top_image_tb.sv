`timescale 1ns/1ps

// Same frame_list.txt / mem-streaming convention as
// roi_warp_grid_pipeline_image_tb.sv, but drives the full cubeocc_top
// (ROI detector -> projective warp -> 8x8 grid -> dynamic_threshold_sampler)
// so the classified 64-bit symbol word and the learned threshold can be
// reviewed against the actual captured images.
module cubeocc_top_image_tb;
    localparam int W = 160;
    localparam int H = 120;
    localparam int PIXELS = W * H;

    logic pclk = 1'b0, rst_n = 1'b0;
    logic cam_vsync = 1'b1, cam_href = 1'b0;
    logic [7:0] cam_gray = 8'd0;

    logic roi_valid, roi_tracking_active;
    logic [9:0] roi_x, roi_y, roi_width, roi_height;
    logic [9:0] roi_tl_x, roi_tl_y, roi_tr_x, roi_tr_y;
    logic [9:0] roi_br_x, roi_br_y, roi_bl_x, roi_bl_y;
    logic        symbols_valid;
    logic [63:0] symbols_data;

    logic [7:0] frame_mem [0:PIXELS-1];

    integer i, row, col, frame_index, emitted_index;
    integer list_file, frame_file, symbols_file, warped_file, parsed;
    string line, mem_path;

    always #5 pclk = ~pclk;

    cubeocc_top dut (
        .pclk(pclk), .rst_n(rst_n),
        .cam_vsync(cam_vsync), .cam_href(cam_href), .cam_pixel_data(cam_gray),
        .roi_valid(roi_valid), .roi_tracking_active(roi_tracking_active),
        .roi_x(roi_x), .roi_y(roi_y), .roi_width(roi_width), .roi_height(roi_height),
        .roi_tl_x(roi_tl_x), .roi_tl_y(roi_tl_y), .roi_tr_x(roi_tr_x), .roi_tr_y(roi_tr_y),
        .roi_br_x(roi_br_x), .roi_br_y(roi_br_y), .roi_bl_x(roi_bl_x), .roi_bl_y(roi_bl_y),
        .symbols_valid(symbols_valid), .symbols_data(symbols_data)
    );

    // Hierarchical, simulation-only taps. cubeocc_top does not forward these
    // as top-level ports (by design, to keep its interface small), but they
    // are real ports/signals on the u_pipeline / u_sampler instances, exactly
    // like the ones roi_warp_grid_pipeline_image_tb.sv already reads.
    wire        detector_frame_done_tap = dut.u_pipeline.detector_frame_done;
    wire        warp_vsync_tap          = dut.u_pipeline.warp_vsync;
    wire        warp_href_tap           = dut.u_pipeline.warp_href;
    wire [7:0]  warp_gray_tap           = dut.u_pipeline.warp_gray;
    wire [15:0] dynamic_thresh_tap      = dut.u_sampler.dynamic_thresh;
    wire [1:0]  sampler_state_tap       = dut.u_sampler.state;

    // Dump the rectified 160x120 warped stream, same convention as
    // roi_warp_grid_pipeline_image_tb.sv, so frames can be turned back into
    // PNGs for visual review.
    always @(posedge pclk) begin
        if (!warp_vsync_tap && warp_href_tap)
            $fwrite(warped_file, "%02x\n", warp_gray_tap);
    end

    task automatic reset_pipeline;
        begin
            @(negedge pclk); rst_n = 1'b0; cam_vsync = 1'b1; cam_href = 1'b0; cam_gray = 0;
            repeat (5) @(posedge pclk);
            @(negedge pclk); rst_n = 1'b1;
        end
    endtask

    task automatic send_frame;
        begin
            @(negedge pclk); cam_vsync = 1'b0;
            for (row = 0; row < H; row = row + 1) begin
                for (col = 0; col < W; col = col + 1) begin
                    @(negedge pclk); cam_href = 1'b1; cam_gray = frame_mem[row * W + col];
                end
                @(negedge pclk); cam_href = 1'b0; cam_gray = 0;
            end
            @(negedge pclk); cam_vsync = 1'b1;

            @(posedge detector_frame_done_tap); #1;
            $fwrite(frame_file, "%0d,%0d,%0d,%0d,%0d,%0d,%0d\n",
                frame_index, roi_valid, roi_tracking_active, roi_x, roi_y, roi_width, roi_height);

            if (roi_valid) begin
                @(posedge symbols_valid); #1;
                $fwrite(symbols_file, "%0d,%0d,%0d,%b\n",
                    frame_index, sampler_state_tap, dynamic_thresh_tap, symbols_data);
                emitted_index = emitted_index + 1;
            end
        end
    endtask

    initial begin
        list_file    = $fopen("frame_list.txt", "r");
        frame_file   = $fopen("pipeline_frames.csv", "w");
        symbols_file = $fopen("symbols_results.csv", "w");
        warped_file  = $fopen("warped_pixels.hex", "w");
        if (!list_file || !frame_file || !symbols_file || !warped_file)
            $fatal(1, "Cannot open cubeocc_top_image_tb output files");

        $fwrite(frame_file, "frame,roi_valid,tracking_active,roi_x,roi_y,roi_width,roi_height\n");
        // sampler_state: 0=IDLE, 1=LEARNING (this frame calibrated dynamic_thresh), 2=PROCESSING
        $fwrite(symbols_file, "frame,sampler_state,dynamic_thresh,symbols_data_binary\n");

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
        $fclose(list_file); $fclose(frame_file); $fclose(symbols_file); $fclose(warped_file);
        $display("CUBEOCC TOP IMAGE TB DONE: %0d frames, %0d symbol results emitted", frame_index, emitted_index);
        $finish;
    end
endmodule