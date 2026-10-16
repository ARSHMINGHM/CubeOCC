`timescale 1ns/1ps

// UART loopback test. Decoding and message reconstruction happen only here,
// outside the synthesized FPGA design.
module cubeocc_uart_stream_tb;
    localparam integer CLKS_PER_BIT = 8;
    localparam integer PACKET_BYTES = 15;
    localparam [55:0] EXPECTED_MESSAGE = 56'h437562654f4343; // "CubeOCC"

    logic clk = 0, rst_n = 0;
    logic frame_valid = 0;
    logic [2:0] frame_kind = 0;
    logic [63:0] frame_symbols = 0;
    logic frame_ready, tx, busy, overflow;
    logic [7:0] packet [0:PACKET_BYTES-1];
    logic [63:0] decoded_word;
    logic [58:0] decoded_payload;
    logic [55:0] decoded_message;
    integer packet_index, bit_index, cell_index, payload_index;
    integer failures = 0;
    logic [7:0] checksum;
    logic [63:0] data_word;

    always #5 clk = ~clk;

    cubeocc_uart_frame_streamer #(
        .CLOCK_HZ(80), .BAUD(10), .MODEL_ID(8'd2)
    ) dut (
        .clk(clk), .rst_n(rst_n), .frame_valid(frame_valid),
        .frame_kind(frame_kind), .frame_symbols(frame_symbols),
        .frame_ready(frame_ready), .tx(tx), .busy(busy), .overflow(overflow)
    );

    task automatic send_frame(input [2:0] kind, input [63:0] symbols);
        begin
            while (!frame_ready) @(posedge clk);
            @(negedge clk);
            frame_kind = kind;
            frame_symbols = symbols;
            frame_valid = 1;
            @(negedge clk);
            frame_valid = 0;
        end
    endtask

    task automatic receive_byte(output [7:0] value);
        integer sample_index;
        begin
            @(negedge tx);
            repeat (CLKS_PER_BIT + (CLKS_PER_BIT / 2)) @(posedge clk);
            for (sample_index = 0; sample_index < 8; sample_index = sample_index + 1) begin
                value[sample_index] = tx;
                repeat (CLKS_PER_BIT) @(posedge clk);
            end
            if (tx !== 1'b1) begin
                $display("UART stop-bit failure");
                failures = failures + 1;
            end
        end
    endtask

    task automatic receive_packet(input [2:0] expected_kind, input [7:0] expected_sequence);
        begin
            for (packet_index = 0; packet_index < PACKET_BYTES; packet_index = packet_index + 1)
                receive_byte(packet[packet_index]);

            if (packet[0] !== 8'hA5 || packet[1] !== 8'h5A ||
                packet[2] !== 8'd1 || packet[3] !== 8'd2 ||
                packet[4] !== expected_sequence || packet[5] !== {5'd0, expected_kind}) begin
                $display("UART header failure seq=%0d kind=%0d", packet[4], packet[5]);
                failures = failures + 1;
            end

            checksum = 0;
            for (packet_index = 2; packet_index <= 13; packet_index = packet_index + 1)
                checksum = checksum ^ packet[packet_index];
            if (checksum !== packet[14]) begin
                $display("UART checksum failure expected=%02h actual=%02h", checksum, packet[14]);
                failures = failures + 1;
            end

            decoded_word = {
                packet[6], packet[7], packet[8], packet[9],
                packet[10], packet[11], packet[12], packet[13]
            };
        end
    endtask

    initial begin
        data_word = 0;
        data_word[0] = 1;
        data_word[7] = 1;
        data_word[56] = 1;
        data_word[63] = 1;
        data_word[1] = 0; // configurable CLK cell at row 0, column 1
        payload_index = 58;
        bit_index = 55;
        for (cell_index = 0; cell_index < 64; cell_index = cell_index + 1) begin
            if (cell_index != 0 && cell_index != 1 && cell_index != 7 &&
                cell_index != 56 && cell_index != 63) begin
                data_word[cell_index] = (bit_index >= 0) ? EXPECTED_MESSAGE[bit_index] : 1'b0;
                bit_index = bit_index - 1;
                payload_index = payload_index - 1;
            end
        end

        repeat (5) @(posedge clk);
        rst_n = 1;

        fork
            begin
                send_frame(3'd1, 64'hffff_ffff_ffff_ffff);
                send_frame(3'd2, data_word);
                send_frame(3'd3, 64'h0100_0000_0000_0081);
            end
            begin
                receive_packet(3'd1, 8'd0);
                if (decoded_word !== 64'hffff_ffff_ffff_ffff) failures = failures + 1;

                receive_packet(3'd2, 8'd1);
                payload_index = 58;
                for (cell_index = 0; cell_index < 64; cell_index = cell_index + 1) begin
                    if (cell_index != 0 && cell_index != 1 && cell_index != 7 &&
                        cell_index != 56 && cell_index != 63) begin
                        decoded_payload[payload_index] = decoded_word[cell_index];
                        payload_index = payload_index - 1;
                    end
                end
                decoded_message = decoded_payload[58:3];
                if (decoded_message !== EXPECTED_MESSAGE) begin
                    $display("Decoded message mismatch: %014h", decoded_message);
                    failures = failures + 1;
                end

                receive_packet(3'd3, 8'd2);
                if (decoded_word !== 64'h0100_0000_0000_0081) failures = failures + 1;
            end
        join

        if (overflow) failures = failures + 1;
        $display("UART_STREAM_RESULT packets=3 message=CubeOCC failures=%0d", failures);
        if (failures != 0) $fatal(1, "UART stream regression failed");
        $finish;
    end
endmodule
