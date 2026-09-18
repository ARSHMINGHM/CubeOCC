`timescale 1ns/1ps

module camera2_roi_programmer_tb;
    logic clk=0, rst_n=0, roi_valid=0, i2c_busy=0, i2c_done=0, i2c_ack_error=0;
    logic [11:0] tl_x=120, tl_y=80, tr_x=519, tr_y=90, br_x=510, br_y=329, bl_x=110, bl_y=320;
    logic i2c_start, busy, stream_ready, error;
    logic [15:0] i2c_reg_addr, i2c_reg_data;
    logic [11:0] roi_x,roi_y,roi_width,roi_height;
    integer writes=0;
    logic [15:0] expected_addr[0:4];
    logic [15:0] expected_data[0:4];
    always #5 clk=~clk;

    camera2_roi_programmer dut(.*);

    always @(posedge clk) begin
        if (i2c_start) begin
            if (i2c_reg_addr !== expected_addr[writes] || i2c_reg_data !== expected_data[writes])
                $fatal(1,"write %0d got %h=%h expected %h=%h",writes,i2c_reg_addr,i2c_reg_data,expected_addr[writes],expected_data[writes]);
            writes <= writes+1;
            i2c_busy <= 1'b1;
        end else if (i2c_busy) begin
            i2c_busy <= 1'b0;
            i2c_done <= 1'b1;
        end else i2c_done <= 1'b0;
    end

    initial begin
        expected_addr[0]=16'h3800; expected_data[0]=16'd110;
        expected_addr[1]=16'h3802; expected_data[1]=16'd80;
        expected_addr[2]=16'h3804; expected_data[2]=16'd410;
        expected_addr[3]=16'h3806; expected_data[3]=16'd250;
        expected_addr[4]=16'h3008; expected_data[4]=16'h0001;
        repeat(4) @(posedge clk); rst_n=1;
        @(posedge clk); roi_valid<=1;
        @(posedge clk); roi_valid<=0;
        wait(stream_ready);
        if(writes!=5 || error) $fatal(1,"ROI programmer failed writes=%0d error=%0d",writes,error);
        $display("CAMERA2 ROI PROGRAMMER PASS: x=%0d y=%0d width=%0d height=%0d",roi_x,roi_y,roi_width,roi_height);
        $finish;
    end
endmodule
