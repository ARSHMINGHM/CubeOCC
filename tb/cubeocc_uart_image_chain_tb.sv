`timescale 1ns/1ps

// Real-image full-chain regression: camera pixels through PCA30 classifier,
// one-pin UART serialization, and an external testbench packet decoder.
module cubeocc_uart_image_chain_tb;
    localparam integer W = 160;
    localparam integer H = 120;
    localparam integer PIXELS = W * H;
    localparam integer FRAME_COUNT = 13;
    localparam integer CLKS_PER_BIT = 8;

    logic pclk = 0, rst_n = 0;
    logic cam_vsync = 1, cam_href = 0;
    logic [7:0] cam_pixel_data = 0;
    logic uart_tx;
    logic [7:0] packet [0:14];
    logic [7:0] checksum;
    logic [63:0] decoded_word;
    logic [7:0] frame_mem [0:PIXELS-1];
    integer row, col, frame_index, packet_index, sample_index;
    integer list_file, parsed, failures = 0;
    string line, mem_path;

    always #5 pclk = ~pclk;

    cubeocc_uart_stream_top #(
        .CLASSIFIER_MODEL(2), .CLOCK_HZ(80), .UART_BAUD(10)
    ) dut (
        .pclk(pclk), .rst_n(rst_n), .cam_vsync(cam_vsync),
        .cam_href(cam_href), .cam_pixel_data(cam_pixel_data), .uart_tx(uart_tx)
    );

    function automatic [63:0] expected_word(input integer index);
        begin
            case (index)
                0: expected_word = 64'hffff_ffff_ffff_ffff;
                1: expected_word = 64'hcb32_7724_f530_b1a9;
                2: expected_word = 64'h8926_a64e_86c6_ce83;
                3: expected_word = 64'h8bd0_d4c4_c09e_c5e1;
                4: expected_word = 64'hb31a_9adb_db38_10af;
                5: expected_word = 64'hf773_0267_724f_13bd;
                6: expected_word = 64'hcf69_6660_4867_67b7;
                7: expected_word = 64'hd95c_085d_5dec_08a5;
                8: expected_word = 64'hf31d_bd89_8127_a9c3;
                9: expected_word = 64'he127_77b3_b6b0_21b9;
                10: expected_word = 64'hed96_162e_a6b6_f6e7;
                11: expected_word = 64'h8100_0000_000e_9ce5;
                default: expected_word = 64'h0100_0000_0000_0081;
            endcase
        end
    endfunction

    function automatic [2:0] expected_kind(input integer index);
        begin
            if (index == 0) expected_kind = 3'd1;
            else if (index == FRAME_COUNT - 1) expected_kind = 3'd3;
            else expected_kind = 3'd2;
        end
    endfunction

    task automatic receive_byte(output [7:0] value);
        begin
            @(negedge uart_tx);
            repeat (CLKS_PER_BIT + (CLKS_PER_BIT / 2)) @(posedge pclk);
            for (sample_index = 0; sample_index < 8; sample_index = sample_index + 1) begin
                value[sample_index] = uart_tx;
                repeat (CLKS_PER_BIT) @(posedge pclk);
            end
            if (uart_tx !== 1'b1) failures = failures + 1;
        end
    endtask

    task automatic receive_and_check_packet(input integer index);
        begin
            for (packet_index = 0; packet_index < 15; packet_index = packet_index + 1)
                receive_byte(packet[packet_index]);
            decoded_word = {
                packet[6], packet[7], packet[8], packet[9],
                packet[10], packet[11], packet[12], packet[13]
            };
            checksum = 0;
            for (packet_index = 2; packet_index <= 13; packet_index = packet_index + 1)
                checksum = checksum ^ packet[packet_index];
            if (packet[0] !== 8'hA5 || packet[1] !== 8'h5A ||
                packet[2] !== 8'd1 || packet[3] !== 8'd2 ||
                packet[4] !== index[7:0] || packet[5] !== {5'd0, expected_kind(index)} ||
                packet[14] !== checksum || decoded_word !== expected_word(index)) begin
                $display("UART image mismatch frame=%0d kind=%0d word=%016h", index, packet[5], decoded_word);
                failures = failures + 1;
            end
        end
    endtask

    task automatic send_camera_frame;
        begin
            @(negedge pclk); cam_vsync = 0;
            for (row = 0; row < H; row = row + 1) begin
                for (col = 0; col < W; col = col + 1) begin
                    @(negedge pclk); cam_href = 1; cam_pixel_data = frame_mem[row*W+col];
                end
                @(negedge pclk); cam_href = 0; cam_pixel_data = 0;
            end
            @(negedge pclk); cam_vsync = 1;
        end
    endtask

    initial begin
        list_file = $fopen("sim/dual_classifier_top_smoke/frame_list.txt", "r");
        if (!list_file) $fatal(1, "Cannot open real-image frame list");
        repeat (5) @(posedge pclk);
        @(negedge pclk); rst_n = 1;

        for (frame_index = 0; frame_index < FRAME_COUNT; frame_index = frame_index + 1) begin
            line = "";
            parsed = $fgets(line, list_file);
            parsed = $sscanf(line, "%s", mem_path);
            if (parsed != 1 || mem_path == "---") $fatal(1, "Bad frame-list entry %0d", frame_index);
            $readmemh(mem_path, frame_mem);
            send_camera_frame();
            receive_and_check_packet(frame_index);
        end

        $fclose(list_file);
        $display("UART_IMAGE_CHAIN_RESULT frames=13 packets=13 mismatches=%0d", failures);
        if (failures != 0) $fatal(1, "Full camera-to-UART regression failed");
        $finish;
    end
endmodule
