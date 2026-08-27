-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
-- Date        : Thu Aug 27 17:03:56 2026
-- Host        : DESKTOP-RQHJO7S running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode funcsim
--               D:/occ_project/CubeOCC/vivado/CubeOCC/CubeOCC.srcs/sources_1/ip/cubeocc_hls_0/cubeocc_hls_0_sim_netlist.vhdl
-- Design      : cubeocc_hls_0
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7a35tcpg236-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity cubeocc_hls_0_cubeocc_hls is
  port (
    ap_clk : in STD_LOGIC;
    ap_rst_n : in STD_LOGIC;
    s_axis_TDATA : in STD_LOGIC_VECTOR ( 7 downto 0 );
    s_axis_TVALID : in STD_LOGIC;
    s_axis_TREADY : out STD_LOGIC;
    s_axis_TKEEP : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axis_TSTRB : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axis_TUSER : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axis_TLAST : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axis_TID : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axis_TDEST : in STD_LOGIC_VECTOR ( 0 to 0 );
    m_axis_TDATA : out STD_LOGIC_VECTOR ( 7 downto 0 );
    m_axis_TVALID : out STD_LOGIC;
    m_axis_TREADY : in STD_LOGIC;
    m_axis_TKEEP : out STD_LOGIC_VECTOR ( 0 to 0 );
    m_axis_TSTRB : out STD_LOGIC_VECTOR ( 0 to 0 );
    m_axis_TUSER : out STD_LOGIC_VECTOR ( 0 to 0 );
    m_axis_TLAST : out STD_LOGIC_VECTOR ( 0 to 0 );
    m_axis_TID : out STD_LOGIC_VECTOR ( 0 to 0 );
    m_axis_TDEST : out STD_LOGIC_VECTOR ( 0 to 0 )
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of cubeocc_hls_0_cubeocc_hls : entity is "cubeocc_hls";
  attribute ap_ST_fsm_pp0_stage0 : string;
  attribute ap_ST_fsm_pp0_stage0 of cubeocc_hls_0_cubeocc_hls : entity is "1'b1";
  attribute hls_module : string;
  attribute hls_module of cubeocc_hls_0_cubeocc_hls : entity is "yes";
end cubeocc_hls_0_cubeocc_hls;

architecture STRUCTURE of cubeocc_hls_0_cubeocc_hls is
  signal ap_block_pp0_stage0_11001 : STD_LOGIC;
  signal ap_enable_reg_pp0_iter1 : STD_LOGIC;
  signal ap_enable_reg_pp0_iter1_i_1_n_0 : STD_LOGIC;
  signal ap_phi_mux_tmp_last_V_1_phi_fu_165_p61_out : STD_LOGIC;
  signal ap_rst_n_inv : STD_LOGIC;
  signal \^m_axis_tvalid\ : STD_LOGIC;
  signal m_axis_V_data_V_1_ack_in : STD_LOGIC;
  signal m_axis_V_data_V_1_load_B : STD_LOGIC;
  signal m_axis_V_data_V_1_payload_A : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal \m_axis_V_data_V_1_payload_A[7]_i_1_n_0\ : STD_LOGIC;
  signal m_axis_V_data_V_1_payload_B : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal m_axis_V_data_V_1_sel : STD_LOGIC;
  signal m_axis_V_data_V_1_sel_rd_i_1_n_0 : STD_LOGIC;
  signal m_axis_V_data_V_1_sel_wr : STD_LOGIC;
  signal m_axis_V_data_V_1_sel_wr_i_1_n_0 : STD_LOGIC;
  signal \m_axis_V_data_V_1_state[0]_i_1_n_0\ : STD_LOGIC;
  signal \m_axis_V_data_V_1_state[1]_i_1_n_0\ : STD_LOGIC;
  signal \m_axis_V_data_V_1_state_reg_n_0_[0]\ : STD_LOGIC;
  signal m_axis_V_dest_V_1_ack_in : STD_LOGIC;
  signal m_axis_V_dest_V_1_payload_A : STD_LOGIC;
  signal \m_axis_V_dest_V_1_payload_A[0]_i_1_n_0\ : STD_LOGIC;
  signal \m_axis_V_dest_V_1_payload_A[0]_i_2_n_0\ : STD_LOGIC;
  signal m_axis_V_dest_V_1_payload_B : STD_LOGIC;
  signal \m_axis_V_dest_V_1_payload_B[0]_i_1_n_0\ : STD_LOGIC;
  signal m_axis_V_dest_V_1_sel : STD_LOGIC;
  signal m_axis_V_dest_V_1_sel_rd_i_1_n_0 : STD_LOGIC;
  signal m_axis_V_dest_V_1_sel_wr : STD_LOGIC;
  signal m_axis_V_dest_V_1_sel_wr_i_1_n_0 : STD_LOGIC;
  signal \m_axis_V_dest_V_1_state[0]_i_1_n_0\ : STD_LOGIC;
  signal \m_axis_V_dest_V_1_state[1]_i_1_n_0\ : STD_LOGIC;
  signal m_axis_V_id_V_1_ack_in : STD_LOGIC;
  signal m_axis_V_id_V_1_payload_A : STD_LOGIC;
  signal \m_axis_V_id_V_1_payload_A[0]_i_1_n_0\ : STD_LOGIC;
  signal \m_axis_V_id_V_1_payload_A[0]_i_2_n_0\ : STD_LOGIC;
  signal m_axis_V_id_V_1_payload_B : STD_LOGIC;
  signal \m_axis_V_id_V_1_payload_B[0]_i_1_n_0\ : STD_LOGIC;
  signal m_axis_V_id_V_1_sel : STD_LOGIC;
  signal m_axis_V_id_V_1_sel_rd_i_1_n_0 : STD_LOGIC;
  signal m_axis_V_id_V_1_sel_wr : STD_LOGIC;
  signal m_axis_V_id_V_1_sel_wr_i_1_n_0 : STD_LOGIC;
  signal \m_axis_V_id_V_1_state[0]_i_1_n_0\ : STD_LOGIC;
  signal \m_axis_V_id_V_1_state[1]_i_1_n_0\ : STD_LOGIC;
  signal \m_axis_V_id_V_1_state_reg_n_0_[0]\ : STD_LOGIC;
  signal m_axis_V_keep_V_1_ack_in : STD_LOGIC;
  signal m_axis_V_keep_V_1_payload_A : STD_LOGIC;
  signal \m_axis_V_keep_V_1_payload_A[0]_i_1_n_0\ : STD_LOGIC;
  signal \m_axis_V_keep_V_1_payload_A[0]_i_2_n_0\ : STD_LOGIC;
  signal m_axis_V_keep_V_1_payload_B : STD_LOGIC;
  signal \m_axis_V_keep_V_1_payload_B[0]_i_1_n_0\ : STD_LOGIC;
  signal m_axis_V_keep_V_1_sel : STD_LOGIC;
  signal m_axis_V_keep_V_1_sel_rd_i_1_n_0 : STD_LOGIC;
  signal m_axis_V_keep_V_1_sel_wr : STD_LOGIC;
  signal m_axis_V_keep_V_1_sel_wr_i_1_n_0 : STD_LOGIC;
  signal \m_axis_V_keep_V_1_state[0]_i_1_n_0\ : STD_LOGIC;
  signal \m_axis_V_keep_V_1_state[1]_i_1_n_0\ : STD_LOGIC;
  signal \m_axis_V_keep_V_1_state_reg_n_0_[0]\ : STD_LOGIC;
  signal m_axis_V_last_V_1_ack_in : STD_LOGIC;
  signal m_axis_V_last_V_1_payload_A : STD_LOGIC;
  signal \m_axis_V_last_V_1_payload_A[0]_i_1_n_0\ : STD_LOGIC;
  signal m_axis_V_last_V_1_payload_B : STD_LOGIC;
  signal \m_axis_V_last_V_1_payload_B[0]_i_1_n_0\ : STD_LOGIC;
  signal m_axis_V_last_V_1_sel : STD_LOGIC;
  signal m_axis_V_last_V_1_sel_rd_i_1_n_0 : STD_LOGIC;
  signal m_axis_V_last_V_1_sel_wr : STD_LOGIC;
  signal m_axis_V_last_V_1_sel_wr_i_1_n_0 : STD_LOGIC;
  signal \m_axis_V_last_V_1_state[0]_i_1_n_0\ : STD_LOGIC;
  signal \m_axis_V_last_V_1_state[1]_i_1_n_0\ : STD_LOGIC;
  signal \m_axis_V_last_V_1_state_reg_n_0_[0]\ : STD_LOGIC;
  signal m_axis_V_strb_V_1_ack_in : STD_LOGIC;
  signal m_axis_V_strb_V_1_payload_A : STD_LOGIC;
  signal \m_axis_V_strb_V_1_payload_A[0]_i_1_n_0\ : STD_LOGIC;
  signal \m_axis_V_strb_V_1_payload_A[0]_i_2_n_0\ : STD_LOGIC;
  signal m_axis_V_strb_V_1_payload_B : STD_LOGIC;
  signal \m_axis_V_strb_V_1_payload_B[0]_i_1_n_0\ : STD_LOGIC;
  signal m_axis_V_strb_V_1_sel : STD_LOGIC;
  signal m_axis_V_strb_V_1_sel_rd_i_1_n_0 : STD_LOGIC;
  signal m_axis_V_strb_V_1_sel_wr : STD_LOGIC;
  signal m_axis_V_strb_V_1_sel_wr_i_1_n_0 : STD_LOGIC;
  signal \m_axis_V_strb_V_1_state[0]_i_1_n_0\ : STD_LOGIC;
  signal \m_axis_V_strb_V_1_state[1]_i_1_n_0\ : STD_LOGIC;
  signal \m_axis_V_strb_V_1_state_reg_n_0_[0]\ : STD_LOGIC;
  signal m_axis_V_user_V_1_ack_in : STD_LOGIC;
  signal m_axis_V_user_V_1_payload_A : STD_LOGIC;
  signal \m_axis_V_user_V_1_payload_A[0]_i_1_n_0\ : STD_LOGIC;
  signal m_axis_V_user_V_1_payload_B : STD_LOGIC;
  signal \m_axis_V_user_V_1_payload_B[0]_i_1_n_0\ : STD_LOGIC;
  signal m_axis_V_user_V_1_sel : STD_LOGIC;
  signal m_axis_V_user_V_1_sel_rd_i_1_n_0 : STD_LOGIC;
  signal m_axis_V_user_V_1_sel_wr : STD_LOGIC;
  signal m_axis_V_user_V_1_sel_wr_i_1_n_0 : STD_LOGIC;
  signal \m_axis_V_user_V_1_state[0]_i_1_n_0\ : STD_LOGIC;
  signal \m_axis_V_user_V_1_state[1]_i_1_n_0\ : STD_LOGIC;
  signal \m_axis_V_user_V_1_state_reg_n_0_[0]\ : STD_LOGIC;
  signal p_0_in58_in : STD_LOGIC;
  signal p_1_in43_in : STD_LOGIC;
  signal \^s_axis_tready\ : STD_LOGIC;
  signal s_axis_V_data_V_0_ack_in : STD_LOGIC;
  signal s_axis_V_data_V_0_data_out : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal s_axis_V_data_V_0_load_B : STD_LOGIC;
  signal s_axis_V_data_V_0_payload_A : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal \s_axis_V_data_V_0_payload_A[7]_i_1_n_0\ : STD_LOGIC;
  signal s_axis_V_data_V_0_payload_B : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal s_axis_V_data_V_0_sel : STD_LOGIC;
  signal s_axis_V_data_V_0_sel_rd_i_1_n_0 : STD_LOGIC;
  signal s_axis_V_data_V_0_sel_wr : STD_LOGIC;
  signal s_axis_V_data_V_0_sel_wr_i_1_n_0 : STD_LOGIC;
  signal \s_axis_V_data_V_0_state[0]_i_1_n_0\ : STD_LOGIC;
  signal \s_axis_V_data_V_0_state[1]_i_1_n_0\ : STD_LOGIC;
  signal \s_axis_V_data_V_0_state_reg_n_0_[0]\ : STD_LOGIC;
  signal s_axis_V_dest_V_0_payload_A : STD_LOGIC;
  signal \s_axis_V_dest_V_0_payload_A[0]_i_1_n_0\ : STD_LOGIC;
  signal s_axis_V_dest_V_0_payload_B : STD_LOGIC;
  signal \s_axis_V_dest_V_0_payload_B[0]_i_1_n_0\ : STD_LOGIC;
  signal s_axis_V_dest_V_0_sel : STD_LOGIC;
  signal s_axis_V_dest_V_0_sel_rd_i_1_n_0 : STD_LOGIC;
  signal s_axis_V_dest_V_0_sel_wr : STD_LOGIC;
  signal s_axis_V_dest_V_0_sel_wr_i_1_n_0 : STD_LOGIC;
  signal \s_axis_V_dest_V_0_state[0]_i_1_n_0\ : STD_LOGIC;
  signal \s_axis_V_dest_V_0_state[1]_i_10_n_0\ : STD_LOGIC;
  signal \s_axis_V_dest_V_0_state[1]_i_11_n_0\ : STD_LOGIC;
  signal \s_axis_V_dest_V_0_state[1]_i_2_n_0\ : STD_LOGIC;
  signal \s_axis_V_dest_V_0_state[1]_i_4_n_0\ : STD_LOGIC;
  signal \s_axis_V_dest_V_0_state[1]_i_5_n_0\ : STD_LOGIC;
  signal \s_axis_V_dest_V_0_state[1]_i_6_n_0\ : STD_LOGIC;
  signal \s_axis_V_dest_V_0_state[1]_i_9_n_0\ : STD_LOGIC;
  signal \s_axis_V_dest_V_0_state_reg_n_0_[0]\ : STD_LOGIC;
  signal s_axis_V_id_V_0_ack_in : STD_LOGIC;
  signal s_axis_V_id_V_0_payload_A : STD_LOGIC;
  signal \s_axis_V_id_V_0_payload_A[0]_i_1_n_0\ : STD_LOGIC;
  signal s_axis_V_id_V_0_payload_B : STD_LOGIC;
  signal \s_axis_V_id_V_0_payload_B[0]_i_1_n_0\ : STD_LOGIC;
  signal s_axis_V_id_V_0_sel : STD_LOGIC;
  signal s_axis_V_id_V_0_sel_rd_i_1_n_0 : STD_LOGIC;
  signal s_axis_V_id_V_0_sel_wr : STD_LOGIC;
  signal s_axis_V_id_V_0_sel_wr_i_1_n_0 : STD_LOGIC;
  signal \s_axis_V_id_V_0_state[0]_i_1_n_0\ : STD_LOGIC;
  signal \s_axis_V_id_V_0_state[1]_i_1_n_0\ : STD_LOGIC;
  signal \s_axis_V_id_V_0_state_reg_n_0_[0]\ : STD_LOGIC;
  signal s_axis_V_keep_V_0_ack_in : STD_LOGIC;
  signal s_axis_V_keep_V_0_payload_A : STD_LOGIC;
  signal \s_axis_V_keep_V_0_payload_A[0]_i_1_n_0\ : STD_LOGIC;
  signal s_axis_V_keep_V_0_payload_B : STD_LOGIC;
  signal \s_axis_V_keep_V_0_payload_B[0]_i_1_n_0\ : STD_LOGIC;
  signal s_axis_V_keep_V_0_sel : STD_LOGIC;
  signal s_axis_V_keep_V_0_sel_rd_i_1_n_0 : STD_LOGIC;
  signal s_axis_V_keep_V_0_sel_wr : STD_LOGIC;
  signal s_axis_V_keep_V_0_sel_wr_i_1_n_0 : STD_LOGIC;
  signal \s_axis_V_keep_V_0_state[0]_i_1_n_0\ : STD_LOGIC;
  signal \s_axis_V_keep_V_0_state[1]_i_1_n_0\ : STD_LOGIC;
  signal \s_axis_V_keep_V_0_state_reg_n_0_[0]\ : STD_LOGIC;
  signal s_axis_V_last_V_0_ack_in : STD_LOGIC;
  signal s_axis_V_last_V_0_payload_A : STD_LOGIC;
  signal \s_axis_V_last_V_0_payload_A[0]_i_1_n_0\ : STD_LOGIC;
  signal s_axis_V_last_V_0_payload_B : STD_LOGIC;
  signal \s_axis_V_last_V_0_payload_B[0]_i_1_n_0\ : STD_LOGIC;
  signal s_axis_V_last_V_0_sel : STD_LOGIC;
  signal s_axis_V_last_V_0_sel_rd_i_1_n_0 : STD_LOGIC;
  signal s_axis_V_last_V_0_sel_wr : STD_LOGIC;
  signal s_axis_V_last_V_0_sel_wr_i_1_n_0 : STD_LOGIC;
  signal \s_axis_V_last_V_0_state[0]_i_1_n_0\ : STD_LOGIC;
  signal \s_axis_V_last_V_0_state[1]_i_1_n_0\ : STD_LOGIC;
  signal \s_axis_V_last_V_0_state_reg_n_0_[0]\ : STD_LOGIC;
  signal s_axis_V_strb_V_0_ack_in : STD_LOGIC;
  signal s_axis_V_strb_V_0_payload_A : STD_LOGIC;
  signal \s_axis_V_strb_V_0_payload_A[0]_i_1_n_0\ : STD_LOGIC;
  signal s_axis_V_strb_V_0_payload_B : STD_LOGIC;
  signal \s_axis_V_strb_V_0_payload_B[0]_i_1_n_0\ : STD_LOGIC;
  signal s_axis_V_strb_V_0_sel : STD_LOGIC;
  signal s_axis_V_strb_V_0_sel_rd_i_1_n_0 : STD_LOGIC;
  signal s_axis_V_strb_V_0_sel_wr : STD_LOGIC;
  signal s_axis_V_strb_V_0_sel_wr_i_1_n_0 : STD_LOGIC;
  signal \s_axis_V_strb_V_0_state[0]_i_1_n_0\ : STD_LOGIC;
  signal \s_axis_V_strb_V_0_state[1]_i_1_n_0\ : STD_LOGIC;
  signal \s_axis_V_strb_V_0_state_reg_n_0_[0]\ : STD_LOGIC;
  signal s_axis_V_user_V_0_ack_in : STD_LOGIC;
  signal s_axis_V_user_V_0_payload_A : STD_LOGIC;
  signal \s_axis_V_user_V_0_payload_A[0]_i_1_n_0\ : STD_LOGIC;
  signal s_axis_V_user_V_0_payload_B : STD_LOGIC;
  signal \s_axis_V_user_V_0_payload_B[0]_i_1_n_0\ : STD_LOGIC;
  signal s_axis_V_user_V_0_sel : STD_LOGIC;
  signal s_axis_V_user_V_0_sel_rd_i_1_n_0 : STD_LOGIC;
  signal s_axis_V_user_V_0_sel_wr : STD_LOGIC;
  signal s_axis_V_user_V_0_sel_wr_i_1_n_0 : STD_LOGIC;
  signal \s_axis_V_user_V_0_state[0]_i_1_n_0\ : STD_LOGIC;
  signal \s_axis_V_user_V_0_state[1]_i_1_n_0\ : STD_LOGIC;
  signal \s_axis_V_user_V_0_state_reg_n_0_[0]\ : STD_LOGIC;
  signal tmp_user_V_fu_216_p1 : STD_LOGIC;
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of ap_enable_reg_pp0_iter1_i_1 : label is "soft_lutpair20";
  attribute SOFT_HLUTNM of \m_axis_TDATA[0]_INST_0\ : label is "soft_lutpair31";
  attribute SOFT_HLUTNM of \m_axis_TDATA[1]_INST_0\ : label is "soft_lutpair32";
  attribute SOFT_HLUTNM of \m_axis_TDATA[2]_INST_0\ : label is "soft_lutpair32";
  attribute SOFT_HLUTNM of \m_axis_TDATA[3]_INST_0\ : label is "soft_lutpair33";
  attribute SOFT_HLUTNM of \m_axis_TDATA[4]_INST_0\ : label is "soft_lutpair33";
  attribute SOFT_HLUTNM of \m_axis_TDATA[5]_INST_0\ : label is "soft_lutpair34";
  attribute SOFT_HLUTNM of \m_axis_TDATA[6]_INST_0\ : label is "soft_lutpair34";
  attribute SOFT_HLUTNM of \m_axis_TDATA[7]_INST_0\ : label is "soft_lutpair31";
  attribute SOFT_HLUTNM of \m_axis_V_data_V_1_payload_A[0]_i_1\ : label is "soft_lutpair27";
  attribute SOFT_HLUTNM of \m_axis_V_data_V_1_payload_A[1]_i_1\ : label is "soft_lutpair27";
  attribute SOFT_HLUTNM of \m_axis_V_data_V_1_payload_A[2]_i_1\ : label is "soft_lutpair28";
  attribute SOFT_HLUTNM of \m_axis_V_data_V_1_payload_A[3]_i_1\ : label is "soft_lutpair28";
  attribute SOFT_HLUTNM of \m_axis_V_data_V_1_payload_A[4]_i_1\ : label is "soft_lutpair29";
  attribute SOFT_HLUTNM of \m_axis_V_data_V_1_payload_A[5]_i_1\ : label is "soft_lutpair29";
  attribute SOFT_HLUTNM of \m_axis_V_data_V_1_payload_A[6]_i_1\ : label is "soft_lutpair30";
  attribute SOFT_HLUTNM of \m_axis_V_data_V_1_payload_A[7]_i_2\ : label is "soft_lutpair30";
  attribute SOFT_HLUTNM of m_axis_V_data_V_1_sel_rd_i_1 : label is "soft_lutpair9";
  attribute SOFT_HLUTNM of m_axis_V_data_V_1_sel_wr_i_1 : label is "soft_lutpair24";
  attribute SOFT_HLUTNM of \m_axis_V_data_V_1_state[0]_i_1\ : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of \m_axis_V_data_V_1_state[1]_i_1\ : label is "soft_lutpair9";
  attribute SOFT_HLUTNM of \m_axis_V_dest_V_1_payload_A[0]_i_2\ : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of m_axis_V_dest_V_1_sel_rd_i_1 : label is "soft_lutpair18";
  attribute SOFT_HLUTNM of m_axis_V_dest_V_1_sel_wr_i_1 : label is "soft_lutpair21";
  attribute SOFT_HLUTNM of \m_axis_V_dest_V_1_state[0]_i_1\ : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of \m_axis_V_dest_V_1_state[1]_i_1\ : label is "soft_lutpair18";
  attribute SOFT_HLUTNM of \m_axis_V_id_V_1_payload_A[0]_i_2\ : label is "soft_lutpair5";
  attribute SOFT_HLUTNM of m_axis_V_id_V_1_sel_rd_i_1 : label is "soft_lutpair14";
  attribute SOFT_HLUTNM of m_axis_V_id_V_1_sel_wr_i_1 : label is "soft_lutpair22";
  attribute SOFT_HLUTNM of \m_axis_V_id_V_1_state[0]_i_1\ : label is "soft_lutpair5";
  attribute SOFT_HLUTNM of \m_axis_V_id_V_1_state[1]_i_1\ : label is "soft_lutpair14";
  attribute SOFT_HLUTNM of m_axis_V_keep_V_1_sel_rd_i_1 : label is "soft_lutpair17";
  attribute SOFT_HLUTNM of m_axis_V_keep_V_1_sel_wr_i_1 : label is "soft_lutpair23";
  attribute SOFT_HLUTNM of \m_axis_V_keep_V_1_state[0]_i_1\ : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of \m_axis_V_keep_V_1_state[1]_i_1\ : label is "soft_lutpair17";
  attribute SOFT_HLUTNM of m_axis_V_last_V_1_sel_rd_i_1 : label is "soft_lutpair15";
  attribute SOFT_HLUTNM of m_axis_V_last_V_1_sel_wr_i_1 : label is "soft_lutpair23";
  attribute SOFT_HLUTNM of \m_axis_V_last_V_1_state[0]_i_1\ : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of \m_axis_V_last_V_1_state[1]_i_1\ : label is "soft_lutpair15";
  attribute SOFT_HLUTNM of \m_axis_V_strb_V_1_payload_A[0]_i_2\ : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of m_axis_V_strb_V_1_sel_rd_i_1 : label is "soft_lutpair13";
  attribute SOFT_HLUTNM of m_axis_V_strb_V_1_sel_wr_i_1 : label is "soft_lutpair25";
  attribute SOFT_HLUTNM of \m_axis_V_strb_V_1_state[0]_i_1\ : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of \m_axis_V_strb_V_1_state[1]_i_1\ : label is "soft_lutpair13";
  attribute SOFT_HLUTNM of m_axis_V_user_V_1_sel_rd_i_1 : label is "soft_lutpair19";
  attribute SOFT_HLUTNM of m_axis_V_user_V_1_sel_wr_i_1 : label is "soft_lutpair26";
  attribute SOFT_HLUTNM of \m_axis_V_user_V_1_state[1]_i_1\ : label is "soft_lutpair19";
  attribute SOFT_HLUTNM of s_axis_V_data_V_0_sel_rd_i_1 : label is "soft_lutpair25";
  attribute SOFT_HLUTNM of s_axis_V_data_V_0_sel_wr_i_1 : label is "soft_lutpair10";
  attribute SOFT_HLUTNM of \s_axis_V_data_V_0_state[1]_i_1\ : label is "soft_lutpair10";
  attribute SOFT_HLUTNM of s_axis_V_dest_V_0_sel_wr_i_1 : label is "soft_lutpair11";
  attribute SOFT_HLUTNM of \s_axis_V_dest_V_0_state[1]_i_11\ : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of \s_axis_V_dest_V_0_state[1]_i_2\ : label is "soft_lutpair11";
  attribute SOFT_HLUTNM of \s_axis_V_dest_V_0_state[1]_i_7\ : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of \s_axis_V_dest_V_0_state[1]_i_8\ : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of s_axis_V_id_V_0_sel_rd_i_1 : label is "soft_lutpair21";
  attribute SOFT_HLUTNM of s_axis_V_id_V_0_sel_wr_i_1 : label is "soft_lutpair16";
  attribute SOFT_HLUTNM of \s_axis_V_id_V_0_state[1]_i_1\ : label is "soft_lutpair16";
  attribute SOFT_HLUTNM of s_axis_V_keep_V_0_sel_rd_i_1 : label is "soft_lutpair20";
  attribute SOFT_HLUTNM of s_axis_V_keep_V_0_sel_wr_i_1 : label is "soft_lutpair8";
  attribute SOFT_HLUTNM of \s_axis_V_keep_V_0_state[1]_i_1\ : label is "soft_lutpair8";
  attribute SOFT_HLUTNM of s_axis_V_last_V_0_sel_rd_i_1 : label is "soft_lutpair22";
  attribute SOFT_HLUTNM of s_axis_V_last_V_0_sel_wr_i_1 : label is "soft_lutpair12";
  attribute SOFT_HLUTNM of \s_axis_V_last_V_0_state[1]_i_1\ : label is "soft_lutpair12";
  attribute SOFT_HLUTNM of s_axis_V_strb_V_0_sel_rd_i_1 : label is "soft_lutpair24";
  attribute SOFT_HLUTNM of s_axis_V_strb_V_0_sel_wr_i_1 : label is "soft_lutpair6";
  attribute SOFT_HLUTNM of \s_axis_V_strb_V_0_state[1]_i_1\ : label is "soft_lutpair6";
  attribute SOFT_HLUTNM of s_axis_V_user_V_0_sel_rd_i_1 : label is "soft_lutpair26";
  attribute SOFT_HLUTNM of s_axis_V_user_V_0_sel_wr_i_1 : label is "soft_lutpair7";
  attribute SOFT_HLUTNM of \s_axis_V_user_V_0_state[1]_i_1\ : label is "soft_lutpair7";
begin
  m_axis_TVALID <= \^m_axis_tvalid\;
  s_axis_TREADY <= \^s_axis_tready\;
ap_enable_reg_pp0_iter1_i_1: unisim.vcomponents.LUT2
    generic map(
      INIT => X"B"
    )
        port map (
      I0 => ap_enable_reg_pp0_iter1,
      I1 => ap_block_pp0_stage0_11001,
      O => ap_enable_reg_pp0_iter1_i_1_n_0
    );
ap_enable_reg_pp0_iter1_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => ap_enable_reg_pp0_iter1_i_1_n_0,
      Q => ap_enable_reg_pp0_iter1,
      R => ap_rst_n_inv
    );
