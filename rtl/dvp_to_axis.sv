`timescale 1ns/1ps

// This module is SYNTHESIZABLE. It converts raw DVP camera signals
// into a standard AXI4-Stream video interface to feed the HLS pipeline.
module dvp_to_axis (
    input  logic        pclk,        // Camera Pixel Clock
    input  logic        rst_n,       // Async reset (active low)
    
    // DVP Camera Inputs
    input  logic        vsync,       // Frame valid (1=blanking, 0=active frame)
    input  logic        href,        // Line valid (1=active pixel data)
    input  logic [7:0]  pixel_data,  // Raw 8-bit pixel data
    
    // AXI4-Stream Master Outputs
    output logic [7:0]  m_axis_tdata,
    output logic        m_axis_tvalid,
    input  logic        m_axis_tready, // Driven by downstream HLS IP
    output logic        m_axis_tlast,  // End of line
    output logic        m_axis_tuser   // Start of frame
);

    // We delay signals by 1 clock to safely detect edges (like end of line)
    logic href_d;
    logic vsync_d;
    logic [7:0] data_d;
    logic sof_detected;

    always_ff @(posedge pclk or negedge rst_n) begin
        if (!rst_n) begin
            href_d <= 1'b0;
            vsync_d <= 1'b1; // Default high (blanking)
            data_d <= 8'd0;
            sof_detected <= 1'b0;
        end else begin
            href_d <= href;
            vsync_d <= vsync;
            data_d <= pixel_data;
            
            // Detect Start of Frame (falling edge of vsync: 1 -> 0)
            if (vsync_d == 1'b1 && vsync == 1'b0) begin
                sof_detected <= 1'b1;
            end
            
            // Clear SOF after the first valid pixel is sent
            if (m_axis_tvalid && m_axis_tready && m_axis_tuser) begin
                sof_detected <= 1'b0;
            end
        end
    end

    // AXI-Stream assignments
    // tvalid is high when delayed href is high (meaning data is valid)
    assign m_axis_tvalid = href_d;
    assign m_axis_tdata  = data_d;
    
    // tlast is high on the last pixel of a line
    // (current href is high, but the NEXT href will be low)
    assign m_axis_tlast  = (href_d == 1'b1 && href == 1'b0);
    
    // tuser is high only for the very first pixel of the frame
    assign m_axis_tuser  = sof_detected && href_d;

endmodule