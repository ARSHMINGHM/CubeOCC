// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
// Date        : Tue Aug 25 23:02:59 2026
// Host        : ARSHMINGHM-LAPTOP running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/Users/arshm/Desktop/CubeOCC/vivado/CubeOCC/CubeOCC.srcs/sources_1/ip/cubeocc_hls_0/cubeocc_hls_0_stub.v
// Design      : cubeocc_hls_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "cubeocc_hls,Vivado 2019.1" *)
module cubeocc_hls_0(s_axi_CTRL_AWADDR, s_axi_CTRL_AWVALID, 
  s_axi_CTRL_AWREADY, s_axi_CTRL_WDATA, s_axi_CTRL_WSTRB, s_axi_CTRL_WVALID, 
  s_axi_CTRL_WREADY, s_axi_CTRL_BRESP, s_axi_CTRL_BVALID, s_axi_CTRL_BREADY, 
  s_axi_CTRL_ARADDR, s_axi_CTRL_ARVALID, s_axi_CTRL_ARREADY, s_axi_CTRL_RDATA, 
  s_axi_CTRL_RRESP, s_axi_CTRL_RVALID, s_axi_CTRL_RREADY, ap_clk, ap_rst_n, interrupt, 
  s_axis_TVALID, s_axis_TREADY, s_axis_TDATA, s_axis_TDEST, s_axis_TKEEP, s_axis_TSTRB, 
  s_axis_TUSER, s_axis_TLAST, s_axis_TID, m_axis_TVALID, m_axis_TREADY, m_axis_TDATA, 
  m_axis_TDEST, m_axis_TKEEP, m_axis_TSTRB, m_axis_TUSER, m_axis_TLAST, m_axis_TID)
/* synthesis syn_black_box black_box_pad_pin="s_axi_CTRL_AWADDR[5:0],s_axi_CTRL_AWVALID,s_axi_CTRL_AWREADY,s_axi_CTRL_WDATA[31:0],s_axi_CTRL_WSTRB[3:0],s_axi_CTRL_WVALID,s_axi_CTRL_WREADY,s_axi_CTRL_BRESP[1:0],s_axi_CTRL_BVALID,s_axi_CTRL_BREADY,s_axi_CTRL_ARADDR[5:0],s_axi_CTRL_ARVALID,s_axi_CTRL_ARREADY,s_axi_CTRL_RDATA[31:0],s_axi_CTRL_RRESP[1:0],s_axi_CTRL_RVALID,s_axi_CTRL_RREADY,ap_clk,ap_rst_n,interrupt,s_axis_TVALID,s_axis_TREADY,s_axis_TDATA[7:0],s_axis_TDEST[0:0],s_axis_TKEEP[0:0],s_axis_TSTRB[0:0],s_axis_TUSER[0:0],s_axis_TLAST[0:0],s_axis_TID[0:0],m_axis_TVALID,m_axis_TREADY,m_axis_TDATA[7:0],m_axis_TDEST[0:0],m_axis_TKEEP[0:0],m_axis_TSTRB[0:0],m_axis_TUSER[0:0],m_axis_TLAST[0:0],m_axis_TID[0:0]" */;
  input [5:0]s_axi_CTRL_AWADDR;
  input s_axi_CTRL_AWVALID;
  output s_axi_CTRL_AWREADY;
  input [31:0]s_axi_CTRL_WDATA;
  input [3:0]s_axi_CTRL_WSTRB;
  input s_axi_CTRL_WVALID;
  output s_axi_CTRL_WREADY;
  output [1:0]s_axi_CTRL_BRESP;
  output s_axi_CTRL_BVALID;
  input s_axi_CTRL_BREADY;
  input [5:0]s_axi_CTRL_ARADDR;
  input s_axi_CTRL_ARVALID;
  output s_axi_CTRL_ARREADY;
  output [31:0]s_axi_CTRL_RDATA;
  output [1:0]s_axi_CTRL_RRESP;
  output s_axi_CTRL_RVALID;
  input s_axi_CTRL_RREADY;
  input ap_clk;
  input ap_rst_n;
  output interrupt;
  input s_axis_TVALID;
  output s_axis_TREADY;
  input [7:0]s_axis_TDATA;
  input [0:0]s_axis_TDEST;
  input [0:0]s_axis_TKEEP;
  input [0:0]s_axis_TSTRB;
  input [0:0]s_axis_TUSER;
  input [0:0]s_axis_TLAST;
  input [0:0]s_axis_TID;
  output m_axis_TVALID;
  input m_axis_TREADY;
  output [7:0]m_axis_TDATA;
  output [0:0]m_axis_TDEST;
  output [0:0]m_axis_TKEEP;
  output [0:0]m_axis_TSTRB;
  output [0:0]m_axis_TUSER;
  output [0:0]m_axis_TLAST;
  output [0:0]m_axis_TID;
endmodule