\m_axis_TDATA[0]_INST_0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => m_axis_V_data_V_1_payload_B(0),
      I1 => m_axis_V_data_V_1_payload_A(0),
      I2 => m_axis_V_data_V_1_sel,
      O => m_axis_TDATA(0)
    );
\m_axis_TDATA[1]_INST_0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => m_axis_V_data_V_1_payload_B(1),
      I1 => m_axis_V_data_V_1_payload_A(1),
      I2 => m_axis_V_data_V_1_sel,
      O => m_axis_TDATA(1)
    );
\m_axis_TDATA[2]_INST_0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => m_axis_V_data_V_1_payload_B(2),
      I1 => m_axis_V_data_V_1_payload_A(2),
      I2 => m_axis_V_data_V_1_sel,
      O => m_axis_TDATA(2)
    );
\m_axis_TDATA[3]_INST_0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => m_axis_V_data_V_1_payload_B(3),
      I1 => m_axis_V_data_V_1_payload_A(3),
      I2 => m_axis_V_data_V_1_sel,
      O => m_axis_TDATA(3)
    );
\m_axis_TDATA[4]_INST_0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => m_axis_V_data_V_1_payload_B(4),
      I1 => m_axis_V_data_V_1_payload_A(4),
      I2 => m_axis_V_data_V_1_sel,
      O => m_axis_TDATA(4)
    );
