`timescale 1ns/1ps

// Same frame_list.txt / mem-streaming convention as
// roi_warp_grid_pipeline_image_tb.sv, but drives the full cubeocc_top
// (ROI detector -> projective warp -> 8x8 grid -> linear_rule_sampler)
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
    logic [2:0]  symbols_kind;

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
        .symbols_valid(symbols_valid), .symbols_data(symbols_data), .symbols_kind(symbols_kind)
    );

    // Hierarchical, simulation-only taps. cubeocc_top does not forward these
    // as top-level ports (by design, to keep its interface small), but they
    // are real ports/signals on the u_pipeline / u_sampler instances, exactly
    // like the ones roi_warp_grid_pipeline_image_tb.sv already reads.
    wire        detector_frame_done_tap = dut.u_pipeline.detector_frame_done;
    wire        warp_vsync_tap          = dut.u_pipeline.warp_vsync;
    wire        warp_href_tap           = dut.u_pipeline.warp_href;
    wire [7:0]  warp_gray_tap           = dut.u_pipeline.warp_gray;
    // Removed: linear_rule_sampler has no dynamic_thresh / state.
    // Kept as constants so downstream $display / CSV columns still compile.
    wire [15:0] dynamic_thresh_tap      = 16'd0;
    wire [1:0]  sampler_state_tap       = 2'd0;

    // grid_corner_frame_guard outputs, consumed by linear_rule_sampler and
    // also logged here for frame-kind diagnostics.
    wire        g_transfer_active_tap = dut.u_pipeline.guard_transfer_active;
    wire        g_start_learned_tap   = dut.u_pipeline.guard_start_learned;
    wire        g_data_valid_tap      = dut.u_pipeline.guard_data_valid;
    wire        g_discarded_tap       = dut.u_pipeline.guard_frame_discarded;
    wire        g_end_detected_tap    = dut.u_pipeline.guard_end_detected;
    wire        g_ignored_tap         = dut.u_pipeline.guard_frame_ignored;
    wire [2:0]  g_discard_reason_tap  = dut.u_pipeline.guard_discard_reason;
    wire [7:0]  g_learned_white_tap   = dut.u_pipeline.guard_learned_white;
    wire [7:0]  g_white_thresh_tap    = dut.u_pipeline.guard_white_threshold;
    wire [7:0]  g_tl_tap              = dut.u_pipeline.guard_tl_average;
    wire [7:0]  g_tr_tap              = dut.u_pipeline.guard_tr_average;
    wire [7:0]  g_bl_tap              = dut.u_pipeline.guard_bl_average;
    wire [7:0]  g_br_tap              = dut.u_pipeline.guard_br_average;

    // Threshold/state the sampler actually used to classify the frame.
    // Sampled on the same edge where the sampler sees grid_frame_done, i.e.
    // before its non-blocking update of dynamic_thresh/state. The
    // dynamic_thresh/state columns logged after symbols_valid are the values
    // AFTER that update, so on the learning frame they differ from these.
    // Removed: linear_rule_sampler has no such registers.
    // Kept as constants so existing $display and CSV code compiles.
    logic [15:0] thresh_used = 16'd0;
    logic [1:0]  state_used  = 2'd0;

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
                // Guard pulses/levels are registered on the same grid_frame_done
                // edge as symbols_valid, so they are stable here.
                $fwrite(symbols_file, "%0d,%0d,%0d,%b,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d\n",
                    frame_index, sampler_state_tap, dynamic_thresh_tap, symbols_data,
                    state_used, thresh_used,
                    g_transfer_active_tap, g_start_learned_tap, g_data_valid_tap,
                    g_discarded_tap, g_end_detected_tap, g_ignored_tap,
                    g_discard_reason_tap, g_learned_white_tap, g_white_thresh_tap,
                    g_tl_tap, g_tr_tap, g_bl_tap, g_br_tap,
                    symbols_kind);
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
        // sampler_state / dynamic_thresh: values AFTER the sampler's frame_done update
        //   (state 0=IDLE, 1=LEARNING, 2=PROCESSING; the learning frame already shows 2).
        // state_used / thresh_used: values the sampler really classified this frame with.
        // g_*: grid_corner_frame_guard outputs for the same frame.
        $fwrite(symbols_file, "frame,sampler_state,dynamic_thresh,symbols_data_binary,state_used,thresh_used,g_transfer_active,g_start_learned,g_data_valid,g_discarded,g_end_detected,g_ignored,g_discard_reason,g_learned_white,g_white_threshold,g_tl,g_tr,g_bl,g_br,symbols_kind\n");

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
