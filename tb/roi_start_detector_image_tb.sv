`timescale 1ns/1ps

// Drives roi_start_detector from grayscale .mem images created by
// dataset/run_roi_rtl_sim.py. One XSim run processes one ordered capture set,
// so the START/DATA/full-off state is preserved across that set's frames.
module roi_start_detector_image_tb;
    localparam int FRAME_WIDTH = 160;
    localparam int FRAME_HEIGHT = 120;
    localparam int FRAME_PIXELS = FRAME_WIDTH * FRAME_HEIGHT;

    logic pclk = 1'b0;
    logic rst_n = 1'b0;
    logic vsync = 1'b1;
    logic href = 1'b0;
    logic [7:0] pixel_data = 8'd0;
    logic [7:0] bright_threshold = 8'd180;
    logic [9:0] min_line_run = 10'd8;
    logic [9:0] min_roi_height = 10'd4;
    logic roi_valid;
    logic tracking_active;
    logic frame_done;
    logic [9:0] roi_x, roi_width;
    logic [9:0] roi_y, roi_height;
    logic [9:0] roi_tl_x, roi_tr_x, roi_br_x, roi_bl_x;
    logic [9:0] roi_tl_y, roi_tr_y, roi_br_y, roi_bl_y;
    logic [7:0] frame_mem [0:FRAME_PIXELS-1];

    string file_list_path;
    string result_path;
    string mem_path;
    string line;
    integer list_file;
    integer result_file;
    integer parsed;
    integer frame_index;

    always #5 pclk = ~pclk;

    roi_start_detector #(.X_BITS(10), .Y_BITS(10), .MAX_ROW_GAP(2)) dut (
        .pclk,
        .rst_n,
        .vsync,
        .href,
        .pixel_data,
        .bright_threshold,
        .min_line_run,
        .min_roi_height,
        .full_off_max_pixels(32'd0),
        .roi_valid,
        .tracking_active,
        .frame_done,
        .roi_x,
        .roi_y,
        .roi_width,
        .roi_height,
        .roi_tl_x,
        .roi_tl_y,
        .roi_tr_x,
        .roi_tr_y,
        .roi_br_x,
        .roi_br_y,
        .roi_bl_x,
        .roi_bl_y
    );

    task automatic send_frame;
        integer row;
        integer col;
        integer pixel_index;
        begin
            @(negedge pclk);
            vsync = 1'b0;
            href = 1'b0;
            pixel_data = 8'd0;
            for (row = 0; row < FRAME_HEIGHT; row++) begin
                for (col = 0; col < FRAME_WIDTH; col++) begin
                    pixel_index = row * FRAME_WIDTH + col;
                    @(negedge pclk);
                    href = 1'b1;
                    pixel_data = frame_mem[pixel_index];
                end
                @(negedge pclk);
                href = 1'b0;
                pixel_data = 8'd0;
            end
            @(negedge pclk);
            vsync = 1'b1;
            @(posedge frame_done);
            #1;
        end
    endtask

    task automatic reset_tracker;
        begin
            @(negedge pclk);
            rst_n = 1'b0;
            vsync = 1'b1;
            href = 1'b0;
            pixel_data = 8'd0;
            repeat (4) @(posedge pclk);
            rst_n = 1'b1;
        end
    endtask

    task automatic write_result(input integer index);
        begin
            $fwrite(
                result_file,
                "%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d\n",
                index,
                roi_valid,
                tracking_active,
                roi_x,
                roi_y,
                roi_width,
                roi_height,
                roi_tl_x,
                roi_tl_y,
                roi_tr_x,
                roi_tr_y,
                roi_br_x,
                roi_br_y,
                roi_bl_x,
                roi_bl_y
            );
        end
    endtask

    initial begin
        // Vivado 2019.1's Windows wrapper does not preserve multiple runtime
        // plusargs reliably. The Python runner writes these fixed names in an
        // isolated build directory before each capture-set simulation.
        file_list_path = "frame_list.txt";
        result_path = "roi_results.csv";

        list_file = $fopen(file_list_path, "r");
        if (list_file == 0) begin
            $fatal(1, "Cannot open FILE_LIST: %s", file_list_path);
        end
        result_file = $fopen(result_path, "w");
        if (result_file == 0) begin
            $fatal(1, "Cannot write RESULT_FILE: %s", result_path);
        end
        $fwrite(result_file, "index,roi_valid,tracking_active,roi_x,roi_y,roi_width,roi_height,tl_x,tl_y,tr_x,tr_y,br_x,br_y,bl_x,bl_y\n");

        reset_tracker();
        frame_index = 0;
        while (!$feof(list_file)) begin
            line = "";
            void'($fgets(line, list_file));
            parsed = $sscanf(line, "%s", mem_path);
            if (parsed == 1) begin
                if (mem_path == "---") begin
                    reset_tracker();
                end else begin
                    $readmemh(mem_path, frame_mem);
                    send_frame();
                    write_result(frame_index);
                    frame_index = frame_index + 1;
                end
            end
        end
        $fclose(list_file);
        $fclose(result_file);
        $display("Result: ROI RTL IMAGE RUN PASS (%0d frames)", frame_index);
        $finish;
    end
endmodule