\m_axis_TDATA[5]_INST_0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => m_axis_V_data_V_1_payload_B(5),
      I1 => m_axis_V_data_V_1_payload_A(5),
      I2 => m_axis_V_data_V_1_sel,
      O => m_axis_TDATA(5)
    );
\m_axis_TDATA[6]_INST_0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => m_axis_V_data_V_1_payload_B(6),
      I1 => m_axis_V_data_V_1_payload_A(6),
      I2 => m_axis_V_data_V_1_sel,
      O => m_axis_TDATA(6)
    );
\m_axis_TDATA[7]_INST_0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => m_axis_V_data_V_1_payload_B(7),
      I1 => m_axis_V_data_V_1_payload_A(7),
      I2 => m_axis_V_data_V_1_sel,
      O => m_axis_TDATA(7)
    );
\m_axis_TDEST[0]_INST_0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axis_V_dest_V_1_payload_B,
      I1 => m_axis_V_dest_V_1_sel,
      I2 => m_axis_V_dest_V_1_payload_A,
      O => m_axis_TDEST(0)
    );
\m_axis_TID[0]_INST_0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axis_V_id_V_1_payload_B,
      I1 => m_axis_V_id_V_1_sel,
      I2 => m_axis_V_id_V_1_payload_A,
      O => m_axis_TID(0)
    );
\m_axis_TKEEP[0]_INST_0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axis_V_keep_V_1_payload_B,
      I1 => m_axis_V_keep_V_1_sel,
      I2 => m_axis_V_keep_V_1_payload_A,
      O => m_axis_TKEEP(0)
    );
\m_axis_TLAST[0]_INST_0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axis_V_last_V_1_payload_B,
      I1 => m_axis_V_last_V_1_sel,
      I2 => m_axis_V_last_V_1_payload_A,
      O => m_axis_TLAST(0)
    );
\m_axis_TSTRB[0]_INST_0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axis_V_strb_V_1_payload_B,
      I1 => m_axis_V_strb_V_1_sel,
      I2 => m_axis_V_strb_V_1_payload_A,
      O => m_axis_TSTRB(0)
    );
\m_axis_TUSER[0]_INST_0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axis_V_user_V_1_payload_B,
      I1 => m_axis_V_user_V_1_sel,
      I2 => m_axis_V_user_V_1_payload_A,
      O => m_axis_TUSER(0)
    );
\m_axis_V_data_V_1_payload_A[0]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => s_axis_V_data_V_0_payload_B(0),
      I1 => s_axis_V_data_V_0_payload_A(0),
      I2 => s_axis_V_data_V_0_sel,
      O => s_axis_V_data_V_0_data_out(0)
    );
\m_axis_V_data_V_1_payload_A[1]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => s_axis_V_data_V_0_payload_B(1),
      I1 => s_axis_V_data_V_0_payload_A(1),
      I2 => s_axis_V_data_V_0_sel,
      O => s_axis_V_data_V_0_data_out(1)
    );
\m_axis_V_data_V_1_payload_A[2]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => s_axis_V_data_V_0_payload_B(2),
      I1 => s_axis_V_data_V_0_payload_A(2),
      I2 => s_axis_V_data_V_0_sel,
      O => s_axis_V_data_V_0_data_out(2)
    );
\m_axis_V_data_V_1_payload_A[3]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => s_axis_V_data_V_0_payload_B(3),
      I1 => s_axis_V_data_V_0_payload_A(3),
      I2 => s_axis_V_data_V_0_sel,
      O => s_axis_V_data_V_0_data_out(3)
    );
\m_axis_V_data_V_1_payload_A[4]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => s_axis_V_data_V_0_payload_B(4),
      I1 => s_axis_V_data_V_0_payload_A(4),
      I2 => s_axis_V_data_V_0_sel,
      O => s_axis_V_data_V_0_data_out(4)
    );
\m_axis_V_data_V_1_payload_A[5]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => s_axis_V_data_V_0_payload_B(5),
      I1 => s_axis_V_data_V_0_payload_A(5),
      I2 => s_axis_V_data_V_0_sel,
      O => s_axis_V_data_V_0_data_out(5)
    );
\m_axis_V_data_V_1_payload_A[6]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => s_axis_V_data_V_0_payload_B(6),
      I1 => s_axis_V_data_V_0_payload_A(6),
      I2 => s_axis_V_data_V_0_sel,
      O => s_axis_V_data_V_0_data_out(6)
    );
\m_axis_V_data_V_1_payload_A[7]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"0D"
    )
        port map (
      I0 => \m_axis_V_data_V_1_state_reg_n_0_[0]\,
      I1 => m_axis_V_data_V_1_ack_in,
      I2 => m_axis_V_data_V_1_sel_wr,
      O => \m_axis_V_data_V_1_payload_A[7]_i_1_n_0\
    );
\m_axis_V_data_V_1_payload_A[7]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => s_axis_V_data_V_0_payload_B(7),
      I1 => s_axis_V_data_V_0_payload_A(7),
      I2 => s_axis_V_data_V_0_sel,
      O => s_axis_V_data_V_0_data_out(7)
    );
\m_axis_V_data_V_1_payload_A_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \m_axis_V_data_V_1_payload_A[7]_i_1_n_0\,
      D => s_axis_V_data_V_0_data_out(0),
      Q => m_axis_V_data_V_1_payload_A(0),
      R => '0'
    );
\m_axis_V_data_V_1_payload_A_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \m_axis_V_data_V_1_payload_A[7]_i_1_n_0\,
      D => s_axis_V_data_V_0_data_out(1),
      Q => m_axis_V_data_V_1_payload_A(1),
      R => '0'
    );
\m_axis_V_data_V_1_payload_A_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \m_axis_V_data_V_1_payload_A[7]_i_1_n_0\,
      D => s_axis_V_data_V_0_data_out(2),
      Q => m_axis_V_data_V_1_payload_A(2),
      R => '0'
    );
\m_axis_V_data_V_1_payload_A_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \m_axis_V_data_V_1_payload_A[7]_i_1_n_0\,
      D => s_axis_V_data_V_0_data_out(3),
      Q => m_axis_V_data_V_1_payload_A(3),
      R => '0'
    );
\m_axis_V_data_V_1_payload_A_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \m_axis_V_data_V_1_payload_A[7]_i_1_n_0\,
      D => s_axis_V_data_V_0_data_out(4),
      Q => m_axis_V_data_V_1_payload_A(4),
      R => '0'
    );
\m_axis_V_data_V_1_payload_A_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \m_axis_V_data_V_1_payload_A[7]_i_1_n_0\,
      D => s_axis_V_data_V_0_data_out(5),
      Q => m_axis_V_data_V_1_payload_A(5),
      R => '0'
    );
\m_axis_V_data_V_1_payload_A_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \m_axis_V_data_V_1_payload_A[7]_i_1_n_0\,
      D => s_axis_V_data_V_0_data_out(6),
      Q => m_axis_V_data_V_1_payload_A(6),
      R => '0'
    );
\m_axis_V_data_V_1_payload_A_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \m_axis_V_data_V_1_payload_A[7]_i_1_n_0\,
      D => s_axis_V_data_V_0_data_out(7),
      Q => m_axis_V_data_V_1_payload_A(7),
      R => '0'
    );
\m_axis_V_data_V_1_payload_B[7]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"A2"
    )
        port map (
      I0 => m_axis_V_data_V_1_sel_wr,
      I1 => \m_axis_V_data_V_1_state_reg_n_0_[0]\,
      I2 => m_axis_V_data_V_1_ack_in,
      O => m_axis_V_data_V_1_load_B
    );
\m_axis_V_data_V_1_payload_B_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => m_axis_V_data_V_1_load_B,
      D => s_axis_V_data_V_0_data_out(0),
      Q => m_axis_V_data_V_1_payload_B(0),
      R => '0'
    );
\m_axis_V_data_V_1_payload_B_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => m_axis_V_data_V_1_load_B,
      D => s_axis_V_data_V_0_data_out(1),
      Q => m_axis_V_data_V_1_payload_B(1),
      R => '0'
    );
\m_axis_V_data_V_1_payload_B_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => m_axis_V_data_V_1_load_B,
      D => s_axis_V_data_V_0_data_out(2),
      Q => m_axis_V_data_V_1_payload_B(2),
      R => '0'
    );
\m_axis_V_data_V_1_payload_B_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => m_axis_V_data_V_1_load_B,
      D => s_axis_V_data_V_0_data_out(3),
      Q => m_axis_V_data_V_1_payload_B(3),
      R => '0'
    );
\m_axis_V_data_V_1_payload_B_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => m_axis_V_data_V_1_load_B,
      D => s_axis_V_data_V_0_data_out(4),
      Q => m_axis_V_data_V_1_payload_B(4),
      R => '0'
    );
\m_axis_V_data_V_1_payload_B_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => m_axis_V_data_V_1_load_B,
      D => s_axis_V_data_V_0_data_out(5),
      Q => m_axis_V_data_V_1_payload_B(5),
      R => '0'
    );
\m_axis_V_data_V_1_payload_B_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => m_axis_V_data_V_1_load_B,
      D => s_axis_V_data_V_0_data_out(6),
      Q => m_axis_V_data_V_1_payload_B(6),
      R => '0'
    );
\m_axis_V_data_V_1_payload_B_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => m_axis_V_data_V_1_load_B,
      D => s_axis_V_data_V_0_data_out(7),
      Q => m_axis_V_data_V_1_payload_B(7),
      R => '0'
    );
m_axis_V_data_V_1_sel_rd_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"78"
    )
        port map (
      I0 => m_axis_TREADY,
      I1 => \m_axis_V_data_V_1_state_reg_n_0_[0]\,
      I2 => m_axis_V_data_V_1_sel,
      O => m_axis_V_data_V_1_sel_rd_i_1_n_0
    );
m_axis_V_data_V_1_sel_rd_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => m_axis_V_data_V_1_sel_rd_i_1_n_0,
      Q => m_axis_V_data_V_1_sel,
      R => ap_rst_n_inv
    );
m_axis_V_data_V_1_sel_wr_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B4"
    )
        port map (
      I0 => ap_block_pp0_stage0_11001,
      I1 => m_axis_V_data_V_1_ack_in,
      I2 => m_axis_V_data_V_1_sel_wr,
      O => m_axis_V_data_V_1_sel_wr_i_1_n_0
    );
m_axis_V_data_V_1_sel_wr_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => m_axis_V_data_V_1_sel_wr_i_1_n_0,
      Q => m_axis_V_data_V_1_sel_wr,
      R => ap_rst_n_inv
    );
