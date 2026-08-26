`timescale 1ns/1ps

module i2c_camera_slave_model #(
    parameter logic [6:0] I2C_ADDR = 7'h3c
)(
    input  logic        rst_n,
    input  logic        scl,
    inout               sda,

    output logic        reg_wr_en,
    output logic [15:0] reg_addr,
    output logic [15:0] reg_wdata
);

    logic sda_drive_low;
    assign sda = sda_drive_low ? 1'b0 : 1'bz;

    logic active;
    logic addr_ok;
    logic rw_bit;
    logic [3:0] bit_cnt;
    logic [2:0] byte_idx;
    logic [7:0] shift_reg;
    logic [7:0] bytes [0:4];

    task automatic clear_bus_state;
        begin
            active = 1'b0;
            addr_ok = 1'b0;
            rw_bit = 1'b0;
            bit_cnt = 4'd0;
            byte_idx = 3'd0;
            shift_reg = 8'd0;
            sda_drive_low = 1'b0;
        end
    endtask

    initial begin
        reg_wr_en = 1'b0;
        reg_addr = 16'd0;
        reg_wdata = 16'd0;
        clear_bus_state();
    end

    always @(negedge rst_n) begin
        reg_wr_en <= 1'b0;
        reg_addr <= 16'd0;
        reg_wdata <= 16'd0;
        clear_bus_state();
    end

    always @(negedge sda) begin
        if (rst_n && scl) begin
            active = 1'b1;
            addr_ok = 1'b0;
            rw_bit = 1'b0;
            bit_cnt = 4'd0;
            byte_idx = 3'd0;
            shift_reg = 8'd0;
            sda_drive_low = 1'b0;
            reg_wr_en <= 1'b0;
        end
    end

    always @(posedge scl) begin
        if (rst_n && active) begin
            if (bit_cnt < 8) begin
                shift_reg = {shift_reg[6:0], sda};
                bit_cnt = bit_cnt + 1'b1;
            end else begin
                bytes[byte_idx] = shift_reg;

                if (byte_idx == 0) begin
                    addr_ok = (shift_reg[7:1] == I2C_ADDR);
                    rw_bit = shift_reg[0];
                end

                byte_idx = byte_idx + 1'b1;
                bit_cnt = 4'd0;
                shift_reg = 8'd0;
            end
        end
    end

    always @(negedge scl) begin
        if (!rst_n) begin
            sda_drive_low = 1'b0;
        end else if (active) begin
            if (bit_cnt == 8) begin
                if (byte_idx == 0) begin
                    sda_drive_low = ({shift_reg[7:1]} == I2C_ADDR) && (shift_reg[0] == 1'b0);
                end else begin
                    sda_drive_low = addr_ok && !rw_bit && (byte_idx < 5);
                end
            end else begin
                sda_drive_low = 1'b0;
            end
        end else begin
            sda_drive_low = 1'b0;
        end
    end

    always @(posedge sda) begin
        if (rst_n && scl && active) begin
            sda_drive_low = 1'b0;
            if (addr_ok && !rw_bit && byte_idx == 5) begin
                reg_addr <= {bytes[1], bytes[2]};
                reg_wdata <= {bytes[3], bytes[4]};
                reg_wr_en <= 1'b1;
                $display(" [I2C SLAVE] ACK write: Addr=0x%04X, Data=0x%04X",
                         {bytes[1], bytes[2]}, {bytes[3], bytes[4]});
                #20 reg_wr_en <= 1'b0;
            end
            active = 1'b0;
        end
    end

endmodule
