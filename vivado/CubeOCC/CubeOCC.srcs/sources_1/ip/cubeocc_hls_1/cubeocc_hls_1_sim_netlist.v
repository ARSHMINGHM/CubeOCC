// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
// Date        : Tue Aug 25 23:02:59 2026
// Host        : ARSHMINGHM-LAPTOP running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top cubeocc_hls_1 -prefix
//               cubeocc_hls_1_ cubeocc_hls_0_sim_netlist.v
// Design      : cubeocc_hls_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* C_S_AXI_CTRL_ADDR_WIDTH = "6" *) (* C_S_AXI_CTRL_DATA_WIDTH = "32" *) (* C_S_AXI_CTRL_WSTRB_WIDTH = "4" *) 
(* C_S_AXI_DATA_WIDTH = "32" *) (* C_S_AXI_WSTRB_WIDTH = "4" *) (* ap_ST_fsm_pp0_stage0 = "3'b010" *) 
(* ap_ST_fsm_state1 = "3'b001" *) (* ap_ST_fsm_state5 = "3'b100" *) (* hls_module = "yes" *) 
module cubeocc_hls_1_cubeocc_hls
   (ap_clk,
    ap_rst_n,
    s_axis_TDATA,
    s_axis_TVALID,
    s_axis_TREADY,
    s_axis_TKEEP,
    s_axis_TSTRB,
    s_axis_TUSER,
    s_axis_TLAST,
    s_axis_TID,
    s_axis_TDEST,
    m_axis_TDATA,
    m_axis_TVALID,
    m_axis_TREADY,
    m_axis_TKEEP,
    m_axis_TSTRB,
    m_axis_TUSER,
    m_axis_TLAST,
    m_axis_TID,
    m_axis_TDEST,
    s_axi_CTRL_AWVALID,
    s_axi_CTRL_AWREADY,
    s_axi_CTRL_AWADDR,
    s_axi_CTRL_WVALID,
    s_axi_CTRL_WREADY,
    s_axi_CTRL_WDATA,
    s_axi_CTRL_WSTRB,
    s_axi_CTRL_ARVALID,
    s_axi_CTRL_ARREADY,
    s_axi_CTRL_ARADDR,
    s_axi_CTRL_RVALID,
    s_axi_CTRL_RREADY,
    s_axi_CTRL_RDATA,
    s_axi_CTRL_RRESP,
    s_axi_CTRL_BVALID,
    s_axi_CTRL_BREADY,
    s_axi_CTRL_BRESP,
    interrupt);
  input ap_clk;
  input ap_rst_n;
  input [7:0]s_axis_TDATA;
  input s_axis_TVALID;
  output s_axis_TREADY;
  input [0:0]s_axis_TKEEP;
  input [0:0]s_axis_TSTRB;
  input [0:0]s_axis_TUSER;
  input [0:0]s_axis_TLAST;
  input [0:0]s_axis_TID;
  input [0:0]s_axis_TDEST;
  output [7:0]m_axis_TDATA;
  output m_axis_TVALID;
  input m_axis_TREADY;
  output [0:0]m_axis_TKEEP;
  output [0:0]m_axis_TSTRB;
  output [0:0]m_axis_TUSER;
  output [0:0]m_axis_TLAST;
  output [0:0]m_axis_TID;
  output [0:0]m_axis_TDEST;
  input s_axi_CTRL_AWVALID;
  output s_axi_CTRL_AWREADY;
  input [5:0]s_axi_CTRL_AWADDR;
  input s_axi_CTRL_WVALID;
  output s_axi_CTRL_WREADY;
  input [31:0]s_axi_CTRL_WDATA;
  input [3:0]s_axi_CTRL_WSTRB;
  input s_axi_CTRL_ARVALID;
  output s_axi_CTRL_ARREADY;
  input [5:0]s_axi_CTRL_ARADDR;
  output s_axi_CTRL_RVALID;
  input s_axi_CTRL_RREADY;
  output [31:0]s_axi_CTRL_RDATA;
  output [1:0]s_axi_CTRL_RRESP;
  output s_axi_CTRL_BVALID;
  input s_axi_CTRL_BREADY;
  output [1:0]s_axi_CTRL_BRESP;
  output interrupt;

  wire \<const0> ;
  wire \ap_CS_fsm[2]_i_1_n_1 ;
  wire \ap_CS_fsm[2]_i_2_n_1 ;
  wire ap_CS_fsm_pp0_stage0;
  wire \ap_CS_fsm_reg_n_1_[0] ;
  wire ap_CS_fsm_state5;
  wire ap_NS_fsm1;
  wire ap_block_pp0_stage0_subdone3_in;
  wire ap_clk;
  wire ap_done;
  wire ap_enable_reg_pp0_iter0;
  wire ap_enable_reg_pp0_iter1_i_1_n_1;
  wire ap_enable_reg_pp0_iter1_reg_n_1;
  wire ap_enable_reg_pp0_iter2_reg_n_1;
  wire ap_rst_n;
  wire ap_rst_n_inv;
  wire cubeocc_hls_CTRL_s_axi_U_n_4;
  wire cubeocc_hls_CTRL_s_axi_U_n_49;
  wire cubeocc_hls_CTRL_s_axi_U_n_50;
  wire cubeocc_hls_CTRL_s_axi_U_n_53;
  wire i_0_reg_143;
  wire \i_0_reg_143[0]_i_2_n_1 ;
  wire \i_0_reg_143[0]_i_4_n_1 ;
  wire [30:0]i_0_reg_143_reg;
  wire \i_0_reg_143_reg[0]_i_3_n_1 ;
  wire \i_0_reg_143_reg[0]_i_3_n_2 ;
  wire \i_0_reg_143_reg[0]_i_3_n_3 ;
  wire \i_0_reg_143_reg[0]_i_3_n_4 ;
  wire \i_0_reg_143_reg[0]_i_3_n_5 ;
  wire \i_0_reg_143_reg[0]_i_3_n_6 ;
  wire \i_0_reg_143_reg[0]_i_3_n_7 ;
  wire \i_0_reg_143_reg[0]_i_3_n_8 ;
  wire \i_0_reg_143_reg[12]_i_1_n_1 ;
  wire \i_0_reg_143_reg[12]_i_1_n_2 ;
  wire \i_0_reg_143_reg[12]_i_1_n_3 ;
  wire \i_0_reg_143_reg[12]_i_1_n_4 ;
  wire \i_0_reg_143_reg[12]_i_1_n_5 ;
  wire \i_0_reg_143_reg[12]_i_1_n_6 ;
  wire \i_0_reg_143_reg[12]_i_1_n_7 ;
  wire \i_0_reg_143_reg[12]_i_1_n_8 ;
  wire \i_0_reg_143_reg[16]_i_1_n_1 ;
  wire \i_0_reg_143_reg[16]_i_1_n_2 ;
  wire \i_0_reg_143_reg[16]_i_1_n_3 ;
  wire \i_0_reg_143_reg[16]_i_1_n_4 ;
  wire \i_0_reg_143_reg[16]_i_1_n_5 ;
  wire \i_0_reg_143_reg[16]_i_1_n_6 ;
  wire \i_0_reg_143_reg[16]_i_1_n_7 ;
  wire \i_0_reg_143_reg[16]_i_1_n_8 ;
  wire \i_0_reg_143_reg[20]_i_1_n_1 ;
  wire \i_0_reg_143_reg[20]_i_1_n_2 ;
  wire \i_0_reg_143_reg[20]_i_1_n_3 ;
  wire \i_0_reg_143_reg[20]_i_1_n_4 ;
  wire \i_0_reg_143_reg[20]_i_1_n_5 ;
  wire \i_0_reg_143_reg[20]_i_1_n_6 ;
  wire \i_0_reg_143_reg[20]_i_1_n_7 ;
  wire \i_0_reg_143_reg[20]_i_1_n_8 ;
  wire \i_0_reg_143_reg[24]_i_1_n_1 ;
  wire \i_0_reg_143_reg[24]_i_1_n_2 ;
  wire \i_0_reg_143_reg[24]_i_1_n_3 ;
  wire \i_0_reg_143_reg[24]_i_1_n_4 ;
  wire \i_0_reg_143_reg[24]_i_1_n_5 ;
  wire \i_0_reg_143_reg[24]_i_1_n_6 ;
  wire \i_0_reg_143_reg[24]_i_1_n_7 ;
  wire \i_0_reg_143_reg[24]_i_1_n_8 ;
  wire \i_0_reg_143_reg[28]_i_1_n_3 ;
  wire \i_0_reg_143_reg[28]_i_1_n_4 ;
  wire \i_0_reg_143_reg[28]_i_1_n_6 ;
  wire \i_0_reg_143_reg[28]_i_1_n_7 ;
  wire \i_0_reg_143_reg[28]_i_1_n_8 ;
  wire \i_0_reg_143_reg[4]_i_1_n_1 ;
  wire \i_0_reg_143_reg[4]_i_1_n_2 ;
  wire \i_0_reg_143_reg[4]_i_1_n_3 ;
  wire \i_0_reg_143_reg[4]_i_1_n_4 ;
  wire \i_0_reg_143_reg[4]_i_1_n_5 ;
  wire \i_0_reg_143_reg[4]_i_1_n_6 ;
  wire \i_0_reg_143_reg[4]_i_1_n_7 ;
  wire \i_0_reg_143_reg[4]_i_1_n_8 ;
  wire \i_0_reg_143_reg[8]_i_1_n_1 ;
  wire \i_0_reg_143_reg[8]_i_1_n_2 ;
  wire \i_0_reg_143_reg[8]_i_1_n_3 ;
  wire \i_0_reg_143_reg[8]_i_1_n_4 ;
  wire \i_0_reg_143_reg[8]_i_1_n_5 ;
  wire \i_0_reg_143_reg[8]_i_1_n_6 ;
  wire \i_0_reg_143_reg[8]_i_1_n_7 ;
  wire \i_0_reg_143_reg[8]_i_1_n_8 ;
  wire icmp_ln17_fu_158_p2;
  wire icmp_ln17_reg_232;
  wire \icmp_ln17_reg_232[0]_i_1_n_1 ;
  wire icmp_ln17_reg_232_pp0_iter1_reg;
  wire \icmp_ln17_reg_232_pp0_iter1_reg[0]_i_1_n_1 ;
  wire interrupt;
  wire [7:0]m_axis_TDATA;
  wire [0:0]m_axis_TDEST;
  wire [0:0]m_axis_TID;
  wire [0:0]m_axis_TKEEP;
  wire [0:0]m_axis_TLAST;
  wire m_axis_TREADY;
  wire [0:0]m_axis_TSTRB;
  wire [0:0]m_axis_TUSER;
  wire m_axis_TVALID;
  wire m_axis_V_data_V_1_ack_in;
  wire m_axis_V_data_V_1_load_A;
  wire m_axis_V_data_V_1_load_B;
  wire [7:0]m_axis_V_data_V_1_payload_A;
  wire [7:0]m_axis_V_data_V_1_payload_B;
  wire m_axis_V_data_V_1_sel;
  wire m_axis_V_data_V_1_sel_rd_i_1_n_1;
  wire m_axis_V_data_V_1_sel_wr;
  wire m_axis_V_data_V_1_sel_wr_i_1_n_1;
  wire [1:1]m_axis_V_data_V_1_state;
  wire \m_axis_V_data_V_1_state[0]_i_1_n_1 ;
  wire \m_axis_V_data_V_1_state_reg_n_1_[0] ;
  wire m_axis_V_dest_V_1_ack_in;
  wire m_axis_V_dest_V_1_payload_A;
  wire \m_axis_V_dest_V_1_payload_A[0]_i_1_n_1 ;
  wire m_axis_V_dest_V_1_payload_B;
  wire \m_axis_V_dest_V_1_payload_B[0]_i_1_n_1 ;
  wire m_axis_V_dest_V_1_sel;
  wire m_axis_V_dest_V_1_sel_rd_i_1_n_1;
  wire m_axis_V_dest_V_1_sel_wr;
  wire m_axis_V_dest_V_1_sel_wr_i_1_n_1;
  wire \m_axis_V_dest_V_1_state[0]_i_1_n_1 ;
  wire \m_axis_V_dest_V_1_state[0]_i_2_n_1 ;
  wire \m_axis_V_dest_V_1_state[0]_i_3_n_1 ;
  wire \m_axis_V_dest_V_1_state[1]_i_1_n_1 ;
  wire m_axis_V_id_V_1_ack_in;
  wire m_axis_V_id_V_1_payload_A;
  wire \m_axis_V_id_V_1_payload_A[0]_i_1_n_1 ;
  wire m_axis_V_id_V_1_payload_B;
  wire \m_axis_V_id_V_1_payload_B[0]_i_1_n_1 ;
  wire m_axis_V_id_V_1_sel;
  wire m_axis_V_id_V_1_sel_rd_i_1_n_1;
  wire m_axis_V_id_V_1_sel_wr;
  wire m_axis_V_id_V_1_sel_wr_i_1_n_1;
  wire \m_axis_V_id_V_1_state[0]_i_1_n_1 ;
  wire \m_axis_V_id_V_1_state[1]_i_1_n_1 ;
  wire \m_axis_V_id_V_1_state_reg_n_1_[0] ;
  wire m_axis_V_keep_V_1_ack_in;
  wire m_axis_V_keep_V_1_payload_A;
  wire \m_axis_V_keep_V_1_payload_A[0]_i_1_n_1 ;
  wire m_axis_V_keep_V_1_payload_B;
  wire \m_axis_V_keep_V_1_payload_B[0]_i_1_n_1 ;
  wire m_axis_V_keep_V_1_sel;
  wire m_axis_V_keep_V_1_sel_rd_i_1_n_1;
  wire m_axis_V_keep_V_1_sel_wr;
  wire m_axis_V_keep_V_1_sel_wr_i_1_n_1;
  wire \m_axis_V_keep_V_1_state[0]_i_1_n_1 ;
  wire \m_axis_V_keep_V_1_state[1]_i_1_n_1 ;
  wire \m_axis_V_keep_V_1_state_reg_n_1_[0] ;
  wire m_axis_V_last_V_1_ack_in;
  wire m_axis_V_last_V_1_payload_A;
  wire \m_axis_V_last_V_1_payload_A[0]_i_1_n_1 ;
  wire m_axis_V_last_V_1_payload_B;
  wire \m_axis_V_last_V_1_payload_B[0]_i_1_n_1 ;
  wire m_axis_V_last_V_1_sel;
  wire m_axis_V_last_V_1_sel_rd_i_1_n_1;
  wire m_axis_V_last_V_1_sel_wr;
  wire m_axis_V_last_V_1_sel_wr_i_1_n_1;
  wire \m_axis_V_last_V_1_state[0]_i_1_n_1 ;
  wire \m_axis_V_last_V_1_state[1]_i_1_n_1 ;
  wire \m_axis_V_last_V_1_state_reg_n_1_[0] ;
  wire m_axis_V_strb_V_1_ack_in;
  wire m_axis_V_strb_V_1_payload_A;
  wire \m_axis_V_strb_V_1_payload_A[0]_i_1_n_1 ;
  wire m_axis_V_strb_V_1_payload_B;
  wire \m_axis_V_strb_V_1_payload_B[0]_i_1_n_1 ;
  wire m_axis_V_strb_V_1_sel;
  wire m_axis_V_strb_V_1_sel_rd_i_1_n_1;
  wire m_axis_V_strb_V_1_sel_wr;
  wire m_axis_V_strb_V_1_sel_wr_i_1_n_1;
  wire \m_axis_V_strb_V_1_state[0]_i_1_n_1 ;
  wire \m_axis_V_strb_V_1_state[1]_i_1_n_1 ;
  wire \m_axis_V_strb_V_1_state_reg_n_1_[0] ;
  wire m_axis_V_user_V_1_ack_in;
  wire m_axis_V_user_V_1_payload_A;
  wire \m_axis_V_user_V_1_payload_A[0]_i_1_n_1 ;
  wire m_axis_V_user_V_1_payload_B;
  wire \m_axis_V_user_V_1_payload_B[0]_i_1_n_1 ;
  wire m_axis_V_user_V_1_sel;
  wire m_axis_V_user_V_1_sel_rd_i_1_n_1;
  wire m_axis_V_user_V_1_sel_wr;
  wire m_axis_V_user_V_1_sel_wr_i_1_n_1;
  wire \m_axis_V_user_V_1_state[0]_i_1_n_1 ;
  wire \m_axis_V_user_V_1_state[1]_i_1_n_1 ;
  wire \m_axis_V_user_V_1_state_reg_n_1_[0] ;
  wire [31:0]pixel_count;
  wire [31:0]pixel_count_read_reg_227;
  wire [5:0]s_axi_CTRL_ARADDR;
  wire s_axi_CTRL_ARREADY;
  wire s_axi_CTRL_ARVALID;
  wire [5:0]s_axi_CTRL_AWADDR;
  wire s_axi_CTRL_AWREADY;
  wire s_axi_CTRL_AWVALID;
  wire s_axi_CTRL_BREADY;
  wire s_axi_CTRL_BVALID;
  wire [31:0]s_axi_CTRL_RDATA;
  wire s_axi_CTRL_RREADY;
  wire s_axi_CTRL_RVALID;
  wire [31:0]s_axi_CTRL_WDATA;
  wire s_axi_CTRL_WREADY;
  wire [3:0]s_axi_CTRL_WSTRB;
  wire s_axi_CTRL_WVALID;
  wire [7:0]s_axis_TDATA;
  wire [0:0]s_axis_TDEST;
  wire [0:0]s_axis_TID;
  wire [0:0]s_axis_TKEEP;
  wire [0:0]s_axis_TLAST;
  wire s_axis_TREADY;
  wire [0:0]s_axis_TSTRB;
  wire [0:0]s_axis_TUSER;
  wire s_axis_TVALID;
  wire s_axis_V_data_V_0_ack_in;
  wire [7:1]s_axis_V_data_V_0_data_out;
  wire s_axis_V_data_V_0_load_A;
  wire s_axis_V_data_V_0_load_B;
  wire [7:0]s_axis_V_data_V_0_payload_A;
  wire [7:0]s_axis_V_data_V_0_payload_B;
  wire s_axis_V_data_V_0_sel;
  wire s_axis_V_data_V_0_sel_rd_i_1_n_1;
  wire s_axis_V_data_V_0_sel_wr;
  wire s_axis_V_data_V_0_sel_wr_i_1_n_1;
  wire [1:1]s_axis_V_data_V_0_state;
  wire \s_axis_V_data_V_0_state[0]_i_1_n_1 ;
  wire \s_axis_V_data_V_0_state_reg_n_1_[0] ;
  wire s_axis_V_dest_V_0_data_out;
  wire s_axis_V_dest_V_0_payload_A;
  wire \s_axis_V_dest_V_0_payload_A[0]_i_1_n_1 ;
  wire s_axis_V_dest_V_0_payload_B;
  wire \s_axis_V_dest_V_0_payload_B[0]_i_1_n_1 ;
  wire s_axis_V_dest_V_0_sel;
  wire s_axis_V_dest_V_0_sel_rd_i_1_n_1;
  wire s_axis_V_dest_V_0_sel_wr;
  wire s_axis_V_dest_V_0_sel_wr_i_1_n_1;
  wire [1:1]s_axis_V_dest_V_0_state;
  wire \s_axis_V_dest_V_0_state[0]_i_1_n_1 ;
  wire \s_axis_V_dest_V_0_state_reg_n_1_[0] ;
  wire s_axis_V_id_V_0_ack_in;
  wire s_axis_V_id_V_0_data_out;
  wire s_axis_V_id_V_0_payload_A;
  wire \s_axis_V_id_V_0_payload_A[0]_i_1_n_1 ;
  wire s_axis_V_id_V_0_payload_B;
  wire \s_axis_V_id_V_0_payload_B[0]_i_1_n_1 ;
  wire s_axis_V_id_V_0_sel;
  wire s_axis_V_id_V_0_sel_rd_i_1_n_1;
  wire s_axis_V_id_V_0_sel_wr;
  wire s_axis_V_id_V_0_sel_wr_i_1_n_1;
  wire [1:1]s_axis_V_id_V_0_state;
  wire \s_axis_V_id_V_0_state[0]_i_1_n_1 ;
  wire \s_axis_V_id_V_0_state_reg_n_1_[0] ;
  wire s_axis_V_keep_V_0_ack_in;
  wire s_axis_V_keep_V_0_data_out;
  wire s_axis_V_keep_V_0_payload_A;
  wire \s_axis_V_keep_V_0_payload_A[0]_i_1_n_1 ;
  wire s_axis_V_keep_V_0_payload_B;
  wire \s_axis_V_keep_V_0_payload_B[0]_i_1_n_1 ;
  wire s_axis_V_keep_V_0_sel;
  wire s_axis_V_keep_V_0_sel_rd_i_1_n_1;
  wire s_axis_V_keep_V_0_sel_wr;
  wire s_axis_V_keep_V_0_sel_wr_i_1_n_1;
  wire [1:1]s_axis_V_keep_V_0_state;
  wire \s_axis_V_keep_V_0_state[0]_i_1_n_1 ;
  wire \s_axis_V_keep_V_0_state_reg_n_1_[0] ;
  wire s_axis_V_last_V_0_ack_in;
  wire s_axis_V_last_V_0_data_out;
  wire s_axis_V_last_V_0_payload_A;
  wire \s_axis_V_last_V_0_payload_A[0]_i_1_n_1 ;
  wire s_axis_V_last_V_0_payload_B;
  wire \s_axis_V_last_V_0_payload_B[0]_i_1_n_1 ;
  wire s_axis_V_last_V_0_sel;
  wire s_axis_V_last_V_0_sel_rd_i_1_n_1;
  wire s_axis_V_last_V_0_sel_wr;
  wire s_axis_V_last_V_0_sel_wr_i_1_n_1;
  wire [1:1]s_axis_V_last_V_0_state;
  wire \s_axis_V_last_V_0_state[0]_i_1_n_1 ;
  wire \s_axis_V_last_V_0_state_reg_n_1_[0] ;
  wire s_axis_V_strb_V_0_ack_in;
  wire s_axis_V_strb_V_0_data_out;
  wire s_axis_V_strb_V_0_payload_A;
  wire \s_axis_V_strb_V_0_payload_A[0]_i_1_n_1 ;
  wire s_axis_V_strb_V_0_payload_B;
  wire \s_axis_V_strb_V_0_payload_B[0]_i_1_n_1 ;
  wire s_axis_V_strb_V_0_sel;
  wire s_axis_V_strb_V_0_sel_rd_i_1_n_1;
  wire s_axis_V_strb_V_0_sel_wr;
  wire s_axis_V_strb_V_0_sel_wr_i_1_n_1;
  wire [1:1]s_axis_V_strb_V_0_state;
  wire \s_axis_V_strb_V_0_state[0]_i_1_n_1 ;
  wire \s_axis_V_strb_V_0_state_reg_n_1_[0] ;
  wire s_axis_V_user_V_0_ack_in;
  wire s_axis_V_user_V_0_data_out;
  wire s_axis_V_user_V_0_payload_A;
  wire \s_axis_V_user_V_0_payload_A[0]_i_1_n_1 ;
  wire s_axis_V_user_V_0_payload_B;
  wire \s_axis_V_user_V_0_payload_B[0]_i_1_n_1 ;
  wire s_axis_V_user_V_0_sel;
  wire s_axis_V_user_V_0_sel_rd_i_1_n_1;
  wire s_axis_V_user_V_0_sel_wr;
  wire s_axis_V_user_V_0_sel_wr_i_1_n_1;
  wire [1:1]s_axis_V_user_V_0_state;
  wire \s_axis_V_user_V_0_state[0]_i_1_n_1 ;
  wire \s_axis_V_user_V_0_state_reg_n_1_[0] ;
  wire [7:0]threshold_V;
  wire [7:0]threshold_V_read_reg_222;
  wire threshold_enable;
  wire threshold_enable_rea_reg_217;
  wire tmp_data_V_1_fu_202_p3;
  wire [7:0]tmp_data_V_2_reg_271;
  wire tmp_data_V_2_reg_2710;
  wire \tmp_data_V_2_reg_271[0]_i_1_n_1 ;
  wire \tmp_data_V_2_reg_271[1]_i_1_n_1 ;
  wire \tmp_data_V_2_reg_271[2]_i_1_n_1 ;
  wire \tmp_data_V_2_reg_271[3]_i_1_n_1 ;
  wire \tmp_data_V_2_reg_271[4]_i_1_n_1 ;
  wire \tmp_data_V_2_reg_271[5]_i_1_n_1 ;
  wire \tmp_data_V_2_reg_271[6]_i_1_n_1 ;
  wire \tmp_data_V_2_reg_271[7]_i_10_n_1 ;
  wire \tmp_data_V_2_reg_271[7]_i_11_n_1 ;
  wire \tmp_data_V_2_reg_271[7]_i_12_n_1 ;
  wire \tmp_data_V_2_reg_271[7]_i_13_n_1 ;
  wire \tmp_data_V_2_reg_271[7]_i_14_n_1 ;
  wire \tmp_data_V_2_reg_271[7]_i_15_n_1 ;
  wire \tmp_data_V_2_reg_271[7]_i_16_n_1 ;
  wire \tmp_data_V_2_reg_271[7]_i_17_n_1 ;
  wire \tmp_data_V_2_reg_271[7]_i_18_n_1 ;
  wire \tmp_data_V_2_reg_271[7]_i_19_n_1 ;
  wire \tmp_data_V_2_reg_271[7]_i_20_n_1 ;
  wire \tmp_data_V_2_reg_271[7]_i_21_n_1 ;
  wire \tmp_data_V_2_reg_271[7]_i_22_n_1 ;
  wire \tmp_data_V_2_reg_271[7]_i_24_n_1 ;
  wire \tmp_data_V_2_reg_271[7]_i_25_n_1 ;
  wire \tmp_data_V_2_reg_271[7]_i_26_n_1 ;
  wire \tmp_data_V_2_reg_271[7]_i_27_n_1 ;
  wire \tmp_data_V_2_reg_271[7]_i_28_n_1 ;
  wire \tmp_data_V_2_reg_271[7]_i_29_n_1 ;
  wire \tmp_data_V_2_reg_271[7]_i_2_n_1 ;
  wire \tmp_data_V_2_reg_271[7]_i_30_n_1 ;
  wire \tmp_data_V_2_reg_271[7]_i_31_n_1 ;
  wire \tmp_data_V_2_reg_271[7]_i_37_n_1 ;
  wire \tmp_data_V_2_reg_271[7]_i_38_n_1 ;
  wire \tmp_data_V_2_reg_271[7]_i_39_n_1 ;
  wire \tmp_data_V_2_reg_271[7]_i_3_n_1 ;
  wire \tmp_data_V_2_reg_271[7]_i_40_n_1 ;
  wire \tmp_data_V_2_reg_271[7]_i_41_n_1 ;
  wire \tmp_data_V_2_reg_271[7]_i_42_n_1 ;
  wire \tmp_data_V_2_reg_271[7]_i_43_n_1 ;
  wire \tmp_data_V_2_reg_271[7]_i_44_n_1 ;
  wire \tmp_data_V_2_reg_271[7]_i_45_n_1 ;
  wire \tmp_data_V_2_reg_271[7]_i_46_n_1 ;
  wire \tmp_data_V_2_reg_271[7]_i_47_n_1 ;
  wire \tmp_data_V_2_reg_271[7]_i_48_n_1 ;
  wire \tmp_data_V_2_reg_271[7]_i_49_n_1 ;
  wire \tmp_data_V_2_reg_271[7]_i_50_n_1 ;
  wire \tmp_data_V_2_reg_271[7]_i_51_n_1 ;
  wire \tmp_data_V_2_reg_271[7]_i_52_n_1 ;
  wire \tmp_data_V_2_reg_271[7]_i_7_n_1 ;
  wire \tmp_data_V_2_reg_271[7]_i_8_n_1 ;
  wire \tmp_data_V_2_reg_271[7]_i_9_n_1 ;
  wire \tmp_data_V_2_reg_271_reg[7]_i_23_n_1 ;
  wire \tmp_data_V_2_reg_271_reg[7]_i_23_n_2 ;
  wire \tmp_data_V_2_reg_271_reg[7]_i_23_n_3 ;
  wire \tmp_data_V_2_reg_271_reg[7]_i_23_n_4 ;
  wire \tmp_data_V_2_reg_271_reg[7]_i_36_n_1 ;
  wire \tmp_data_V_2_reg_271_reg[7]_i_36_n_2 ;
  wire \tmp_data_V_2_reg_271_reg[7]_i_36_n_3 ;
  wire \tmp_data_V_2_reg_271_reg[7]_i_36_n_4 ;
  wire \tmp_data_V_2_reg_271_reg[7]_i_4_n_2 ;
  wire \tmp_data_V_2_reg_271_reg[7]_i_4_n_3 ;
  wire \tmp_data_V_2_reg_271_reg[7]_i_4_n_4 ;
  wire \tmp_data_V_2_reg_271_reg[7]_i_5_n_2 ;
  wire \tmp_data_V_2_reg_271_reg[7]_i_5_n_3 ;
  wire \tmp_data_V_2_reg_271_reg[7]_i_5_n_4 ;
  wire \tmp_data_V_2_reg_271_reg[7]_i_6_n_1 ;
  wire \tmp_data_V_2_reg_271_reg[7]_i_6_n_2 ;
  wire \tmp_data_V_2_reg_271_reg[7]_i_6_n_3 ;
  wire \tmp_data_V_2_reg_271_reg[7]_i_6_n_4 ;
  wire tmp_dest_V_reg_266;
  wire tmp_id_V_reg_261;
  wire tmp_keep_V_reg_241;
  wire tmp_last_V_reg_256;
  wire tmp_strb_V_reg_246;
  wire tmp_user_V_reg_251;
  wire [3:2]\NLW_i_0_reg_143_reg[28]_i_1_CO_UNCONNECTED ;
  wire [3:3]\NLW_i_0_reg_143_reg[28]_i_1_O_UNCONNECTED ;
  wire [3:0]\NLW_tmp_data_V_2_reg_271_reg[7]_i_23_O_UNCONNECTED ;
  wire [3:0]\NLW_tmp_data_V_2_reg_271_reg[7]_i_36_O_UNCONNECTED ;
  wire [3:0]\NLW_tmp_data_V_2_reg_271_reg[7]_i_4_O_UNCONNECTED ;
  wire [3:0]\NLW_tmp_data_V_2_reg_271_reg[7]_i_5_O_UNCONNECTED ;
  wire [3:0]\NLW_tmp_data_V_2_reg_271_reg[7]_i_6_O_UNCONNECTED ;

  assign s_axi_CTRL_BRESP[1] = \<const0> ;
  assign s_axi_CTRL_BRESP[0] = \<const0> ;
  assign s_axi_CTRL_RRESP[1] = \<const0> ;
  assign s_axi_CTRL_RRESP[0] = \<const0> ;
  GND GND
       (.G(\<const0> ));
  LUT4 #(
    .INIT(16'h0F11)) 
    \ap_CS_fsm[2]_i_1 
       (.I0(ap_done),
        .I1(\ap_CS_fsm_reg_n_1_[0] ),
        .I2(\ap_CS_fsm[2]_i_2_n_1 ),
        .I3(ap_CS_fsm_pp0_stage0),
        .O(\ap_CS_fsm[2]_i_1_n_1 ));
  LUT6 #(
    .INIT(64'hFBFFFBFBFAFAFBFB)) 
    \ap_CS_fsm[2]_i_2 
       (.I0(ap_enable_reg_pp0_iter1_reg_n_1),
        .I1(ap_enable_reg_pp0_iter2_reg_n_1),
        .I2(\tmp_data_V_2_reg_271[7]_i_3_n_1 ),
        .I3(\s_axis_V_data_V_0_state_reg_n_1_[0] ),
        .I4(ap_enable_reg_pp0_iter0),
        .I5(icmp_ln17_fu_158_p2),
        .O(\ap_CS_fsm[2]_i_2_n_1 ));
  (* FSM_ENCODING = "none" *) 
  FDSE #(
    .INIT(1'b1)) 
    \ap_CS_fsm_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(cubeocc_hls_CTRL_s_axi_U_n_50),
        .Q(\ap_CS_fsm_reg_n_1_[0] ),
        .S(ap_rst_n_inv));
  (* FSM_ENCODING = "none" *) 
  FDRE #(
    .INIT(1'b0)) 
    \ap_CS_fsm_reg[1] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(cubeocc_hls_CTRL_s_axi_U_n_49),
        .Q(ap_CS_fsm_pp0_stage0),
        .R(ap_rst_n_inv));
  (* FSM_ENCODING = "none" *) 
  FDRE #(
    .INIT(1'b0)) 
    \ap_CS_fsm_reg[2] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\ap_CS_fsm[2]_i_1_n_1 ),
        .Q(ap_CS_fsm_state5),
        .R(ap_rst_n_inv));
  LUT4 #(
    .INIT(16'h00F7)) 
    ap_enable_reg_pp0_iter0_i_2
       (.I0(icmp_ln17_fu_158_p2),
        .I1(ap_enable_reg_pp0_iter0),
        .I2(\s_axis_V_data_V_0_state_reg_n_1_[0] ),
        .I3(\tmp_data_V_2_reg_271[7]_i_3_n_1 ),
        .O(ap_block_pp0_stage0_subdone3_in));
  FDRE #(
    .INIT(1'b0)) 
    ap_enable_reg_pp0_iter0_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(cubeocc_hls_CTRL_s_axi_U_n_53),
        .Q(ap_enable_reg_pp0_iter0),
        .R(1'b0));
  LUT6 #(
    .INIT(64'hFF88008000000000)) 
    ap_enable_reg_pp0_iter1_i_1
       (.I0(icmp_ln17_fu_158_p2),
        .I1(ap_enable_reg_pp0_iter0),
        .I2(\s_axis_V_data_V_0_state_reg_n_1_[0] ),
        .I3(\tmp_data_V_2_reg_271[7]_i_3_n_1 ),
        .I4(ap_enable_reg_pp0_iter1_reg_n_1),
        .I5(ap_rst_n),
        .O(ap_enable_reg_pp0_iter1_i_1_n_1));
  FDRE #(
    .INIT(1'b0)) 
    ap_enable_reg_pp0_iter1_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(ap_enable_reg_pp0_iter1_i_1_n_1),
        .Q(ap_enable_reg_pp0_iter1_reg_n_1),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    ap_enable_reg_pp0_iter2_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(cubeocc_hls_CTRL_s_axi_U_n_4),
        .Q(ap_enable_reg_pp0_iter2_reg_n_1),
        .R(1'b0));
  cubeocc_hls_1_cubeocc_hls_CTRL_s_axi cubeocc_hls_CTRL_s_axi_U
       (.CO(icmp_ln17_fu_158_p2),
        .D({cubeocc_hls_CTRL_s_axi_U_n_49,cubeocc_hls_CTRL_s_axi_U_n_50}),
        .E(ap_NS_fsm1),
        .\FSM_onehot_rstate_reg[1]_0 (s_axi_CTRL_ARREADY),
        .\FSM_onehot_wstate_reg[1]_0 (s_axi_CTRL_AWREADY),
        .\FSM_onehot_wstate_reg[2]_0 (s_axi_CTRL_WREADY),
        .Q({ap_CS_fsm_state5,ap_CS_fsm_pp0_stage0,\ap_CS_fsm_reg_n_1_[0] }),
        .\ap_CS_fsm_reg[0] (cubeocc_hls_CTRL_s_axi_U_n_4),
        .\ap_CS_fsm_reg[1] (cubeocc_hls_CTRL_s_axi_U_n_53),
        .\ap_CS_fsm_reg[1]_0 (\ap_CS_fsm[2]_i_2_n_1 ),
        .ap_block_pp0_stage0_subdone3_in(ap_block_pp0_stage0_subdone3_in),
        .ap_clk(ap_clk),
        .ap_done(ap_done),
        .ap_enable_reg_pp0_iter0(ap_enable_reg_pp0_iter0),
        .ap_enable_reg_pp0_iter2_reg(ap_enable_reg_pp0_iter1_reg_n_1),
        .ap_enable_reg_pp0_iter2_reg_0(ap_enable_reg_pp0_iter2_reg_n_1),
        .ap_rst_n(ap_rst_n),
        .ap_rst_n_inv(ap_rst_n_inv),
        .i_0_reg_143(i_0_reg_143),
        .\i_0_reg_143_reg[0] (\i_0_reg_143[0]_i_2_n_1 ),
        .int_ap_ready_i_2_0(\m_axis_V_data_V_1_state_reg_n_1_[0] ),
        .int_ap_ready_i_2_1(m_axis_TVALID),
        .int_ap_ready_reg_0(\m_axis_V_strb_V_1_state_reg_n_1_[0] ),
        .int_ap_ready_reg_1(\m_axis_V_last_V_1_state_reg_n_1_[0] ),
        .int_ap_ready_reg_2(\m_axis_V_user_V_1_state_reg_n_1_[0] ),
        .int_ap_ready_reg_3(\m_axis_V_id_V_1_state_reg_n_1_[0] ),
        .int_ap_ready_reg_4(\m_axis_V_keep_V_1_state_reg_n_1_[0] ),
        .\int_pixel_count_reg[31]_0 (pixel_count),
        .\int_threshold_V_reg[7]_0 (threshold_V),
        .interrupt(interrupt),
        .m_axis_TREADY(m_axis_TREADY),
        .m_axis_V_data_V_1_ack_in(m_axis_V_data_V_1_ack_in),
        .m_axis_V_dest_V_1_ack_in(m_axis_V_dest_V_1_ack_in),
        .m_axis_V_id_V_1_ack_in(m_axis_V_id_V_1_ack_in),
        .m_axis_V_keep_V_1_ack_in(m_axis_V_keep_V_1_ack_in),
        .m_axis_V_last_V_1_ack_in(m_axis_V_last_V_1_ack_in),
        .m_axis_V_strb_V_1_ack_in(m_axis_V_strb_V_1_ack_in),
        .m_axis_V_user_V_1_ack_in(m_axis_V_user_V_1_ack_in),
        .s_axi_CTRL_ARADDR(s_axi_CTRL_ARADDR),
        .s_axi_CTRL_ARVALID(s_axi_CTRL_ARVALID),
        .s_axi_CTRL_AWADDR(s_axi_CTRL_AWADDR),
        .s_axi_CTRL_AWVALID(s_axi_CTRL_AWVALID),
        .s_axi_CTRL_BREADY(s_axi_CTRL_BREADY),
        .s_axi_CTRL_BVALID(s_axi_CTRL_BVALID),
        .s_axi_CTRL_RDATA(s_axi_CTRL_RDATA),
        .s_axi_CTRL_RREADY(s_axi_CTRL_RREADY),
        .s_axi_CTRL_RVALID(s_axi_CTRL_RVALID),
        .s_axi_CTRL_WDATA(s_axi_CTRL_WDATA),
        .s_axi_CTRL_WSTRB(s_axi_CTRL_WSTRB),
        .s_axi_CTRL_WVALID(s_axi_CTRL_WVALID),
        .threshold_enable(threshold_enable));
  LUT5 #(
    .INIT(32'h00800000)) 
    \i_0_reg_143[0]_i_2 
       (.I0(icmp_ln17_fu_158_p2),
        .I1(ap_CS_fsm_pp0_stage0),
        .I2(\s_axis_V_data_V_0_state_reg_n_1_[0] ),
        .I3(\tmp_data_V_2_reg_271[7]_i_3_n_1 ),
        .I4(ap_enable_reg_pp0_iter0),
        .O(\i_0_reg_143[0]_i_2_n_1 ));
  LUT1 #(
    .INIT(2'h1)) 
    \i_0_reg_143[0]_i_4 
       (.I0(i_0_reg_143_reg[0]),
        .O(\i_0_reg_143[0]_i_4_n_1 ));
  FDRE \i_0_reg_143_reg[0] 
       (.C(ap_clk),
        .CE(\i_0_reg_143[0]_i_2_n_1 ),
        .D(\i_0_reg_143_reg[0]_i_3_n_8 ),
        .Q(i_0_reg_143_reg[0]),
        .R(i_0_reg_143));
  CARRY4 \i_0_reg_143_reg[0]_i_3 
       (.CI(1'b0),
        .CO({\i_0_reg_143_reg[0]_i_3_n_1 ,\i_0_reg_143_reg[0]_i_3_n_2 ,\i_0_reg_143_reg[0]_i_3_n_3 ,\i_0_reg_143_reg[0]_i_3_n_4 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b1}),
        .O({\i_0_reg_143_reg[0]_i_3_n_5 ,\i_0_reg_143_reg[0]_i_3_n_6 ,\i_0_reg_143_reg[0]_i_3_n_7 ,\i_0_reg_143_reg[0]_i_3_n_8 }),
        .S({i_0_reg_143_reg[3:1],\i_0_reg_143[0]_i_4_n_1 }));
  FDRE \i_0_reg_143_reg[10] 
       (.C(ap_clk),
        .CE(\i_0_reg_143[0]_i_2_n_1 ),
        .D(\i_0_reg_143_reg[8]_i_1_n_6 ),
        .Q(i_0_reg_143_reg[10]),
        .R(i_0_reg_143));
  FDRE \i_0_reg_143_reg[11] 
       (.C(ap_clk),
        .CE(\i_0_reg_143[0]_i_2_n_1 ),
        .D(\i_0_reg_143_reg[8]_i_1_n_5 ),
        .Q(i_0_reg_143_reg[11]),
        .R(i_0_reg_143));
  FDRE \i_0_reg_143_reg[12] 
       (.C(ap_clk),
        .CE(\i_0_reg_143[0]_i_2_n_1 ),
        .D(\i_0_reg_143_reg[12]_i_1_n_8 ),
        .Q(i_0_reg_143_reg[12]),
        .R(i_0_reg_143));
  CARRY4 \i_0_reg_143_reg[12]_i_1 
       (.CI(\i_0_reg_143_reg[8]_i_1_n_1 ),
        .CO({\i_0_reg_143_reg[12]_i_1_n_1 ,\i_0_reg_143_reg[12]_i_1_n_2 ,\i_0_reg_143_reg[12]_i_1_n_3 ,\i_0_reg_143_reg[12]_i_1_n_4 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\i_0_reg_143_reg[12]_i_1_n_5 ,\i_0_reg_143_reg[12]_i_1_n_6 ,\i_0_reg_143_reg[12]_i_1_n_7 ,\i_0_reg_143_reg[12]_i_1_n_8 }),
        .S(i_0_reg_143_reg[15:12]));
  FDRE \i_0_reg_143_reg[13] 
       (.C(ap_clk),
        .CE(\i_0_reg_143[0]_i_2_n_1 ),
        .D(\i_0_reg_143_reg[12]_i_1_n_7 ),
        .Q(i_0_reg_143_reg[13]),
        .R(i_0_reg_143));
  FDRE \i_0_reg_143_reg[14] 
       (.C(ap_clk),
        .CE(\i_0_reg_143[0]_i_2_n_1 ),
        .D(\i_0_reg_143_reg[12]_i_1_n_6 ),
        .Q(i_0_reg_143_reg[14]),
        .R(i_0_reg_143));
  FDRE \i_0_reg_143_reg[15] 
       (.C(ap_clk),
        .CE(\i_0_reg_143[0]_i_2_n_1 ),
        .D(\i_0_reg_143_reg[12]_i_1_n_5 ),
        .Q(i_0_reg_143_reg[15]),
        .R(i_0_reg_143));
  FDRE \i_0_reg_143_reg[16] 
       (.C(ap_clk),
        .CE(\i_0_reg_143[0]_i_2_n_1 ),
        .D(\i_0_reg_143_reg[16]_i_1_n_8 ),
        .Q(i_0_reg_143_reg[16]),
        .R(i_0_reg_143));
  CARRY4 \i_0_reg_143_reg[16]_i_1 
       (.CI(\i_0_reg_143_reg[12]_i_1_n_1 ),
        .CO({\i_0_reg_143_reg[16]_i_1_n_1 ,\i_0_reg_143_reg[16]_i_1_n_2 ,\i_0_reg_143_reg[16]_i_1_n_3 ,\i_0_reg_143_reg[16]_i_1_n_4 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\i_0_reg_143_reg[16]_i_1_n_5 ,\i_0_reg_143_reg[16]_i_1_n_6 ,\i_0_reg_143_reg[16]_i_1_n_7 ,\i_0_reg_143_reg[16]_i_1_n_8 }),
        .S(i_0_reg_143_reg[19:16]));
  FDRE \i_0_reg_143_reg[17] 
       (.C(ap_clk),
        .CE(\i_0_reg_143[0]_i_2_n_1 ),
        .D(\i_0_reg_143_reg[16]_i_1_n_7 ),
        .Q(i_0_reg_143_reg[17]),
        .R(i_0_reg_143));
  FDRE \i_0_reg_143_reg[18] 
       (.C(ap_clk),
        .CE(\i_0_reg_143[0]_i_2_n_1 ),
        .D(\i_0_reg_143_reg[16]_i_1_n_6 ),
        .Q(i_0_reg_143_reg[18]),
        .R(i_0_reg_143));
  FDRE \i_0_reg_143_reg[19] 
       (.C(ap_clk),
        .CE(\i_0_reg_143[0]_i_2_n_1 ),
        .D(\i_0_reg_143_reg[16]_i_1_n_5 ),
        .Q(i_0_reg_143_reg[19]),
        .R(i_0_reg_143));
  FDRE \i_0_reg_143_reg[1] 
       (.C(ap_clk),
        .CE(\i_0_reg_143[0]_i_2_n_1 ),
        .D(\i_0_reg_143_reg[0]_i_3_n_7 ),
        .Q(i_0_reg_143_reg[1]),
        .R(i_0_reg_143));
  FDRE \i_0_reg_143_reg[20] 
       (.C(ap_clk),
        .CE(\i_0_reg_143[0]_i_2_n_1 ),
        .D(\i_0_reg_143_reg[20]_i_1_n_8 ),
        .Q(i_0_reg_143_reg[20]),
        .R(i_0_reg_143));
  CARRY4 \i_0_reg_143_reg[20]_i_1 
       (.CI(\i_0_reg_143_reg[16]_i_1_n_1 ),
        .CO({\i_0_reg_143_reg[20]_i_1_n_1 ,\i_0_reg_143_reg[20]_i_1_n_2 ,\i_0_reg_143_reg[20]_i_1_n_3 ,\i_0_reg_143_reg[20]_i_1_n_4 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\i_0_reg_143_reg[20]_i_1_n_5 ,\i_0_reg_143_reg[20]_i_1_n_6 ,\i_0_reg_143_reg[20]_i_1_n_7 ,\i_0_reg_143_reg[20]_i_1_n_8 }),
        .S(i_0_reg_143_reg[23:20]));
  FDRE \i_0_reg_143_reg[21] 
       (.C(ap_clk),
        .CE(\i_0_reg_143[0]_i_2_n_1 ),
        .D(\i_0_reg_143_reg[20]_i_1_n_7 ),
        .Q(i_0_reg_143_reg[21]),
        .R(i_0_reg_143));
  FDRE \i_0_reg_143_reg[22] 
       (.C(ap_clk),
        .CE(\i_0_reg_143[0]_i_2_n_1 ),
        .D(\i_0_reg_143_reg[20]_i_1_n_6 ),
        .Q(i_0_reg_143_reg[22]),
        .R(i_0_reg_143));
  FDRE \i_0_reg_143_reg[23] 
       (.C(ap_clk),
        .CE(\i_0_reg_143[0]_i_2_n_1 ),
        .D(\i_0_reg_143_reg[20]_i_1_n_5 ),
        .Q(i_0_reg_143_reg[23]),
        .R(i_0_reg_143));
  FDRE \i_0_reg_143_reg[24] 
       (.C(ap_clk),
        .CE(\i_0_reg_143[0]_i_2_n_1 ),
        .D(\i_0_reg_143_reg[24]_i_1_n_8 ),
        .Q(i_0_reg_143_reg[24]),
        .R(i_0_reg_143));
  CARRY4 \i_0_reg_143_reg[24]_i_1 
       (.CI(\i_0_reg_143_reg[20]_i_1_n_1 ),
        .CO({\i_0_reg_143_reg[24]_i_1_n_1 ,\i_0_reg_143_reg[24]_i_1_n_2 ,\i_0_reg_143_reg[24]_i_1_n_3 ,\i_0_reg_143_reg[24]_i_1_n_4 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\i_0_reg_143_reg[24]_i_1_n_5 ,\i_0_reg_143_reg[24]_i_1_n_6 ,\i_0_reg_143_reg[24]_i_1_n_7 ,\i_0_reg_143_reg[24]_i_1_n_8 }),
        .S(i_0_reg_143_reg[27:24]));
  FDRE \i_0_reg_143_reg[25] 
       (.C(ap_clk),
        .CE(\i_0_reg_143[0]_i_2_n_1 ),
        .D(\i_0_reg_143_reg[24]_i_1_n_7 ),
        .Q(i_0_reg_143_reg[25]),
        .R(i_0_reg_143));
  FDRE \i_0_reg_143_reg[26] 
       (.C(ap_clk),
        .CE(\i_0_reg_143[0]_i_2_n_1 ),
        .D(\i_0_reg_143_reg[24]_i_1_n_6 ),
        .Q(i_0_reg_143_reg[26]),
        .R(i_0_reg_143));
  FDRE \i_0_reg_143_reg[27] 
       (.C(ap_clk),
        .CE(\i_0_reg_143[0]_i_2_n_1 ),
        .D(\i_0_reg_143_reg[24]_i_1_n_5 ),
        .Q(i_0_reg_143_reg[27]),
        .R(i_0_reg_143));
  FDRE \i_0_reg_143_reg[28] 
       (.C(ap_clk),
        .CE(\i_0_reg_143[0]_i_2_n_1 ),
        .D(\i_0_reg_143_reg[28]_i_1_n_8 ),
        .Q(i_0_reg_143_reg[28]),
        .R(i_0_reg_143));
  CARRY4 \i_0_reg_143_reg[28]_i_1 
       (.CI(\i_0_reg_143_reg[24]_i_1_n_1 ),
        .CO({\NLW_i_0_reg_143_reg[28]_i_1_CO_UNCONNECTED [3:2],\i_0_reg_143_reg[28]_i_1_n_3 ,\i_0_reg_143_reg[28]_i_1_n_4 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\NLW_i_0_reg_143_reg[28]_i_1_O_UNCONNECTED [3],\i_0_reg_143_reg[28]_i_1_n_6 ,\i_0_reg_143_reg[28]_i_1_n_7 ,\i_0_reg_143_reg[28]_i_1_n_8 }),
        .S({1'b0,i_0_reg_143_reg[30:28]}));
  FDRE \i_0_reg_143_reg[29] 
       (.C(ap_clk),
        .CE(\i_0_reg_143[0]_i_2_n_1 ),
        .D(\i_0_reg_143_reg[28]_i_1_n_7 ),
        .Q(i_0_reg_143_reg[29]),
        .R(i_0_reg_143));
  FDRE \i_0_reg_143_reg[2] 
       (.C(ap_clk),
        .CE(\i_0_reg_143[0]_i_2_n_1 ),
        .D(\i_0_reg_143_reg[0]_i_3_n_6 ),
        .Q(i_0_reg_143_reg[2]),
        .R(i_0_reg_143));
  FDRE \i_0_reg_143_reg[30] 
       (.C(ap_clk),
        .CE(\i_0_reg_143[0]_i_2_n_1 ),
        .D(\i_0_reg_143_reg[28]_i_1_n_6 ),
        .Q(i_0_reg_143_reg[30]),
        .R(i_0_reg_143));
  FDRE \i_0_reg_143_reg[3] 
       (.C(ap_clk),
        .CE(\i_0_reg_143[0]_i_2_n_1 ),
        .D(\i_0_reg_143_reg[0]_i_3_n_5 ),
        .Q(i_0_reg_143_reg[3]),
        .R(i_0_reg_143));
  FDRE \i_0_reg_143_reg[4] 
       (.C(ap_clk),
        .CE(\i_0_reg_143[0]_i_2_n_1 ),
        .D(\i_0_reg_143_reg[4]_i_1_n_8 ),
        .Q(i_0_reg_143_reg[4]),
        .R(i_0_reg_143));
  CARRY4 \i_0_reg_143_reg[4]_i_1 
       (.CI(\i_0_reg_143_reg[0]_i_3_n_1 ),
        .CO({\i_0_reg_143_reg[4]_i_1_n_1 ,\i_0_reg_143_reg[4]_i_1_n_2 ,\i_0_reg_143_reg[4]_i_1_n_3 ,\i_0_reg_143_reg[4]_i_1_n_4 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\i_0_reg_143_reg[4]_i_1_n_5 ,\i_0_reg_143_reg[4]_i_1_n_6 ,\i_0_reg_143_reg[4]_i_1_n_7 ,\i_0_reg_143_reg[4]_i_1_n_8 }),
        .S(i_0_reg_143_reg[7:4]));
  FDRE \i_0_reg_143_reg[5] 
       (.C(ap_clk),
        .CE(\i_0_reg_143[0]_i_2_n_1 ),
        .D(\i_0_reg_143_reg[4]_i_1_n_7 ),
        .Q(i_0_reg_143_reg[5]),
        .R(i_0_reg_143));
  FDRE \i_0_reg_143_reg[6] 
       (.C(ap_clk),
        .CE(\i_0_reg_143[0]_i_2_n_1 ),
        .D(\i_0_reg_143_reg[4]_i_1_n_6 ),
        .Q(i_0_reg_143_reg[6]),
        .R(i_0_reg_143));
  FDRE \i_0_reg_143_reg[7] 
       (.C(ap_clk),
        .CE(\i_0_reg_143[0]_i_2_n_1 ),
        .D(\i_0_reg_143_reg[4]_i_1_n_5 ),
        .Q(i_0_reg_143_reg[7]),
        .R(i_0_reg_143));
  FDRE \i_0_reg_143_reg[8] 
       (.C(ap_clk),
        .CE(\i_0_reg_143[0]_i_2_n_1 ),
        .D(\i_0_reg_143_reg[8]_i_1_n_8 ),
        .Q(i_0_reg_143_reg[8]),
        .R(i_0_reg_143));
  CARRY4 \i_0_reg_143_reg[8]_i_1 
       (.CI(\i_0_reg_143_reg[4]_i_1_n_1 ),
        .CO({\i_0_reg_143_reg[8]_i_1_n_1 ,\i_0_reg_143_reg[8]_i_1_n_2 ,\i_0_reg_143_reg[8]_i_1_n_3 ,\i_0_reg_143_reg[8]_i_1_n_4 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\i_0_reg_143_reg[8]_i_1_n_5 ,\i_0_reg_143_reg[8]_i_1_n_6 ,\i_0_reg_143_reg[8]_i_1_n_7 ,\i_0_reg_143_reg[8]_i_1_n_8 }),
        .S(i_0_reg_143_reg[11:8]));
  FDRE \i_0_reg_143_reg[9] 
       (.C(ap_clk),
        .CE(\i_0_reg_143[0]_i_2_n_1 ),
        .D(\i_0_reg_143_reg[8]_i_1_n_7 ),
        .Q(i_0_reg_143_reg[9]),
        .R(i_0_reg_143));
  (* SOFT_HLUTNM = "soft_lutpair37" *) 
  LUT4 #(
    .INIT(16'hBF80)) 
    \icmp_ln17_reg_232[0]_i_1 
       (.I0(icmp_ln17_fu_158_p2),
        .I1(ap_block_pp0_stage0_subdone3_in),
        .I2(ap_CS_fsm_pp0_stage0),
        .I3(icmp_ln17_reg_232),
        .O(\icmp_ln17_reg_232[0]_i_1_n_1 ));
  (* SOFT_HLUTNM = "soft_lutpair37" *) 
  LUT4 #(
    .INIT(16'hBF80)) 
    \icmp_ln17_reg_232_pp0_iter1_reg[0]_i_1 
       (.I0(icmp_ln17_reg_232),
        .I1(ap_block_pp0_stage0_subdone3_in),
        .I2(ap_CS_fsm_pp0_stage0),
        .I3(icmp_ln17_reg_232_pp0_iter1_reg),
        .O(\icmp_ln17_reg_232_pp0_iter1_reg[0]_i_1_n_1 ));
  FDRE \icmp_ln17_reg_232_pp0_iter1_reg_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\icmp_ln17_reg_232_pp0_iter1_reg[0]_i_1_n_1 ),
        .Q(icmp_ln17_reg_232_pp0_iter1_reg),
        .R(1'b0));
  FDRE \icmp_ln17_reg_232_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\icmp_ln17_reg_232[0]_i_1_n_1 ),
        .Q(icmp_ln17_reg_232),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair59" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \m_axis_TDATA[0]_INST_0 
       (.I0(m_axis_V_data_V_1_payload_B[0]),
        .I1(m_axis_V_data_V_1_payload_A[0]),
        .I2(m_axis_V_data_V_1_sel),
        .O(m_axis_TDATA[0]));
  (* SOFT_HLUTNM = "soft_lutpair60" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \m_axis_TDATA[1]_INST_0 
       (.I0(m_axis_V_data_V_1_payload_B[1]),
        .I1(m_axis_V_data_V_1_payload_A[1]),
        .I2(m_axis_V_data_V_1_sel),
        .O(m_axis_TDATA[1]));
  (* SOFT_HLUTNM = "soft_lutpair61" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \m_axis_TDATA[2]_INST_0 
       (.I0(m_axis_V_data_V_1_payload_B[2]),
        .I1(m_axis_V_data_V_1_payload_A[2]),
        .I2(m_axis_V_data_V_1_sel),
        .O(m_axis_TDATA[2]));
  (* SOFT_HLUTNM = "soft_lutpair61" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \m_axis_TDATA[3]_INST_0 
       (.I0(m_axis_V_data_V_1_payload_B[3]),
        .I1(m_axis_V_data_V_1_payload_A[3]),
        .I2(m_axis_V_data_V_1_sel),
        .O(m_axis_TDATA[3]));
  (* SOFT_HLUTNM = "soft_lutpair59" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \m_axis_TDATA[4]_INST_0 
       (.I0(m_axis_V_data_V_1_payload_B[4]),
        .I1(m_axis_V_data_V_1_payload_A[4]),
        .I2(m_axis_V_data_V_1_sel),
        .O(m_axis_TDATA[4]));
  (* SOFT_HLUTNM = "soft_lutpair60" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \m_axis_TDATA[5]_INST_0 
       (.I0(m_axis_V_data_V_1_payload_B[5]),
        .I1(m_axis_V_data_V_1_payload_A[5]),
        .I2(m_axis_V_data_V_1_sel),
        .O(m_axis_TDATA[5]));
  (* SOFT_HLUTNM = "soft_lutpair62" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \m_axis_TDATA[6]_INST_0 
       (.I0(m_axis_V_data_V_1_payload_B[6]),
        .I1(m_axis_V_data_V_1_payload_A[6]),
        .I2(m_axis_V_data_V_1_sel),
        .O(m_axis_TDATA[6]));
  (* SOFT_HLUTNM = "soft_lutpair62" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \m_axis_TDATA[7]_INST_0 
       (.I0(m_axis_V_data_V_1_payload_B[7]),
        .I1(m_axis_V_data_V_1_payload_A[7]),
        .I2(m_axis_V_data_V_1_sel),
        .O(m_axis_TDATA[7]));
  (* SOFT_HLUTNM = "soft_lutpair52" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \m_axis_TDEST[0]_INST_0 
       (.I0(m_axis_V_dest_V_1_payload_B),
        .I1(m_axis_V_dest_V_1_sel),
        .I2(m_axis_V_dest_V_1_payload_A),
        .O(m_axis_TDEST));
  LUT3 #(
    .INIT(8'hB8)) 
    \m_axis_TID[0]_INST_0 
       (.I0(m_axis_V_id_V_1_payload_B),
        .I1(m_axis_V_id_V_1_sel),
        .I2(m_axis_V_id_V_1_payload_A),
        .O(m_axis_TID));
  LUT3 #(
    .INIT(8'hB8)) 
    \m_axis_TKEEP[0]_INST_0 
       (.I0(m_axis_V_keep_V_1_payload_B),
        .I1(m_axis_V_keep_V_1_sel),
        .I2(m_axis_V_keep_V_1_payload_A),
        .O(m_axis_TKEEP));
  LUT3 #(
    .INIT(8'hB8)) 
    \m_axis_TLAST[0]_INST_0 
       (.I0(m_axis_V_last_V_1_payload_B),
        .I1(m_axis_V_last_V_1_sel),
        .I2(m_axis_V_last_V_1_payload_A),
        .O(m_axis_TLAST));
  LUT3 #(
    .INIT(8'hB8)) 
    \m_axis_TSTRB[0]_INST_0 
       (.I0(m_axis_V_strb_V_1_payload_B),
        .I1(m_axis_V_strb_V_1_sel),
        .I2(m_axis_V_strb_V_1_payload_A),
        .O(m_axis_TSTRB));
  LUT3 #(
    .INIT(8'hB8)) 
    \m_axis_TUSER[0]_INST_0 
       (.I0(m_axis_V_user_V_1_payload_B),
        .I1(m_axis_V_user_V_1_sel),
        .I2(m_axis_V_user_V_1_payload_A),
        .O(m_axis_TUSER));
  LUT3 #(
    .INIT(8'h45)) 
    \m_axis_V_data_V_1_payload_A[7]_i_1 
       (.I0(m_axis_V_data_V_1_sel_wr),
        .I1(m_axis_V_data_V_1_ack_in),
        .I2(\m_axis_V_data_V_1_state_reg_n_1_[0] ),
        .O(m_axis_V_data_V_1_load_A));
  FDRE \m_axis_V_data_V_1_payload_A_reg[0] 
       (.C(ap_clk),
        .CE(m_axis_V_data_V_1_load_A),
        .D(tmp_data_V_2_reg_271[0]),
        .Q(m_axis_V_data_V_1_payload_A[0]),
        .R(1'b0));
  FDRE \m_axis_V_data_V_1_payload_A_reg[1] 
       (.C(ap_clk),
        .CE(m_axis_V_data_V_1_load_A),
        .D(tmp_data_V_2_reg_271[1]),
        .Q(m_axis_V_data_V_1_payload_A[1]),
        .R(1'b0));
  FDRE \m_axis_V_data_V_1_payload_A_reg[2] 
       (.C(ap_clk),
        .CE(m_axis_V_data_V_1_load_A),
        .D(tmp_data_V_2_reg_271[2]),
        .Q(m_axis_V_data_V_1_payload_A[2]),
        .R(1'b0));
  FDRE \m_axis_V_data_V_1_payload_A_reg[3] 
       (.C(ap_clk),
        .CE(m_axis_V_data_V_1_load_A),
        .D(tmp_data_V_2_reg_271[3]),
        .Q(m_axis_V_data_V_1_payload_A[3]),
        .R(1'b0));
  FDRE \m_axis_V_data_V_1_payload_A_reg[4] 
       (.C(ap_clk),
        .CE(m_axis_V_data_V_1_load_A),
        .D(tmp_data_V_2_reg_271[4]),
        .Q(m_axis_V_data_V_1_payload_A[4]),
        .R(1'b0));
  FDRE \m_axis_V_data_V_1_payload_A_reg[5] 
       (.C(ap_clk),
        .CE(m_axis_V_data_V_1_load_A),
        .D(tmp_data_V_2_reg_271[5]),
        .Q(m_axis_V_data_V_1_payload_A[5]),
        .R(1'b0));
  FDRE \m_axis_V_data_V_1_payload_A_reg[6] 
       (.C(ap_clk),
        .CE(m_axis_V_data_V_1_load_A),
        .D(tmp_data_V_2_reg_271[6]),
        .Q(m_axis_V_data_V_1_payload_A[6]),
        .R(1'b0));
  FDRE \m_axis_V_data_V_1_payload_A_reg[7] 
       (.C(ap_clk),
        .CE(m_axis_V_data_V_1_load_A),
        .D(tmp_data_V_2_reg_271[7]),
        .Q(m_axis_V_data_V_1_payload_A[7]),
        .R(1'b0));
  LUT3 #(
    .INIT(8'h8A)) 
    \m_axis_V_data_V_1_payload_B[7]_i_1 
       (.I0(m_axis_V_data_V_1_sel_wr),
        .I1(m_axis_V_data_V_1_ack_in),
        .I2(\m_axis_V_data_V_1_state_reg_n_1_[0] ),
        .O(m_axis_V_data_V_1_load_B));
  FDRE \m_axis_V_data_V_1_payload_B_reg[0] 
       (.C(ap_clk),
        .CE(m_axis_V_data_V_1_load_B),
        .D(tmp_data_V_2_reg_271[0]),
        .Q(m_axis_V_data_V_1_payload_B[0]),
        .R(1'b0));
  FDRE \m_axis_V_data_V_1_payload_B_reg[1] 
       (.C(ap_clk),
        .CE(m_axis_V_data_V_1_load_B),
        .D(tmp_data_V_2_reg_271[1]),
        .Q(m_axis_V_data_V_1_payload_B[1]),
        .R(1'b0));
  FDRE \m_axis_V_data_V_1_payload_B_reg[2] 
       (.C(ap_clk),
        .CE(m_axis_V_data_V_1_load_B),
        .D(tmp_data_V_2_reg_271[2]),
        .Q(m_axis_V_data_V_1_payload_B[2]),
        .R(1'b0));
  FDRE \m_axis_V_data_V_1_payload_B_reg[3] 
       (.C(ap_clk),
        .CE(m_axis_V_data_V_1_load_B),
        .D(tmp_data_V_2_reg_271[3]),
        .Q(m_axis_V_data_V_1_payload_B[3]),
        .R(1'b0));
  FDRE \m_axis_V_data_V_1_payload_B_reg[4] 
       (.C(ap_clk),
        .CE(m_axis_V_data_V_1_load_B),
        .D(tmp_data_V_2_reg_271[4]),
        .Q(m_axis_V_data_V_1_payload_B[4]),
        .R(1'b0));
  FDRE \m_axis_V_data_V_1_payload_B_reg[5] 
       (.C(ap_clk),
        .CE(m_axis_V_data_V_1_load_B),
        .D(tmp_data_V_2_reg_271[5]),
        .Q(m_axis_V_data_V_1_payload_B[5]),
        .R(1'b0));
  FDRE \m_axis_V_data_V_1_payload_B_reg[6] 
       (.C(ap_clk),
        .CE(m_axis_V_data_V_1_load_B),
        .D(tmp_data_V_2_reg_271[6]),
        .Q(m_axis_V_data_V_1_payload_B[6]),
        .R(1'b0));
  FDRE \m_axis_V_data_V_1_payload_B_reg[7] 
       (.C(ap_clk),
        .CE(m_axis_V_data_V_1_load_B),
        .D(tmp_data_V_2_reg_271[7]),
        .Q(m_axis_V_data_V_1_payload_B[7]),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair53" *) 
  LUT3 #(
    .INIT(8'h78)) 
    m_axis_V_data_V_1_sel_rd_i_1
       (.I0(\m_axis_V_data_V_1_state_reg_n_1_[0] ),
        .I1(m_axis_TREADY),
        .I2(m_axis_V_data_V_1_sel),
        .O(m_axis_V_data_V_1_sel_rd_i_1_n_1));
  FDRE #(
    .INIT(1'b0)) 
    m_axis_V_data_V_1_sel_rd_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(m_axis_V_data_V_1_sel_rd_i_1_n_1),
        .Q(m_axis_V_data_V_1_sel),
        .R(ap_rst_n_inv));
  (* SOFT_HLUTNM = "soft_lutpair46" *) 
  LUT2 #(
    .INIT(4'h9)) 
    m_axis_V_data_V_1_sel_wr_i_1
       (.I0(\m_axis_V_dest_V_1_state[0]_i_2_n_1 ),
        .I1(m_axis_V_data_V_1_sel_wr),
        .O(m_axis_V_data_V_1_sel_wr_i_1_n_1));
  FDRE #(
    .INIT(1'b0)) 
    m_axis_V_data_V_1_sel_wr_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(m_axis_V_data_V_1_sel_wr_i_1_n_1),
        .Q(m_axis_V_data_V_1_sel_wr),
        .R(ap_rst_n_inv));
  (* SOFT_HLUTNM = "soft_lutpair43" *) 
  LUT4 #(
    .INIT(16'h2AFF)) 
    \m_axis_V_data_V_1_state[0]_i_1 
       (.I0(\m_axis_V_data_V_1_state_reg_n_1_[0] ),
        .I1(m_axis_TREADY),
        .I2(m_axis_V_data_V_1_ack_in),
        .I3(\m_axis_V_dest_V_1_state[0]_i_2_n_1 ),
        .O(\m_axis_V_data_V_1_state[0]_i_1_n_1 ));
  (* SOFT_HLUTNM = "soft_lutpair43" *) 
  LUT4 #(
    .INIT(16'hFBBB)) 
    \m_axis_V_data_V_1_state[1]_i_1 
       (.I0(m_axis_TREADY),
        .I1(\m_axis_V_data_V_1_state_reg_n_1_[0] ),
        .I2(\m_axis_V_dest_V_1_state[0]_i_2_n_1 ),
        .I3(m_axis_V_data_V_1_ack_in),
        .O(m_axis_V_data_V_1_state));
  FDRE #(
    .INIT(1'b0)) 
    \m_axis_V_data_V_1_state_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\m_axis_V_data_V_1_state[0]_i_1_n_1 ),
        .Q(\m_axis_V_data_V_1_state_reg_n_1_[0] ),
        .R(ap_rst_n_inv));
  FDRE #(
    .INIT(1'b0)) 
    \m_axis_V_data_V_1_state_reg[1] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(m_axis_V_data_V_1_state),
        .Q(m_axis_V_data_V_1_ack_in),
        .R(ap_rst_n_inv));
  LUT5 #(
    .INIT(32'hEFEE2022)) 
    \m_axis_V_dest_V_1_payload_A[0]_i_1 
       (.I0(tmp_dest_V_reg_266),
        .I1(m_axis_V_dest_V_1_sel_wr),
        .I2(m_axis_V_dest_V_1_ack_in),
        .I3(m_axis_TVALID),
        .I4(m_axis_V_dest_V_1_payload_A),
        .O(\m_axis_V_dest_V_1_payload_A[0]_i_1_n_1 ));
  FDRE \m_axis_V_dest_V_1_payload_A_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\m_axis_V_dest_V_1_payload_A[0]_i_1_n_1 ),
        .Q(m_axis_V_dest_V_1_payload_A),
        .R(1'b0));
  LUT5 #(
    .INIT(32'hBFBB8088)) 
    \m_axis_V_dest_V_1_payload_B[0]_i_1 
       (.I0(tmp_dest_V_reg_266),
        .I1(m_axis_V_dest_V_1_sel_wr),
        .I2(m_axis_V_dest_V_1_ack_in),
        .I3(m_axis_TVALID),
        .I4(m_axis_V_dest_V_1_payload_B),
        .O(\m_axis_V_dest_V_1_payload_B[0]_i_1_n_1 ));
  FDRE \m_axis_V_dest_V_1_payload_B_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\m_axis_V_dest_V_1_payload_B[0]_i_1_n_1 ),
        .Q(m_axis_V_dest_V_1_payload_B),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair52" *) 
  LUT3 #(
    .INIT(8'h78)) 
    m_axis_V_dest_V_1_sel_rd_i_1
       (.I0(m_axis_TVALID),
        .I1(m_axis_TREADY),
        .I2(m_axis_V_dest_V_1_sel),
        .O(m_axis_V_dest_V_1_sel_rd_i_1_n_1));
  FDRE #(
    .INIT(1'b0)) 
    m_axis_V_dest_V_1_sel_rd_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(m_axis_V_dest_V_1_sel_rd_i_1_n_1),
        .Q(m_axis_V_dest_V_1_sel),
        .R(ap_rst_n_inv));
  (* SOFT_HLUTNM = "soft_lutpair47" *) 
  LUT3 #(
    .INIT(8'hB4)) 
    m_axis_V_dest_V_1_sel_wr_i_1
       (.I0(\m_axis_V_dest_V_1_state[0]_i_2_n_1 ),
        .I1(m_axis_V_dest_V_1_ack_in),
        .I2(m_axis_V_dest_V_1_sel_wr),
        .O(m_axis_V_dest_V_1_sel_wr_i_1_n_1));
  FDRE #(
    .INIT(1'b0)) 
    m_axis_V_dest_V_1_sel_wr_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(m_axis_V_dest_V_1_sel_wr_i_1_n_1),
        .Q(m_axis_V_dest_V_1_sel_wr),
        .R(ap_rst_n_inv));
  (* SOFT_HLUTNM = "soft_lutpair42" *) 
  LUT4 #(
    .INIT(16'h5DCC)) 
    \m_axis_V_dest_V_1_state[0]_i_1 
       (.I0(\m_axis_V_dest_V_1_state[0]_i_2_n_1 ),
        .I1(m_axis_TVALID),
        .I2(m_axis_TREADY),
        .I3(m_axis_V_dest_V_1_ack_in),
        .O(\m_axis_V_dest_V_1_state[0]_i_1_n_1 ));
  LUT6 #(
    .INIT(64'hFFFFAAEAFFFFFFFF)) 
    \m_axis_V_dest_V_1_state[0]_i_2 
       (.I0(\m_axis_V_dest_V_1_state[0]_i_3_n_1 ),
        .I1(icmp_ln17_fu_158_p2),
        .I2(ap_enable_reg_pp0_iter0),
        .I3(\s_axis_V_data_V_0_state_reg_n_1_[0] ),
        .I4(\tmp_data_V_2_reg_271[7]_i_3_n_1 ),
        .I5(ap_CS_fsm_pp0_stage0),
        .O(\m_axis_V_dest_V_1_state[0]_i_2_n_1 ));
  (* SOFT_HLUTNM = "soft_lutpair26" *) 
  LUT2 #(
    .INIT(4'h7)) 
    \m_axis_V_dest_V_1_state[0]_i_3 
       (.I0(icmp_ln17_reg_232),
        .I1(ap_enable_reg_pp0_iter1_reg_n_1),
        .O(\m_axis_V_dest_V_1_state[0]_i_3_n_1 ));
  (* SOFT_HLUTNM = "soft_lutpair42" *) 
  LUT4 #(
    .INIT(16'hFBBB)) 
    \m_axis_V_dest_V_1_state[1]_i_1 
       (.I0(m_axis_TREADY),
        .I1(m_axis_TVALID),
        .I2(\m_axis_V_dest_V_1_state[0]_i_2_n_1 ),
        .I3(m_axis_V_dest_V_1_ack_in),
        .O(\m_axis_V_dest_V_1_state[1]_i_1_n_1 ));
  FDRE #(
    .INIT(1'b0)) 
    \m_axis_V_dest_V_1_state_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\m_axis_V_dest_V_1_state[0]_i_1_n_1 ),
        .Q(m_axis_TVALID),
        .R(ap_rst_n_inv));
  FDRE #(
    .INIT(1'b0)) 
    \m_axis_V_dest_V_1_state_reg[1] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\m_axis_V_dest_V_1_state[1]_i_1_n_1 ),
        .Q(m_axis_V_dest_V_1_ack_in),
        .R(ap_rst_n_inv));
  LUT5 #(
    .INIT(32'hEFEE2022)) 
    \m_axis_V_id_V_1_payload_A[0]_i_1 
       (.I0(tmp_id_V_reg_261),
        .I1(m_axis_V_id_V_1_sel_wr),
        .I2(m_axis_V_id_V_1_ack_in),
        .I3(\m_axis_V_id_V_1_state_reg_n_1_[0] ),
        .I4(m_axis_V_id_V_1_payload_A),
        .O(\m_axis_V_id_V_1_payload_A[0]_i_1_n_1 ));
  FDRE \m_axis_V_id_V_1_payload_A_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\m_axis_V_id_V_1_payload_A[0]_i_1_n_1 ),
        .Q(m_axis_V_id_V_1_payload_A),
        .R(1'b0));
  LUT5 #(
    .INIT(32'hBFBB8088)) 
    \m_axis_V_id_V_1_payload_B[0]_i_1 
       (.I0(tmp_id_V_reg_261),
        .I1(m_axis_V_id_V_1_sel_wr),
        .I2(m_axis_V_id_V_1_ack_in),
        .I3(\m_axis_V_id_V_1_state_reg_n_1_[0] ),
        .I4(m_axis_V_id_V_1_payload_B),
        .O(\m_axis_V_id_V_1_payload_B[0]_i_1_n_1 ));
  FDRE \m_axis_V_id_V_1_payload_B_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\m_axis_V_id_V_1_payload_B[0]_i_1_n_1 ),
        .Q(m_axis_V_id_V_1_payload_B),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair55" *) 
  LUT3 #(
    .INIT(8'h78)) 
    m_axis_V_id_V_1_sel_rd_i_1
       (.I0(m_axis_TREADY),
        .I1(\m_axis_V_id_V_1_state_reg_n_1_[0] ),
        .I2(m_axis_V_id_V_1_sel),
        .O(m_axis_V_id_V_1_sel_rd_i_1_n_1));
  FDRE #(
    .INIT(1'b0)) 
    m_axis_V_id_V_1_sel_rd_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(m_axis_V_id_V_1_sel_rd_i_1_n_1),
        .Q(m_axis_V_id_V_1_sel),
        .R(ap_rst_n_inv));
  (* SOFT_HLUTNM = "soft_lutpair48" *) 
  LUT3 #(
    .INIT(8'hB4)) 
    m_axis_V_id_V_1_sel_wr_i_1
       (.I0(\m_axis_V_dest_V_1_state[0]_i_2_n_1 ),
        .I1(m_axis_V_id_V_1_ack_in),
        .I2(m_axis_V_id_V_1_sel_wr),
        .O(m_axis_V_id_V_1_sel_wr_i_1_n_1));
  FDRE #(
    .INIT(1'b0)) 
    m_axis_V_id_V_1_sel_wr_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(m_axis_V_id_V_1_sel_wr_i_1_n_1),
        .Q(m_axis_V_id_V_1_sel_wr),
        .R(ap_rst_n_inv));
  (* SOFT_HLUTNM = "soft_lutpair41" *) 
  LUT4 #(
    .INIT(16'h5DCC)) 
    \m_axis_V_id_V_1_state[0]_i_1 
       (.I0(\m_axis_V_dest_V_1_state[0]_i_2_n_1 ),
        .I1(\m_axis_V_id_V_1_state_reg_n_1_[0] ),
        .I2(m_axis_TREADY),
        .I3(m_axis_V_id_V_1_ack_in),
        .O(\m_axis_V_id_V_1_state[0]_i_1_n_1 ));
  (* SOFT_HLUTNM = "soft_lutpair41" *) 
  LUT4 #(
    .INIT(16'hFBBB)) 
    \m_axis_V_id_V_1_state[1]_i_1 
       (.I0(m_axis_TREADY),
        .I1(\m_axis_V_id_V_1_state_reg_n_1_[0] ),
        .I2(\m_axis_V_dest_V_1_state[0]_i_2_n_1 ),
        .I3(m_axis_V_id_V_1_ack_in),
        .O(\m_axis_V_id_V_1_state[1]_i_1_n_1 ));
  FDRE #(
    .INIT(1'b0)) 
    \m_axis_V_id_V_1_state_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\m_axis_V_id_V_1_state[0]_i_1_n_1 ),
        .Q(\m_axis_V_id_V_1_state_reg_n_1_[0] ),
        .R(ap_rst_n_inv));
  FDRE #(
    .INIT(1'b0)) 
    \m_axis_V_id_V_1_state_reg[1] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\m_axis_V_id_V_1_state[1]_i_1_n_1 ),
        .Q(m_axis_V_id_V_1_ack_in),
        .R(ap_rst_n_inv));
  LUT5 #(
    .INIT(32'hEFEE2022)) 
    \m_axis_V_keep_V_1_payload_A[0]_i_1 
       (.I0(tmp_keep_V_reg_241),
        .I1(m_axis_V_keep_V_1_sel_wr),
        .I2(m_axis_V_keep_V_1_ack_in),
        .I3(\m_axis_V_keep_V_1_state_reg_n_1_[0] ),
        .I4(m_axis_V_keep_V_1_payload_A),
        .O(\m_axis_V_keep_V_1_payload_A[0]_i_1_n_1 ));
  FDRE \m_axis_V_keep_V_1_payload_A_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\m_axis_V_keep_V_1_payload_A[0]_i_1_n_1 ),
        .Q(m_axis_V_keep_V_1_payload_A),
        .R(1'b0));
  LUT5 #(
    .INIT(32'hBFBB8088)) 
    \m_axis_V_keep_V_1_payload_B[0]_i_1 
       (.I0(tmp_keep_V_reg_241),
        .I1(m_axis_V_keep_V_1_sel_wr),
        .I2(m_axis_V_keep_V_1_ack_in),
        .I3(\m_axis_V_keep_V_1_state_reg_n_1_[0] ),
        .I4(m_axis_V_keep_V_1_payload_B),
        .O(\m_axis_V_keep_V_1_payload_B[0]_i_1_n_1 ));
  FDRE \m_axis_V_keep_V_1_payload_B_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\m_axis_V_keep_V_1_payload_B[0]_i_1_n_1 ),
        .Q(m_axis_V_keep_V_1_payload_B),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair53" *) 
  LUT3 #(
    .INIT(8'h78)) 
    m_axis_V_keep_V_1_sel_rd_i_1
       (.I0(\m_axis_V_keep_V_1_state_reg_n_1_[0] ),
        .I1(m_axis_TREADY),
        .I2(m_axis_V_keep_V_1_sel),
        .O(m_axis_V_keep_V_1_sel_rd_i_1_n_1));
  FDRE #(
    .INIT(1'b0)) 
    m_axis_V_keep_V_1_sel_rd_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(m_axis_V_keep_V_1_sel_rd_i_1_n_1),
        .Q(m_axis_V_keep_V_1_sel),
        .R(ap_rst_n_inv));
  (* SOFT_HLUTNM = "soft_lutpair46" *) 
  LUT3 #(
    .INIT(8'hB4)) 
    m_axis_V_keep_V_1_sel_wr_i_1
       (.I0(\m_axis_V_dest_V_1_state[0]_i_2_n_1 ),
        .I1(m_axis_V_keep_V_1_ack_in),
        .I2(m_axis_V_keep_V_1_sel_wr),
        .O(m_axis_V_keep_V_1_sel_wr_i_1_n_1));
  FDRE #(
    .INIT(1'b0)) 
    m_axis_V_keep_V_1_sel_wr_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(m_axis_V_keep_V_1_sel_wr_i_1_n_1),
        .Q(m_axis_V_keep_V_1_sel_wr),
        .R(ap_rst_n_inv));
  (* SOFT_HLUTNM = "soft_lutpair40" *) 
  LUT4 #(
    .INIT(16'h5DCC)) 
    \m_axis_V_keep_V_1_state[0]_i_1 
       (.I0(\m_axis_V_dest_V_1_state[0]_i_2_n_1 ),
        .I1(\m_axis_V_keep_V_1_state_reg_n_1_[0] ),
        .I2(m_axis_TREADY),
        .I3(m_axis_V_keep_V_1_ack_in),
        .O(\m_axis_V_keep_V_1_state[0]_i_1_n_1 ));
  (* SOFT_HLUTNM = "soft_lutpair40" *) 
  LUT4 #(
    .INIT(16'hFBBB)) 
    \m_axis_V_keep_V_1_state[1]_i_1 
       (.I0(m_axis_TREADY),
        .I1(\m_axis_V_keep_V_1_state_reg_n_1_[0] ),
        .I2(\m_axis_V_dest_V_1_state[0]_i_2_n_1 ),
        .I3(m_axis_V_keep_V_1_ack_in),
        .O(\m_axis_V_keep_V_1_state[1]_i_1_n_1 ));
  FDRE #(
    .INIT(1'b0)) 
    \m_axis_V_keep_V_1_state_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\m_axis_V_keep_V_1_state[0]_i_1_n_1 ),
        .Q(\m_axis_V_keep_V_1_state_reg_n_1_[0] ),
        .R(ap_rst_n_inv));
  FDRE #(
    .INIT(1'b0)) 
    \m_axis_V_keep_V_1_state_reg[1] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\m_axis_V_keep_V_1_state[1]_i_1_n_1 ),
        .Q(m_axis_V_keep_V_1_ack_in),
        .R(ap_rst_n_inv));
  LUT5 #(
    .INIT(32'hEFEE2022)) 
    \m_axis_V_last_V_1_payload_A[0]_i_1 
       (.I0(tmp_last_V_reg_256),
        .I1(m_axis_V_last_V_1_sel_wr),
        .I2(m_axis_V_last_V_1_ack_in),
        .I3(\m_axis_V_last_V_1_state_reg_n_1_[0] ),
        .I4(m_axis_V_last_V_1_payload_A),
        .O(\m_axis_V_last_V_1_payload_A[0]_i_1_n_1 ));
  FDRE \m_axis_V_last_V_1_payload_A_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\m_axis_V_last_V_1_payload_A[0]_i_1_n_1 ),
        .Q(m_axis_V_last_V_1_payload_A),
        .R(1'b0));
  LUT5 #(
    .INIT(32'hBFBB8088)) 
    \m_axis_V_last_V_1_payload_B[0]_i_1 
       (.I0(tmp_last_V_reg_256),
        .I1(m_axis_V_last_V_1_sel_wr),
        .I2(m_axis_V_last_V_1_ack_in),
        .I3(\m_axis_V_last_V_1_state_reg_n_1_[0] ),
        .I4(m_axis_V_last_V_1_payload_B),
        .O(\m_axis_V_last_V_1_payload_B[0]_i_1_n_1 ));
  FDRE \m_axis_V_last_V_1_payload_B_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\m_axis_V_last_V_1_payload_B[0]_i_1_n_1 ),
        .Q(m_axis_V_last_V_1_payload_B),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair55" *) 
  LUT3 #(
    .INIT(8'h78)) 
    m_axis_V_last_V_1_sel_rd_i_1
       (.I0(\m_axis_V_last_V_1_state_reg_n_1_[0] ),
        .I1(m_axis_TREADY),
        .I2(m_axis_V_last_V_1_sel),
        .O(m_axis_V_last_V_1_sel_rd_i_1_n_1));
  FDRE #(
    .INIT(1'b0)) 
    m_axis_V_last_V_1_sel_rd_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(m_axis_V_last_V_1_sel_rd_i_1_n_1),
        .Q(m_axis_V_last_V_1_sel),
        .R(ap_rst_n_inv));
  (* SOFT_HLUTNM = "soft_lutpair48" *) 
  LUT3 #(
    .INIT(8'hB4)) 
    m_axis_V_last_V_1_sel_wr_i_1
       (.I0(\m_axis_V_dest_V_1_state[0]_i_2_n_1 ),
        .I1(m_axis_V_last_V_1_ack_in),
        .I2(m_axis_V_last_V_1_sel_wr),
        .O(m_axis_V_last_V_1_sel_wr_i_1_n_1));
  FDRE #(
    .INIT(1'b0)) 
    m_axis_V_last_V_1_sel_wr_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(m_axis_V_last_V_1_sel_wr_i_1_n_1),
        .Q(m_axis_V_last_V_1_sel_wr),
        .R(ap_rst_n_inv));
  (* SOFT_HLUTNM = "soft_lutpair44" *) 
  LUT4 #(
    .INIT(16'h2FAA)) 
    \m_axis_V_last_V_1_state[0]_i_1 
       (.I0(\m_axis_V_last_V_1_state_reg_n_1_[0] ),
        .I1(m_axis_TREADY),
        .I2(\m_axis_V_dest_V_1_state[0]_i_2_n_1 ),
        .I3(m_axis_V_last_V_1_ack_in),
        .O(\m_axis_V_last_V_1_state[0]_i_1_n_1 ));
  (* SOFT_HLUTNM = "soft_lutpair44" *) 
  LUT4 #(
    .INIT(16'hFBBB)) 
    \m_axis_V_last_V_1_state[1]_i_1 
       (.I0(m_axis_TREADY),
        .I1(\m_axis_V_last_V_1_state_reg_n_1_[0] ),
        .I2(\m_axis_V_dest_V_1_state[0]_i_2_n_1 ),
        .I3(m_axis_V_last_V_1_ack_in),
        .O(\m_axis_V_last_V_1_state[1]_i_1_n_1 ));
  FDRE #(
    .INIT(1'b0)) 
    \m_axis_V_last_V_1_state_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\m_axis_V_last_V_1_state[0]_i_1_n_1 ),
        .Q(\m_axis_V_last_V_1_state_reg_n_1_[0] ),
        .R(ap_rst_n_inv));
  FDRE #(
    .INIT(1'b0)) 
    \m_axis_V_last_V_1_state_reg[1] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\m_axis_V_last_V_1_state[1]_i_1_n_1 ),
        .Q(m_axis_V_last_V_1_ack_in),
        .R(ap_rst_n_inv));
  LUT5 #(
    .INIT(32'hEFEE2022)) 
    \m_axis_V_strb_V_1_payload_A[0]_i_1 
       (.I0(tmp_strb_V_reg_246),
        .I1(m_axis_V_strb_V_1_sel_wr),
        .I2(m_axis_V_strb_V_1_ack_in),
        .I3(\m_axis_V_strb_V_1_state_reg_n_1_[0] ),
        .I4(m_axis_V_strb_V_1_payload_A),
        .O(\m_axis_V_strb_V_1_payload_A[0]_i_1_n_1 ));
  FDRE \m_axis_V_strb_V_1_payload_A_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\m_axis_V_strb_V_1_payload_A[0]_i_1_n_1 ),
        .Q(m_axis_V_strb_V_1_payload_A),
        .R(1'b0));
  LUT5 #(
    .INIT(32'hBFBB8088)) 
    \m_axis_V_strb_V_1_payload_B[0]_i_1 
       (.I0(tmp_strb_V_reg_246),
        .I1(m_axis_V_strb_V_1_sel_wr),
        .I2(m_axis_V_strb_V_1_ack_in),
        .I3(\m_axis_V_strb_V_1_state_reg_n_1_[0] ),
        .I4(m_axis_V_strb_V_1_payload_B),
        .O(\m_axis_V_strb_V_1_payload_B[0]_i_1_n_1 ));
  FDRE \m_axis_V_strb_V_1_payload_B_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\m_axis_V_strb_V_1_payload_B[0]_i_1_n_1 ),
        .Q(m_axis_V_strb_V_1_payload_B),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair54" *) 
  LUT3 #(
    .INIT(8'h78)) 
    m_axis_V_strb_V_1_sel_rd_i_1
       (.I0(\m_axis_V_strb_V_1_state_reg_n_1_[0] ),
        .I1(m_axis_TREADY),
        .I2(m_axis_V_strb_V_1_sel),
        .O(m_axis_V_strb_V_1_sel_rd_i_1_n_1));
  FDRE #(
    .INIT(1'b0)) 
    m_axis_V_strb_V_1_sel_rd_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(m_axis_V_strb_V_1_sel_rd_i_1_n_1),
        .Q(m_axis_V_strb_V_1_sel),
        .R(ap_rst_n_inv));
  LUT3 #(
    .INIT(8'hB4)) 
    m_axis_V_strb_V_1_sel_wr_i_1
       (.I0(\m_axis_V_dest_V_1_state[0]_i_2_n_1 ),
        .I1(m_axis_V_strb_V_1_ack_in),
        .I2(m_axis_V_strb_V_1_sel_wr),
        .O(m_axis_V_strb_V_1_sel_wr_i_1_n_1));
  FDRE #(
    .INIT(1'b0)) 
    m_axis_V_strb_V_1_sel_wr_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(m_axis_V_strb_V_1_sel_wr_i_1_n_1),
        .Q(m_axis_V_strb_V_1_sel_wr),
        .R(ap_rst_n_inv));
  (* SOFT_HLUTNM = "soft_lutpair38" *) 
  LUT4 #(
    .INIT(16'h2FAA)) 
    \m_axis_V_strb_V_1_state[0]_i_1 
       (.I0(\m_axis_V_strb_V_1_state_reg_n_1_[0] ),
        .I1(m_axis_TREADY),
        .I2(\m_axis_V_dest_V_1_state[0]_i_2_n_1 ),
        .I3(m_axis_V_strb_V_1_ack_in),
        .O(\m_axis_V_strb_V_1_state[0]_i_1_n_1 ));
  (* SOFT_HLUTNM = "soft_lutpair38" *) 
  LUT4 #(
    .INIT(16'hFBBB)) 
    \m_axis_V_strb_V_1_state[1]_i_1 
       (.I0(m_axis_TREADY),
        .I1(\m_axis_V_strb_V_1_state_reg_n_1_[0] ),
        .I2(\m_axis_V_dest_V_1_state[0]_i_2_n_1 ),
        .I3(m_axis_V_strb_V_1_ack_in),
        .O(\m_axis_V_strb_V_1_state[1]_i_1_n_1 ));
  FDRE #(
    .INIT(1'b0)) 
    \m_axis_V_strb_V_1_state_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\m_axis_V_strb_V_1_state[0]_i_1_n_1 ),
        .Q(\m_axis_V_strb_V_1_state_reg_n_1_[0] ),
        .R(ap_rst_n_inv));
  FDRE #(
    .INIT(1'b0)) 
    \m_axis_V_strb_V_1_state_reg[1] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\m_axis_V_strb_V_1_state[1]_i_1_n_1 ),
        .Q(m_axis_V_strb_V_1_ack_in),
        .R(ap_rst_n_inv));
  LUT5 #(
    .INIT(32'hEFEE2022)) 
    \m_axis_V_user_V_1_payload_A[0]_i_1 
       (.I0(tmp_user_V_reg_251),
        .I1(m_axis_V_user_V_1_sel_wr),
        .I2(m_axis_V_user_V_1_ack_in),
        .I3(\m_axis_V_user_V_1_state_reg_n_1_[0] ),
        .I4(m_axis_V_user_V_1_payload_A),
        .O(\m_axis_V_user_V_1_payload_A[0]_i_1_n_1 ));
  FDRE \m_axis_V_user_V_1_payload_A_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\m_axis_V_user_V_1_payload_A[0]_i_1_n_1 ),
        .Q(m_axis_V_user_V_1_payload_A),
        .R(1'b0));
  LUT5 #(
    .INIT(32'hBFBB8088)) 
    \m_axis_V_user_V_1_payload_B[0]_i_1 
       (.I0(tmp_user_V_reg_251),
        .I1(m_axis_V_user_V_1_sel_wr),
        .I2(m_axis_V_user_V_1_ack_in),
        .I3(\m_axis_V_user_V_1_state_reg_n_1_[0] ),
        .I4(m_axis_V_user_V_1_payload_B),
        .O(\m_axis_V_user_V_1_payload_B[0]_i_1_n_1 ));
  FDRE \m_axis_V_user_V_1_payload_B_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\m_axis_V_user_V_1_payload_B[0]_i_1_n_1 ),
        .Q(m_axis_V_user_V_1_payload_B),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair54" *) 
  LUT3 #(
    .INIT(8'h78)) 
    m_axis_V_user_V_1_sel_rd_i_1
       (.I0(\m_axis_V_user_V_1_state_reg_n_1_[0] ),
        .I1(m_axis_TREADY),
        .I2(m_axis_V_user_V_1_sel),
        .O(m_axis_V_user_V_1_sel_rd_i_1_n_1));
  FDRE #(
    .INIT(1'b0)) 
    m_axis_V_user_V_1_sel_rd_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(m_axis_V_user_V_1_sel_rd_i_1_n_1),
        .Q(m_axis_V_user_V_1_sel),
        .R(ap_rst_n_inv));
  (* SOFT_HLUTNM = "soft_lutpair47" *) 
  LUT3 #(
    .INIT(8'hB4)) 
    m_axis_V_user_V_1_sel_wr_i_1
       (.I0(\m_axis_V_dest_V_1_state[0]_i_2_n_1 ),
        .I1(m_axis_V_user_V_1_ack_in),
        .I2(m_axis_V_user_V_1_sel_wr),
        .O(m_axis_V_user_V_1_sel_wr_i_1_n_1));
  FDRE #(
    .INIT(1'b0)) 
    m_axis_V_user_V_1_sel_wr_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(m_axis_V_user_V_1_sel_wr_i_1_n_1),
        .Q(m_axis_V_user_V_1_sel_wr),
        .R(ap_rst_n_inv));
  (* SOFT_HLUTNM = "soft_lutpair45" *) 
  LUT4 #(
    .INIT(16'h5DCC)) 
    \m_axis_V_user_V_1_state[0]_i_1 
       (.I0(\m_axis_V_dest_V_1_state[0]_i_2_n_1 ),
        .I1(\m_axis_V_user_V_1_state_reg_n_1_[0] ),
        .I2(m_axis_TREADY),
        .I3(m_axis_V_user_V_1_ack_in),
        .O(\m_axis_V_user_V_1_state[0]_i_1_n_1 ));
  (* SOFT_HLUTNM = "soft_lutpair45" *) 
  LUT4 #(
    .INIT(16'hFBBB)) 
    \m_axis_V_user_V_1_state[1]_i_1 
       (.I0(m_axis_TREADY),
        .I1(\m_axis_V_user_V_1_state_reg_n_1_[0] ),
        .I2(\m_axis_V_dest_V_1_state[0]_i_2_n_1 ),
        .I3(m_axis_V_user_V_1_ack_in),
        .O(\m_axis_V_user_V_1_state[1]_i_1_n_1 ));
  FDRE #(
    .INIT(1'b0)) 
    \m_axis_V_user_V_1_state_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\m_axis_V_user_V_1_state[0]_i_1_n_1 ),
        .Q(\m_axis_V_user_V_1_state_reg_n_1_[0] ),
        .R(ap_rst_n_inv));
  FDRE #(
    .INIT(1'b0)) 
    \m_axis_V_user_V_1_state_reg[1] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\m_axis_V_user_V_1_state[1]_i_1_n_1 ),
        .Q(m_axis_V_user_V_1_ack_in),
        .R(ap_rst_n_inv));
  FDRE \pixel_count_read_reg_227_reg[0] 
       (.C(ap_clk),
        .CE(ap_NS_fsm1),
        .D(pixel_count[0]),
        .Q(pixel_count_read_reg_227[0]),
        .R(1'b0));
  FDRE \pixel_count_read_reg_227_reg[10] 
       (.C(ap_clk),
        .CE(ap_NS_fsm1),
        .D(pixel_count[10]),
        .Q(pixel_count_read_reg_227[10]),
        .R(1'b0));
  FDRE \pixel_count_read_reg_227_reg[11] 
       (.C(ap_clk),
        .CE(ap_NS_fsm1),
        .D(pixel_count[11]),
        .Q(pixel_count_read_reg_227[11]),
        .R(1'b0));
  FDRE \pixel_count_read_reg_227_reg[12] 
       (.C(ap_clk),
        .CE(ap_NS_fsm1),
        .D(pixel_count[12]),
        .Q(pixel_count_read_reg_227[12]),
        .R(1'b0));
  FDRE \pixel_count_read_reg_227_reg[13] 
       (.C(ap_clk),
        .CE(ap_NS_fsm1),
        .D(pixel_count[13]),
        .Q(pixel_count_read_reg_227[13]),
        .R(1'b0));
  FDRE \pixel_count_read_reg_227_reg[14] 
       (.C(ap_clk),
        .CE(ap_NS_fsm1),
        .D(pixel_count[14]),
        .Q(pixel_count_read_reg_227[14]),
        .R(1'b0));
  FDRE \pixel_count_read_reg_227_reg[15] 
       (.C(ap_clk),
        .CE(ap_NS_fsm1),
        .D(pixel_count[15]),
        .Q(pixel_count_read_reg_227[15]),
        .R(1'b0));
  FDRE \pixel_count_read_reg_227_reg[16] 
       (.C(ap_clk),
        .CE(ap_NS_fsm1),
        .D(pixel_count[16]),
        .Q(pixel_count_read_reg_227[16]),
        .R(1'b0));
  FDRE \pixel_count_read_reg_227_reg[17] 
       (.C(ap_clk),
        .CE(ap_NS_fsm1),
        .D(pixel_count[17]),
        .Q(pixel_count_read_reg_227[17]),
        .R(1'b0));
  FDRE \pixel_count_read_reg_227_reg[18] 
       (.C(ap_clk),
        .CE(ap_NS_fsm1),
        .D(pixel_count[18]),
        .Q(pixel_count_read_reg_227[18]),
        .R(1'b0));
  FDRE \pixel_count_read_reg_227_reg[19] 
       (.C(ap_clk),
        .CE(ap_NS_fsm1),
        .D(pixel_count[19]),
        .Q(pixel_count_read_reg_227[19]),
        .R(1'b0));
  FDRE \pixel_count_read_reg_227_reg[1] 
       (.C(ap_clk),
        .CE(ap_NS_fsm1),
        .D(pixel_count[1]),
        .Q(pixel_count_read_reg_227[1]),
        .R(1'b0));
  FDRE \pixel_count_read_reg_227_reg[20] 
       (.C(ap_clk),
        .CE(ap_NS_fsm1),
        .D(pixel_count[20]),
        .Q(pixel_count_read_reg_227[20]),
        .R(1'b0));
  FDRE \pixel_count_read_reg_227_reg[21] 
       (.C(ap_clk),
        .CE(ap_NS_fsm1),
        .D(pixel_count[21]),
        .Q(pixel_count_read_reg_227[21]),
        .R(1'b0));
  FDRE \pixel_count_read_reg_227_reg[22] 
       (.C(ap_clk),
        .CE(ap_NS_fsm1),
        .D(pixel_count[22]),
        .Q(pixel_count_read_reg_227[22]),
        .R(1'b0));
  FDRE \pixel_count_read_reg_227_reg[23] 
       (.C(ap_clk),
        .CE(ap_NS_fsm1),
        .D(pixel_count[23]),
        .Q(pixel_count_read_reg_227[23]),
        .R(1'b0));
  FDRE \pixel_count_read_reg_227_reg[24] 
       (.C(ap_clk),
        .CE(ap_NS_fsm1),
        .D(pixel_count[24]),
        .Q(pixel_count_read_reg_227[24]),
        .R(1'b0));
  FDRE \pixel_count_read_reg_227_reg[25] 
       (.C(ap_clk),
        .CE(ap_NS_fsm1),
        .D(pixel_count[25]),
        .Q(pixel_count_read_reg_227[25]),
        .R(1'b0));
  FDRE \pixel_count_read_reg_227_reg[26] 
       (.C(ap_clk),
        .CE(ap_NS_fsm1),
        .D(pixel_count[26]),
        .Q(pixel_count_read_reg_227[26]),
        .R(1'b0));
  FDRE \pixel_count_read_reg_227_reg[27] 
       (.C(ap_clk),
        .CE(ap_NS_fsm1),
        .D(pixel_count[27]),
        .Q(pixel_count_read_reg_227[27]),
        .R(1'b0));
  FDRE \pixel_count_read_reg_227_reg[28] 
       (.C(ap_clk),
        .CE(ap_NS_fsm1),
        .D(pixel_count[28]),
        .Q(pixel_count_read_reg_227[28]),
        .R(1'b0));
  FDRE \pixel_count_read_reg_227_reg[29] 
       (.C(ap_clk),
        .CE(ap_NS_fsm1),
        .D(pixel_count[29]),
        .Q(pixel_count_read_reg_227[29]),
        .R(1'b0));
  FDRE \pixel_count_read_reg_227_reg[2] 
       (.C(ap_clk),
        .CE(ap_NS_fsm1),
        .D(pixel_count[2]),
        .Q(pixel_count_read_reg_227[2]),
        .R(1'b0));
  FDRE \pixel_count_read_reg_227_reg[30] 
       (.C(ap_clk),
        .CE(ap_NS_fsm1),
        .D(pixel_count[30]),
        .Q(pixel_count_read_reg_227[30]),
        .R(1'b0));
  FDRE \pixel_count_read_reg_227_reg[31] 
       (.C(ap_clk),
        .CE(ap_NS_fsm1),
        .D(pixel_count[31]),
        .Q(pixel_count_read_reg_227[31]),
        .R(1'b0));
  FDRE \pixel_count_read_reg_227_reg[3] 
       (.C(ap_clk),
        .CE(ap_NS_fsm1),
        .D(pixel_count[3]),
        .Q(pixel_count_read_reg_227[3]),
        .R(1'b0));
  FDRE \pixel_count_read_reg_227_reg[4] 
       (.C(ap_clk),
        .CE(ap_NS_fsm1),
        .D(pixel_count[4]),
        .Q(pixel_count_read_reg_227[4]),
        .R(1'b0));
  FDRE \pixel_count_read_reg_227_reg[5] 
       (.C(ap_clk),
        .CE(ap_NS_fsm1),
        .D(pixel_count[5]),
        .Q(pixel_count_read_reg_227[5]),
        .R(1'b0));
  FDRE \pixel_count_read_reg_227_reg[6] 
       (.C(ap_clk),
        .CE(ap_NS_fsm1),
        .D(pixel_count[6]),
        .Q(pixel_count_read_reg_227[6]),
        .R(1'b0));
  FDRE \pixel_count_read_reg_227_reg[7] 
       (.C(ap_clk),
        .CE(ap_NS_fsm1),
        .D(pixel_count[7]),
        .Q(pixel_count_read_reg_227[7]),
        .R(1'b0));
  FDRE \pixel_count_read_reg_227_reg[8] 
       (.C(ap_clk),
        .CE(ap_NS_fsm1),
        .D(pixel_count[8]),
        .Q(pixel_count_read_reg_227[8]),
        .R(1'b0));
  FDRE \pixel_count_read_reg_227_reg[9] 
       (.C(ap_clk),
        .CE(ap_NS_fsm1),
        .D(pixel_count[9]),
        .Q(pixel_count_read_reg_227[9]),
        .R(1'b0));
  LUT3 #(
    .INIT(8'h45)) 
    \s_axis_V_data_V_0_payload_A[7]_i_1 
       (.I0(s_axis_V_data_V_0_sel_wr),
        .I1(s_axis_V_data_V_0_ack_in),
        .I2(\s_axis_V_data_V_0_state_reg_n_1_[0] ),
        .O(s_axis_V_data_V_0_load_A));
  FDRE \s_axis_V_data_V_0_payload_A_reg[0] 
       (.C(ap_clk),
        .CE(s_axis_V_data_V_0_load_A),
        .D(s_axis_TDATA[0]),
        .Q(s_axis_V_data_V_0_payload_A[0]),
        .R(1'b0));
  FDRE \s_axis_V_data_V_0_payload_A_reg[1] 
       (.C(ap_clk),
        .CE(s_axis_V_data_V_0_load_A),
        .D(s_axis_TDATA[1]),
        .Q(s_axis_V_data_V_0_payload_A[1]),
        .R(1'b0));
  FDRE \s_axis_V_data_V_0_payload_A_reg[2] 
       (.C(ap_clk),
        .CE(s_axis_V_data_V_0_load_A),
        .D(s_axis_TDATA[2]),
        .Q(s_axis_V_data_V_0_payload_A[2]),
        .R(1'b0));
  FDRE \s_axis_V_data_V_0_payload_A_reg[3] 
       (.C(ap_clk),
        .CE(s_axis_V_data_V_0_load_A),
        .D(s_axis_TDATA[3]),
        .Q(s_axis_V_data_V_0_payload_A[3]),
        .R(1'b0));
  FDRE \s_axis_V_data_V_0_payload_A_reg[4] 
       (.C(ap_clk),
        .CE(s_axis_V_data_V_0_load_A),
        .D(s_axis_TDATA[4]),
        .Q(s_axis_V_data_V_0_payload_A[4]),
        .R(1'b0));
  FDRE \s_axis_V_data_V_0_payload_A_reg[5] 
       (.C(ap_clk),
        .CE(s_axis_V_data_V_0_load_A),
        .D(s_axis_TDATA[5]),
        .Q(s_axis_V_data_V_0_payload_A[5]),
        .R(1'b0));
  FDRE \s_axis_V_data_V_0_payload_A_reg[6] 
       (.C(ap_clk),
        .CE(s_axis_V_data_V_0_load_A),
        .D(s_axis_TDATA[6]),
        .Q(s_axis_V_data_V_0_payload_A[6]),
        .R(1'b0));
  FDRE \s_axis_V_data_V_0_payload_A_reg[7] 
       (.C(ap_clk),
        .CE(s_axis_V_data_V_0_load_A),
        .D(s_axis_TDATA[7]),
        .Q(s_axis_V_data_V_0_payload_A[7]),
        .R(1'b0));
  LUT3 #(
    .INIT(8'h8A)) 
    \s_axis_V_data_V_0_payload_B[7]_i_1 
       (.I0(s_axis_V_data_V_0_sel_wr),
        .I1(s_axis_V_data_V_0_ack_in),
        .I2(\s_axis_V_data_V_0_state_reg_n_1_[0] ),
        .O(s_axis_V_data_V_0_load_B));
  FDRE \s_axis_V_data_V_0_payload_B_reg[0] 
       (.C(ap_clk),
        .CE(s_axis_V_data_V_0_load_B),
        .D(s_axis_TDATA[0]),
        .Q(s_axis_V_data_V_0_payload_B[0]),
        .R(1'b0));
  FDRE \s_axis_V_data_V_0_payload_B_reg[1] 
       (.C(ap_clk),
        .CE(s_axis_V_data_V_0_load_B),
        .D(s_axis_TDATA[1]),
        .Q(s_axis_V_data_V_0_payload_B[1]),
        .R(1'b0));
  FDRE \s_axis_V_data_V_0_payload_B_reg[2] 
       (.C(ap_clk),
        .CE(s_axis_V_data_V_0_load_B),
        .D(s_axis_TDATA[2]),
        .Q(s_axis_V_data_V_0_payload_B[2]),
        .R(1'b0));
  FDRE \s_axis_V_data_V_0_payload_B_reg[3] 
       (.C(ap_clk),
        .CE(s_axis_V_data_V_0_load_B),
        .D(s_axis_TDATA[3]),
        .Q(s_axis_V_data_V_0_payload_B[3]),
        .R(1'b0));
  FDRE \s_axis_V_data_V_0_payload_B_reg[4] 
       (.C(ap_clk),
        .CE(s_axis_V_data_V_0_load_B),
        .D(s_axis_TDATA[4]),
        .Q(s_axis_V_data_V_0_payload_B[4]),
        .R(1'b0));
  FDRE \s_axis_V_data_V_0_payload_B_reg[5] 
       (.C(ap_clk),
        .CE(s_axis_V_data_V_0_load_B),
        .D(s_axis_TDATA[5]),
        .Q(s_axis_V_data_V_0_payload_B[5]),
        .R(1'b0));
  FDRE \s_axis_V_data_V_0_payload_B_reg[6] 
       (.C(ap_clk),
        .CE(s_axis_V_data_V_0_load_B),
        .D(s_axis_TDATA[6]),
        .Q(s_axis_V_data_V_0_payload_B[6]),
        .R(1'b0));
  FDRE \s_axis_V_data_V_0_payload_B_reg[7] 
       (.C(ap_clk),
        .CE(s_axis_V_data_V_0_load_B),
        .D(s_axis_TDATA[7]),
        .Q(s_axis_V_data_V_0_payload_B[7]),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair49" *) 
  LUT2 #(
    .INIT(4'h6)) 
    s_axis_V_data_V_0_sel_rd_i_1
       (.I0(\i_0_reg_143[0]_i_2_n_1 ),
        .I1(s_axis_V_data_V_0_sel),
        .O(s_axis_V_data_V_0_sel_rd_i_1_n_1));
  FDRE #(
    .INIT(1'b0)) 
    s_axis_V_data_V_0_sel_rd_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(s_axis_V_data_V_0_sel_rd_i_1_n_1),
        .Q(s_axis_V_data_V_0_sel),
        .R(ap_rst_n_inv));
  (* SOFT_HLUTNM = "soft_lutpair56" *) 
  LUT3 #(
    .INIT(8'h78)) 
    s_axis_V_data_V_0_sel_wr_i_1
       (.I0(s_axis_TVALID),
        .I1(s_axis_V_data_V_0_ack_in),
        .I2(s_axis_V_data_V_0_sel_wr),
        .O(s_axis_V_data_V_0_sel_wr_i_1_n_1));
  FDRE #(
    .INIT(1'b0)) 
    s_axis_V_data_V_0_sel_wr_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(s_axis_V_data_V_0_sel_wr_i_1_n_1),
        .Q(s_axis_V_data_V_0_sel_wr),
        .R(ap_rst_n_inv));
  (* SOFT_HLUTNM = "soft_lutpair33" *) 
  LUT4 #(
    .INIT(16'hF7C0)) 
    \s_axis_V_data_V_0_state[0]_i_1 
       (.I0(\i_0_reg_143[0]_i_2_n_1 ),
        .I1(s_axis_V_data_V_0_ack_in),
        .I2(s_axis_TVALID),
        .I3(\s_axis_V_data_V_0_state_reg_n_1_[0] ),
        .O(\s_axis_V_data_V_0_state[0]_i_1_n_1 ));
  (* SOFT_HLUTNM = "soft_lutpair33" *) 
  LUT4 #(
    .INIT(16'hBBFB)) 
    \s_axis_V_data_V_0_state[1]_i_1 
       (.I0(\i_0_reg_143[0]_i_2_n_1 ),
        .I1(\s_axis_V_data_V_0_state_reg_n_1_[0] ),
        .I2(s_axis_V_data_V_0_ack_in),
        .I3(s_axis_TVALID),
        .O(s_axis_V_data_V_0_state));
  FDRE #(
    .INIT(1'b0)) 
    \s_axis_V_data_V_0_state_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\s_axis_V_data_V_0_state[0]_i_1_n_1 ),
        .Q(\s_axis_V_data_V_0_state_reg_n_1_[0] ),
        .R(ap_rst_n_inv));
  FDRE #(
    .INIT(1'b0)) 
    \s_axis_V_data_V_0_state_reg[1] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(s_axis_V_data_V_0_state),
        .Q(s_axis_V_data_V_0_ack_in),
        .R(ap_rst_n_inv));
  LUT5 #(
    .INIT(32'hEFEE2022)) 
    \s_axis_V_dest_V_0_payload_A[0]_i_1 
       (.I0(s_axis_TDEST),
        .I1(s_axis_V_dest_V_0_sel_wr),
        .I2(s_axis_TREADY),
        .I3(\s_axis_V_dest_V_0_state_reg_n_1_[0] ),
        .I4(s_axis_V_dest_V_0_payload_A),
        .O(\s_axis_V_dest_V_0_payload_A[0]_i_1_n_1 ));
  FDRE \s_axis_V_dest_V_0_payload_A_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\s_axis_V_dest_V_0_payload_A[0]_i_1_n_1 ),
        .Q(s_axis_V_dest_V_0_payload_A),
        .R(1'b0));
  LUT5 #(
    .INIT(32'hBFBB8088)) 
    \s_axis_V_dest_V_0_payload_B[0]_i_1 
       (.I0(s_axis_TDEST),
        .I1(s_axis_V_dest_V_0_sel_wr),
        .I2(s_axis_TREADY),
        .I3(\s_axis_V_dest_V_0_state_reg_n_1_[0] ),
        .I4(s_axis_V_dest_V_0_payload_B),
        .O(\s_axis_V_dest_V_0_payload_B[0]_i_1_n_1 ));
  FDRE \s_axis_V_dest_V_0_payload_B_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\s_axis_V_dest_V_0_payload_B[0]_i_1_n_1 ),
        .Q(s_axis_V_dest_V_0_payload_B),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair50" *) 
  LUT3 #(
    .INIT(8'h78)) 
    s_axis_V_dest_V_0_sel_rd_i_1
       (.I0(\i_0_reg_143[0]_i_2_n_1 ),
        .I1(\s_axis_V_dest_V_0_state_reg_n_1_[0] ),
        .I2(s_axis_V_dest_V_0_sel),
        .O(s_axis_V_dest_V_0_sel_rd_i_1_n_1));
  FDRE #(
    .INIT(1'b0)) 
    s_axis_V_dest_V_0_sel_rd_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(s_axis_V_dest_V_0_sel_rd_i_1_n_1),
        .Q(s_axis_V_dest_V_0_sel),
        .R(ap_rst_n_inv));
  (* SOFT_HLUTNM = "soft_lutpair56" *) 
  LUT3 #(
    .INIT(8'h78)) 
    s_axis_V_dest_V_0_sel_wr_i_1
       (.I0(s_axis_TVALID),
        .I1(s_axis_TREADY),
        .I2(s_axis_V_dest_V_0_sel_wr),
        .O(s_axis_V_dest_V_0_sel_wr_i_1_n_1));
  FDRE #(
    .INIT(1'b0)) 
    s_axis_V_dest_V_0_sel_wr_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(s_axis_V_dest_V_0_sel_wr_i_1_n_1),
        .Q(s_axis_V_dest_V_0_sel_wr),
        .R(ap_rst_n_inv));
  (* SOFT_HLUTNM = "soft_lutpair34" *) 
  LUT4 #(
    .INIT(16'hF7C0)) 
    \s_axis_V_dest_V_0_state[0]_i_1 
       (.I0(\i_0_reg_143[0]_i_2_n_1 ),
        .I1(s_axis_TREADY),
        .I2(s_axis_TVALID),
        .I3(\s_axis_V_dest_V_0_state_reg_n_1_[0] ),
        .O(\s_axis_V_dest_V_0_state[0]_i_1_n_1 ));
  (* SOFT_HLUTNM = "soft_lutpair34" *) 
  LUT4 #(
    .INIT(16'hBBFB)) 
    \s_axis_V_dest_V_0_state[1]_i_2 
       (.I0(\i_0_reg_143[0]_i_2_n_1 ),
        .I1(\s_axis_V_dest_V_0_state_reg_n_1_[0] ),
        .I2(s_axis_TREADY),
        .I3(s_axis_TVALID),
        .O(s_axis_V_dest_V_0_state));
  FDRE #(
    .INIT(1'b0)) 
    \s_axis_V_dest_V_0_state_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\s_axis_V_dest_V_0_state[0]_i_1_n_1 ),
        .Q(\s_axis_V_dest_V_0_state_reg_n_1_[0] ),
        .R(ap_rst_n_inv));
  FDRE #(
    .INIT(1'b0)) 
    \s_axis_V_dest_V_0_state_reg[1] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(s_axis_V_dest_V_0_state),
        .Q(s_axis_TREADY),
        .R(ap_rst_n_inv));
  LUT5 #(
    .INIT(32'hEFEE2022)) 
    \s_axis_V_id_V_0_payload_A[0]_i_1 
       (.I0(s_axis_TID),
        .I1(s_axis_V_id_V_0_sel_wr),
        .I2(s_axis_V_id_V_0_ack_in),
        .I3(\s_axis_V_id_V_0_state_reg_n_1_[0] ),
        .I4(s_axis_V_id_V_0_payload_A),
        .O(\s_axis_V_id_V_0_payload_A[0]_i_1_n_1 ));
  FDRE \s_axis_V_id_V_0_payload_A_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\s_axis_V_id_V_0_payload_A[0]_i_1_n_1 ),
        .Q(s_axis_V_id_V_0_payload_A),
        .R(1'b0));
  LUT5 #(
    .INIT(32'hBFBB8088)) 
    \s_axis_V_id_V_0_payload_B[0]_i_1 
       (.I0(s_axis_TID),
        .I1(s_axis_V_id_V_0_sel_wr),
        .I2(s_axis_V_id_V_0_ack_in),
        .I3(\s_axis_V_id_V_0_state_reg_n_1_[0] ),
        .I4(s_axis_V_id_V_0_payload_B),
        .O(\s_axis_V_id_V_0_payload_B[0]_i_1_n_1 ));
  FDRE \s_axis_V_id_V_0_payload_B_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\s_axis_V_id_V_0_payload_B[0]_i_1_n_1 ),
        .Q(s_axis_V_id_V_0_payload_B),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair51" *) 
  LUT3 #(
    .INIT(8'h78)) 
    s_axis_V_id_V_0_sel_rd_i_1
       (.I0(\i_0_reg_143[0]_i_2_n_1 ),
        .I1(\s_axis_V_id_V_0_state_reg_n_1_[0] ),
        .I2(s_axis_V_id_V_0_sel),
        .O(s_axis_V_id_V_0_sel_rd_i_1_n_1));
  FDRE #(
    .INIT(1'b0)) 
    s_axis_V_id_V_0_sel_rd_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(s_axis_V_id_V_0_sel_rd_i_1_n_1),
        .Q(s_axis_V_id_V_0_sel),
        .R(ap_rst_n_inv));
  LUT3 #(
    .INIT(8'h78)) 
    s_axis_V_id_V_0_sel_wr_i_1
       (.I0(s_axis_TVALID),
        .I1(s_axis_V_id_V_0_ack_in),
        .I2(s_axis_V_id_V_0_sel_wr),
        .O(s_axis_V_id_V_0_sel_wr_i_1_n_1));
  FDRE #(
    .INIT(1'b0)) 
    s_axis_V_id_V_0_sel_wr_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(s_axis_V_id_V_0_sel_wr_i_1_n_1),
        .Q(s_axis_V_id_V_0_sel_wr),
        .R(ap_rst_n_inv));
  (* SOFT_HLUTNM = "soft_lutpair36" *) 
  LUT4 #(
    .INIT(16'hF7C0)) 
    \s_axis_V_id_V_0_state[0]_i_1 
       (.I0(\i_0_reg_143[0]_i_2_n_1 ),
        .I1(s_axis_V_id_V_0_ack_in),
        .I2(s_axis_TVALID),
        .I3(\s_axis_V_id_V_0_state_reg_n_1_[0] ),
        .O(\s_axis_V_id_V_0_state[0]_i_1_n_1 ));
  (* SOFT_HLUTNM = "soft_lutpair36" *) 
  LUT4 #(
    .INIT(16'hBBFB)) 
    \s_axis_V_id_V_0_state[1]_i_1 
       (.I0(\i_0_reg_143[0]_i_2_n_1 ),
        .I1(\s_axis_V_id_V_0_state_reg_n_1_[0] ),
        .I2(s_axis_V_id_V_0_ack_in),
        .I3(s_axis_TVALID),
        .O(s_axis_V_id_V_0_state));
  FDRE #(
    .INIT(1'b0)) 
    \s_axis_V_id_V_0_state_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\s_axis_V_id_V_0_state[0]_i_1_n_1 ),
        .Q(\s_axis_V_id_V_0_state_reg_n_1_[0] ),
        .R(ap_rst_n_inv));
  FDRE #(
    .INIT(1'b0)) 
    \s_axis_V_id_V_0_state_reg[1] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(s_axis_V_id_V_0_state),
        .Q(s_axis_V_id_V_0_ack_in),
        .R(ap_rst_n_inv));
  LUT5 #(
    .INIT(32'hEFEE2022)) 
    \s_axis_V_keep_V_0_payload_A[0]_i_1 
       (.I0(s_axis_TKEEP),
        .I1(s_axis_V_keep_V_0_sel_wr),
        .I2(s_axis_V_keep_V_0_ack_in),
        .I3(\s_axis_V_keep_V_0_state_reg_n_1_[0] ),
        .I4(s_axis_V_keep_V_0_payload_A),
        .O(\s_axis_V_keep_V_0_payload_A[0]_i_1_n_1 ));
  FDRE \s_axis_V_keep_V_0_payload_A_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\s_axis_V_keep_V_0_payload_A[0]_i_1_n_1 ),
        .Q(s_axis_V_keep_V_0_payload_A),
        .R(1'b0));
  LUT5 #(
    .INIT(32'hBFBB8088)) 
    \s_axis_V_keep_V_0_payload_B[0]_i_1 
       (.I0(s_axis_TKEEP),
        .I1(s_axis_V_keep_V_0_sel_wr),
        .I2(s_axis_V_keep_V_0_ack_in),
        .I3(\s_axis_V_keep_V_0_state_reg_n_1_[0] ),
        .I4(s_axis_V_keep_V_0_payload_B),
        .O(\s_axis_V_keep_V_0_payload_B[0]_i_1_n_1 ));
  FDRE \s_axis_V_keep_V_0_payload_B_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\s_axis_V_keep_V_0_payload_B[0]_i_1_n_1 ),
        .Q(s_axis_V_keep_V_0_payload_B),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair49" *) 
  LUT3 #(
    .INIT(8'h78)) 
    s_axis_V_keep_V_0_sel_rd_i_1
       (.I0(\i_0_reg_143[0]_i_2_n_1 ),
        .I1(\s_axis_V_keep_V_0_state_reg_n_1_[0] ),
        .I2(s_axis_V_keep_V_0_sel),
        .O(s_axis_V_keep_V_0_sel_rd_i_1_n_1));
  FDRE #(
    .INIT(1'b0)) 
    s_axis_V_keep_V_0_sel_rd_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(s_axis_V_keep_V_0_sel_rd_i_1_n_1),
        .Q(s_axis_V_keep_V_0_sel),
        .R(ap_rst_n_inv));
  (* SOFT_HLUTNM = "soft_lutpair57" *) 
  LUT3 #(
    .INIT(8'h78)) 
    s_axis_V_keep_V_0_sel_wr_i_1
       (.I0(s_axis_TVALID),
        .I1(s_axis_V_keep_V_0_ack_in),
        .I2(s_axis_V_keep_V_0_sel_wr),
        .O(s_axis_V_keep_V_0_sel_wr_i_1_n_1));
  FDRE #(
    .INIT(1'b0)) 
    s_axis_V_keep_V_0_sel_wr_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(s_axis_V_keep_V_0_sel_wr_i_1_n_1),
        .Q(s_axis_V_keep_V_0_sel_wr),
        .R(ap_rst_n_inv));
  (* SOFT_HLUTNM = "soft_lutpair35" *) 
  LUT4 #(
    .INIT(16'hF7C0)) 
    \s_axis_V_keep_V_0_state[0]_i_1 
       (.I0(\i_0_reg_143[0]_i_2_n_1 ),
        .I1(s_axis_V_keep_V_0_ack_in),
        .I2(s_axis_TVALID),
        .I3(\s_axis_V_keep_V_0_state_reg_n_1_[0] ),
        .O(\s_axis_V_keep_V_0_state[0]_i_1_n_1 ));
  (* SOFT_HLUTNM = "soft_lutpair35" *) 
  LUT4 #(
    .INIT(16'hBBFB)) 
    \s_axis_V_keep_V_0_state[1]_i_1 
       (.I0(\i_0_reg_143[0]_i_2_n_1 ),
        .I1(\s_axis_V_keep_V_0_state_reg_n_1_[0] ),
        .I2(s_axis_V_keep_V_0_ack_in),
        .I3(s_axis_TVALID),
        .O(s_axis_V_keep_V_0_state));
  FDRE #(
    .INIT(1'b0)) 
    \s_axis_V_keep_V_0_state_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\s_axis_V_keep_V_0_state[0]_i_1_n_1 ),
        .Q(\s_axis_V_keep_V_0_state_reg_n_1_[0] ),
        .R(ap_rst_n_inv));
  FDRE #(
    .INIT(1'b0)) 
    \s_axis_V_keep_V_0_state_reg[1] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(s_axis_V_keep_V_0_state),
        .Q(s_axis_V_keep_V_0_ack_in),
        .R(ap_rst_n_inv));
  LUT5 #(
    .INIT(32'hEFEE2022)) 
    \s_axis_V_last_V_0_payload_A[0]_i_1 
       (.I0(s_axis_TLAST),
        .I1(s_axis_V_last_V_0_sel_wr),
        .I2(s_axis_V_last_V_0_ack_in),
        .I3(\s_axis_V_last_V_0_state_reg_n_1_[0] ),
        .I4(s_axis_V_last_V_0_payload_A),
        .O(\s_axis_V_last_V_0_payload_A[0]_i_1_n_1 ));
  FDRE \s_axis_V_last_V_0_payload_A_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\s_axis_V_last_V_0_payload_A[0]_i_1_n_1 ),
        .Q(s_axis_V_last_V_0_payload_A),
        .R(1'b0));
  LUT5 #(
    .INIT(32'hBFBB8088)) 
    \s_axis_V_last_V_0_payload_B[0]_i_1 
       (.I0(s_axis_TLAST),
        .I1(s_axis_V_last_V_0_sel_wr),
        .I2(s_axis_V_last_V_0_ack_in),
        .I3(\s_axis_V_last_V_0_state_reg_n_1_[0] ),
        .I4(s_axis_V_last_V_0_payload_B),
        .O(\s_axis_V_last_V_0_payload_B[0]_i_1_n_1 ));
  FDRE \s_axis_V_last_V_0_payload_B_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\s_axis_V_last_V_0_payload_B[0]_i_1_n_1 ),
        .Q(s_axis_V_last_V_0_payload_B),
        .R(1'b0));
  LUT3 #(
    .INIT(8'h78)) 
    s_axis_V_last_V_0_sel_rd_i_1
       (.I0(\i_0_reg_143[0]_i_2_n_1 ),
        .I1(\s_axis_V_last_V_0_state_reg_n_1_[0] ),
        .I2(s_axis_V_last_V_0_sel),
        .O(s_axis_V_last_V_0_sel_rd_i_1_n_1));
  FDRE #(
    .INIT(1'b0)) 
    s_axis_V_last_V_0_sel_rd_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(s_axis_V_last_V_0_sel_rd_i_1_n_1),
        .Q(s_axis_V_last_V_0_sel),
        .R(ap_rst_n_inv));
  (* SOFT_HLUTNM = "soft_lutpair58" *) 
  LUT3 #(
    .INIT(8'h78)) 
    s_axis_V_last_V_0_sel_wr_i_1
       (.I0(s_axis_TVALID),
        .I1(s_axis_V_last_V_0_ack_in),
        .I2(s_axis_V_last_V_0_sel_wr),
        .O(s_axis_V_last_V_0_sel_wr_i_1_n_1));
  FDRE #(
    .INIT(1'b0)) 
    s_axis_V_last_V_0_sel_wr_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(s_axis_V_last_V_0_sel_wr_i_1_n_1),
        .Q(s_axis_V_last_V_0_sel_wr),
        .R(ap_rst_n_inv));
  (* SOFT_HLUTNM = "soft_lutpair31" *) 
  LUT4 #(
    .INIT(16'hF7C0)) 
    \s_axis_V_last_V_0_state[0]_i_1 
       (.I0(\i_0_reg_143[0]_i_2_n_1 ),
        .I1(s_axis_V_last_V_0_ack_in),
        .I2(s_axis_TVALID),
        .I3(\s_axis_V_last_V_0_state_reg_n_1_[0] ),
        .O(\s_axis_V_last_V_0_state[0]_i_1_n_1 ));
  (* SOFT_HLUTNM = "soft_lutpair31" *) 
  LUT4 #(
    .INIT(16'hBBFB)) 
    \s_axis_V_last_V_0_state[1]_i_1 
       (.I0(\i_0_reg_143[0]_i_2_n_1 ),
        .I1(\s_axis_V_last_V_0_state_reg_n_1_[0] ),
        .I2(s_axis_V_last_V_0_ack_in),
        .I3(s_axis_TVALID),
        .O(s_axis_V_last_V_0_state));
  FDRE #(
    .INIT(1'b0)) 
    \s_axis_V_last_V_0_state_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\s_axis_V_last_V_0_state[0]_i_1_n_1 ),
        .Q(\s_axis_V_last_V_0_state_reg_n_1_[0] ),
        .R(ap_rst_n_inv));
  FDRE #(
    .INIT(1'b0)) 
    \s_axis_V_last_V_0_state_reg[1] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(s_axis_V_last_V_0_state),
        .Q(s_axis_V_last_V_0_ack_in),
        .R(ap_rst_n_inv));
  LUT5 #(
    .INIT(32'hEFEE2022)) 
    \s_axis_V_strb_V_0_payload_A[0]_i_1 
       (.I0(s_axis_TSTRB),
        .I1(s_axis_V_strb_V_0_sel_wr),
        .I2(s_axis_V_strb_V_0_ack_in),
        .I3(\s_axis_V_strb_V_0_state_reg_n_1_[0] ),
        .I4(s_axis_V_strb_V_0_payload_A),
        .O(\s_axis_V_strb_V_0_payload_A[0]_i_1_n_1 ));
  FDRE \s_axis_V_strb_V_0_payload_A_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\s_axis_V_strb_V_0_payload_A[0]_i_1_n_1 ),
        .Q(s_axis_V_strb_V_0_payload_A),
        .R(1'b0));
  LUT5 #(
    .INIT(32'hBFBB8088)) 
    \s_axis_V_strb_V_0_payload_B[0]_i_1 
       (.I0(s_axis_TSTRB),
        .I1(s_axis_V_strb_V_0_sel_wr),
        .I2(s_axis_V_strb_V_0_ack_in),
        .I3(\s_axis_V_strb_V_0_state_reg_n_1_[0] ),
        .I4(s_axis_V_strb_V_0_payload_B),
        .O(\s_axis_V_strb_V_0_payload_B[0]_i_1_n_1 ));
  FDRE \s_axis_V_strb_V_0_payload_B_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\s_axis_V_strb_V_0_payload_B[0]_i_1_n_1 ),
        .Q(s_axis_V_strb_V_0_payload_B),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair50" *) 
  LUT3 #(
    .INIT(8'h78)) 
    s_axis_V_strb_V_0_sel_rd_i_1
       (.I0(\i_0_reg_143[0]_i_2_n_1 ),
        .I1(\s_axis_V_strb_V_0_state_reg_n_1_[0] ),
        .I2(s_axis_V_strb_V_0_sel),
        .O(s_axis_V_strb_V_0_sel_rd_i_1_n_1));
  FDRE #(
    .INIT(1'b0)) 
    s_axis_V_strb_V_0_sel_rd_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(s_axis_V_strb_V_0_sel_rd_i_1_n_1),
        .Q(s_axis_V_strb_V_0_sel),
        .R(ap_rst_n_inv));
  (* SOFT_HLUTNM = "soft_lutpair57" *) 
  LUT3 #(
    .INIT(8'h78)) 
    s_axis_V_strb_V_0_sel_wr_i_1
       (.I0(s_axis_TVALID),
        .I1(s_axis_V_strb_V_0_ack_in),
        .I2(s_axis_V_strb_V_0_sel_wr),
        .O(s_axis_V_strb_V_0_sel_wr_i_1_n_1));
  FDRE #(
    .INIT(1'b0)) 
    s_axis_V_strb_V_0_sel_wr_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(s_axis_V_strb_V_0_sel_wr_i_1_n_1),
        .Q(s_axis_V_strb_V_0_sel_wr),
        .R(ap_rst_n_inv));
  (* SOFT_HLUTNM = "soft_lutpair32" *) 
  LUT4 #(
    .INIT(16'hF7C0)) 
    \s_axis_V_strb_V_0_state[0]_i_1 
       (.I0(\i_0_reg_143[0]_i_2_n_1 ),
        .I1(s_axis_V_strb_V_0_ack_in),
        .I2(s_axis_TVALID),
        .I3(\s_axis_V_strb_V_0_state_reg_n_1_[0] ),
        .O(\s_axis_V_strb_V_0_state[0]_i_1_n_1 ));
  (* SOFT_HLUTNM = "soft_lutpair32" *) 
  LUT4 #(
    .INIT(16'hBBFB)) 
    \s_axis_V_strb_V_0_state[1]_i_1 
       (.I0(\i_0_reg_143[0]_i_2_n_1 ),
        .I1(\s_axis_V_strb_V_0_state_reg_n_1_[0] ),
        .I2(s_axis_V_strb_V_0_ack_in),
        .I3(s_axis_TVALID),
        .O(s_axis_V_strb_V_0_state));
  FDRE #(
    .INIT(1'b0)) 
    \s_axis_V_strb_V_0_state_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\s_axis_V_strb_V_0_state[0]_i_1_n_1 ),
        .Q(\s_axis_V_strb_V_0_state_reg_n_1_[0] ),
        .R(ap_rst_n_inv));
  FDRE #(
    .INIT(1'b0)) 
    \s_axis_V_strb_V_0_state_reg[1] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(s_axis_V_strb_V_0_state),
        .Q(s_axis_V_strb_V_0_ack_in),
        .R(ap_rst_n_inv));
  LUT5 #(
    .INIT(32'hEFEE2022)) 
    \s_axis_V_user_V_0_payload_A[0]_i_1 
       (.I0(s_axis_TUSER),
        .I1(s_axis_V_user_V_0_sel_wr),
        .I2(s_axis_V_user_V_0_ack_in),
        .I3(\s_axis_V_user_V_0_state_reg_n_1_[0] ),
        .I4(s_axis_V_user_V_0_payload_A),
        .O(\s_axis_V_user_V_0_payload_A[0]_i_1_n_1 ));
  FDRE \s_axis_V_user_V_0_payload_A_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\s_axis_V_user_V_0_payload_A[0]_i_1_n_1 ),
        .Q(s_axis_V_user_V_0_payload_A),
        .R(1'b0));
  LUT5 #(
    .INIT(32'hBFBB8088)) 
    \s_axis_V_user_V_0_payload_B[0]_i_1 
       (.I0(s_axis_TUSER),
        .I1(s_axis_V_user_V_0_sel_wr),
        .I2(s_axis_V_user_V_0_ack_in),
        .I3(\s_axis_V_user_V_0_state_reg_n_1_[0] ),
        .I4(s_axis_V_user_V_0_payload_B),
        .O(\s_axis_V_user_V_0_payload_B[0]_i_1_n_1 ));
  FDRE \s_axis_V_user_V_0_payload_B_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\s_axis_V_user_V_0_payload_B[0]_i_1_n_1 ),
        .Q(s_axis_V_user_V_0_payload_B),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair51" *) 
  LUT3 #(
    .INIT(8'h78)) 
    s_axis_V_user_V_0_sel_rd_i_1
       (.I0(\i_0_reg_143[0]_i_2_n_1 ),
        .I1(\s_axis_V_user_V_0_state_reg_n_1_[0] ),
        .I2(s_axis_V_user_V_0_sel),
        .O(s_axis_V_user_V_0_sel_rd_i_1_n_1));
  FDRE #(
    .INIT(1'b0)) 
    s_axis_V_user_V_0_sel_rd_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(s_axis_V_user_V_0_sel_rd_i_1_n_1),
        .Q(s_axis_V_user_V_0_sel),
        .R(ap_rst_n_inv));
  (* SOFT_HLUTNM = "soft_lutpair58" *) 
  LUT3 #(
    .INIT(8'h78)) 
    s_axis_V_user_V_0_sel_wr_i_1
       (.I0(s_axis_TVALID),
        .I1(s_axis_V_user_V_0_ack_in),
        .I2(s_axis_V_user_V_0_sel_wr),
        .O(s_axis_V_user_V_0_sel_wr_i_1_n_1));
  FDRE #(
    .INIT(1'b0)) 
    s_axis_V_user_V_0_sel_wr_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(s_axis_V_user_V_0_sel_wr_i_1_n_1),
        .Q(s_axis_V_user_V_0_sel_wr),
        .R(ap_rst_n_inv));
  (* SOFT_HLUTNM = "soft_lutpair39" *) 
  LUT4 #(
    .INIT(16'hF7C0)) 
    \s_axis_V_user_V_0_state[0]_i_1 
       (.I0(\i_0_reg_143[0]_i_2_n_1 ),
        .I1(s_axis_V_user_V_0_ack_in),
        .I2(s_axis_TVALID),
        .I3(\s_axis_V_user_V_0_state_reg_n_1_[0] ),
        .O(\s_axis_V_user_V_0_state[0]_i_1_n_1 ));
  (* SOFT_HLUTNM = "soft_lutpair39" *) 
  LUT4 #(
    .INIT(16'hBBFB)) 
    \s_axis_V_user_V_0_state[1]_i_1 
       (.I0(\i_0_reg_143[0]_i_2_n_1 ),
        .I1(\s_axis_V_user_V_0_state_reg_n_1_[0] ),
        .I2(s_axis_V_user_V_0_ack_in),
        .I3(s_axis_TVALID),
        .O(s_axis_V_user_V_0_state));
  FDRE #(
    .INIT(1'b0)) 
    \s_axis_V_user_V_0_state_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\s_axis_V_user_V_0_state[0]_i_1_n_1 ),
        .Q(\s_axis_V_user_V_0_state_reg_n_1_[0] ),
        .R(ap_rst_n_inv));
  FDRE #(
    .INIT(1'b0)) 
    \s_axis_V_user_V_0_state_reg[1] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(s_axis_V_user_V_0_state),
        .Q(s_axis_V_user_V_0_ack_in),
        .R(ap_rst_n_inv));
  FDRE \threshold_V_read_reg_222_reg[0] 
       (.C(ap_clk),
        .CE(ap_NS_fsm1),
        .D(threshold_V[0]),
        .Q(threshold_V_read_reg_222[0]),
        .R(1'b0));
  FDRE \threshold_V_read_reg_222_reg[1] 
       (.C(ap_clk),
        .CE(ap_NS_fsm1),
        .D(threshold_V[1]),
        .Q(threshold_V_read_reg_222[1]),
        .R(1'b0));
  FDRE \threshold_V_read_reg_222_reg[2] 
       (.C(ap_clk),
        .CE(ap_NS_fsm1),
        .D(threshold_V[2]),
        .Q(threshold_V_read_reg_222[2]),
        .R(1'b0));
  FDRE \threshold_V_read_reg_222_reg[3] 
       (.C(ap_clk),
        .CE(ap_NS_fsm1),
        .D(threshold_V[3]),
        .Q(threshold_V_read_reg_222[3]),
        .R(1'b0));
  FDRE \threshold_V_read_reg_222_reg[4] 
       (.C(ap_clk),
        .CE(ap_NS_fsm1),
        .D(threshold_V[4]),
        .Q(threshold_V_read_reg_222[4]),
        .R(1'b0));
  FDRE \threshold_V_read_reg_222_reg[5] 
       (.C(ap_clk),
        .CE(ap_NS_fsm1),
        .D(threshold_V[5]),
        .Q(threshold_V_read_reg_222[5]),
        .R(1'b0));
  FDRE \threshold_V_read_reg_222_reg[6] 
       (.C(ap_clk),
        .CE(ap_NS_fsm1),
        .D(threshold_V[6]),
        .Q(threshold_V_read_reg_222[6]),
        .R(1'b0));
  FDRE \threshold_V_read_reg_222_reg[7] 
       (.C(ap_clk),
        .CE(ap_NS_fsm1),
        .D(threshold_V[7]),
        .Q(threshold_V_read_reg_222[7]),
        .R(1'b0));
  FDRE \threshold_enable_rea_reg_217_reg[0] 
       (.C(ap_clk),
        .CE(ap_NS_fsm1),
        .D(threshold_enable),
        .Q(threshold_enable_rea_reg_217),
        .R(1'b0));
  LUT5 #(
    .INIT(32'hDDD88D88)) 
    \tmp_data_V_2_reg_271[0]_i_1 
       (.I0(threshold_enable_rea_reg_217),
        .I1(tmp_data_V_1_fu_202_p3),
        .I2(s_axis_V_data_V_0_sel),
        .I3(s_axis_V_data_V_0_payload_A[0]),
        .I4(s_axis_V_data_V_0_payload_B[0]),
        .O(\tmp_data_V_2_reg_271[0]_i_1_n_1 ));
  (* SOFT_HLUTNM = "soft_lutpair27" *) 
  LUT5 #(
    .INIT(32'hDDD88D88)) 
    \tmp_data_V_2_reg_271[1]_i_1 
       (.I0(threshold_enable_rea_reg_217),
        .I1(tmp_data_V_1_fu_202_p3),
        .I2(s_axis_V_data_V_0_sel),
        .I3(s_axis_V_data_V_0_payload_A[1]),
        .I4(s_axis_V_data_V_0_payload_B[1]),
        .O(\tmp_data_V_2_reg_271[1]_i_1_n_1 ));
  LUT5 #(
    .INIT(32'hDDD88D88)) 
    \tmp_data_V_2_reg_271[2]_i_1 
       (.I0(threshold_enable_rea_reg_217),
        .I1(tmp_data_V_1_fu_202_p3),
        .I2(s_axis_V_data_V_0_sel),
        .I3(s_axis_V_data_V_0_payload_A[2]),
        .I4(s_axis_V_data_V_0_payload_B[2]),
        .O(\tmp_data_V_2_reg_271[2]_i_1_n_1 ));
  (* SOFT_HLUTNM = "soft_lutpair28" *) 
  LUT5 #(
    .INIT(32'hDDD88D88)) 
    \tmp_data_V_2_reg_271[3]_i_1 
       (.I0(threshold_enable_rea_reg_217),
        .I1(tmp_data_V_1_fu_202_p3),
        .I2(s_axis_V_data_V_0_sel),
        .I3(s_axis_V_data_V_0_payload_A[3]),
        .I4(s_axis_V_data_V_0_payload_B[3]),
        .O(\tmp_data_V_2_reg_271[3]_i_1_n_1 ));
  LUT5 #(
    .INIT(32'hDDD88D88)) 
    \tmp_data_V_2_reg_271[4]_i_1 
       (.I0(threshold_enable_rea_reg_217),
        .I1(tmp_data_V_1_fu_202_p3),
        .I2(s_axis_V_data_V_0_sel),
        .I3(s_axis_V_data_V_0_payload_A[4]),
        .I4(s_axis_V_data_V_0_payload_B[4]),
        .O(\tmp_data_V_2_reg_271[4]_i_1_n_1 ));
  (* SOFT_HLUTNM = "soft_lutpair29" *) 
  LUT5 #(
    .INIT(32'hDDD88D88)) 
    \tmp_data_V_2_reg_271[5]_i_1 
       (.I0(threshold_enable_rea_reg_217),
        .I1(tmp_data_V_1_fu_202_p3),
        .I2(s_axis_V_data_V_0_sel),
        .I3(s_axis_V_data_V_0_payload_A[5]),
        .I4(s_axis_V_data_V_0_payload_B[5]),
        .O(\tmp_data_V_2_reg_271[5]_i_1_n_1 ));
  LUT5 #(
    .INIT(32'hDDD88D88)) 
    \tmp_data_V_2_reg_271[6]_i_1 
       (.I0(threshold_enable_rea_reg_217),
        .I1(tmp_data_V_1_fu_202_p3),
        .I2(s_axis_V_data_V_0_sel),
        .I3(s_axis_V_data_V_0_payload_A[6]),
        .I4(s_axis_V_data_V_0_payload_B[6]),
        .O(\tmp_data_V_2_reg_271[6]_i_1_n_1 ));
  LUT5 #(
    .INIT(32'h45000000)) 
    \tmp_data_V_2_reg_271[7]_i_1 
       (.I0(\tmp_data_V_2_reg_271[7]_i_3_n_1 ),
        .I1(\s_axis_V_data_V_0_state_reg_n_1_[0] ),
        .I2(ap_enable_reg_pp0_iter0),
        .I3(ap_CS_fsm_pp0_stage0),
        .I4(icmp_ln17_fu_158_p2),
        .O(tmp_data_V_2_reg_2710));
  LUT4 #(
    .INIT(16'h2F02)) 
    \tmp_data_V_2_reg_271[7]_i_10 
       (.I0(pixel_count_read_reg_227[24]),
        .I1(i_0_reg_143_reg[24]),
        .I2(i_0_reg_143_reg[25]),
        .I3(pixel_count_read_reg_227[25]),
        .O(\tmp_data_V_2_reg_271[7]_i_10_n_1 ));
  LUT3 #(
    .INIT(8'h21)) 
    \tmp_data_V_2_reg_271[7]_i_11 
       (.I0(i_0_reg_143_reg[30]),
        .I1(pixel_count_read_reg_227[31]),
        .I2(pixel_count_read_reg_227[30]),
        .O(\tmp_data_V_2_reg_271[7]_i_11_n_1 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \tmp_data_V_2_reg_271[7]_i_12 
       (.I0(i_0_reg_143_reg[28]),
        .I1(pixel_count_read_reg_227[28]),
        .I2(i_0_reg_143_reg[29]),
        .I3(pixel_count_read_reg_227[29]),
        .O(\tmp_data_V_2_reg_271[7]_i_12_n_1 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \tmp_data_V_2_reg_271[7]_i_13 
       (.I0(i_0_reg_143_reg[26]),
        .I1(pixel_count_read_reg_227[26]),
        .I2(i_0_reg_143_reg[27]),
        .I3(pixel_count_read_reg_227[27]),
        .O(\tmp_data_V_2_reg_271[7]_i_13_n_1 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \tmp_data_V_2_reg_271[7]_i_14 
       (.I0(i_0_reg_143_reg[24]),
        .I1(pixel_count_read_reg_227[24]),
        .I2(i_0_reg_143_reg[25]),
        .I3(pixel_count_read_reg_227[25]),
        .O(\tmp_data_V_2_reg_271[7]_i_14_n_1 ));
  LUT6 #(
    .INIT(64'h00E4FFFF000000E4)) 
    \tmp_data_V_2_reg_271[7]_i_15 
       (.I0(s_axis_V_data_V_0_sel),
        .I1(s_axis_V_data_V_0_payload_A[6]),
        .I2(s_axis_V_data_V_0_payload_B[6]),
        .I3(threshold_V_read_reg_222[6]),
        .I4(threshold_V_read_reg_222[7]),
        .I5(s_axis_V_data_V_0_data_out[7]),
        .O(\tmp_data_V_2_reg_271[7]_i_15_n_1 ));
  LUT6 #(
    .INIT(64'h00E4FFFF000000E4)) 
    \tmp_data_V_2_reg_271[7]_i_16 
       (.I0(s_axis_V_data_V_0_sel),
        .I1(s_axis_V_data_V_0_payload_A[4]),
        .I2(s_axis_V_data_V_0_payload_B[4]),
        .I3(threshold_V_read_reg_222[4]),
        .I4(threshold_V_read_reg_222[5]),
        .I5(s_axis_V_data_V_0_data_out[5]),
        .O(\tmp_data_V_2_reg_271[7]_i_16_n_1 ));
  LUT6 #(
    .INIT(64'h00E4FFFF000000E4)) 
    \tmp_data_V_2_reg_271[7]_i_17 
       (.I0(s_axis_V_data_V_0_sel),
        .I1(s_axis_V_data_V_0_payload_A[2]),
        .I2(s_axis_V_data_V_0_payload_B[2]),
        .I3(threshold_V_read_reg_222[2]),
        .I4(threshold_V_read_reg_222[3]),
        .I5(s_axis_V_data_V_0_data_out[3]),
        .O(\tmp_data_V_2_reg_271[7]_i_17_n_1 ));
  LUT6 #(
    .INIT(64'h00E4FFFF000000E4)) 
    \tmp_data_V_2_reg_271[7]_i_18 
       (.I0(s_axis_V_data_V_0_sel),
        .I1(s_axis_V_data_V_0_payload_A[0]),
        .I2(s_axis_V_data_V_0_payload_B[0]),
        .I3(threshold_V_read_reg_222[0]),
        .I4(threshold_V_read_reg_222[1]),
        .I5(s_axis_V_data_V_0_data_out[1]),
        .O(\tmp_data_V_2_reg_271[7]_i_18_n_1 ));
  LUT6 #(
    .INIT(64'hAC5300000000AC53)) 
    \tmp_data_V_2_reg_271[7]_i_19 
       (.I0(s_axis_V_data_V_0_payload_B[6]),
        .I1(s_axis_V_data_V_0_payload_A[6]),
        .I2(s_axis_V_data_V_0_sel),
        .I3(threshold_V_read_reg_222[6]),
        .I4(s_axis_V_data_V_0_data_out[7]),
        .I5(threshold_V_read_reg_222[7]),
        .O(\tmp_data_V_2_reg_271[7]_i_19_n_1 ));
  (* SOFT_HLUTNM = "soft_lutpair30" *) 
  LUT5 #(
    .INIT(32'hDDD88D88)) 
    \tmp_data_V_2_reg_271[7]_i_2 
       (.I0(threshold_enable_rea_reg_217),
        .I1(tmp_data_V_1_fu_202_p3),
        .I2(s_axis_V_data_V_0_sel),
        .I3(s_axis_V_data_V_0_payload_A[7]),
        .I4(s_axis_V_data_V_0_payload_B[7]),
        .O(\tmp_data_V_2_reg_271[7]_i_2_n_1 ));
  LUT6 #(
    .INIT(64'hAC5300000000AC53)) 
    \tmp_data_V_2_reg_271[7]_i_20 
       (.I0(s_axis_V_data_V_0_payload_B[4]),
        .I1(s_axis_V_data_V_0_payload_A[4]),
        .I2(s_axis_V_data_V_0_sel),
        .I3(threshold_V_read_reg_222[4]),
        .I4(s_axis_V_data_V_0_data_out[5]),
        .I5(threshold_V_read_reg_222[5]),
        .O(\tmp_data_V_2_reg_271[7]_i_20_n_1 ));
  LUT6 #(
    .INIT(64'hAC5300000000AC53)) 
    \tmp_data_V_2_reg_271[7]_i_21 
       (.I0(s_axis_V_data_V_0_payload_B[2]),
        .I1(s_axis_V_data_V_0_payload_A[2]),
        .I2(s_axis_V_data_V_0_sel),
        .I3(threshold_V_read_reg_222[2]),
        .I4(s_axis_V_data_V_0_data_out[3]),
        .I5(threshold_V_read_reg_222[3]),
        .O(\tmp_data_V_2_reg_271[7]_i_21_n_1 ));
  LUT6 #(
    .INIT(64'hAC5300000000AC53)) 
    \tmp_data_V_2_reg_271[7]_i_22 
       (.I0(s_axis_V_data_V_0_payload_B[0]),
        .I1(s_axis_V_data_V_0_payload_A[0]),
        .I2(s_axis_V_data_V_0_sel),
        .I3(threshold_V_read_reg_222[0]),
        .I4(s_axis_V_data_V_0_data_out[1]),
        .I5(threshold_V_read_reg_222[1]),
        .O(\tmp_data_V_2_reg_271[7]_i_22_n_1 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \tmp_data_V_2_reg_271[7]_i_24 
       (.I0(pixel_count_read_reg_227[22]),
        .I1(i_0_reg_143_reg[22]),
        .I2(i_0_reg_143_reg[23]),
        .I3(pixel_count_read_reg_227[23]),
        .O(\tmp_data_V_2_reg_271[7]_i_24_n_1 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \tmp_data_V_2_reg_271[7]_i_25 
       (.I0(pixel_count_read_reg_227[20]),
        .I1(i_0_reg_143_reg[20]),
        .I2(i_0_reg_143_reg[21]),
        .I3(pixel_count_read_reg_227[21]),
        .O(\tmp_data_V_2_reg_271[7]_i_25_n_1 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \tmp_data_V_2_reg_271[7]_i_26 
       (.I0(pixel_count_read_reg_227[18]),
        .I1(i_0_reg_143_reg[18]),
        .I2(i_0_reg_143_reg[19]),
        .I3(pixel_count_read_reg_227[19]),
        .O(\tmp_data_V_2_reg_271[7]_i_26_n_1 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \tmp_data_V_2_reg_271[7]_i_27 
       (.I0(pixel_count_read_reg_227[16]),
        .I1(i_0_reg_143_reg[16]),
        .I2(i_0_reg_143_reg[17]),
        .I3(pixel_count_read_reg_227[17]),
        .O(\tmp_data_V_2_reg_271[7]_i_27_n_1 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \tmp_data_V_2_reg_271[7]_i_28 
       (.I0(i_0_reg_143_reg[22]),
        .I1(pixel_count_read_reg_227[22]),
        .I2(i_0_reg_143_reg[23]),
        .I3(pixel_count_read_reg_227[23]),
        .O(\tmp_data_V_2_reg_271[7]_i_28_n_1 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \tmp_data_V_2_reg_271[7]_i_29 
       (.I0(i_0_reg_143_reg[20]),
        .I1(pixel_count_read_reg_227[20]),
        .I2(i_0_reg_143_reg[21]),
        .I3(pixel_count_read_reg_227[21]),
        .O(\tmp_data_V_2_reg_271[7]_i_29_n_1 ));
  (* SOFT_HLUTNM = "soft_lutpair26" *) 
  LUT5 #(
    .INIT(32'h0000F888)) 
    \tmp_data_V_2_reg_271[7]_i_3 
       (.I0(icmp_ln17_reg_232),
        .I1(ap_enable_reg_pp0_iter1_reg_n_1),
        .I2(ap_enable_reg_pp0_iter2_reg_n_1),
        .I3(icmp_ln17_reg_232_pp0_iter1_reg),
        .I4(m_axis_V_data_V_1_ack_in),
        .O(\tmp_data_V_2_reg_271[7]_i_3_n_1 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \tmp_data_V_2_reg_271[7]_i_30 
       (.I0(i_0_reg_143_reg[18]),
        .I1(pixel_count_read_reg_227[18]),
        .I2(i_0_reg_143_reg[19]),
        .I3(pixel_count_read_reg_227[19]),
        .O(\tmp_data_V_2_reg_271[7]_i_30_n_1 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \tmp_data_V_2_reg_271[7]_i_31 
       (.I0(i_0_reg_143_reg[16]),
        .I1(pixel_count_read_reg_227[16]),
        .I2(i_0_reg_143_reg[17]),
        .I3(pixel_count_read_reg_227[17]),
        .O(\tmp_data_V_2_reg_271[7]_i_31_n_1 ));
  (* SOFT_HLUTNM = "soft_lutpair30" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \tmp_data_V_2_reg_271[7]_i_32 
       (.I0(s_axis_V_data_V_0_payload_B[7]),
        .I1(s_axis_V_data_V_0_payload_A[7]),
        .I2(s_axis_V_data_V_0_sel),
        .O(s_axis_V_data_V_0_data_out[7]));
  (* SOFT_HLUTNM = "soft_lutpair29" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \tmp_data_V_2_reg_271[7]_i_33 
       (.I0(s_axis_V_data_V_0_payload_B[5]),
        .I1(s_axis_V_data_V_0_payload_A[5]),
        .I2(s_axis_V_data_V_0_sel),
        .O(s_axis_V_data_V_0_data_out[5]));
  (* SOFT_HLUTNM = "soft_lutpair28" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \tmp_data_V_2_reg_271[7]_i_34 
       (.I0(s_axis_V_data_V_0_payload_B[3]),
        .I1(s_axis_V_data_V_0_payload_A[3]),
        .I2(s_axis_V_data_V_0_sel),
        .O(s_axis_V_data_V_0_data_out[3]));
  (* SOFT_HLUTNM = "soft_lutpair27" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \tmp_data_V_2_reg_271[7]_i_35 
       (.I0(s_axis_V_data_V_0_payload_B[1]),
        .I1(s_axis_V_data_V_0_payload_A[1]),
        .I2(s_axis_V_data_V_0_sel),
        .O(s_axis_V_data_V_0_data_out[1]));
  LUT4 #(
    .INIT(16'h2F02)) 
    \tmp_data_V_2_reg_271[7]_i_37 
       (.I0(pixel_count_read_reg_227[14]),
        .I1(i_0_reg_143_reg[14]),
        .I2(i_0_reg_143_reg[15]),
        .I3(pixel_count_read_reg_227[15]),
        .O(\tmp_data_V_2_reg_271[7]_i_37_n_1 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \tmp_data_V_2_reg_271[7]_i_38 
       (.I0(pixel_count_read_reg_227[12]),
        .I1(i_0_reg_143_reg[12]),
        .I2(i_0_reg_143_reg[13]),
        .I3(pixel_count_read_reg_227[13]),
        .O(\tmp_data_V_2_reg_271[7]_i_38_n_1 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \tmp_data_V_2_reg_271[7]_i_39 
       (.I0(pixel_count_read_reg_227[10]),
        .I1(i_0_reg_143_reg[10]),
        .I2(i_0_reg_143_reg[11]),
        .I3(pixel_count_read_reg_227[11]),
        .O(\tmp_data_V_2_reg_271[7]_i_39_n_1 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \tmp_data_V_2_reg_271[7]_i_40 
       (.I0(pixel_count_read_reg_227[8]),
        .I1(i_0_reg_143_reg[8]),
        .I2(i_0_reg_143_reg[9]),
        .I3(pixel_count_read_reg_227[9]),
        .O(\tmp_data_V_2_reg_271[7]_i_40_n_1 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \tmp_data_V_2_reg_271[7]_i_41 
       (.I0(i_0_reg_143_reg[14]),
        .I1(pixel_count_read_reg_227[14]),
        .I2(i_0_reg_143_reg[15]),
        .I3(pixel_count_read_reg_227[15]),
        .O(\tmp_data_V_2_reg_271[7]_i_41_n_1 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \tmp_data_V_2_reg_271[7]_i_42 
       (.I0(i_0_reg_143_reg[12]),
        .I1(pixel_count_read_reg_227[12]),
        .I2(i_0_reg_143_reg[13]),
        .I3(pixel_count_read_reg_227[13]),
        .O(\tmp_data_V_2_reg_271[7]_i_42_n_1 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \tmp_data_V_2_reg_271[7]_i_43 
       (.I0(i_0_reg_143_reg[10]),
        .I1(pixel_count_read_reg_227[10]),
        .I2(i_0_reg_143_reg[11]),
        .I3(pixel_count_read_reg_227[11]),
        .O(\tmp_data_V_2_reg_271[7]_i_43_n_1 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \tmp_data_V_2_reg_271[7]_i_44 
       (.I0(i_0_reg_143_reg[8]),
        .I1(pixel_count_read_reg_227[8]),
        .I2(i_0_reg_143_reg[9]),
        .I3(pixel_count_read_reg_227[9]),
        .O(\tmp_data_V_2_reg_271[7]_i_44_n_1 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \tmp_data_V_2_reg_271[7]_i_45 
       (.I0(pixel_count_read_reg_227[6]),
        .I1(i_0_reg_143_reg[6]),
        .I2(i_0_reg_143_reg[7]),
        .I3(pixel_count_read_reg_227[7]),
        .O(\tmp_data_V_2_reg_271[7]_i_45_n_1 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \tmp_data_V_2_reg_271[7]_i_46 
       (.I0(pixel_count_read_reg_227[4]),
        .I1(i_0_reg_143_reg[4]),
        .I2(i_0_reg_143_reg[5]),
        .I3(pixel_count_read_reg_227[5]),
        .O(\tmp_data_V_2_reg_271[7]_i_46_n_1 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \tmp_data_V_2_reg_271[7]_i_47 
       (.I0(pixel_count_read_reg_227[2]),
        .I1(i_0_reg_143_reg[2]),
        .I2(i_0_reg_143_reg[3]),
        .I3(pixel_count_read_reg_227[3]),
        .O(\tmp_data_V_2_reg_271[7]_i_47_n_1 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \tmp_data_V_2_reg_271[7]_i_48 
       (.I0(pixel_count_read_reg_227[0]),
        .I1(i_0_reg_143_reg[0]),
        .I2(i_0_reg_143_reg[1]),
        .I3(pixel_count_read_reg_227[1]),
        .O(\tmp_data_V_2_reg_271[7]_i_48_n_1 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \tmp_data_V_2_reg_271[7]_i_49 
       (.I0(i_0_reg_143_reg[6]),
        .I1(pixel_count_read_reg_227[6]),
        .I2(i_0_reg_143_reg[7]),
        .I3(pixel_count_read_reg_227[7]),
        .O(\tmp_data_V_2_reg_271[7]_i_49_n_1 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \tmp_data_V_2_reg_271[7]_i_50 
       (.I0(i_0_reg_143_reg[4]),
        .I1(pixel_count_read_reg_227[4]),
        .I2(i_0_reg_143_reg[5]),
        .I3(pixel_count_read_reg_227[5]),
        .O(\tmp_data_V_2_reg_271[7]_i_50_n_1 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \tmp_data_V_2_reg_271[7]_i_51 
       (.I0(i_0_reg_143_reg[2]),
        .I1(pixel_count_read_reg_227[2]),
        .I2(i_0_reg_143_reg[3]),
        .I3(pixel_count_read_reg_227[3]),
        .O(\tmp_data_V_2_reg_271[7]_i_51_n_1 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \tmp_data_V_2_reg_271[7]_i_52 
       (.I0(i_0_reg_143_reg[0]),
        .I1(pixel_count_read_reg_227[0]),
        .I2(i_0_reg_143_reg[1]),
        .I3(pixel_count_read_reg_227[1]),
        .O(\tmp_data_V_2_reg_271[7]_i_52_n_1 ));
  LUT3 #(
    .INIT(8'h04)) 
    \tmp_data_V_2_reg_271[7]_i_7 
       (.I0(pixel_count_read_reg_227[31]),
        .I1(pixel_count_read_reg_227[30]),
        .I2(i_0_reg_143_reg[30]),
        .O(\tmp_data_V_2_reg_271[7]_i_7_n_1 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \tmp_data_V_2_reg_271[7]_i_8 
       (.I0(pixel_count_read_reg_227[28]),
        .I1(i_0_reg_143_reg[28]),
        .I2(i_0_reg_143_reg[29]),
        .I3(pixel_count_read_reg_227[29]),
        .O(\tmp_data_V_2_reg_271[7]_i_8_n_1 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \tmp_data_V_2_reg_271[7]_i_9 
       (.I0(pixel_count_read_reg_227[26]),
        .I1(i_0_reg_143_reg[26]),
        .I2(i_0_reg_143_reg[27]),
        .I3(pixel_count_read_reg_227[27]),
        .O(\tmp_data_V_2_reg_271[7]_i_9_n_1 ));
  FDSE \tmp_data_V_2_reg_271_reg[0] 
       (.C(ap_clk),
        .CE(tmp_data_V_2_reg_2710),
        .D(\tmp_data_V_2_reg_271[0]_i_1_n_1 ),
        .Q(tmp_data_V_2_reg_271[0]),
        .S(1'b0));
  FDSE \tmp_data_V_2_reg_271_reg[1] 
       (.C(ap_clk),
        .CE(tmp_data_V_2_reg_2710),
        .D(\tmp_data_V_2_reg_271[1]_i_1_n_1 ),
        .Q(tmp_data_V_2_reg_271[1]),
        .S(1'b0));
  FDSE \tmp_data_V_2_reg_271_reg[2] 
       (.C(ap_clk),
        .CE(tmp_data_V_2_reg_2710),
        .D(\tmp_data_V_2_reg_271[2]_i_1_n_1 ),
        .Q(tmp_data_V_2_reg_271[2]),
        .S(1'b0));
  FDSE \tmp_data_V_2_reg_271_reg[3] 
       (.C(ap_clk),
        .CE(tmp_data_V_2_reg_2710),
        .D(\tmp_data_V_2_reg_271[3]_i_1_n_1 ),
        .Q(tmp_data_V_2_reg_271[3]),
        .S(1'b0));
  FDSE \tmp_data_V_2_reg_271_reg[4] 
       (.C(ap_clk),
        .CE(tmp_data_V_2_reg_2710),
        .D(\tmp_data_V_2_reg_271[4]_i_1_n_1 ),
        .Q(tmp_data_V_2_reg_271[4]),
        .S(1'b0));
  FDSE \tmp_data_V_2_reg_271_reg[5] 
       (.C(ap_clk),
        .CE(tmp_data_V_2_reg_2710),
        .D(\tmp_data_V_2_reg_271[5]_i_1_n_1 ),
        .Q(tmp_data_V_2_reg_271[5]),
        .S(1'b0));
  FDSE \tmp_data_V_2_reg_271_reg[6] 
       (.C(ap_clk),
        .CE(tmp_data_V_2_reg_2710),
        .D(\tmp_data_V_2_reg_271[6]_i_1_n_1 ),
        .Q(tmp_data_V_2_reg_271[6]),
        .S(1'b0));
  FDSE \tmp_data_V_2_reg_271_reg[7] 
       (.C(ap_clk),
        .CE(tmp_data_V_2_reg_2710),
        .D(\tmp_data_V_2_reg_271[7]_i_2_n_1 ),
        .Q(tmp_data_V_2_reg_271[7]),
        .S(1'b0));
  CARRY4 \tmp_data_V_2_reg_271_reg[7]_i_23 
       (.CI(\tmp_data_V_2_reg_271_reg[7]_i_36_n_1 ),
        .CO({\tmp_data_V_2_reg_271_reg[7]_i_23_n_1 ,\tmp_data_V_2_reg_271_reg[7]_i_23_n_2 ,\tmp_data_V_2_reg_271_reg[7]_i_23_n_3 ,\tmp_data_V_2_reg_271_reg[7]_i_23_n_4 }),
        .CYINIT(1'b0),
        .DI({\tmp_data_V_2_reg_271[7]_i_37_n_1 ,\tmp_data_V_2_reg_271[7]_i_38_n_1 ,\tmp_data_V_2_reg_271[7]_i_39_n_1 ,\tmp_data_V_2_reg_271[7]_i_40_n_1 }),
        .O(\NLW_tmp_data_V_2_reg_271_reg[7]_i_23_O_UNCONNECTED [3:0]),
        .S({\tmp_data_V_2_reg_271[7]_i_41_n_1 ,\tmp_data_V_2_reg_271[7]_i_42_n_1 ,\tmp_data_V_2_reg_271[7]_i_43_n_1 ,\tmp_data_V_2_reg_271[7]_i_44_n_1 }));
  CARRY4 \tmp_data_V_2_reg_271_reg[7]_i_36 
       (.CI(1'b0),
        .CO({\tmp_data_V_2_reg_271_reg[7]_i_36_n_1 ,\tmp_data_V_2_reg_271_reg[7]_i_36_n_2 ,\tmp_data_V_2_reg_271_reg[7]_i_36_n_3 ,\tmp_data_V_2_reg_271_reg[7]_i_36_n_4 }),
        .CYINIT(1'b0),
        .DI({\tmp_data_V_2_reg_271[7]_i_45_n_1 ,\tmp_data_V_2_reg_271[7]_i_46_n_1 ,\tmp_data_V_2_reg_271[7]_i_47_n_1 ,\tmp_data_V_2_reg_271[7]_i_48_n_1 }),
        .O(\NLW_tmp_data_V_2_reg_271_reg[7]_i_36_O_UNCONNECTED [3:0]),
        .S({\tmp_data_V_2_reg_271[7]_i_49_n_1 ,\tmp_data_V_2_reg_271[7]_i_50_n_1 ,\tmp_data_V_2_reg_271[7]_i_51_n_1 ,\tmp_data_V_2_reg_271[7]_i_52_n_1 }));
  CARRY4 \tmp_data_V_2_reg_271_reg[7]_i_4 
       (.CI(\tmp_data_V_2_reg_271_reg[7]_i_6_n_1 ),
        .CO({icmp_ln17_fu_158_p2,\tmp_data_V_2_reg_271_reg[7]_i_4_n_2 ,\tmp_data_V_2_reg_271_reg[7]_i_4_n_3 ,\tmp_data_V_2_reg_271_reg[7]_i_4_n_4 }),
        .CYINIT(1'b0),
        .DI({\tmp_data_V_2_reg_271[7]_i_7_n_1 ,\tmp_data_V_2_reg_271[7]_i_8_n_1 ,\tmp_data_V_2_reg_271[7]_i_9_n_1 ,\tmp_data_V_2_reg_271[7]_i_10_n_1 }),
        .O(\NLW_tmp_data_V_2_reg_271_reg[7]_i_4_O_UNCONNECTED [3:0]),
        .S({\tmp_data_V_2_reg_271[7]_i_11_n_1 ,\tmp_data_V_2_reg_271[7]_i_12_n_1 ,\tmp_data_V_2_reg_271[7]_i_13_n_1 ,\tmp_data_V_2_reg_271[7]_i_14_n_1 }));
  CARRY4 \tmp_data_V_2_reg_271_reg[7]_i_5 
       (.CI(1'b0),
        .CO({tmp_data_V_1_fu_202_p3,\tmp_data_V_2_reg_271_reg[7]_i_5_n_2 ,\tmp_data_V_2_reg_271_reg[7]_i_5_n_3 ,\tmp_data_V_2_reg_271_reg[7]_i_5_n_4 }),
        .CYINIT(1'b0),
        .DI({\tmp_data_V_2_reg_271[7]_i_15_n_1 ,\tmp_data_V_2_reg_271[7]_i_16_n_1 ,\tmp_data_V_2_reg_271[7]_i_17_n_1 ,\tmp_data_V_2_reg_271[7]_i_18_n_1 }),
        .O(\NLW_tmp_data_V_2_reg_271_reg[7]_i_5_O_UNCONNECTED [3:0]),
        .S({\tmp_data_V_2_reg_271[7]_i_19_n_1 ,\tmp_data_V_2_reg_271[7]_i_20_n_1 ,\tmp_data_V_2_reg_271[7]_i_21_n_1 ,\tmp_data_V_2_reg_271[7]_i_22_n_1 }));
  CARRY4 \tmp_data_V_2_reg_271_reg[7]_i_6 
       (.CI(\tmp_data_V_2_reg_271_reg[7]_i_23_n_1 ),
        .CO({\tmp_data_V_2_reg_271_reg[7]_i_6_n_1 ,\tmp_data_V_2_reg_271_reg[7]_i_6_n_2 ,\tmp_data_V_2_reg_271_reg[7]_i_6_n_3 ,\tmp_data_V_2_reg_271_reg[7]_i_6_n_4 }),
        .CYINIT(1'b0),
        .DI({\tmp_data_V_2_reg_271[7]_i_24_n_1 ,\tmp_data_V_2_reg_271[7]_i_25_n_1 ,\tmp_data_V_2_reg_271[7]_i_26_n_1 ,\tmp_data_V_2_reg_271[7]_i_27_n_1 }),
        .O(\NLW_tmp_data_V_2_reg_271_reg[7]_i_6_O_UNCONNECTED [3:0]),
        .S({\tmp_data_V_2_reg_271[7]_i_28_n_1 ,\tmp_data_V_2_reg_271[7]_i_29_n_1 ,\tmp_data_V_2_reg_271[7]_i_30_n_1 ,\tmp_data_V_2_reg_271[7]_i_31_n_1 }));
  LUT3 #(
    .INIT(8'hB8)) 
    \tmp_dest_V_reg_266[0]_i_1 
       (.I0(s_axis_V_dest_V_0_payload_B),
        .I1(s_axis_V_dest_V_0_sel),
        .I2(s_axis_V_dest_V_0_payload_A),
        .O(s_axis_V_dest_V_0_data_out));
  FDRE \tmp_dest_V_reg_266_reg[0] 
       (.C(ap_clk),
        .CE(tmp_data_V_2_reg_2710),
        .D(s_axis_V_dest_V_0_data_out),
        .Q(tmp_dest_V_reg_266),
        .R(1'b0));
  LUT3 #(
    .INIT(8'hB8)) 
    \tmp_id_V_reg_261[0]_i_1 
       (.I0(s_axis_V_id_V_0_payload_B),
        .I1(s_axis_V_id_V_0_sel),
        .I2(s_axis_V_id_V_0_payload_A),
        .O(s_axis_V_id_V_0_data_out));
  FDRE \tmp_id_V_reg_261_reg[0] 
       (.C(ap_clk),
        .CE(tmp_data_V_2_reg_2710),
        .D(s_axis_V_id_V_0_data_out),
        .Q(tmp_id_V_reg_261),
        .R(1'b0));
  LUT3 #(
    .INIT(8'hB8)) 
    \tmp_keep_V_reg_241[0]_i_1 
       (.I0(s_axis_V_keep_V_0_payload_B),
        .I1(s_axis_V_keep_V_0_sel),
        .I2(s_axis_V_keep_V_0_payload_A),
        .O(s_axis_V_keep_V_0_data_out));
  FDRE \tmp_keep_V_reg_241_reg[0] 
       (.C(ap_clk),
        .CE(tmp_data_V_2_reg_2710),
        .D(s_axis_V_keep_V_0_data_out),
        .Q(tmp_keep_V_reg_241),
        .R(1'b0));
  LUT3 #(
    .INIT(8'hB8)) 
    \tmp_last_V_reg_256[0]_i_1 
       (.I0(s_axis_V_last_V_0_payload_B),
        .I1(s_axis_V_last_V_0_sel),
        .I2(s_axis_V_last_V_0_payload_A),
        .O(s_axis_V_last_V_0_data_out));
  FDRE \tmp_last_V_reg_256_reg[0] 
       (.C(ap_clk),
        .CE(tmp_data_V_2_reg_2710),
        .D(s_axis_V_last_V_0_data_out),
        .Q(tmp_last_V_reg_256),
        .R(1'b0));
  LUT3 #(
    .INIT(8'hB8)) 
    \tmp_strb_V_reg_246[0]_i_1 
       (.I0(s_axis_V_strb_V_0_payload_B),
        .I1(s_axis_V_strb_V_0_sel),
        .I2(s_axis_V_strb_V_0_payload_A),
        .O(s_axis_V_strb_V_0_data_out));
  FDRE \tmp_strb_V_reg_246_reg[0] 
       (.C(ap_clk),
        .CE(tmp_data_V_2_reg_2710),
        .D(s_axis_V_strb_V_0_data_out),
        .Q(tmp_strb_V_reg_246),
        .R(1'b0));
  LUT3 #(
    .INIT(8'hB8)) 
    \tmp_user_V_reg_251[0]_i_1 
       (.I0(s_axis_V_user_V_0_payload_B),
        .I1(s_axis_V_user_V_0_sel),
        .I2(s_axis_V_user_V_0_payload_A),
        .O(s_axis_V_user_V_0_data_out));
  FDRE \tmp_user_V_reg_251_reg[0] 
       (.C(ap_clk),
        .CE(tmp_data_V_2_reg_2710),
        .D(s_axis_V_user_V_0_data_out),
        .Q(tmp_user_V_reg_251),
        .R(1'b0));
endmodule

(* CHECK_LICENSE_TYPE = "cubeocc_hls_0,cubeocc_hls,{}" *) (* DowngradeIPIdentifiedWarnings = "yes" *) (* IP_DEFINITION_SOURCE = "HLS" *) 
(* X_CORE_INFO = "cubeocc_hls,Vivado 2019.1" *) (* hls_module = "yes" *) 
(* NotValidForBitStream *)
module cubeocc_hls_1
   (s_axi_CTRL_AWADDR,
    s_axi_CTRL_AWVALID,
    s_axi_CTRL_AWREADY,
    s_axi_CTRL_WDATA,
    s_axi_CTRL_WSTRB,
    s_axi_CTRL_WVALID,
    s_axi_CTRL_WREADY,
    s_axi_CTRL_BRESP,
    s_axi_CTRL_BVALID,
    s_axi_CTRL_BREADY,
    s_axi_CTRL_ARADDR,
    s_axi_CTRL_ARVALID,
    s_axi_CTRL_ARREADY,
    s_axi_CTRL_RDATA,
    s_axi_CTRL_RRESP,
    s_axi_CTRL_RVALID,
    s_axi_CTRL_RREADY,
    ap_clk,
    ap_rst_n,
    interrupt,
    s_axis_TVALID,
    s_axis_TREADY,
    s_axis_TDATA,
    s_axis_TDEST,
    s_axis_TKEEP,
    s_axis_TSTRB,
    s_axis_TUSER,
    s_axis_TLAST,
    s_axis_TID,
    m_axis_TVALID,
    m_axis_TREADY,
    m_axis_TDATA,
    m_axis_TDEST,
    m_axis_TKEEP,
    m_axis_TSTRB,
    m_axis_TUSER,
    m_axis_TLAST,
    m_axis_TID);
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_CTRL AWADDR" *) input [5:0]s_axi_CTRL_AWADDR;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_CTRL AWVALID" *) input s_axi_CTRL_AWVALID;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_CTRL AWREADY" *) output s_axi_CTRL_AWREADY;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_CTRL WDATA" *) input [31:0]s_axi_CTRL_WDATA;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_CTRL WSTRB" *) input [3:0]s_axi_CTRL_WSTRB;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_CTRL WVALID" *) input s_axi_CTRL_WVALID;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_CTRL WREADY" *) output s_axi_CTRL_WREADY;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_CTRL BRESP" *) output [1:0]s_axi_CTRL_BRESP;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_CTRL BVALID" *) output s_axi_CTRL_BVALID;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_CTRL BREADY" *) input s_axi_CTRL_BREADY;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_CTRL ARADDR" *) input [5:0]s_axi_CTRL_ARADDR;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_CTRL ARVALID" *) input s_axi_CTRL_ARVALID;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_CTRL ARREADY" *) output s_axi_CTRL_ARREADY;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_CTRL RDATA" *) output [31:0]s_axi_CTRL_RDATA;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_CTRL RRESP" *) output [1:0]s_axi_CTRL_RRESP;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_CTRL RVALID" *) output s_axi_CTRL_RVALID;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_CTRL RREADY" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME s_axi_CTRL, ADDR_WIDTH 6, DATA_WIDTH 32, PROTOCOL AXI4LITE, READ_WRITE_MODE READ_WRITE, FREQ_HZ 100000000, ID_WIDTH 0, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 0, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 0, NUM_READ_OUTSTANDING 1, NUM_WRITE_OUTSTANDING 1, MAX_BURST_LENGTH 1, PHASE 0.000, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0" *) input s_axi_CTRL_RREADY;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 ap_clk CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME ap_clk, ASSOCIATED_BUSIF s_axi_CTRL:s_axis:m_axis, ASSOCIATED_RESET ap_rst_n, FREQ_HZ 100000000, PHASE 0.000, INSERT_VIP 0" *) input ap_clk;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 ap_rst_n RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME ap_rst_n, POLARITY ACTIVE_LOW, INSERT_VIP 0" *) input ap_rst_n;
  (* X_INTERFACE_INFO = "xilinx.com:signal:interrupt:1.0 interrupt INTERRUPT" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME interrupt, SENSITIVITY LEVEL_HIGH, PortWidth 1" *) output interrupt;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_axis TVALID" *) input s_axis_TVALID;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_axis TREADY" *) output s_axis_TREADY;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_axis TDATA" *) input [7:0]s_axis_TDATA;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_axis TDEST" *) input [0:0]s_axis_TDEST;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_axis TKEEP" *) input [0:0]s_axis_TKEEP;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_axis TSTRB" *) input [0:0]s_axis_TSTRB;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_axis TUSER" *) input [0:0]s_axis_TUSER;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_axis TLAST" *) input [0:0]s_axis_TLAST;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_axis TID" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME s_axis, TDATA_NUM_BYTES 1, TDEST_WIDTH 1, TID_WIDTH 1, TUSER_WIDTH 1, HAS_TREADY 1, HAS_TSTRB 1, HAS_TKEEP 1, HAS_TLAST 1, FREQ_HZ 100000000, PHASE 0.000, INSERT_VIP 0" *) input [0:0]s_axis_TID;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis TVALID" *) output m_axis_TVALID;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis TREADY" *) input m_axis_TREADY;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis TDATA" *) output [7:0]m_axis_TDATA;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis TDEST" *) output [0:0]m_axis_TDEST;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis TKEEP" *) output [0:0]m_axis_TKEEP;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis TSTRB" *) output [0:0]m_axis_TSTRB;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis TUSER" *) output [0:0]m_axis_TUSER;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis TLAST" *) output [0:0]m_axis_TLAST;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis TID" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME m_axis, TDATA_NUM_BYTES 1, TDEST_WIDTH 1, TID_WIDTH 1, TUSER_WIDTH 1, HAS_TREADY 1, HAS_TSTRB 1, HAS_TKEEP 1, HAS_TLAST 1, FREQ_HZ 100000000, PHASE 0.000, INSERT_VIP 0" *) output [0:0]m_axis_TID;

  wire ap_clk;
  wire ap_rst_n;
  wire interrupt;
  wire [7:0]m_axis_TDATA;
  wire [0:0]m_axis_TDEST;
  wire [0:0]m_axis_TID;
  wire [0:0]m_axis_TKEEP;
  wire [0:0]m_axis_TLAST;
  wire m_axis_TREADY;
  wire [0:0]m_axis_TSTRB;
  wire [0:0]m_axis_TUSER;
  wire m_axis_TVALID;
  wire [5:0]s_axi_CTRL_ARADDR;
  wire s_axi_CTRL_ARREADY;
  wire s_axi_CTRL_ARVALID;
  wire [5:0]s_axi_CTRL_AWADDR;
  wire s_axi_CTRL_AWREADY;
  wire s_axi_CTRL_AWVALID;
  wire s_axi_CTRL_BREADY;
  wire [1:0]s_axi_CTRL_BRESP;
  wire s_axi_CTRL_BVALID;
  wire [31:0]s_axi_CTRL_RDATA;
  wire s_axi_CTRL_RREADY;
  wire [1:0]s_axi_CTRL_RRESP;
  wire s_axi_CTRL_RVALID;
  wire [31:0]s_axi_CTRL_WDATA;
  wire s_axi_CTRL_WREADY;
  wire [3:0]s_axi_CTRL_WSTRB;
  wire s_axi_CTRL_WVALID;
  wire [7:0]s_axis_TDATA;
  wire [0:0]s_axis_TDEST;
  wire [0:0]s_axis_TID;
  wire [0:0]s_axis_TKEEP;
  wire [0:0]s_axis_TLAST;
  wire s_axis_TREADY;
  wire [0:0]s_axis_TSTRB;
  wire [0:0]s_axis_TUSER;
  wire s_axis_TVALID;

  (* C_S_AXI_CTRL_ADDR_WIDTH = "6" *) 
  (* C_S_AXI_CTRL_DATA_WIDTH = "32" *) 
  (* C_S_AXI_CTRL_WSTRB_WIDTH = "4" *) 
  (* C_S_AXI_DATA_WIDTH = "32" *) 
  (* C_S_AXI_WSTRB_WIDTH = "4" *) 
  (* ap_ST_fsm_pp0_stage0 = "3'b010" *) 
  (* ap_ST_fsm_state1 = "3'b001" *) 
  (* ap_ST_fsm_state5 = "3'b100" *) 
  cubeocc_hls_1_cubeocc_hls inst
       (.ap_clk(ap_clk),
        .ap_rst_n(ap_rst_n),
        .interrupt(interrupt),
        .m_axis_TDATA(m_axis_TDATA),
        .m_axis_TDEST(m_axis_TDEST),
        .m_axis_TID(m_axis_TID),
        .m_axis_TKEEP(m_axis_TKEEP),
        .m_axis_TLAST(m_axis_TLAST),
        .m_axis_TREADY(m_axis_TREADY),
        .m_axis_TSTRB(m_axis_TSTRB),
        .m_axis_TUSER(m_axis_TUSER),
        .m_axis_TVALID(m_axis_TVALID),
        .s_axi_CTRL_ARADDR(s_axi_CTRL_ARADDR),
        .s_axi_CTRL_ARREADY(s_axi_CTRL_ARREADY),
        .s_axi_CTRL_ARVALID(s_axi_CTRL_ARVALID),
        .s_axi_CTRL_AWADDR(s_axi_CTRL_AWADDR),
        .s_axi_CTRL_AWREADY(s_axi_CTRL_AWREADY),
        .s_axi_CTRL_AWVALID(s_axi_CTRL_AWVALID),
        .s_axi_CTRL_BREADY(s_axi_CTRL_BREADY),
        .s_axi_CTRL_BRESP(s_axi_CTRL_BRESP),
        .s_axi_CTRL_BVALID(s_axi_CTRL_BVALID),
        .s_axi_CTRL_RDATA(s_axi_CTRL_RDATA),
        .s_axi_CTRL_RREADY(s_axi_CTRL_RREADY),
        .s_axi_CTRL_RRESP(s_axi_CTRL_RRESP),
        .s_axi_CTRL_RVALID(s_axi_CTRL_RVALID),
        .s_axi_CTRL_WDATA(s_axi_CTRL_WDATA),
        .s_axi_CTRL_WREADY(s_axi_CTRL_WREADY),
        .s_axi_CTRL_WSTRB(s_axi_CTRL_WSTRB),
        .s_axi_CTRL_WVALID(s_axi_CTRL_WVALID),
        .s_axis_TDATA(s_axis_TDATA),
        .s_axis_TDEST(s_axis_TDEST),
        .s_axis_TID(s_axis_TID),
        .s_axis_TKEEP(s_axis_TKEEP),
        .s_axis_TLAST(s_axis_TLAST),
        .s_axis_TREADY(s_axis_TREADY),
        .s_axis_TSTRB(s_axis_TSTRB),
        .s_axis_TUSER(s_axis_TUSER),
        .s_axis_TVALID(s_axis_TVALID));
endmodule

module cubeocc_hls_1_cubeocc_hls_CTRL_s_axi
   (ap_rst_n_inv,
    ap_done,
    threshold_enable,
    \ap_CS_fsm_reg[0] ,
    \FSM_onehot_wstate_reg[2]_0 ,
    s_axi_CTRL_BVALID,
    \int_pixel_count_reg[31]_0 ,
    \int_threshold_V_reg[7]_0 ,
    \FSM_onehot_rstate_reg[1]_0 ,
    s_axi_CTRL_RVALID,
    D,
    interrupt,
    i_0_reg_143,
    \ap_CS_fsm_reg[1] ,
    E,
    \FSM_onehot_wstate_reg[1]_0 ,
    s_axi_CTRL_RDATA,
    ap_clk,
    Q,
    ap_enable_reg_pp0_iter2_reg,
    ap_block_pp0_stage0_subdone3_in,
    ap_enable_reg_pp0_iter2_reg_0,
    ap_rst_n,
    s_axi_CTRL_WDATA,
    s_axi_CTRL_WSTRB,
    s_axi_CTRL_WVALID,
    s_axi_CTRL_BREADY,
    s_axi_CTRL_ARADDR,
    s_axi_CTRL_ARVALID,
    s_axi_CTRL_RREADY,
    int_ap_ready_reg_0,
    m_axis_TREADY,
    m_axis_V_strb_V_1_ack_in,
    int_ap_ready_reg_1,
    m_axis_V_last_V_1_ack_in,
    int_ap_ready_reg_2,
    m_axis_V_user_V_1_ack_in,
    int_ap_ready_reg_3,
    m_axis_V_id_V_1_ack_in,
    int_ap_ready_reg_4,
    m_axis_V_keep_V_1_ack_in,
    int_ap_ready_i_2_0,
    m_axis_V_data_V_1_ack_in,
    int_ap_ready_i_2_1,
    m_axis_V_dest_V_1_ack_in,
    \ap_CS_fsm_reg[1]_0 ,
    \i_0_reg_143_reg[0] ,
    CO,
    ap_enable_reg_pp0_iter0,
    s_axi_CTRL_AWVALID,
    s_axi_CTRL_AWADDR);
  output ap_rst_n_inv;
  output ap_done;
  output threshold_enable;
  output \ap_CS_fsm_reg[0] ;
  output \FSM_onehot_wstate_reg[2]_0 ;
  output s_axi_CTRL_BVALID;
  output [31:0]\int_pixel_count_reg[31]_0 ;
  output [7:0]\int_threshold_V_reg[7]_0 ;
  output \FSM_onehot_rstate_reg[1]_0 ;
  output s_axi_CTRL_RVALID;
  output [1:0]D;
  output interrupt;
  output i_0_reg_143;
  output \ap_CS_fsm_reg[1] ;
  output [0:0]E;
  output \FSM_onehot_wstate_reg[1]_0 ;
  output [31:0]s_axi_CTRL_RDATA;
  input ap_clk;
  input [2:0]Q;
  input ap_enable_reg_pp0_iter2_reg;
  input ap_block_pp0_stage0_subdone3_in;
  input ap_enable_reg_pp0_iter2_reg_0;
  input ap_rst_n;
  input [31:0]s_axi_CTRL_WDATA;
  input [3:0]s_axi_CTRL_WSTRB;
  input s_axi_CTRL_WVALID;
  input s_axi_CTRL_BREADY;
  input [5:0]s_axi_CTRL_ARADDR;
  input s_axi_CTRL_ARVALID;
  input s_axi_CTRL_RREADY;
  input int_ap_ready_reg_0;
  input m_axis_TREADY;
  input m_axis_V_strb_V_1_ack_in;
  input int_ap_ready_reg_1;
  input m_axis_V_last_V_1_ack_in;
  input int_ap_ready_reg_2;
  input m_axis_V_user_V_1_ack_in;
  input int_ap_ready_reg_3;
  input m_axis_V_id_V_1_ack_in;
  input int_ap_ready_reg_4;
  input m_axis_V_keep_V_1_ack_in;
  input int_ap_ready_i_2_0;
  input m_axis_V_data_V_1_ack_in;
  input int_ap_ready_i_2_1;
  input m_axis_V_dest_V_1_ack_in;
  input \ap_CS_fsm_reg[1]_0 ;
  input \i_0_reg_143_reg[0] ;
  input [0:0]CO;
  input ap_enable_reg_pp0_iter0;
  input s_axi_CTRL_AWVALID;
  input [5:0]s_axi_CTRL_AWADDR;

  wire [0:0]CO;
  wire [1:0]D;
  wire [0:0]E;
  wire \FSM_onehot_rstate[1]_i_1_n_1 ;
  wire \FSM_onehot_rstate[2]_i_1_n_1 ;
  wire \FSM_onehot_rstate_reg[1]_0 ;
  wire \FSM_onehot_wstate[1]_i_1_n_1 ;
  wire \FSM_onehot_wstate[2]_i_1_n_1 ;
  wire \FSM_onehot_wstate[3]_i_1_n_1 ;
  wire \FSM_onehot_wstate_reg[1]_0 ;
  wire \FSM_onehot_wstate_reg[2]_0 ;
  wire [2:0]Q;
  wire \ap_CS_fsm_reg[0] ;
  wire \ap_CS_fsm_reg[1] ;
  wire \ap_CS_fsm_reg[1]_0 ;
  wire ap_block_pp0_stage0_subdone3_in;
  wire ap_clk;
  wire ap_done;
  wire ap_enable_reg_pp0_iter0;
  wire ap_enable_reg_pp0_iter2_reg;
  wire ap_enable_reg_pp0_iter2_reg_0;
  wire ap_idle;
  wire ap_rst_n;
  wire ap_rst_n_inv;
  wire ap_start;
  wire ar_hs;
  wire i_0_reg_143;
  wire \i_0_reg_143_reg[0] ;
  wire int_ap_done;
  wire int_ap_done_i_1_n_1;
  wire int_ap_done_i_2_n_1;
  wire int_ap_idle;
  wire int_ap_ready;
  wire int_ap_ready_i_2_0;
  wire int_ap_ready_i_2_1;
  wire int_ap_ready_i_2_n_1;
  wire int_ap_ready_i_3_n_1;
  wire int_ap_ready_i_4_n_1;
  wire int_ap_ready_i_5_n_1;
  wire int_ap_ready_i_6_n_1;
  wire int_ap_ready_i_7_n_1;
  wire int_ap_ready_reg_0;
  wire int_ap_ready_reg_1;
  wire int_ap_ready_reg_2;
  wire int_ap_ready_reg_3;
  wire int_ap_ready_reg_4;
  wire int_ap_start3_out;
  wire int_ap_start_i_1_n_1;
  wire int_ap_start_i_3_n_1;
  wire int_auto_restart;
  wire int_auto_restart_i_1_n_1;
  wire int_gie_i_1_n_1;
  wire int_gie_reg_n_1;
  wire \int_ier[0]_i_1_n_1 ;
  wire \int_ier[1]_i_1_n_1 ;
  wire \int_ier[1]_i_2_n_1 ;
  wire \int_ier_reg_n_1_[0] ;
  wire int_isr6_out;
  wire \int_isr[0]_i_1_n_1 ;
  wire \int_isr[1]_i_1_n_1 ;
  wire \int_isr_reg_n_1_[0] ;
  wire \int_pixel_count[0]_i_1_n_1 ;
  wire \int_pixel_count[10]_i_1_n_1 ;
  wire \int_pixel_count[11]_i_1_n_1 ;
  wire \int_pixel_count[12]_i_1_n_1 ;
  wire \int_pixel_count[13]_i_1_n_1 ;
  wire \int_pixel_count[14]_i_1_n_1 ;
  wire \int_pixel_count[15]_i_1_n_1 ;
  wire \int_pixel_count[16]_i_1_n_1 ;
  wire \int_pixel_count[17]_i_1_n_1 ;
  wire \int_pixel_count[18]_i_1_n_1 ;
  wire \int_pixel_count[19]_i_1_n_1 ;
  wire \int_pixel_count[1]_i_1_n_1 ;
  wire \int_pixel_count[20]_i_1_n_1 ;
  wire \int_pixel_count[21]_i_1_n_1 ;
  wire \int_pixel_count[22]_i_1_n_1 ;
  wire \int_pixel_count[23]_i_1_n_1 ;
  wire \int_pixel_count[24]_i_1_n_1 ;
  wire \int_pixel_count[25]_i_1_n_1 ;
  wire \int_pixel_count[26]_i_1_n_1 ;
  wire \int_pixel_count[27]_i_1_n_1 ;
  wire \int_pixel_count[28]_i_1_n_1 ;
  wire \int_pixel_count[29]_i_1_n_1 ;
  wire \int_pixel_count[2]_i_1_n_1 ;
  wire \int_pixel_count[30]_i_1_n_1 ;
  wire \int_pixel_count[31]_i_1_n_1 ;
  wire \int_pixel_count[31]_i_2_n_1 ;
  wire \int_pixel_count[31]_i_3_n_1 ;
  wire \int_pixel_count[3]_i_1_n_1 ;
  wire \int_pixel_count[4]_i_1_n_1 ;
  wire \int_pixel_count[5]_i_1_n_1 ;
  wire \int_pixel_count[6]_i_1_n_1 ;
  wire \int_pixel_count[7]_i_1_n_1 ;
  wire \int_pixel_count[8]_i_1_n_1 ;
  wire \int_pixel_count[9]_i_1_n_1 ;
  wire [31:0]\int_pixel_count_reg[31]_0 ;
  wire \int_threshold_V[0]_i_1_n_1 ;
  wire \int_threshold_V[1]_i_1_n_1 ;
  wire \int_threshold_V[2]_i_1_n_1 ;
  wire \int_threshold_V[3]_i_1_n_1 ;
  wire \int_threshold_V[4]_i_1_n_1 ;
  wire \int_threshold_V[5]_i_1_n_1 ;
  wire \int_threshold_V[6]_i_1_n_1 ;
  wire \int_threshold_V[7]_i_1_n_1 ;
  wire \int_threshold_V[7]_i_2_n_1 ;
  wire [7:0]\int_threshold_V_reg[7]_0 ;
  wire \int_threshold_enable[0]_i_1_n_1 ;
  wire \int_threshold_enable[0]_i_2_n_1 ;
  wire \int_threshold_enable[0]_i_3_n_1 ;
  wire interrupt;
  wire m_axis_TREADY;
  wire m_axis_V_data_V_1_ack_in;
  wire m_axis_V_dest_V_1_ack_in;
  wire m_axis_V_id_V_1_ack_in;
  wire m_axis_V_keep_V_1_ack_in;
  wire m_axis_V_last_V_1_ack_in;
  wire m_axis_V_strb_V_1_ack_in;
  wire m_axis_V_user_V_1_ack_in;
  wire p_0_in;
  wire p_1_in;
  wire [7:0]rdata;
  wire \rdata[0]_i_2_n_1 ;
  wire \rdata[0]_i_3_n_1 ;
  wire \rdata[1]_i_2_n_1 ;
  wire \rdata[31]_i_1_n_1 ;
  wire \rdata[31]_i_3_n_1 ;
  wire \rdata[6]_i_2_n_1 ;
  wire \rdata[7]_i_2_n_1 ;
  wire \rdata[7]_i_3_n_1 ;
  wire \rdata[7]_i_4_n_1 ;
  wire [5:0]s_axi_CTRL_ARADDR;
  wire s_axi_CTRL_ARVALID;
  wire [5:0]s_axi_CTRL_AWADDR;
  wire s_axi_CTRL_AWVALID;
  wire s_axi_CTRL_BREADY;
  wire s_axi_CTRL_BVALID;
  wire [31:0]s_axi_CTRL_RDATA;
  wire s_axi_CTRL_RREADY;
  wire s_axi_CTRL_RVALID;
  wire [31:0]s_axi_CTRL_WDATA;
  wire [3:0]s_axi_CTRL_WSTRB;
  wire s_axi_CTRL_WVALID;
  wire threshold_enable;
  wire waddr;
  wire \waddr_reg_n_1_[0] ;
  wire \waddr_reg_n_1_[1] ;
  wire \waddr_reg_n_1_[2] ;
  wire \waddr_reg_n_1_[3] ;
  wire \waddr_reg_n_1_[4] ;
  wire \waddr_reg_n_1_[5] ;

  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT4 #(
    .INIT(16'h8BFB)) 
    \FSM_onehot_rstate[1]_i_1 
       (.I0(s_axi_CTRL_RREADY),
        .I1(s_axi_CTRL_RVALID),
        .I2(\FSM_onehot_rstate_reg[1]_0 ),
        .I3(s_axi_CTRL_ARVALID),
        .O(\FSM_onehot_rstate[1]_i_1_n_1 ));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT4 #(
    .INIT(16'h8F88)) 
    \FSM_onehot_rstate[2]_i_1 
       (.I0(\FSM_onehot_rstate_reg[1]_0 ),
        .I1(s_axi_CTRL_ARVALID),
        .I2(s_axi_CTRL_RREADY),
        .I3(s_axi_CTRL_RVALID),
        .O(\FSM_onehot_rstate[2]_i_1_n_1 ));
  (* FSM_ENCODED_STATES = "RDIDLE:010,RDDATA:100,iSTATE:001" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_rstate_reg[1] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\FSM_onehot_rstate[1]_i_1_n_1 ),
        .Q(\FSM_onehot_rstate_reg[1]_0 ),
        .R(ap_rst_n_inv));
  (* FSM_ENCODED_STATES = "RDIDLE:010,RDDATA:100,iSTATE:001" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_rstate_reg[2] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\FSM_onehot_rstate[2]_i_1_n_1 ),
        .Q(s_axi_CTRL_RVALID),
        .R(ap_rst_n_inv));
  LUT5 #(
    .INIT(32'hBABA303F)) 
    \FSM_onehot_wstate[1]_i_1 
       (.I0(s_axi_CTRL_BREADY),
        .I1(s_axi_CTRL_AWVALID),
        .I2(\FSM_onehot_wstate_reg[1]_0 ),
        .I3(\FSM_onehot_wstate_reg[2]_0 ),
        .I4(s_axi_CTRL_BVALID),
        .O(\FSM_onehot_wstate[1]_i_1_n_1 ));
  LUT4 #(
    .INIT(16'hF444)) 
    \FSM_onehot_wstate[2]_i_1 
       (.I0(s_axi_CTRL_WVALID),
        .I1(\FSM_onehot_wstate_reg[2]_0 ),
        .I2(\FSM_onehot_wstate_reg[1]_0 ),
        .I3(s_axi_CTRL_AWVALID),
        .O(\FSM_onehot_wstate[2]_i_1_n_1 ));
  LUT4 #(
    .INIT(16'h8F88)) 
    \FSM_onehot_wstate[3]_i_1 
       (.I0(\FSM_onehot_wstate_reg[2]_0 ),
        .I1(s_axi_CTRL_WVALID),
        .I2(s_axi_CTRL_BREADY),
        .I3(s_axi_CTRL_BVALID),
        .O(\FSM_onehot_wstate[3]_i_1_n_1 ));
  (* FSM_ENCODED_STATES = "WRDATA:0100,WRRESP:1000,WRIDLE:0010,iSTATE:0001" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_wstate_reg[1] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\FSM_onehot_wstate[1]_i_1_n_1 ),
        .Q(\FSM_onehot_wstate_reg[1]_0 ),
        .R(ap_rst_n_inv));
  (* FSM_ENCODED_STATES = "WRDATA:0100,WRRESP:1000,WRIDLE:0010,iSTATE:0001" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_wstate_reg[2] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\FSM_onehot_wstate[2]_i_1_n_1 ),
        .Q(\FSM_onehot_wstate_reg[2]_0 ),
        .R(ap_rst_n_inv));
  (* FSM_ENCODED_STATES = "WRDATA:0100,WRRESP:1000,WRIDLE:0010,iSTATE:0001" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_wstate_reg[3] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\FSM_onehot_wstate[3]_i_1_n_1 ),
        .Q(s_axi_CTRL_BVALID),
        .R(ap_rst_n_inv));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT3 #(
    .INIT(8'hBA)) 
    \ap_CS_fsm[0]_i_1 
       (.I0(ap_done),
        .I1(ap_start),
        .I2(Q[0]),
        .O(D[0]));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT4 #(
    .INIT(16'hEAE0)) 
    \ap_CS_fsm[1]_i_1 
       (.I0(Q[1]),
        .I1(ap_start),
        .I2(Q[0]),
        .I3(\ap_CS_fsm_reg[1]_0 ),
        .O(D[1]));
  LUT6 #(
    .INIT(64'hF7F7F70000000000)) 
    ap_enable_reg_pp0_iter0_i_1
       (.I0(Q[1]),
        .I1(ap_block_pp0_stage0_subdone3_in),
        .I2(CO),
        .I3(E),
        .I4(ap_enable_reg_pp0_iter0),
        .I5(ap_rst_n),
        .O(\ap_CS_fsm_reg[1] ));
  LUT6 #(
    .INIT(64'hF077F00000000000)) 
    ap_enable_reg_pp0_iter2_i_1
       (.I0(Q[0]),
        .I1(ap_start),
        .I2(ap_enable_reg_pp0_iter2_reg),
        .I3(ap_block_pp0_stage0_subdone3_in),
        .I4(ap_enable_reg_pp0_iter2_reg_0),
        .I5(ap_rst_n),
        .O(\ap_CS_fsm_reg[0] ));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \i_0_reg_143[0]_i_1 
       (.I0(ap_start),
        .I1(Q[0]),
        .I2(\i_0_reg_143_reg[0] ),
        .O(i_0_reg_143));
  LUT6 #(
    .INIT(64'hFFFFFFFEAAAAAAAA)) 
    int_ap_done_i_1
       (.I0(ap_done),
        .I1(int_ap_done_i_2_n_1),
        .I2(s_axi_CTRL_ARADDR[1]),
        .I3(s_axi_CTRL_ARADDR[0]),
        .I4(s_axi_CTRL_ARADDR[2]),
        .I5(int_ap_done),
        .O(int_ap_done_i_1_n_1));
  LUT5 #(
    .INIT(32'hFFFFFFF7)) 
    int_ap_done_i_2
       (.I0(\FSM_onehot_rstate_reg[1]_0 ),
        .I1(s_axi_CTRL_ARVALID),
        .I2(s_axi_CTRL_ARADDR[5]),
        .I3(s_axi_CTRL_ARADDR[4]),
        .I4(s_axi_CTRL_ARADDR[3]),
        .O(int_ap_done_i_2_n_1));
  FDRE #(
    .INIT(1'b0)) 
    int_ap_done_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(int_ap_done_i_1_n_1),
        .Q(int_ap_done),
        .R(ap_rst_n_inv));
  (* SOFT_HLUTNM = "soft_lutpair25" *) 
  LUT2 #(
    .INIT(4'h2)) 
    int_ap_idle_i_1
       (.I0(Q[0]),
        .I1(ap_start),
        .O(ap_idle));
  FDRE int_ap_idle_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(ap_idle),
        .Q(int_ap_idle),
        .R(ap_rst_n_inv));
  LUT6 #(
    .INIT(64'h000000000000A222)) 
    int_ap_ready_i_1
       (.I0(int_ap_ready_i_2_n_1),
        .I1(int_ap_ready_reg_0),
        .I2(m_axis_TREADY),
        .I3(m_axis_V_strb_V_1_ack_in),
        .I4(int_ap_ready_i_3_n_1),
        .I5(int_ap_ready_i_4_n_1),
        .O(ap_done));
  LUT6 #(
    .INIT(64'hAAAAABBBABBBABBB)) 
    int_ap_ready_i_2
       (.I0(m_axis_TREADY),
        .I1(int_ap_ready_i_5_n_1),
        .I2(int_ap_ready_reg_4),
        .I3(m_axis_V_keep_V_1_ack_in),
        .I4(int_ap_ready_reg_3),
        .I5(m_axis_V_id_V_1_ack_in),
        .O(int_ap_ready_i_2_n_1));
  LUT6 #(
    .INIT(64'h2AFF2AFFFFFF2AFF)) 
    int_ap_ready_i_3
       (.I0(int_ap_ready_reg_1),
        .I1(m_axis_TREADY),
        .I2(m_axis_V_last_V_1_ack_in),
        .I3(Q[2]),
        .I4(int_ap_ready_reg_2),
        .I5(m_axis_V_user_V_1_ack_in),
        .O(int_ap_ready_i_3_n_1));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFF22F2)) 
    int_ap_ready_i_4
       (.I0(int_ap_ready_reg_3),
        .I1(m_axis_V_id_V_1_ack_in),
        .I2(int_ap_ready_reg_4),
        .I3(m_axis_V_keep_V_1_ack_in),
        .I4(int_ap_ready_i_6_n_1),
        .I5(int_ap_ready_i_7_n_1),
        .O(int_ap_ready_i_4_n_1));
  LUT6 #(
    .INIT(64'hFFFFF888F888F888)) 
    int_ap_ready_i_5
       (.I0(int_ap_ready_i_2_0),
        .I1(m_axis_V_data_V_1_ack_in),
        .I2(m_axis_V_user_V_1_ack_in),
        .I3(int_ap_ready_reg_2),
        .I4(m_axis_V_dest_V_1_ack_in),
        .I5(int_ap_ready_i_2_1),
        .O(int_ap_ready_i_5_n_1));
  LUT2 #(
    .INIT(4'h2)) 
    int_ap_ready_i_6
       (.I0(int_ap_ready_i_2_0),
        .I1(m_axis_V_data_V_1_ack_in),
        .O(int_ap_ready_i_6_n_1));
  LUT2 #(
    .INIT(4'h2)) 
    int_ap_ready_i_7
       (.I0(int_ap_ready_i_2_1),
        .I1(m_axis_V_dest_V_1_ack_in),
        .O(int_ap_ready_i_7_n_1));
  FDRE int_ap_ready_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(ap_done),
        .Q(int_ap_ready),
        .R(ap_rst_n_inv));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT4 #(
    .INIT(16'hFBF8)) 
    int_ap_start_i_1
       (.I0(int_auto_restart),
        .I1(ap_done),
        .I2(int_ap_start3_out),
        .I3(ap_start),
        .O(int_ap_start_i_1_n_1));
  LUT6 #(
    .INIT(64'h0000000000020000)) 
    int_ap_start_i_2
       (.I0(s_axi_CTRL_WDATA[0]),
        .I1(\waddr_reg_n_1_[3] ),
        .I2(\waddr_reg_n_1_[2] ),
        .I3(int_ap_start_i_3_n_1),
        .I4(s_axi_CTRL_WSTRB[0]),
        .I5(\waddr_reg_n_1_[4] ),
        .O(int_ap_start3_out));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'hFFFFFFBF)) 
    int_ap_start_i_3
       (.I0(\waddr_reg_n_1_[5] ),
        .I1(s_axi_CTRL_WVALID),
        .I2(\FSM_onehot_wstate_reg[2]_0 ),
        .I3(\waddr_reg_n_1_[0] ),
        .I4(\waddr_reg_n_1_[1] ),
        .O(int_ap_start_i_3_n_1));
  FDRE #(
    .INIT(1'b0)) 
    int_ap_start_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(int_ap_start_i_1_n_1),
        .Q(ap_start),
        .R(ap_rst_n_inv));
  LUT5 #(
    .INIT(32'hAAABAAA8)) 
    int_auto_restart_i_1
       (.I0(int_auto_restart),
        .I1(\int_ier[1]_i_2_n_1 ),
        .I2(\waddr_reg_n_1_[2] ),
        .I3(\waddr_reg_n_1_[3] ),
        .I4(s_axi_CTRL_WDATA[7]),
        .O(int_auto_restart_i_1_n_1));
  FDRE #(
    .INIT(1'b0)) 
    int_auto_restart_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(int_auto_restart_i_1_n_1),
        .Q(int_auto_restart),
        .R(ap_rst_n_inv));
  LUT5 #(
    .INIT(32'hFFEF0020)) 
    int_gie_i_1
       (.I0(s_axi_CTRL_WDATA[0]),
        .I1(\waddr_reg_n_1_[3] ),
        .I2(\waddr_reg_n_1_[2] ),
        .I3(\int_ier[1]_i_2_n_1 ),
        .I4(int_gie_reg_n_1),
        .O(int_gie_i_1_n_1));
  FDRE #(
    .INIT(1'b0)) 
    int_gie_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(int_gie_i_1_n_1),
        .Q(int_gie_reg_n_1),
        .R(ap_rst_n_inv));
  LUT5 #(
    .INIT(32'hFFEF0020)) 
    \int_ier[0]_i_1 
       (.I0(s_axi_CTRL_WDATA[0]),
        .I1(\waddr_reg_n_1_[2] ),
        .I2(\waddr_reg_n_1_[3] ),
        .I3(\int_ier[1]_i_2_n_1 ),
        .I4(\int_ier_reg_n_1_[0] ),
        .O(\int_ier[0]_i_1_n_1 ));
  LUT5 #(
    .INIT(32'hFFEF0020)) 
    \int_ier[1]_i_1 
       (.I0(s_axi_CTRL_WDATA[1]),
        .I1(\waddr_reg_n_1_[2] ),
        .I2(\waddr_reg_n_1_[3] ),
        .I3(\int_ier[1]_i_2_n_1 ),
        .I4(p_0_in),
        .O(\int_ier[1]_i_1_n_1 ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT3 #(
    .INIT(8'hFB)) 
    \int_ier[1]_i_2 
       (.I0(int_ap_start_i_3_n_1),
        .I1(s_axi_CTRL_WSTRB[0]),
        .I2(\waddr_reg_n_1_[4] ),
        .O(\int_ier[1]_i_2_n_1 ));
  FDRE #(
    .INIT(1'b0)) 
    \int_ier_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\int_ier[0]_i_1_n_1 ),
        .Q(\int_ier_reg_n_1_[0] ),
        .R(ap_rst_n_inv));
  FDRE #(
    .INIT(1'b0)) 
    \int_ier_reg[1] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\int_ier[1]_i_1_n_1 ),
        .Q(p_0_in),
        .R(ap_rst_n_inv));
  LUT5 #(
    .INIT(32'hF777F888)) 
    \int_isr[0]_i_1 
       (.I0(s_axi_CTRL_WDATA[0]),
        .I1(int_isr6_out),
        .I2(ap_done),
        .I3(\int_ier_reg_n_1_[0] ),
        .I4(\int_isr_reg_n_1_[0] ),
        .O(\int_isr[0]_i_1_n_1 ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT5 #(
    .INIT(32'h00000800)) 
    \int_isr[0]_i_2 
       (.I0(\waddr_reg_n_1_[3] ),
        .I1(\waddr_reg_n_1_[2] ),
        .I2(int_ap_start_i_3_n_1),
        .I3(s_axi_CTRL_WSTRB[0]),
        .I4(\waddr_reg_n_1_[4] ),
        .O(int_isr6_out));
  LUT5 #(
    .INIT(32'hF777F888)) 
    \int_isr[1]_i_1 
       (.I0(s_axi_CTRL_WDATA[1]),
        .I1(int_isr6_out),
        .I2(ap_done),
        .I3(p_0_in),
        .I4(p_1_in),
        .O(\int_isr[1]_i_1_n_1 ));
  FDRE #(
    .INIT(1'b0)) 
    \int_isr_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\int_isr[0]_i_1_n_1 ),
        .Q(\int_isr_reg_n_1_[0] ),
        .R(ap_rst_n_inv));
  FDRE #(
    .INIT(1'b0)) 
    \int_isr_reg[1] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\int_isr[1]_i_1_n_1 ),
        .Q(p_1_in),
        .R(ap_rst_n_inv));
  (* SOFT_HLUTNM = "soft_lutpair20" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_pixel_count[0]_i_1 
       (.I0(s_axi_CTRL_WDATA[0]),
        .I1(s_axi_CTRL_WSTRB[0]),
        .I2(\int_pixel_count_reg[31]_0 [0]),
        .O(\int_pixel_count[0]_i_1_n_1 ));
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_pixel_count[10]_i_1 
       (.I0(s_axi_CTRL_WDATA[10]),
        .I1(s_axi_CTRL_WSTRB[1]),
        .I2(\int_pixel_count_reg[31]_0 [10]),
        .O(\int_pixel_count[10]_i_1_n_1 ));
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_pixel_count[11]_i_1 
       (.I0(s_axi_CTRL_WDATA[11]),
        .I1(s_axi_CTRL_WSTRB[1]),
        .I2(\int_pixel_count_reg[31]_0 [11]),
        .O(\int_pixel_count[11]_i_1_n_1 ));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_pixel_count[12]_i_1 
       (.I0(s_axi_CTRL_WDATA[12]),
        .I1(s_axi_CTRL_WSTRB[1]),
        .I2(\int_pixel_count_reg[31]_0 [12]),
        .O(\int_pixel_count[12]_i_1_n_1 ));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_pixel_count[13]_i_1 
       (.I0(s_axi_CTRL_WDATA[13]),
        .I1(s_axi_CTRL_WSTRB[1]),
        .I2(\int_pixel_count_reg[31]_0 [13]),
        .O(\int_pixel_count[13]_i_1_n_1 ));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_pixel_count[14]_i_1 
       (.I0(s_axi_CTRL_WDATA[14]),
        .I1(s_axi_CTRL_WSTRB[1]),
        .I2(\int_pixel_count_reg[31]_0 [14]),
        .O(\int_pixel_count[14]_i_1_n_1 ));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_pixel_count[15]_i_1 
       (.I0(s_axi_CTRL_WDATA[15]),
        .I1(s_axi_CTRL_WSTRB[1]),
        .I2(\int_pixel_count_reg[31]_0 [15]),
        .O(\int_pixel_count[15]_i_1_n_1 ));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_pixel_count[16]_i_1 
       (.I0(s_axi_CTRL_WDATA[16]),
        .I1(s_axi_CTRL_WSTRB[2]),
        .I2(\int_pixel_count_reg[31]_0 [16]),
        .O(\int_pixel_count[16]_i_1_n_1 ));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_pixel_count[17]_i_1 
       (.I0(s_axi_CTRL_WDATA[17]),
        .I1(s_axi_CTRL_WSTRB[2]),
        .I2(\int_pixel_count_reg[31]_0 [17]),
        .O(\int_pixel_count[17]_i_1_n_1 ));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_pixel_count[18]_i_1 
       (.I0(s_axi_CTRL_WDATA[18]),
        .I1(s_axi_CTRL_WSTRB[2]),
        .I2(\int_pixel_count_reg[31]_0 [18]),
        .O(\int_pixel_count[18]_i_1_n_1 ));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_pixel_count[19]_i_1 
       (.I0(s_axi_CTRL_WDATA[19]),
        .I1(s_axi_CTRL_WSTRB[2]),
        .I2(\int_pixel_count_reg[31]_0 [19]),
        .O(\int_pixel_count[19]_i_1_n_1 ));
  (* SOFT_HLUTNM = "soft_lutpair20" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_pixel_count[1]_i_1 
       (.I0(s_axi_CTRL_WDATA[1]),
        .I1(s_axi_CTRL_WSTRB[0]),
        .I2(\int_pixel_count_reg[31]_0 [1]),
        .O(\int_pixel_count[1]_i_1_n_1 ));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_pixel_count[20]_i_1 
       (.I0(s_axi_CTRL_WDATA[20]),
        .I1(s_axi_CTRL_WSTRB[2]),
        .I2(\int_pixel_count_reg[31]_0 [20]),
        .O(\int_pixel_count[20]_i_1_n_1 ));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_pixel_count[21]_i_1 
       (.I0(s_axi_CTRL_WDATA[21]),
        .I1(s_axi_CTRL_WSTRB[2]),
        .I2(\int_pixel_count_reg[31]_0 [21]),
        .O(\int_pixel_count[21]_i_1_n_1 ));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_pixel_count[22]_i_1 
       (.I0(s_axi_CTRL_WDATA[22]),
        .I1(s_axi_CTRL_WSTRB[2]),
        .I2(\int_pixel_count_reg[31]_0 [22]),
        .O(\int_pixel_count[22]_i_1_n_1 ));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_pixel_count[23]_i_1 
       (.I0(s_axi_CTRL_WDATA[23]),
        .I1(s_axi_CTRL_WSTRB[2]),
        .I2(\int_pixel_count_reg[31]_0 [23]),
        .O(\int_pixel_count[23]_i_1_n_1 ));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_pixel_count[24]_i_1 
       (.I0(s_axi_CTRL_WDATA[24]),
        .I1(s_axi_CTRL_WSTRB[3]),
        .I2(\int_pixel_count_reg[31]_0 [24]),
        .O(\int_pixel_count[24]_i_1_n_1 ));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_pixel_count[25]_i_1 
       (.I0(s_axi_CTRL_WDATA[25]),
        .I1(s_axi_CTRL_WSTRB[3]),
        .I2(\int_pixel_count_reg[31]_0 [25]),
        .O(\int_pixel_count[25]_i_1_n_1 ));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_pixel_count[26]_i_1 
       (.I0(s_axi_CTRL_WDATA[26]),
        .I1(s_axi_CTRL_WSTRB[3]),
        .I2(\int_pixel_count_reg[31]_0 [26]),
        .O(\int_pixel_count[26]_i_1_n_1 ));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_pixel_count[27]_i_1 
       (.I0(s_axi_CTRL_WDATA[27]),
        .I1(s_axi_CTRL_WSTRB[3]),
        .I2(\int_pixel_count_reg[31]_0 [27]),
        .O(\int_pixel_count[27]_i_1_n_1 ));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_pixel_count[28]_i_1 
       (.I0(s_axi_CTRL_WDATA[28]),
        .I1(s_axi_CTRL_WSTRB[3]),
        .I2(\int_pixel_count_reg[31]_0 [28]),
        .O(\int_pixel_count[28]_i_1_n_1 ));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_pixel_count[29]_i_1 
       (.I0(s_axi_CTRL_WDATA[29]),
        .I1(s_axi_CTRL_WSTRB[3]),
        .I2(\int_pixel_count_reg[31]_0 [29]),
        .O(\int_pixel_count[29]_i_1_n_1 ));
  (* SOFT_HLUTNM = "soft_lutpair19" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_pixel_count[2]_i_1 
       (.I0(s_axi_CTRL_WDATA[2]),
        .I1(s_axi_CTRL_WSTRB[0]),
        .I2(\int_pixel_count_reg[31]_0 [2]),
        .O(\int_pixel_count[2]_i_1_n_1 ));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_pixel_count[30]_i_1 
       (.I0(s_axi_CTRL_WDATA[30]),
        .I1(s_axi_CTRL_WSTRB[3]),
        .I2(\int_pixel_count_reg[31]_0 [30]),
        .O(\int_pixel_count[30]_i_1_n_1 ));
  LUT3 #(
    .INIT(8'h01)) 
    \int_pixel_count[31]_i_1 
       (.I0(\waddr_reg_n_1_[2] ),
        .I1(\waddr_reg_n_1_[3] ),
        .I2(\int_pixel_count[31]_i_3_n_1 ),
        .O(\int_pixel_count[31]_i_1_n_1 ));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_pixel_count[31]_i_2 
       (.I0(s_axi_CTRL_WDATA[31]),
        .I1(s_axi_CTRL_WSTRB[3]),
        .I2(\int_pixel_count_reg[31]_0 [31]),
        .O(\int_pixel_count[31]_i_2_n_1 ));
  LUT6 #(
    .INIT(64'hFFFFEFFFFFFFFFFF)) 
    \int_pixel_count[31]_i_3 
       (.I0(\waddr_reg_n_1_[1] ),
        .I1(\waddr_reg_n_1_[0] ),
        .I2(\FSM_onehot_wstate_reg[2]_0 ),
        .I3(s_axi_CTRL_WVALID),
        .I4(\waddr_reg_n_1_[5] ),
        .I5(\waddr_reg_n_1_[4] ),
        .O(\int_pixel_count[31]_i_3_n_1 ));
  (* SOFT_HLUTNM = "soft_lutpair19" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_pixel_count[3]_i_1 
       (.I0(s_axi_CTRL_WDATA[3]),
        .I1(s_axi_CTRL_WSTRB[0]),
        .I2(\int_pixel_count_reg[31]_0 [3]),
        .O(\int_pixel_count[3]_i_1_n_1 ));
  (* SOFT_HLUTNM = "soft_lutpair18" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_pixel_count[4]_i_1 
       (.I0(s_axi_CTRL_WDATA[4]),
        .I1(s_axi_CTRL_WSTRB[0]),
        .I2(\int_pixel_count_reg[31]_0 [4]),
        .O(\int_pixel_count[4]_i_1_n_1 ));
  (* SOFT_HLUTNM = "soft_lutpair18" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_pixel_count[5]_i_1 
       (.I0(s_axi_CTRL_WDATA[5]),
        .I1(s_axi_CTRL_WSTRB[0]),
        .I2(\int_pixel_count_reg[31]_0 [5]),
        .O(\int_pixel_count[5]_i_1_n_1 ));
  (* SOFT_HLUTNM = "soft_lutpair17" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_pixel_count[6]_i_1 
       (.I0(s_axi_CTRL_WDATA[6]),
        .I1(s_axi_CTRL_WSTRB[0]),
        .I2(\int_pixel_count_reg[31]_0 [6]),
        .O(\int_pixel_count[6]_i_1_n_1 ));
  (* SOFT_HLUTNM = "soft_lutpair17" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_pixel_count[7]_i_1 
       (.I0(s_axi_CTRL_WDATA[7]),
        .I1(s_axi_CTRL_WSTRB[0]),
        .I2(\int_pixel_count_reg[31]_0 [7]),
        .O(\int_pixel_count[7]_i_1_n_1 ));
  (* SOFT_HLUTNM = "soft_lutpair16" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_pixel_count[8]_i_1 
       (.I0(s_axi_CTRL_WDATA[8]),
        .I1(s_axi_CTRL_WSTRB[1]),
        .I2(\int_pixel_count_reg[31]_0 [8]),
        .O(\int_pixel_count[8]_i_1_n_1 ));
  (* SOFT_HLUTNM = "soft_lutpair16" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_pixel_count[9]_i_1 
       (.I0(s_axi_CTRL_WDATA[9]),
        .I1(s_axi_CTRL_WSTRB[1]),
        .I2(\int_pixel_count_reg[31]_0 [9]),
        .O(\int_pixel_count[9]_i_1_n_1 ));
  FDRE #(
    .INIT(1'b0)) 
    \int_pixel_count_reg[0] 
       (.C(ap_clk),
        .CE(\int_pixel_count[31]_i_1_n_1 ),
        .D(\int_pixel_count[0]_i_1_n_1 ),
        .Q(\int_pixel_count_reg[31]_0 [0]),
        .R(ap_rst_n_inv));
  FDRE #(
    .INIT(1'b0)) 
    \int_pixel_count_reg[10] 
       (.C(ap_clk),
        .CE(\int_pixel_count[31]_i_1_n_1 ),
        .D(\int_pixel_count[10]_i_1_n_1 ),
        .Q(\int_pixel_count_reg[31]_0 [10]),
        .R(ap_rst_n_inv));
  FDRE #(
    .INIT(1'b0)) 
    \int_pixel_count_reg[11] 
       (.C(ap_clk),
        .CE(\int_pixel_count[31]_i_1_n_1 ),
        .D(\int_pixel_count[11]_i_1_n_1 ),
        .Q(\int_pixel_count_reg[31]_0 [11]),
        .R(ap_rst_n_inv));
  FDRE #(
    .INIT(1'b0)) 
    \int_pixel_count_reg[12] 
       (.C(ap_clk),
        .CE(\int_pixel_count[31]_i_1_n_1 ),
        .D(\int_pixel_count[12]_i_1_n_1 ),
        .Q(\int_pixel_count_reg[31]_0 [12]),
        .R(ap_rst_n_inv));
  FDRE #(
    .INIT(1'b0)) 
    \int_pixel_count_reg[13] 
       (.C(ap_clk),
        .CE(\int_pixel_count[31]_i_1_n_1 ),
        .D(\int_pixel_count[13]_i_1_n_1 ),
        .Q(\int_pixel_count_reg[31]_0 [13]),
        .R(ap_rst_n_inv));
  FDRE #(
    .INIT(1'b0)) 
    \int_pixel_count_reg[14] 
       (.C(ap_clk),
        .CE(\int_pixel_count[31]_i_1_n_1 ),
        .D(\int_pixel_count[14]_i_1_n_1 ),
        .Q(\int_pixel_count_reg[31]_0 [14]),
        .R(ap_rst_n_inv));
  FDRE #(
    .INIT(1'b0)) 
    \int_pixel_count_reg[15] 
       (.C(ap_clk),
        .CE(\int_pixel_count[31]_i_1_n_1 ),
        .D(\int_pixel_count[15]_i_1_n_1 ),
        .Q(\int_pixel_count_reg[31]_0 [15]),
        .R(ap_rst_n_inv));
  FDRE #(
    .INIT(1'b0)) 
    \int_pixel_count_reg[16] 
       (.C(ap_clk),
        .CE(\int_pixel_count[31]_i_1_n_1 ),
        .D(\int_pixel_count[16]_i_1_n_1 ),
        .Q(\int_pixel_count_reg[31]_0 [16]),
        .R(ap_rst_n_inv));
  FDRE #(
    .INIT(1'b0)) 
    \int_pixel_count_reg[17] 
       (.C(ap_clk),
        .CE(\int_pixel_count[31]_i_1_n_1 ),
        .D(\int_pixel_count[17]_i_1_n_1 ),
        .Q(\int_pixel_count_reg[31]_0 [17]),
        .R(ap_rst_n_inv));
  FDRE #(
    .INIT(1'b0)) 
    \int_pixel_count_reg[18] 
       (.C(ap_clk),
        .CE(\int_pixel_count[31]_i_1_n_1 ),
        .D(\int_pixel_count[18]_i_1_n_1 ),
        .Q(\int_pixel_count_reg[31]_0 [18]),
        .R(ap_rst_n_inv));
  FDRE #(
    .INIT(1'b0)) 
    \int_pixel_count_reg[19] 
       (.C(ap_clk),
        .CE(\int_pixel_count[31]_i_1_n_1 ),
        .D(\int_pixel_count[19]_i_1_n_1 ),
        .Q(\int_pixel_count_reg[31]_0 [19]),
        .R(ap_rst_n_inv));
  FDRE #(
    .INIT(1'b0)) 
    \int_pixel_count_reg[1] 
       (.C(ap_clk),
        .CE(\int_pixel_count[31]_i_1_n_1 ),
        .D(\int_pixel_count[1]_i_1_n_1 ),
        .Q(\int_pixel_count_reg[31]_0 [1]),
        .R(ap_rst_n_inv));
  FDRE #(
    .INIT(1'b0)) 
    \int_pixel_count_reg[20] 
       (.C(ap_clk),
        .CE(\int_pixel_count[31]_i_1_n_1 ),
        .D(\int_pixel_count[20]_i_1_n_1 ),
        .Q(\int_pixel_count_reg[31]_0 [20]),
        .R(ap_rst_n_inv));
  FDRE #(
    .INIT(1'b0)) 
    \int_pixel_count_reg[21] 
       (.C(ap_clk),
        .CE(\int_pixel_count[31]_i_1_n_1 ),
        .D(\int_pixel_count[21]_i_1_n_1 ),
        .Q(\int_pixel_count_reg[31]_0 [21]),
        .R(ap_rst_n_inv));
  FDRE #(
    .INIT(1'b0)) 
    \int_pixel_count_reg[22] 
       (.C(ap_clk),
        .CE(\int_pixel_count[31]_i_1_n_1 ),
        .D(\int_pixel_count[22]_i_1_n_1 ),
        .Q(\int_pixel_count_reg[31]_0 [22]),
        .R(ap_rst_n_inv));
  FDRE #(
    .INIT(1'b0)) 
    \int_pixel_count_reg[23] 
       (.C(ap_clk),
        .CE(\int_pixel_count[31]_i_1_n_1 ),
        .D(\int_pixel_count[23]_i_1_n_1 ),
        .Q(\int_pixel_count_reg[31]_0 [23]),
        .R(ap_rst_n_inv));
  FDRE #(
    .INIT(1'b0)) 
    \int_pixel_count_reg[24] 
       (.C(ap_clk),
        .CE(\int_pixel_count[31]_i_1_n_1 ),
        .D(\int_pixel_count[24]_i_1_n_1 ),
        .Q(\int_pixel_count_reg[31]_0 [24]),
        .R(ap_rst_n_inv));
  FDRE #(
    .INIT(1'b0)) 
    \int_pixel_count_reg[25] 
       (.C(ap_clk),
        .CE(\int_pixel_count[31]_i_1_n_1 ),
        .D(\int_pixel_count[25]_i_1_n_1 ),
        .Q(\int_pixel_count_reg[31]_0 [25]),
        .R(ap_rst_n_inv));
  FDRE #(
    .INIT(1'b0)) 
    \int_pixel_count_reg[26] 
       (.C(ap_clk),
        .CE(\int_pixel_count[31]_i_1_n_1 ),
        .D(\int_pixel_count[26]_i_1_n_1 ),
        .Q(\int_pixel_count_reg[31]_0 [26]),
        .R(ap_rst_n_inv));
  FDRE #(
    .INIT(1'b0)) 
    \int_pixel_count_reg[27] 
       (.C(ap_clk),
        .CE(\int_pixel_count[31]_i_1_n_1 ),
        .D(\int_pixel_count[27]_i_1_n_1 ),
        .Q(\int_pixel_count_reg[31]_0 [27]),
        .R(ap_rst_n_inv));
  FDRE #(
    .INIT(1'b0)) 
    \int_pixel_count_reg[28] 
       (.C(ap_clk),
        .CE(\int_pixel_count[31]_i_1_n_1 ),
        .D(\int_pixel_count[28]_i_1_n_1 ),
        .Q(\int_pixel_count_reg[31]_0 [28]),
        .R(ap_rst_n_inv));
  FDRE #(
    .INIT(1'b0)) 
    \int_pixel_count_reg[29] 
       (.C(ap_clk),
        .CE(\int_pixel_count[31]_i_1_n_1 ),
        .D(\int_pixel_count[29]_i_1_n_1 ),
        .Q(\int_pixel_count_reg[31]_0 [29]),
        .R(ap_rst_n_inv));
  FDRE #(
    .INIT(1'b0)) 
    \int_pixel_count_reg[2] 
       (.C(ap_clk),
        .CE(\int_pixel_count[31]_i_1_n_1 ),
        .D(\int_pixel_count[2]_i_1_n_1 ),
        .Q(\int_pixel_count_reg[31]_0 [2]),
        .R(ap_rst_n_inv));
  FDRE #(
    .INIT(1'b0)) 
    \int_pixel_count_reg[30] 
       (.C(ap_clk),
        .CE(\int_pixel_count[31]_i_1_n_1 ),
        .D(\int_pixel_count[30]_i_1_n_1 ),
        .Q(\int_pixel_count_reg[31]_0 [30]),
        .R(ap_rst_n_inv));
  FDRE #(
    .INIT(1'b0)) 
    \int_pixel_count_reg[31] 
       (.C(ap_clk),
        .CE(\int_pixel_count[31]_i_1_n_1 ),
        .D(\int_pixel_count[31]_i_2_n_1 ),
        .Q(\int_pixel_count_reg[31]_0 [31]),
        .R(ap_rst_n_inv));
  FDRE #(
    .INIT(1'b0)) 
    \int_pixel_count_reg[3] 
       (.C(ap_clk),
        .CE(\int_pixel_count[31]_i_1_n_1 ),
        .D(\int_pixel_count[3]_i_1_n_1 ),
        .Q(\int_pixel_count_reg[31]_0 [3]),
        .R(ap_rst_n_inv));
  FDRE #(
    .INIT(1'b0)) 
    \int_pixel_count_reg[4] 
       (.C(ap_clk),
        .CE(\int_pixel_count[31]_i_1_n_1 ),
        .D(\int_pixel_count[4]_i_1_n_1 ),
        .Q(\int_pixel_count_reg[31]_0 [4]),
        .R(ap_rst_n_inv));
  FDRE #(
    .INIT(1'b0)) 
    \int_pixel_count_reg[5] 
       (.C(ap_clk),
        .CE(\int_pixel_count[31]_i_1_n_1 ),
        .D(\int_pixel_count[5]_i_1_n_1 ),
        .Q(\int_pixel_count_reg[31]_0 [5]),
        .R(ap_rst_n_inv));
  FDRE #(
    .INIT(1'b0)) 
    \int_pixel_count_reg[6] 
       (.C(ap_clk),
        .CE(\int_pixel_count[31]_i_1_n_1 ),
        .D(\int_pixel_count[6]_i_1_n_1 ),
        .Q(\int_pixel_count_reg[31]_0 [6]),
        .R(ap_rst_n_inv));
  FDRE #(
    .INIT(1'b0)) 
    \int_pixel_count_reg[7] 
       (.C(ap_clk),
        .CE(\int_pixel_count[31]_i_1_n_1 ),
        .D(\int_pixel_count[7]_i_1_n_1 ),
        .Q(\int_pixel_count_reg[31]_0 [7]),
        .R(ap_rst_n_inv));
  FDRE #(
    .INIT(1'b0)) 
    \int_pixel_count_reg[8] 
       (.C(ap_clk),
        .CE(\int_pixel_count[31]_i_1_n_1 ),
        .D(\int_pixel_count[8]_i_1_n_1 ),
        .Q(\int_pixel_count_reg[31]_0 [8]),
        .R(ap_rst_n_inv));
  FDRE #(
    .INIT(1'b0)) 
    \int_pixel_count_reg[9] 
       (.C(ap_clk),
        .CE(\int_pixel_count[31]_i_1_n_1 ),
        .D(\int_pixel_count[9]_i_1_n_1 ),
        .Q(\int_pixel_count_reg[31]_0 [9]),
        .R(ap_rst_n_inv));
  (* SOFT_HLUTNM = "soft_lutpair24" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_threshold_V[0]_i_1 
       (.I0(s_axi_CTRL_WDATA[0]),
        .I1(s_axi_CTRL_WSTRB[0]),
        .I2(\int_threshold_V_reg[7]_0 [0]),
        .O(\int_threshold_V[0]_i_1_n_1 ));
  (* SOFT_HLUTNM = "soft_lutpair24" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_threshold_V[1]_i_1 
       (.I0(s_axi_CTRL_WDATA[1]),
        .I1(s_axi_CTRL_WSTRB[0]),
        .I2(\int_threshold_V_reg[7]_0 [1]),
        .O(\int_threshold_V[1]_i_1_n_1 ));
  (* SOFT_HLUTNM = "soft_lutpair23" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_threshold_V[2]_i_1 
       (.I0(s_axi_CTRL_WDATA[2]),
        .I1(s_axi_CTRL_WSTRB[0]),
        .I2(\int_threshold_V_reg[7]_0 [2]),
        .O(\int_threshold_V[2]_i_1_n_1 ));
  (* SOFT_HLUTNM = "soft_lutpair23" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_threshold_V[3]_i_1 
       (.I0(s_axi_CTRL_WDATA[3]),
        .I1(s_axi_CTRL_WSTRB[0]),
        .I2(\int_threshold_V_reg[7]_0 [3]),
        .O(\int_threshold_V[3]_i_1_n_1 ));
  (* SOFT_HLUTNM = "soft_lutpair22" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_threshold_V[4]_i_1 
       (.I0(s_axi_CTRL_WDATA[4]),
        .I1(s_axi_CTRL_WSTRB[0]),
        .I2(\int_threshold_V_reg[7]_0 [4]),
        .O(\int_threshold_V[4]_i_1_n_1 ));
  (* SOFT_HLUTNM = "soft_lutpair22" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_threshold_V[5]_i_1 
       (.I0(s_axi_CTRL_WDATA[5]),
        .I1(s_axi_CTRL_WSTRB[0]),
        .I2(\int_threshold_V_reg[7]_0 [5]),
        .O(\int_threshold_V[5]_i_1_n_1 ));
  (* SOFT_HLUTNM = "soft_lutpair21" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_threshold_V[6]_i_1 
       (.I0(s_axi_CTRL_WDATA[6]),
        .I1(s_axi_CTRL_WSTRB[0]),
        .I2(\int_threshold_V_reg[7]_0 [6]),
        .O(\int_threshold_V[6]_i_1_n_1 ));
  LUT3 #(
    .INIT(8'h04)) 
    \int_threshold_V[7]_i_1 
       (.I0(\waddr_reg_n_1_[2] ),
        .I1(\waddr_reg_n_1_[3] ),
        .I2(\int_pixel_count[31]_i_3_n_1 ),
        .O(\int_threshold_V[7]_i_1_n_1 ));
  (* SOFT_HLUTNM = "soft_lutpair21" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_threshold_V[7]_i_2 
       (.I0(s_axi_CTRL_WDATA[7]),
        .I1(s_axi_CTRL_WSTRB[0]),
        .I2(\int_threshold_V_reg[7]_0 [7]),
        .O(\int_threshold_V[7]_i_2_n_1 ));
  FDRE #(
    .INIT(1'b0)) 
    \int_threshold_V_reg[0] 
       (.C(ap_clk),
        .CE(\int_threshold_V[7]_i_1_n_1 ),
        .D(\int_threshold_V[0]_i_1_n_1 ),
        .Q(\int_threshold_V_reg[7]_0 [0]),
        .R(ap_rst_n_inv));
  FDRE #(
    .INIT(1'b0)) 
    \int_threshold_V_reg[1] 
       (.C(ap_clk),
        .CE(\int_threshold_V[7]_i_1_n_1 ),
        .D(\int_threshold_V[1]_i_1_n_1 ),
        .Q(\int_threshold_V_reg[7]_0 [1]),
        .R(ap_rst_n_inv));
  FDRE #(
    .INIT(1'b0)) 
    \int_threshold_V_reg[2] 
       (.C(ap_clk),
        .CE(\int_threshold_V[7]_i_1_n_1 ),
        .D(\int_threshold_V[2]_i_1_n_1 ),
        .Q(\int_threshold_V_reg[7]_0 [2]),
        .R(ap_rst_n_inv));
  FDRE #(
    .INIT(1'b0)) 
    \int_threshold_V_reg[3] 
       (.C(ap_clk),
        .CE(\int_threshold_V[7]_i_1_n_1 ),
        .D(\int_threshold_V[3]_i_1_n_1 ),
        .Q(\int_threshold_V_reg[7]_0 [3]),
        .R(ap_rst_n_inv));
  FDRE #(
    .INIT(1'b0)) 
    \int_threshold_V_reg[4] 
       (.C(ap_clk),
        .CE(\int_threshold_V[7]_i_1_n_1 ),
        .D(\int_threshold_V[4]_i_1_n_1 ),
        .Q(\int_threshold_V_reg[7]_0 [4]),
        .R(ap_rst_n_inv));
  FDRE #(
    .INIT(1'b0)) 
    \int_threshold_V_reg[5] 
       (.C(ap_clk),
        .CE(\int_threshold_V[7]_i_1_n_1 ),
        .D(\int_threshold_V[5]_i_1_n_1 ),
        .Q(\int_threshold_V_reg[7]_0 [5]),
        .R(ap_rst_n_inv));
  FDRE #(
    .INIT(1'b0)) 
    \int_threshold_V_reg[6] 
       (.C(ap_clk),
        .CE(\int_threshold_V[7]_i_1_n_1 ),
        .D(\int_threshold_V[6]_i_1_n_1 ),
        .Q(\int_threshold_V_reg[7]_0 [6]),
        .R(ap_rst_n_inv));
  FDRE #(
    .INIT(1'b0)) 
    \int_threshold_V_reg[7] 
       (.C(ap_clk),
        .CE(\int_threshold_V[7]_i_1_n_1 ),
        .D(\int_threshold_V[7]_i_2_n_1 ),
        .Q(\int_threshold_V_reg[7]_0 [7]),
        .R(ap_rst_n_inv));
  LUT5 #(
    .INIT(32'hFFFB0008)) 
    \int_threshold_enable[0]_i_1 
       (.I0(s_axi_CTRL_WDATA[0]),
        .I1(s_axi_CTRL_WSTRB[0]),
        .I2(\int_threshold_enable[0]_i_2_n_1 ),
        .I3(\int_threshold_enable[0]_i_3_n_1 ),
        .I4(threshold_enable),
        .O(\int_threshold_enable[0]_i_1_n_1 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'hEFFF)) 
    \int_threshold_enable[0]_i_2 
       (.I0(\waddr_reg_n_1_[1] ),
        .I1(\waddr_reg_n_1_[0] ),
        .I2(\FSM_onehot_wstate_reg[2]_0 ),
        .I3(s_axi_CTRL_WVALID),
        .O(\int_threshold_enable[0]_i_2_n_1 ));
  LUT4 #(
    .INIT(16'hFFEF)) 
    \int_threshold_enable[0]_i_3 
       (.I0(\waddr_reg_n_1_[2] ),
        .I1(\waddr_reg_n_1_[3] ),
        .I2(\waddr_reg_n_1_[5] ),
        .I3(\waddr_reg_n_1_[4] ),
        .O(\int_threshold_enable[0]_i_3_n_1 ));
  FDRE #(
    .INIT(1'b0)) 
    \int_threshold_enable_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\int_threshold_enable[0]_i_1_n_1 ),
        .Q(threshold_enable),
        .R(ap_rst_n_inv));
  LUT3 #(
    .INIT(8'hA8)) 
    interrupt_INST_0
       (.I0(int_gie_reg_n_1),
        .I1(p_1_in),
        .I2(\int_isr_reg_n_1_[0] ),
        .O(interrupt));
  (* SOFT_HLUTNM = "soft_lutpair25" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \pixel_count_read_reg_227[31]_i_1 
       (.I0(Q[0]),
        .I1(ap_start),
        .O(E));
  LUT5 #(
    .INIT(32'h0F00ACAC)) 
    \rdata[0]_i_2 
       (.I0(threshold_enable),
        .I1(\int_pixel_count_reg[31]_0 [0]),
        .I2(\rdata[7]_i_4_n_1 ),
        .I3(\int_threshold_V_reg[7]_0 [0]),
        .I4(\rdata[7]_i_3_n_1 ),
        .O(\rdata[0]_i_2_n_1 ));
  LUT6 #(
    .INIT(64'hCCFFF0AACC00F0AA)) 
    \rdata[0]_i_3 
       (.I0(ap_start),
        .I1(\int_isr_reg_n_1_[0] ),
        .I2(int_gie_reg_n_1),
        .I3(\rdata[7]_i_3_n_1 ),
        .I4(\rdata[7]_i_4_n_1 ),
        .I5(\int_ier_reg_n_1_[0] ),
        .O(\rdata[0]_i_3_n_1 ));
  LUT6 #(
    .INIT(64'h505F505C5050505C)) 
    \rdata[1]_i_1 
       (.I0(\rdata[1]_i_2_n_1 ),
        .I1(\int_pixel_count_reg[31]_0 [1]),
        .I2(\rdata[7]_i_2_n_1 ),
        .I3(\rdata[7]_i_4_n_1 ),
        .I4(\rdata[7]_i_3_n_1 ),
        .I5(\int_threshold_V_reg[7]_0 [1]),
        .O(rdata[1]));
  LUT5 #(
    .INIT(32'h3F113FDD)) 
    \rdata[1]_i_2 
       (.I0(int_ap_done),
        .I1(\rdata[7]_i_4_n_1 ),
        .I2(p_1_in),
        .I3(\rdata[7]_i_3_n_1 ),
        .I4(p_0_in),
        .O(\rdata[1]_i_2_n_1 ));
  LUT6 #(
    .INIT(64'h000000000A0ACFC0)) 
    \rdata[2]_i_1 
       (.I0(\int_threshold_V_reg[7]_0 [2]),
        .I1(int_ap_idle),
        .I2(\rdata[7]_i_2_n_1 ),
        .I3(\int_pixel_count_reg[31]_0 [2]),
        .I4(\rdata[7]_i_3_n_1 ),
        .I5(\rdata[7]_i_4_n_1 ),
        .O(rdata[2]));
  LUT3 #(
    .INIT(8'h80)) 
    \rdata[31]_i_1 
       (.I0(\rdata[31]_i_3_n_1 ),
        .I1(\FSM_onehot_rstate_reg[1]_0 ),
        .I2(s_axi_CTRL_ARVALID),
        .O(\rdata[31]_i_1_n_1 ));
  LUT2 #(
    .INIT(4'h8)) 
    \rdata[31]_i_2 
       (.I0(s_axi_CTRL_ARVALID),
        .I1(\FSM_onehot_rstate_reg[1]_0 ),
        .O(ar_hs));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFEFFFF)) 
    \rdata[31]_i_3 
       (.I0(s_axi_CTRL_ARADDR[0]),
        .I1(s_axi_CTRL_ARADDR[1]),
        .I2(s_axi_CTRL_ARADDR[5]),
        .I3(s_axi_CTRL_ARADDR[2]),
        .I4(s_axi_CTRL_ARADDR[4]),
        .I5(s_axi_CTRL_ARADDR[3]),
        .O(\rdata[31]_i_3_n_1 ));
  LUT6 #(
    .INIT(64'h000000000A0ACFC0)) 
    \rdata[3]_i_1 
       (.I0(\int_threshold_V_reg[7]_0 [3]),
        .I1(int_ap_ready),
        .I2(\rdata[7]_i_2_n_1 ),
        .I3(\int_pixel_count_reg[31]_0 [3]),
        .I4(\rdata[7]_i_3_n_1 ),
        .I5(\rdata[7]_i_4_n_1 ),
        .O(rdata[3]));
  LUT4 #(
    .INIT(16'h4F44)) 
    \rdata[4]_i_1 
       (.I0(\rdata[31]_i_3_n_1 ),
        .I1(\int_pixel_count_reg[31]_0 [4]),
        .I2(\rdata[6]_i_2_n_1 ),
        .I3(\int_threshold_V_reg[7]_0 [4]),
        .O(rdata[4]));
  LUT4 #(
    .INIT(16'h4F44)) 
    \rdata[5]_i_1 
       (.I0(\rdata[31]_i_3_n_1 ),
        .I1(\int_pixel_count_reg[31]_0 [5]),
        .I2(\rdata[6]_i_2_n_1 ),
        .I3(\int_threshold_V_reg[7]_0 [5]),
        .O(rdata[5]));
  LUT4 #(
    .INIT(16'h4F44)) 
    \rdata[6]_i_1 
       (.I0(\rdata[31]_i_3_n_1 ),
        .I1(\int_pixel_count_reg[31]_0 [6]),
        .I2(\rdata[6]_i_2_n_1 ),
        .I3(\int_threshold_V_reg[7]_0 [6]),
        .O(rdata[6]));
  LUT6 #(
    .INIT(64'hFFFEFFFFFFFFFFFF)) 
    \rdata[6]_i_2 
       (.I0(s_axi_CTRL_ARADDR[1]),
        .I1(s_axi_CTRL_ARADDR[0]),
        .I2(s_axi_CTRL_ARADDR[2]),
        .I3(s_axi_CTRL_ARADDR[5]),
        .I4(s_axi_CTRL_ARADDR[3]),
        .I5(s_axi_CTRL_ARADDR[4]),
        .O(\rdata[6]_i_2_n_1 ));
  LUT6 #(
    .INIT(64'h000000000A0ACFC0)) 
    \rdata[7]_i_1 
       (.I0(\int_threshold_V_reg[7]_0 [7]),
        .I1(int_auto_restart),
        .I2(\rdata[7]_i_2_n_1 ),
        .I3(\int_pixel_count_reg[31]_0 [7]),
        .I4(\rdata[7]_i_3_n_1 ),
        .I5(\rdata[7]_i_4_n_1 ),
        .O(rdata[7]));
  LUT4 #(
    .INIT(16'h0001)) 
    \rdata[7]_i_2 
       (.I0(s_axi_CTRL_ARADDR[1]),
        .I1(s_axi_CTRL_ARADDR[0]),
        .I2(s_axi_CTRL_ARADDR[4]),
        .I3(s_axi_CTRL_ARADDR[5]),
        .O(\rdata[7]_i_2_n_1 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFE8)) 
    \rdata[7]_i_3 
       (.I0(s_axi_CTRL_ARADDR[4]),
        .I1(s_axi_CTRL_ARADDR[3]),
        .I2(s_axi_CTRL_ARADDR[5]),
        .I3(s_axi_CTRL_ARADDR[2]),
        .I4(s_axi_CTRL_ARADDR[0]),
        .I5(s_axi_CTRL_ARADDR[1]),
        .O(\rdata[7]_i_3_n_1 ));
  LUT6 #(
    .INIT(64'hFFFEFFFFFFFEFEFE)) 
    \rdata[7]_i_4 
       (.I0(s_axi_CTRL_ARADDR[0]),
        .I1(s_axi_CTRL_ARADDR[1]),
        .I2(s_axi_CTRL_ARADDR[5]),
        .I3(s_axi_CTRL_ARADDR[2]),
        .I4(s_axi_CTRL_ARADDR[4]),
        .I5(s_axi_CTRL_ARADDR[3]),
        .O(\rdata[7]_i_4_n_1 ));
  FDRE \rdata_reg[0] 
       (.C(ap_clk),
        .CE(ar_hs),
        .D(rdata[0]),
        .Q(s_axi_CTRL_RDATA[0]),
        .R(1'b0));
  MUXF7 \rdata_reg[0]_i_1 
       (.I0(\rdata[0]_i_2_n_1 ),
        .I1(\rdata[0]_i_3_n_1 ),
        .O(rdata[0]),
        .S(\rdata[7]_i_2_n_1 ));
  FDRE \rdata_reg[10] 
       (.C(ap_clk),
        .CE(ar_hs),
        .D(\int_pixel_count_reg[31]_0 [10]),
        .Q(s_axi_CTRL_RDATA[10]),
        .R(\rdata[31]_i_1_n_1 ));
  FDRE \rdata_reg[11] 
       (.C(ap_clk),
        .CE(ar_hs),
        .D(\int_pixel_count_reg[31]_0 [11]),
        .Q(s_axi_CTRL_RDATA[11]),
        .R(\rdata[31]_i_1_n_1 ));
  FDRE \rdata_reg[12] 
       (.C(ap_clk),
        .CE(ar_hs),
        .D(\int_pixel_count_reg[31]_0 [12]),
        .Q(s_axi_CTRL_RDATA[12]),
        .R(\rdata[31]_i_1_n_1 ));
  FDRE \rdata_reg[13] 
       (.C(ap_clk),
        .CE(ar_hs),
        .D(\int_pixel_count_reg[31]_0 [13]),
        .Q(s_axi_CTRL_RDATA[13]),
        .R(\rdata[31]_i_1_n_1 ));
  FDRE \rdata_reg[14] 
       (.C(ap_clk),
        .CE(ar_hs),
        .D(\int_pixel_count_reg[31]_0 [14]),
        .Q(s_axi_CTRL_RDATA[14]),
        .R(\rdata[31]_i_1_n_1 ));
  FDRE \rdata_reg[15] 
       (.C(ap_clk),
        .CE(ar_hs),
        .D(\int_pixel_count_reg[31]_0 [15]),
        .Q(s_axi_CTRL_RDATA[15]),
        .R(\rdata[31]_i_1_n_1 ));
  FDRE \rdata_reg[16] 
       (.C(ap_clk),
        .CE(ar_hs),
        .D(\int_pixel_count_reg[31]_0 [16]),
        .Q(s_axi_CTRL_RDATA[16]),
        .R(\rdata[31]_i_1_n_1 ));
  FDRE \rdata_reg[17] 
       (.C(ap_clk),
        .CE(ar_hs),
        .D(\int_pixel_count_reg[31]_0 [17]),
        .Q(s_axi_CTRL_RDATA[17]),
        .R(\rdata[31]_i_1_n_1 ));
  FDRE \rdata_reg[18] 
       (.C(ap_clk),
        .CE(ar_hs),
        .D(\int_pixel_count_reg[31]_0 [18]),
        .Q(s_axi_CTRL_RDATA[18]),
        .R(\rdata[31]_i_1_n_1 ));
  FDRE \rdata_reg[19] 
       (.C(ap_clk),
        .CE(ar_hs),
        .D(\int_pixel_count_reg[31]_0 [19]),
        .Q(s_axi_CTRL_RDATA[19]),
        .R(\rdata[31]_i_1_n_1 ));
  FDRE \rdata_reg[1] 
       (.C(ap_clk),
        .CE(ar_hs),
        .D(rdata[1]),
        .Q(s_axi_CTRL_RDATA[1]),
        .R(1'b0));
  FDRE \rdata_reg[20] 
       (.C(ap_clk),
        .CE(ar_hs),
        .D(\int_pixel_count_reg[31]_0 [20]),
        .Q(s_axi_CTRL_RDATA[20]),
        .R(\rdata[31]_i_1_n_1 ));
  FDRE \rdata_reg[21] 
       (.C(ap_clk),
        .CE(ar_hs),
        .D(\int_pixel_count_reg[31]_0 [21]),
        .Q(s_axi_CTRL_RDATA[21]),
        .R(\rdata[31]_i_1_n_1 ));
  FDRE \rdata_reg[22] 
       (.C(ap_clk),
        .CE(ar_hs),
        .D(\int_pixel_count_reg[31]_0 [22]),
        .Q(s_axi_CTRL_RDATA[22]),
        .R(\rdata[31]_i_1_n_1 ));
  FDRE \rdata_reg[23] 
       (.C(ap_clk),
        .CE(ar_hs),
        .D(\int_pixel_count_reg[31]_0 [23]),
        .Q(s_axi_CTRL_RDATA[23]),
        .R(\rdata[31]_i_1_n_1 ));
  FDRE \rdata_reg[24] 
       (.C(ap_clk),
        .CE(ar_hs),
        .D(\int_pixel_count_reg[31]_0 [24]),
        .Q(s_axi_CTRL_RDATA[24]),
        .R(\rdata[31]_i_1_n_1 ));
  FDRE \rdata_reg[25] 
       (.C(ap_clk),
        .CE(ar_hs),
        .D(\int_pixel_count_reg[31]_0 [25]),
        .Q(s_axi_CTRL_RDATA[25]),
        .R(\rdata[31]_i_1_n_1 ));
  FDRE \rdata_reg[26] 
       (.C(ap_clk),
        .CE(ar_hs),
        .D(\int_pixel_count_reg[31]_0 [26]),
        .Q(s_axi_CTRL_RDATA[26]),
        .R(\rdata[31]_i_1_n_1 ));
  FDRE \rdata_reg[27] 
       (.C(ap_clk),
        .CE(ar_hs),
        .D(\int_pixel_count_reg[31]_0 [27]),
        .Q(s_axi_CTRL_RDATA[27]),
        .R(\rdata[31]_i_1_n_1 ));
  FDRE \rdata_reg[28] 
       (.C(ap_clk),
        .CE(ar_hs),
        .D(\int_pixel_count_reg[31]_0 [28]),
        .Q(s_axi_CTRL_RDATA[28]),
        .R(\rdata[31]_i_1_n_1 ));
  FDRE \rdata_reg[29] 
       (.C(ap_clk),
        .CE(ar_hs),
        .D(\int_pixel_count_reg[31]_0 [29]),
        .Q(s_axi_CTRL_RDATA[29]),
        .R(\rdata[31]_i_1_n_1 ));
  FDRE \rdata_reg[2] 
       (.C(ap_clk),
        .CE(ar_hs),
        .D(rdata[2]),
        .Q(s_axi_CTRL_RDATA[2]),
        .R(1'b0));
  FDRE \rdata_reg[30] 
       (.C(ap_clk),
        .CE(ar_hs),
        .D(\int_pixel_count_reg[31]_0 [30]),
        .Q(s_axi_CTRL_RDATA[30]),
        .R(\rdata[31]_i_1_n_1 ));
  FDRE \rdata_reg[31] 
       (.C(ap_clk),
        .CE(ar_hs),
        .D(\int_pixel_count_reg[31]_0 [31]),
        .Q(s_axi_CTRL_RDATA[31]),
        .R(\rdata[31]_i_1_n_1 ));
  FDRE \rdata_reg[3] 
       (.C(ap_clk),
        .CE(ar_hs),
        .D(rdata[3]),
        .Q(s_axi_CTRL_RDATA[3]),
        .R(1'b0));
  FDRE \rdata_reg[4] 
       (.C(ap_clk),
        .CE(ar_hs),
        .D(rdata[4]),
        .Q(s_axi_CTRL_RDATA[4]),
        .R(1'b0));
  FDRE \rdata_reg[5] 
       (.C(ap_clk),
        .CE(ar_hs),
        .D(rdata[5]),
        .Q(s_axi_CTRL_RDATA[5]),
        .R(1'b0));
  FDRE \rdata_reg[6] 
       (.C(ap_clk),
        .CE(ar_hs),
        .D(rdata[6]),
        .Q(s_axi_CTRL_RDATA[6]),
        .R(1'b0));
  FDRE \rdata_reg[7] 
       (.C(ap_clk),
        .CE(ar_hs),
        .D(rdata[7]),
        .Q(s_axi_CTRL_RDATA[7]),
        .R(1'b0));
  FDRE \rdata_reg[8] 
       (.C(ap_clk),
        .CE(ar_hs),
        .D(\int_pixel_count_reg[31]_0 [8]),
        .Q(s_axi_CTRL_RDATA[8]),
        .R(\rdata[31]_i_1_n_1 ));
  FDRE \rdata_reg[9] 
       (.C(ap_clk),
        .CE(ar_hs),
        .D(\int_pixel_count_reg[31]_0 [9]),
        .Q(s_axi_CTRL_RDATA[9]),
        .R(\rdata[31]_i_1_n_1 ));
  LUT1 #(
    .INIT(2'h1)) 
    \s_axis_V_dest_V_0_state[1]_i_1 
       (.I0(ap_rst_n),
        .O(ap_rst_n_inv));
  LUT2 #(
    .INIT(4'h8)) 
    \waddr[5]_i_1 
       (.I0(s_axi_CTRL_AWVALID),
        .I1(\FSM_onehot_wstate_reg[1]_0 ),
        .O(waddr));
  FDRE \waddr_reg[0] 
       (.C(ap_clk),
        .CE(waddr),
        .D(s_axi_CTRL_AWADDR[0]),
        .Q(\waddr_reg_n_1_[0] ),
        .R(1'b0));
  FDRE \waddr_reg[1] 
       (.C(ap_clk),
        .CE(waddr),
        .D(s_axi_CTRL_AWADDR[1]),
        .Q(\waddr_reg_n_1_[1] ),
        .R(1'b0));
  FDRE \waddr_reg[2] 
       (.C(ap_clk),
        .CE(waddr),
        .D(s_axi_CTRL_AWADDR[2]),
        .Q(\waddr_reg_n_1_[2] ),
        .R(1'b0));
  FDRE \waddr_reg[3] 
       (.C(ap_clk),
        .CE(waddr),
        .D(s_axi_CTRL_AWADDR[3]),
        .Q(\waddr_reg_n_1_[3] ),
        .R(1'b0));
  FDRE \waddr_reg[4] 
       (.C(ap_clk),
        .CE(waddr),
        .D(s_axi_CTRL_AWADDR[4]),
        .Q(\waddr_reg_n_1_[4] ),
        .R(1'b0));
  FDRE \waddr_reg[5] 
       (.C(ap_clk),
        .CE(waddr),
        .D(s_axi_CTRL_AWADDR[5]),
        .Q(\waddr_reg_n_1_[5] ),
        .R(1'b0));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule
`endif