\m_axis_V_data_V_1_state[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0888A8A8"
    )
        port map (
      I0 => ap_rst_n,
      I1 => \m_axis_V_data_V_1_state_reg_n_0_[0]\,
      I2 => m_axis_V_data_V_1_ack_in,
      I3 => m_axis_TREADY,
      I4 => ap_block_pp0_stage0_11001,
      O => \m_axis_V_data_V_1_state[0]_i_1_n_0\
    );
\m_axis_V_data_V_1_state[1]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FBBB"
    )
        port map (
      I0 => m_axis_TREADY,
      I1 => \m_axis_V_data_V_1_state_reg_n_0_[0]\,
      I2 => m_axis_V_data_V_1_ack_in,
      I3 => ap_block_pp0_stage0_11001,
      O => \m_axis_V_data_V_1_state[1]_i_1_n_0\
    );
\m_axis_V_data_V_1_state_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \m_axis_V_data_V_1_state[0]_i_1_n_0\,
      Q => \m_axis_V_data_V_1_state_reg_n_0_[0]\,
      R => '0'
    );
\m_axis_V_data_V_1_state_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \m_axis_V_data_V_1_state[1]_i_1_n_0\,
      Q => m_axis_V_data_V_1_ack_in,
      R => ap_rst_n_inv
    );
\m_axis_V_dest_V_1_payload_A[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFB8000000B8"
    )
        port map (
      I0 => s_axis_V_dest_V_0_payload_B,
      I1 => s_axis_V_dest_V_0_sel,
      I2 => s_axis_V_dest_V_0_payload_A,
      I3 => \m_axis_V_dest_V_1_payload_A[0]_i_2_n_0\,
      I4 => m_axis_V_dest_V_1_sel_wr,
      I5 => m_axis_V_dest_V_1_payload_A,
      O => \m_axis_V_dest_V_1_payload_A[0]_i_1_n_0\
    );
\m_axis_V_dest_V_1_payload_A[0]_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => \^m_axis_tvalid\,
      I1 => m_axis_V_dest_V_1_ack_in,
      O => \m_axis_V_dest_V_1_payload_A[0]_i_2_n_0\
    );
\m_axis_V_dest_V_1_payload_A_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \m_axis_V_dest_V_1_payload_A[0]_i_1_n_0\,
      Q => m_axis_V_dest_V_1_payload_A,
      R => '0'
    );
\m_axis_V_dest_V_1_payload_B[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFB8FF0000B800"
    )
        port map (
      I0 => s_axis_V_dest_V_0_payload_B,
      I1 => s_axis_V_dest_V_0_sel,
      I2 => s_axis_V_dest_V_0_payload_A,
      I3 => m_axis_V_dest_V_1_sel_wr,
      I4 => \m_axis_V_dest_V_1_payload_A[0]_i_2_n_0\,
      I5 => m_axis_V_dest_V_1_payload_B,
      O => \m_axis_V_dest_V_1_payload_B[0]_i_1_n_0\
    );
\m_axis_V_dest_V_1_payload_B_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \m_axis_V_dest_V_1_payload_B[0]_i_1_n_0\,
      Q => m_axis_V_dest_V_1_payload_B,
      R => '0'
    );
m_axis_V_dest_V_1_sel_rd_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"78"
    )
        port map (
      I0 => m_axis_TREADY,
      I1 => \^m_axis_tvalid\,
      I2 => m_axis_V_dest_V_1_sel,
      O => m_axis_V_dest_V_1_sel_rd_i_1_n_0
    );
m_axis_V_dest_V_1_sel_rd_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => m_axis_V_dest_V_1_sel_rd_i_1_n_0,
      Q => m_axis_V_dest_V_1_sel,
      R => ap_rst_n_inv
    );
m_axis_V_dest_V_1_sel_wr_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B4"
    )
        port map (
      I0 => ap_block_pp0_stage0_11001,
      I1 => m_axis_V_dest_V_1_ack_in,
      I2 => m_axis_V_dest_V_1_sel_wr,
      O => m_axis_V_dest_V_1_sel_wr_i_1_n_0
    );
m_axis_V_dest_V_1_sel_wr_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => m_axis_V_dest_V_1_sel_wr_i_1_n_0,
      Q => m_axis_V_dest_V_1_sel_wr,
      R => ap_rst_n_inv
    );
\m_axis_V_dest_V_1_state[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0888A8A8"
    )
        port map (
      I0 => ap_rst_n,
      I1 => \^m_axis_tvalid\,
      I2 => m_axis_V_dest_V_1_ack_in,
      I3 => m_axis_TREADY,
      I4 => ap_block_pp0_stage0_11001,
      O => \m_axis_V_dest_V_1_state[0]_i_1_n_0\
    );
\m_axis_V_dest_V_1_state[1]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FBBB"
    )
        port map (
      I0 => m_axis_TREADY,
      I1 => \^m_axis_tvalid\,
      I2 => m_axis_V_dest_V_1_ack_in,
      I3 => ap_block_pp0_stage0_11001,
      O => \m_axis_V_dest_V_1_state[1]_i_1_n_0\
    );
\m_axis_V_dest_V_1_state_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \m_axis_V_dest_V_1_state[0]_i_1_n_0\,
      Q => \^m_axis_tvalid\,
      R => '0'
    );
\m_axis_V_dest_V_1_state_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \m_axis_V_dest_V_1_state[1]_i_1_n_0\,
      Q => m_axis_V_dest_V_1_ack_in,
      R => ap_rst_n_inv
    );
\m_axis_V_id_V_1_payload_A[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFB8000000B8"
    )
        port map (
      I0 => s_axis_V_id_V_0_payload_B,
      I1 => s_axis_V_id_V_0_sel,
      I2 => s_axis_V_id_V_0_payload_A,
      I3 => \m_axis_V_id_V_1_payload_A[0]_i_2_n_0\,
      I4 => m_axis_V_id_V_1_sel_wr,
      I5 => m_axis_V_id_V_1_payload_A,
      O => \m_axis_V_id_V_1_payload_A[0]_i_1_n_0\
    );
\m_axis_V_id_V_1_payload_A[0]_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => \m_axis_V_id_V_1_state_reg_n_0_[0]\,
      I1 => m_axis_V_id_V_1_ack_in,
      O => \m_axis_V_id_V_1_payload_A[0]_i_2_n_0\
    );
\m_axis_V_id_V_1_payload_A_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \m_axis_V_id_V_1_payload_A[0]_i_1_n_0\,
      Q => m_axis_V_id_V_1_payload_A,
      R => '0'
    );
\m_axis_V_id_V_1_payload_B[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFB8FF0000B800"
    )
        port map (
      I0 => s_axis_V_id_V_0_payload_B,
      I1 => s_axis_V_id_V_0_sel,
      I2 => s_axis_V_id_V_0_payload_A,
      I3 => m_axis_V_id_V_1_sel_wr,
      I4 => \m_axis_V_id_V_1_payload_A[0]_i_2_n_0\,
      I5 => m_axis_V_id_V_1_payload_B,
      O => \m_axis_V_id_V_1_payload_B[0]_i_1_n_0\
    );
\m_axis_V_id_V_1_payload_B_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \m_axis_V_id_V_1_payload_B[0]_i_1_n_0\,
      Q => m_axis_V_id_V_1_payload_B,
      R => '0'
    );
m_axis_V_id_V_1_sel_rd_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"78"
    )
        port map (
      I0 => m_axis_TREADY,
      I1 => \m_axis_V_id_V_1_state_reg_n_0_[0]\,
      I2 => m_axis_V_id_V_1_sel,
      O => m_axis_V_id_V_1_sel_rd_i_1_n_0
    );
m_axis_V_id_V_1_sel_rd_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => m_axis_V_id_V_1_sel_rd_i_1_n_0,
      Q => m_axis_V_id_V_1_sel,
      R => ap_rst_n_inv
    );
m_axis_V_id_V_1_sel_wr_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B4"
    )
        port map (
      I0 => ap_block_pp0_stage0_11001,
      I1 => m_axis_V_id_V_1_ack_in,
      I2 => m_axis_V_id_V_1_sel_wr,
      O => m_axis_V_id_V_1_sel_wr_i_1_n_0
    );
m_axis_V_id_V_1_sel_wr_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => m_axis_V_id_V_1_sel_wr_i_1_n_0,
      Q => m_axis_V_id_V_1_sel_wr,
      R => ap_rst_n_inv
    );
\m_axis_V_id_V_1_state[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0888A8A8"
    )
        port map (
      I0 => ap_rst_n,
      I1 => \m_axis_V_id_V_1_state_reg_n_0_[0]\,
      I2 => m_axis_V_id_V_1_ack_in,
      I3 => m_axis_TREADY,
      I4 => ap_block_pp0_stage0_11001,
      O => \m_axis_V_id_V_1_state[0]_i_1_n_0\
    );
\m_axis_V_id_V_1_state[1]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FBBB"
    )
        port map (
      I0 => m_axis_TREADY,
      I1 => \m_axis_V_id_V_1_state_reg_n_0_[0]\,
      I2 => m_axis_V_id_V_1_ack_in,
      I3 => ap_block_pp0_stage0_11001,
      O => \m_axis_V_id_V_1_state[1]_i_1_n_0\
    );
\m_axis_V_id_V_1_state_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \m_axis_V_id_V_1_state[0]_i_1_n_0\,
      Q => \m_axis_V_id_V_1_state_reg_n_0_[0]\,
      R => '0'
    );
\m_axis_V_id_V_1_state_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \m_axis_V_id_V_1_state[1]_i_1_n_0\,
      Q => m_axis_V_id_V_1_ack_in,
      R => ap_rst_n_inv
    );
\m_axis_V_keep_V_1_payload_A[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFB8000000B8"
    )
        port map (
      I0 => s_axis_V_keep_V_0_payload_B,
      I1 => s_axis_V_keep_V_0_sel,
      I2 => s_axis_V_keep_V_0_payload_A,
      I3 => \m_axis_V_keep_V_1_payload_A[0]_i_2_n_0\,
      I4 => m_axis_V_keep_V_1_sel_wr,
      I5 => m_axis_V_keep_V_1_payload_A,
      O => \m_axis_V_keep_V_1_payload_A[0]_i_1_n_0\
    );
\m_axis_V_keep_V_1_payload_A[0]_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => \m_axis_V_keep_V_1_state_reg_n_0_[0]\,
      I1 => m_axis_V_keep_V_1_ack_in,
      O => \m_axis_V_keep_V_1_payload_A[0]_i_2_n_0\
    );
\m_axis_V_keep_V_1_payload_A_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \m_axis_V_keep_V_1_payload_A[0]_i_1_n_0\,
      Q => m_axis_V_keep_V_1_payload_A,
      R => '0'
    );
\m_axis_V_keep_V_1_payload_B[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFB8FF0000B800"
    )
        port map (
      I0 => s_axis_V_keep_V_0_payload_B,
      I1 => s_axis_V_keep_V_0_sel,
      I2 => s_axis_V_keep_V_0_payload_A,
      I3 => m_axis_V_keep_V_1_sel_wr,
      I4 => \m_axis_V_keep_V_1_payload_A[0]_i_2_n_0\,
      I5 => m_axis_V_keep_V_1_payload_B,
      O => \m_axis_V_keep_V_1_payload_B[0]_i_1_n_0\
    );
\m_axis_V_keep_V_1_payload_B_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \m_axis_V_keep_V_1_payload_B[0]_i_1_n_0\,
      Q => m_axis_V_keep_V_1_payload_B,
      R => '0'
    );
m_axis_V_keep_V_1_sel_rd_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"78"
    )
        port map (
      I0 => m_axis_TREADY,
      I1 => \m_axis_V_keep_V_1_state_reg_n_0_[0]\,
      I2 => m_axis_V_keep_V_1_sel,
      O => m_axis_V_keep_V_1_sel_rd_i_1_n_0
    );
m_axis_V_keep_V_1_sel_rd_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => m_axis_V_keep_V_1_sel_rd_i_1_n_0,
      Q => m_axis_V_keep_V_1_sel,
      R => ap_rst_n_inv
    );
m_axis_V_keep_V_1_sel_wr_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B4"
    )
        port map (
      I0 => ap_block_pp0_stage0_11001,
      I1 => m_axis_V_keep_V_1_ack_in,
      I2 => m_axis_V_keep_V_1_sel_wr,
      O => m_axis_V_keep_V_1_sel_wr_i_1_n_0
    );
m_axis_V_keep_V_1_sel_wr_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => m_axis_V_keep_V_1_sel_wr_i_1_n_0,
      Q => m_axis_V_keep_V_1_sel_wr,
      R => ap_rst_n_inv
    );
\m_axis_V_keep_V_1_state[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0888A8A8"
    )
        port map (
      I0 => ap_rst_n,
      I1 => \m_axis_V_keep_V_1_state_reg_n_0_[0]\,
      I2 => m_axis_V_keep_V_1_ack_in,
      I3 => m_axis_TREADY,
      I4 => ap_block_pp0_stage0_11001,
      O => \m_axis_V_keep_V_1_state[0]_i_1_n_0\
    );
\m_axis_V_keep_V_1_state[1]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FBBB"
    )
        port map (
      I0 => m_axis_TREADY,
      I1 => \m_axis_V_keep_V_1_state_reg_n_0_[0]\,
      I2 => m_axis_V_keep_V_1_ack_in,
      I3 => ap_block_pp0_stage0_11001,
      O => \m_axis_V_keep_V_1_state[1]_i_1_n_0\
    );
