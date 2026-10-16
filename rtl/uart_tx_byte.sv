`timescale 1ns/1ps

// 8-N-1 UART transmitter. CLKS_PER_BIT is a compile-time clock divider.
module uart_tx_byte #(
    parameter integer CLKS_PER_BIT = 868
) (
    input  logic       clk,
    input  logic       rst_n,
    input  logic [7:0] data,
    input  logic       valid,
    output logic       ready,
    output logic       tx,
    output logic       busy
);
    localparam integer COUNT_W = (CLKS_PER_BIT <= 2) ? 1 : $clog2(CLKS_PER_BIT);

    logic [COUNT_W-1:0] clock_count;
    logic [3:0] bit_index;
    logic [9:0] shift_register;

    assign ready = !busy;

    always @(posedge clk) begin
        if (!rst_n) begin
            tx <= 1'b1;
            busy <= 1'b0;
            clock_count <= 0;
            bit_index <= 0;
            shift_register <= 10'h3ff;
        end else if (!busy) begin
            tx <= 1'b1;
            if (valid) begin
                shift_register <= {1'b1, data, 1'b0};
                tx <= 1'b0;
                busy <= 1'b1;
                clock_count <= 0;
                bit_index <= 0;
            end
        end else if (clock_count == CLKS_PER_BIT - 1) begin
            clock_count <= 0;
            if (bit_index == 9) begin
                tx <= 1'b1;
                busy <= 1'b0;
            end else begin
                bit_index <= bit_index + 1'b1;
                tx <= shift_register[bit_index + 1'b1];
            end
        end else begin
            clock_count <= clock_count + 1'b1;
        end
    end
endmodule
