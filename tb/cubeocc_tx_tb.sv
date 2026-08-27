`timescale 1ns/1ps

module cubeocc_tx_tb;
    logic pclk, rst_n;
    logic tx_enable;
    logic [7:0] frame_id;
    logic frame_start, cam_vsync, cam_href;
    logic [7:0] cam_pixel_data;

    cubeocc_tx dut (
        .pclk(pclk), .rst_n(rst_n), .frame_id(frame_id), .tx_enable(tx_enable),
        .frame_start(frame_start), .cam_vsync(cam_vsync), 
        .cam_href(cam_href), .cam_pixel_data(cam_pixel_data)
    );

    initial pclk = 0;
    always #5 pclk = ~pclk; // 100 MHz

    integer r, c;
    logic [7:0] grid_mem [0:7][0:7];

    // Task to capture the 8x8 grid from the stream
    task automatic capture_grid(input int fid);
        begin
            $display("================================================================");
            $display(" Capturing Frame ID: %0d", fid);
            $display("================================================================");
            
            // Wait for frame to start
            @(posedge frame_start);
            @(negedge pclk); // slight delay
            
            for (r = 0; r < 8; r++) begin
                // Wait for the start of the line (cam_href goes high)
                while (!cam_href) @(negedge pclk);
                
                for (c = 0; c < 8; c++) begin
                    // We are in the active area. Read pixel.
                    grid_mem[r][c] = cam_pixel_data;
                    @(negedge pclk); // move to next pixel
                end
                
                // Skip the rest of the 128-pixel line
                while (cam_href) @(negedge pclk);
            end
            
            // Print the captured grid
            $display(" Grid 8x8 for Frame %0d:", fid);
            for (r = 0; r < 8; r++) begin
                $display(" %0d %0d %0d %0d %0d %0d %0d %0d", 
                    grid_mem[r][0], grid_mem[r][1], grid_mem[r][2], grid_mem[r][3],
                    grid_mem[r][4], grid_mem[r][5], grid_mem[r][6], grid_mem[r][7]);
            end
        end
    endtask

    initial begin
        rst_n = 0;
        tx_enable = 0;
        frame_id = 0;
        #20 rst_n = 1;
        #10 tx_enable = 1;

        // Generate and capture 4 frames
        capture_grid(0); // START
        frame_id = 1;
        capture_grid(1); // DATA0
        frame_id = 2;
        capture_grid(2); // DATA1
        frame_id = 3;
        capture_grid(3); // STOP

        $display("================================================================");
        $display(" TX Test Complete. Check grid patterns above.");
        $display("================================================================");
        $finish;
    end

endmodule