\m_axis_V_keep_V_1_state_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \m_axis_V_keep_V_1_state[0]_i_1_n_0\,
      Q => \m_axis_V_keep_V_1_state_reg_n_0_[0]\,
      R => '0'
    );
\m_axis_V_keep_V_1_state_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \m_axis_V_keep_V_1_state[1]_i_1_n_0\,
      Q => m_axis_V_keep_V_1_ack_in,
      R => ap_rst_n_inv
    );
\m_axis_V_last_V_1_payload_A[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFAE00A2"
    )
        port map (
      I0 => ap_phi_mux_tmp_last_V_1_phi_fu_165_p61_out,
      I1 => \m_axis_V_last_V_1_state_reg_n_0_[0]\,
      I2 => m_axis_V_last_V_1_ack_in,
      I3 => m_axis_V_last_V_1_sel_wr,
      I4 => m_axis_V_last_V_1_payload_A,
      O => \m_axis_V_last_V_1_payload_A[0]_i_1_n_0\
    );
\m_axis_V_last_V_1_payload_A[0]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axis_V_last_V_0_payload_B,
      I1 => s_axis_V_last_V_0_sel,
      I2 => s_axis_V_last_V_0_payload_A,
      O => ap_phi_mux_tmp_last_V_1_phi_fu_165_p61_out
    );
\m_axis_V_last_V_1_payload_A_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \m_axis_V_last_V_1_payload_A[0]_i_1_n_0\,
      Q => m_axis_V_last_V_1_payload_A,
      R => '0'
    );
\m_axis_V_last_V_1_payload_B[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"BBFB8808"
    )
        port map (
      I0 => ap_phi_mux_tmp_last_V_1_phi_fu_165_p61_out,
      I1 => m_axis_V_last_V_1_sel_wr,
      I2 => \m_axis_V_last_V_1_state_reg_n_0_[0]\,
      I3 => m_axis_V_last_V_1_ack_in,
      I4 => m_axis_V_last_V_1_payload_B,
      O => \m_axis_V_last_V_1_payload_B[0]_i_1_n_0\
    );
\m_axis_V_last_V_1_payload_B_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \m_axis_V_last_V_1_payload_B[0]_i_1_n_0\,
      Q => m_axis_V_last_V_1_payload_B,
      R => '0'
    );
m_axis_V_last_V_1_sel_rd_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"78"
    )
        port map (
      I0 => m_axis_TREADY,
      I1 => \m_axis_V_last_V_1_state_reg_n_0_[0]\,
      I2 => m_axis_V_last_V_1_sel,
      O => m_axis_V_last_V_1_sel_rd_i_1_n_0
    );
m_axis_V_last_V_1_sel_rd_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => m_axis_V_last_V_1_sel_rd_i_1_n_0,
      Q => m_axis_V_last_V_1_sel,
      R => ap_rst_n_inv
    );
m_axis_V_last_V_1_sel_wr_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B4"
    )
        port map (
      I0 => ap_block_pp0_stage0_11001,
      I1 => m_axis_V_last_V_1_ack_in,
      I2 => m_axis_V_last_V_1_sel_wr,
      O => m_axis_V_last_V_1_sel_wr_i_1_n_0
    );
m_axis_V_last_V_1_sel_wr_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => m_axis_V_last_V_1_sel_wr_i_1_n_0,
      Q => m_axis_V_last_V_1_sel_wr,
      R => ap_rst_n_inv
    );
\m_axis_V_last_V_1_state[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0888A8A8"
    )
        port map (
      I0 => ap_rst_n,
      I1 => \m_axis_V_last_V_1_state_reg_n_0_[0]\,
      I2 => m_axis_V_last_V_1_ack_in,
      I3 => m_axis_TREADY,
      I4 => ap_block_pp0_stage0_11001,
      O => \m_axis_V_last_V_1_state[0]_i_1_n_0\
    );
\m_axis_V_last_V_1_state[1]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FBBB"
    )
        port map (
      I0 => m_axis_TREADY,
      I1 => \m_axis_V_last_V_1_state_reg_n_0_[0]\,
      I2 => m_axis_V_last_V_1_ack_in,
      I3 => ap_block_pp0_stage0_11001,
      O => \m_axis_V_last_V_1_state[1]_i_1_n_0\
    );
\m_axis_V_last_V_1_state_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \m_axis_V_last_V_1_state[0]_i_1_n_0\,
      Q => \m_axis_V_last_V_1_state_reg_n_0_[0]\,
      R => '0'
    );
\m_axis_V_last_V_1_state_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \m_axis_V_last_V_1_state[1]_i_1_n_0\,
      Q => m_axis_V_last_V_1_ack_in,
      R => ap_rst_n_inv
    );
\m_axis_V_strb_V_1_payload_A[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFB8000000B8"
    )
        port map (
      I0 => s_axis_V_strb_V_0_payload_B,
      I1 => s_axis_V_strb_V_0_sel,
      I2 => s_axis_V_strb_V_0_payload_A,
      I3 => \m_axis_V_strb_V_1_payload_A[0]_i_2_n_0\,
      I4 => m_axis_V_strb_V_1_sel_wr,
      I5 => m_axis_V_strb_V_1_payload_A,
      O => \m_axis_V_strb_V_1_payload_A[0]_i_1_n_0\
    );
\m_axis_V_strb_V_1_payload_A[0]_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => \m_axis_V_strb_V_1_state_reg_n_0_[0]\,
      I1 => m_axis_V_strb_V_1_ack_in,
      O => \m_axis_V_strb_V_1_payload_A[0]_i_2_n_0\
    );
\m_axis_V_strb_V_1_payload_A_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \m_axis_V_strb_V_1_payload_A[0]_i_1_n_0\,
      Q => m_axis_V_strb_V_1_payload_A,
      R => '0'
    );
\m_axis_V_strb_V_1_payload_B[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFB8FF0000B800"
    )
        port map (
      I0 => s_axis_V_strb_V_0_payload_B,
      I1 => s_axis_V_strb_V_0_sel,
      I2 => s_axis_V_strb_V_0_payload_A,
      I3 => m_axis_V_strb_V_1_sel_wr,
      I4 => \m_axis_V_strb_V_1_payload_A[0]_i_2_n_0\,
      I5 => m_axis_V_strb_V_1_payload_B,
      O => \m_axis_V_strb_V_1_payload_B[0]_i_1_n_0\
    );
\m_axis_V_strb_V_1_payload_B_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \m_axis_V_strb_V_1_payload_B[0]_i_1_n_0\,
      Q => m_axis_V_strb_V_1_payload_B,
      R => '0'
    );
m_axis_V_strb_V_1_sel_rd_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"78"
    )
        port map (
      I0 => m_axis_TREADY,
      I1 => \m_axis_V_strb_V_1_state_reg_n_0_[0]\,
      I2 => m_axis_V_strb_V_1_sel,
      O => m_axis_V_strb_V_1_sel_rd_i_1_n_0
    );
m_axis_V_strb_V_1_sel_rd_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => m_axis_V_strb_V_1_sel_rd_i_1_n_0,
      Q => m_axis_V_strb_V_1_sel,
      R => ap_rst_n_inv
    );
m_axis_V_strb_V_1_sel_wr_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B4"
    )
        port map (
      I0 => ap_block_pp0_stage0_11001,
      I1 => m_axis_V_strb_V_1_ack_in,
      I2 => m_axis_V_strb_V_1_sel_wr,
      O => m_axis_V_strb_V_1_sel_wr_i_1_n_0
    );
m_axis_V_strb_V_1_sel_wr_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => m_axis_V_strb_V_1_sel_wr_i_1_n_0,
      Q => m_axis_V_strb_V_1_sel_wr,
      R => ap_rst_n_inv
    );
\m_axis_V_strb_V_1_state[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0888A8A8"
    )
        port map (
      I0 => ap_rst_n,
      I1 => \m_axis_V_strb_V_1_state_reg_n_0_[0]\,
      I2 => m_axis_V_strb_V_1_ack_in,
      I3 => m_axis_TREADY,
      I4 => ap_block_pp0_stage0_11001,
      O => \m_axis_V_strb_V_1_state[0]_i_1_n_0\
    );
\m_axis_V_strb_V_1_state[1]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FBBB"
    )
        port map (
      I0 => m_axis_TREADY,
      I1 => \m_axis_V_strb_V_1_state_reg_n_0_[0]\,
      I2 => m_axis_V_strb_V_1_ack_in,
      I3 => ap_block_pp0_stage0_11001,
      O => \m_axis_V_strb_V_1_state[1]_i_1_n_0\
    );
\m_axis_V_strb_V_1_state_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \m_axis_V_strb_V_1_state[0]_i_1_n_0\,
      Q => \m_axis_V_strb_V_1_state_reg_n_0_[0]\,
      R => '0'
    );
\m_axis_V_strb_V_1_state_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \m_axis_V_strb_V_1_state[1]_i_1_n_0\,
      Q => m_axis_V_strb_V_1_ack_in,
      R => ap_rst_n_inv
    );
\m_axis_V_user_V_1_payload_A[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFAE00A2"
    )
        port map (
      I0 => tmp_user_V_fu_216_p1,
      I1 => \m_axis_V_user_V_1_state_reg_n_0_[0]\,
      I2 => m_axis_V_user_V_1_ack_in,
      I3 => m_axis_V_user_V_1_sel_wr,
      I4 => m_axis_V_user_V_1_payload_A,
      O => \m_axis_V_user_V_1_payload_A[0]_i_1_n_0\
    );
\m_axis_V_user_V_1_payload_A[0]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axis_V_user_V_0_payload_B,
      I1 => s_axis_V_user_V_0_sel,
      I2 => s_axis_V_user_V_0_payload_A,
      O => tmp_user_V_fu_216_p1
    );
\m_axis_V_user_V_1_payload_A_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \m_axis_V_user_V_1_payload_A[0]_i_1_n_0\,
      Q => m_axis_V_user_V_1_payload_A,
      R => '0'
    );
\m_axis_V_user_V_1_payload_B[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"BBFB8808"
    )
        port map (
      I0 => tmp_user_V_fu_216_p1,
      I1 => m_axis_V_user_V_1_sel_wr,
      I2 => \m_axis_V_user_V_1_state_reg_n_0_[0]\,
      I3 => m_axis_V_user_V_1_ack_in,
      I4 => m_axis_V_user_V_1_payload_B,
      O => \m_axis_V_user_V_1_payload_B[0]_i_1_n_0\
    );
\m_axis_V_user_V_1_payload_B_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \m_axis_V_user_V_1_payload_B[0]_i_1_n_0\,
      Q => m_axis_V_user_V_1_payload_B,
      R => '0'
    );
m_axis_V_user_V_1_sel_rd_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"78"
    )
        port map (
      I0 => m_axis_TREADY,
      I1 => \m_axis_V_user_V_1_state_reg_n_0_[0]\,
      I2 => m_axis_V_user_V_1_sel,
      O => m_axis_V_user_V_1_sel_rd_i_1_n_0
    );
m_axis_V_user_V_1_sel_rd_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => m_axis_V_user_V_1_sel_rd_i_1_n_0,
      Q => m_axis_V_user_V_1_sel,
      R => ap_rst_n_inv
    );
m_axis_V_user_V_1_sel_wr_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B4"
    )
        port map (
      I0 => ap_block_pp0_stage0_11001,
      I1 => m_axis_V_user_V_1_ack_in,
      I2 => m_axis_V_user_V_1_sel_wr,
      O => m_axis_V_user_V_1_sel_wr_i_1_n_0
    );
m_axis_V_user_V_1_sel_wr_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => m_axis_V_user_V_1_sel_wr_i_1_n_0,
      Q => m_axis_V_user_V_1_sel_wr,
      R => ap_rst_n_inv
    );
\m_axis_V_user_V_1_state[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0888A8A8"
    )
        port map (
      I0 => ap_rst_n,
      I1 => \m_axis_V_user_V_1_state_reg_n_0_[0]\,
      I2 => m_axis_V_user_V_1_ack_in,
      I3 => m_axis_TREADY,
      I4 => ap_block_pp0_stage0_11001,
      O => \m_axis_V_user_V_1_state[0]_i_1_n_0\
    );
\m_axis_V_user_V_1_state[1]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FBBB"
    )
        port map (
      I0 => m_axis_TREADY,
      I1 => \m_axis_V_user_V_1_state_reg_n_0_[0]\,
      I2 => m_axis_V_user_V_1_ack_in,
      I3 => ap_block_pp0_stage0_11001,
      O => \m_axis_V_user_V_1_state[1]_i_1_n_0\
    );
\m_axis_V_user_V_1_state_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \m_axis_V_user_V_1_state[0]_i_1_n_0\,
      Q => \m_axis_V_user_V_1_state_reg_n_0_[0]\,
      R => '0'
    );
\m_axis_V_user_V_1_state_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \m_axis_V_user_V_1_state[1]_i_1_n_0\,
      Q => m_axis_V_user_V_1_ack_in,
      R => ap_rst_n_inv
    );
\s_axis_V_data_V_0_payload_A[7]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"0D"
    )
        port map (
      I0 => \s_axis_V_data_V_0_state_reg_n_0_[0]\,
      I1 => s_axis_V_data_V_0_ack_in,
      I2 => s_axis_V_data_V_0_sel_wr,
      O => \s_axis_V_data_V_0_payload_A[7]_i_1_n_0\
    );
\s_axis_V_data_V_0_payload_A_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \s_axis_V_data_V_0_payload_A[7]_i_1_n_0\,
      D => s_axis_TDATA(0),
      Q => s_axis_V_data_V_0_payload_A(0),
      R => '0'
    );
