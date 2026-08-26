`timescale 1ns/1ps

// Fully Standard I2C Master with inout SDA and ACK handling.
module i2c_master #(
    parameter SYS_CLK_FREQ = 100_000_000,
    parameter I2C_CLK_FREQ = 400_000
)(
    input  logic        clk,
    input  logic        rst_n,
    input  logic        start,
    input  logic [15:0] reg_addr,
    input  logic [15:0] reg_data,
    output logic        busy,
    output logic        done,
    output logic        ack_error,
    output logic        scl,
    inout               sda
);

    localparam CLK_DIV = SYS_CLK_FREQ / (I2C_CLK_FREQ * 4);
    localparam SLAVE_ADDR = 8'h78;

    typedef enum logic [3:0] {
        IDLE,
        START,
        SEND_BIT,
        WAIT_HIGH,
        STOP_LOW,
        STOP_HIGH,
        DONE_STATE
    } state_e;

    state_e state;
    logic [15:0] clk_cnt;
    logic [3:0]  bit_cnt; 
    logic [7:0]  shift_reg;
    logic [7:0]  data_arr [0:4];
    logic [2:0]  byte_idx;
    
    logic sda_o;
    logic sda_oe;
    assign sda = sda_oe ? sda_o : 1'bz;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            busy <= 0;
            done <= 0;
            ack_error <= 0;
            scl <= 1;
            sda_o <= 1;
            sda_oe <= 0;
            clk_cnt <= 0;
            bit_cnt <= 0;
            shift_reg <= 0;
            byte_idx <= 0;
        end else begin
            case (state)
                IDLE: begin
                    busy <= 0;
                    done <= 0;
                    scl <= 1;
                    sda_o <= 1;
                    sda_oe <= 0; // High-Z
                    clk_cnt <= 0;
                    if (start) begin
                        busy <= 1;
                        ack_error <= 0;
                        data_arr[0] <= SLAVE_ADDR;
                        data_arr[1] <= reg_addr[15:8];
                        data_arr[2] <= reg_addr[7:0];
                        data_arr[3] <= reg_data[15:8];
                        data_arr[4] <= reg_data[7:0];
                        byte_idx <= 0;
                        shift_reg <= SLAVE_ADDR;
                        state <= START;
                    end
                end

                START: begin
                    sda_oe <= 1;
                    sda_o <= 0; // SDA goes low while SCL is high (Start)
                    if (clk_cnt == CLK_DIV/2 - 1) begin
                        scl <= 0; // Pull SCL low
                        clk_cnt <= 0;
                        bit_cnt <= 0;
                        state <= SEND_BIT;
                    end else begin
                        clk_cnt <= clk_cnt + 1;
                    end
                end

                SEND_BIT: begin
                    sda_oe <= 1;
                    if (clk_cnt == 0) begin
                        if (bit_cnt < 8) begin
                            sda_o <= shift_reg[7];
                            shift_reg <= shift_reg << 1;
                        end else begin
                            sda_oe <= 0; // Release SDA for ACK
                            sda_o <= 1;
                        end
                    end
                    
                    if (clk_cnt == CLK_DIV - 1) begin
                        clk_cnt <= 0;
                        scl <= 1; // SCL goes high
                        state <= WAIT_HIGH;
                    end else begin
                        clk_cnt <= clk_cnt + 1;
                    end
                end

                WAIT_HIGH: begin
                    if (bit_cnt == 8 && clk_cnt == CLK_DIV/2) begin
                        ack_error <= ack_error | sda;
                    end

                    if (clk_cnt == CLK_DIV - 1) begin
                        clk_cnt <= 0;
                        scl <= 0; // SCL goes low
                        if (bit_cnt == 8) begin
                            // ACK bit just finished
                            bit_cnt <= 0;
                            if (ack_error) begin
                                state <= STOP_LOW;
                            end else if (byte_idx < 4) begin
                                byte_idx <= byte_idx + 1;
                                shift_reg <= data_arr[byte_idx + 1];
                                state <= SEND_BIT;
                            end else begin
                                state <= STOP_LOW;
                            end
                        end else begin
                            bit_cnt <= bit_cnt + 1;
                            state <= SEND_BIT;
                        end
                    end else begin
                        clk_cnt <= clk_cnt + 1;
                    end
                end

                STOP_LOW: begin
                    sda_oe <= 1;
                    if (clk_cnt == 0) begin
                        sda_o <= 0;
                    end
                    if (clk_cnt == CLK_DIV - 1) begin
                        clk_cnt <= 0;
                        scl <= 1; // SCL goes high
                        state <= STOP_HIGH;
                    end else begin
                        clk_cnt <= clk_cnt + 1;
                    end
                end

                STOP_HIGH: begin
                    if (clk_cnt == 0) begin
                        sda_o <= 1; // SDA goes high (Stop condition)
                    end
                    if (clk_cnt == CLK_DIV - 1) begin
                        clk_cnt <= 0;
                        state <= DONE_STATE;
                    end else begin
                        clk_cnt <= clk_cnt + 1;
                    end
                end

                DONE_STATE: begin
                    done <= 1;
                    busy <= 0;
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule
