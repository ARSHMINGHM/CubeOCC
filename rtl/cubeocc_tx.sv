`timescale 1ns/1ps

// CubeOCC Transmitter (Frame Generator)
module cubeocc_tx (
    input  logic       pclk,
    input  logic       rst_n,
    input  logic [7:0] frame_id, // 0: START, 1: DATA0, 2: DATA1, 3: STOP
    input  logic       tx_enable,
    output logic       frame_start, // Pulse high at the beginning of a new frame
    output logic       cam_vsync,
    output logic       cam_href,
    output logic [7:0] cam_pixel_data
);

    localparam GRID_W = 8;
    localparam GRID_H = 8;
    localparam IMG_W  = 128;
    localparam IMG_H  = 720;

    int row_cnt;
    int col_cnt;

    // Generate frame timing
    always_ff @(posedge pclk or negedge rst_n) begin
        if (!rst_n) begin
            row_cnt <= 0;
            col_cnt <= 0;
            cam_vsync <= 1;
            cam_href  <= 0;
            frame_start <= 0;
        end else if (tx_enable) begin
            frame_start <= 0;
            cam_vsync <= 0; // Active low during frame
            
            if (cam_href) begin
                // We are in active pixel area
                if (col_cnt == IMG_W - 1) begin
                    // End of line
                    col_cnt <= 0;
                    cam_href <= 0;
                    if (row_cnt == IMG_H - 1) begin
                        // End of frame
                        row_cnt <= 0;
                        cam_vsync <= 1; // Blank period
                        frame_start <= 1; // Pulse for next frame
                    end else begin
                        row_cnt <= row_cnt + 1;
                    end
                end else begin
                    col_cnt <= col_cnt + 1;
                end
            end else begin
                // Blanking period between lines (or start of frame)
                col_cnt <= 0;
                cam_href <= 1; // Start new line
            end
        end
    end

    // Generate 8x8 Grid Pattern
    function automatic logic [7:0] get_grid_pixel(input int row, input int col, input int fid);
        logic is_corner = (row == 0 || row == 7) && (col == 0 || col == 7);
        logic is_clk = (row == 0 && col == 1); // Clock at row 0, col 1
        
        if (fid == 0) begin
            // START: All white
            return 8'd255;
        end else if (fid == 3) begin
            // STOP: 3 corners white (TL, TR, BL), BR black, CLK black
            if (is_corner && !(row == 7 && col == 7)) 
                return 8'd255;
            else 
                return 8'd0;
        end else begin
            // DATA frames
            if (is_corner) return 8'd255;
            if (is_clk && fid == 2) return 8'd255; // CLK toggles in frame 2
            return 8'd0;
        end
    endfunction

    // Output pixel data
    always_comb begin
        if (tx_enable && cam_href) begin
            if (row_cnt < GRID_H && col_cnt < GRID_W) begin
                cam_pixel_data = get_grid_pixel(row_cnt, col_cnt, frame_id);
            end else begin
                cam_pixel_data = 8'd0; // Black background
            end
        end else begin
            cam_pixel_data = 8'd0;
        end
    end

endmodule