\s_axis_V_data_V_0_payload_A_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \s_axis_V_data_V_0_payload_A[7]_i_1_n_0\,
      D => s_axis_TDATA(1),
      Q => s_axis_V_data_V_0_payload_A(1),
      R => '0'
    );
\s_axis_V_data_V_0_payload_A_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \s_axis_V_data_V_0_payload_A[7]_i_1_n_0\,
      D => s_axis_TDATA(2),
      Q => s_axis_V_data_V_0_payload_A(2),
      R => '0'
    );
\s_axis_V_data_V_0_payload_A_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \s_axis_V_data_V_0_payload_A[7]_i_1_n_0\,
      D => s_axis_TDATA(3),
      Q => s_axis_V_data_V_0_payload_A(3),
      R => '0'
    );
\s_axis_V_data_V_0_payload_A_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \s_axis_V_data_V_0_payload_A[7]_i_1_n_0\,
      D => s_axis_TDATA(4),
      Q => s_axis_V_data_V_0_payload_A(4),
      R => '0'
    );
\s_axis_V_data_V_0_payload_A_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \s_axis_V_data_V_0_payload_A[7]_i_1_n_0\,
      D => s_axis_TDATA(5),
      Q => s_axis_V_data_V_0_payload_A(5),
      R => '0'
    );
\s_axis_V_data_V_0_payload_A_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \s_axis_V_data_V_0_payload_A[7]_i_1_n_0\,
      D => s_axis_TDATA(6),
      Q => s_axis_V_data_V_0_payload_A(6),
      R => '0'
    );
\s_axis_V_data_V_0_payload_A_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \s_axis_V_data_V_0_payload_A[7]_i_1_n_0\,
      D => s_axis_TDATA(7),
      Q => s_axis_V_data_V_0_payload_A(7),
      R => '0'
    );
\s_axis_V_data_V_0_payload_B[7]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"A2"
    )
        port map (
      I0 => s_axis_V_data_V_0_sel_wr,
      I1 => \s_axis_V_data_V_0_state_reg_n_0_[0]\,
      I2 => s_axis_V_data_V_0_ack_in,
      O => s_axis_V_data_V_0_load_B
    );
\s_axis_V_data_V_0_payload_B_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => s_axis_V_data_V_0_load_B,
      D => s_axis_TDATA(0),
      Q => s_axis_V_data_V_0_payload_B(0),
      R => '0'
    );
\s_axis_V_data_V_0_payload_B_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => s_axis_V_data_V_0_load_B,
      D => s_axis_TDATA(1),
      Q => s_axis_V_data_V_0_payload_B(1),
      R => '0'
    );
\s_axis_V_data_V_0_payload_B_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => s_axis_V_data_V_0_load_B,
      D => s_axis_TDATA(2),
      Q => s_axis_V_data_V_0_payload_B(2),
      R => '0'
    );
\s_axis_V_data_V_0_payload_B_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => s_axis_V_data_V_0_load_B,
      D => s_axis_TDATA(3),
      Q => s_axis_V_data_V_0_payload_B(3),
      R => '0'
    );
\s_axis_V_data_V_0_payload_B_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => s_axis_V_data_V_0_load_B,
      D => s_axis_TDATA(4),
      Q => s_axis_V_data_V_0_payload_B(4),
      R => '0'
    );
\s_axis_V_data_V_0_payload_B_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => s_axis_V_data_V_0_load_B,
      D => s_axis_TDATA(5),
      Q => s_axis_V_data_V_0_payload_B(5),
      R => '0'
    );
\s_axis_V_data_V_0_payload_B_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => s_axis_V_data_V_0_load_B,
      D => s_axis_TDATA(6),
      Q => s_axis_V_data_V_0_payload_B(6),
      R => '0'
    );
\s_axis_V_data_V_0_payload_B_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => s_axis_V_data_V_0_load_B,
      D => s_axis_TDATA(7),
      Q => s_axis_V_data_V_0_payload_B(7),
      R => '0'
    );
s_axis_V_data_V_0_sel_rd_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B4"
    )
        port map (
      I0 => ap_block_pp0_stage0_11001,
      I1 => \s_axis_V_data_V_0_state_reg_n_0_[0]\,
      I2 => s_axis_V_data_V_0_sel,
      O => s_axis_V_data_V_0_sel_rd_i_1_n_0
    );
s_axis_V_data_V_0_sel_rd_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => s_axis_V_data_V_0_sel_rd_i_1_n_0,
      Q => s_axis_V_data_V_0_sel,
      R => ap_rst_n_inv
    );
s_axis_V_data_V_0_sel_wr_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"78"
    )
        port map (
      I0 => s_axis_TVALID,
      I1 => s_axis_V_data_V_0_ack_in,
      I2 => s_axis_V_data_V_0_sel_wr,
      O => s_axis_V_data_V_0_sel_wr_i_1_n_0
    );
s_axis_V_data_V_0_sel_wr_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => s_axis_V_data_V_0_sel_wr_i_1_n_0,
      Q => s_axis_V_data_V_0_sel_wr,
      R => ap_rst_n_inv
    );
\s_axis_V_data_V_0_state[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"A888A808"
    )
        port map (
      I0 => ap_rst_n,
      I1 => \s_axis_V_data_V_0_state_reg_n_0_[0]\,
      I2 => s_axis_V_data_V_0_ack_in,
      I3 => s_axis_TVALID,
      I4 => ap_block_pp0_stage0_11001,
      O => \s_axis_V_data_V_0_state[0]_i_1_n_0\
    );
\s_axis_V_data_V_0_state[1]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"75FF"
    )
        port map (
      I0 => ap_block_pp0_stage0_11001,
      I1 => s_axis_TVALID,
      I2 => s_axis_V_data_V_0_ack_in,
      I3 => \s_axis_V_data_V_0_state_reg_n_0_[0]\,
      O => \s_axis_V_data_V_0_state[1]_i_1_n_0\
    );
\s_axis_V_data_V_0_state_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \s_axis_V_data_V_0_state[0]_i_1_n_0\,
      Q => \s_axis_V_data_V_0_state_reg_n_0_[0]\,
      R => '0'
    );
\s_axis_V_data_V_0_state_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \s_axis_V_data_V_0_state[1]_i_1_n_0\,
      Q => s_axis_V_data_V_0_ack_in,
      R => ap_rst_n_inv
    );
\s_axis_V_dest_V_0_payload_A[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFAE00A2"
    )
        port map (
      I0 => s_axis_TDEST(0),
      I1 => \s_axis_V_dest_V_0_state_reg_n_0_[0]\,
      I2 => \^s_axis_tready\,
      I3 => s_axis_V_dest_V_0_sel_wr,
      I4 => s_axis_V_dest_V_0_payload_A,
      O => \s_axis_V_dest_V_0_payload_A[0]_i_1_n_0\
    );
\s_axis_V_dest_V_0_payload_A_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \s_axis_V_dest_V_0_payload_A[0]_i_1_n_0\,
      Q => s_axis_V_dest_V_0_payload_A,
      R => '0'
    );
\s_axis_V_dest_V_0_payload_B[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"BBFB8808"
    )
        port map (
      I0 => s_axis_TDEST(0),
      I1 => s_axis_V_dest_V_0_sel_wr,
      I2 => \s_axis_V_dest_V_0_state_reg_n_0_[0]\,
      I3 => \^s_axis_tready\,
      I4 => s_axis_V_dest_V_0_payload_B,
      O => \s_axis_V_dest_V_0_payload_B[0]_i_1_n_0\
    );
\s_axis_V_dest_V_0_payload_B_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \s_axis_V_dest_V_0_payload_B[0]_i_1_n_0\,
      Q => s_axis_V_dest_V_0_payload_B,
      R => '0'
    );
s_axis_V_dest_V_0_sel_rd_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B4"
    )
        port map (
      I0 => ap_block_pp0_stage0_11001,
      I1 => \s_axis_V_dest_V_0_state_reg_n_0_[0]\,
      I2 => s_axis_V_dest_V_0_sel,
      O => s_axis_V_dest_V_0_sel_rd_i_1_n_0
    );
s_axis_V_dest_V_0_sel_rd_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => s_axis_V_dest_V_0_sel_rd_i_1_n_0,
      Q => s_axis_V_dest_V_0_sel,
      R => ap_rst_n_inv
    );
s_axis_V_dest_V_0_sel_wr_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"78"
    )
        port map (
      I0 => s_axis_TVALID,
      I1 => \^s_axis_tready\,
      I2 => s_axis_V_dest_V_0_sel_wr,
      O => s_axis_V_dest_V_0_sel_wr_i_1_n_0
    );
s_axis_V_dest_V_0_sel_wr_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => s_axis_V_dest_V_0_sel_wr_i_1_n_0,
      Q => s_axis_V_dest_V_0_sel_wr,
      R => ap_rst_n_inv
    );
\s_axis_V_dest_V_0_state[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"A888A808"
    )
        port map (
      I0 => ap_rst_n,
      I1 => \s_axis_V_dest_V_0_state_reg_n_0_[0]\,
      I2 => \^s_axis_tready\,
      I3 => s_axis_TVALID,
      I4 => ap_block_pp0_stage0_11001,
      O => \s_axis_V_dest_V_0_state[0]_i_1_n_0\
    );
\s_axis_V_dest_V_0_state[1]_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => ap_rst_n,
      O => ap_rst_n_inv
    );
\s_axis_V_dest_V_0_state[1]_i_10\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0F080808"
    )
        port map (
      I0 => \m_axis_V_strb_V_1_state_reg_n_0_[0]\,
      I1 => m_axis_V_strb_V_1_ack_in,
      I2 => m_axis_TREADY,
      I3 => \m_axis_V_user_V_1_state_reg_n_0_[0]\,
      I4 => m_axis_V_user_V_1_ack_in,
      O => \s_axis_V_dest_V_0_state[1]_i_10_n_0\
    );
\s_axis_V_dest_V_0_state[1]_i_11\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => \m_axis_V_last_V_1_state_reg_n_0_[0]\,
      I1 => m_axis_V_last_V_1_ack_in,
      O => \s_axis_V_dest_V_0_state[1]_i_11_n_0\
    );
\s_axis_V_dest_V_0_state[1]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"75FF"
    )
        port map (
      I0 => ap_block_pp0_stage0_11001,
      I1 => s_axis_TVALID,
      I2 => \^s_axis_tready\,
      I3 => \s_axis_V_dest_V_0_state_reg_n_0_[0]\,
      O => \s_axis_V_dest_V_0_state[1]_i_2_n_0\
    );
\s_axis_V_dest_V_0_state[1]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAA8FFFFFFFFFFFF"
    )
        port map (
      I0 => ap_enable_reg_pp0_iter1,
      I1 => \s_axis_V_dest_V_0_state[1]_i_4_n_0\,
      I2 => \s_axis_V_dest_V_0_state[1]_i_5_n_0\,
      I3 => \s_axis_V_dest_V_0_state[1]_i_6_n_0\,
      I4 => \s_axis_V_data_V_0_state_reg_n_0_[0]\,
      I5 => m_axis_V_data_V_1_ack_in,
      O => ap_block_pp0_stage0_11001
    );
\s_axis_V_dest_V_0_state[1]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFFFFF32"
    )
        port map (
      I0 => p_0_in58_in,
      I1 => m_axis_TREADY,
      I2 => p_1_in43_in,
      I3 => \m_axis_V_dest_V_1_payload_A[0]_i_2_n_0\,
      I4 => \s_axis_V_dest_V_0_state[1]_i_9_n_0\,
      I5 => \s_axis_V_dest_V_0_state[1]_i_10_n_0\,
      O => \s_axis_V_dest_V_0_state[1]_i_4_n_0\
    );
\s_axis_V_dest_V_0_state[1]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFFF22F2"
    )
        port map (
      I0 => \m_axis_V_user_V_1_state_reg_n_0_[0]\,
      I1 => m_axis_V_user_V_1_ack_in,
      I2 => \m_axis_V_strb_V_1_state_reg_n_0_[0]\,
      I3 => m_axis_V_strb_V_1_ack_in,
      I4 => \m_axis_V_id_V_1_payload_A[0]_i_2_n_0\,
      I5 => \s_axis_V_dest_V_0_state[1]_i_11_n_0\,
      O => \s_axis_V_dest_V_0_state[1]_i_5_n_0\
    );
\s_axis_V_dest_V_0_state[1]_i_6\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FF08FFFF"
    )
        port map (
      I0 => m_axis_V_dest_V_1_ack_in,
      I1 => \^m_axis_tvalid\,
      I2 => m_axis_TREADY,
      I3 => \m_axis_V_keep_V_1_payload_A[0]_i_2_n_0\,
      I4 => m_axis_V_data_V_1_ack_in,
      O => \s_axis_V_dest_V_0_state[1]_i_6_n_0\
    );
\s_axis_V_dest_V_0_state[1]_i_7\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \m_axis_V_data_V_1_state_reg_n_0_[0]\,
      I1 => m_axis_V_data_V_1_ack_in,
      O => p_0_in58_in
    );
\s_axis_V_dest_V_0_state[1]_i_8\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \m_axis_V_keep_V_1_state_reg_n_0_[0]\,
      I1 => m_axis_V_keep_V_1_ack_in,
      O => p_1_in43_in
    );
