`timescale 1ns/1ps

module roi_start_detector_tb;
    logic pclk = 1'b0;
    logic rst_n = 1'b0;
    logic vsync = 1'b1;
    logic href = 1'b0;
    logic [7:0] pixel_data = 8'd0;
    logic roi_valid;
    logic frame_done;
    logic [9:0] roi_x;
    logic [9:0] roi_y;
    logic [9:0] roi_width;
    logic [9:0] roi_height;

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
        .roi_valid,
        .frame_done,
        .roi_x,
        .roi_y,
        .roi_width,
        .roi_height
    );

    task automatic send_frame;
        int row;
        int col;
        begin
            @(negedge pclk);
            vsync = 1'b0;
            href = 1'b0;
            pixel_data = 8'd0;
            for (row = 0; row < 48; row++) begin
                for (col = 0; col < 64; col++) begin
                    @(negedge pclk);
                    href = 1'b1;
                    // One-line reflection plus the tall sender START region.
                    pixel_data = ((row == 2 && col >= 20 && col <= 45) ||
                                  (row >= 8 && row <= 35 && col >= 10 && col <= 50)) ? 8'd255 : 8'd0;
                end
                @(negedge pclk);
                href = 1'b0;
                pixel_data = 8'd0;
            end
            @(negedge pclk);
            vsync = 1'b1;
        end
    endtask

    initial begin
        repeat (4) @(posedge pclk);
        rst_n = 1'b1;
        send_frame();
        @(posedge frame_done);
        $display("ROI x=%0d y=%0d width=%0d height=%0d", roi_x, roi_y, roi_width, roi_height);
        if (roi_valid && roi_x == 10 && roi_y == 8 && roi_width == 41 && roi_height == 28) begin
            $display("Result: ROI START DETECTOR PASS");
        end else begin
            $display("Result: ROI START DETECTOR FAIL");
        end
        $finish;
    end
endmodule
