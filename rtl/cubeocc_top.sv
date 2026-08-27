`timescale 1ns/1ps

module cubeocc_top (
    input  logic       pclk,
    input  logic       rst_n,

    input  logic       cam_vsync,
    input  logic       cam_href,
    input  logic [7:0] cam_pixel_data,

    output logic [7:0] m_axis_tdata,
    output logic       m_axis_tvalid,
    input  logic       m_axis_tready,
    output logic       m_axis_tlast,
    output logic       m_axis_tuser
);

    logic [7:0] axis_cam_tdata;
    logic       axis_cam_tvalid;
    logic       axis_cam_tready;
    logic       axis_cam_tlast;
    logic       axis_cam_tuser;

    // 1. DVP to AXI-Stream Bridge
    dvp_to_axis u_dvp_to_axis (
        .pclk(pclk),
        .rst_n(rst_n),
        .vsync(cam_vsync),
        .href(cam_href),
        .pixel_data(cam_pixel_data),
        .m_axis_tdata(axis_cam_tdata),
        .m_axis_tvalid(axis_cam_tvalid),
        .m_axis_tready(axis_cam_tready),
        .m_axis_tlast(axis_cam_tlast),
        .m_axis_tuser(axis_cam_tuser)
    );

    // 2. HLS Image Processing Module
    // The new HLS IP no longer has an AXI-Lite interface (ap_ctrl_none).
    // It free-runs directly on the camera stream.
    cubeocc_hls_0 u_cubeocc_hls (
        .ap_clk(pclk),
        .ap_rst_n(rst_n),
        
        // AXI4-Stream Input (from Camera)
        .s_axis_TVALID(axis_cam_tvalid),
        .s_axis_TREADY(axis_cam_tready),
        .s_axis_TDATA(axis_cam_tdata),
        .s_axis_TDEST(1'b0),
        .s_axis_TKEEP(1'b1),
        .s_axis_TSTRB(1'b1),
        .s_axis_TUSER(axis_cam_tuser),
        .s_axis_TLAST(axis_cam_tlast),
        .s_axis_TID(1'b0),
        
        // AXI4-Stream Output (to downstream)
        .m_axis_TVALID(m_axis_tvalid),
        .m_axis_TREADY(m_axis_tready),
        .m_axis_TDATA(m_axis_tdata),
        .m_axis_TDEST(),
        .m_axis_TKEEP(),
        .m_axis_TSTRB(),
        .m_axis_TUSER(m_axis_tuser),
        .m_axis_TLAST(m_axis_tlast),
        .m_axis_TID()
    );

endmodule