\s_axis_V_dest_V_0_state[1]_i_9\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0F080808"
    )
        port map (
      I0 => \m_axis_V_last_V_1_state_reg_n_0_[0]\,
      I1 => m_axis_V_last_V_1_ack_in,
      I2 => m_axis_TREADY,
      I3 => \m_axis_V_id_V_1_state_reg_n_0_[0]\,
      I4 => m_axis_V_id_V_1_ack_in,
      O => \s_axis_V_dest_V_0_state[1]_i_9_n_0\
    );
\s_axis_V_dest_V_0_state_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \s_axis_V_dest_V_0_state[0]_i_1_n_0\,
      Q => \s_axis_V_dest_V_0_state_reg_n_0_[0]\,
      R => '0'
    );
\s_axis_V_dest_V_0_state_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \s_axis_V_dest_V_0_state[1]_i_2_n_0\,
      Q => \^s_axis_tready\,
      R => ap_rst_n_inv
    );
\s_axis_V_id_V_0_payload_A[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFAE00A2"
    )
        port map (
      I0 => s_axis_TID(0),
      I1 => \s_axis_V_id_V_0_state_reg_n_0_[0]\,
      I2 => s_axis_V_id_V_0_ack_in,
      I3 => s_axis_V_id_V_0_sel_wr,
      I4 => s_axis_V_id_V_0_payload_A,
      O => \s_axis_V_id_V_0_payload_A[0]_i_1_n_0\
    );
\s_axis_V_id_V_0_payload_A_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \s_axis_V_id_V_0_payload_A[0]_i_1_n_0\,
      Q => s_axis_V_id_V_0_payload_A,
      R => '0'
    );
\s_axis_V_id_V_0_payload_B[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"BBFB8808"
    )
        port map (
      I0 => s_axis_TID(0),
      I1 => s_axis_V_id_V_0_sel_wr,
      I2 => \s_axis_V_id_V_0_state_reg_n_0_[0]\,
      I3 => s_axis_V_id_V_0_ack_in,
      I4 => s_axis_V_id_V_0_payload_B,
      O => \s_axis_V_id_V_0_payload_B[0]_i_1_n_0\
    );
\s_axis_V_id_V_0_payload_B_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \s_axis_V_id_V_0_payload_B[0]_i_1_n_0\,
      Q => s_axis_V_id_V_0_payload_B,
      R => '0'
    );
s_axis_V_id_V_0_sel_rd_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B4"
    )
        port map (
      I0 => ap_block_pp0_stage0_11001,
      I1 => \s_axis_V_id_V_0_state_reg_n_0_[0]\,
      I2 => s_axis_V_id_V_0_sel,
      O => s_axis_V_id_V_0_sel_rd_i_1_n_0
    );
s_axis_V_id_V_0_sel_rd_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => s_axis_V_id_V_0_sel_rd_i_1_n_0,
      Q => s_axis_V_id_V_0_sel,
      R => ap_rst_n_inv
    );
s_axis_V_id_V_0_sel_wr_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"78"
    )
        port map (
      I0 => s_axis_TVALID,
      I1 => s_axis_V_id_V_0_ack_in,
      I2 => s_axis_V_id_V_0_sel_wr,
      O => s_axis_V_id_V_0_sel_wr_i_1_n_0
    );
s_axis_V_id_V_0_sel_wr_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => s_axis_V_id_V_0_sel_wr_i_1_n_0,
      Q => s_axis_V_id_V_0_sel_wr,
      R => ap_rst_n_inv
    );
\s_axis_V_id_V_0_state[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"A888A808"
    )
        port map (
      I0 => ap_rst_n,
      I1 => \s_axis_V_id_V_0_state_reg_n_0_[0]\,
      I2 => s_axis_V_id_V_0_ack_in,
      I3 => s_axis_TVALID,
      I4 => ap_block_pp0_stage0_11001,
      O => \s_axis_V_id_V_0_state[0]_i_1_n_0\
    );
\s_axis_V_id_V_0_state[1]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"75FF"
    )
        port map (
      I0 => ap_block_pp0_stage0_11001,
      I1 => s_axis_TVALID,
      I2 => s_axis_V_id_V_0_ack_in,
      I3 => \s_axis_V_id_V_0_state_reg_n_0_[0]\,
      O => \s_axis_V_id_V_0_state[1]_i_1_n_0\
    );
\s_axis_V_id_V_0_state_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \s_axis_V_id_V_0_state[0]_i_1_n_0\,
      Q => \s_axis_V_id_V_0_state_reg_n_0_[0]\,
      R => '0'
    );
\s_axis_V_id_V_0_state_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \s_axis_V_id_V_0_state[1]_i_1_n_0\,
      Q => s_axis_V_id_V_0_ack_in,
      R => ap_rst_n_inv
    );
\s_axis_V_keep_V_0_payload_A[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFAE00A2"
    )
        port map (
      I0 => s_axis_TKEEP(0),
      I1 => \s_axis_V_keep_V_0_state_reg_n_0_[0]\,
      I2 => s_axis_V_keep_V_0_ack_in,
      I3 => s_axis_V_keep_V_0_sel_wr,
      I4 => s_axis_V_keep_V_0_payload_A,
      O => \s_axis_V_keep_V_0_payload_A[0]_i_1_n_0\
    );
\s_axis_V_keep_V_0_payload_A_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \s_axis_V_keep_V_0_payload_A[0]_i_1_n_0\,
      Q => s_axis_V_keep_V_0_payload_A,
      R => '0'
    );
\s_axis_V_keep_V_0_payload_B[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"BBFB8808"
    )
        port map (
      I0 => s_axis_TKEEP(0),
      I1 => s_axis_V_keep_V_0_sel_wr,
      I2 => \s_axis_V_keep_V_0_state_reg_n_0_[0]\,
      I3 => s_axis_V_keep_V_0_ack_in,
      I4 => s_axis_V_keep_V_0_payload_B,
      O => \s_axis_V_keep_V_0_payload_B[0]_i_1_n_0\
    );
\s_axis_V_keep_V_0_payload_B_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \s_axis_V_keep_V_0_payload_B[0]_i_1_n_0\,
      Q => s_axis_V_keep_V_0_payload_B,
      R => '0'
    );
s_axis_V_keep_V_0_sel_rd_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B4"
    )
        port map (
      I0 => ap_block_pp0_stage0_11001,
      I1 => \s_axis_V_keep_V_0_state_reg_n_0_[0]\,
      I2 => s_axis_V_keep_V_0_sel,
      O => s_axis_V_keep_V_0_sel_rd_i_1_n_0
    );
s_axis_V_keep_V_0_sel_rd_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => s_axis_V_keep_V_0_sel_rd_i_1_n_0,
      Q => s_axis_V_keep_V_0_sel,
      R => ap_rst_n_inv
    );
s_axis_V_keep_V_0_sel_wr_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"78"
    )
        port map (
      I0 => s_axis_TVALID,
      I1 => s_axis_V_keep_V_0_ack_in,
      I2 => s_axis_V_keep_V_0_sel_wr,
      O => s_axis_V_keep_V_0_sel_wr_i_1_n_0
    );
s_axis_V_keep_V_0_sel_wr_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => s_axis_V_keep_V_0_sel_wr_i_1_n_0,
      Q => s_axis_V_keep_V_0_sel_wr,
      R => ap_rst_n_inv
    );
\s_axis_V_keep_V_0_state[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"A8AAA000"
    )
        port map (
      I0 => ap_rst_n,
      I1 => ap_block_pp0_stage0_11001,
      I2 => s_axis_TVALID,
      I3 => s_axis_V_keep_V_0_ack_in,
      I4 => \s_axis_V_keep_V_0_state_reg_n_0_[0]\,
      O => \s_axis_V_keep_V_0_state[0]_i_1_n_0\
    );
\s_axis_V_keep_V_0_state[1]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"75FF"
    )
        port map (
      I0 => ap_block_pp0_stage0_11001,
      I1 => s_axis_TVALID,
      I2 => s_axis_V_keep_V_0_ack_in,
      I3 => \s_axis_V_keep_V_0_state_reg_n_0_[0]\,
      O => \s_axis_V_keep_V_0_state[1]_i_1_n_0\
    );
\s_axis_V_keep_V_0_state_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \s_axis_V_keep_V_0_state[0]_i_1_n_0\,
      Q => \s_axis_V_keep_V_0_state_reg_n_0_[0]\,
      R => '0'
    );
\s_axis_V_keep_V_0_state_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \s_axis_V_keep_V_0_state[1]_i_1_n_0\,
      Q => s_axis_V_keep_V_0_ack_in,
      R => ap_rst_n_inv
    );
\s_axis_V_last_V_0_payload_A[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFAE00A2"
    )
        port map (
      I0 => s_axis_TLAST(0),
      I1 => \s_axis_V_last_V_0_state_reg_n_0_[0]\,
      I2 => s_axis_V_last_V_0_ack_in,
      I3 => s_axis_V_last_V_0_sel_wr,
      I4 => s_axis_V_last_V_0_payload_A,
      O => \s_axis_V_last_V_0_payload_A[0]_i_1_n_0\
    );
\s_axis_V_last_V_0_payload_A_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \s_axis_V_last_V_0_payload_A[0]_i_1_n_0\,
      Q => s_axis_V_last_V_0_payload_A,
      R => '0'
    );
\s_axis_V_last_V_0_payload_B[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"BBFB8808"
    )
        port map (
      I0 => s_axis_TLAST(0),
      I1 => s_axis_V_last_V_0_sel_wr,
      I2 => \s_axis_V_last_V_0_state_reg_n_0_[0]\,
      I3 => s_axis_V_last_V_0_ack_in,
      I4 => s_axis_V_last_V_0_payload_B,
      O => \s_axis_V_last_V_0_payload_B[0]_i_1_n_0\
    );
\s_axis_V_last_V_0_payload_B_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \s_axis_V_last_V_0_payload_B[0]_i_1_n_0\,
      Q => s_axis_V_last_V_0_payload_B,
      R => '0'
    );
s_axis_V_last_V_0_sel_rd_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B4"
    )
        port map (
      I0 => ap_block_pp0_stage0_11001,
      I1 => \s_axis_V_last_V_0_state_reg_n_0_[0]\,
      I2 => s_axis_V_last_V_0_sel,
      O => s_axis_V_last_V_0_sel_rd_i_1_n_0
    );
s_axis_V_last_V_0_sel_rd_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => s_axis_V_last_V_0_sel_rd_i_1_n_0,
      Q => s_axis_V_last_V_0_sel,
      R => ap_rst_n_inv
    );
s_axis_V_last_V_0_sel_wr_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"78"
    )
        port map (
      I0 => s_axis_TVALID,
      I1 => s_axis_V_last_V_0_ack_in,
      I2 => s_axis_V_last_V_0_sel_wr,
      O => s_axis_V_last_V_0_sel_wr_i_1_n_0
    );
s_axis_V_last_V_0_sel_wr_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => s_axis_V_last_V_0_sel_wr_i_1_n_0,
      Q => s_axis_V_last_V_0_sel_wr,
      R => ap_rst_n_inv
    );
\s_axis_V_last_V_0_state[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"A888A808"
    )
        port map (
      I0 => ap_rst_n,
      I1 => \s_axis_V_last_V_0_state_reg_n_0_[0]\,
      I2 => s_axis_V_last_V_0_ack_in,
      I3 => s_axis_TVALID,
      I4 => ap_block_pp0_stage0_11001,
      O => \s_axis_V_last_V_0_state[0]_i_1_n_0\
    );
\s_axis_V_last_V_0_state[1]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"75FF"
    )
        port map (
      I0 => ap_block_pp0_stage0_11001,
      I1 => s_axis_TVALID,
      I2 => s_axis_V_last_V_0_ack_in,
      I3 => \s_axis_V_last_V_0_state_reg_n_0_[0]\,
      O => \s_axis_V_last_V_0_state[1]_i_1_n_0\
    );
\s_axis_V_last_V_0_state_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \s_axis_V_last_V_0_state[0]_i_1_n_0\,
      Q => \s_axis_V_last_V_0_state_reg_n_0_[0]\,
      R => '0'
    );
\s_axis_V_last_V_0_state_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \s_axis_V_last_V_0_state[1]_i_1_n_0\,
      Q => s_axis_V_last_V_0_ack_in,
      R => ap_rst_n_inv
    );
\s_axis_V_strb_V_0_payload_A[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFAE00A2"
    )
        port map (
      I0 => s_axis_TSTRB(0),
      I1 => \s_axis_V_strb_V_0_state_reg_n_0_[0]\,
      I2 => s_axis_V_strb_V_0_ack_in,
      I3 => s_axis_V_strb_V_0_sel_wr,
      I4 => s_axis_V_strb_V_0_payload_A,
      O => \s_axis_V_strb_V_0_payload_A[0]_i_1_n_0\
    );
\s_axis_V_strb_V_0_payload_A_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \s_axis_V_strb_V_0_payload_A[0]_i_1_n_0\,
      Q => s_axis_V_strb_V_0_payload_A,
      R => '0'
    );
\s_axis_V_strb_V_0_payload_B[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"BBFB8808"
    )
        port map (
      I0 => s_axis_TSTRB(0),
      I1 => s_axis_V_strb_V_0_sel_wr,
      I2 => \s_axis_V_strb_V_0_state_reg_n_0_[0]\,
      I3 => s_axis_V_strb_V_0_ack_in,
      I4 => s_axis_V_strb_V_0_payload_B,
      O => \s_axis_V_strb_V_0_payload_B[0]_i_1_n_0\
    );
\s_axis_V_strb_V_0_payload_B_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \s_axis_V_strb_V_0_payload_B[0]_i_1_n_0\,
      Q => s_axis_V_strb_V_0_payload_B,
      R => '0'
    );
