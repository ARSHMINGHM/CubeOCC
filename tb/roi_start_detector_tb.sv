`timescale 1ns/1ps

module roi_start_detector_tb;
    localparam int FRAME_WIDTH = 64;
    localparam int FRAME_HEIGHT = 48;

    logic pclk = 1'b0;
    logic rst_n = 1'b0;
    logic vsync = 1'b1;
    logic href = 1'b0;
    logic [7:0] pixel_data = 8'd0;
    logic roi_valid;
    logic tracking_active;
    logic frame_done;
    logic [9:0] roi_x, roi_width;
    logic [9:0] roi_y, roi_height;
    logic [9:0] roi_tl_x, roi_tr_x, roi_br_x, roi_bl_x;
    logic [9:0] roi_tl_y, roi_tr_y, roi_br_y, roi_bl_y;

    always #5 pclk = ~pclk;

    roi_start_detector #(.X_BITS(10), .Y_BITS(10), .MAX_ROW_GAP(2)) dut (
        .pclk,
        .rst_n,
        .vsync,
        .href,
        .pixel_data,
        .bright_threshold(8'd180),
        .min_line_run(10'd20),
        .min_roi_height(10'd12),
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

    task automatic send_pixels(input int frame_kind);
        int row;
        int col;
        bit is_start;
        bit is_data_marker;
        bit is_payload;
        bit is_outlier;
        bit is_tiny_noise;
        bit is_marker_shift6;
        bit is_marker_shift12;
        begin
            @(negedge pclk);
            vsync = 1'b0;
            href = 1'b0;
            pixel_data = 8'd0;
            for (row = 0; row < FRAME_HEIGHT; row++) begin
                for (col = 0; col < FRAME_WIDTH; col++) begin
                    @(negedge pclk);
                    href = 1'b1;
                    is_start = (row >= 8 && row <= 35 && col >= 10 && col <= 50);
                    is_data_marker = ((row >= 8 && row <= 12 && col >= 10 && col <= 15) ||
                                      (row >= 8 && row <= 12 && col >= 45 && col <= 50) ||
                                      (row >= 31 && row <= 35 && col >= 45 && col <= 50) ||
                                      (row >= 31 && row <= 35 && col >= 10 && col <= 15));
                    is_payload = (row >= 16 && row <= 22 && col >= 24 && col <= 31);
                    is_outlier = (row >= 2 && row <= 7 && col >= 54 && col <= 59);
                    is_tiny_noise = (row >= 5 && row <= 6 && col >= 7 && col <= 8);
                    is_marker_shift6 = ((row >= 14 && row <= 18 && col >= 16 && col <= 21) ||
                                        (row >= 14 && row <= 18 && col >= 39 && col <= 44) ||
                                        (row >= 25 && row <= 29 && col >= 39 && col <= 44) ||
                                        (row >= 25 && row <= 29 && col >= 16 && col <= 21));
                    is_marker_shift12 = ((row >= 20 && row <= 24 && col >= 22 && col <= 27) ||
                                         (row >= 20 && row <= 24 && col >= 33 && col <= 38) ||
                                         (row >= 19 && row <= 23 && col >= 33 && col <= 38) ||
                                         (row >= 19 && row <= 23 && col >= 22 && col <= 27));
                    case (frame_kind)
                        0: pixel_data = is_start ? 8'd255 : 8'd0;                         // START
                        1: pixel_data = (is_data_marker || is_payload) ? 8'd255 : 8'd0;   // DATA
                        2: pixel_data = is_outlier ? 8'd255 : 8'd0;                       // bad DATA
                        5: pixel_data = (is_data_marker || is_payload || is_tiny_noise) ? 8'd255 : 8'd0;
                        6: pixel_data = (is_marker_shift6 || is_payload) ? 8'd255 : 8'd0;
                        7: pixel_data = (is_marker_shift12 || is_payload) ? 8'd255 : 8'd0;
                        4: pixel_data = (row >= 8 && row <= 35 &&
                                          col >= 10 + ((row - 8) >> 2) &&
                                          col <= 50 + ((row - 8) >> 2)) ? 8'd255 : 8'd0;     // angled START
                        default: pixel_data = 8'd0;                                        // full-off
                    endcase
                end
                @(negedge pclk);
                href = 1'b0;
                pixel_data = 8'd0;
            end
            @(negedge pclk);
            vsync = 1'b1;
        end
    endtask

    task automatic wait_for_frame;
        begin
            @(posedge frame_done);
            #1;
        end
    endtask

    initial begin
        repeat (4) @(posedge pclk);
        rst_n = 1'b1;

        send_pixels(0);
        wait_for_frame();
        if (!tracking_active || !roi_valid || roi_x != 10 || roi_y != 8 || roi_width != 41 || roi_height != 28) begin
            $display("Result: FAIL START acquisition");
            $finish;
        end

        send_pixels(1);
        wait_for_frame();
        if (!tracking_active || !roi_valid || roi_tl_x != 10 || roi_tl_y != 8 || roi_br_x != 50 || roi_br_y != 35) begin
            $display("Result: FAIL DATA outside-corner update");
            $finish;
        end

        send_pixels(5);
        wait_for_frame();
        if (!tracking_active || !roi_valid || roi_tl_x != 10 || roi_tl_y != 8 || roi_br_x != 50 || roi_br_y != 35) begin
            $display("Result: FAIL tiny-noise box rejection");
            $finish;
        end

        send_pixels(6);
        wait_for_frame();
        if (!tracking_active || !roi_valid || roi_tl_x != 16 || roi_tl_y != 14 || roi_br_x != 44 || roi_br_y != 29) begin
            $display("Result: FAIL in-tolerance anchor movement");
            $finish;
        end

        send_pixels(7);
        wait_for_frame();
        if (!tracking_active || !roi_valid || roi_tl_x != 16 || roi_tl_y != 14 || roi_br_x != 44 || roi_br_y != 29) begin
            $display("Result: FAIL cumulative anchor drift rejection");
            $finish;
        end

        send_pixels(2);
        wait_for_frame();
        if (!tracking_active || !roi_valid || roi_tl_x != 16 || roi_tl_y != 14 || roi_br_x != 44 || roi_br_y != 29) begin
            $display("Result: FAIL prior-ROI hold");
            $finish;
        end

        send_pixels(3);
        wait_for_frame();
        if (tracking_active || roi_valid) begin
            $display("Result: FAIL full-off stop");
            $finish;
        end

        send_pixels(1);
        wait_for_frame();
        if (tracking_active || roi_valid) begin
            $display("Result: FAIL idle DATA ignore");
            $finish;
        end

        send_pixels(0);
        wait_for_frame();
        if (tracking_active && roi_valid && roi_x == 10 && roi_y == 8 && roi_width == 41 && roi_height == 28) begin
            $display("Result: ROI PROTOCOL TRACKER PASS");
        end else begin
            $display("Result: FAIL START reacquisition");
            $finish;
        end

        send_pixels(3);
        wait_for_frame();
        send_pixels(4);
        wait_for_frame();
        if (tracking_active && roi_valid &&
            roi_tl_x == 10 && roi_tl_y == 8 && roi_tr_x == 56 && roi_tr_y == 8 &&
            roi_br_x == 56 && roi_br_y == 35 && roi_bl_x == 10 && roi_bl_y == 35) begin
            $display("Result: ANGLED START CORNER PASS");
        end else begin
            $display("Result: FAIL angled START corners TL=(%0d,%0d) TR=(%0d,%0d) BR=(%0d,%0d) BL=(%0d,%0d)",
                roi_tl_x, roi_tl_y, roi_tr_x, roi_tr_y,
                roi_br_x, roi_br_y, roi_bl_x, roi_bl_y);
        end
        $finish;
    end
endmodule
