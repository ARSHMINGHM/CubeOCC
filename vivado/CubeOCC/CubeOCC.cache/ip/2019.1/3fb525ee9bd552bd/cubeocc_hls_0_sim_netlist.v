// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
// Date        : Thu Aug 27 17:03:56 2026
// Host        : DESKTOP-RQHJO7S running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ cubeocc_hls_0_sim_netlist.v
// Design      : cubeocc_hls_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* ap_ST_fsm_pp0_stage0 = "1'b1" *) (* hls_module = "yes" *) 
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_cubeocc_hls
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
    m_axis_TDEST);
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

  wire ap_block_pp0_stage0_11001;
  wire ap_clk;
  wire ap_enable_reg_pp0_iter1;
  wire ap_enable_reg_pp0_iter1_i_1_n_0;
  wire ap_phi_mux_tmp_last_V_1_phi_fu_165_p61_out;
  wire ap_rst_n;
  wire ap_rst_n_inv;
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
  wire m_axis_V_data_V_1_load_B;
  wire [7:0]m_axis_V_data_V_1_payload_A;
  wire \m_axis_V_data_V_1_payload_A[7]_i_1_n_0 ;
  wire [7:0]m_axis_V_data_V_1_payload_B;
  wire m_axis_V_data_V_1_sel;
  wire m_axis_V_data_V_1_sel_rd_i_1_n_0;
  wire m_axis_V_data_V_1_sel_wr;
  wire m_axis_V_data_V_1_sel_wr_i_1_n_0;
  wire \m_axis_V_data_V_1_state[0]_i_1_n_0 ;
  wire \m_axis_V_data_V_1_state[1]_i_1_n_0 ;
  wire \m_axis_V_data_V_1_state_reg_n_0_[0] ;
  wire m_axis_V_dest_V_1_ack_in;
  wire m_axis_V_dest_V_1_payload_A;
  wire \m_axis_V_dest_V_1_payload_A[0]_i_1_n_0 ;
  wire \m_axis_V_dest_V_1_payload_A[0]_i_2_n_0 ;
  wire m_axis_V_dest_V_1_payload_B;
  wire \m_axis_V_dest_V_1_payload_B[0]_i_1_n_0 ;
  wire m_axis_V_dest_V_1_sel;
  wire m_axis_V_dest_V_1_sel_rd_i_1_n_0;
  wire m_axis_V_dest_V_1_sel_wr;
  wire m_axis_V_dest_V_1_sel_wr_i_1_n_0;
  wire \m_axis_V_dest_V_1_state[0]_i_1_n_0 ;
  wire \m_axis_V_dest_V_1_state[1]_i_1_n_0 ;
  wire m_axis_V_id_V_1_ack_in;
  wire m_axis_V_id_V_1_payload_A;
  wire \m_axis_V_id_V_1_payload_A[0]_i_1_n_0 ;
  wire \m_axis_V_id_V_1_payload_A[0]_i_2_n_0 ;
  wire m_axis_V_id_V_1_payload_B;
  wire \m_axis_V_id_V_1_payload_B[0]_i_1_n_0 ;
  wire m_axis_V_id_V_1_sel;
  wire m_axis_V_id_V_1_sel_rd_i_1_n_0;
  wire m_axis_V_id_V_1_sel_wr;
  wire m_axis_V_id_V_1_sel_wr_i_1_n_0;
  wire \m_axis_V_id_V_1_state[0]_i_1_n_0 ;
  wire \m_axis_V_id_V_1_state[1]_i_1_n_0 ;
  wire \m_axis_V_id_V_1_state_reg_n_0_[0] ;
  wire m_axis_V_keep_V_1_ack_in;
  wire m_axis_V_keep_V_1_payload_A;
  wire \m_axis_V_keep_V_1_payload_A[0]_i_1_n_0 ;
  wire \m_axis_V_keep_V_1_payload_A[0]_i_2_n_0 ;
  wire m_axis_V_keep_V_1_payload_B;
  wire \m_axis_V_keep_V_1_payload_B[0]_i_1_n_0 ;
  wire m_axis_V_keep_V_1_sel;
  wire m_axis_V_keep_V_1_sel_rd_i_1_n_0;
  wire m_axis_V_keep_V_1_sel_wr;
  wire m_axis_V_keep_V_1_sel_wr_i_1_n_0;
  wire \m_axis_V_keep_V_1_state[0]_i_1_n_0 ;
  wire \m_axis_V_keep_V_1_state[1]_i_1_n_0 ;
  wire \m_axis_V_keep_V_1_state_reg_n_0_[0] ;
  wire m_axis_V_last_V_1_ack_in;
  wire m_axis_V_last_V_1_payload_A;
  wire \m_axis_V_last_V_1_payload_A[0]_i_1_n_0 ;
  wire m_axis_V_last_V_1_payload_B;
  wire \m_axis_V_last_V_1_payload_B[0]_i_1_n_0 ;
  wire m_axis_V_last_V_1_sel;
  wire m_axis_V_last_V_1_sel_rd_i_1_n_0;
  wire m_axis_V_last_V_1_sel_wr;
  wire m_axis_V_last_V_1_sel_wr_i_1_n_0;
  wire \m_axis_V_last_V_1_state[0]_i_1_n_0 ;
  wire \m_axis_V_last_V_1_state[1]_i_1_n_0 ;
  wire \m_axis_V_last_V_1_state_reg_n_0_[0] ;
  wire m_axis_V_strb_V_1_ack_in;
  wire m_axis_V_strb_V_1_payload_A;
  wire \m_axis_V_strb_V_1_payload_A[0]_i_1_n_0 ;
  wire \m_axis_V_strb_V_1_payload_A[0]_i_2_n_0 ;
  wire m_axis_V_strb_V_1_payload_B;
  wire \m_axis_V_strb_V_1_payload_B[0]_i_1_n_0 ;
  wire m_axis_V_strb_V_1_sel;
  wire m_axis_V_strb_V_1_sel_rd_i_1_n_0;
  wire m_axis_V_strb_V_1_sel_wr;
  wire m_axis_V_strb_V_1_sel_wr_i_1_n_0;
  wire \m_axis_V_strb_V_1_state[0]_i_1_n_0 ;
  wire \m_axis_V_strb_V_1_state[1]_i_1_n_0 ;
  wire \m_axis_V_strb_V_1_state_reg_n_0_[0] ;
  wire m_axis_V_user_V_1_ack_in;
  wire m_axis_V_user_V_1_payload_A;
  wire \m_axis_V_user_V_1_payload_A[0]_i_1_n_0 ;
  wire m_axis_V_user_V_1_payload_B;
  wire \m_axis_V_user_V_1_payload_B[0]_i_1_n_0 ;
  wire m_axis_V_user_V_1_sel;
  wire m_axis_V_user_V_1_sel_rd_i_1_n_0;
  wire m_axis_V_user_V_1_sel_wr;
  wire m_axis_V_user_V_1_sel_wr_i_1_n_0;
  wire \m_axis_V_user_V_1_state[0]_i_1_n_0 ;
  wire \m_axis_V_user_V_1_state[1]_i_1_n_0 ;
  wire \m_axis_V_user_V_1_state_reg_n_0_[0] ;
  wire p_0_in58_in;
  wire p_1_in43_in;
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
  wire [7:0]s_axis_V_data_V_0_data_out;
  wire s_axis_V_data_V_0_load_B;
  wire [7:0]s_axis_V_data_V_0_payload_A;
  wire \s_axis_V_data_V_0_payload_A[7]_i_1_n_0 ;
  wire [7:0]s_axis_V_data_V_0_payload_B;
  wire s_axis_V_data_V_0_sel;
  wire s_axis_V_data_V_0_sel_rd_i_1_n_0;
  wire s_axis_V_data_V_0_sel_wr;
  wire s_axis_V_data_V_0_sel_wr_i_1_n_0;
  wire \s_axis_V_data_V_0_state[0]_i_1_n_0 ;
  wire \s_axis_V_data_V_0_state[1]_i_1_n_0 ;
  wire \s_axis_V_data_V_0_state_reg_n_0_[0] ;
  wire s_axis_V_dest_V_0_payload_A;
  wire \s_axis_V_dest_V_0_payload_A[0]_i_1_n_0 ;
  wire s_axis_V_dest_V_0_payload_B;
  wire \s_axis_V_dest_V_0_payload_B[0]_i_1_n_0 ;
  wire s_axis_V_dest_V_0_sel;
  wire s_axis_V_dest_V_0_sel_rd_i_1_n_0;
  wire s_axis_V_dest_V_0_sel_wr;
  wire s_axis_V_dest_V_0_sel_wr_i_1_n_0;
  wire \s_axis_V_dest_V_0_state[0]_i_1_n_0 ;
  wire \s_axis_V_dest_V_0_state[1]_i_10_n_0 ;
  wire \s_axis_V_dest_V_0_state[1]_i_11_n_0 ;
  wire \s_axis_V_dest_V_0_state[1]_i_2_n_0 ;
  wire \s_axis_V_dest_V_0_state[1]_i_4_n_0 ;
  wire \s_axis_V_dest_V_0_state[1]_i_5_n_0 ;
  wire \s_axis_V_dest_V_0_state[1]_i_6_n_0 ;
  wire \s_axis_V_dest_V_0_state[1]_i_9_n_0 ;
  wire \s_axis_V_dest_V_0_state_reg_n_0_[0] ;
  wire s_axis_V_id_V_0_ack_in;
  wire s_axis_V_id_V_0_payload_A;
  wire \s_axis_V_id_V_0_payload_A[0]_i_1_n_0 ;
  wire s_axis_V_id_V_0_payload_B;
  wire \s_axis_V_id_V_0_payload_B[0]_i_1_n_0 ;
  wire s_axis_V_id_V_0_sel;
  wire s_axis_V_id_V_0_sel_rd_i_1_n_0;
  wire s_axis_V_id_V_0_sel_wr;
  wire s_axis_V_id_V_0_sel_wr_i_1_n_0;
  wire \s_axis_V_id_V_0_state[0]_i_1_n_0 ;
  wire \s_axis_V_id_V_0_state[1]_i_1_n_0 ;
  wire \s_axis_V_id_V_0_state_reg_n_0_[0] ;
  wire s_axis_V_keep_V_0_ack_in;
  wire s_axis_V_keep_V_0_payload_A;
  wire \s_axis_V_keep_V_0_payload_A[0]_i_1_n_0 ;
  wire s_axis_V_keep_V_0_payload_B;
  wire \s_axis_V_keep_V_0_payload_B[0]_i_1_n_0 ;
  wire s_axis_V_keep_V_0_sel;
  wire s_axis_V_keep_V_0_sel_rd_i_1_n_0;
  wire s_axis_V_keep_V_0_sel_wr;
  wire s_axis_V_keep_V_0_sel_wr_i_1_n_0;
  wire \s_axis_V_keep_V_0_state[0]_i_1_n_0 ;
  wire \s_axis_V_keep_V_0_state[1]_i_1_n_0 ;
  wire \s_axis_V_keep_V_0_state_reg_n_0_[0] ;
  wire s_axis_V_last_V_0_ack_in;
  wire s_axis_V_last_V_0_payload_A;
  wire \s_axis_V_last_V_0_payload_A[0]_i_1_n_0 ;
  wire s_axis_V_last_V_0_payload_B;
  wire \s_axis_V_last_V_0_payload_B[0]_i_1_n_0 ;
  wire s_axis_V_last_V_0_sel;
  wire s_axis_V_last_V_0_sel_rd_i_1_n_0;
  wire s_axis_V_last_V_0_sel_wr;
  wire s_axis_V_last_V_0_sel_wr_i_1_n_0;
  wire \s_axis_V_last_V_0_state[0]_i_1_n_0 ;
  wire \s_axis_V_last_V_0_state[1]_i_1_n_0 ;
  wire \s_axis_V_last_V_0_state_reg_n_0_[0] ;
  wire s_axis_V_strb_V_0_ack_in;
  wire s_axis_V_strb_V_0_payload_A;
  wire \s_axis_V_strb_V_0_payload_A[0]_i_1_n_0 ;
  wire s_axis_V_strb_V_0_payload_B;
  wire \s_axis_V_strb_V_0_payload_B[0]_i_1_n_0 ;
  wire s_axis_V_strb_V_0_sel;
  wire s_axis_V_strb_V_0_sel_rd_i_1_n_0;
  wire s_axis_V_strb_V_0_sel_wr;
  wire s_axis_V_strb_V_0_sel_wr_i_1_n_0;
  wire \s_axis_V_strb_V_0_state[0]_i_1_n_0 ;
  wire \s_axis_V_strb_V_0_state[1]_i_1_n_0 ;
  wire \s_axis_V_strb_V_0_state_reg_n_0_[0] ;
  wire s_axis_V_user_V_0_ack_in;
  wire s_axis_V_user_V_0_payload_A;
  wire \s_axis_V_user_V_0_payload_A[0]_i_1_n_0 ;
  wire s_axis_V_user_V_0_payload_B;
  wire \s_axis_V_user_V_0_payload_B[0]_i_1_n_0 ;
  wire s_axis_V_user_V_0_sel;
  wire s_axis_V_user_V_0_sel_rd_i_1_n_0;
  wire s_axis_V_user_V_0_sel_wr;
  wire s_axis_V_user_V_0_sel_wr_i_1_n_0;
  wire \s_axis_V_user_V_0_state[0]_i_1_n_0 ;
  wire \s_axis_V_user_V_0_state[1]_i_1_n_0 ;
  wire \s_axis_V_user_V_0_state_reg_n_0_[0] ;
  wire tmp_user_V_fu_216_p1;

  (* SOFT_HLUTNM = "soft_lutpair20" *) 
  LUT2 #(
    .INIT(4'hB)) 
    ap_enable_reg_pp0_iter1_i_1
       (.I0(ap_enable_reg_pp0_iter1),
        .I1(ap_block_pp0_stage0_11001),
        .O(ap_enable_reg_pp0_iter1_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    ap_enable_reg_pp0_iter1_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(ap_enable_reg_pp0_iter1_i_1_n_0),
        .Q(ap_enable_reg_pp0_iter1),
        .R(ap_rst_n_inv));
  (* SOFT_HLUTNM = "soft_lutpair31" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \m_axis_TDATA[0]_INST_0 
       (.I0(m_axis_V_data_V_1_payload_B[0]),
        .I1(m_axis_V_data_V_1_payload_A[0]),
        .I2(m_axis_V_data_V_1_sel),
        .O(m_axis_TDATA[0]));
  (* SOFT_HLUTNM = "soft_lutpair32" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \m_axis_TDATA[1]_INST_0 
       (.I0(m_axis_V_data_V_1_payload_B[1]),
        .I1(m_axis_V_data_V_1_payload_A[1]),
        .I2(m_axis_V_data_V_1_sel),
        .O(m_axis_TDATA[1]));
  (* SOFT_HLUTNM = "soft_lutpair32" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \m_axis_TDATA[2]_INST_0 
       (.I0(m_axis_V_data_V_1_payload_B[2]),
        .I1(m_axis_V_data_V_1_payload_A[2]),
        .I2(m_axis_V_data_V_1_sel),
        .O(m_axis_TDATA[2]));
  (* SOFT_HLUTNM = "soft_lutpair33" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \m_axis_TDATA[3]_INST_0 
       (.I0(m_axis_V_data_V_1_payload_B[3]),
        .I1(m_axis_V_data_V_1_payload_A[3]),
        .I2(m_axis_V_data_V_1_sel),
        .O(m_axis_TDATA[3]));
  (* SOFT_HLUTNM = "soft_lutpair33" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \m_axis_TDATA[4]_INST_0 
       (.I0(m_axis_V_data_V_1_payload_B[4]),
        .I1(m_axis_V_data_V_1_payload_A[4]),
        .I2(m_axis_V_data_V_1_sel),
        .O(m_axis_TDATA[4]));
  (* SOFT_HLUTNM = "soft_lutpair34" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \m_axis_TDATA[5]_INST_0 
       (.I0(m_axis_V_data_V_1_payload_B[5]),
        .I1(m_axis_V_data_V_1_payload_A[5]),
        .I2(m_axis_V_data_V_1_sel),
        .O(m_axis_TDATA[5]));
  (* SOFT_HLUTNM = "soft_lutpair34" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \m_axis_TDATA[6]_INST_0 
       (.I0(m_axis_V_data_V_1_payload_B[6]),
        .I1(m_axis_V_data_V_1_payload_A[6]),
        .I2(m_axis_V_data_V_1_sel),
        .O(m_axis_TDATA[6]));
  (* SOFT_HLUTNM = "soft_lutpair31" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \m_axis_TDATA[7]_INST_0 
       (.I0(m_axis_V_data_V_1_payload_B[7]),
        .I1(m_axis_V_data_V_1_payload_A[7]),
        .I2(m_axis_V_data_V_1_sel),
        .O(m_axis_TDATA[7]));
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
  (* SOFT_HLUTNM = "soft_lutpair27" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \m_axis_V_data_V_1_payload_A[0]_i_1 
       (.I0(s_axis_V_data_V_0_payload_B[0]),
        .I1(s_axis_V_data_V_0_payload_A[0]),
        .I2(s_axis_V_data_V_0_sel),
        .O(s_axis_V_data_V_0_data_out[0]));
  (* SOFT_HLUTNM = "soft_lutpair27" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \m_axis_V_data_V_1_payload_A[1]_i_1 
       (.I0(s_axis_V_data_V_0_payload_B[1]),
        .I1(s_axis_V_data_V_0_payload_A[1]),
        .I2(s_axis_V_data_V_0_sel),
        .O(s_axis_V_data_V_0_data_out[1]));
  (* SOFT_HLUTNM = "soft_lutpair28" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \m_axis_V_data_V_1_payload_A[2]_i_1 
       (.I0(s_axis_V_data_V_0_payload_B[2]),
        .I1(s_axis_V_data_V_0_payload_A[2]),
        .I2(s_axis_V_data_V_0_sel),
        .O(s_axis_V_data_V_0_data_out[2]));
  (* SOFT_HLUTNM = "soft_lutpair28" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \m_axis_V_data_V_1_payload_A[3]_i_1 
       (.I0(s_axis_V_data_V_0_payload_B[3]),
        .I1(s_axis_V_data_V_0_payload_A[3]),
        .I2(s_axis_V_data_V_0_sel),
        .O(s_axis_V_data_V_0_data_out[3]));
  (* SOFT_HLUTNM = "soft_lutpair29" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \m_axis_V_data_V_1_payload_A[4]_i_1 
       (.I0(s_axis_V_data_V_0_payload_B[4]),
        .I1(s_axis_V_data_V_0_payload_A[4]),
        .I2(s_axis_V_data_V_0_sel),
        .O(s_axis_V_data_V_0_data_out[4]));
  (* SOFT_HLUTNM = "soft_lutpair29" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \m_axis_V_data_V_1_payload_A[5]_i_1 
       (.I0(s_axis_V_data_V_0_payload_B[5]),
        .I1(s_axis_V_data_V_0_payload_A[5]),
        .I2(s_axis_V_data_V_0_sel),
        .O(s_axis_V_data_V_0_data_out[5]));
  (* SOFT_HLUTNM = "soft_lutpair30" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \m_axis_V_data_V_1_payload_A[6]_i_1 
       (.I0(s_axis_V_data_V_0_payload_B[6]),
        .I1(s_axis_V_data_V_0_payload_A[6]),
        .I2(s_axis_V_data_V_0_sel),
        .O(s_axis_V_data_V_0_data_out[6]));
  LUT3 #(
    .INIT(8'h0D)) 
    \m_axis_V_data_V_1_payload_A[7]_i_1 
       (.I0(\m_axis_V_data_V_1_state_reg_n_0_[0] ),
        .I1(m_axis_V_data_V_1_ack_in),
        .I2(m_axis_V_data_V_1_sel_wr),
        .O(\m_axis_V_data_V_1_payload_A[7]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair30" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \m_axis_V_data_V_1_payload_A[7]_i_2 
       (.I0(s_axis_V_data_V_0_payload_B[7]),
        .I1(s_axis_V_data_V_0_payload_A[7]),
        .I2(s_axis_V_data_V_0_sel),
        .O(s_axis_V_data_V_0_data_out[7]));
  FDRE \m_axis_V_data_V_1_payload_A_reg[0] 
       (.C(ap_clk),
        .CE(\m_axis_V_data_V_1_payload_A[7]_i_1_n_0 ),
        .D(s_axis_V_data_V_0_data_out[0]),
        .Q(m_axis_V_data_V_1_payload_A[0]),
        .R(1'b0));
  FDRE \m_axis_V_data_V_1_payload_A_reg[1] 
       (.C(ap_clk),
        .CE(\m_axis_V_data_V_1_payload_A[7]_i_1_n_0 ),
        .D(s_axis_V_data_V_0_data_out[1]),
        .Q(m_axis_V_data_V_1_payload_A[1]),
        .R(1'b0));
  FDRE \m_axis_V_data_V_1_payload_A_reg[2] 
       (.C(ap_clk),
        .CE(\m_axis_V_data_V_1_payload_A[7]_i_1_n_0 ),
        .D(s_axis_V_data_V_0_data_out[2]),
        .Q(m_axis_V_data_V_1_payload_A[2]),
        .R(1'b0));
  FDRE \m_axis_V_data_V_1_payload_A_reg[3] 
       (.C(ap_clk),
        .CE(\m_axis_V_data_V_1_payload_A[7]_i_1_n_0 ),
        .D(s_axis_V_data_V_0_data_out[3]),
        .Q(m_axis_V_data_V_1_payload_A[3]),
        .R(1'b0));
  FDRE \m_axis_V_data_V_1_payload_A_reg[4] 
       (.C(ap_clk),
        .CE(\m_axis_V_data_V_1_payload_A[7]_i_1_n_0 ),
        .D(s_axis_V_data_V_0_data_out[4]),
        .Q(m_axis_V_data_V_1_payload_A[4]),
        .R(1'b0));
  FDRE \m_axis_V_data_V_1_payload_A_reg[5] 
       (.C(ap_clk),
        .CE(\m_axis_V_data_V_1_payload_A[7]_i_1_n_0 ),
        .D(s_axis_V_data_V_0_data_out[5]),
        .Q(m_axis_V_data_V_1_payload_A[5]),
        .R(1'b0));
  FDRE \m_axis_V_data_V_1_payload_A_reg[6] 
       (.C(ap_clk),
        .CE(\m_axis_V_data_V_1_payload_A[7]_i_1_n_0 ),
        .D(s_axis_V_data_V_0_data_out[6]),
        .Q(m_axis_V_data_V_1_payload_A[6]),
        .R(1'b0));
  FDRE \m_axis_V_data_V_1_payload_A_reg[7] 
       (.C(ap_clk),
        .CE(\m_axis_V_data_V_1_payload_A[7]_i_1_n_0 ),
        .D(s_axis_V_data_V_0_data_out[7]),
        .Q(m_axis_V_data_V_1_payload_A[7]),
        .R(1'b0));
  LUT3 #(
    .INIT(8'hA2)) 
    \m_axis_V_data_V_1_payload_B[7]_i_1 
       (.I0(m_axis_V_data_V_1_sel_wr),
        .I1(\m_axis_V_data_V_1_state_reg_n_0_[0] ),
        .I2(m_axis_V_data_V_1_ack_in),
        .O(m_axis_V_data_V_1_load_B));
  FDRE \m_axis_V_data_V_1_payload_B_reg[0] 
       (.C(ap_clk),
        .CE(m_axis_V_data_V_1_load_B),
        .D(s_axis_V_data_V_0_data_out[0]),
        .Q(m_axis_V_data_V_1_payload_B[0]),
        .R(1'b0));
  FDRE \m_axis_V_data_V_1_payload_B_reg[1] 
       (.C(ap_clk),
        .CE(m_axis_V_data_V_1_load_B),
        .D(s_axis_V_data_V_0_data_out[1]),
        .Q(m_axis_V_data_V_1_payload_B[1]),
        .R(1'b0));
  FDRE \m_axis_V_data_V_1_payload_B_reg[2] 
       (.C(ap_clk),
        .CE(m_axis_V_data_V_1_load_B),
        .D(s_axis_V_data_V_0_data_out[2]),
        .Q(m_axis_V_data_V_1_payload_B[2]),
        .R(1'b0));
  FDRE \m_axis_V_data_V_1_payload_B_reg[3] 
       (.C(ap_clk),
        .CE(m_axis_V_data_V_1_load_B),
        .D(s_axis_V_data_V_0_data_out[3]),
        .Q(m_axis_V_data_V_1_payload_B[3]),
        .R(1'b0));
  FDRE \m_axis_V_data_V_1_payload_B_reg[4] 
       (.C(ap_clk),
        .CE(m_axis_V_data_V_1_load_B),
        .D(s_axis_V_data_V_0_data_out[4]),
        .Q(m_axis_V_data_V_1_payload_B[4]),
        .R(1'b0));
  FDRE \m_axis_V_data_V_1_payload_B_reg[5] 
       (.C(ap_clk),
        .CE(m_axis_V_data_V_1_load_B),
        .D(s_axis_V_data_V_0_data_out[5]),
        .Q(m_axis_V_data_V_1_payload_B[5]),
        .R(1'b0));
  FDRE \m_axis_V_data_V_1_payload_B_reg[6] 
       (.C(ap_clk),
        .CE(m_axis_V_data_V_1_load_B),
        .D(s_axis_V_data_V_0_data_out[6]),
        .Q(m_axis_V_data_V_1_payload_B[6]),
        .R(1'b0));
  FDRE \m_axis_V_data_V_1_payload_B_reg[7] 
       (.C(ap_clk),
        .CE(m_axis_V_data_V_1_load_B),
        .D(s_axis_V_data_V_0_data_out[7]),
        .Q(m_axis_V_data_V_1_payload_B[7]),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT3 #(
    .INIT(8'h78)) 
    m_axis_V_data_V_1_sel_rd_i_1
       (.I0(m_axis_TREADY),
        .I1(\m_axis_V_data_V_1_state_reg_n_0_[0] ),
        .I2(m_axis_V_data_V_1_sel),
        .O(m_axis_V_data_V_1_sel_rd_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    m_axis_V_data_V_1_sel_rd_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(m_axis_V_data_V_1_sel_rd_i_1_n_0),
        .Q(m_axis_V_data_V_1_sel),
        .R(ap_rst_n_inv));
  (* SOFT_HLUTNM = "soft_lutpair24" *) 
  LUT3 #(
    .INIT(8'hB4)) 
    m_axis_V_data_V_1_sel_wr_i_1
       (.I0(ap_block_pp0_stage0_11001),
        .I1(m_axis_V_data_V_1_ack_in),
        .I2(m_axis_V_data_V_1_sel_wr),
        .O(m_axis_V_data_V_1_sel_wr_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    m_axis_V_data_V_1_sel_wr_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(m_axis_V_data_V_1_sel_wr_i_1_n_0),
        .Q(m_axis_V_data_V_1_sel_wr),
        .R(ap_rst_n_inv));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT5 #(
    .INIT(32'h0888A8A8)) 
    \m_axis_V_data_V_1_state[0]_i_1 
       (.I0(ap_rst_n),
        .I1(\m_axis_V_data_V_1_state_reg_n_0_[0] ),
        .I2(m_axis_V_data_V_1_ack_in),
        .I3(m_axis_TREADY),
        .I4(ap_block_pp0_stage0_11001),
        .O(\m_axis_V_data_V_1_state[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT4 #(
    .INIT(16'hFBBB)) 
    \m_axis_V_data_V_1_state[1]_i_1 
       (.I0(m_axis_TREADY),
        .I1(\m_axis_V_data_V_1_state_reg_n_0_[0] ),
        .I2(m_axis_V_data_V_1_ack_in),
        .I3(ap_block_pp0_stage0_11001),
        .O(\m_axis_V_data_V_1_state[1]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \m_axis_V_data_V_1_state_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\m_axis_V_data_V_1_state[0]_i_1_n_0 ),
        .Q(\m_axis_V_data_V_1_state_reg_n_0_[0] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \m_axis_V_data_V_1_state_reg[1] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\m_axis_V_data_V_1_state[1]_i_1_n_0 ),
        .Q(m_axis_V_data_V_1_ack_in),
        .R(ap_rst_n_inv));
  LUT6 #(
    .INIT(64'hFFFFFFB8000000B8)) 
    \m_axis_V_dest_V_1_payload_A[0]_i_1 
       (.I0(s_axis_V_dest_V_0_payload_B),
        .I1(s_axis_V_dest_V_0_sel),
        .I2(s_axis_V_dest_V_0_payload_A),
        .I3(\m_axis_V_dest_V_1_payload_A[0]_i_2_n_0 ),
        .I4(m_axis_V_dest_V_1_sel_wr),
        .I5(m_axis_V_dest_V_1_payload_A),
        .O(\m_axis_V_dest_V_1_payload_A[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \m_axis_V_dest_V_1_payload_A[0]_i_2 
       (.I0(m_axis_TVALID),
        .I1(m_axis_V_dest_V_1_ack_in),
        .O(\m_axis_V_dest_V_1_payload_A[0]_i_2_n_0 ));
  FDRE \m_axis_V_dest_V_1_payload_A_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\m_axis_V_dest_V_1_payload_A[0]_i_1_n_0 ),
        .Q(m_axis_V_dest_V_1_payload_A),
        .R(1'b0));
  LUT6 #(
    .INIT(64'hFFFFB8FF0000B800)) 
    \m_axis_V_dest_V_1_payload_B[0]_i_1 
       (.I0(s_axis_V_dest_V_0_payload_B),
        .I1(s_axis_V_dest_V_0_sel),
        .I2(s_axis_V_dest_V_0_payload_A),
        .I3(m_axis_V_dest_V_1_sel_wr),
        .I4(\m_axis_V_dest_V_1_payload_A[0]_i_2_n_0 ),
        .I5(m_axis_V_dest_V_1_payload_B),
        .O(\m_axis_V_dest_V_1_payload_B[0]_i_1_n_0 ));
  FDRE \m_axis_V_dest_V_1_payload_B_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\m_axis_V_dest_V_1_payload_B[0]_i_1_n_0 ),
        .Q(m_axis_V_dest_V_1_payload_B),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair18" *) 
  LUT3 #(
    .INIT(8'h78)) 
    m_axis_V_dest_V_1_sel_rd_i_1
       (.I0(m_axis_TREADY),
        .I1(m_axis_TVALID),
        .I2(m_axis_V_dest_V_1_sel),
        .O(m_axis_V_dest_V_1_sel_rd_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    m_axis_V_dest_V_1_sel_rd_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(m_axis_V_dest_V_1_sel_rd_i_1_n_0),
        .Q(m_axis_V_dest_V_1_sel),
        .R(ap_rst_n_inv));
  (* SOFT_HLUTNM = "soft_lutpair21" *) 
  LUT3 #(
    .INIT(8'hB4)) 
    m_axis_V_dest_V_1_sel_wr_i_1
       (.I0(ap_block_pp0_stage0_11001),
        .I1(m_axis_V_dest_V_1_ack_in),
        .I2(m_axis_V_dest_V_1_sel_wr),
        .O(m_axis_V_dest_V_1_sel_wr_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    m_axis_V_dest_V_1_sel_wr_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(m_axis_V_dest_V_1_sel_wr_i_1_n_0),
        .Q(m_axis_V_dest_V_1_sel_wr),
        .R(ap_rst_n_inv));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'h0888A8A8)) 
    \m_axis_V_dest_V_1_state[0]_i_1 
       (.I0(ap_rst_n),
        .I1(m_axis_TVALID),
        .I2(m_axis_V_dest_V_1_ack_in),
        .I3(m_axis_TREADY),
        .I4(ap_block_pp0_stage0_11001),
        .O(\m_axis_V_dest_V_1_state[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair18" *) 
  LUT4 #(
    .INIT(16'hFBBB)) 
    \m_axis_V_dest_V_1_state[1]_i_1 
       (.I0(m_axis_TREADY),
        .I1(m_axis_TVALID),
        .I2(m_axis_V_dest_V_1_ack_in),
        .I3(ap_block_pp0_stage0_11001),
        .O(\m_axis_V_dest_V_1_state[1]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \m_axis_V_dest_V_1_state_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\m_axis_V_dest_V_1_state[0]_i_1_n_0 ),
        .Q(m_axis_TVALID),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \m_axis_V_dest_V_1_state_reg[1] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\m_axis_V_dest_V_1_state[1]_i_1_n_0 ),
        .Q(m_axis_V_dest_V_1_ack_in),
        .R(ap_rst_n_inv));
  LUT6 #(
    .INIT(64'hFFFFFFB8000000B8)) 
    \m_axis_V_id_V_1_payload_A[0]_i_1 
       (.I0(s_axis_V_id_V_0_payload_B),
        .I1(s_axis_V_id_V_0_sel),
        .I2(s_axis_V_id_V_0_payload_A),
        .I3(\m_axis_V_id_V_1_payload_A[0]_i_2_n_0 ),
        .I4(m_axis_V_id_V_1_sel_wr),
        .I5(m_axis_V_id_V_1_payload_A),
        .O(\m_axis_V_id_V_1_payload_A[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \m_axis_V_id_V_1_payload_A[0]_i_2 
       (.I0(\m_axis_V_id_V_1_state_reg_n_0_[0] ),
        .I1(m_axis_V_id_V_1_ack_in),
        .O(\m_axis_V_id_V_1_payload_A[0]_i_2_n_0 ));
  FDRE \m_axis_V_id_V_1_payload_A_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\m_axis_V_id_V_1_payload_A[0]_i_1_n_0 ),
        .Q(m_axis_V_id_V_1_payload_A),
        .R(1'b0));
  LUT6 #(
    .INIT(64'hFFFFB8FF0000B800)) 
    \m_axis_V_id_V_1_payload_B[0]_i_1 
       (.I0(s_axis_V_id_V_0_payload_B),
        .I1(s_axis_V_id_V_0_sel),
        .I2(s_axis_V_id_V_0_payload_A),
        .I3(m_axis_V_id_V_1_sel_wr),
        .I4(\m_axis_V_id_V_1_payload_A[0]_i_2_n_0 ),
        .I5(m_axis_V_id_V_1_payload_B),
        .O(\m_axis_V_id_V_1_payload_B[0]_i_1_n_0 ));
  FDRE \m_axis_V_id_V_1_payload_B_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\m_axis_V_id_V_1_payload_B[0]_i_1_n_0 ),
        .Q(m_axis_V_id_V_1_payload_B),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT3 #(
    .INIT(8'h78)) 
    m_axis_V_id_V_1_sel_rd_i_1
       (.I0(m_axis_TREADY),
        .I1(\m_axis_V_id_V_1_state_reg_n_0_[0] ),
        .I2(m_axis_V_id_V_1_sel),
        .O(m_axis_V_id_V_1_sel_rd_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    m_axis_V_id_V_1_sel_rd_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(m_axis_V_id_V_1_sel_rd_i_1_n_0),
        .Q(m_axis_V_id_V_1_sel),
        .R(ap_rst_n_inv));
  (* SOFT_HLUTNM = "soft_lutpair22" *) 
  LUT3 #(
    .INIT(8'hB4)) 
    m_axis_V_id_V_1_sel_wr_i_1
       (.I0(ap_block_pp0_stage0_11001),
        .I1(m_axis_V_id_V_1_ack_in),
        .I2(m_axis_V_id_V_1_sel_wr),
        .O(m_axis_V_id_V_1_sel_wr_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    m_axis_V_id_V_1_sel_wr_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(m_axis_V_id_V_1_sel_wr_i_1_n_0),
        .Q(m_axis_V_id_V_1_sel_wr),
        .R(ap_rst_n_inv));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT5 #(
    .INIT(32'h0888A8A8)) 
    \m_axis_V_id_V_1_state[0]_i_1 
       (.I0(ap_rst_n),
        .I1(\m_axis_V_id_V_1_state_reg_n_0_[0] ),
        .I2(m_axis_V_id_V_1_ack_in),
        .I3(m_axis_TREADY),
        .I4(ap_block_pp0_stage0_11001),
        .O(\m_axis_V_id_V_1_state[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT4 #(
    .INIT(16'hFBBB)) 
    \m_axis_V_id_V_1_state[1]_i_1 
       (.I0(m_axis_TREADY),
        .I1(\m_axis_V_id_V_1_state_reg_n_0_[0] ),
        .I2(m_axis_V_id_V_1_ack_in),
        .I3(ap_block_pp0_stage0_11001),
        .O(\m_axis_V_id_V_1_state[1]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \m_axis_V_id_V_1_state_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\m_axis_V_id_V_1_state[0]_i_1_n_0 ),
        .Q(\m_axis_V_id_V_1_state_reg_n_0_[0] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \m_axis_V_id_V_1_state_reg[1] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\m_axis_V_id_V_1_state[1]_i_1_n_0 ),
        .Q(m_axis_V_id_V_1_ack_in),
        .R(ap_rst_n_inv));
  LUT6 #(
    .INIT(64'hFFFFFFB8000000B8)) 
    \m_axis_V_keep_V_1_payload_A[0]_i_1 
       (.I0(s_axis_V_keep_V_0_payload_B),
        .I1(s_axis_V_keep_V_0_sel),
        .I2(s_axis_V_keep_V_0_payload_A),
        .I3(\m_axis_V_keep_V_1_payload_A[0]_i_2_n_0 ),
        .I4(m_axis_V_keep_V_1_sel_wr),
        .I5(m_axis_V_keep_V_1_payload_A),
        .O(\m_axis_V_keep_V_1_payload_A[0]_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h2)) 
    \m_axis_V_keep_V_1_payload_A[0]_i_2 
       (.I0(\m_axis_V_keep_V_1_state_reg_n_0_[0] ),
        .I1(m_axis_V_keep_V_1_ack_in),
        .O(\m_axis_V_keep_V_1_payload_A[0]_i_2_n_0 ));
  FDRE \m_axis_V_keep_V_1_payload_A_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\m_axis_V_keep_V_1_payload_A[0]_i_1_n_0 ),
        .Q(m_axis_V_keep_V_1_payload_A),
        .R(1'b0));
  LUT6 #(
    .INIT(64'hFFFFB8FF0000B800)) 
    \m_axis_V_keep_V_1_payload_B[0]_i_1 
       (.I0(s_axis_V_keep_V_0_payload_B),
        .I1(s_axis_V_keep_V_0_sel),
        .I2(s_axis_V_keep_V_0_payload_A),
        .I3(m_axis_V_keep_V_1_sel_wr),
        .I4(\m_axis_V_keep_V_1_payload_A[0]_i_2_n_0 ),
        .I5(m_axis_V_keep_V_1_payload_B),
        .O(\m_axis_V_keep_V_1_payload_B[0]_i_1_n_0 ));
  FDRE \m_axis_V_keep_V_1_payload_B_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\m_axis_V_keep_V_1_payload_B[0]_i_1_n_0 ),
        .Q(m_axis_V_keep_V_1_payload_B),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair17" *) 
  LUT3 #(
    .INIT(8'h78)) 
    m_axis_V_keep_V_1_sel_rd_i_1
       (.I0(m_axis_TREADY),
        .I1(\m_axis_V_keep_V_1_state_reg_n_0_[0] ),
        .I2(m_axis_V_keep_V_1_sel),
        .O(m_axis_V_keep_V_1_sel_rd_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    m_axis_V_keep_V_1_sel_rd_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(m_axis_V_keep_V_1_sel_rd_i_1_n_0),
        .Q(m_axis_V_keep_V_1_sel),
        .R(ap_rst_n_inv));
  (* SOFT_HLUTNM = "soft_lutpair23" *) 
  LUT3 #(
    .INIT(8'hB4)) 
    m_axis_V_keep_V_1_sel_wr_i_1
       (.I0(ap_block_pp0_stage0_11001),
        .I1(m_axis_V_keep_V_1_ack_in),
        .I2(m_axis_V_keep_V_1_sel_wr),
        .O(m_axis_V_keep_V_1_sel_wr_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    m_axis_V_keep_V_1_sel_wr_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(m_axis_V_keep_V_1_sel_wr_i_1_n_0),
        .Q(m_axis_V_keep_V_1_sel_wr),
        .R(ap_rst_n_inv));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT5 #(
    .INIT(32'h0888A8A8)) 
    \m_axis_V_keep_V_1_state[0]_i_1 
       (.I0(ap_rst_n),
        .I1(\m_axis_V_keep_V_1_state_reg_n_0_[0] ),
        .I2(m_axis_V_keep_V_1_ack_in),
        .I3(m_axis_TREADY),
        .I4(ap_block_pp0_stage0_11001),
        .O(\m_axis_V_keep_V_1_state[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair17" *) 
  LUT4 #(
    .INIT(16'hFBBB)) 
    \m_axis_V_keep_V_1_state[1]_i_1 
       (.I0(m_axis_TREADY),
        .I1(\m_axis_V_keep_V_1_state_reg_n_0_[0] ),
        .I2(m_axis_V_keep_V_1_ack_in),
        .I3(ap_block_pp0_stage0_11001),
        .O(\m_axis_V_keep_V_1_state[1]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \m_axis_V_keep_V_1_state_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\m_axis_V_keep_V_1_state[0]_i_1_n_0 ),
        .Q(\m_axis_V_keep_V_1_state_reg_n_0_[0] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \m_axis_V_keep_V_1_state_reg[1] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\m_axis_V_keep_V_1_state[1]_i_1_n_0 ),
        .Q(m_axis_V_keep_V_1_ack_in),
        .R(ap_rst_n_inv));
  LUT5 #(
    .INIT(32'hFFAE00A2)) 
    \m_axis_V_last_V_1_payload_A[0]_i_1 
       (.I0(ap_phi_mux_tmp_last_V_1_phi_fu_165_p61_out),
        .I1(\m_axis_V_last_V_1_state_reg_n_0_[0] ),
        .I2(m_axis_V_last_V_1_ack_in),
        .I3(m_axis_V_last_V_1_sel_wr),
        .I4(m_axis_V_last_V_1_payload_A),
        .O(\m_axis_V_last_V_1_payload_A[0]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'hB8)) 
    \m_axis_V_last_V_1_payload_A[0]_i_2 
       (.I0(s_axis_V_last_V_0_payload_B),
        .I1(s_axis_V_last_V_0_sel),
        .I2(s_axis_V_last_V_0_payload_A),
        .O(ap_phi_mux_tmp_last_V_1_phi_fu_165_p61_out));
  FDRE \m_axis_V_last_V_1_payload_A_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\m_axis_V_last_V_1_payload_A[0]_i_1_n_0 ),
        .Q(m_axis_V_last_V_1_payload_A),
        .R(1'b0));
  LUT5 #(
    .INIT(32'hBBFB8808)) 
    \m_axis_V_last_V_1_payload_B[0]_i_1 
       (.I0(ap_phi_mux_tmp_last_V_1_phi_fu_165_p61_out),
        .I1(m_axis_V_last_V_1_sel_wr),
        .I2(\m_axis_V_last_V_1_state_reg_n_0_[0] ),
        .I3(m_axis_V_last_V_1_ack_in),
        .I4(m_axis_V_last_V_1_payload_B),
        .O(\m_axis_V_last_V_1_payload_B[0]_i_1_n_0 ));
  FDRE \m_axis_V_last_V_1_payload_B_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\m_axis_V_last_V_1_payload_B[0]_i_1_n_0 ),
        .Q(m_axis_V_last_V_1_payload_B),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT3 #(
    .INIT(8'h78)) 
    m_axis_V_last_V_1_sel_rd_i_1
       (.I0(m_axis_TREADY),
        .I1(\m_axis_V_last_V_1_state_reg_n_0_[0] ),
        .I2(m_axis_V_last_V_1_sel),
        .O(m_axis_V_last_V_1_sel_rd_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    m_axis_V_last_V_1_sel_rd_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(m_axis_V_last_V_1_sel_rd_i_1_n_0),
        .Q(m_axis_V_last_V_1_sel),
        .R(ap_rst_n_inv));
  (* SOFT_HLUTNM = "soft_lutpair23" *) 
  LUT3 #(
    .INIT(8'hB4)) 
    m_axis_V_last_V_1_sel_wr_i_1
       (.I0(ap_block_pp0_stage0_11001),
        .I1(m_axis_V_last_V_1_ack_in),
        .I2(m_axis_V_last_V_1_sel_wr),
        .O(m_axis_V_last_V_1_sel_wr_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    m_axis_V_last_V_1_sel_wr_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(m_axis_V_last_V_1_sel_wr_i_1_n_0),
        .Q(m_axis_V_last_V_1_sel_wr),
        .R(ap_rst_n_inv));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT5 #(
    .INIT(32'h0888A8A8)) 
    \m_axis_V_last_V_1_state[0]_i_1 
       (.I0(ap_rst_n),
        .I1(\m_axis_V_last_V_1_state_reg_n_0_[0] ),
        .I2(m_axis_V_last_V_1_ack_in),
        .I3(m_axis_TREADY),
        .I4(ap_block_pp0_stage0_11001),
        .O(\m_axis_V_last_V_1_state[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT4 #(
    .INIT(16'hFBBB)) 
    \m_axis_V_last_V_1_state[1]_i_1 
       (.I0(m_axis_TREADY),
        .I1(\m_axis_V_last_V_1_state_reg_n_0_[0] ),
        .I2(m_axis_V_last_V_1_ack_in),
        .I3(ap_block_pp0_stage0_11001),
        .O(\m_axis_V_last_V_1_state[1]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \m_axis_V_last_V_1_state_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\m_axis_V_last_V_1_state[0]_i_1_n_0 ),
        .Q(\m_axis_V_last_V_1_state_reg_n_0_[0] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \m_axis_V_last_V_1_state_reg[1] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\m_axis_V_last_V_1_state[1]_i_1_n_0 ),
        .Q(m_axis_V_last_V_1_ack_in),
        .R(ap_rst_n_inv));
  LUT6 #(
    .INIT(64'hFFFFFFB8000000B8)) 
    \m_axis_V_strb_V_1_payload_A[0]_i_1 
       (.I0(s_axis_V_strb_V_0_payload_B),
        .I1(s_axis_V_strb_V_0_sel),
        .I2(s_axis_V_strb_V_0_payload_A),
        .I3(\m_axis_V_strb_V_1_payload_A[0]_i_2_n_0 ),
        .I4(m_axis_V_strb_V_1_sel_wr),
        .I5(m_axis_V_strb_V_1_payload_A),
        .O(\m_axis_V_strb_V_1_payload_A[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \m_axis_V_strb_V_1_payload_A[0]_i_2 
       (.I0(\m_axis_V_strb_V_1_state_reg_n_0_[0] ),
        .I1(m_axis_V_strb_V_1_ack_in),
        .O(\m_axis_V_strb_V_1_payload_A[0]_i_2_n_0 ));
  FDRE \m_axis_V_strb_V_1_payload_A_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\m_axis_V_strb_V_1_payload_A[0]_i_1_n_0 ),
        .Q(m_axis_V_strb_V_1_payload_A),
        .R(1'b0));
  LUT6 #(
    .INIT(64'hFFFFB8FF0000B800)) 
    \m_axis_V_strb_V_1_payload_B[0]_i_1 
       (.I0(s_axis_V_strb_V_0_payload_B),
        .I1(s_axis_V_strb_V_0_sel),
        .I2(s_axis_V_strb_V_0_payload_A),
        .I3(m_axis_V_strb_V_1_sel_wr),
        .I4(\m_axis_V_strb_V_1_payload_A[0]_i_2_n_0 ),
        .I5(m_axis_V_strb_V_1_payload_B),
        .O(\m_axis_V_strb_V_1_payload_B[0]_i_1_n_0 ));
  FDRE \m_axis_V_strb_V_1_payload_B_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\m_axis_V_strb_V_1_payload_B[0]_i_1_n_0 ),
        .Q(m_axis_V_strb_V_1_payload_B),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT3 #(
    .INIT(8'h78)) 
    m_axis_V_strb_V_1_sel_rd_i_1
       (.I0(m_axis_TREADY),
        .I1(\m_axis_V_strb_V_1_state_reg_n_0_[0] ),
        .I2(m_axis_V_strb_V_1_sel),
        .O(m_axis_V_strb_V_1_sel_rd_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    m_axis_V_strb_V_1_sel_rd_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(m_axis_V_strb_V_1_sel_rd_i_1_n_0),
        .Q(m_axis_V_strb_V_1_sel),
        .R(ap_rst_n_inv));
  (* SOFT_HLUTNM = "soft_lutpair25" *) 
  LUT3 #(
    .INIT(8'hB4)) 
    m_axis_V_strb_V_1_sel_wr_i_1
       (.I0(ap_block_pp0_stage0_11001),
        .I1(m_axis_V_strb_V_1_ack_in),
        .I2(m_axis_V_strb_V_1_sel_wr),
        .O(m_axis_V_strb_V_1_sel_wr_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    m_axis_V_strb_V_1_sel_wr_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(m_axis_V_strb_V_1_sel_wr_i_1_n_0),
        .Q(m_axis_V_strb_V_1_sel_wr),
        .R(ap_rst_n_inv));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT5 #(
    .INIT(32'h0888A8A8)) 
    \m_axis_V_strb_V_1_state[0]_i_1 
       (.I0(ap_rst_n),
        .I1(\m_axis_V_strb_V_1_state_reg_n_0_[0] ),
        .I2(m_axis_V_strb_V_1_ack_in),
        .I3(m_axis_TREADY),
        .I4(ap_block_pp0_stage0_11001),
        .O(\m_axis_V_strb_V_1_state[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT4 #(
    .INIT(16'hFBBB)) 
    \m_axis_V_strb_V_1_state[1]_i_1 
       (.I0(m_axis_TREADY),
        .I1(\m_axis_V_strb_V_1_state_reg_n_0_[0] ),
        .I2(m_axis_V_strb_V_1_ack_in),
        .I3(ap_block_pp0_stage0_11001),
        .O(\m_axis_V_strb_V_1_state[1]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \m_axis_V_strb_V_1_state_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\m_axis_V_strb_V_1_state[0]_i_1_n_0 ),
        .Q(\m_axis_V_strb_V_1_state_reg_n_0_[0] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \m_axis_V_strb_V_1_state_reg[1] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\m_axis_V_strb_V_1_state[1]_i_1_n_0 ),
        .Q(m_axis_V_strb_V_1_ack_in),
        .R(ap_rst_n_inv));
  LUT5 #(
    .INIT(32'hFFAE00A2)) 
    \m_axis_V_user_V_1_payload_A[0]_i_1 
       (.I0(tmp_user_V_fu_216_p1),
        .I1(\m_axis_V_user_V_1_state_reg_n_0_[0] ),
        .I2(m_axis_V_user_V_1_ack_in),
        .I3(m_axis_V_user_V_1_sel_wr),
        .I4(m_axis_V_user_V_1_payload_A),
        .O(\m_axis_V_user_V_1_payload_A[0]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'hB8)) 
    \m_axis_V_user_V_1_payload_A[0]_i_2 
       (.I0(s_axis_V_user_V_0_payload_B),
        .I1(s_axis_V_user_V_0_sel),
        .I2(s_axis_V_user_V_0_payload_A),
        .O(tmp_user_V_fu_216_p1));
  FDRE \m_axis_V_user_V_1_payload_A_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\m_axis_V_user_V_1_payload_A[0]_i_1_n_0 ),
        .Q(m_axis_V_user_V_1_payload_A),
        .R(1'b0));
  LUT5 #(
    .INIT(32'hBBFB8808)) 
    \m_axis_V_user_V_1_payload_B[0]_i_1 
       (.I0(tmp_user_V_fu_216_p1),
        .I1(m_axis_V_user_V_1_sel_wr),
        .I2(\m_axis_V_user_V_1_state_reg_n_0_[0] ),
        .I3(m_axis_V_user_V_1_ack_in),
        .I4(m_axis_V_user_V_1_payload_B),
        .O(\m_axis_V_user_V_1_payload_B[0]_i_1_n_0 ));
  FDRE \m_axis_V_user_V_1_payload_B_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\m_axis_V_user_V_1_payload_B[0]_i_1_n_0 ),
        .Q(m_axis_V_user_V_1_payload_B),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair19" *) 
  LUT3 #(
    .INIT(8'h78)) 
    m_axis_V_user_V_1_sel_rd_i_1
       (.I0(m_axis_TREADY),
        .I1(\m_axis_V_user_V_1_state_reg_n_0_[0] ),
        .I2(m_axis_V_user_V_1_sel),
        .O(m_axis_V_user_V_1_sel_rd_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    m_axis_V_user_V_1_sel_rd_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(m_axis_V_user_V_1_sel_rd_i_1_n_0),
        .Q(m_axis_V_user_V_1_sel),
        .R(ap_rst_n_inv));
  (* SOFT_HLUTNM = "soft_lutpair26" *) 
  LUT3 #(
    .INIT(8'hB4)) 
    m_axis_V_user_V_1_sel_wr_i_1
       (.I0(ap_block_pp0_stage0_11001),
        .I1(m_axis_V_user_V_1_ack_in),
        .I2(m_axis_V_user_V_1_sel_wr),
        .O(m_axis_V_user_V_1_sel_wr_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    m_axis_V_user_V_1_sel_wr_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(m_axis_V_user_V_1_sel_wr_i_1_n_0),
        .Q(m_axis_V_user_V_1_sel_wr),
        .R(ap_rst_n_inv));
  LUT5 #(
    .INIT(32'h0888A8A8)) 
    \m_axis_V_user_V_1_state[0]_i_1 
       (.I0(ap_rst_n),
        .I1(\m_axis_V_user_V_1_state_reg_n_0_[0] ),
        .I2(m_axis_V_user_V_1_ack_in),
        .I3(m_axis_TREADY),
        .I4(ap_block_pp0_stage0_11001),
        .O(\m_axis_V_user_V_1_state[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair19" *) 
  LUT4 #(
    .INIT(16'hFBBB)) 
    \m_axis_V_user_V_1_state[1]_i_1 
       (.I0(m_axis_TREADY),
        .I1(\m_axis_V_user_V_1_state_reg_n_0_[0] ),
        .I2(m_axis_V_user_V_1_ack_in),
        .I3(ap_block_pp0_stage0_11001),
        .O(\m_axis_V_user_V_1_state[1]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \m_axis_V_user_V_1_state_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\m_axis_V_user_V_1_state[0]_i_1_n_0 ),
        .Q(\m_axis_V_user_V_1_state_reg_n_0_[0] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \m_axis_V_user_V_1_state_reg[1] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\m_axis_V_user_V_1_state[1]_i_1_n_0 ),
        .Q(m_axis_V_user_V_1_ack_in),
        .R(ap_rst_n_inv));
  LUT3 #(
    .INIT(8'h0D)) 
    \s_axis_V_data_V_0_payload_A[7]_i_1 
       (.I0(\s_axis_V_data_V_0_state_reg_n_0_[0] ),
        .I1(s_axis_V_data_V_0_ack_in),
        .I2(s_axis_V_data_V_0_sel_wr),
        .O(\s_axis_V_data_V_0_payload_A[7]_i_1_n_0 ));
  FDRE \s_axis_V_data_V_0_payload_A_reg[0] 
       (.C(ap_clk),
        .CE(\s_axis_V_data_V_0_payload_A[7]_i_1_n_0 ),
        .D(s_axis_TDATA[0]),
        .Q(s_axis_V_data_V_0_payload_A[0]),
        .R(1'b0));
  FDRE \s_axis_V_data_V_0_payload_A_reg[1] 
       (.C(ap_clk),
        .CE(\s_axis_V_data_V_0_payload_A[7]_i_1_n_0 ),
        .D(s_axis_TDATA[1]),
        .Q(s_axis_V_data_V_0_payload_A[1]),
        .R(1'b0));
  FDRE \s_axis_V_data_V_0_payload_A_reg[2] 
       (.C(ap_clk),
        .CE(\s_axis_V_data_V_0_payload_A[7]_i_1_n_0 ),
        .D(s_axis_TDATA[2]),
        .Q(s_axis_V_data_V_0_payload_A[2]),
        .R(1'b0));
  FDRE \s_axis_V_data_V_0_payload_A_reg[3] 
       (.C(ap_clk),
        .CE(\s_axis_V_data_V_0_payload_A[7]_i_1_n_0 ),
        .D(s_axis_TDATA[3]),
        .Q(s_axis_V_data_V_0_payload_A[3]),
        .R(1'b0));
  FDRE \s_axis_V_data_V_0_payload_A_reg[4] 
       (.C(ap_clk),
        .CE(\s_axis_V_data_V_0_payload_A[7]_i_1_n_0 ),
        .D(s_axis_TDATA[4]),
        .Q(s_axis_V_data_V_0_payload_A[4]),
        .R(1'b0));
  FDRE \s_axis_V_data_V_0_payload_A_reg[5] 
       (.C(ap_clk),
        .CE(\s_axis_V_data_V_0_payload_A[7]_i_1_n_0 ),
        .D(s_axis_TDATA[5]),
        .Q(s_axis_V_data_V_0_payload_A[5]),
        .R(1'b0));
  FDRE \s_axis_V_data_V_0_payload_A_reg[6] 
       (.C(ap_clk),
        .CE(\s_axis_V_data_V_0_payload_A[7]_i_1_n_0 ),
        .D(s_axis_TDATA[6]),
        .Q(s_axis_V_data_V_0_payload_A[6]),
        .R(1'b0));
  FDRE \s_axis_V_data_V_0_payload_A_reg[7] 
       (.C(ap_clk),
        .CE(\s_axis_V_data_V_0_payload_A[7]_i_1_n_0 ),
        .D(s_axis_TDATA[7]),
        .Q(s_axis_V_data_V_0_payload_A[7]),
        .R(1'b0));
  LUT3 #(
    .INIT(8'hA2)) 
    \s_axis_V_data_V_0_payload_B[7]_i_1 
       (.I0(s_axis_V_data_V_0_sel_wr),
        .I1(\s_axis_V_data_V_0_state_reg_n_0_[0] ),
        .I2(s_axis_V_data_V_0_ack_in),
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
  (* SOFT_HLUTNM = "soft_lutpair25" *) 
  LUT3 #(
    .INIT(8'hB4)) 
    s_axis_V_data_V_0_sel_rd_i_1
       (.I0(ap_block_pp0_stage0_11001),
        .I1(\s_axis_V_data_V_0_state_reg_n_0_[0] ),
        .I2(s_axis_V_data_V_0_sel),
        .O(s_axis_V_data_V_0_sel_rd_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    s_axis_V_data_V_0_sel_rd_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(s_axis_V_data_V_0_sel_rd_i_1_n_0),
        .Q(s_axis_V_data_V_0_sel),
        .R(ap_rst_n_inv));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT3 #(
    .INIT(8'h78)) 
    s_axis_V_data_V_0_sel_wr_i_1
       (.I0(s_axis_TVALID),
        .I1(s_axis_V_data_V_0_ack_in),
        .I2(s_axis_V_data_V_0_sel_wr),
        .O(s_axis_V_data_V_0_sel_wr_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    s_axis_V_data_V_0_sel_wr_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(s_axis_V_data_V_0_sel_wr_i_1_n_0),
        .Q(s_axis_V_data_V_0_sel_wr),
        .R(ap_rst_n_inv));
  LUT5 #(
    .INIT(32'hA888A808)) 
    \s_axis_V_data_V_0_state[0]_i_1 
       (.I0(ap_rst_n),
        .I1(\s_axis_V_data_V_0_state_reg_n_0_[0] ),
        .I2(s_axis_V_data_V_0_ack_in),
        .I3(s_axis_TVALID),
        .I4(ap_block_pp0_stage0_11001),
        .O(\s_axis_V_data_V_0_state[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT4 #(
    .INIT(16'h75FF)) 
    \s_axis_V_data_V_0_state[1]_i_1 
       (.I0(ap_block_pp0_stage0_11001),
        .I1(s_axis_TVALID),
        .I2(s_axis_V_data_V_0_ack_in),
        .I3(\s_axis_V_data_V_0_state_reg_n_0_[0] ),
        .O(\s_axis_V_data_V_0_state[1]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \s_axis_V_data_V_0_state_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\s_axis_V_data_V_0_state[0]_i_1_n_0 ),
        .Q(\s_axis_V_data_V_0_state_reg_n_0_[0] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \s_axis_V_data_V_0_state_reg[1] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\s_axis_V_data_V_0_state[1]_i_1_n_0 ),
        .Q(s_axis_V_data_V_0_ack_in),
        .R(ap_rst_n_inv));
  LUT5 #(
    .INIT(32'hFFAE00A2)) 
    \s_axis_V_dest_V_0_payload_A[0]_i_1 
       (.I0(s_axis_TDEST),
        .I1(\s_axis_V_dest_V_0_state_reg_n_0_[0] ),
        .I2(s_axis_TREADY),
        .I3(s_axis_V_dest_V_0_sel_wr),
        .I4(s_axis_V_dest_V_0_payload_A),
        .O(\s_axis_V_dest_V_0_payload_A[0]_i_1_n_0 ));
  FDRE \s_axis_V_dest_V_0_payload_A_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\s_axis_V_dest_V_0_payload_A[0]_i_1_n_0 ),
        .Q(s_axis_V_dest_V_0_payload_A),
        .R(1'b0));
  LUT5 #(
    .INIT(32'hBBFB8808)) 
    \s_axis_V_dest_V_0_payload_B[0]_i_1 
       (.I0(s_axis_TDEST),
        .I1(s_axis_V_dest_V_0_sel_wr),
        .I2(\s_axis_V_dest_V_0_state_reg_n_0_[0] ),
        .I3(s_axis_TREADY),
        .I4(s_axis_V_dest_V_0_payload_B),
        .O(\s_axis_V_dest_V_0_payload_B[0]_i_1_n_0 ));
  FDRE \s_axis_V_dest_V_0_payload_B_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\s_axis_V_dest_V_0_payload_B[0]_i_1_n_0 ),
        .Q(s_axis_V_dest_V_0_payload_B),
        .R(1'b0));
  LUT3 #(
    .INIT(8'hB4)) 
    s_axis_V_dest_V_0_sel_rd_i_1
       (.I0(ap_block_pp0_stage0_11001),
        .I1(\s_axis_V_dest_V_0_state_reg_n_0_[0] ),
        .I2(s_axis_V_dest_V_0_sel),
        .O(s_axis_V_dest_V_0_sel_rd_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    s_axis_V_dest_V_0_sel_rd_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(s_axis_V_dest_V_0_sel_rd_i_1_n_0),
        .Q(s_axis_V_dest_V_0_sel),
        .R(ap_rst_n_inv));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT3 #(
    .INIT(8'h78)) 
    s_axis_V_dest_V_0_sel_wr_i_1
       (.I0(s_axis_TVALID),
        .I1(s_axis_TREADY),
        .I2(s_axis_V_dest_V_0_sel_wr),
        .O(s_axis_V_dest_V_0_sel_wr_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    s_axis_V_dest_V_0_sel_wr_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(s_axis_V_dest_V_0_sel_wr_i_1_n_0),
        .Q(s_axis_V_dest_V_0_sel_wr),
        .R(ap_rst_n_inv));
  LUT5 #(
    .INIT(32'hA888A808)) 
    \s_axis_V_dest_V_0_state[0]_i_1 
       (.I0(ap_rst_n),
        .I1(\s_axis_V_dest_V_0_state_reg_n_0_[0] ),
        .I2(s_axis_TREADY),
        .I3(s_axis_TVALID),
        .I4(ap_block_pp0_stage0_11001),
        .O(\s_axis_V_dest_V_0_state[0]_i_1_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \s_axis_V_dest_V_0_state[1]_i_1 
       (.I0(ap_rst_n),
        .O(ap_rst_n_inv));
  LUT5 #(
    .INIT(32'h0F080808)) 
    \s_axis_V_dest_V_0_state[1]_i_10 
       (.I0(\m_axis_V_strb_V_1_state_reg_n_0_[0] ),
        .I1(m_axis_V_strb_V_1_ack_in),
        .I2(m_axis_TREADY),
        .I3(\m_axis_V_user_V_1_state_reg_n_0_[0] ),
        .I4(m_axis_V_user_V_1_ack_in),
        .O(\s_axis_V_dest_V_0_state[1]_i_10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \s_axis_V_dest_V_0_state[1]_i_11 
       (.I0(\m_axis_V_last_V_1_state_reg_n_0_[0] ),
        .I1(m_axis_V_last_V_1_ack_in),
        .O(\s_axis_V_dest_V_0_state[1]_i_11_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT4 #(
    .INIT(16'h75FF)) 
    \s_axis_V_dest_V_0_state[1]_i_2 
       (.I0(ap_block_pp0_stage0_11001),
        .I1(s_axis_TVALID),
        .I2(s_axis_TREADY),
        .I3(\s_axis_V_dest_V_0_state_reg_n_0_[0] ),
        .O(\s_axis_V_dest_V_0_state[1]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hAAA8FFFFFFFFFFFF)) 
    \s_axis_V_dest_V_0_state[1]_i_3 
       (.I0(ap_enable_reg_pp0_iter1),
        .I1(\s_axis_V_dest_V_0_state[1]_i_4_n_0 ),
        .I2(\s_axis_V_dest_V_0_state[1]_i_5_n_0 ),
        .I3(\s_axis_V_dest_V_0_state[1]_i_6_n_0 ),
        .I4(\s_axis_V_data_V_0_state_reg_n_0_[0] ),
        .I5(m_axis_V_data_V_1_ack_in),
        .O(ap_block_pp0_stage0_11001));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFF32)) 
    \s_axis_V_dest_V_0_state[1]_i_4 
       (.I0(p_0_in58_in),
        .I1(m_axis_TREADY),
        .I2(p_1_in43_in),
        .I3(\m_axis_V_dest_V_1_payload_A[0]_i_2_n_0 ),
        .I4(\s_axis_V_dest_V_0_state[1]_i_9_n_0 ),
        .I5(\s_axis_V_dest_V_0_state[1]_i_10_n_0 ),
        .O(\s_axis_V_dest_V_0_state[1]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFF22F2)) 
    \s_axis_V_dest_V_0_state[1]_i_5 
       (.I0(\m_axis_V_user_V_1_state_reg_n_0_[0] ),
        .I1(m_axis_V_user_V_1_ack_in),
        .I2(\m_axis_V_strb_V_1_state_reg_n_0_[0] ),
        .I3(m_axis_V_strb_V_1_ack_in),
        .I4(\m_axis_V_id_V_1_payload_A[0]_i_2_n_0 ),
        .I5(\s_axis_V_dest_V_0_state[1]_i_11_n_0 ),
        .O(\s_axis_V_dest_V_0_state[1]_i_5_n_0 ));
  LUT5 #(
    .INIT(32'hFF08FFFF)) 
    \s_axis_V_dest_V_0_state[1]_i_6 
       (.I0(m_axis_V_dest_V_1_ack_in),
        .I1(m_axis_TVALID),
        .I2(m_axis_TREADY),
        .I3(\m_axis_V_keep_V_1_payload_A[0]_i_2_n_0 ),
        .I4(m_axis_V_data_V_1_ack_in),
        .O(\s_axis_V_dest_V_0_state[1]_i_6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \s_axis_V_dest_V_0_state[1]_i_7 
       (.I0(\m_axis_V_data_V_1_state_reg_n_0_[0] ),
        .I1(m_axis_V_data_V_1_ack_in),
        .O(p_0_in58_in));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \s_axis_V_dest_V_0_state[1]_i_8 
       (.I0(\m_axis_V_keep_V_1_state_reg_n_0_[0] ),
        .I1(m_axis_V_keep_V_1_ack_in),
        .O(p_1_in43_in));
  LUT5 #(
    .INIT(32'h0F080808)) 
    \s_axis_V_dest_V_0_state[1]_i_9 
       (.I0(\m_axis_V_last_V_1_state_reg_n_0_[0] ),
        .I1(m_axis_V_last_V_1_ack_in),
        .I2(m_axis_TREADY),
        .I3(\m_axis_V_id_V_1_state_reg_n_0_[0] ),
        .I4(m_axis_V_id_V_1_ack_in),
        .O(\s_axis_V_dest_V_0_state[1]_i_9_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \s_axis_V_dest_V_0_state_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\s_axis_V_dest_V_0_state[0]_i_1_n_0 ),
        .Q(\s_axis_V_dest_V_0_state_reg_n_0_[0] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \s_axis_V_dest_V_0_state_reg[1] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\s_axis_V_dest_V_0_state[1]_i_2_n_0 ),
        .Q(s_axis_TREADY),
        .R(ap_rst_n_inv));
  LUT5 #(
    .INIT(32'hFFAE00A2)) 
    \s_axis_V_id_V_0_payload_A[0]_i_1 
       (.I0(s_axis_TID),
        .I1(\s_axis_V_id_V_0_state_reg_n_0_[0] ),
        .I2(s_axis_V_id_V_0_ack_in),
        .I3(s_axis_V_id_V_0_sel_wr),
        .I4(s_axis_V_id_V_0_payload_A),
        .O(\s_axis_V_id_V_0_payload_A[0]_i_1_n_0 ));
  FDRE \s_axis_V_id_V_0_payload_A_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\s_axis_V_id_V_0_payload_A[0]_i_1_n_0 ),
        .Q(s_axis_V_id_V_0_payload_A),
        .R(1'b0));
  LUT5 #(
    .INIT(32'hBBFB8808)) 
    \s_axis_V_id_V_0_payload_B[0]_i_1 
       (.I0(s_axis_TID),
        .I1(s_axis_V_id_V_0_sel_wr),
        .I2(\s_axis_V_id_V_0_state_reg_n_0_[0] ),
        .I3(s_axis_V_id_V_0_ack_in),
        .I4(s_axis_V_id_V_0_payload_B),
        .O(\s_axis_V_id_V_0_payload_B[0]_i_1_n_0 ));
  FDRE \s_axis_V_id_V_0_payload_B_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\s_axis_V_id_V_0_payload_B[0]_i_1_n_0 ),
        .Q(s_axis_V_id_V_0_payload_B),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair21" *) 
  LUT3 #(
    .INIT(8'hB4)) 
    s_axis_V_id_V_0_sel_rd_i_1
       (.I0(ap_block_pp0_stage0_11001),
        .I1(\s_axis_V_id_V_0_state_reg_n_0_[0] ),
        .I2(s_axis_V_id_V_0_sel),
        .O(s_axis_V_id_V_0_sel_rd_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    s_axis_V_id_V_0_sel_rd_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(s_axis_V_id_V_0_sel_rd_i_1_n_0),
        .Q(s_axis_V_id_V_0_sel),
        .R(ap_rst_n_inv));
  (* SOFT_HLUTNM = "soft_lutpair16" *) 
  LUT3 #(
    .INIT(8'h78)) 
    s_axis_V_id_V_0_sel_wr_i_1
       (.I0(s_axis_TVALID),
        .I1(s_axis_V_id_V_0_ack_in),
        .I2(s_axis_V_id_V_0_sel_wr),
        .O(s_axis_V_id_V_0_sel_wr_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    s_axis_V_id_V_0_sel_wr_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(s_axis_V_id_V_0_sel_wr_i_1_n_0),
        .Q(s_axis_V_id_V_0_sel_wr),
        .R(ap_rst_n_inv));
  LUT5 #(
    .INIT(32'hA888A808)) 
    \s_axis_V_id_V_0_state[0]_i_1 
       (.I0(ap_rst_n),
        .I1(\s_axis_V_id_V_0_state_reg_n_0_[0] ),
        .I2(s_axis_V_id_V_0_ack_in),
        .I3(s_axis_TVALID),
        .I4(ap_block_pp0_stage0_11001),
        .O(\s_axis_V_id_V_0_state[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair16" *) 
  LUT4 #(
    .INIT(16'h75FF)) 
    \s_axis_V_id_V_0_state[1]_i_1 
       (.I0(ap_block_pp0_stage0_11001),
        .I1(s_axis_TVALID),
        .I2(s_axis_V_id_V_0_ack_in),
        .I3(\s_axis_V_id_V_0_state_reg_n_0_[0] ),
        .O(\s_axis_V_id_V_0_state[1]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \s_axis_V_id_V_0_state_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\s_axis_V_id_V_0_state[0]_i_1_n_0 ),
        .Q(\s_axis_V_id_V_0_state_reg_n_0_[0] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \s_axis_V_id_V_0_state_reg[1] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\s_axis_V_id_V_0_state[1]_i_1_n_0 ),
        .Q(s_axis_V_id_V_0_ack_in),
        .R(ap_rst_n_inv));
  LUT5 #(
    .INIT(32'hFFAE00A2)) 
    \s_axis_V_keep_V_0_payload_A[0]_i_1 
       (.I0(s_axis_TKEEP),
        .I1(\s_axis_V_keep_V_0_state_reg_n_0_[0] ),
        .I2(s_axis_V_keep_V_0_ack_in),
        .I3(s_axis_V_keep_V_0_sel_wr),
        .I4(s_axis_V_keep_V_0_payload_A),
        .O(\s_axis_V_keep_V_0_payload_A[0]_i_1_n_0 ));
  FDRE \s_axis_V_keep_V_0_payload_A_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\s_axis_V_keep_V_0_payload_A[0]_i_1_n_0 ),
        .Q(s_axis_V_keep_V_0_payload_A),
        .R(1'b0));
  LUT5 #(
    .INIT(32'hBBFB8808)) 
    \s_axis_V_keep_V_0_payload_B[0]_i_1 
       (.I0(s_axis_TKEEP),
        .I1(s_axis_V_keep_V_0_sel_wr),
        .I2(\s_axis_V_keep_V_0_state_reg_n_0_[0] ),
        .I3(s_axis_V_keep_V_0_ack_in),
        .I4(s_axis_V_keep_V_0_payload_B),
        .O(\s_axis_V_keep_V_0_payload_B[0]_i_1_n_0 ));
  FDRE \s_axis_V_keep_V_0_payload_B_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\s_axis_V_keep_V_0_payload_B[0]_i_1_n_0 ),
        .Q(s_axis_V_keep_V_0_payload_B),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair20" *) 
  LUT3 #(
    .INIT(8'hB4)) 
    s_axis_V_keep_V_0_sel_rd_i_1
       (.I0(ap_block_pp0_stage0_11001),
        .I1(\s_axis_V_keep_V_0_state_reg_n_0_[0] ),
        .I2(s_axis_V_keep_V_0_sel),
        .O(s_axis_V_keep_V_0_sel_rd_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    s_axis_V_keep_V_0_sel_rd_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(s_axis_V_keep_V_0_sel_rd_i_1_n_0),
        .Q(s_axis_V_keep_V_0_sel),
        .R(ap_rst_n_inv));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT3 #(
    .INIT(8'h78)) 
    s_axis_V_keep_V_0_sel_wr_i_1
       (.I0(s_axis_TVALID),
        .I1(s_axis_V_keep_V_0_ack_in),
        .I2(s_axis_V_keep_V_0_sel_wr),
        .O(s_axis_V_keep_V_0_sel_wr_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    s_axis_V_keep_V_0_sel_wr_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(s_axis_V_keep_V_0_sel_wr_i_1_n_0),
        .Q(s_axis_V_keep_V_0_sel_wr),
        .R(ap_rst_n_inv));
  LUT5 #(
    .INIT(32'hA8AAA000)) 
    \s_axis_V_keep_V_0_state[0]_i_1 
       (.I0(ap_rst_n),
        .I1(ap_block_pp0_stage0_11001),
        .I2(s_axis_TVALID),
        .I3(s_axis_V_keep_V_0_ack_in),
        .I4(\s_axis_V_keep_V_0_state_reg_n_0_[0] ),
        .O(\s_axis_V_keep_V_0_state[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT4 #(
    .INIT(16'h75FF)) 
    \s_axis_V_keep_V_0_state[1]_i_1 
       (.I0(ap_block_pp0_stage0_11001),
        .I1(s_axis_TVALID),
        .I2(s_axis_V_keep_V_0_ack_in),
        .I3(\s_axis_V_keep_V_0_state_reg_n_0_[0] ),
        .O(\s_axis_V_keep_V_0_state[1]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \s_axis_V_keep_V_0_state_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\s_axis_V_keep_V_0_state[0]_i_1_n_0 ),
        .Q(\s_axis_V_keep_V_0_state_reg_n_0_[0] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \s_axis_V_keep_V_0_state_reg[1] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\s_axis_V_keep_V_0_state[1]_i_1_n_0 ),
        .Q(s_axis_V_keep_V_0_ack_in),
        .R(ap_rst_n_inv));
  LUT5 #(
    .INIT(32'hFFAE00A2)) 
    \s_axis_V_last_V_0_payload_A[0]_i_1 
       (.I0(s_axis_TLAST),
        .I1(\s_axis_V_last_V_0_state_reg_n_0_[0] ),
        .I2(s_axis_V_last_V_0_ack_in),
        .I3(s_axis_V_last_V_0_sel_wr),
        .I4(s_axis_V_last_V_0_payload_A),
        .O(\s_axis_V_last_V_0_payload_A[0]_i_1_n_0 ));
  FDRE \s_axis_V_last_V_0_payload_A_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\s_axis_V_last_V_0_payload_A[0]_i_1_n_0 ),
        .Q(s_axis_V_last_V_0_payload_A),
        .R(1'b0));
  LUT5 #(
    .INIT(32'hBBFB8808)) 
    \s_axis_V_last_V_0_payload_B[0]_i_1 
       (.I0(s_axis_TLAST),
        .I1(s_axis_V_last_V_0_sel_wr),
        .I2(\s_axis_V_last_V_0_state_reg_n_0_[0] ),
        .I3(s_axis_V_last_V_0_ack_in),
        .I4(s_axis_V_last_V_0_payload_B),
        .O(\s_axis_V_last_V_0_payload_B[0]_i_1_n_0 ));
  FDRE \s_axis_V_last_V_0_payload_B_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\s_axis_V_last_V_0_payload_B[0]_i_1_n_0 ),
        .Q(s_axis_V_last_V_0_payload_B),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair22" *) 
  LUT3 #(
    .INIT(8'hB4)) 
    s_axis_V_last_V_0_sel_rd_i_1
       (.I0(ap_block_pp0_stage0_11001),
        .I1(\s_axis_V_last_V_0_state_reg_n_0_[0] ),
        .I2(s_axis_V_last_V_0_sel),
        .O(s_axis_V_last_V_0_sel_rd_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    s_axis_V_last_V_0_sel_rd_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(s_axis_V_last_V_0_sel_rd_i_1_n_0),
        .Q(s_axis_V_last_V_0_sel),
        .R(ap_rst_n_inv));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT3 #(
    .INIT(8'h78)) 
    s_axis_V_last_V_0_sel_wr_i_1
       (.I0(s_axis_TVALID),
        .I1(s_axis_V_last_V_0_ack_in),
        .I2(s_axis_V_last_V_0_sel_wr),
        .O(s_axis_V_last_V_0_sel_wr_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    s_axis_V_last_V_0_sel_wr_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(s_axis_V_last_V_0_sel_wr_i_1_n_0),
        .Q(s_axis_V_last_V_0_sel_wr),
        .R(ap_rst_n_inv));
  LUT5 #(
    .INIT(32'hA888A808)) 
    \s_axis_V_last_V_0_state[0]_i_1 
       (.I0(ap_rst_n),
        .I1(\s_axis_V_last_V_0_state_reg_n_0_[0] ),
        .I2(s_axis_V_last_V_0_ack_in),
        .I3(s_axis_TVALID),
        .I4(ap_block_pp0_stage0_11001),
        .O(\s_axis_V_last_V_0_state[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT4 #(
    .INIT(16'h75FF)) 
    \s_axis_V_last_V_0_state[1]_i_1 
       (.I0(ap_block_pp0_stage0_11001),
        .I1(s_axis_TVALID),
        .I2(s_axis_V_last_V_0_ack_in),
        .I3(\s_axis_V_last_V_0_state_reg_n_0_[0] ),
        .O(\s_axis_V_last_V_0_state[1]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \s_axis_V_last_V_0_state_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\s_axis_V_last_V_0_state[0]_i_1_n_0 ),
        .Q(\s_axis_V_last_V_0_state_reg_n_0_[0] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \s_axis_V_last_V_0_state_reg[1] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\s_axis_V_last_V_0_state[1]_i_1_n_0 ),
        .Q(s_axis_V_last_V_0_ack_in),
        .R(ap_rst_n_inv));
  LUT5 #(
    .INIT(32'hFFAE00A2)) 
    \s_axis_V_strb_V_0_payload_A[0]_i_1 
       (.I0(s_axis_TSTRB),
        .I1(\s_axis_V_strb_V_0_state_reg_n_0_[0] ),
        .I2(s_axis_V_strb_V_0_ack_in),
        .I3(s_axis_V_strb_V_0_sel_wr),
        .I4(s_axis_V_strb_V_0_payload_A),
        .O(\s_axis_V_strb_V_0_payload_A[0]_i_1_n_0 ));
  FDRE \s_axis_V_strb_V_0_payload_A_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\s_axis_V_strb_V_0_payload_A[0]_i_1_n_0 ),
        .Q(s_axis_V_strb_V_0_payload_A),
        .R(1'b0));
  LUT5 #(
    .INIT(32'hBBFB8808)) 
    \s_axis_V_strb_V_0_payload_B[0]_i_1 
       (.I0(s_axis_TSTRB),
        .I1(s_axis_V_strb_V_0_sel_wr),
        .I2(\s_axis_V_strb_V_0_state_reg_n_0_[0] ),
        .I3(s_axis_V_strb_V_0_ack_in),
        .I4(s_axis_V_strb_V_0_payload_B),
        .O(\s_axis_V_strb_V_0_payload_B[0]_i_1_n_0 ));
  FDRE \s_axis_V_strb_V_0_payload_B_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\s_axis_V_strb_V_0_payload_B[0]_i_1_n_0 ),
        .Q(s_axis_V_strb_V_0_payload_B),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair24" *) 
  LUT3 #(
    .INIT(8'hB4)) 
    s_axis_V_strb_V_0_sel_rd_i_1
       (.I0(ap_block_pp0_stage0_11001),
        .I1(\s_axis_V_strb_V_0_state_reg_n_0_[0] ),
        .I2(s_axis_V_strb_V_0_sel),
        .O(s_axis_V_strb_V_0_sel_rd_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    s_axis_V_strb_V_0_sel_rd_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(s_axis_V_strb_V_0_sel_rd_i_1_n_0),
        .Q(s_axis_V_strb_V_0_sel),
        .R(ap_rst_n_inv));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT3 #(
    .INIT(8'h78)) 
    s_axis_V_strb_V_0_sel_wr_i_1
       (.I0(s_axis_TVALID),
        .I1(s_axis_V_strb_V_0_ack_in),
        .I2(s_axis_V_strb_V_0_sel_wr),
        .O(s_axis_V_strb_V_0_sel_wr_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    s_axis_V_strb_V_0_sel_wr_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(s_axis_V_strb_V_0_sel_wr_i_1_n_0),
        .Q(s_axis_V_strb_V_0_sel_wr),
        .R(ap_rst_n_inv));
  LUT5 #(
    .INIT(32'hA888A808)) 
    \s_axis_V_strb_V_0_state[0]_i_1 
       (.I0(ap_rst_n),
        .I1(\s_axis_V_strb_V_0_state_reg_n_0_[0] ),
        .I2(s_axis_V_strb_V_0_ack_in),
        .I3(s_axis_TVALID),
        .I4(ap_block_pp0_stage0_11001),
        .O(\s_axis_V_strb_V_0_state[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT4 #(
    .INIT(16'h75FF)) 
    \s_axis_V_strb_V_0_state[1]_i_1 
       (.I0(ap_block_pp0_stage0_11001),
        .I1(s_axis_TVALID),
        .I2(s_axis_V_strb_V_0_ack_in),
        .I3(\s_axis_V_strb_V_0_state_reg_n_0_[0] ),
        .O(\s_axis_V_strb_V_0_state[1]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \s_axis_V_strb_V_0_state_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\s_axis_V_strb_V_0_state[0]_i_1_n_0 ),
        .Q(\s_axis_V_strb_V_0_state_reg_n_0_[0] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \s_axis_V_strb_V_0_state_reg[1] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\s_axis_V_strb_V_0_state[1]_i_1_n_0 ),
        .Q(s_axis_V_strb_V_0_ack_in),
        .R(ap_rst_n_inv));
  LUT5 #(
    .INIT(32'hFFAE00A2)) 
    \s_axis_V_user_V_0_payload_A[0]_i_1 
       (.I0(s_axis_TUSER),
        .I1(\s_axis_V_user_V_0_state_reg_n_0_[0] ),
        .I2(s_axis_V_user_V_0_ack_in),
        .I3(s_axis_V_user_V_0_sel_wr),
        .I4(s_axis_V_user_V_0_payload_A),
        .O(\s_axis_V_user_V_0_payload_A[0]_i_1_n_0 ));
  FDRE \s_axis_V_user_V_0_payload_A_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\s_axis_V_user_V_0_payload_A[0]_i_1_n_0 ),
        .Q(s_axis_V_user_V_0_payload_A),
        .R(1'b0));
  LUT5 #(
    .INIT(32'hBBFB8808)) 
    \s_axis_V_user_V_0_payload_B[0]_i_1 
       (.I0(s_axis_TUSER),
        .I1(s_axis_V_user_V_0_sel_wr),
        .I2(\s_axis_V_user_V_0_state_reg_n_0_[0] ),
        .I3(s_axis_V_user_V_0_ack_in),
        .I4(s_axis_V_user_V_0_payload_B),
        .O(\s_axis_V_user_V_0_payload_B[0]_i_1_n_0 ));
  FDRE \s_axis_V_user_V_0_payload_B_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\s_axis_V_user_V_0_payload_B[0]_i_1_n_0 ),
        .Q(s_axis_V_user_V_0_payload_B),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair26" *) 
  LUT3 #(
    .INIT(8'hB4)) 
    s_axis_V_user_V_0_sel_rd_i_1
       (.I0(ap_block_pp0_stage0_11001),
        .I1(\s_axis_V_user_V_0_state_reg_n_0_[0] ),
        .I2(s_axis_V_user_V_0_sel),
        .O(s_axis_V_user_V_0_sel_rd_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    s_axis_V_user_V_0_sel_rd_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(s_axis_V_user_V_0_sel_rd_i_1_n_0),
        .Q(s_axis_V_user_V_0_sel),
        .R(ap_rst_n_inv));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT3 #(
    .INIT(8'h78)) 
    s_axis_V_user_V_0_sel_wr_i_1
       (.I0(s_axis_V_user_V_0_ack_in),
        .I1(s_axis_TVALID),
        .I2(s_axis_V_user_V_0_sel_wr),
        .O(s_axis_V_user_V_0_sel_wr_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    s_axis_V_user_V_0_sel_wr_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(s_axis_V_user_V_0_sel_wr_i_1_n_0),
        .Q(s_axis_V_user_V_0_sel_wr),
        .R(ap_rst_n_inv));
  LUT5 #(
    .INIT(32'hA888A808)) 
    \s_axis_V_user_V_0_state[0]_i_1 
       (.I0(ap_rst_n),
        .I1(\s_axis_V_user_V_0_state_reg_n_0_[0] ),
        .I2(s_axis_V_user_V_0_ack_in),
        .I3(s_axis_TVALID),
        .I4(ap_block_pp0_stage0_11001),
        .O(\s_axis_V_user_V_0_state[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT4 #(
    .INIT(16'h75FF)) 
    \s_axis_V_user_V_0_state[1]_i_1 
       (.I0(ap_block_pp0_stage0_11001),
        .I1(s_axis_TVALID),
        .I2(s_axis_V_user_V_0_ack_in),
        .I3(\s_axis_V_user_V_0_state_reg_n_0_[0] ),
        .O(\s_axis_V_user_V_0_state[1]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \s_axis_V_user_V_0_state_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\s_axis_V_user_V_0_state[0]_i_1_n_0 ),
        .Q(\s_axis_V_user_V_0_state_reg_n_0_[0] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \s_axis_V_user_V_0_state_reg[1] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\s_axis_V_user_V_0_state[1]_i_1_n_0 ),
        .Q(s_axis_V_user_V_0_ack_in),
        .R(ap_rst_n_inv));
endmodule

(* CHECK_LICENSE_TYPE = "cubeocc_hls_0,cubeocc_hls,{}" *) (* DowngradeIPIdentifiedWarnings = "yes" *) (* IP_DEFINITION_SOURCE = "HLS" *) 
(* X_CORE_INFO = "cubeocc_hls,Vivado 2019.1" *) (* hls_module = "yes" *) 
(* NotValidForBitStream *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix
   (ap_clk,
    ap_rst_n,
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
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 ap_clk CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME ap_clk, ASSOCIATED_BUSIF s_axis:m_axis, ASSOCIATED_RESET ap_rst_n, FREQ_HZ 100000000, PHASE 0.000, INSERT_VIP 0" *) input ap_clk;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 ap_rst_n RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME ap_rst_n, POLARITY ACTIVE_LOW, INSERT_VIP 0" *) input ap_rst_n;
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
  wire [7:0]m_axis_TDATA;
  wire [0:0]m_axis_TDEST;
  wire [0:0]m_axis_TID;
  wire [0:0]m_axis_TKEEP;
  wire [0:0]m_axis_TLAST;
  wire m_axis_TREADY;
  wire [0:0]m_axis_TSTRB;
  wire [0:0]m_axis_TUSER;
  wire m_axis_TVALID;
  wire [7:0]s_axis_TDATA;
  wire [0:0]s_axis_TDEST;
  wire [0:0]s_axis_TID;
  wire [0:0]s_axis_TKEEP;
  wire [0:0]s_axis_TLAST;
  wire s_axis_TREADY;
  wire [0:0]s_axis_TSTRB;
  wire [0:0]s_axis_TUSER;
  wire s_axis_TVALID;

  (* ap_ST_fsm_pp0_stage0 = "1'b1" *) 
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_cubeocc_hls inst
       (.ap_clk(ap_clk),
        .ap_rst_n(ap_rst_n),
        .m_axis_TDATA(m_axis_TDATA),
        .m_axis_TDEST(m_axis_TDEST),
        .m_axis_TID(m_axis_TID),
        .m_axis_TKEEP(m_axis_TKEEP),
        .m_axis_TLAST(m_axis_TLAST),
        .m_axis_TREADY(m_axis_TREADY),
        .m_axis_TSTRB(m_axis_TSTRB),
        .m_axis_TUSER(m_axis_TUSER),
        .m_axis_TVALID(m_axis_TVALID),
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