s_axis_V_strb_V_0_sel_rd_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B4"
    )
        port map (
      I0 => ap_block_pp0_stage0_11001,
      I1 => \s_axis_V_strb_V_0_state_reg_n_0_[0]\,
      I2 => s_axis_V_strb_V_0_sel,
      O => s_axis_V_strb_V_0_sel_rd_i_1_n_0
    );
s_axis_V_strb_V_0_sel_rd_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => s_axis_V_strb_V_0_sel_rd_i_1_n_0,
      Q => s_axis_V_strb_V_0_sel,
      R => ap_rst_n_inv
    );
s_axis_V_strb_V_0_sel_wr_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"78"
    )
        port map (
      I0 => s_axis_TVALID,
      I1 => s_axis_V_strb_V_0_ack_in,
      I2 => s_axis_V_strb_V_0_sel_wr,
      O => s_axis_V_strb_V_0_sel_wr_i_1_n_0
    );
s_axis_V_strb_V_0_sel_wr_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => s_axis_V_strb_V_0_sel_wr_i_1_n_0,
      Q => s_axis_V_strb_V_0_sel_wr,
      R => ap_rst_n_inv
    );
\s_axis_V_strb_V_0_state[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"A888A808"
    )
        port map (
      I0 => ap_rst_n,
      I1 => \s_axis_V_strb_V_0_state_reg_n_0_[0]\,
      I2 => s_axis_V_strb_V_0_ack_in,
      I3 => s_axis_TVALID,
      I4 => ap_block_pp0_stage0_11001,
      O => \s_axis_V_strb_V_0_state[0]_i_1_n_0\
    );
\s_axis_V_strb_V_0_state[1]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"75FF"
    )
        port map (
      I0 => ap_block_pp0_stage0_11001,
      I1 => s_axis_TVALID,
      I2 => s_axis_V_strb_V_0_ack_in,
      I3 => \s_axis_V_strb_V_0_state_reg_n_0_[0]\,
      O => \s_axis_V_strb_V_0_state[1]_i_1_n_0\
    );
\s_axis_V_strb_V_0_state_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \s_axis_V_strb_V_0_state[0]_i_1_n_0\,
      Q => \s_axis_V_strb_V_0_state_reg_n_0_[0]\,
      R => '0'
    );
\s_axis_V_strb_V_0_state_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \s_axis_V_strb_V_0_state[1]_i_1_n_0\,
      Q => s_axis_V_strb_V_0_ack_in,
      R => ap_rst_n_inv
    );
\s_axis_V_user_V_0_payload_A[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFAE00A2"
    )
        port map (
      I0 => s_axis_TUSER(0),
      I1 => \s_axis_V_user_V_0_state_reg_n_0_[0]\,
      I2 => s_axis_V_user_V_0_ack_in,
      I3 => s_axis_V_user_V_0_sel_wr,
      I4 => s_axis_V_user_V_0_payload_A,
      O => \s_axis_V_user_V_0_payload_A[0]_i_1_n_0\
    );
\s_axis_V_user_V_0_payload_A_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \s_axis_V_user_V_0_payload_A[0]_i_1_n_0\,
      Q => s_axis_V_user_V_0_payload_A,
      R => '0'
    );
\s_axis_V_user_V_0_payload_B[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"BBFB8808"
    )
        port map (
      I0 => s_axis_TUSER(0),
      I1 => s_axis_V_user_V_0_sel_wr,
      I2 => \s_axis_V_user_V_0_state_reg_n_0_[0]\,
      I3 => s_axis_V_user_V_0_ack_in,
      I4 => s_axis_V_user_V_0_payload_B,
      O => \s_axis_V_user_V_0_payload_B[0]_i_1_n_0\
    );
\s_axis_V_user_V_0_payload_B_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \s_axis_V_user_V_0_payload_B[0]_i_1_n_0\,
      Q => s_axis_V_user_V_0_payload_B,
      R => '0'
    );
s_axis_V_user_V_0_sel_rd_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B4"
    )
        port map (
      I0 => ap_block_pp0_stage0_11001,
      I1 => \s_axis_V_user_V_0_state_reg_n_0_[0]\,
      I2 => s_axis_V_user_V_0_sel,
      O => s_axis_V_user_V_0_sel_rd_i_1_n_0
    );
s_axis_V_user_V_0_sel_rd_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => s_axis_V_user_V_0_sel_rd_i_1_n_0,
      Q => s_axis_V_user_V_0_sel,
      R => ap_rst_n_inv
    );
s_axis_V_user_V_0_sel_wr_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"78"
    )
        port map (
      I0 => s_axis_V_user_V_0_ack_in,
      I1 => s_axis_TVALID,
      I2 => s_axis_V_user_V_0_sel_wr,
      O => s_axis_V_user_V_0_sel_wr_i_1_n_0
    );
s_axis_V_user_V_0_sel_wr_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => s_axis_V_user_V_0_sel_wr_i_1_n_0,
      Q => s_axis_V_user_V_0_sel_wr,
      R => ap_rst_n_inv
    );
\s_axis_V_user_V_0_state[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"A888A808"
    )
        port map (
      I0 => ap_rst_n,
      I1 => \s_axis_V_user_V_0_state_reg_n_0_[0]\,
      I2 => s_axis_V_user_V_0_ack_in,
      I3 => s_axis_TVALID,
      I4 => ap_block_pp0_stage0_11001,
      O => \s_axis_V_user_V_0_state[0]_i_1_n_0\
    );
\s_axis_V_user_V_0_state[1]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"75FF"
    )
        port map (
      I0 => ap_block_pp0_stage0_11001,
      I1 => s_axis_TVALID,
      I2 => s_axis_V_user_V_0_ack_in,
      I3 => \s_axis_V_user_V_0_state_reg_n_0_[0]\,
      O => \s_axis_V_user_V_0_state[1]_i_1_n_0\
    );
\s_axis_V_user_V_0_state_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \s_axis_V_user_V_0_state[0]_i_1_n_0\,
      Q => \s_axis_V_user_V_0_state_reg_n_0_[0]\,
      R => '0'
    );
\s_axis_V_user_V_0_state_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \s_axis_V_user_V_0_state[1]_i_1_n_0\,
      Q => s_axis_V_user_V_0_ack_in,
      R => ap_rst_n_inv
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity cubeocc_hls_0 is
  port (
    ap_clk : in STD_LOGIC;
    ap_rst_n : in STD_LOGIC;
    s_axis_TVALID : in STD_LOGIC;
    s_axis_TREADY : out STD_LOGIC;
    s_axis_TDATA : in STD_LOGIC_VECTOR ( 7 downto 0 );
    s_axis_TDEST : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axis_TKEEP : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axis_TSTRB : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axis_TUSER : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axis_TLAST : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axis_TID : in STD_LOGIC_VECTOR ( 0 to 0 );
    m_axis_TVALID : out STD_LOGIC;
    m_axis_TREADY : in STD_LOGIC;
    m_axis_TDATA : out STD_LOGIC_VECTOR ( 7 downto 0 );
    m_axis_TDEST : out STD_LOGIC_VECTOR ( 0 to 0 );
    m_axis_TKEEP : out STD_LOGIC_VECTOR ( 0 to 0 );
    m_axis_TSTRB : out STD_LOGIC_VECTOR ( 0 to 0 );
    m_axis_TUSER : out STD_LOGIC_VECTOR ( 0 to 0 );
    m_axis_TLAST : out STD_LOGIC_VECTOR ( 0 to 0 );
    m_axis_TID : out STD_LOGIC_VECTOR ( 0 to 0 )
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of cubeocc_hls_0 : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of cubeocc_hls_0 : entity is "cubeocc_hls_0,cubeocc_hls,{}";
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of cubeocc_hls_0 : entity is "yes";
  attribute IP_DEFINITION_SOURCE : string;
  attribute IP_DEFINITION_SOURCE of cubeocc_hls_0 : entity is "HLS";
  attribute X_CORE_INFO : string;
  attribute X_CORE_INFO of cubeocc_hls_0 : entity is "cubeocc_hls,Vivado 2019.1";
  attribute hls_module : string;
  attribute hls_module of cubeocc_hls_0 : entity is "yes";
end cubeocc_hls_0;

architecture STRUCTURE of cubeocc_hls_0 is
  attribute ap_ST_fsm_pp0_stage0 : string;
  attribute ap_ST_fsm_pp0_stage0 of inst : label is "1'b1";
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of ap_clk : signal is "xilinx.com:signal:clock:1.0 ap_clk CLK";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of ap_clk : signal is "XIL_INTERFACENAME ap_clk, ASSOCIATED_BUSIF s_axis:m_axis, ASSOCIATED_RESET ap_rst_n, FREQ_HZ 100000000, PHASE 0.000, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of ap_rst_n : signal is "xilinx.com:signal:reset:1.0 ap_rst_n RST";
  attribute X_INTERFACE_PARAMETER of ap_rst_n : signal is "XIL_INTERFACENAME ap_rst_n, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of m_axis_TREADY : signal is "xilinx.com:interface:axis:1.0 m_axis TREADY";
  attribute X_INTERFACE_INFO of m_axis_TVALID : signal is "xilinx.com:interface:axis:1.0 m_axis TVALID";
  attribute X_INTERFACE_INFO of s_axis_TREADY : signal is "xilinx.com:interface:axis:1.0 s_axis TREADY";
  attribute X_INTERFACE_INFO of s_axis_TVALID : signal is "xilinx.com:interface:axis:1.0 s_axis TVALID";
  attribute X_INTERFACE_INFO of m_axis_TDATA : signal is "xilinx.com:interface:axis:1.0 m_axis TDATA";
  attribute X_INTERFACE_INFO of m_axis_TDEST : signal is "xilinx.com:interface:axis:1.0 m_axis TDEST";
  attribute X_INTERFACE_INFO of m_axis_TID : signal is "xilinx.com:interface:axis:1.0 m_axis TID";
  attribute X_INTERFACE_PARAMETER of m_axis_TID : signal is "XIL_INTERFACENAME m_axis, TDATA_NUM_BYTES 1, TDEST_WIDTH 1, TID_WIDTH 1, TUSER_WIDTH 1, HAS_TREADY 1, HAS_TSTRB 1, HAS_TKEEP 1, HAS_TLAST 1, FREQ_HZ 100000000, PHASE 0.000, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of m_axis_TKEEP : signal is "xilinx.com:interface:axis:1.0 m_axis TKEEP";
  attribute X_INTERFACE_INFO of m_axis_TLAST : signal is "xilinx.com:interface:axis:1.0 m_axis TLAST";
  attribute X_INTERFACE_INFO of m_axis_TSTRB : signal is "xilinx.com:interface:axis:1.0 m_axis TSTRB";
  attribute X_INTERFACE_INFO of m_axis_TUSER : signal is "xilinx.com:interface:axis:1.0 m_axis TUSER";
  attribute X_INTERFACE_INFO of s_axis_TDATA : signal is "xilinx.com:interface:axis:1.0 s_axis TDATA";
  attribute X_INTERFACE_INFO of s_axis_TDEST : signal is "xilinx.com:interface:axis:1.0 s_axis TDEST";
  attribute X_INTERFACE_INFO of s_axis_TID : signal is "xilinx.com:interface:axis:1.0 s_axis TID";
  attribute X_INTERFACE_PARAMETER of s_axis_TID : signal is "XIL_INTERFACENAME s_axis, TDATA_NUM_BYTES 1, TDEST_WIDTH 1, TID_WIDTH 1, TUSER_WIDTH 1, HAS_TREADY 1, HAS_TSTRB 1, HAS_TKEEP 1, HAS_TLAST 1, FREQ_HZ 100000000, PHASE 0.000, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of s_axis_TKEEP : signal is "xilinx.com:interface:axis:1.0 s_axis TKEEP";
  attribute X_INTERFACE_INFO of s_axis_TLAST : signal is "xilinx.com:interface:axis:1.0 s_axis TLAST";
  attribute X_INTERFACE_INFO of s_axis_TSTRB : signal is "xilinx.com:interface:axis:1.0 s_axis TSTRB";
  attribute X_INTERFACE_INFO of s_axis_TUSER : signal is "xilinx.com:interface:axis:1.0 s_axis TUSER";
begin
inst: entity work.cubeocc_hls_0_cubeocc_hls
     port map (
      ap_clk => ap_clk,
      ap_rst_n => ap_rst_n,
      m_axis_TDATA(7 downto 0) => m_axis_TDATA(7 downto 0),
      m_axis_TDEST(0) => m_axis_TDEST(0),
      m_axis_TID(0) => m_axis_TID(0),
      m_axis_TKEEP(0) => m_axis_TKEEP(0),
      m_axis_TLAST(0) => m_axis_TLAST(0),
      m_axis_TREADY => m_axis_TREADY,
      m_axis_TSTRB(0) => m_axis_TSTRB(0),
      m_axis_TUSER(0) => m_axis_TUSER(0),
      m_axis_TVALID => m_axis_TVALID,
      s_axis_TDATA(7 downto 0) => s_axis_TDATA(7 downto 0),
      s_axis_TDEST(0) => s_axis_TDEST(0),
      s_axis_TID(0) => s_axis_TID(0),
      s_axis_TKEEP(0) => s_axis_TKEEP(0),
      s_axis_TLAST(0) => s_axis_TLAST(0),
      s_axis_TREADY => s_axis_TREADY,
      s_axis_TSTRB(0) => s_axis_TSTRB(0),
      s_axis_TUSER(0) => s_axis_TUSER(0),
      s_axis_TVALID => s_axis_TVALID
    );
end STRUCTURE;
