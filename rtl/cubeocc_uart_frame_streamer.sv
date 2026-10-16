`timescale 1ns/1ps

// Converts each classified CubeOCC frame into one fixed-length UART packet.
// Packet: A5 5A version model sequence kind symbols[63:0] checksum.
module cubeocc_uart_frame_streamer #(
    parameter integer CLOCK_HZ = 100_000_000,
    parameter integer BAUD = 115_200,
    parameter [7:0] MODEL_ID = 8'd2
) (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        frame_valid,
    input  logic [2:0]  frame_kind,
    input  logic [63:0] frame_symbols,
    output logic        frame_ready,
    output logic        tx,
    output logic        busy,
    output logic        overflow
);
    localparam integer CLKS_PER_BIT = (CLOCK_HZ + (BAUD / 2)) / BAUD;
    localparam [7:0] PROTOCOL_VERSION = 8'd1;

    logic active;
    logic [3:0] byte_index;
    logic [7:0] packet_sequence;
    logic [7:0] latched_sequence;
    logic [7:0] latched_kind;
    logic [63:0] latched_symbols;
    logic [7:0] latched_checksum;
    logic [7:0] uart_data;
    logic uart_valid, uart_ready, uart_busy;

    function automatic [7:0] packet_checksum(
        input [7:0] seq_value,
        input [7:0] kind,
        input [63:0] symbols
    );
        integer index;
        reg [7:0] value;
        begin
            value = PROTOCOL_VERSION ^ MODEL_ID ^ seq_value ^ kind;
            for (index = 0; index < 8; index = index + 1)
                value = value ^ symbols[index*8 +: 8];
            packet_checksum = value;
        end
    endfunction

    always @* begin
        case (byte_index)
            4'd0:  uart_data = 8'hA5;
            4'd1:  uart_data = 8'h5A;
            4'd2:  uart_data = PROTOCOL_VERSION;
            4'd3:  uart_data = MODEL_ID;
            4'd4:  uart_data = latched_sequence;
            4'd5:  uart_data = latched_kind;
            4'd6:  uart_data = latched_symbols[63:56];
            4'd7:  uart_data = latched_symbols[55:48];
            4'd8:  uart_data = latched_symbols[47:40];
            4'd9:  uart_data = latched_symbols[39:32];
            4'd10: uart_data = latched_symbols[31:24];
            4'd11: uart_data = latched_symbols[23:16];
            4'd12: uart_data = latched_symbols[15:8];
            4'd13: uart_data = latched_symbols[7:0];
            default: uart_data = latched_checksum;
        endcase
    end

    assign frame_ready = !active;
    assign uart_valid = active;
    assign busy = active || uart_busy;

    uart_tx_byte #(.CLKS_PER_BIT(CLKS_PER_BIT)) u_uart_tx (
        .clk(clk), .rst_n(rst_n), .data(uart_data), .valid(uart_valid),
        .ready(uart_ready), .tx(tx), .busy(uart_busy)
    );

    always @(posedge clk) begin
        if (!rst_n) begin
            active <= 1'b0;
            byte_index <= 0;
            packet_sequence <= 0;
            latched_sequence <= 0;
            latched_kind <= 0;
            latched_symbols <= 0;
            latched_checksum <= 0;
            overflow <= 1'b0;
        end else begin
            if (frame_valid && !frame_ready)
                overflow <= 1'b1;

            if (frame_valid && frame_ready) begin
                active <= 1'b1;
                byte_index <= 0;
                latched_sequence <= packet_sequence;
                latched_kind <= {5'd0, frame_kind};
                latched_symbols <= frame_symbols;
                latched_checksum <= packet_checksum(
                    packet_sequence, {5'd0, frame_kind}, frame_symbols);
                packet_sequence <= packet_sequence + 1'b1;
            end else if (active && uart_ready) begin
                if (byte_index == 14) begin
                    active <= 1'b0;
                    byte_index <= 0;
                end else begin
                    byte_index <= byte_index + 1'b1;
                end
            end
        end
    end
endmodule
