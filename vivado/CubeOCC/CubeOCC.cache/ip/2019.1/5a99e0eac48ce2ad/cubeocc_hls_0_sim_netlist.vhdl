-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
-- Date        : Tue Aug 25 23:02:59 2026
-- Host        : ARSHMINGHM-LAPTOP running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
--               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ cubeocc_hls_0_sim_netlist.vhdl
-- Design      : cubeocc_hls_0
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7a35tcpg236-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_cubeocc_hls_CTRL_s_axi is
  port (
    ap_rst_n_inv : out STD_LOGIC;
    ap_done : out STD_LOGIC;
    threshold_enable : out STD_LOGIC;
    \ap_CS_fsm_reg[0]\ : out STD_LOGIC;
    \FSM_onehot_wstate_reg[2]_0\ : out STD_LOGIC;
    s_axi_CTRL_BVALID : out STD_LOGIC;
    \int_pixel_count_reg[31]_0\ : out STD_LOGIC_VECTOR ( 31 downto 0 );
    \int_threshold_V_reg[7]_0\ : out STD_LOGIC_VECTOR ( 7 downto 0 );
    \FSM_onehot_rstate_reg[1]_0\ : out STD_LOGIC;
    s_axi_CTRL_RVALID : out STD_LOGIC;
    D : out STD_LOGIC_VECTOR ( 1 downto 0 );
    interrupt : out STD_LOGIC;
    i_0_reg_143 : out STD_LOGIC;
    \ap_CS_fsm_reg[1]\ : out STD_LOGIC;
    E : out STD_LOGIC_VECTOR ( 0 to 0 );
    \FSM_onehot_wstate_reg[1]_0\ : out STD_LOGIC;
    s_axi_CTRL_RDATA : out STD_LOGIC_VECTOR ( 31 downto 0 );
    ap_clk : in STD_LOGIC;
    Q : in STD_LOGIC_VECTOR ( 2 downto 0 );
    ap_enable_reg_pp0_iter2_reg : in STD_LOGIC;
    ap_block_pp0_stage0_subdone3_in : in STD_LOGIC;
    ap_enable_reg_pp0_iter2_reg_0 : in STD_LOGIC;
    ap_rst_n : in STD_LOGIC;
    s_axi_CTRL_WDATA : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_CTRL_WSTRB : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_CTRL_WVALID : in STD_LOGIC;
    s_axi_CTRL_BREADY : in STD_LOGIC;
    s_axi_CTRL_ARADDR : in STD_LOGIC_VECTOR ( 5 downto 0 );
    s_axi_CTRL_ARVALID : in STD_LOGIC;
    s_axi_CTRL_RREADY : in STD_LOGIC;
    int_ap_ready_reg_0 : in STD_LOGIC;
    m_axis_TREADY : in STD_LOGIC;
    m_axis_V_strb_V_1_ack_in : in STD_LOGIC;
    int_ap_ready_reg_1 : in STD_LOGIC;
    m_axis_V_last_V_1_ack_in : in STD_LOGIC;
    int_ap_ready_reg_2 : in STD_LOGIC;
    m_axis_V_user_V_1_ack_in : in STD_LOGIC;
    int_ap_ready_reg_3 : in STD_LOGIC;
    m_axis_V_id_V_1_ack_in : in STD_LOGIC;
    int_ap_ready_reg_4 : in STD_LOGIC;
    m_axis_V_keep_V_1_ack_in : in STD_LOGIC;
    int_ap_ready_i_2_0 : in STD_LOGIC;
    m_axis_V_data_V_1_ack_in : in STD_LOGIC;
    int_ap_ready_i_2_1 : in STD_LOGIC;
    m_axis_V_dest_V_1_ack_in : in STD_LOGIC;
    \ap_CS_fsm_reg[1]_0\ : in STD_LOGIC;
    \i_0_reg_143_reg[0]\ : in STD_LOGIC;
    CO : in STD_LOGIC_VECTOR ( 0 to 0 );
    ap_enable_reg_pp0_iter0 : in STD_LOGIC;
    s_axi_CTRL_AWVALID : in STD_LOGIC;
    s_axi_CTRL_AWADDR : in STD_LOGIC_VECTOR ( 5 downto 0 )
  );
end decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_cubeocc_hls_CTRL_s_axi;

architecture STRUCTURE of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_cubeocc_hls_CTRL_s_axi is
  signal \^e\ : STD_LOGIC_VECTOR ( 0 to 0 );
  signal \FSM_onehot_rstate[1]_i_1_n_1\ : STD_LOGIC;
  signal \FSM_onehot_rstate[2]_i_1_n_1\ : STD_LOGIC;
  signal \^fsm_onehot_rstate_reg[1]_0\ : STD_LOGIC;
  signal \FSM_onehot_wstate[1]_i_1_n_1\ : STD_LOGIC;
  signal \FSM_onehot_wstate[2]_i_1_n_1\ : STD_LOGIC;
  signal \FSM_onehot_wstate[3]_i_1_n_1\ : STD_LOGIC;
  signal \^fsm_onehot_wstate_reg[1]_0\ : STD_LOGIC;
  signal \^fsm_onehot_wstate_reg[2]_0\ : STD_LOGIC;
  signal \^ap_done\ : STD_LOGIC;
  signal ap_idle : STD_LOGIC;
  signal \^ap_rst_n_inv\ : STD_LOGIC;
  signal ap_start : STD_LOGIC;
  signal ar_hs : STD_LOGIC;
  signal int_ap_done : STD_LOGIC;
  signal int_ap_done_i_1_n_1 : STD_LOGIC;
  signal int_ap_done_i_2_n_1 : STD_LOGIC;
  signal int_ap_idle : STD_LOGIC;
  signal int_ap_ready : STD_LOGIC;
  signal int_ap_ready_i_2_n_1 : STD_LOGIC;
  signal int_ap_ready_i_3_n_1 : STD_LOGIC;
  signal int_ap_ready_i_4_n_1 : STD_LOGIC;
  signal int_ap_ready_i_5_n_1 : STD_LOGIC;
  signal int_ap_ready_i_6_n_1 : STD_LOGIC;
  signal int_ap_ready_i_7_n_1 : STD_LOGIC;
  signal int_ap_start3_out : STD_LOGIC;
  signal int_ap_start_i_1_n_1 : STD_LOGIC;
  signal int_ap_start_i_3_n_1 : STD_LOGIC;
  signal int_auto_restart : STD_LOGIC;
  signal int_auto_restart_i_1_n_1 : STD_LOGIC;
  signal int_gie_i_1_n_1 : STD_LOGIC;
  signal int_gie_reg_n_1 : STD_LOGIC;
  signal \int_ier[0]_i_1_n_1\ : STD_LOGIC;
  signal \int_ier[1]_i_1_n_1\ : STD_LOGIC;
  signal \int_ier[1]_i_2_n_1\ : STD_LOGIC;
  signal \int_ier_reg_n_1_[0]\ : STD_LOGIC;
  signal int_isr6_out : STD_LOGIC;
  signal \int_isr[0]_i_1_n_1\ : STD_LOGIC;
  signal \int_isr[1]_i_1_n_1\ : STD_LOGIC;
  signal \int_isr_reg_n_1_[0]\ : STD_LOGIC;
  signal \int_pixel_count[0]_i_1_n_1\ : STD_LOGIC;
  signal \int_pixel_count[10]_i_1_n_1\ : STD_LOGIC;
  signal \int_pixel_count[11]_i_1_n_1\ : STD_LOGIC;
  signal \int_pixel_count[12]_i_1_n_1\ : STD_LOGIC;
  signal \int_pixel_count[13]_i_1_n_1\ : STD_LOGIC;
  signal \int_pixel_count[14]_i_1_n_1\ : STD_LOGIC;
  signal \int_pixel_count[15]_i_1_n_1\ : STD_LOGIC;
  signal \int_pixel_count[16]_i_1_n_1\ : STD_LOGIC;
  signal \int_pixel_count[17]_i_1_n_1\ : STD_LOGIC;
  signal \int_pixel_count[18]_i_1_n_1\ : STD_LOGIC;
  signal \int_pixel_count[19]_i_1_n_1\ : STD_LOGIC;
  signal \int_pixel_count[1]_i_1_n_1\ : STD_LOGIC;
  signal \int_pixel_count[20]_i_1_n_1\ : STD_LOGIC;
  signal \int_pixel_count[21]_i_1_n_1\ : STD_LOGIC;
  signal \int_pixel_count[22]_i_1_n_1\ : STD_LOGIC;
  signal \int_pixel_count[23]_i_1_n_1\ : STD_LOGIC;
  signal \int_pixel_count[24]_i_1_n_1\ : STD_LOGIC;
  signal \int_pixel_count[25]_i_1_n_1\ : STD_LOGIC;
  signal \int_pixel_count[26]_i_1_n_1\ : STD_LOGIC;
  signal \int_pixel_count[27]_i_1_n_1\ : STD_LOGIC;
  signal \int_pixel_count[28]_i_1_n_1\ : STD_LOGIC;
  signal \int_pixel_count[29]_i_1_n_1\ : STD_LOGIC;
  signal \int_pixel_count[2]_i_1_n_1\ : STD_LOGIC;
  signal \int_pixel_count[30]_i_1_n_1\ : STD_LOGIC;
  signal \int_pixel_count[31]_i_1_n_1\ : STD_LOGIC;
  signal \int_pixel_count[31]_i_2_n_1\ : STD_LOGIC;
  signal \int_pixel_count[31]_i_3_n_1\ : STD_LOGIC;
  signal \int_pixel_count[3]_i_1_n_1\ : STD_LOGIC;
  signal \int_pixel_count[4]_i_1_n_1\ : STD_LOGIC;
  signal \int_pixel_count[5]_i_1_n_1\ : STD_LOGIC;
  signal \int_pixel_count[6]_i_1_n_1\ : STD_LOGIC;
  signal \int_pixel_count[7]_i_1_n_1\ : STD_LOGIC;
  signal \int_pixel_count[8]_i_1_n_1\ : STD_LOGIC;
  signal \int_pixel_count[9]_i_1_n_1\ : STD_LOGIC;
  signal \^int_pixel_count_reg[31]_0\ : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \int_threshold_V[0]_i_1_n_1\ : STD_LOGIC;
  signal \int_threshold_V[1]_i_1_n_1\ : STD_LOGIC;
  signal \int_threshold_V[2]_i_1_n_1\ : STD_LOGIC;
  signal \int_threshold_V[3]_i_1_n_1\ : STD_LOGIC;
  signal \int_threshold_V[4]_i_1_n_1\ : STD_LOGIC;
  signal \int_threshold_V[5]_i_1_n_1\ : STD_LOGIC;
  signal \int_threshold_V[6]_i_1_n_1\ : STD_LOGIC;
  signal \int_threshold_V[7]_i_1_n_1\ : STD_LOGIC;
  signal \int_threshold_V[7]_i_2_n_1\ : STD_LOGIC;
  signal \^int_threshold_v_reg[7]_0\ : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal \int_threshold_enable[0]_i_1_n_1\ : STD_LOGIC;
  signal \int_threshold_enable[0]_i_2_n_1\ : STD_LOGIC;
  signal \int_threshold_enable[0]_i_3_n_1\ : STD_LOGIC;
  signal p_0_in : STD_LOGIC;
  signal p_1_in : STD_LOGIC;
  signal rdata : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal \rdata[0]_i_2_n_1\ : STD_LOGIC;
  signal \rdata[0]_i_3_n_1\ : STD_LOGIC;
  signal \rdata[1]_i_2_n_1\ : STD_LOGIC;
  signal \rdata[31]_i_1_n_1\ : STD_LOGIC;
  signal \rdata[31]_i_3_n_1\ : STD_LOGIC;
  signal \rdata[6]_i_2_n_1\ : STD_LOGIC;
  signal \rdata[7]_i_2_n_1\ : STD_LOGIC;
  signal \rdata[7]_i_3_n_1\ : STD_LOGIC;
  signal \rdata[7]_i_4_n_1\ : STD_LOGIC;
  signal \^s_axi_ctrl_bvalid\ : STD_LOGIC;
  signal \^s_axi_ctrl_rvalid\ : STD_LOGIC;
  signal \^threshold_enable\ : STD_LOGIC;
  signal waddr : STD_LOGIC;
  signal \waddr_reg_n_1_[0]\ : STD_LOGIC;
  signal \waddr_reg_n_1_[1]\ : STD_LOGIC;
  signal \waddr_reg_n_1_[2]\ : STD_LOGIC;
  signal \waddr_reg_n_1_[3]\ : STD_LOGIC;
  signal \waddr_reg_n_1_[4]\ : STD_LOGIC;
  signal \waddr_reg_n_1_[5]\ : STD_LOGIC;
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \FSM_onehot_rstate[1]_i_1\ : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of \FSM_onehot_rstate[2]_i_1\ : label is "soft_lutpair4";
  attribute FSM_ENCODED_STATES : string;
  attribute FSM_ENCODED_STATES of \FSM_onehot_rstate_reg[1]\ : label is "RDIDLE:010,RDDATA:100,iSTATE:001";
  attribute FSM_ENCODED_STATES of \FSM_onehot_rstate_reg[2]\ : label is "RDIDLE:010,RDDATA:100,iSTATE:001";
  attribute FSM_ENCODED_STATES of \FSM_onehot_wstate_reg[1]\ : label is "WRDATA:0100,WRRESP:1000,WRIDLE:0010,iSTATE:0001";
  attribute FSM_ENCODED_STATES of \FSM_onehot_wstate_reg[2]\ : label is "WRDATA:0100,WRRESP:1000,WRIDLE:0010,iSTATE:0001";
  attribute FSM_ENCODED_STATES of \FSM_onehot_wstate_reg[3]\ : label is "WRDATA:0100,WRRESP:1000,WRIDLE:0010,iSTATE:0001";
  attribute SOFT_HLUTNM of \ap_CS_fsm[0]_i_1\ : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of \ap_CS_fsm[1]_i_1\ : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of \i_0_reg_143[0]_i_1\ : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of int_ap_idle_i_1 : label is "soft_lutpair25";
  attribute SOFT_HLUTNM of int_ap_start_i_1 : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of int_ap_start_i_3 : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of \int_ier[1]_i_2\ : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of \int_isr[0]_i_2\ : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of \int_pixel_count[0]_i_1\ : label is "soft_lutpair20";
  attribute SOFT_HLUTNM of \int_pixel_count[10]_i_1\ : label is "soft_lutpair15";
  attribute SOFT_HLUTNM of \int_pixel_count[11]_i_1\ : label is "soft_lutpair15";
  attribute SOFT_HLUTNM of \int_pixel_count[12]_i_1\ : label is "soft_lutpair14";
  attribute SOFT_HLUTNM of \int_pixel_count[13]_i_1\ : label is "soft_lutpair14";
  attribute SOFT_HLUTNM of \int_pixel_count[14]_i_1\ : label is "soft_lutpair13";
  attribute SOFT_HLUTNM of \int_pixel_count[15]_i_1\ : label is "soft_lutpair13";
  attribute SOFT_HLUTNM of \int_pixel_count[16]_i_1\ : label is "soft_lutpair12";
  attribute SOFT_HLUTNM of \int_pixel_count[17]_i_1\ : label is "soft_lutpair12";
  attribute SOFT_HLUTNM of \int_pixel_count[18]_i_1\ : label is "soft_lutpair11";
  attribute SOFT_HLUTNM of \int_pixel_count[19]_i_1\ : label is "soft_lutpair11";
  attribute SOFT_HLUTNM of \int_pixel_count[1]_i_1\ : label is "soft_lutpair20";
  attribute SOFT_HLUTNM of \int_pixel_count[20]_i_1\ : label is "soft_lutpair10";
  attribute SOFT_HLUTNM of \int_pixel_count[21]_i_1\ : label is "soft_lutpair10";
  attribute SOFT_HLUTNM of \int_pixel_count[22]_i_1\ : label is "soft_lutpair9";
  attribute SOFT_HLUTNM of \int_pixel_count[23]_i_1\ : label is "soft_lutpair9";
  attribute SOFT_HLUTNM of \int_pixel_count[24]_i_1\ : label is "soft_lutpair8";
  attribute SOFT_HLUTNM of \int_pixel_count[25]_i_1\ : label is "soft_lutpair8";
  attribute SOFT_HLUTNM of \int_pixel_count[26]_i_1\ : label is "soft_lutpair7";
  attribute SOFT_HLUTNM of \int_pixel_count[27]_i_1\ : label is "soft_lutpair7";
  attribute SOFT_HLUTNM of \int_pixel_count[28]_i_1\ : label is "soft_lutpair6";
  attribute SOFT_HLUTNM of \int_pixel_count[29]_i_1\ : label is "soft_lutpair6";
  attribute SOFT_HLUTNM of \int_pixel_count[2]_i_1\ : label is "soft_lutpair19";
  attribute SOFT_HLUTNM of \int_pixel_count[30]_i_1\ : label is "soft_lutpair5";
  attribute SOFT_HLUTNM of \int_pixel_count[31]_i_2\ : label is "soft_lutpair5";
  attribute SOFT_HLUTNM of \int_pixel_count[3]_i_1\ : label is "soft_lutpair19";
  attribute SOFT_HLUTNM of \int_pixel_count[4]_i_1\ : label is "soft_lutpair18";
  attribute SOFT_HLUTNM of \int_pixel_count[5]_i_1\ : label is "soft_lutpair18";
  attribute SOFT_HLUTNM of \int_pixel_count[6]_i_1\ : label is "soft_lutpair17";
  attribute SOFT_HLUTNM of \int_pixel_count[7]_i_1\ : label is "soft_lutpair17";
  attribute SOFT_HLUTNM of \int_pixel_count[8]_i_1\ : label is "soft_lutpair16";
  attribute SOFT_HLUTNM of \int_pixel_count[9]_i_1\ : label is "soft_lutpair16";
  attribute SOFT_HLUTNM of \int_threshold_V[0]_i_1\ : label is "soft_lutpair24";
  attribute SOFT_HLUTNM of \int_threshold_V[1]_i_1\ : label is "soft_lutpair24";
  attribute SOFT_HLUTNM of \int_threshold_V[2]_i_1\ : label is "soft_lutpair23";
  attribute SOFT_HLUTNM of \int_threshold_V[3]_i_1\ : label is "soft_lutpair23";
  attribute SOFT_HLUTNM of \int_threshold_V[4]_i_1\ : label is "soft_lutpair22";
  attribute SOFT_HLUTNM of \int_threshold_V[5]_i_1\ : label is "soft_lutpair22";
  attribute SOFT_HLUTNM of \int_threshold_V[6]_i_1\ : label is "soft_lutpair21";
  attribute SOFT_HLUTNM of \int_threshold_V[7]_i_2\ : label is "soft_lutpair21";
  attribute SOFT_HLUTNM of \int_threshold_enable[0]_i_2\ : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of \pixel_count_read_reg_227[31]_i_1\ : label is "soft_lutpair25";
begin
  E(0) <= \^e\(0);
  \FSM_onehot_rstate_reg[1]_0\ <= \^fsm_onehot_rstate_reg[1]_0\;
  \FSM_onehot_wstate_reg[1]_0\ <= \^fsm_onehot_wstate_reg[1]_0\;
  \FSM_onehot_wstate_reg[2]_0\ <= \^fsm_onehot_wstate_reg[2]_0\;
  ap_done <= \^ap_done\;
  ap_rst_n_inv <= \^ap_rst_n_inv\;
  \int_pixel_count_reg[31]_0\(31 downto 0) <= \^int_pixel_count_reg[31]_0\(31 downto 0);
  \int_threshold_V_reg[7]_0\(7 downto 0) <= \^int_threshold_v_reg[7]_0\(7 downto 0);
  s_axi_CTRL_BVALID <= \^s_axi_ctrl_bvalid\;
  s_axi_CTRL_RVALID <= \^s_axi_ctrl_rvalid\;
  threshold_enable <= \^threshold_enable\;
\FSM_onehot_rstate[1]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8BFB"
    )
        port map (
      I0 => s_axi_CTRL_RREADY,
      I1 => \^s_axi_ctrl_rvalid\,
      I2 => \^fsm_onehot_rstate_reg[1]_0\,
      I3 => s_axi_CTRL_ARVALID,
      O => \FSM_onehot_rstate[1]_i_1_n_1\
    );
\FSM_onehot_rstate[2]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8F88"
    )
        port map (
      I0 => \^fsm_onehot_rstate_reg[1]_0\,
      I1 => s_axi_CTRL_ARVALID,
      I2 => s_axi_CTRL_RREADY,
      I3 => \^s_axi_ctrl_rvalid\,
      O => \FSM_onehot_rstate[2]_i_1_n_1\
    );
\FSM_onehot_rstate_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \FSM_onehot_rstate[1]_i_1_n_1\,
      Q => \^fsm_onehot_rstate_reg[1]_0\,
      R => \^ap_rst_n_inv\
    );
\FSM_onehot_rstate_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \FSM_onehot_rstate[2]_i_1_n_1\,
      Q => \^s_axi_ctrl_rvalid\,
      R => \^ap_rst_n_inv\
    );
\FSM_onehot_wstate[1]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"BABA303F"
    )
        port map (
      I0 => s_axi_CTRL_BREADY,
      I1 => s_axi_CTRL_AWVALID,
      I2 => \^fsm_onehot_wstate_reg[1]_0\,
      I3 => \^fsm_onehot_wstate_reg[2]_0\,
      I4 => \^s_axi_ctrl_bvalid\,
      O => \FSM_onehot_wstate[1]_i_1_n_1\
    );
\FSM_onehot_wstate[2]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F444"
    )
        port map (
      I0 => s_axi_CTRL_WVALID,
      I1 => \^fsm_onehot_wstate_reg[2]_0\,
      I2 => \^fsm_onehot_wstate_reg[1]_0\,
      I3 => s_axi_CTRL_AWVALID,
      O => \FSM_onehot_wstate[2]_i_1_n_1\
    );
\FSM_onehot_wstate[3]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8F88"
    )
        port map (
      I0 => \^fsm_onehot_wstate_reg[2]_0\,
      I1 => s_axi_CTRL_WVALID,
      I2 => s_axi_CTRL_BREADY,
      I3 => \^s_axi_ctrl_bvalid\,
      O => \FSM_onehot_wstate[3]_i_1_n_1\
    );
\FSM_onehot_wstate_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \FSM_onehot_wstate[1]_i_1_n_1\,
      Q => \^fsm_onehot_wstate_reg[1]_0\,
      R => \^ap_rst_n_inv\
    );
\FSM_onehot_wstate_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \FSM_onehot_wstate[2]_i_1_n_1\,
      Q => \^fsm_onehot_wstate_reg[2]_0\,
      R => \^ap_rst_n_inv\
    );
\FSM_onehot_wstate_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \FSM_onehot_wstate[3]_i_1_n_1\,
      Q => \^s_axi_ctrl_bvalid\,
      R => \^ap_rst_n_inv\
    );
\ap_CS_fsm[0]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"BA"
    )
        port map (
      I0 => \^ap_done\,
      I1 => ap_start,
      I2 => Q(0),
      O => D(0)
    );
\ap_CS_fsm[1]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"EAE0"
    )
        port map (
      I0 => Q(1),
      I1 => ap_start,
      I2 => Q(0),
      I3 => \ap_CS_fsm_reg[1]_0\,
      O => D(1)
    );
ap_enable_reg_pp0_iter0_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F7F7F70000000000"
    )
        port map (
      I0 => Q(1),
      I1 => ap_block_pp0_stage0_subdone3_in,
      I2 => CO(0),
      I3 => \^e\(0),
      I4 => ap_enable_reg_pp0_iter0,
      I5 => ap_rst_n,
      O => \ap_CS_fsm_reg[1]\
    );
ap_enable_reg_pp0_iter2_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F077F00000000000"
    )
        port map (
      I0 => Q(0),
      I1 => ap_start,
      I2 => ap_enable_reg_pp0_iter2_reg,
      I3 => ap_block_pp0_stage0_subdone3_in,
      I4 => ap_enable_reg_pp0_iter2_reg_0,
      I5 => ap_rst_n,
      O => \ap_CS_fsm_reg[0]\
    );
\i_0_reg_143[0]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => ap_start,
      I1 => Q(0),
      I2 => \i_0_reg_143_reg[0]\,
      O => i_0_reg_143
    );
int_ap_done_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFEAAAAAAAA"
    )
        port map (
      I0 => \^ap_done\,
      I1 => int_ap_done_i_2_n_1,
      I2 => s_axi_CTRL_ARADDR(1),
      I3 => s_axi_CTRL_ARADDR(0),
      I4 => s_axi_CTRL_ARADDR(2),
      I5 => int_ap_done,
      O => int_ap_done_i_1_n_1
    );
int_ap_done_i_2: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFFF7"
    )
        port map (
      I0 => \^fsm_onehot_rstate_reg[1]_0\,
      I1 => s_axi_CTRL_ARVALID,
      I2 => s_axi_CTRL_ARADDR(5),
      I3 => s_axi_CTRL_ARADDR(4),
      I4 => s_axi_CTRL_ARADDR(3),
      O => int_ap_done_i_2_n_1
    );
int_ap_done_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => int_ap_done_i_1_n_1,
      Q => int_ap_done,
      R => \^ap_rst_n_inv\
    );
int_ap_idle_i_1: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => Q(0),
      I1 => ap_start,
      O => ap_idle
    );
int_ap_idle_reg: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => ap_idle,
      Q => int_ap_idle,
      R => \^ap_rst_n_inv\
    );
int_ap_ready_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000000000000A222"
    )
        port map (
      I0 => int_ap_ready_i_2_n_1,
      I1 => int_ap_ready_reg_0,
      I2 => m_axis_TREADY,
      I3 => m_axis_V_strb_V_1_ack_in,
      I4 => int_ap_ready_i_3_n_1,
      I5 => int_ap_ready_i_4_n_1,
      O => \^ap_done\
    );
int_ap_ready_i_2: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAAABBBABBBABBB"
    )
        port map (
      I0 => m_axis_TREADY,
      I1 => int_ap_ready_i_5_n_1,
      I2 => int_ap_ready_reg_4,
      I3 => m_axis_V_keep_V_1_ack_in,
      I4 => int_ap_ready_reg_3,
      I5 => m_axis_V_id_V_1_ack_in,
      O => int_ap_ready_i_2_n_1
    );
int_ap_ready_i_3: unisim.vcomponents.LUT6
    generic map(
      INIT => X"2AFF2AFFFFFF2AFF"
    )
        port map (
      I0 => int_ap_ready_reg_1,
      I1 => m_axis_TREADY,
      I2 => m_axis_V_last_V_1_ack_in,
      I3 => Q(2),
      I4 => int_ap_ready_reg_2,
      I5 => m_axis_V_user_V_1_ack_in,
      O => int_ap_ready_i_3_n_1
    );
int_ap_ready_i_4: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFFF22F2"
    )
        port map (
      I0 => int_ap_ready_reg_3,
      I1 => m_axis_V_id_V_1_ack_in,
      I2 => int_ap_ready_reg_4,
      I3 => m_axis_V_keep_V_1_ack_in,
      I4 => int_ap_ready_i_6_n_1,
      I5 => int_ap_ready_i_7_n_1,
      O => int_ap_ready_i_4_n_1
    );
int_ap_ready_i_5: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFF888F888F888"
    )
        port map (
      I0 => int_ap_ready_i_2_0,
      I1 => m_axis_V_data_V_1_ack_in,
      I2 => m_axis_V_user_V_1_ack_in,
      I3 => int_ap_ready_reg_2,
      I4 => m_axis_V_dest_V_1_ack_in,
      I5 => int_ap_ready_i_2_1,
      O => int_ap_ready_i_5_n_1
    );
int_ap_ready_i_6: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => int_ap_ready_i_2_0,
      I1 => m_axis_V_data_V_1_ack_in,
      O => int_ap_ready_i_6_n_1
    );
int_ap_ready_i_7: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => int_ap_ready_i_2_1,
      I1 => m_axis_V_dest_V_1_ack_in,
      O => int_ap_ready_i_7_n_1
    );
int_ap_ready_reg: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \^ap_done\,
      Q => int_ap_ready,
      R => \^ap_rst_n_inv\
    );
int_ap_start_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FBF8"
    )
        port map (
      I0 => int_auto_restart,
      I1 => \^ap_done\,
      I2 => int_ap_start3_out,
      I3 => ap_start,
      O => int_ap_start_i_1_n_1
    );
int_ap_start_i_2: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000020000"
    )
        port map (
      I0 => s_axi_CTRL_WDATA(0),
      I1 => \waddr_reg_n_1_[3]\,
      I2 => \waddr_reg_n_1_[2]\,
      I3 => int_ap_start_i_3_n_1,
      I4 => s_axi_CTRL_WSTRB(0),
      I5 => \waddr_reg_n_1_[4]\,
      O => int_ap_start3_out
    );
int_ap_start_i_3: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFFBF"
    )
        port map (
      I0 => \waddr_reg_n_1_[5]\,
      I1 => s_axi_CTRL_WVALID,
      I2 => \^fsm_onehot_wstate_reg[2]_0\,
      I3 => \waddr_reg_n_1_[0]\,
      I4 => \waddr_reg_n_1_[1]\,
      O => int_ap_start_i_3_n_1
    );
int_ap_start_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => int_ap_start_i_1_n_1,
      Q => ap_start,
      R => \^ap_rst_n_inv\
    );
int_auto_restart_i_1: unisim.vcomponents.LUT5
    generic map(
      INIT => X"AAABAAA8"
    )
        port map (
      I0 => int_auto_restart,
      I1 => \int_ier[1]_i_2_n_1\,
      I2 => \waddr_reg_n_1_[2]\,
      I3 => \waddr_reg_n_1_[3]\,
      I4 => s_axi_CTRL_WDATA(7),
      O => int_auto_restart_i_1_n_1
    );
int_auto_restart_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => int_auto_restart_i_1_n_1,
      Q => int_auto_restart,
      R => \^ap_rst_n_inv\
    );
int_gie_i_1: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFEF0020"
    )
        port map (
      I0 => s_axi_CTRL_WDATA(0),
      I1 => \waddr_reg_n_1_[3]\,
      I2 => \waddr_reg_n_1_[2]\,
      I3 => \int_ier[1]_i_2_n_1\,
      I4 => int_gie_reg_n_1,
      O => int_gie_i_1_n_1
    );
int_gie_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => int_gie_i_1_n_1,
      Q => int_gie_reg_n_1,
      R => \^ap_rst_n_inv\
    );
\int_ier[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFEF0020"
    )
        port map (
      I0 => s_axi_CTRL_WDATA(0),
      I1 => \waddr_reg_n_1_[2]\,
      I2 => \waddr_reg_n_1_[3]\,
      I3 => \int_ier[1]_i_2_n_1\,
      I4 => \int_ier_reg_n_1_[0]\,
      O => \int_ier[0]_i_1_n_1\
    );
\int_ier[1]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFEF0020"
    )
        port map (
      I0 => s_axi_CTRL_WDATA(1),
      I1 => \waddr_reg_n_1_[2]\,
      I2 => \waddr_reg_n_1_[3]\,
      I3 => \int_ier[1]_i_2_n_1\,
      I4 => p_0_in,
      O => \int_ier[1]_i_1_n_1\
    );
\int_ier[1]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"FB"
    )
        port map (
      I0 => int_ap_start_i_3_n_1,
      I1 => s_axi_CTRL_WSTRB(0),
      I2 => \waddr_reg_n_1_[4]\,
      O => \int_ier[1]_i_2_n_1\
    );
\int_ier_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \int_ier[0]_i_1_n_1\,
      Q => \int_ier_reg_n_1_[0]\,
      R => \^ap_rst_n_inv\
    );
\int_ier_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \int_ier[1]_i_1_n_1\,
      Q => p_0_in,
      R => \^ap_rst_n_inv\
    );
\int_isr[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"F777F888"
    )
        port map (
      I0 => s_axi_CTRL_WDATA(0),
      I1 => int_isr6_out,
      I2 => \^ap_done\,
      I3 => \int_ier_reg_n_1_[0]\,
      I4 => \int_isr_reg_n_1_[0]\,
      O => \int_isr[0]_i_1_n_1\
    );
\int_isr[0]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00000800"
    )
        port map (
      I0 => \waddr_reg_n_1_[3]\,
      I1 => \waddr_reg_n_1_[2]\,
      I2 => int_ap_start_i_3_n_1,
      I3 => s_axi_CTRL_WSTRB(0),
      I4 => \waddr_reg_n_1_[4]\,
      O => int_isr6_out
    );
\int_isr[1]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"F777F888"
    )
        port map (
      I0 => s_axi_CTRL_WDATA(1),
      I1 => int_isr6_out,
      I2 => \^ap_done\,
      I3 => p_0_in,
      I4 => p_1_in,
      O => \int_isr[1]_i_1_n_1\
    );
\int_isr_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \int_isr[0]_i_1_n_1\,
      Q => \int_isr_reg_n_1_[0]\,
      R => \^ap_rst_n_inv\
    );
\int_isr_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \int_isr[1]_i_1_n_1\,
      Q => p_1_in,
      R => \^ap_rst_n_inv\
    );
\int_pixel_count[0]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_CTRL_WDATA(0),
      I1 => s_axi_CTRL_WSTRB(0),
      I2 => \^int_pixel_count_reg[31]_0\(0),
      O => \int_pixel_count[0]_i_1_n_1\
    );
\int_pixel_count[10]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_CTRL_WDATA(10),
      I1 => s_axi_CTRL_WSTRB(1),
      I2 => \^int_pixel_count_reg[31]_0\(10),
      O => \int_pixel_count[10]_i_1_n_1\
    );
\int_pixel_count[11]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_CTRL_WDATA(11),
      I1 => s_axi_CTRL_WSTRB(1),
      I2 => \^int_pixel_count_reg[31]_0\(11),
      O => \int_pixel_count[11]_i_1_n_1\
    );
\int_pixel_count[12]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_CTRL_WDATA(12),
      I1 => s_axi_CTRL_WSTRB(1),
      I2 => \^int_pixel_count_reg[31]_0\(12),
      O => \int_pixel_count[12]_i_1_n_1\
    );
\int_pixel_count[13]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_CTRL_WDATA(13),
      I1 => s_axi_CTRL_WSTRB(1),
      I2 => \^int_pixel_count_reg[31]_0\(13),
      O => \int_pixel_count[13]_i_1_n_1\
    );
\int_pixel_count[14]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_CTRL_WDATA(14),
      I1 => s_axi_CTRL_WSTRB(1),
      I2 => \^int_pixel_count_reg[31]_0\(14),
      O => \int_pixel_count[14]_i_1_n_1\
    );
\int_pixel_count[15]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_CTRL_WDATA(15),
      I1 => s_axi_CTRL_WSTRB(1),
      I2 => \^int_pixel_count_reg[31]_0\(15),
      O => \int_pixel_count[15]_i_1_n_1\
    );
\int_pixel_count[16]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_CTRL_WDATA(16),
      I1 => s_axi_CTRL_WSTRB(2),
      I2 => \^int_pixel_count_reg[31]_0\(16),
      O => \int_pixel_count[16]_i_1_n_1\
    );
\int_pixel_count[17]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_CTRL_WDATA(17),
      I1 => s_axi_CTRL_WSTRB(2),
      I2 => \^int_pixel_count_reg[31]_0\(17),
      O => \int_pixel_count[17]_i_1_n_1\
    );
\int_pixel_count[18]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_CTRL_WDATA(18),
      I1 => s_axi_CTRL_WSTRB(2),
      I2 => \^int_pixel_count_reg[31]_0\(18),
      O => \int_pixel_count[18]_i_1_n_1\
    );
\int_pixel_count[19]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_CTRL_WDATA(19),
      I1 => s_axi_CTRL_WSTRB(2),
      I2 => \^int_pixel_count_reg[31]_0\(19),
      O => \int_pixel_count[19]_i_1_n_1\
    );
\int_pixel_count[1]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_CTRL_WDATA(1),
      I1 => s_axi_CTRL_WSTRB(0),
      I2 => \^int_pixel_count_reg[31]_0\(1),
      O => \int_pixel_count[1]_i_1_n_1\
    );
\int_pixel_count[20]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_CTRL_WDATA(20),
      I1 => s_axi_CTRL_WSTRB(2),
      I2 => \^int_pixel_count_reg[31]_0\(20),
      O => \int_pixel_count[20]_i_1_n_1\
    );
\int_pixel_count[21]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_CTRL_WDATA(21),
      I1 => s_axi_CTRL_WSTRB(2),
      I2 => \^int_pixel_count_reg[31]_0\(21),
      O => \int_pixel_count[21]_i_1_n_1\
    );
\int_pixel_count[22]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_CTRL_WDATA(22),
      I1 => s_axi_CTRL_WSTRB(2),
      I2 => \^int_pixel_count_reg[31]_0\(22),
      O => \int_pixel_count[22]_i_1_n_1\
    );
\int_pixel_count[23]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_CTRL_WDATA(23),
      I1 => s_axi_CTRL_WSTRB(2),
      I2 => \^int_pixel_count_reg[31]_0\(23),
      O => \int_pixel_count[23]_i_1_n_1\
    );
\int_pixel_count[24]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_CTRL_WDATA(24),
      I1 => s_axi_CTRL_WSTRB(3),
      I2 => \^int_pixel_count_reg[31]_0\(24),
      O => \int_pixel_count[24]_i_1_n_1\
    );
\int_pixel_count[25]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_CTRL_WDATA(25),
      I1 => s_axi_CTRL_WSTRB(3),
      I2 => \^int_pixel_count_reg[31]_0\(25),
      O => \int_pixel_count[25]_i_1_n_1\
    );
\int_pixel_count[26]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_CTRL_WDATA(26),
      I1 => s_axi_CTRL_WSTRB(3),
      I2 => \^int_pixel_count_reg[31]_0\(26),
      O => \int_pixel_count[26]_i_1_n_1\
    );
\int_pixel_count[27]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_CTRL_WDATA(27),
      I1 => s_axi_CTRL_WSTRB(3),
      I2 => \^int_pixel_count_reg[31]_0\(27),
      O => \int_pixel_count[27]_i_1_n_1\
    );
\int_pixel_count[28]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_CTRL_WDATA(28),
      I1 => s_axi_CTRL_WSTRB(3),
      I2 => \^int_pixel_count_reg[31]_0\(28),
      O => \int_pixel_count[28]_i_1_n_1\
    );
\int_pixel_count[29]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_CTRL_WDATA(29),
      I1 => s_axi_CTRL_WSTRB(3),
      I2 => \^int_pixel_count_reg[31]_0\(29),
      O => \int_pixel_count[29]_i_1_n_1\
    );
\int_pixel_count[2]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_CTRL_WDATA(2),
      I1 => s_axi_CTRL_WSTRB(0),
      I2 => \^int_pixel_count_reg[31]_0\(2),
      O => \int_pixel_count[2]_i_1_n_1\
    );
\int_pixel_count[30]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_CTRL_WDATA(30),
      I1 => s_axi_CTRL_WSTRB(3),
      I2 => \^int_pixel_count_reg[31]_0\(30),
      O => \int_pixel_count[30]_i_1_n_1\
    );
\int_pixel_count[31]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"01"
    )
        port map (
      I0 => \waddr_reg_n_1_[2]\,
      I1 => \waddr_reg_n_1_[3]\,
      I2 => \int_pixel_count[31]_i_3_n_1\,
      O => \int_pixel_count[31]_i_1_n_1\
    );
\int_pixel_count[31]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_CTRL_WDATA(31),
      I1 => s_axi_CTRL_WSTRB(3),
      I2 => \^int_pixel_count_reg[31]_0\(31),
      O => \int_pixel_count[31]_i_2_n_1\
    );
\int_pixel_count[31]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFEFFFFFFFFFFF"
    )
        port map (
      I0 => \waddr_reg_n_1_[1]\,
      I1 => \waddr_reg_n_1_[0]\,
      I2 => \^fsm_onehot_wstate_reg[2]_0\,
      I3 => s_axi_CTRL_WVALID,
      I4 => \waddr_reg_n_1_[5]\,
      I5 => \waddr_reg_n_1_[4]\,
      O => \int_pixel_count[31]_i_3_n_1\
    );
\int_pixel_count[3]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_CTRL_WDATA(3),
      I1 => s_axi_CTRL_WSTRB(0),
      I2 => \^int_pixel_count_reg[31]_0\(3),
      O => \int_pixel_count[3]_i_1_n_1\
    );
\int_pixel_count[4]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_CTRL_WDATA(4),
      I1 => s_axi_CTRL_WSTRB(0),
      I2 => \^int_pixel_count_reg[31]_0\(4),
      O => \int_pixel_count[4]_i_1_n_1\
    );
\int_pixel_count[5]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_CTRL_WDATA(5),
      I1 => s_axi_CTRL_WSTRB(0),
      I2 => \^int_pixel_count_reg[31]_0\(5),
      O => \int_pixel_count[5]_i_1_n_1\
    );
\int_pixel_count[6]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_CTRL_WDATA(6),
      I1 => s_axi_CTRL_WSTRB(0),
      I2 => \^int_pixel_count_reg[31]_0\(6),
      O => \int_pixel_count[6]_i_1_n_1\
    );
\int_pixel_count[7]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_CTRL_WDATA(7),
      I1 => s_axi_CTRL_WSTRB(0),
      I2 => \^int_pixel_count_reg[31]_0\(7),
      O => \int_pixel_count[7]_i_1_n_1\
    );
\int_pixel_count[8]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_CTRL_WDATA(8),
      I1 => s_axi_CTRL_WSTRB(1),
      I2 => \^int_pixel_count_reg[31]_0\(8),
      O => \int_pixel_count[8]_i_1_n_1\
    );
\int_pixel_count[9]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_CTRL_WDATA(9),
      I1 => s_axi_CTRL_WSTRB(1),
      I2 => \^int_pixel_count_reg[31]_0\(9),
      O => \int_pixel_count[9]_i_1_n_1\
    );
\int_pixel_count_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_pixel_count[31]_i_1_n_1\,
      D => \int_pixel_count[0]_i_1_n_1\,
      Q => \^int_pixel_count_reg[31]_0\(0),
      R => \^ap_rst_n_inv\
    );
\int_pixel_count_reg[10]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_pixel_count[31]_i_1_n_1\,
      D => \int_pixel_count[10]_i_1_n_1\,
      Q => \^int_pixel_count_reg[31]_0\(10),
      R => \^ap_rst_n_inv\
    );
\int_pixel_count_reg[11]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_pixel_count[31]_i_1_n_1\,
      D => \int_pixel_count[11]_i_1_n_1\,
      Q => \^int_pixel_count_reg[31]_0\(11),
      R => \^ap_rst_n_inv\
    );
\int_pixel_count_reg[12]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_pixel_count[31]_i_1_n_1\,
      D => \int_pixel_count[12]_i_1_n_1\,
      Q => \^int_pixel_count_reg[31]_0\(12),
      R => \^ap_rst_n_inv\
    );
\int_pixel_count_reg[13]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_pixel_count[31]_i_1_n_1\,
      D => \int_pixel_count[13]_i_1_n_1\,
      Q => \^int_pixel_count_reg[31]_0\(13),
      R => \^ap_rst_n_inv\
    );
\int_pixel_count_reg[14]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_pixel_count[31]_i_1_n_1\,
      D => \int_pixel_count[14]_i_1_n_1\,
      Q => \^int_pixel_count_reg[31]_0\(14),
      R => \^ap_rst_n_inv\
    );
\int_pixel_count_reg[15]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_pixel_count[31]_i_1_n_1\,
      D => \int_pixel_count[15]_i_1_n_1\,
      Q => \^int_pixel_count_reg[31]_0\(15),
      R => \^ap_rst_n_inv\
    );
\int_pixel_count_reg[16]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_pixel_count[31]_i_1_n_1\,
      D => \int_pixel_count[16]_i_1_n_1\,
      Q => \^int_pixel_count_reg[31]_0\(16),
      R => \^ap_rst_n_inv\
    );
\int_pixel_count_reg[17]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_pixel_count[31]_i_1_n_1\,
      D => \int_pixel_count[17]_i_1_n_1\,
      Q => \^int_pixel_count_reg[31]_0\(17),
      R => \^ap_rst_n_inv\
    );
\int_pixel_count_reg[18]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_pixel_count[31]_i_1_n_1\,
      D => \int_pixel_count[18]_i_1_n_1\,
      Q => \^int_pixel_count_reg[31]_0\(18),
      R => \^ap_rst_n_inv\
    );
\int_pixel_count_reg[19]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_pixel_count[31]_i_1_n_1\,
      D => \int_pixel_count[19]_i_1_n_1\,
      Q => \^int_pixel_count_reg[31]_0\(19),
      R => \^ap_rst_n_inv\
    );
\int_pixel_count_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_pixel_count[31]_i_1_n_1\,
      D => \int_pixel_count[1]_i_1_n_1\,
      Q => \^int_pixel_count_reg[31]_0\(1),
      R => \^ap_rst_n_inv\
    );
\int_pixel_count_reg[20]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_pixel_count[31]_i_1_n_1\,
      D => \int_pixel_count[20]_i_1_n_1\,
      Q => \^int_pixel_count_reg[31]_0\(20),
      R => \^ap_rst_n_inv\
    );
\int_pixel_count_reg[21]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_pixel_count[31]_i_1_n_1\,
      D => \int_pixel_count[21]_i_1_n_1\,
      Q => \^int_pixel_count_reg[31]_0\(21),
      R => \^ap_rst_n_inv\
    );
\int_pixel_count_reg[22]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_pixel_count[31]_i_1_n_1\,
      D => \int_pixel_count[22]_i_1_n_1\,
      Q => \^int_pixel_count_reg[31]_0\(22),
      R => \^ap_rst_n_inv\
    );
\int_pixel_count_reg[23]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_pixel_count[31]_i_1_n_1\,
      D => \int_pixel_count[23]_i_1_n_1\,
      Q => \^int_pixel_count_reg[31]_0\(23),
      R => \^ap_rst_n_inv\
    );
\int_pixel_count_reg[24]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_pixel_count[31]_i_1_n_1\,
      D => \int_pixel_count[24]_i_1_n_1\,
      Q => \^int_pixel_count_reg[31]_0\(24),
      R => \^ap_rst_n_inv\
    );
\int_pixel_count_reg[25]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_pixel_count[31]_i_1_n_1\,
      D => \int_pixel_count[25]_i_1_n_1\,
      Q => \^int_pixel_count_reg[31]_0\(25),
      R => \^ap_rst_n_inv\
    );
\int_pixel_count_reg[26]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_pixel_count[31]_i_1_n_1\,
      D => \int_pixel_count[26]_i_1_n_1\,
      Q => \^int_pixel_count_reg[31]_0\(26),
      R => \^ap_rst_n_inv\
    );
\int_pixel_count_reg[27]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_pixel_count[31]_i_1_n_1\,
      D => \int_pixel_count[27]_i_1_n_1\,
      Q => \^int_pixel_count_reg[31]_0\(27),
      R => \^ap_rst_n_inv\
    );
\int_pixel_count_reg[28]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_pixel_count[31]_i_1_n_1\,
      D => \int_pixel_count[28]_i_1_n_1\,
      Q => \^int_pixel_count_reg[31]_0\(28),
      R => \^ap_rst_n_inv\
    );
\int_pixel_count_reg[29]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_pixel_count[31]_i_1_n_1\,
      D => \int_pixel_count[29]_i_1_n_1\,
      Q => \^int_pixel_count_reg[31]_0\(29),
      R => \^ap_rst_n_inv\
    );
\int_pixel_count_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_pixel_count[31]_i_1_n_1\,
      D => \int_pixel_count[2]_i_1_n_1\,
      Q => \^int_pixel_count_reg[31]_0\(2),
      R => \^ap_rst_n_inv\
    );
\int_pixel_count_reg[30]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_pixel_count[31]_i_1_n_1\,
      D => \int_pixel_count[30]_i_1_n_1\,
      Q => \^int_pixel_count_reg[31]_0\(30),
      R => \^ap_rst_n_inv\
    );
\int_pixel_count_reg[31]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_pixel_count[31]_i_1_n_1\,
      D => \int_pixel_count[31]_i_2_n_1\,
      Q => \^int_pixel_count_reg[31]_0\(31),
      R => \^ap_rst_n_inv\
    );
\int_pixel_count_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_pixel_count[31]_i_1_n_1\,
      D => \int_pixel_count[3]_i_1_n_1\,
      Q => \^int_pixel_count_reg[31]_0\(3),
      R => \^ap_rst_n_inv\
    );
\int_pixel_count_reg[4]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_pixel_count[31]_i_1_n_1\,
      D => \int_pixel_count[4]_i_1_n_1\,
      Q => \^int_pixel_count_reg[31]_0\(4),
      R => \^ap_rst_n_inv\
    );
\int_pixel_count_reg[5]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_pixel_count[31]_i_1_n_1\,
      D => \int_pixel_count[5]_i_1_n_1\,
      Q => \^int_pixel_count_reg[31]_0\(5),
      R => \^ap_rst_n_inv\
    );
\int_pixel_count_reg[6]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_pixel_count[31]_i_1_n_1\,
      D => \int_pixel_count[6]_i_1_n_1\,
      Q => \^int_pixel_count_reg[31]_0\(6),
      R => \^ap_rst_n_inv\
    );
\int_pixel_count_reg[7]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_pixel_count[31]_i_1_n_1\,
      D => \int_pixel_count[7]_i_1_n_1\,
      Q => \^int_pixel_count_reg[31]_0\(7),
      R => \^ap_rst_n_inv\
    );
\int_pixel_count_reg[8]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_pixel_count[31]_i_1_n_1\,
      D => \int_pixel_count[8]_i_1_n_1\,
      Q => \^int_pixel_count_reg[31]_0\(8),
      R => \^ap_rst_n_inv\
    );
\int_pixel_count_reg[9]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_pixel_count[31]_i_1_n_1\,
      D => \int_pixel_count[9]_i_1_n_1\,
      Q => \^int_pixel_count_reg[31]_0\(9),
      R => \^ap_rst_n_inv\
    );
\int_threshold_V[0]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_CTRL_WDATA(0),
      I1 => s_axi_CTRL_WSTRB(0),
      I2 => \^int_threshold_v_reg[7]_0\(0),
      O => \int_threshold_V[0]_i_1_n_1\
    );
\int_threshold_V[1]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_CTRL_WDATA(1),
      I1 => s_axi_CTRL_WSTRB(0),
      I2 => \^int_threshold_v_reg[7]_0\(1),
      O => \int_threshold_V[1]_i_1_n_1\
    );
\int_threshold_V[2]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_CTRL_WDATA(2),
      I1 => s_axi_CTRL_WSTRB(0),
      I2 => \^int_threshold_v_reg[7]_0\(2),
      O => \int_threshold_V[2]_i_1_n_1\
    );
\int_threshold_V[3]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_CTRL_WDATA(3),
      I1 => s_axi_CTRL_WSTRB(0),
      I2 => \^int_threshold_v_reg[7]_0\(3),
      O => \int_threshold_V[3]_i_1_n_1\
    );
\int_threshold_V[4]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_CTRL_WDATA(4),
      I1 => s_axi_CTRL_WSTRB(0),
      I2 => \^int_threshold_v_reg[7]_0\(4),
      O => \int_threshold_V[4]_i_1_n_1\
    );
\int_threshold_V[5]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_CTRL_WDATA(5),
      I1 => s_axi_CTRL_WSTRB(0),
      I2 => \^int_threshold_v_reg[7]_0\(5),
      O => \int_threshold_V[5]_i_1_n_1\
    );
\int_threshold_V[6]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_CTRL_WDATA(6),
      I1 => s_axi_CTRL_WSTRB(0),
      I2 => \^int_threshold_v_reg[7]_0\(6),
      O => \int_threshold_V[6]_i_1_n_1\
    );
\int_threshold_V[7]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"04"
    )
        port map (
      I0 => \waddr_reg_n_1_[2]\,
      I1 => \waddr_reg_n_1_[3]\,
      I2 => \int_pixel_count[31]_i_3_n_1\,
      O => \int_threshold_V[7]_i_1_n_1\
    );
\int_threshold_V[7]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_CTRL_WDATA(7),
      I1 => s_axi_CTRL_WSTRB(0),
      I2 => \^int_threshold_v_reg[7]_0\(7),
      O => \int_threshold_V[7]_i_2_n_1\
    );
\int_threshold_V_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_threshold_V[7]_i_1_n_1\,
      D => \int_threshold_V[0]_i_1_n_1\,
      Q => \^int_threshold_v_reg[7]_0\(0),
      R => \^ap_rst_n_inv\
    );
\int_threshold_V_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_threshold_V[7]_i_1_n_1\,
      D => \int_threshold_V[1]_i_1_n_1\,
      Q => \^int_threshold_v_reg[7]_0\(1),
      R => \^ap_rst_n_inv\
    );
\int_threshold_V_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_threshold_V[7]_i_1_n_1\,
      D => \int_threshold_V[2]_i_1_n_1\,
      Q => \^int_threshold_v_reg[7]_0\(2),
      R => \^ap_rst_n_inv\
    );
\int_threshold_V_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_threshold_V[7]_i_1_n_1\,
      D => \int_threshold_V[3]_i_1_n_1\,
      Q => \^int_threshold_v_reg[7]_0\(3),
      R => \^ap_rst_n_inv\
    );
\int_threshold_V_reg[4]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_threshold_V[7]_i_1_n_1\,
      D => \int_threshold_V[4]_i_1_n_1\,
      Q => \^int_threshold_v_reg[7]_0\(4),
      R => \^ap_rst_n_inv\
    );
\int_threshold_V_reg[5]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_threshold_V[7]_i_1_n_1\,
      D => \int_threshold_V[5]_i_1_n_1\,
      Q => \^int_threshold_v_reg[7]_0\(5),
      R => \^ap_rst_n_inv\
    );
\int_threshold_V_reg[6]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_threshold_V[7]_i_1_n_1\,
      D => \int_threshold_V[6]_i_1_n_1\,
      Q => \^int_threshold_v_reg[7]_0\(6),
      R => \^ap_rst_n_inv\
    );
\int_threshold_V_reg[7]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_threshold_V[7]_i_1_n_1\,
      D => \int_threshold_V[7]_i_2_n_1\,
      Q => \^int_threshold_v_reg[7]_0\(7),
      R => \^ap_rst_n_inv\
    );
\int_threshold_enable[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFB0008"
    )
        port map (
      I0 => s_axi_CTRL_WDATA(0),
      I1 => s_axi_CTRL_WSTRB(0),
      I2 => \int_threshold_enable[0]_i_2_n_1\,
      I3 => \int_threshold_enable[0]_i_3_n_1\,
      I4 => \^threshold_enable\,
      O => \int_threshold_enable[0]_i_1_n_1\
    );
\int_threshold_enable[0]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"EFFF"
    )
        port map (
      I0 => \waddr_reg_n_1_[1]\,
      I1 => \waddr_reg_n_1_[0]\,
      I2 => \^fsm_onehot_wstate_reg[2]_0\,
      I3 => s_axi_CTRL_WVALID,
      O => \int_threshold_enable[0]_i_2_n_1\
    );
\int_threshold_enable[0]_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFEF"
    )
        port map (
      I0 => \waddr_reg_n_1_[2]\,
      I1 => \waddr_reg_n_1_[3]\,
      I2 => \waddr_reg_n_1_[5]\,
      I3 => \waddr_reg_n_1_[4]\,
      O => \int_threshold_enable[0]_i_3_n_1\
    );
\int_threshold_enable_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \int_threshold_enable[0]_i_1_n_1\,
      Q => \^threshold_enable\,
      R => \^ap_rst_n_inv\
    );
interrupt_INST_0: unisim.vcomponents.LUT3
    generic map(
      INIT => X"A8"
    )
        port map (
      I0 => int_gie_reg_n_1,
      I1 => p_1_in,
      I2 => \int_isr_reg_n_1_[0]\,
      O => interrupt
    );
\pixel_count_read_reg_227[31]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => Q(0),
      I1 => ap_start,
      O => \^e\(0)
    );
\rdata[0]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0F00ACAC"
    )
        port map (
      I0 => \^threshold_enable\,
      I1 => \^int_pixel_count_reg[31]_0\(0),
      I2 => \rdata[7]_i_4_n_1\,
      I3 => \^int_threshold_v_reg[7]_0\(0),
      I4 => \rdata[7]_i_3_n_1\,
      O => \rdata[0]_i_2_n_1\
    );
\rdata[0]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"CCFFF0AACC00F0AA"
    )
        port map (
      I0 => ap_start,
      I1 => \int_isr_reg_n_1_[0]\,
      I2 => int_gie_reg_n_1,
      I3 => \rdata[7]_i_3_n_1\,
      I4 => \rdata[7]_i_4_n_1\,
      I5 => \int_ier_reg_n_1_[0]\,
      O => \rdata[0]_i_3_n_1\
    );
\rdata[1]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"505F505C5050505C"
    )
        port map (
      I0 => \rdata[1]_i_2_n_1\,
      I1 => \^int_pixel_count_reg[31]_0\(1),
      I2 => \rdata[7]_i_2_n_1\,
      I3 => \rdata[7]_i_4_n_1\,
      I4 => \rdata[7]_i_3_n_1\,
      I5 => \^int_threshold_v_reg[7]_0\(1),
      O => rdata(1)
    );
\rdata[1]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"3F113FDD"
    )
        port map (
      I0 => int_ap_done,
      I1 => \rdata[7]_i_4_n_1\,
      I2 => p_1_in,
      I3 => \rdata[7]_i_3_n_1\,
      I4 => p_0_in,
      O => \rdata[1]_i_2_n_1\
    );
\rdata[2]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000000000A0ACFC0"
    )
        port map (
      I0 => \^int_threshold_v_reg[7]_0\(2),
      I1 => int_ap_idle,
      I2 => \rdata[7]_i_2_n_1\,
      I3 => \^int_pixel_count_reg[31]_0\(2),
      I4 => \rdata[7]_i_3_n_1\,
      I5 => \rdata[7]_i_4_n_1\,
      O => rdata(2)
    );
\rdata[31]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"80"
    )
        port map (
      I0 => \rdata[31]_i_3_n_1\,
      I1 => \^fsm_onehot_rstate_reg[1]_0\,
      I2 => s_axi_CTRL_ARVALID,
      O => \rdata[31]_i_1_n_1\
    );
\rdata[31]_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => s_axi_CTRL_ARVALID,
      I1 => \^fsm_onehot_rstate_reg[1]_0\,
      O => ar_hs
    );
\rdata[31]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFFEFFFF"
    )
        port map (
      I0 => s_axi_CTRL_ARADDR(0),
      I1 => s_axi_CTRL_ARADDR(1),
      I2 => s_axi_CTRL_ARADDR(5),
      I3 => s_axi_CTRL_ARADDR(2),
      I4 => s_axi_CTRL_ARADDR(4),
      I5 => s_axi_CTRL_ARADDR(3),
      O => \rdata[31]_i_3_n_1\
    );
\rdata[3]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000000000A0ACFC0"
    )
        port map (
      I0 => \^int_threshold_v_reg[7]_0\(3),
      I1 => int_ap_ready,
      I2 => \rdata[7]_i_2_n_1\,
      I3 => \^int_pixel_count_reg[31]_0\(3),
      I4 => \rdata[7]_i_3_n_1\,
      I5 => \rdata[7]_i_4_n_1\,
      O => rdata(3)
    );
\rdata[4]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"4F44"
    )
        port map (
      I0 => \rdata[31]_i_3_n_1\,
      I1 => \^int_pixel_count_reg[31]_0\(4),
      I2 => \rdata[6]_i_2_n_1\,
      I3 => \^int_threshold_v_reg[7]_0\(4),
      O => rdata(4)
    );
\rdata[5]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"4F44"
    )
        port map (
      I0 => \rdata[31]_i_3_n_1\,
      I1 => \^int_pixel_count_reg[31]_0\(5),
      I2 => \rdata[6]_i_2_n_1\,
      I3 => \^int_threshold_v_reg[7]_0\(5),
      O => rdata(5)
    );
\rdata[6]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"4F44"
    )
        port map (
      I0 => \rdata[31]_i_3_n_1\,
      I1 => \^int_pixel_count_reg[31]_0\(6),
      I2 => \rdata[6]_i_2_n_1\,
      I3 => \^int_threshold_v_reg[7]_0\(6),
      O => rdata(6)
    );
\rdata[6]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFEFFFFFFFFFFFF"
    )
        port map (
      I0 => s_axi_CTRL_ARADDR(1),
      I1 => s_axi_CTRL_ARADDR(0),
      I2 => s_axi_CTRL_ARADDR(2),
      I3 => s_axi_CTRL_ARADDR(5),
      I4 => s_axi_CTRL_ARADDR(3),
      I5 => s_axi_CTRL_ARADDR(4),
      O => \rdata[6]_i_2_n_1\
    );
\rdata[7]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000000000A0ACFC0"
    )
        port map (
      I0 => \^int_threshold_v_reg[7]_0\(7),
      I1 => int_auto_restart,
      I2 => \rdata[7]_i_2_n_1\,
      I3 => \^int_pixel_count_reg[31]_0\(7),
      I4 => \rdata[7]_i_3_n_1\,
      I5 => \rdata[7]_i_4_n_1\,
      O => rdata(7)
    );
\rdata[7]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0001"
    )
        port map (
      I0 => s_axi_CTRL_ARADDR(1),
      I1 => s_axi_CTRL_ARADDR(0),
      I2 => s_axi_CTRL_ARADDR(4),
      I3 => s_axi_CTRL_ARADDR(5),
      O => \rdata[7]_i_2_n_1\
    );
\rdata[7]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFFFFFE8"
    )
        port map (
      I0 => s_axi_CTRL_ARADDR(4),
      I1 => s_axi_CTRL_ARADDR(3),
      I2 => s_axi_CTRL_ARADDR(5),
      I3 => s_axi_CTRL_ARADDR(2),
      I4 => s_axi_CTRL_ARADDR(0),
      I5 => s_axi_CTRL_ARADDR(1),
      O => \rdata[7]_i_3_n_1\
    );
\rdata[7]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFEFFFFFFFEFEFE"
    )
        port map (
      I0 => s_axi_CTRL_ARADDR(0),
      I1 => s_axi_CTRL_ARADDR(1),
      I2 => s_axi_CTRL_ARADDR(5),
      I3 => s_axi_CTRL_ARADDR(2),
      I4 => s_axi_CTRL_ARADDR(4),
      I5 => s_axi_CTRL_ARADDR(3),
      O => \rdata[7]_i_4_n_1\
    );
\rdata_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ar_hs,
      D => rdata(0),
      Q => s_axi_CTRL_RDATA(0),
      R => '0'
    );
\rdata_reg[0]_i_1\: unisim.vcomponents.MUXF7
     port map (
      I0 => \rdata[0]_i_2_n_1\,
      I1 => \rdata[0]_i_3_n_1\,
      O => rdata(0),
      S => \rdata[7]_i_2_n_1\
    );
\rdata_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ar_hs,
      D => \^int_pixel_count_reg[31]_0\(10),
      Q => s_axi_CTRL_RDATA(10),
      R => \rdata[31]_i_1_n_1\
    );
\rdata_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ar_hs,
      D => \^int_pixel_count_reg[31]_0\(11),
      Q => s_axi_CTRL_RDATA(11),
      R => \rdata[31]_i_1_n_1\
    );
\rdata_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ar_hs,
      D => \^int_pixel_count_reg[31]_0\(12),
      Q => s_axi_CTRL_RDATA(12),
      R => \rdata[31]_i_1_n_1\
    );
\rdata_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ar_hs,
      D => \^int_pixel_count_reg[31]_0\(13),
      Q => s_axi_CTRL_RDATA(13),
      R => \rdata[31]_i_1_n_1\
    );
\rdata_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ar_hs,
      D => \^int_pixel_count_reg[31]_0\(14),
      Q => s_axi_CTRL_RDATA(14),
      R => \rdata[31]_i_1_n_1\
    );
\rdata_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ar_hs,
      D => \^int_pixel_count_reg[31]_0\(15),
      Q => s_axi_CTRL_RDATA(15),
      R => \rdata[31]_i_1_n_1\
    );
\rdata_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ar_hs,
      D => \^int_pixel_count_reg[31]_0\(16),
      Q => s_axi_CTRL_RDATA(16),
      R => \rdata[31]_i_1_n_1\
    );
\rdata_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ar_hs,
      D => \^int_pixel_count_reg[31]_0\(17),
      Q => s_axi_CTRL_RDATA(17),
      R => \rdata[31]_i_1_n_1\
    );
\rdata_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ar_hs,
      D => \^int_pixel_count_reg[31]_0\(18),
      Q => s_axi_CTRL_RDATA(18),
      R => \rdata[31]_i_1_n_1\
    );
\rdata_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ar_hs,
      D => \^int_pixel_count_reg[31]_0\(19),
      Q => s_axi_CTRL_RDATA(19),
      R => \rdata[31]_i_1_n_1\
    );
\rdata_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ar_hs,
      D => rdata(1),
      Q => s_axi_CTRL_RDATA(1),
      R => '0'
    );
\rdata_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ar_hs,
      D => \^int_pixel_count_reg[31]_0\(20),
      Q => s_axi_CTRL_RDATA(20),
      R => \rdata[31]_i_1_n_1\
    );
\rdata_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ar_hs,
      D => \^int_pixel_count_reg[31]_0\(21),
      Q => s_axi_CTRL_RDATA(21),
      R => \rdata[31]_i_1_n_1\
    );
\rdata_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ar_hs,
      D => \^int_pixel_count_reg[31]_0\(22),
      Q => s_axi_CTRL_RDATA(22),
      R => \rdata[31]_i_1_n_1\
    );
\rdata_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ar_hs,
      D => \^int_pixel_count_reg[31]_0\(23),
      Q => s_axi_CTRL_RDATA(23),
      R => \rdata[31]_i_1_n_1\
    );
\rdata_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ar_hs,
      D => \^int_pixel_count_reg[31]_0\(24),
      Q => s_axi_CTRL_RDATA(24),
      R => \rdata[31]_i_1_n_1\
    );
\rdata_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ar_hs,
      D => \^int_pixel_count_reg[31]_0\(25),
      Q => s_axi_CTRL_RDATA(25),
      R => \rdata[31]_i_1_n_1\
    );
\rdata_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ar_hs,
      D => \^int_pixel_count_reg[31]_0\(26),
      Q => s_axi_CTRL_RDATA(26),
      R => \rdata[31]_i_1_n_1\
    );
\rdata_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ar_hs,
      D => \^int_pixel_count_reg[31]_0\(27),
      Q => s_axi_CTRL_RDATA(27),
      R => \rdata[31]_i_1_n_1\
    );
\rdata_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ar_hs,
      D => \^int_pixel_count_reg[31]_0\(28),
      Q => s_axi_CTRL_RDATA(28),
      R => \rdata[31]_i_1_n_1\
    );
\rdata_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ar_hs,
      D => \^int_pixel_count_reg[31]_0\(29),
      Q => s_axi_CTRL_RDATA(29),
      R => \rdata[31]_i_1_n_1\
    );
\rdata_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ar_hs,
      D => rdata(2),
      Q => s_axi_CTRL_RDATA(2),
      R => '0'
    );
\rdata_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ar_hs,
      D => \^int_pixel_count_reg[31]_0\(30),
      Q => s_axi_CTRL_RDATA(30),
      R => \rdata[31]_i_1_n_1\
    );
\rdata_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ar_hs,
      D => \^int_pixel_count_reg[31]_0\(31),
      Q => s_axi_CTRL_RDATA(31),
      R => \rdata[31]_i_1_n_1\
    );
\rdata_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ar_hs,
      D => rdata(3),
      Q => s_axi_CTRL_RDATA(3),
      R => '0'
    );
\rdata_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ar_hs,
      D => rdata(4),
      Q => s_axi_CTRL_RDATA(4),
      R => '0'
    );
\rdata_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ar_hs,
      D => rdata(5),
      Q => s_axi_CTRL_RDATA(5),
      R => '0'
    );
\rdata_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ar_hs,
      D => rdata(6),
      Q => s_axi_CTRL_RDATA(6),
      R => '0'
    );
\rdata_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ar_hs,
      D => rdata(7),
      Q => s_axi_CTRL_RDATA(7),
      R => '0'
    );
\rdata_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ar_hs,
      D => \^int_pixel_count_reg[31]_0\(8),
      Q => s_axi_CTRL_RDATA(8),
      R => \rdata[31]_i_1_n_1\
    );
\rdata_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ar_hs,
      D => \^int_pixel_count_reg[31]_0\(9),
      Q => s_axi_CTRL_RDATA(9),
      R => \rdata[31]_i_1_n_1\
    );
\s_axis_V_dest_V_0_state[1]_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => ap_rst_n,
      O => \^ap_rst_n_inv\
    );
\waddr[5]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => s_axi_CTRL_AWVALID,
      I1 => \^fsm_onehot_wstate_reg[1]_0\,
      O => waddr
    );
\waddr_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => waddr,
      D => s_axi_CTRL_AWADDR(0),
      Q => \waddr_reg_n_1_[0]\,
      R => '0'
    );
\waddr_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => waddr,
      D => s_axi_CTRL_AWADDR(1),
      Q => \waddr_reg_n_1_[1]\,
      R => '0'
    );
\waddr_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => waddr,
      D => s_axi_CTRL_AWADDR(2),
      Q => \waddr_reg_n_1_[2]\,
      R => '0'
    );
\waddr_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => waddr,
      D => s_axi_CTRL_AWADDR(3),
      Q => \waddr_reg_n_1_[3]\,
      R => '0'
    );
\waddr_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => waddr,
      D => s_axi_CTRL_AWADDR(4),
      Q => \waddr_reg_n_1_[4]\,
      R => '0'
    );
\waddr_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => waddr,
      D => s_axi_CTRL_AWADDR(5),
      Q => \waddr_reg_n_1_[5]\,
      R => '0'
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_cubeocc_hls is
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
    m_axis_TDEST : out STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_CTRL_AWVALID : in STD_LOGIC;
    s_axi_CTRL_AWREADY : out STD_LOGIC;
    s_axi_CTRL_AWADDR : in STD_LOGIC_VECTOR ( 5 downto 0 );
    s_axi_CTRL_WVALID : in STD_LOGIC;
    s_axi_CTRL_WREADY : out STD_LOGIC;
    s_axi_CTRL_WDATA : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_CTRL_WSTRB : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_CTRL_ARVALID : in STD_LOGIC;
    s_axi_CTRL_ARREADY : out STD_LOGIC;
    s_axi_CTRL_ARADDR : in STD_LOGIC_VECTOR ( 5 downto 0 );
    s_axi_CTRL_RVALID : out STD_LOGIC;
    s_axi_CTRL_RREADY : in STD_LOGIC;
    s_axi_CTRL_RDATA : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_CTRL_RRESP : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_CTRL_BVALID : out STD_LOGIC;
    s_axi_CTRL_BREADY : in STD_LOGIC;
    s_axi_CTRL_BRESP : out STD_LOGIC_VECTOR ( 1 downto 0 );
    interrupt : out STD_LOGIC
  );
  attribute C_S_AXI_CTRL_ADDR_WIDTH : integer;
  attribute C_S_AXI_CTRL_ADDR_WIDTH of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_cubeocc_hls : entity is 6;
  attribute C_S_AXI_CTRL_DATA_WIDTH : integer;
  attribute C_S_AXI_CTRL_DATA_WIDTH of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_cubeocc_hls : entity is 32;
  attribute C_S_AXI_CTRL_WSTRB_WIDTH : integer;
  attribute C_S_AXI_CTRL_WSTRB_WIDTH of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_cubeocc_hls : entity is 4;
  attribute C_S_AXI_DATA_WIDTH : integer;
  attribute C_S_AXI_DATA_WIDTH of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_cubeocc_hls : entity is 32;
  attribute C_S_AXI_WSTRB_WIDTH : integer;
  attribute C_S_AXI_WSTRB_WIDTH of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_cubeocc_hls : entity is 4;
  attribute ap_ST_fsm_pp0_stage0 : string;
  attribute ap_ST_fsm_pp0_stage0 of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_cubeocc_hls : entity is "3'b010";
  attribute ap_ST_fsm_state1 : string;
  attribute ap_ST_fsm_state1 of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_cubeocc_hls : entity is "3'b001";
  attribute ap_ST_fsm_state5 : string;
  attribute ap_ST_fsm_state5 of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_cubeocc_hls : entity is "3'b100";
  attribute hls_module : string;
  attribute hls_module of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_cubeocc_hls : entity is "yes";
end decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_cubeocc_hls;

architecture STRUCTURE of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_cubeocc_hls is
  signal \<const0>\ : STD_LOGIC;
  signal \ap_CS_fsm[2]_i_1_n_1\ : STD_LOGIC;
  signal \ap_CS_fsm[2]_i_2_n_1\ : STD_LOGIC;
  signal ap_CS_fsm_pp0_stage0 : STD_LOGIC;
  signal \ap_CS_fsm_reg_n_1_[0]\ : STD_LOGIC;
  signal ap_CS_fsm_state5 : STD_LOGIC;
  signal ap_NS_fsm1 : STD_LOGIC;
  signal ap_block_pp0_stage0_subdone3_in : STD_LOGIC;
  signal ap_done : STD_LOGIC;
  signal ap_enable_reg_pp0_iter0 : STD_LOGIC;
  signal ap_enable_reg_pp0_iter1_i_1_n_1 : STD_LOGIC;
  signal ap_enable_reg_pp0_iter1_reg_n_1 : STD_LOGIC;
  signal ap_enable_reg_pp0_iter2_reg_n_1 : STD_LOGIC;
  signal ap_rst_n_inv : STD_LOGIC;
  signal cubeocc_hls_CTRL_s_axi_U_n_4 : STD_LOGIC;
  signal cubeocc_hls_CTRL_s_axi_U_n_49 : STD_LOGIC;
  signal cubeocc_hls_CTRL_s_axi_U_n_50 : STD_LOGIC;
  signal cubeocc_hls_CTRL_s_axi_U_n_53 : STD_LOGIC;
  signal i_0_reg_143 : STD_LOGIC;
  signal \i_0_reg_143[0]_i_2_n_1\ : STD_LOGIC;
  signal \i_0_reg_143[0]_i_4_n_1\ : STD_LOGIC;
  signal i_0_reg_143_reg : STD_LOGIC_VECTOR ( 30 downto 0 );
  signal \i_0_reg_143_reg[0]_i_3_n_1\ : STD_LOGIC;
  signal \i_0_reg_143_reg[0]_i_3_n_2\ : STD_LOGIC;
  signal \i_0_reg_143_reg[0]_i_3_n_3\ : STD_LOGIC;
  signal \i_0_reg_143_reg[0]_i_3_n_4\ : STD_LOGIC;
  signal \i_0_reg_143_reg[0]_i_3_n_5\ : STD_LOGIC;
  signal \i_0_reg_143_reg[0]_i_3_n_6\ : STD_LOGIC;
  signal \i_0_reg_143_reg[0]_i_3_n_7\ : STD_LOGIC;
  signal \i_0_reg_143_reg[0]_i_3_n_8\ : STD_LOGIC;
  signal \i_0_reg_143_reg[12]_i_1_n_1\ : STD_LOGIC;
  signal \i_0_reg_143_reg[12]_i_1_n_2\ : STD_LOGIC;
  signal \i_0_reg_143_reg[12]_i_1_n_3\ : STD_LOGIC;
  signal \i_0_reg_143_reg[12]_i_1_n_4\ : STD_LOGIC;
  signal \i_0_reg_143_reg[12]_i_1_n_5\ : STD_LOGIC;
  signal \i_0_reg_143_reg[12]_i_1_n_6\ : STD_LOGIC;
  signal \i_0_reg_143_reg[12]_i_1_n_7\ : STD_LOGIC;
  signal \i_0_reg_143_reg[12]_i_1_n_8\ : STD_LOGIC;
  signal \i_0_reg_143_reg[16]_i_1_n_1\ : STD_LOGIC;
  signal \i_0_reg_143_reg[16]_i_1_n_2\ : STD_LOGIC;
  signal \i_0_reg_143_reg[16]_i_1_n_3\ : STD_LOGIC;
  signal \i_0_reg_143_reg[16]_i_1_n_4\ : STD_LOGIC;
  signal \i_0_reg_143_reg[16]_i_1_n_5\ : STD_LOGIC;
  signal \i_0_reg_143_reg[16]_i_1_n_6\ : STD_LOGIC;
  signal \i_0_reg_143_reg[16]_i_1_n_7\ : STD_LOGIC;
  signal \i_0_reg_143_reg[16]_i_1_n_8\ : STD_LOGIC;
  signal \i_0_reg_143_reg[20]_i_1_n_1\ : STD_LOGIC;
  signal \i_0_reg_143_reg[20]_i_1_n_2\ : STD_LOGIC;
  signal \i_0_reg_143_reg[20]_i_1_n_3\ : STD_LOGIC;
  signal \i_0_reg_143_reg[20]_i_1_n_4\ : STD_LOGIC;
  signal \i_0_reg_143_reg[20]_i_1_n_5\ : STD_LOGIC;
  signal \i_0_reg_143_reg[20]_i_1_n_6\ : STD_LOGIC;
  signal \i_0_reg_143_reg[20]_i_1_n_7\ : STD_LOGIC;
  signal \i_0_reg_143_reg[20]_i_1_n_8\ : STD_LOGIC;
  signal \i_0_reg_143_reg[24]_i_1_n_1\ : STD_LOGIC;
  signal \i_0_reg_143_reg[24]_i_1_n_2\ : STD_LOGIC;
  signal \i_0_reg_143_reg[24]_i_1_n_3\ : STD_LOGIC;
  signal \i_0_reg_143_reg[24]_i_1_n_4\ : STD_LOGIC;
  signal \i_0_reg_143_reg[24]_i_1_n_5\ : STD_LOGIC;
  signal \i_0_reg_143_reg[24]_i_1_n_6\ : STD_LOGIC;
  signal \i_0_reg_143_reg[24]_i_1_n_7\ : STD_LOGIC;
  signal \i_0_reg_143_reg[24]_i_1_n_8\ : STD_LOGIC;
  signal \i_0_reg_143_reg[28]_i_1_n_3\ : STD_LOGIC;
  signal \i_0_reg_143_reg[28]_i_1_n_4\ : STD_LOGIC;
  signal \i_0_reg_143_reg[28]_i_1_n_6\ : STD_LOGIC;
  signal \i_0_reg_143_reg[28]_i_1_n_7\ : STD_LOGIC;
  signal \i_0_reg_143_reg[28]_i_1_n_8\ : STD_LOGIC;
  signal \i_0_reg_143_reg[4]_i_1_n_1\ : STD_LOGIC;
  signal \i_0_reg_143_reg[4]_i_1_n_2\ : STD_LOGIC;
  signal \i_0_reg_143_reg[4]_i_1_n_3\ : STD_LOGIC;
  signal \i_0_reg_143_reg[4]_i_1_n_4\ : STD_LOGIC;
  signal \i_0_reg_143_reg[4]_i_1_n_5\ : STD_LOGIC;
  signal \i_0_reg_143_reg[4]_i_1_n_6\ : STD_LOGIC;
  signal \i_0_reg_143_reg[4]_i_1_n_7\ : STD_LOGIC;
  signal \i_0_reg_143_reg[4]_i_1_n_8\ : STD_LOGIC;
  signal \i_0_reg_143_reg[8]_i_1_n_1\ : STD_LOGIC;
  signal \i_0_reg_143_reg[8]_i_1_n_2\ : STD_LOGIC;
  signal \i_0_reg_143_reg[8]_i_1_n_3\ : STD_LOGIC;
  signal \i_0_reg_143_reg[8]_i_1_n_4\ : STD_LOGIC;
  signal \i_0_reg_143_reg[8]_i_1_n_5\ : STD_LOGIC;
  signal \i_0_reg_143_reg[8]_i_1_n_6\ : STD_LOGIC;
  signal \i_0_reg_143_reg[8]_i_1_n_7\ : STD_LOGIC;
  signal \i_0_reg_143_reg[8]_i_1_n_8\ : STD_LOGIC;
  signal icmp_ln17_fu_158_p2 : STD_LOGIC;
  signal icmp_ln17_reg_232 : STD_LOGIC;
  signal \icmp_ln17_reg_232[0]_i_1_n_1\ : STD_LOGIC;
  signal icmp_ln17_reg_232_pp0_iter1_reg : STD_LOGIC;
  signal \icmp_ln17_reg_232_pp0_iter1_reg[0]_i_1_n_1\ : STD_LOGIC;
  signal \^m_axis_tvalid\ : STD_LOGIC;
  signal m_axis_V_data_V_1_ack_in : STD_LOGIC;
  signal m_axis_V_data_V_1_load_A : STD_LOGIC;
  signal m_axis_V_data_V_1_load_B : STD_LOGIC;
  signal m_axis_V_data_V_1_payload_A : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal m_axis_V_data_V_1_payload_B : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal m_axis_V_data_V_1_sel : STD_LOGIC;
  signal m_axis_V_data_V_1_sel_rd_i_1_n_1 : STD_LOGIC;
  signal m_axis_V_data_V_1_sel_wr : STD_LOGIC;
  signal m_axis_V_data_V_1_sel_wr_i_1_n_1 : STD_LOGIC;
  signal m_axis_V_data_V_1_state : STD_LOGIC_VECTOR ( 1 to 1 );
  signal \m_axis_V_data_V_1_state[0]_i_1_n_1\ : STD_LOGIC;
  signal \m_axis_V_data_V_1_state_reg_n_1_[0]\ : STD_LOGIC;
  signal m_axis_V_dest_V_1_ack_in : STD_LOGIC;
  signal m_axis_V_dest_V_1_payload_A : STD_LOGIC;
  signal \m_axis_V_dest_V_1_payload_A[0]_i_1_n_1\ : STD_LOGIC;
  signal m_axis_V_dest_V_1_payload_B : STD_LOGIC;
  signal \m_axis_V_dest_V_1_payload_B[0]_i_1_n_1\ : STD_LOGIC;
  signal m_axis_V_dest_V_1_sel : STD_LOGIC;
  signal m_axis_V_dest_V_1_sel_rd_i_1_n_1 : STD_LOGIC;
  signal m_axis_V_dest_V_1_sel_wr : STD_LOGIC;
  signal m_axis_V_dest_V_1_sel_wr_i_1_n_1 : STD_LOGIC;
  signal \m_axis_V_dest_V_1_state[0]_i_1_n_1\ : STD_LOGIC;
  signal \m_axis_V_dest_V_1_state[0]_i_2_n_1\ : STD_LOGIC;
  signal \m_axis_V_dest_V_1_state[0]_i_3_n_1\ : STD_LOGIC;
  signal \m_axis_V_dest_V_1_state[1]_i_1_n_1\ : STD_LOGIC;
  signal m_axis_V_id_V_1_ack_in : STD_LOGIC;
  signal m_axis_V_id_V_1_payload_A : STD_LOGIC;
  signal \m_axis_V_id_V_1_payload_A[0]_i_1_n_1\ : STD_LOGIC;
  signal m_axis_V_id_V_1_payload_B : STD_LOGIC;
  signal \m_axis_V_id_V_1_payload_B[0]_i_1_n_1\ : STD_LOGIC;
  signal m_axis_V_id_V_1_sel : STD_LOGIC;
  signal m_axis_V_id_V_1_sel_rd_i_1_n_1 : STD_LOGIC;
  signal m_axis_V_id_V_1_sel_wr : STD_LOGIC;
  signal m_axis_V_id_V_1_sel_wr_i_1_n_1 : STD_LOGIC;
  signal \m_axis_V_id_V_1_state[0]_i_1_n_1\ : STD_LOGIC;
  signal \m_axis_V_id_V_1_state[1]_i_1_n_1\ : STD_LOGIC;
  signal \m_axis_V_id_V_1_state_reg_n_1_[0]\ : STD_LOGIC;
  signal m_axis_V_keep_V_1_ack_in : STD_LOGIC;
  signal m_axis_V_keep_V_1_payload_A : STD_LOGIC;
  signal \m_axis_V_keep_V_1_payload_A[0]_i_1_n_1\ : STD_LOGIC;
  signal m_axis_V_keep_V_1_payload_B : STD_LOGIC;
  signal \m_axis_V_keep_V_1_payload_B[0]_i_1_n_1\ : STD_LOGIC;
  signal m_axis_V_keep_V_1_sel : STD_LOGIC;
  signal m_axis_V_keep_V_1_sel_rd_i_1_n_1 : STD_LOGIC;
  signal m_axis_V_keep_V_1_sel_wr : STD_LOGIC;
  signal m_axis_V_keep_V_1_sel_wr_i_1_n_1 : STD_LOGIC;
  signal \m_axis_V_keep_V_1_state[0]_i_1_n_1\ : STD_LOGIC;
  signal \m_axis_V_keep_V_1_state[1]_i_1_n_1\ : STD_LOGIC;
  signal \m_axis_V_keep_V_1_state_reg_n_1_[0]\ : STD_LOGIC;
  signal m_axis_V_last_V_1_ack_in : STD_LOGIC;
  signal m_axis_V_last_V_1_payload_A : STD_LOGIC;
  signal \m_axis_V_last_V_1_payload_A[0]_i_1_n_1\ : STD_LOGIC;
  signal m_axis_V_last_V_1_payload_B : STD_LOGIC;
  signal \m_axis_V_last_V_1_payload_B[0]_i_1_n_1\ : STD_LOGIC;
  signal m_axis_V_last_V_1_sel : STD_LOGIC;
  signal m_axis_V_last_V_1_sel_rd_i_1_n_1 : STD_LOGIC;
  signal m_axis_V_last_V_1_sel_wr : STD_LOGIC;
  signal m_axis_V_last_V_1_sel_wr_i_1_n_1 : STD_LOGIC;
  signal \m_axis_V_last_V_1_state[0]_i_1_n_1\ : STD_LOGIC;
  signal \m_axis_V_last_V_1_state[1]_i_1_n_1\ : STD_LOGIC;
  signal \m_axis_V_last_V_1_state_reg_n_1_[0]\ : STD_LOGIC;
  signal m_axis_V_strb_V_1_ack_in : STD_LOGIC;
  signal m_axis_V_strb_V_1_payload_A : STD_LOGIC;
  signal \m_axis_V_strb_V_1_payload_A[0]_i_1_n_1\ : STD_LOGIC;
  signal m_axis_V_strb_V_1_payload_B : STD_LOGIC;
  signal \m_axis_V_strb_V_1_payload_B[0]_i_1_n_1\ : STD_LOGIC;
  signal m_axis_V_strb_V_1_sel : STD_LOGIC;
  signal m_axis_V_strb_V_1_sel_rd_i_1_n_1 : STD_LOGIC;
  signal m_axis_V_strb_V_1_sel_wr : STD_LOGIC;
  signal m_axis_V_strb_V_1_sel_wr_i_1_n_1 : STD_LOGIC;
  signal \m_axis_V_strb_V_1_state[0]_i_1_n_1\ : STD_LOGIC;
  signal \m_axis_V_strb_V_1_state[1]_i_1_n_1\ : STD_LOGIC;
  signal \m_axis_V_strb_V_1_state_reg_n_1_[0]\ : STD_LOGIC;
  signal m_axis_V_user_V_1_ack_in : STD_LOGIC;
  signal m_axis_V_user_V_1_payload_A : STD_LOGIC;
  signal \m_axis_V_user_V_1_payload_A[0]_i_1_n_1\ : STD_LOGIC;
  signal m_axis_V_user_V_1_payload_B : STD_LOGIC;
  signal \m_axis_V_user_V_1_payload_B[0]_i_1_n_1\ : STD_LOGIC;
  signal m_axis_V_user_V_1_sel : STD_LOGIC;
  signal m_axis_V_user_V_1_sel_rd_i_1_n_1 : STD_LOGIC;
  signal m_axis_V_user_V_1_sel_wr : STD_LOGIC;
  signal m_axis_V_user_V_1_sel_wr_i_1_n_1 : STD_LOGIC;
  signal \m_axis_V_user_V_1_state[0]_i_1_n_1\ : STD_LOGIC;
  signal \m_axis_V_user_V_1_state[1]_i_1_n_1\ : STD_LOGIC;
  signal \m_axis_V_user_V_1_state_reg_n_1_[0]\ : STD_LOGIC;
  signal pixel_count : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal pixel_count_read_reg_227 : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \^s_axis_tready\ : STD_LOGIC;
  signal s_axis_V_data_V_0_ack_in : STD_LOGIC;
  signal s_axis_V_data_V_0_data_out : STD_LOGIC_VECTOR ( 7 downto 1 );
  signal s_axis_V_data_V_0_load_A : STD_LOGIC;
  signal s_axis_V_data_V_0_load_B : STD_LOGIC;
  signal s_axis_V_data_V_0_payload_A : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal s_axis_V_data_V_0_payload_B : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal s_axis_V_data_V_0_sel : STD_LOGIC;
  signal s_axis_V_data_V_0_sel_rd_i_1_n_1 : STD_LOGIC;
  signal s_axis_V_data_V_0_sel_wr : STD_LOGIC;
  signal s_axis_V_data_V_0_sel_wr_i_1_n_1 : STD_LOGIC;
  signal s_axis_V_data_V_0_state : STD_LOGIC_VECTOR ( 1 to 1 );
  signal \s_axis_V_data_V_0_state[0]_i_1_n_1\ : STD_LOGIC;
  signal \s_axis_V_data_V_0_state_reg_n_1_[0]\ : STD_LOGIC;
  signal s_axis_V_dest_V_0_data_out : STD_LOGIC;
  signal s_axis_V_dest_V_0_payload_A : STD_LOGIC;
  signal \s_axis_V_dest_V_0_payload_A[0]_i_1_n_1\ : STD_LOGIC;
  signal s_axis_V_dest_V_0_payload_B : STD_LOGIC;
  signal \s_axis_V_dest_V_0_payload_B[0]_i_1_n_1\ : STD_LOGIC;
  signal s_axis_V_dest_V_0_sel : STD_LOGIC;
  signal s_axis_V_dest_V_0_sel_rd_i_1_n_1 : STD_LOGIC;
  signal s_axis_V_dest_V_0_sel_wr : STD_LOGIC;
  signal s_axis_V_dest_V_0_sel_wr_i_1_n_1 : STD_LOGIC;
  signal s_axis_V_dest_V_0_state : STD_LOGIC_VECTOR ( 1 to 1 );
  signal \s_axis_V_dest_V_0_state[0]_i_1_n_1\ : STD_LOGIC;
  signal \s_axis_V_dest_V_0_state_reg_n_1_[0]\ : STD_LOGIC;
  signal s_axis_V_id_V_0_ack_in : STD_LOGIC;
  signal s_axis_V_id_V_0_data_out : STD_LOGIC;
  signal s_axis_V_id_V_0_payload_A : STD_LOGIC;
  signal \s_axis_V_id_V_0_payload_A[0]_i_1_n_1\ : STD_LOGIC;
  signal s_axis_V_id_V_0_payload_B : STD_LOGIC;
  signal \s_axis_V_id_V_0_payload_B[0]_i_1_n_1\ : STD_LOGIC;
  signal s_axis_V_id_V_0_sel : STD_LOGIC;
  signal s_axis_V_id_V_0_sel_rd_i_1_n_1 : STD_LOGIC;
  signal s_axis_V_id_V_0_sel_wr : STD_LOGIC;
  signal s_axis_V_id_V_0_sel_wr_i_1_n_1 : STD_LOGIC;
  signal s_axis_V_id_V_0_state : STD_LOGIC_VECTOR ( 1 to 1 );
  signal \s_axis_V_id_V_0_state[0]_i_1_n_1\ : STD_LOGIC;
  signal \s_axis_V_id_V_0_state_reg_n_1_[0]\ : STD_LOGIC;
  signal s_axis_V_keep_V_0_ack_in : STD_LOGIC;
  signal s_axis_V_keep_V_0_data_out : STD_LOGIC;
  signal s_axis_V_keep_V_0_payload_A : STD_LOGIC;
  signal \s_axis_V_keep_V_0_payload_A[0]_i_1_n_1\ : STD_LOGIC;
  signal s_axis_V_keep_V_0_payload_B : STD_LOGIC;
  signal \s_axis_V_keep_V_0_payload_B[0]_i_1_n_1\ : STD_LOGIC;
  signal s_axis_V_keep_V_0_sel : STD_LOGIC;
  signal s_axis_V_keep_V_0_sel_rd_i_1_n_1 : STD_LOGIC;
  signal s_axis_V_keep_V_0_sel_wr : STD_LOGIC;
  signal s_axis_V_keep_V_0_sel_wr_i_1_n_1 : STD_LOGIC;
  signal s_axis_V_keep_V_0_state : STD_LOGIC_VECTOR ( 1 to 1 );
  signal \s_axis_V_keep_V_0_state[0]_i_1_n_1\ : STD_LOGIC;
  signal \s_axis_V_keep_V_0_state_reg_n_1_[0]\ : STD_LOGIC;
  signal s_axis_V_last_V_0_ack_in : STD_LOGIC;
  signal s_axis_V_last_V_0_data_out : STD_LOGIC;
  signal s_axis_V_last_V_0_payload_A : STD_LOGIC;
  signal \s_axis_V_last_V_0_payload_A[0]_i_1_n_1\ : STD_LOGIC;
  signal s_axis_V_last_V_0_payload_B : STD_LOGIC;
  signal \s_axis_V_last_V_0_payload_B[0]_i_1_n_1\ : STD_LOGIC;
  signal s_axis_V_last_V_0_sel : STD_LOGIC;
  signal s_axis_V_last_V_0_sel_rd_i_1_n_1 : STD_LOGIC;
  signal s_axis_V_last_V_0_sel_wr : STD_LOGIC;
  signal s_axis_V_last_V_0_sel_wr_i_1_n_1 : STD_LOGIC;
  signal s_axis_V_last_V_0_state : STD_LOGIC_VECTOR ( 1 to 1 );
  signal \s_axis_V_last_V_0_state[0]_i_1_n_1\ : STD_LOGIC;
  signal \s_axis_V_last_V_0_state_reg_n_1_[0]\ : STD_LOGIC;
  signal s_axis_V_strb_V_0_ack_in : STD_LOGIC;
  signal s_axis_V_strb_V_0_data_out : STD_LOGIC;
  signal s_axis_V_strb_V_0_payload_A : STD_LOGIC;
  signal \s_axis_V_strb_V_0_payload_A[0]_i_1_n_1\ : STD_LOGIC;
  signal s_axis_V_strb_V_0_payload_B : STD_LOGIC;
  signal \s_axis_V_strb_V_0_payload_B[0]_i_1_n_1\ : STD_LOGIC;
  signal s_axis_V_strb_V_0_sel : STD_LOGIC;
  signal s_axis_V_strb_V_0_sel_rd_i_1_n_1 : STD_LOGIC;
  signal s_axis_V_strb_V_0_sel_wr : STD_LOGIC;
  signal s_axis_V_strb_V_0_sel_wr_i_1_n_1 : STD_LOGIC;
  signal s_axis_V_strb_V_0_state : STD_LOGIC_VECTOR ( 1 to 1 );
  signal \s_axis_V_strb_V_0_state[0]_i_1_n_1\ : STD_LOGIC;
  signal \s_axis_V_strb_V_0_state_reg_n_1_[0]\ : STD_LOGIC;
  signal s_axis_V_user_V_0_ack_in : STD_LOGIC;
  signal s_axis_V_user_V_0_data_out : STD_LOGIC;
  signal s_axis_V_user_V_0_payload_A : STD_LOGIC;
  signal \s_axis_V_user_V_0_payload_A[0]_i_1_n_1\ : STD_LOGIC;
  signal s_axis_V_user_V_0_payload_B : STD_LOGIC;
  signal \s_axis_V_user_V_0_payload_B[0]_i_1_n_1\ : STD_LOGIC;
  signal s_axis_V_user_V_0_sel : STD_LOGIC;
  signal s_axis_V_user_V_0_sel_rd_i_1_n_1 : STD_LOGIC;
  signal s_axis_V_user_V_0_sel_wr : STD_LOGIC;
  signal s_axis_V_user_V_0_sel_wr_i_1_n_1 : STD_LOGIC;
  signal s_axis_V_user_V_0_state : STD_LOGIC_VECTOR ( 1 to 1 );
  signal \s_axis_V_user_V_0_state[0]_i_1_n_1\ : STD_LOGIC;
  signal \s_axis_V_user_V_0_state_reg_n_1_[0]\ : STD_LOGIC;
  signal threshold_V : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal threshold_V_read_reg_222 : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal threshold_enable : STD_LOGIC;
  signal threshold_enable_rea_reg_217 : STD_LOGIC;
  signal tmp_data_V_1_fu_202_p3 : STD_LOGIC;
  signal tmp_data_V_2_reg_271 : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal tmp_data_V_2_reg_2710 : STD_LOGIC;
  signal \tmp_data_V_2_reg_271[0]_i_1_n_1\ : STD_LOGIC;
  signal \tmp_data_V_2_reg_271[1]_i_1_n_1\ : STD_LOGIC;
  signal \tmp_data_V_2_reg_271[2]_i_1_n_1\ : STD_LOGIC;
  signal \tmp_data_V_2_reg_271[3]_i_1_n_1\ : STD_LOGIC;
  signal \tmp_data_V_2_reg_271[4]_i_1_n_1\ : STD_LOGIC;
  signal \tmp_data_V_2_reg_271[5]_i_1_n_1\ : STD_LOGIC;
  signal \tmp_data_V_2_reg_271[6]_i_1_n_1\ : STD_LOGIC;
  signal \tmp_data_V_2_reg_271[7]_i_10_n_1\ : STD_LOGIC;
  signal \tmp_data_V_2_reg_271[7]_i_11_n_1\ : STD_LOGIC;
  signal \tmp_data_V_2_reg_271[7]_i_12_n_1\ : STD_LOGIC;
  signal \tmp_data_V_2_reg_271[7]_i_13_n_1\ : STD_LOGIC;
  signal \tmp_data_V_2_reg_271[7]_i_14_n_1\ : STD_LOGIC;
  signal \tmp_data_V_2_reg_271[7]_i_15_n_1\ : STD_LOGIC;
  signal \tmp_data_V_2_reg_271[7]_i_16_n_1\ : STD_LOGIC;
  signal \tmp_data_V_2_reg_271[7]_i_17_n_1\ : STD_LOGIC;
  signal \tmp_data_V_2_reg_271[7]_i_18_n_1\ : STD_LOGIC;
  signal \tmp_data_V_2_reg_271[7]_i_19_n_1\ : STD_LOGIC;
  signal \tmp_data_V_2_reg_271[7]_i_20_n_1\ : STD_LOGIC;
  signal \tmp_data_V_2_reg_271[7]_i_21_n_1\ : STD_LOGIC;
  signal \tmp_data_V_2_reg_271[7]_i_22_n_1\ : STD_LOGIC;
  signal \tmp_data_V_2_reg_271[7]_i_24_n_1\ : STD_LOGIC;
  signal \tmp_data_V_2_reg_271[7]_i_25_n_1\ : STD_LOGIC;
  signal \tmp_data_V_2_reg_271[7]_i_26_n_1\ : STD_LOGIC;
  signal \tmp_data_V_2_reg_271[7]_i_27_n_1\ : STD_LOGIC;
  signal \tmp_data_V_2_reg_271[7]_i_28_n_1\ : STD_LOGIC;
  signal \tmp_data_V_2_reg_271[7]_i_29_n_1\ : STD_LOGIC;
  signal \tmp_data_V_2_reg_271[7]_i_2_n_1\ : STD_LOGIC;
  signal \tmp_data_V_2_reg_271[7]_i_30_n_1\ : STD_LOGIC;
  signal \tmp_data_V_2_reg_271[7]_i_31_n_1\ : STD_LOGIC;
  signal \tmp_data_V_2_reg_271[7]_i_37_n_1\ : STD_LOGIC;
  signal \tmp_data_V_2_reg_271[7]_i_38_n_1\ : STD_LOGIC;
  signal \tmp_data_V_2_reg_271[7]_i_39_n_1\ : STD_LOGIC;
  signal \tmp_data_V_2_reg_271[7]_i_3_n_1\ : STD_LOGIC;
  signal \tmp_data_V_2_reg_271[7]_i_40_n_1\ : STD_LOGIC;
  signal \tmp_data_V_2_reg_271[7]_i_41_n_1\ : STD_LOGIC;
  signal \tmp_data_V_2_reg_271[7]_i_42_n_1\ : STD_LOGIC;
  signal \tmp_data_V_2_reg_271[7]_i_43_n_1\ : STD_LOGIC;
  signal \tmp_data_V_2_reg_271[7]_i_44_n_1\ : STD_LOGIC;
  signal \tmp_data_V_2_reg_271[7]_i_45_n_1\ : STD_LOGIC;
  signal \tmp_data_V_2_reg_271[7]_i_46_n_1\ : STD_LOGIC;
  signal \tmp_data_V_2_reg_271[7]_i_47_n_1\ : STD_LOGIC;
  signal \tmp_data_V_2_reg_271[7]_i_48_n_1\ : STD_LOGIC;
  signal \tmp_data_V_2_reg_271[7]_i_49_n_1\ : STD_LOGIC;
  signal \tmp_data_V_2_reg_271[7]_i_50_n_1\ : STD_LOGIC;
  signal \tmp_data_V_2_reg_271[7]_i_51_n_1\ : STD_LOGIC;
  signal \tmp_data_V_2_reg_271[7]_i_52_n_1\ : STD_LOGIC;
  signal \tmp_data_V_2_reg_271[7]_i_7_n_1\ : STD_LOGIC;
  signal \tmp_data_V_2_reg_271[7]_i_8_n_1\ : STD_LOGIC;
  signal \tmp_data_V_2_reg_271[7]_i_9_n_1\ : STD_LOGIC;
  signal \tmp_data_V_2_reg_271_reg[7]_i_23_n_1\ : STD_LOGIC;
  signal \tmp_data_V_2_reg_271_reg[7]_i_23_n_2\ : STD_LOGIC;
  signal \tmp_data_V_2_reg_271_reg[7]_i_23_n_3\ : STD_LOGIC;
  signal \tmp_data_V_2_reg_271_reg[7]_i_23_n_4\ : STD_LOGIC;
  signal \tmp_data_V_2_reg_271_reg[7]_i_36_n_1\ : STD_LOGIC;
  signal \tmp_data_V_2_reg_271_reg[7]_i_36_n_2\ : STD_LOGIC;
  signal \tmp_data_V_2_reg_271_reg[7]_i_36_n_3\ : STD_LOGIC;
  signal \tmp_data_V_2_reg_271_reg[7]_i_36_n_4\ : STD_LOGIC;
  signal \tmp_data_V_2_reg_271_reg[7]_i_4_n_2\ : STD_LOGIC;
  signal \tmp_data_V_2_reg_271_reg[7]_i_4_n_3\ : STD_LOGIC;
  signal \tmp_data_V_2_reg_271_reg[7]_i_4_n_4\ : STD_LOGIC;
  signal \tmp_data_V_2_reg_271_reg[7]_i_5_n_2\ : STD_LOGIC;
  signal \tmp_data_V_2_reg_271_reg[7]_i_5_n_3\ : STD_LOGIC;
  signal \tmp_data_V_2_reg_271_reg[7]_i_5_n_4\ : STD_LOGIC;
  signal \tmp_data_V_2_reg_271_reg[7]_i_6_n_1\ : STD_LOGIC;
  signal \tmp_data_V_2_reg_271_reg[7]_i_6_n_2\ : STD_LOGIC;
  signal \tmp_data_V_2_reg_271_reg[7]_i_6_n_3\ : STD_LOGIC;
  signal \tmp_data_V_2_reg_271_reg[7]_i_6_n_4\ : STD_LOGIC;
  signal tmp_dest_V_reg_266 : STD_LOGIC;
  signal tmp_id_V_reg_261 : STD_LOGIC;
  signal tmp_keep_V_reg_241 : STD_LOGIC;
  signal tmp_last_V_reg_256 : STD_LOGIC;
  signal tmp_strb_V_reg_246 : STD_LOGIC;
  signal tmp_user_V_reg_251 : STD_LOGIC;
  signal \NLW_i_0_reg_143_reg[28]_i_1_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 2 );
  signal \NLW_i_0_reg_143_reg[28]_i_1_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
  signal \NLW_tmp_data_V_2_reg_271_reg[7]_i_23_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_tmp_data_V_2_reg_271_reg[7]_i_36_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_tmp_data_V_2_reg_271_reg[7]_i_4_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_tmp_data_V_2_reg_271_reg[7]_i_5_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_tmp_data_V_2_reg_271_reg[7]_i_6_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  attribute FSM_ENCODING : string;
  attribute FSM_ENCODING of \ap_CS_fsm_reg[0]\ : label is "none";
  attribute FSM_ENCODING of \ap_CS_fsm_reg[1]\ : label is "none";
  attribute FSM_ENCODING of \ap_CS_fsm_reg[2]\ : label is "none";
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \icmp_ln17_reg_232[0]_i_1\ : label is "soft_lutpair37";
  attribute SOFT_HLUTNM of \icmp_ln17_reg_232_pp0_iter1_reg[0]_i_1\ : label is "soft_lutpair37";
  attribute SOFT_HLUTNM of \m_axis_TDATA[0]_INST_0\ : label is "soft_lutpair59";
  attribute SOFT_HLUTNM of \m_axis_TDATA[1]_INST_0\ : label is "soft_lutpair60";
  attribute SOFT_HLUTNM of \m_axis_TDATA[2]_INST_0\ : label is "soft_lutpair61";
  attribute SOFT_HLUTNM of \m_axis_TDATA[3]_INST_0\ : label is "soft_lutpair61";
  attribute SOFT_HLUTNM of \m_axis_TDATA[4]_INST_0\ : label is "soft_lutpair59";
  attribute SOFT_HLUTNM of \m_axis_TDATA[5]_INST_0\ : label is "soft_lutpair60";
  attribute SOFT_HLUTNM of \m_axis_TDATA[6]_INST_0\ : label is "soft_lutpair62";
  attribute SOFT_HLUTNM of \m_axis_TDATA[7]_INST_0\ : label is "soft_lutpair62";
  attribute SOFT_HLUTNM of \m_axis_TDEST[0]_INST_0\ : label is "soft_lutpair52";
  attribute SOFT_HLUTNM of m_axis_V_data_V_1_sel_rd_i_1 : label is "soft_lutpair53";
  attribute SOFT_HLUTNM of m_axis_V_data_V_1_sel_wr_i_1 : label is "soft_lutpair46";
  attribute SOFT_HLUTNM of \m_axis_V_data_V_1_state[0]_i_1\ : label is "soft_lutpair43";
  attribute SOFT_HLUTNM of \m_axis_V_data_V_1_state[1]_i_1\ : label is "soft_lutpair43";
  attribute SOFT_HLUTNM of m_axis_V_dest_V_1_sel_rd_i_1 : label is "soft_lutpair52";
  attribute SOFT_HLUTNM of m_axis_V_dest_V_1_sel_wr_i_1 : label is "soft_lutpair47";
  attribute SOFT_HLUTNM of \m_axis_V_dest_V_1_state[0]_i_1\ : label is "soft_lutpair42";
  attribute SOFT_HLUTNM of \m_axis_V_dest_V_1_state[0]_i_3\ : label is "soft_lutpair26";
  attribute SOFT_HLUTNM of \m_axis_V_dest_V_1_state[1]_i_1\ : label is "soft_lutpair42";
  attribute SOFT_HLUTNM of m_axis_V_id_V_1_sel_rd_i_1 : label is "soft_lutpair55";
  attribute SOFT_HLUTNM of m_axis_V_id_V_1_sel_wr_i_1 : label is "soft_lutpair48";
  attribute SOFT_HLUTNM of \m_axis_V_id_V_1_state[0]_i_1\ : label is "soft_lutpair41";
  attribute SOFT_HLUTNM of \m_axis_V_id_V_1_state[1]_i_1\ : label is "soft_lutpair41";
  attribute SOFT_HLUTNM of m_axis_V_keep_V_1_sel_rd_i_1 : label is "soft_lutpair53";
  attribute SOFT_HLUTNM of m_axis_V_keep_V_1_sel_wr_i_1 : label is "soft_lutpair46";
  attribute SOFT_HLUTNM of \m_axis_V_keep_V_1_state[0]_i_1\ : label is "soft_lutpair40";
  attribute SOFT_HLUTNM of \m_axis_V_keep_V_1_state[1]_i_1\ : label is "soft_lutpair40";
  attribute SOFT_HLUTNM of m_axis_V_last_V_1_sel_rd_i_1 : label is "soft_lutpair55";
  attribute SOFT_HLUTNM of m_axis_V_last_V_1_sel_wr_i_1 : label is "soft_lutpair48";
  attribute SOFT_HLUTNM of \m_axis_V_last_V_1_state[0]_i_1\ : label is "soft_lutpair44";
  attribute SOFT_HLUTNM of \m_axis_V_last_V_1_state[1]_i_1\ : label is "soft_lutpair44";
  attribute SOFT_HLUTNM of m_axis_V_strb_V_1_sel_rd_i_1 : label is "soft_lutpair54";
  attribute SOFT_HLUTNM of \m_axis_V_strb_V_1_state[0]_i_1\ : label is "soft_lutpair38";
  attribute SOFT_HLUTNM of \m_axis_V_strb_V_1_state[1]_i_1\ : label is "soft_lutpair38";
  attribute SOFT_HLUTNM of m_axis_V_user_V_1_sel_rd_i_1 : label is "soft_lutpair54";
  attribute SOFT_HLUTNM of m_axis_V_user_V_1_sel_wr_i_1 : label is "soft_lutpair47";
  attribute SOFT_HLUTNM of \m_axis_V_user_V_1_state[0]_i_1\ : label is "soft_lutpair45";
  attribute SOFT_HLUTNM of \m_axis_V_user_V_1_state[1]_i_1\ : label is "soft_lutpair45";
  attribute SOFT_HLUTNM of s_axis_V_data_V_0_sel_rd_i_1 : label is "soft_lutpair49";
  attribute SOFT_HLUTNM of s_axis_V_data_V_0_sel_wr_i_1 : label is "soft_lutpair56";
  attribute SOFT_HLUTNM of \s_axis_V_data_V_0_state[0]_i_1\ : label is "soft_lutpair33";
  attribute SOFT_HLUTNM of \s_axis_V_data_V_0_state[1]_i_1\ : label is "soft_lutpair33";
  attribute SOFT_HLUTNM of s_axis_V_dest_V_0_sel_rd_i_1 : label is "soft_lutpair50";
  attribute SOFT_HLUTNM of s_axis_V_dest_V_0_sel_wr_i_1 : label is "soft_lutpair56";
  attribute SOFT_HLUTNM of \s_axis_V_dest_V_0_state[0]_i_1\ : label is "soft_lutpair34";
  attribute SOFT_HLUTNM of \s_axis_V_dest_V_0_state[1]_i_2\ : label is "soft_lutpair34";
  attribute SOFT_HLUTNM of s_axis_V_id_V_0_sel_rd_i_1 : label is "soft_lutpair51";
  attribute SOFT_HLUTNM of \s_axis_V_id_V_0_state[0]_i_1\ : label is "soft_lutpair36";
  attribute SOFT_HLUTNM of \s_axis_V_id_V_0_state[1]_i_1\ : label is "soft_lutpair36";
  attribute SOFT_HLUTNM of s_axis_V_keep_V_0_sel_rd_i_1 : label is "soft_lutpair49";
  attribute SOFT_HLUTNM of s_axis_V_keep_V_0_sel_wr_i_1 : label is "soft_lutpair57";
  attribute SOFT_HLUTNM of \s_axis_V_keep_V_0_state[0]_i_1\ : label is "soft_lutpair35";
  attribute SOFT_HLUTNM of \s_axis_V_keep_V_0_state[1]_i_1\ : label is "soft_lutpair35";
  attribute SOFT_HLUTNM of s_axis_V_last_V_0_sel_wr_i_1 : label is "soft_lutpair58";
  attribute SOFT_HLUTNM of \s_axis_V_last_V_0_state[0]_i_1\ : label is "soft_lutpair31";
  attribute SOFT_HLUTNM of \s_axis_V_last_V_0_state[1]_i_1\ : label is "soft_lutpair31";
  attribute SOFT_HLUTNM of s_axis_V_strb_V_0_sel_rd_i_1 : label is "soft_lutpair50";
  attribute SOFT_HLUTNM of s_axis_V_strb_V_0_sel_wr_i_1 : label is "soft_lutpair57";
  attribute SOFT_HLUTNM of \s_axis_V_strb_V_0_state[0]_i_1\ : label is "soft_lutpair32";
  attribute SOFT_HLUTNM of \s_axis_V_strb_V_0_state[1]_i_1\ : label is "soft_lutpair32";
  attribute SOFT_HLUTNM of s_axis_V_user_V_0_sel_rd_i_1 : label is "soft_lutpair51";
  attribute SOFT_HLUTNM of s_axis_V_user_V_0_sel_wr_i_1 : label is "soft_lutpair58";
  attribute SOFT_HLUTNM of \s_axis_V_user_V_0_state[0]_i_1\ : label is "soft_lutpair39";
  attribute SOFT_HLUTNM of \s_axis_V_user_V_0_state[1]_i_1\ : label is "soft_lutpair39";
  attribute SOFT_HLUTNM of \tmp_data_V_2_reg_271[1]_i_1\ : label is "soft_lutpair27";
  attribute SOFT_HLUTNM of \tmp_data_V_2_reg_271[3]_i_1\ : label is "soft_lutpair28";
  attribute SOFT_HLUTNM of \tmp_data_V_2_reg_271[5]_i_1\ : label is "soft_lutpair29";
  attribute SOFT_HLUTNM of \tmp_data_V_2_reg_271[7]_i_2\ : label is "soft_lutpair30";
  attribute SOFT_HLUTNM of \tmp_data_V_2_reg_271[7]_i_3\ : label is "soft_lutpair26";
  attribute SOFT_HLUTNM of \tmp_data_V_2_reg_271[7]_i_32\ : label is "soft_lutpair30";
  attribute SOFT_HLUTNM of \tmp_data_V_2_reg_271[7]_i_33\ : label is "soft_lutpair29";
  attribute SOFT_HLUTNM of \tmp_data_V_2_reg_271[7]_i_34\ : label is "soft_lutpair28";
  attribute SOFT_HLUTNM of \tmp_data_V_2_reg_271[7]_i_35\ : label is "soft_lutpair27";
begin
  m_axis_TVALID <= \^m_axis_tvalid\;
  s_axi_CTRL_BRESP(1) <= \<const0>\;
  s_axi_CTRL_BRESP(0) <= \<const0>\;
  s_axi_CTRL_RRESP(1) <= \<const0>\;
  s_axi_CTRL_RRESP(0) <= \<const0>\;
  s_axis_TREADY <= \^s_axis_tready\;
GND: unisim.vcomponents.GND
     port map (
      G => \<const0>\
    );
\ap_CS_fsm[2]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0F11"
    )
        port map (
      I0 => ap_done,
      I1 => \ap_CS_fsm_reg_n_1_[0]\,
      I2 => \ap_CS_fsm[2]_i_2_n_1\,
      I3 => ap_CS_fsm_pp0_stage0,
      O => \ap_CS_fsm[2]_i_1_n_1\
    );
\ap_CS_fsm[2]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FBFFFBFBFAFAFBFB"
    )
        port map (
      I0 => ap_enable_reg_pp0_iter1_reg_n_1,
      I1 => ap_enable_reg_pp0_iter2_reg_n_1,
      I2 => \tmp_data_V_2_reg_271[7]_i_3_n_1\,
      I3 => \s_axis_V_data_V_0_state_reg_n_1_[0]\,
      I4 => ap_enable_reg_pp0_iter0,
      I5 => icmp_ln17_fu_158_p2,
      O => \ap_CS_fsm[2]_i_2_n_1\
    );
\ap_CS_fsm_reg[0]\: unisim.vcomponents.FDSE
    generic map(
      INIT => '1'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => cubeocc_hls_CTRL_s_axi_U_n_50,
      Q => \ap_CS_fsm_reg_n_1_[0]\,
      S => ap_rst_n_inv
    );
\ap_CS_fsm_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => cubeocc_hls_CTRL_s_axi_U_n_49,
      Q => ap_CS_fsm_pp0_stage0,
      R => ap_rst_n_inv
    );
\ap_CS_fsm_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \ap_CS_fsm[2]_i_1_n_1\,
      Q => ap_CS_fsm_state5,
      R => ap_rst_n_inv
    );
ap_enable_reg_pp0_iter0_i_2: unisim.vcomponents.LUT4
    generic map(
      INIT => X"00F7"
    )
        port map (
      I0 => icmp_ln17_fu_158_p2,
      I1 => ap_enable_reg_pp0_iter0,
      I2 => \s_axis_V_data_V_0_state_reg_n_1_[0]\,
      I3 => \tmp_data_V_2_reg_271[7]_i_3_n_1\,
      O => ap_block_pp0_stage0_subdone3_in
    );
ap_enable_reg_pp0_iter0_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => cubeocc_hls_CTRL_s_axi_U_n_53,
      Q => ap_enable_reg_pp0_iter0,
      R => '0'
    );
ap_enable_reg_pp0_iter1_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FF88008000000000"
    )
        port map (
      I0 => icmp_ln17_fu_158_p2,
      I1 => ap_enable_reg_pp0_iter0,
      I2 => \s_axis_V_data_V_0_state_reg_n_1_[0]\,
      I3 => \tmp_data_V_2_reg_271[7]_i_3_n_1\,
      I4 => ap_enable_reg_pp0_iter1_reg_n_1,
      I5 => ap_rst_n,
      O => ap_enable_reg_pp0_iter1_i_1_n_1
    );
ap_enable_reg_pp0_iter1_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => ap_enable_reg_pp0_iter1_i_1_n_1,
      Q => ap_enable_reg_pp0_iter1_reg_n_1,
      R => '0'
    );
ap_enable_reg_pp0_iter2_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => cubeocc_hls_CTRL_s_axi_U_n_4,
      Q => ap_enable_reg_pp0_iter2_reg_n_1,
      R => '0'
    );
cubeocc_hls_CTRL_s_axi_U: entity work.decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_cubeocc_hls_CTRL_s_axi
     port map (
      CO(0) => icmp_ln17_fu_158_p2,
      D(1) => cubeocc_hls_CTRL_s_axi_U_n_49,
      D(0) => cubeocc_hls_CTRL_s_axi_U_n_50,
      E(0) => ap_NS_fsm1,
      \FSM_onehot_rstate_reg[1]_0\ => s_axi_CTRL_ARREADY,
      \FSM_onehot_wstate_reg[1]_0\ => s_axi_CTRL_AWREADY,
      \FSM_onehot_wstate_reg[2]_0\ => s_axi_CTRL_WREADY,
      Q(2) => ap_CS_fsm_state5,
      Q(1) => ap_CS_fsm_pp0_stage0,
      Q(0) => \ap_CS_fsm_reg_n_1_[0]\,
      \ap_CS_fsm_reg[0]\ => cubeocc_hls_CTRL_s_axi_U_n_4,
      \ap_CS_fsm_reg[1]\ => cubeocc_hls_CTRL_s_axi_U_n_53,
      \ap_CS_fsm_reg[1]_0\ => \ap_CS_fsm[2]_i_2_n_1\,
      ap_block_pp0_stage0_subdone3_in => ap_block_pp0_stage0_subdone3_in,
      ap_clk => ap_clk,
      ap_done => ap_done,
      ap_enable_reg_pp0_iter0 => ap_enable_reg_pp0_iter0,
      ap_enable_reg_pp0_iter2_reg => ap_enable_reg_pp0_iter1_reg_n_1,
      ap_enable_reg_pp0_iter2_reg_0 => ap_enable_reg_pp0_iter2_reg_n_1,
      ap_rst_n => ap_rst_n,
      ap_rst_n_inv => ap_rst_n_inv,
      i_0_reg_143 => i_0_reg_143,
      \i_0_reg_143_reg[0]\ => \i_0_reg_143[0]_i_2_n_1\,
      int_ap_ready_i_2_0 => \m_axis_V_data_V_1_state_reg_n_1_[0]\,
      int_ap_ready_i_2_1 => \^m_axis_tvalid\,
      int_ap_ready_reg_0 => \m_axis_V_strb_V_1_state_reg_n_1_[0]\,
      int_ap_ready_reg_1 => \m_axis_V_last_V_1_state_reg_n_1_[0]\,
      int_ap_ready_reg_2 => \m_axis_V_user_V_1_state_reg_n_1_[0]\,
      int_ap_ready_reg_3 => \m_axis_V_id_V_1_state_reg_n_1_[0]\,
      int_ap_ready_reg_4 => \m_axis_V_keep_V_1_state_reg_n_1_[0]\,
      \int_pixel_count_reg[31]_0\(31 downto 0) => pixel_count(31 downto 0),
      \int_threshold_V_reg[7]_0\(7 downto 0) => threshold_V(7 downto 0),
      interrupt => interrupt,
      m_axis_TREADY => m_axis_TREADY,
      m_axis_V_data_V_1_ack_in => m_axis_V_data_V_1_ack_in,
      m_axis_V_dest_V_1_ack_in => m_axis_V_dest_V_1_ack_in,
      m_axis_V_id_V_1_ack_in => m_axis_V_id_V_1_ack_in,
      m_axis_V_keep_V_1_ack_in => m_axis_V_keep_V_1_ack_in,
      m_axis_V_last_V_1_ack_in => m_axis_V_last_V_1_ack_in,
      m_axis_V_strb_V_1_ack_in => m_axis_V_strb_V_1_ack_in,
      m_axis_V_user_V_1_ack_in => m_axis_V_user_V_1_ack_in,
      s_axi_CTRL_ARADDR(5 downto 0) => s_axi_CTRL_ARADDR(5 downto 0),
      s_axi_CTRL_ARVALID => s_axi_CTRL_ARVALID,
      s_axi_CTRL_AWADDR(5 downto 0) => s_axi_CTRL_AWADDR(5 downto 0),
      s_axi_CTRL_AWVALID => s_axi_CTRL_AWVALID,
      s_axi_CTRL_BREADY => s_axi_CTRL_BREADY,
      s_axi_CTRL_BVALID => s_axi_CTRL_BVALID,
      s_axi_CTRL_RDATA(31 downto 0) => s_axi_CTRL_RDATA(31 downto 0),
      s_axi_CTRL_RREADY => s_axi_CTRL_RREADY,
      s_axi_CTRL_RVALID => s_axi_CTRL_RVALID,
      s_axi_CTRL_WDATA(31 downto 0) => s_axi_CTRL_WDATA(31 downto 0),
      s_axi_CTRL_WSTRB(3 downto 0) => s_axi_CTRL_WSTRB(3 downto 0),
      s_axi_CTRL_WVALID => s_axi_CTRL_WVALID,
      threshold_enable => threshold_enable
    );
\i_0_reg_143[0]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00800000"
    )
        port map (
      I0 => icmp_ln17_fu_158_p2,
      I1 => ap_CS_fsm_pp0_stage0,
      I2 => \s_axis_V_data_V_0_state_reg_n_1_[0]\,
      I3 => \tmp_data_V_2_reg_271[7]_i_3_n_1\,
      I4 => ap_enable_reg_pp0_iter0,
      O => \i_0_reg_143[0]_i_2_n_1\
    );
\i_0_reg_143[0]_i_4\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => i_0_reg_143_reg(0),
      O => \i_0_reg_143[0]_i_4_n_1\
    );
\i_0_reg_143_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \i_0_reg_143[0]_i_2_n_1\,
      D => \i_0_reg_143_reg[0]_i_3_n_8\,
      Q => i_0_reg_143_reg(0),
      R => i_0_reg_143
    );
\i_0_reg_143_reg[0]_i_3\: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => \i_0_reg_143_reg[0]_i_3_n_1\,
      CO(2) => \i_0_reg_143_reg[0]_i_3_n_2\,
      CO(1) => \i_0_reg_143_reg[0]_i_3_n_3\,
      CO(0) => \i_0_reg_143_reg[0]_i_3_n_4\,
      CYINIT => '0',
      DI(3 downto 0) => B"0001",
      O(3) => \i_0_reg_143_reg[0]_i_3_n_5\,
      O(2) => \i_0_reg_143_reg[0]_i_3_n_6\,
      O(1) => \i_0_reg_143_reg[0]_i_3_n_7\,
      O(0) => \i_0_reg_143_reg[0]_i_3_n_8\,
      S(3 downto 1) => i_0_reg_143_reg(3 downto 1),
      S(0) => \i_0_reg_143[0]_i_4_n_1\
    );
\i_0_reg_143_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \i_0_reg_143[0]_i_2_n_1\,
      D => \i_0_reg_143_reg[8]_i_1_n_6\,
      Q => i_0_reg_143_reg(10),
      R => i_0_reg_143
    );
\i_0_reg_143_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \i_0_reg_143[0]_i_2_n_1\,
      D => \i_0_reg_143_reg[8]_i_1_n_5\,
      Q => i_0_reg_143_reg(11),
      R => i_0_reg_143
    );
\i_0_reg_143_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \i_0_reg_143[0]_i_2_n_1\,
      D => \i_0_reg_143_reg[12]_i_1_n_8\,
      Q => i_0_reg_143_reg(12),
      R => i_0_reg_143
    );
\i_0_reg_143_reg[12]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \i_0_reg_143_reg[8]_i_1_n_1\,
      CO(3) => \i_0_reg_143_reg[12]_i_1_n_1\,
      CO(2) => \i_0_reg_143_reg[12]_i_1_n_2\,
      CO(1) => \i_0_reg_143_reg[12]_i_1_n_3\,
      CO(0) => \i_0_reg_143_reg[12]_i_1_n_4\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \i_0_reg_143_reg[12]_i_1_n_5\,
      O(2) => \i_0_reg_143_reg[12]_i_1_n_6\,
      O(1) => \i_0_reg_143_reg[12]_i_1_n_7\,
      O(0) => \i_0_reg_143_reg[12]_i_1_n_8\,
      S(3 downto 0) => i_0_reg_143_reg(15 downto 12)
    );
\i_0_reg_143_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \i_0_reg_143[0]_i_2_n_1\,
      D => \i_0_reg_143_reg[12]_i_1_n_7\,
      Q => i_0_reg_143_reg(13),
      R => i_0_reg_143
    );
\i_0_reg_143_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \i_0_reg_143[0]_i_2_n_1\,
      D => \i_0_reg_143_reg[12]_i_1_n_6\,
      Q => i_0_reg_143_reg(14),
      R => i_0_reg_143
    );
\i_0_reg_143_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \i_0_reg_143[0]_i_2_n_1\,
      D => \i_0_reg_143_reg[12]_i_1_n_5\,
      Q => i_0_reg_143_reg(15),
      R => i_0_reg_143
    );
\i_0_reg_143_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \i_0_reg_143[0]_i_2_n_1\,
      D => \i_0_reg_143_reg[16]_i_1_n_8\,
      Q => i_0_reg_143_reg(16),
      R => i_0_reg_143
    );
\i_0_reg_143_reg[16]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \i_0_reg_143_reg[12]_i_1_n_1\,
      CO(3) => \i_0_reg_143_reg[16]_i_1_n_1\,
      CO(2) => \i_0_reg_143_reg[16]_i_1_n_2\,
      CO(1) => \i_0_reg_143_reg[16]_i_1_n_3\,
      CO(0) => \i_0_reg_143_reg[16]_i_1_n_4\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \i_0_reg_143_reg[16]_i_1_n_5\,
      O(2) => \i_0_reg_143_reg[16]_i_1_n_6\,
      O(1) => \i_0_reg_143_reg[16]_i_1_n_7\,
      O(0) => \i_0_reg_143_reg[16]_i_1_n_8\,
      S(3 downto 0) => i_0_reg_143_reg(19 downto 16)
    );
\i_0_reg_143_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \i_0_reg_143[0]_i_2_n_1\,
      D => \i_0_reg_143_reg[16]_i_1_n_7\,
      Q => i_0_reg_143_reg(17),
      R => i_0_reg_143
    );
\i_0_reg_143_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \i_0_reg_143[0]_i_2_n_1\,
      D => \i_0_reg_143_reg[16]_i_1_n_6\,
      Q => i_0_reg_143_reg(18),
      R => i_0_reg_143
    );
\i_0_reg_143_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \i_0_reg_143[0]_i_2_n_1\,
      D => \i_0_reg_143_reg[16]_i_1_n_5\,
      Q => i_0_reg_143_reg(19),
      R => i_0_reg_143
    );
\i_0_reg_143_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \i_0_reg_143[0]_i_2_n_1\,
      D => \i_0_reg_143_reg[0]_i_3_n_7\,
      Q => i_0_reg_143_reg(1),
      R => i_0_reg_143
    );
\i_0_reg_143_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \i_0_reg_143[0]_i_2_n_1\,
      D => \i_0_reg_143_reg[20]_i_1_n_8\,
      Q => i_0_reg_143_reg(20),
      R => i_0_reg_143
    );
\i_0_reg_143_reg[20]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \i_0_reg_143_reg[16]_i_1_n_1\,
      CO(3) => \i_0_reg_143_reg[20]_i_1_n_1\,
      CO(2) => \i_0_reg_143_reg[20]_i_1_n_2\,
      CO(1) => \i_0_reg_143_reg[20]_i_1_n_3\,
      CO(0) => \i_0_reg_143_reg[20]_i_1_n_4\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \i_0_reg_143_reg[20]_i_1_n_5\,
      O(2) => \i_0_reg_143_reg[20]_i_1_n_6\,
      O(1) => \i_0_reg_143_reg[20]_i_1_n_7\,
      O(0) => \i_0_reg_143_reg[20]_i_1_n_8\,
      S(3 downto 0) => i_0_reg_143_reg(23 downto 20)
    );
\i_0_reg_143_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \i_0_reg_143[0]_i_2_n_1\,
      D => \i_0_reg_143_reg[20]_i_1_n_7\,
      Q => i_0_reg_143_reg(21),
      R => i_0_reg_143
    );
\i_0_reg_143_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \i_0_reg_143[0]_i_2_n_1\,
      D => \i_0_reg_143_reg[20]_i_1_n_6\,
      Q => i_0_reg_143_reg(22),
      R => i_0_reg_143
    );
\i_0_reg_143_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \i_0_reg_143[0]_i_2_n_1\,
      D => \i_0_reg_143_reg[20]_i_1_n_5\,
      Q => i_0_reg_143_reg(23),
      R => i_0_reg_143
    );
\i_0_reg_143_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \i_0_reg_143[0]_i_2_n_1\,
      D => \i_0_reg_143_reg[24]_i_1_n_8\,
      Q => i_0_reg_143_reg(24),
      R => i_0_reg_143
    );
\i_0_reg_143_reg[24]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \i_0_reg_143_reg[20]_i_1_n_1\,
      CO(3) => \i_0_reg_143_reg[24]_i_1_n_1\,
      CO(2) => \i_0_reg_143_reg[24]_i_1_n_2\,
      CO(1) => \i_0_reg_143_reg[24]_i_1_n_3\,
      CO(0) => \i_0_reg_143_reg[24]_i_1_n_4\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \i_0_reg_143_reg[24]_i_1_n_5\,
      O(2) => \i_0_reg_143_reg[24]_i_1_n_6\,
      O(1) => \i_0_reg_143_reg[24]_i_1_n_7\,
      O(0) => \i_0_reg_143_reg[24]_i_1_n_8\,
      S(3 downto 0) => i_0_reg_143_reg(27 downto 24)
    );
\i_0_reg_143_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \i_0_reg_143[0]_i_2_n_1\,
      D => \i_0_reg_143_reg[24]_i_1_n_7\,
      Q => i_0_reg_143_reg(25),
      R => i_0_reg_143
    );
\i_0_reg_143_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \i_0_reg_143[0]_i_2_n_1\,
      D => \i_0_reg_143_reg[24]_i_1_n_6\,
      Q => i_0_reg_143_reg(26),
      R => i_0_reg_143
    );
\i_0_reg_143_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \i_0_reg_143[0]_i_2_n_1\,
      D => \i_0_reg_143_reg[24]_i_1_n_5\,
      Q => i_0_reg_143_reg(27),
      R => i_0_reg_143
    );
\i_0_reg_143_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \i_0_reg_143[0]_i_2_n_1\,
      D => \i_0_reg_143_reg[28]_i_1_n_8\,
      Q => i_0_reg_143_reg(28),
      R => i_0_reg_143
    );
\i_0_reg_143_reg[28]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \i_0_reg_143_reg[24]_i_1_n_1\,
      CO(3 downto 2) => \NLW_i_0_reg_143_reg[28]_i_1_CO_UNCONNECTED\(3 downto 2),
      CO(1) => \i_0_reg_143_reg[28]_i_1_n_3\,
      CO(0) => \i_0_reg_143_reg[28]_i_1_n_4\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \NLW_i_0_reg_143_reg[28]_i_1_O_UNCONNECTED\(3),
      O(2) => \i_0_reg_143_reg[28]_i_1_n_6\,
      O(1) => \i_0_reg_143_reg[28]_i_1_n_7\,
      O(0) => \i_0_reg_143_reg[28]_i_1_n_8\,
      S(3) => '0',
      S(2 downto 0) => i_0_reg_143_reg(30 downto 28)
    );
\i_0_reg_143_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \i_0_reg_143[0]_i_2_n_1\,
      D => \i_0_reg_143_reg[28]_i_1_n_7\,
      Q => i_0_reg_143_reg(29),
      R => i_0_reg_143
    );
\i_0_reg_143_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \i_0_reg_143[0]_i_2_n_1\,
      D => \i_0_reg_143_reg[0]_i_3_n_6\,
      Q => i_0_reg_143_reg(2),
      R => i_0_reg_143
    );
\i_0_reg_143_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \i_0_reg_143[0]_i_2_n_1\,
      D => \i_0_reg_143_reg[28]_i_1_n_6\,
      Q => i_0_reg_143_reg(30),
      R => i_0_reg_143
    );
\i_0_reg_143_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \i_0_reg_143[0]_i_2_n_1\,
      D => \i_0_reg_143_reg[0]_i_3_n_5\,
      Q => i_0_reg_143_reg(3),
      R => i_0_reg_143
    );
\i_0_reg_143_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \i_0_reg_143[0]_i_2_n_1\,
      D => \i_0_reg_143_reg[4]_i_1_n_8\,
      Q => i_0_reg_143_reg(4),
      R => i_0_reg_143
    );
\i_0_reg_143_reg[4]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \i_0_reg_143_reg[0]_i_3_n_1\,
      CO(3) => \i_0_reg_143_reg[4]_i_1_n_1\,
      CO(2) => \i_0_reg_143_reg[4]_i_1_n_2\,
      CO(1) => \i_0_reg_143_reg[4]_i_1_n_3\,
      CO(0) => \i_0_reg_143_reg[4]_i_1_n_4\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \i_0_reg_143_reg[4]_i_1_n_5\,
      O(2) => \i_0_reg_143_reg[4]_i_1_n_6\,
      O(1) => \i_0_reg_143_reg[4]_i_1_n_7\,
      O(0) => \i_0_reg_143_reg[4]_i_1_n_8\,
      S(3 downto 0) => i_0_reg_143_reg(7 downto 4)
    );
\i_0_reg_143_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \i_0_reg_143[0]_i_2_n_1\,
      D => \i_0_reg_143_reg[4]_i_1_n_7\,
      Q => i_0_reg_143_reg(5),
      R => i_0_reg_143
    );
\i_0_reg_143_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \i_0_reg_143[0]_i_2_n_1\,
      D => \i_0_reg_143_reg[4]_i_1_n_6\,
      Q => i_0_reg_143_reg(6),
      R => i_0_reg_143
    );
\i_0_reg_143_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \i_0_reg_143[0]_i_2_n_1\,
      D => \i_0_reg_143_reg[4]_i_1_n_5\,
      Q => i_0_reg_143_reg(7),
      R => i_0_reg_143
    );
\i_0_reg_143_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \i_0_reg_143[0]_i_2_n_1\,
      D => \i_0_reg_143_reg[8]_i_1_n_8\,
      Q => i_0_reg_143_reg(8),
      R => i_0_reg_143
    );
\i_0_reg_143_reg[8]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \i_0_reg_143_reg[4]_i_1_n_1\,
      CO(3) => \i_0_reg_143_reg[8]_i_1_n_1\,
      CO(2) => \i_0_reg_143_reg[8]_i_1_n_2\,
      CO(1) => \i_0_reg_143_reg[8]_i_1_n_3\,
      CO(0) => \i_0_reg_143_reg[8]_i_1_n_4\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \i_0_reg_143_reg[8]_i_1_n_5\,
      O(2) => \i_0_reg_143_reg[8]_i_1_n_6\,
      O(1) => \i_0_reg_143_reg[8]_i_1_n_7\,
      O(0) => \i_0_reg_143_reg[8]_i_1_n_8\,
      S(3 downto 0) => i_0_reg_143_reg(11 downto 8)
    );
\i_0_reg_143_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \i_0_reg_143[0]_i_2_n_1\,
      D => \i_0_reg_143_reg[8]_i_1_n_7\,
      Q => i_0_reg_143_reg(9),
      R => i_0_reg_143
    );
\icmp_ln17_reg_232[0]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BF80"
    )
        port map (
      I0 => icmp_ln17_fu_158_p2,
      I1 => ap_block_pp0_stage0_subdone3_in,
      I2 => ap_CS_fsm_pp0_stage0,
      I3 => icmp_ln17_reg_232,
      O => \icmp_ln17_reg_232[0]_i_1_n_1\
    );
\icmp_ln17_reg_232_pp0_iter1_reg[0]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BF80"
    )
        port map (
      I0 => icmp_ln17_reg_232,
      I1 => ap_block_pp0_stage0_subdone3_in,
      I2 => ap_CS_fsm_pp0_stage0,
      I3 => icmp_ln17_reg_232_pp0_iter1_reg,
      O => \icmp_ln17_reg_232_pp0_iter1_reg[0]_i_1_n_1\
    );
\icmp_ln17_reg_232_pp0_iter1_reg_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \icmp_ln17_reg_232_pp0_iter1_reg[0]_i_1_n_1\,
      Q => icmp_ln17_reg_232_pp0_iter1_reg,
      R => '0'
    );
\icmp_ln17_reg_232_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \icmp_ln17_reg_232[0]_i_1_n_1\,
      Q => icmp_ln17_reg_232,
      R => '0'
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
\m_axis_V_data_V_1_payload_A[7]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"45"
    )
        port map (
      I0 => m_axis_V_data_V_1_sel_wr,
      I1 => m_axis_V_data_V_1_ack_in,
      I2 => \m_axis_V_data_V_1_state_reg_n_1_[0]\,
      O => m_axis_V_data_V_1_load_A
    );
\m_axis_V_data_V_1_payload_A_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => m_axis_V_data_V_1_load_A,
      D => tmp_data_V_2_reg_271(0),
      Q => m_axis_V_data_V_1_payload_A(0),
      R => '0'
    );
\m_axis_V_data_V_1_payload_A_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => m_axis_V_data_V_1_load_A,
      D => tmp_data_V_2_reg_271(1),
      Q => m_axis_V_data_V_1_payload_A(1),
      R => '0'
    );
\m_axis_V_data_V_1_payload_A_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => m_axis_V_data_V_1_load_A,
      D => tmp_data_V_2_reg_271(2),
      Q => m_axis_V_data_V_1_payload_A(2),
      R => '0'
    );
\m_axis_V_data_V_1_payload_A_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => m_axis_V_data_V_1_load_A,
      D => tmp_data_V_2_reg_271(3),
      Q => m_axis_V_data_V_1_payload_A(3),
      R => '0'
    );
\m_axis_V_data_V_1_payload_A_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => m_axis_V_data_V_1_load_A,
      D => tmp_data_V_2_reg_271(4),
      Q => m_axis_V_data_V_1_payload_A(4),
      R => '0'
    );
\m_axis_V_data_V_1_payload_A_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => m_axis_V_data_V_1_load_A,
      D => tmp_data_V_2_reg_271(5),
      Q => m_axis_V_data_V_1_payload_A(5),
      R => '0'
    );
\m_axis_V_data_V_1_payload_A_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => m_axis_V_data_V_1_load_A,
      D => tmp_data_V_2_reg_271(6),
      Q => m_axis_V_data_V_1_payload_A(6),
      R => '0'
    );
\m_axis_V_data_V_1_payload_A_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => m_axis_V_data_V_1_load_A,
      D => tmp_data_V_2_reg_271(7),
      Q => m_axis_V_data_V_1_payload_A(7),
      R => '0'
    );
\m_axis_V_data_V_1_payload_B[7]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"8A"
    )
        port map (
      I0 => m_axis_V_data_V_1_sel_wr,
      I1 => m_axis_V_data_V_1_ack_in,
      I2 => \m_axis_V_data_V_1_state_reg_n_1_[0]\,
      O => m_axis_V_data_V_1_load_B
    );
\m_axis_V_data_V_1_payload_B_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => m_axis_V_data_V_1_load_B,
      D => tmp_data_V_2_reg_271(0),
      Q => m_axis_V_data_V_1_payload_B(0),
      R => '0'
    );
\m_axis_V_data_V_1_payload_B_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => m_axis_V_data_V_1_load_B,
      D => tmp_data_V_2_reg_271(1),
      Q => m_axis_V_data_V_1_payload_B(1),
      R => '0'
    );
\m_axis_V_data_V_1_payload_B_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => m_axis_V_data_V_1_load_B,
      D => tmp_data_V_2_reg_271(2),
      Q => m_axis_V_data_V_1_payload_B(2),
      R => '0'
    );
\m_axis_V_data_V_1_payload_B_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => m_axis_V_data_V_1_load_B,
      D => tmp_data_V_2_reg_271(3),
      Q => m_axis_V_data_V_1_payload_B(3),
      R => '0'
    );
\m_axis_V_data_V_1_payload_B_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => m_axis_V_data_V_1_load_B,
      D => tmp_data_V_2_reg_271(4),
      Q => m_axis_V_data_V_1_payload_B(4),
      R => '0'
    );
\m_axis_V_data_V_1_payload_B_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => m_axis_V_data_V_1_load_B,
      D => tmp_data_V_2_reg_271(5),
      Q => m_axis_V_data_V_1_payload_B(5),
      R => '0'
    );
\m_axis_V_data_V_1_payload_B_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => m_axis_V_data_V_1_load_B,
      D => tmp_data_V_2_reg_271(6),
      Q => m_axis_V_data_V_1_payload_B(6),
      R => '0'
    );
\m_axis_V_data_V_1_payload_B_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => m_axis_V_data_V_1_load_B,
      D => tmp_data_V_2_reg_271(7),
      Q => m_axis_V_data_V_1_payload_B(7),
      R => '0'
    );
m_axis_V_data_V_1_sel_rd_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"78"
    )
        port map (
      I0 => \m_axis_V_data_V_1_state_reg_n_1_[0]\,
      I1 => m_axis_TREADY,
      I2 => m_axis_V_data_V_1_sel,
      O => m_axis_V_data_V_1_sel_rd_i_1_n_1
    );
m_axis_V_data_V_1_sel_rd_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => m_axis_V_data_V_1_sel_rd_i_1_n_1,
      Q => m_axis_V_data_V_1_sel,
      R => ap_rst_n_inv
    );
m_axis_V_data_V_1_sel_wr_i_1: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \m_axis_V_dest_V_1_state[0]_i_2_n_1\,
      I1 => m_axis_V_data_V_1_sel_wr,
      O => m_axis_V_data_V_1_sel_wr_i_1_n_1
    );
m_axis_V_data_V_1_sel_wr_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => m_axis_V_data_V_1_sel_wr_i_1_n_1,
      Q => m_axis_V_data_V_1_sel_wr,
      R => ap_rst_n_inv
    );
\m_axis_V_data_V_1_state[0]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2AFF"
    )
        port map (
      I0 => \m_axis_V_data_V_1_state_reg_n_1_[0]\,
      I1 => m_axis_TREADY,
      I2 => m_axis_V_data_V_1_ack_in,
      I3 => \m_axis_V_dest_V_1_state[0]_i_2_n_1\,
      O => \m_axis_V_data_V_1_state[0]_i_1_n_1\
    );
\m_axis_V_data_V_1_state[1]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FBBB"
    )
        port map (
      I0 => m_axis_TREADY,
      I1 => \m_axis_V_data_V_1_state_reg_n_1_[0]\,
      I2 => \m_axis_V_dest_V_1_state[0]_i_2_n_1\,
      I3 => m_axis_V_data_V_1_ack_in,
      O => m_axis_V_data_V_1_state(1)
    );
\m_axis_V_data_V_1_state_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \m_axis_V_data_V_1_state[0]_i_1_n_1\,
      Q => \m_axis_V_data_V_1_state_reg_n_1_[0]\,
      R => ap_rst_n_inv
    );
\m_axis_V_data_V_1_state_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => m_axis_V_data_V_1_state(1),
      Q => m_axis_V_data_V_1_ack_in,
      R => ap_rst_n_inv
    );
\m_axis_V_dest_V_1_payload_A[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"EFEE2022"
    )
        port map (
      I0 => tmp_dest_V_reg_266,
      I1 => m_axis_V_dest_V_1_sel_wr,
      I2 => m_axis_V_dest_V_1_ack_in,
      I3 => \^m_axis_tvalid\,
      I4 => m_axis_V_dest_V_1_payload_A,
      O => \m_axis_V_dest_V_1_payload_A[0]_i_1_n_1\
    );
\m_axis_V_dest_V_1_payload_A_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \m_axis_V_dest_V_1_payload_A[0]_i_1_n_1\,
      Q => m_axis_V_dest_V_1_payload_A,
      R => '0'
    );
\m_axis_V_dest_V_1_payload_B[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"BFBB8088"
    )
        port map (
      I0 => tmp_dest_V_reg_266,
      I1 => m_axis_V_dest_V_1_sel_wr,
      I2 => m_axis_V_dest_V_1_ack_in,
      I3 => \^m_axis_tvalid\,
      I4 => m_axis_V_dest_V_1_payload_B,
      O => \m_axis_V_dest_V_1_payload_B[0]_i_1_n_1\
    );
\m_axis_V_dest_V_1_payload_B_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \m_axis_V_dest_V_1_payload_B[0]_i_1_n_1\,
      Q => m_axis_V_dest_V_1_payload_B,
      R => '0'
    );
m_axis_V_dest_V_1_sel_rd_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"78"
    )
        port map (
      I0 => \^m_axis_tvalid\,
      I1 => m_axis_TREADY,
      I2 => m_axis_V_dest_V_1_sel,
      O => m_axis_V_dest_V_1_sel_rd_i_1_n_1
    );
m_axis_V_dest_V_1_sel_rd_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => m_axis_V_dest_V_1_sel_rd_i_1_n_1,
      Q => m_axis_V_dest_V_1_sel,
      R => ap_rst_n_inv
    );
m_axis_V_dest_V_1_sel_wr_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B4"
    )
        port map (
      I0 => \m_axis_V_dest_V_1_state[0]_i_2_n_1\,
      I1 => m_axis_V_dest_V_1_ack_in,
      I2 => m_axis_V_dest_V_1_sel_wr,
      O => m_axis_V_dest_V_1_sel_wr_i_1_n_1
    );
m_axis_V_dest_V_1_sel_wr_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => m_axis_V_dest_V_1_sel_wr_i_1_n_1,
      Q => m_axis_V_dest_V_1_sel_wr,
      R => ap_rst_n_inv
    );
\m_axis_V_dest_V_1_state[0]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"5DCC"
    )
        port map (
      I0 => \m_axis_V_dest_V_1_state[0]_i_2_n_1\,
      I1 => \^m_axis_tvalid\,
      I2 => m_axis_TREADY,
      I3 => m_axis_V_dest_V_1_ack_in,
      O => \m_axis_V_dest_V_1_state[0]_i_1_n_1\
    );
\m_axis_V_dest_V_1_state[0]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFAAEAFFFFFFFF"
    )
        port map (
      I0 => \m_axis_V_dest_V_1_state[0]_i_3_n_1\,
      I1 => icmp_ln17_fu_158_p2,
      I2 => ap_enable_reg_pp0_iter0,
      I3 => \s_axis_V_data_V_0_state_reg_n_1_[0]\,
      I4 => \tmp_data_V_2_reg_271[7]_i_3_n_1\,
      I5 => ap_CS_fsm_pp0_stage0,
      O => \m_axis_V_dest_V_1_state[0]_i_2_n_1\
    );
\m_axis_V_dest_V_1_state[0]_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"7"
    )
        port map (
      I0 => icmp_ln17_reg_232,
      I1 => ap_enable_reg_pp0_iter1_reg_n_1,
      O => \m_axis_V_dest_V_1_state[0]_i_3_n_1\
    );
\m_axis_V_dest_V_1_state[1]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FBBB"
    )
        port map (
      I0 => m_axis_TREADY,
      I1 => \^m_axis_tvalid\,
      I2 => \m_axis_V_dest_V_1_state[0]_i_2_n_1\,
      I3 => m_axis_V_dest_V_1_ack_in,
      O => \m_axis_V_dest_V_1_state[1]_i_1_n_1\
    );
\m_axis_V_dest_V_1_state_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \m_axis_V_dest_V_1_state[0]_i_1_n_1\,
      Q => \^m_axis_tvalid\,
      R => ap_rst_n_inv
    );
\m_axis_V_dest_V_1_state_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \m_axis_V_dest_V_1_state[1]_i_1_n_1\,
      Q => m_axis_V_dest_V_1_ack_in,
      R => ap_rst_n_inv
    );
\m_axis_V_id_V_1_payload_A[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"EFEE2022"
    )
        port map (
      I0 => tmp_id_V_reg_261,
      I1 => m_axis_V_id_V_1_sel_wr,
      I2 => m_axis_V_id_V_1_ack_in,
      I3 => \m_axis_V_id_V_1_state_reg_n_1_[0]\,
      I4 => m_axis_V_id_V_1_payload_A,
      O => \m_axis_V_id_V_1_payload_A[0]_i_1_n_1\
    );
\m_axis_V_id_V_1_payload_A_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \m_axis_V_id_V_1_payload_A[0]_i_1_n_1\,
      Q => m_axis_V_id_V_1_payload_A,
      R => '0'
    );
\m_axis_V_id_V_1_payload_B[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"BFBB8088"
    )
        port map (
      I0 => tmp_id_V_reg_261,
      I1 => m_axis_V_id_V_1_sel_wr,
      I2 => m_axis_V_id_V_1_ack_in,
      I3 => \m_axis_V_id_V_1_state_reg_n_1_[0]\,
      I4 => m_axis_V_id_V_1_payload_B,
      O => \m_axis_V_id_V_1_payload_B[0]_i_1_n_1\
    );
\m_axis_V_id_V_1_payload_B_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \m_axis_V_id_V_1_payload_B[0]_i_1_n_1\,
      Q => m_axis_V_id_V_1_payload_B,
      R => '0'
    );
m_axis_V_id_V_1_sel_rd_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"78"
    )
        port map (
      I0 => m_axis_TREADY,
      I1 => \m_axis_V_id_V_1_state_reg_n_1_[0]\,
      I2 => m_axis_V_id_V_1_sel,
      O => m_axis_V_id_V_1_sel_rd_i_1_n_1
    );
m_axis_V_id_V_1_sel_rd_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => m_axis_V_id_V_1_sel_rd_i_1_n_1,
      Q => m_axis_V_id_V_1_sel,
      R => ap_rst_n_inv
    );
m_axis_V_id_V_1_sel_wr_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B4"
    )
        port map (
      I0 => \m_axis_V_dest_V_1_state[0]_i_2_n_1\,
      I1 => m_axis_V_id_V_1_ack_in,
      I2 => m_axis_V_id_V_1_sel_wr,
      O => m_axis_V_id_V_1_sel_wr_i_1_n_1
    );
m_axis_V_id_V_1_sel_wr_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => m_axis_V_id_V_1_sel_wr_i_1_n_1,
      Q => m_axis_V_id_V_1_sel_wr,
      R => ap_rst_n_inv
    );
\m_axis_V_id_V_1_state[0]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"5DCC"
    )
        port map (
      I0 => \m_axis_V_dest_V_1_state[0]_i_2_n_1\,
      I1 => \m_axis_V_id_V_1_state_reg_n_1_[0]\,
      I2 => m_axis_TREADY,
      I3 => m_axis_V_id_V_1_ack_in,
      O => \m_axis_V_id_V_1_state[0]_i_1_n_1\
    );
\m_axis_V_id_V_1_state[1]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FBBB"
    )
        port map (
      I0 => m_axis_TREADY,
      I1 => \m_axis_V_id_V_1_state_reg_n_1_[0]\,
      I2 => \m_axis_V_dest_V_1_state[0]_i_2_n_1\,
      I3 => m_axis_V_id_V_1_ack_in,
      O => \m_axis_V_id_V_1_state[1]_i_1_n_1\
    );
\m_axis_V_id_V_1_state_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \m_axis_V_id_V_1_state[0]_i_1_n_1\,
      Q => \m_axis_V_id_V_1_state_reg_n_1_[0]\,
      R => ap_rst_n_inv
    );
\m_axis_V_id_V_1_state_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \m_axis_V_id_V_1_state[1]_i_1_n_1\,
      Q => m_axis_V_id_V_1_ack_in,
      R => ap_rst_n_inv
    );
\m_axis_V_keep_V_1_payload_A[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"EFEE2022"
    )
        port map (
      I0 => tmp_keep_V_reg_241,
      I1 => m_axis_V_keep_V_1_sel_wr,
      I2 => m_axis_V_keep_V_1_ack_in,
      I3 => \m_axis_V_keep_V_1_state_reg_n_1_[0]\,
      I4 => m_axis_V_keep_V_1_payload_A,
      O => \m_axis_V_keep_V_1_payload_A[0]_i_1_n_1\
    );
\m_axis_V_keep_V_1_payload_A_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \m_axis_V_keep_V_1_payload_A[0]_i_1_n_1\,
      Q => m_axis_V_keep_V_1_payload_A,
      R => '0'
    );
\m_axis_V_keep_V_1_payload_B[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"BFBB8088"
    )
        port map (
      I0 => tmp_keep_V_reg_241,
      I1 => m_axis_V_keep_V_1_sel_wr,
      I2 => m_axis_V_keep_V_1_ack_in,
      I3 => \m_axis_V_keep_V_1_state_reg_n_1_[0]\,
      I4 => m_axis_V_keep_V_1_payload_B,
      O => \m_axis_V_keep_V_1_payload_B[0]_i_1_n_1\
    );
\m_axis_V_keep_V_1_payload_B_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \m_axis_V_keep_V_1_payload_B[0]_i_1_n_1\,
      Q => m_axis_V_keep_V_1_payload_B,
      R => '0'
    );
m_axis_V_keep_V_1_sel_rd_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"78"
    )
        port map (
      I0 => \m_axis_V_keep_V_1_state_reg_n_1_[0]\,
      I1 => m_axis_TREADY,
      I2 => m_axis_V_keep_V_1_sel,
      O => m_axis_V_keep_V_1_sel_rd_i_1_n_1
    );
m_axis_V_keep_V_1_sel_rd_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => m_axis_V_keep_V_1_sel_rd_i_1_n_1,
      Q => m_axis_V_keep_V_1_sel,
      R => ap_rst_n_inv
    );
m_axis_V_keep_V_1_sel_wr_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B4"
    )
        port map (
      I0 => \m_axis_V_dest_V_1_state[0]_i_2_n_1\,
      I1 => m_axis_V_keep_V_1_ack_in,
      I2 => m_axis_V_keep_V_1_sel_wr,
      O => m_axis_V_keep_V_1_sel_wr_i_1_n_1
    );
m_axis_V_keep_V_1_sel_wr_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => m_axis_V_keep_V_1_sel_wr_i_1_n_1,
      Q => m_axis_V_keep_V_1_sel_wr,
      R => ap_rst_n_inv
    );
\m_axis_V_keep_V_1_state[0]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"5DCC"
    )
        port map (
      I0 => \m_axis_V_dest_V_1_state[0]_i_2_n_1\,
      I1 => \m_axis_V_keep_V_1_state_reg_n_1_[0]\,
      I2 => m_axis_TREADY,
      I3 => m_axis_V_keep_V_1_ack_in,
      O => \m_axis_V_keep_V_1_state[0]_i_1_n_1\
    );
\m_axis_V_keep_V_1_state[1]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FBBB"
    )
        port map (
      I0 => m_axis_TREADY,
      I1 => \m_axis_V_keep_V_1_state_reg_n_1_[0]\,
      I2 => \m_axis_V_dest_V_1_state[0]_i_2_n_1\,
      I3 => m_axis_V_keep_V_1_ack_in,
      O => \m_axis_V_keep_V_1_state[1]_i_1_n_1\
    );
\m_axis_V_keep_V_1_state_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \m_axis_V_keep_V_1_state[0]_i_1_n_1\,
      Q => \m_axis_V_keep_V_1_state_reg_n_1_[0]\,
      R => ap_rst_n_inv
    );
\m_axis_V_keep_V_1_state_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \m_axis_V_keep_V_1_state[1]_i_1_n_1\,
      Q => m_axis_V_keep_V_1_ack_in,
      R => ap_rst_n_inv
    );
\m_axis_V_last_V_1_payload_A[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"EFEE2022"
    )
        port map (
      I0 => tmp_last_V_reg_256,
      I1 => m_axis_V_last_V_1_sel_wr,
      I2 => m_axis_V_last_V_1_ack_in,
      I3 => \m_axis_V_last_V_1_state_reg_n_1_[0]\,
      I4 => m_axis_V_last_V_1_payload_A,
      O => \m_axis_V_last_V_1_payload_A[0]_i_1_n_1\
    );
\m_axis_V_last_V_1_payload_A_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \m_axis_V_last_V_1_payload_A[0]_i_1_n_1\,
      Q => m_axis_V_last_V_1_payload_A,
      R => '0'
    );
\m_axis_V_last_V_1_payload_B[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"BFBB8088"
    )
        port map (
      I0 => tmp_last_V_reg_256,
      I1 => m_axis_V_last_V_1_sel_wr,
      I2 => m_axis_V_last_V_1_ack_in,
      I3 => \m_axis_V_last_V_1_state_reg_n_1_[0]\,
      I4 => m_axis_V_last_V_1_payload_B,
      O => \m_axis_V_last_V_1_payload_B[0]_i_1_n_1\
    );
\m_axis_V_last_V_1_payload_B_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \m_axis_V_last_V_1_payload_B[0]_i_1_n_1\,
      Q => m_axis_V_last_V_1_payload_B,
      R => '0'
    );
m_axis_V_last_V_1_sel_rd_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"78"
    )
        port map (
      I0 => \m_axis_V_last_V_1_state_reg_n_1_[0]\,
      I1 => m_axis_TREADY,
      I2 => m_axis_V_last_V_1_sel,
      O => m_axis_V_last_V_1_sel_rd_i_1_n_1
    );
m_axis_V_last_V_1_sel_rd_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => m_axis_V_last_V_1_sel_rd_i_1_n_1,
      Q => m_axis_V_last_V_1_sel,
      R => ap_rst_n_inv
    );
m_axis_V_last_V_1_sel_wr_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B4"
    )
        port map (
      I0 => \m_axis_V_dest_V_1_state[0]_i_2_n_1\,
      I1 => m_axis_V_last_V_1_ack_in,
      I2 => m_axis_V_last_V_1_sel_wr,
      O => m_axis_V_last_V_1_sel_wr_i_1_n_1
    );
m_axis_V_last_V_1_sel_wr_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => m_axis_V_last_V_1_sel_wr_i_1_n_1,
      Q => m_axis_V_last_V_1_sel_wr,
      R => ap_rst_n_inv
    );
\m_axis_V_last_V_1_state[0]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2FAA"
    )
        port map (
      I0 => \m_axis_V_last_V_1_state_reg_n_1_[0]\,
      I1 => m_axis_TREADY,
      I2 => \m_axis_V_dest_V_1_state[0]_i_2_n_1\,
      I3 => m_axis_V_last_V_1_ack_in,
      O => \m_axis_V_last_V_1_state[0]_i_1_n_1\
    );
\m_axis_V_last_V_1_state[1]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FBBB"
    )
        port map (
      I0 => m_axis_TREADY,
      I1 => \m_axis_V_last_V_1_state_reg_n_1_[0]\,
      I2 => \m_axis_V_dest_V_1_state[0]_i_2_n_1\,
      I3 => m_axis_V_last_V_1_ack_in,
      O => \m_axis_V_last_V_1_state[1]_i_1_n_1\
    );
\m_axis_V_last_V_1_state_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \m_axis_V_last_V_1_state[0]_i_1_n_1\,
      Q => \m_axis_V_last_V_1_state_reg_n_1_[0]\,
      R => ap_rst_n_inv
    );
\m_axis_V_last_V_1_state_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \m_axis_V_last_V_1_state[1]_i_1_n_1\,
      Q => m_axis_V_last_V_1_ack_in,
      R => ap_rst_n_inv
    );
\m_axis_V_strb_V_1_payload_A[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"EFEE2022"
    )
        port map (
      I0 => tmp_strb_V_reg_246,
      I1 => m_axis_V_strb_V_1_sel_wr,
      I2 => m_axis_V_strb_V_1_ack_in,
      I3 => \m_axis_V_strb_V_1_state_reg_n_1_[0]\,
      I4 => m_axis_V_strb_V_1_payload_A,
      O => \m_axis_V_strb_V_1_payload_A[0]_i_1_n_1\
    );
\m_axis_V_strb_V_1_payload_A_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \m_axis_V_strb_V_1_payload_A[0]_i_1_n_1\,
      Q => m_axis_V_strb_V_1_payload_A,
      R => '0'
    );
\m_axis_V_strb_V_1_payload_B[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"BFBB8088"
    )
        port map (
      I0 => tmp_strb_V_reg_246,
      I1 => m_axis_V_strb_V_1_sel_wr,
      I2 => m_axis_V_strb_V_1_ack_in,
      I3 => \m_axis_V_strb_V_1_state_reg_n_1_[0]\,
      I4 => m_axis_V_strb_V_1_payload_B,
      O => \m_axis_V_strb_V_1_payload_B[0]_i_1_n_1\
    );
\m_axis_V_strb_V_1_payload_B_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \m_axis_V_strb_V_1_payload_B[0]_i_1_n_1\,
      Q => m_axis_V_strb_V_1_payload_B,
      R => '0'
    );
m_axis_V_strb_V_1_sel_rd_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"78"
    )
        port map (
      I0 => \m_axis_V_strb_V_1_state_reg_n_1_[0]\,
      I1 => m_axis_TREADY,
      I2 => m_axis_V_strb_V_1_sel,
      O => m_axis_V_strb_V_1_sel_rd_i_1_n_1
    );
m_axis_V_strb_V_1_sel_rd_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => m_axis_V_strb_V_1_sel_rd_i_1_n_1,
      Q => m_axis_V_strb_V_1_sel,
      R => ap_rst_n_inv
    );
m_axis_V_strb_V_1_sel_wr_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B4"
    )
        port map (
      I0 => \m_axis_V_dest_V_1_state[0]_i_2_n_1\,
      I1 => m_axis_V_strb_V_1_ack_in,
      I2 => m_axis_V_strb_V_1_sel_wr,
      O => m_axis_V_strb_V_1_sel_wr_i_1_n_1
    );
m_axis_V_strb_V_1_sel_wr_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => m_axis_V_strb_V_1_sel_wr_i_1_n_1,
      Q => m_axis_V_strb_V_1_sel_wr,
      R => ap_rst_n_inv
    );
\m_axis_V_strb_V_1_state[0]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2FAA"
    )
        port map (
      I0 => \m_axis_V_strb_V_1_state_reg_n_1_[0]\,
      I1 => m_axis_TREADY,
      I2 => \m_axis_V_dest_V_1_state[0]_i_2_n_1\,
      I3 => m_axis_V_strb_V_1_ack_in,
      O => \m_axis_V_strb_V_1_state[0]_i_1_n_1\
    );
\m_axis_V_strb_V_1_state[1]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FBBB"
    )
        port map (
      I0 => m_axis_TREADY,
      I1 => \m_axis_V_strb_V_1_state_reg_n_1_[0]\,
      I2 => \m_axis_V_dest_V_1_state[0]_i_2_n_1\,
      I3 => m_axis_V_strb_V_1_ack_in,
      O => \m_axis_V_strb_V_1_state[1]_i_1_n_1\
    );
\m_axis_V_strb_V_1_state_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \m_axis_V_strb_V_1_state[0]_i_1_n_1\,
      Q => \m_axis_V_strb_V_1_state_reg_n_1_[0]\,
      R => ap_rst_n_inv
    );
\m_axis_V_strb_V_1_state_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \m_axis_V_strb_V_1_state[1]_i_1_n_1\,
      Q => m_axis_V_strb_V_1_ack_in,
      R => ap_rst_n_inv
    );
\m_axis_V_user_V_1_payload_A[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"EFEE2022"
    )
        port map (
      I0 => tmp_user_V_reg_251,
      I1 => m_axis_V_user_V_1_sel_wr,
      I2 => m_axis_V_user_V_1_ack_in,
      I3 => \m_axis_V_user_V_1_state_reg_n_1_[0]\,
      I4 => m_axis_V_user_V_1_payload_A,
      O => \m_axis_V_user_V_1_payload_A[0]_i_1_n_1\
    );
\m_axis_V_user_V_1_payload_A_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \m_axis_V_user_V_1_payload_A[0]_i_1_n_1\,
      Q => m_axis_V_user_V_1_payload_A,
      R => '0'
    );
\m_axis_V_user_V_1_payload_B[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"BFBB8088"
    )
        port map (
      I0 => tmp_user_V_reg_251,
      I1 => m_axis_V_user_V_1_sel_wr,
      I2 => m_axis_V_user_V_1_ack_in,
      I3 => \m_axis_V_user_V_1_state_reg_n_1_[0]\,
      I4 => m_axis_V_user_V_1_payload_B,
      O => \m_axis_V_user_V_1_payload_B[0]_i_1_n_1\
    );
\m_axis_V_user_V_1_payload_B_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \m_axis_V_user_V_1_payload_B[0]_i_1_n_1\,
      Q => m_axis_V_user_V_1_payload_B,
      R => '0'
    );
m_axis_V_user_V_1_sel_rd_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"78"
    )
        port map (
      I0 => \m_axis_V_user_V_1_state_reg_n_1_[0]\,
      I1 => m_axis_TREADY,
      I2 => m_axis_V_user_V_1_sel,
      O => m_axis_V_user_V_1_sel_rd_i_1_n_1
    );
m_axis_V_user_V_1_sel_rd_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => m_axis_V_user_V_1_sel_rd_i_1_n_1,
      Q => m_axis_V_user_V_1_sel,
      R => ap_rst_n_inv
    );
m_axis_V_user_V_1_sel_wr_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B4"
    )
        port map (
      I0 => \m_axis_V_dest_V_1_state[0]_i_2_n_1\,
      I1 => m_axis_V_user_V_1_ack_in,
      I2 => m_axis_V_user_V_1_sel_wr,
      O => m_axis_V_user_V_1_sel_wr_i_1_n_1
    );
m_axis_V_user_V_1_sel_wr_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => m_axis_V_user_V_1_sel_wr_i_1_n_1,
      Q => m_axis_V_user_V_1_sel_wr,
      R => ap_rst_n_inv
    );
\m_axis_V_user_V_1_state[0]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"5DCC"
    )
        port map (
      I0 => \m_axis_V_dest_V_1_state[0]_i_2_n_1\,
      I1 => \m_axis_V_user_V_1_state_reg_n_1_[0]\,
      I2 => m_axis_TREADY,
      I3 => m_axis_V_user_V_1_ack_in,
      O => \m_axis_V_user_V_1_state[0]_i_1_n_1\
    );
\m_axis_V_user_V_1_state[1]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FBBB"
    )
        port map (
      I0 => m_axis_TREADY,
      I1 => \m_axis_V_user_V_1_state_reg_n_1_[0]\,
      I2 => \m_axis_V_dest_V_1_state[0]_i_2_n_1\,
      I3 => m_axis_V_user_V_1_ack_in,
      O => \m_axis_V_user_V_1_state[1]_i_1_n_1\
    );
\m_axis_V_user_V_1_state_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \m_axis_V_user_V_1_state[0]_i_1_n_1\,
      Q => \m_axis_V_user_V_1_state_reg_n_1_[0]\,
      R => ap_rst_n_inv
    );
\m_axis_V_user_V_1_state_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \m_axis_V_user_V_1_state[1]_i_1_n_1\,
      Q => m_axis_V_user_V_1_ack_in,
      R => ap_rst_n_inv
    );
\pixel_count_read_reg_227_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm1,
      D => pixel_count(0),
      Q => pixel_count_read_reg_227(0),
      R => '0'
    );
\pixel_count_read_reg_227_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm1,
      D => pixel_count(10),
      Q => pixel_count_read_reg_227(10),
      R => '0'
    );
\pixel_count_read_reg_227_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm1,
      D => pixel_count(11),
      Q => pixel_count_read_reg_227(11),
      R => '0'
    );
\pixel_count_read_reg_227_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm1,
      D => pixel_count(12),
      Q => pixel_count_read_reg_227(12),
      R => '0'
    );
\pixel_count_read_reg_227_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm1,
      D => pixel_count(13),
      Q => pixel_count_read_reg_227(13),
      R => '0'
    );
\pixel_count_read_reg_227_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm1,
      D => pixel_count(14),
      Q => pixel_count_read_reg_227(14),
      R => '0'
    );
\pixel_count_read_reg_227_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm1,
      D => pixel_count(15),
      Q => pixel_count_read_reg_227(15),
      R => '0'
    );
\pixel_count_read_reg_227_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm1,
      D => pixel_count(16),
      Q => pixel_count_read_reg_227(16),
      R => '0'
    );
\pixel_count_read_reg_227_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm1,
      D => pixel_count(17),
      Q => pixel_count_read_reg_227(17),
      R => '0'
    );
\pixel_count_read_reg_227_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm1,
      D => pixel_count(18),
      Q => pixel_count_read_reg_227(18),
      R => '0'
    );
\pixel_count_read_reg_227_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm1,
      D => pixel_count(19),
      Q => pixel_count_read_reg_227(19),
      R => '0'
    );
\pixel_count_read_reg_227_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm1,
      D => pixel_count(1),
      Q => pixel_count_read_reg_227(1),
      R => '0'
    );
\pixel_count_read_reg_227_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm1,
      D => pixel_count(20),
      Q => pixel_count_read_reg_227(20),
      R => '0'
    );
\pixel_count_read_reg_227_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm1,
      D => pixel_count(21),
      Q => pixel_count_read_reg_227(21),
      R => '0'
    );
\pixel_count_read_reg_227_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm1,
      D => pixel_count(22),
      Q => pixel_count_read_reg_227(22),
      R => '0'
    );
\pixel_count_read_reg_227_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm1,
      D => pixel_count(23),
      Q => pixel_count_read_reg_227(23),
      R => '0'
    );
\pixel_count_read_reg_227_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm1,
      D => pixel_count(24),
      Q => pixel_count_read_reg_227(24),
      R => '0'
    );
\pixel_count_read_reg_227_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm1,
      D => pixel_count(25),
      Q => pixel_count_read_reg_227(25),
      R => '0'
    );
\pixel_count_read_reg_227_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm1,
      D => pixel_count(26),
      Q => pixel_count_read_reg_227(26),
      R => '0'
    );
\pixel_count_read_reg_227_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm1,
      D => pixel_count(27),
      Q => pixel_count_read_reg_227(27),
      R => '0'
    );
\pixel_count_read_reg_227_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm1,
      D => pixel_count(28),
      Q => pixel_count_read_reg_227(28),
      R => '0'
    );
\pixel_count_read_reg_227_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm1,
      D => pixel_count(29),
      Q => pixel_count_read_reg_227(29),
      R => '0'
    );
\pixel_count_read_reg_227_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm1,
      D => pixel_count(2),
      Q => pixel_count_read_reg_227(2),
      R => '0'
    );
\pixel_count_read_reg_227_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm1,
      D => pixel_count(30),
      Q => pixel_count_read_reg_227(30),
      R => '0'
    );
\pixel_count_read_reg_227_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm1,
      D => pixel_count(31),
      Q => pixel_count_read_reg_227(31),
      R => '0'
    );
\pixel_count_read_reg_227_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm1,
      D => pixel_count(3),
      Q => pixel_count_read_reg_227(3),
      R => '0'
    );
\pixel_count_read_reg_227_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm1,
      D => pixel_count(4),
      Q => pixel_count_read_reg_227(4),
      R => '0'
    );
\pixel_count_read_reg_227_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm1,
      D => pixel_count(5),
      Q => pixel_count_read_reg_227(5),
      R => '0'
    );
\pixel_count_read_reg_227_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm1,
      D => pixel_count(6),
      Q => pixel_count_read_reg_227(6),
      R => '0'
    );
\pixel_count_read_reg_227_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm1,
      D => pixel_count(7),
      Q => pixel_count_read_reg_227(7),
      R => '0'
    );
\pixel_count_read_reg_227_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm1,
      D => pixel_count(8),
      Q => pixel_count_read_reg_227(8),
      R => '0'
    );
\pixel_count_read_reg_227_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm1,
      D => pixel_count(9),
      Q => pixel_count_read_reg_227(9),
      R => '0'
    );
\s_axis_V_data_V_0_payload_A[7]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"45"
    )
        port map (
      I0 => s_axis_V_data_V_0_sel_wr,
      I1 => s_axis_V_data_V_0_ack_in,
      I2 => \s_axis_V_data_V_0_state_reg_n_1_[0]\,
      O => s_axis_V_data_V_0_load_A
    );
\s_axis_V_data_V_0_payload_A_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => s_axis_V_data_V_0_load_A,
      D => s_axis_TDATA(0),
      Q => s_axis_V_data_V_0_payload_A(0),
      R => '0'
    );
\s_axis_V_data_V_0_payload_A_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => s_axis_V_data_V_0_load_A,
      D => s_axis_TDATA(1),
      Q => s_axis_V_data_V_0_payload_A(1),
      R => '0'
    );
\s_axis_V_data_V_0_payload_A_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => s_axis_V_data_V_0_load_A,
      D => s_axis_TDATA(2),
      Q => s_axis_V_data_V_0_payload_A(2),
      R => '0'
    );
\s_axis_V_data_V_0_payload_A_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => s_axis_V_data_V_0_load_A,
      D => s_axis_TDATA(3),
      Q => s_axis_V_data_V_0_payload_A(3),
      R => '0'
    );
\s_axis_V_data_V_0_payload_A_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => s_axis_V_data_V_0_load_A,
      D => s_axis_TDATA(4),
      Q => s_axis_V_data_V_0_payload_A(4),
      R => '0'
    );
\s_axis_V_data_V_0_payload_A_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => s_axis_V_data_V_0_load_A,
      D => s_axis_TDATA(5),
      Q => s_axis_V_data_V_0_payload_A(5),
      R => '0'
    );
\s_axis_V_data_V_0_payload_A_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => s_axis_V_data_V_0_load_A,
      D => s_axis_TDATA(6),
      Q => s_axis_V_data_V_0_payload_A(6),
      R => '0'
    );
\s_axis_V_data_V_0_payload_A_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => s_axis_V_data_V_0_load_A,
      D => s_axis_TDATA(7),
      Q => s_axis_V_data_V_0_payload_A(7),
      R => '0'
    );
\s_axis_V_data_V_0_payload_B[7]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"8A"
    )
        port map (
      I0 => s_axis_V_data_V_0_sel_wr,
      I1 => s_axis_V_data_V_0_ack_in,
      I2 => \s_axis_V_data_V_0_state_reg_n_1_[0]\,
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
s_axis_V_data_V_0_sel_rd_i_1: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \i_0_reg_143[0]_i_2_n_1\,
      I1 => s_axis_V_data_V_0_sel,
      O => s_axis_V_data_V_0_sel_rd_i_1_n_1
    );
s_axis_V_data_V_0_sel_rd_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => s_axis_V_data_V_0_sel_rd_i_1_n_1,
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
      O => s_axis_V_data_V_0_sel_wr_i_1_n_1
    );
s_axis_V_data_V_0_sel_wr_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => s_axis_V_data_V_0_sel_wr_i_1_n_1,
      Q => s_axis_V_data_V_0_sel_wr,
      R => ap_rst_n_inv
    );
\s_axis_V_data_V_0_state[0]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F7C0"
    )
        port map (
      I0 => \i_0_reg_143[0]_i_2_n_1\,
      I1 => s_axis_V_data_V_0_ack_in,
      I2 => s_axis_TVALID,
      I3 => \s_axis_V_data_V_0_state_reg_n_1_[0]\,
      O => \s_axis_V_data_V_0_state[0]_i_1_n_1\
    );
\s_axis_V_data_V_0_state[1]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BBFB"
    )
        port map (
      I0 => \i_0_reg_143[0]_i_2_n_1\,
      I1 => \s_axis_V_data_V_0_state_reg_n_1_[0]\,
      I2 => s_axis_V_data_V_0_ack_in,
      I3 => s_axis_TVALID,
      O => s_axis_V_data_V_0_state(1)
    );
\s_axis_V_data_V_0_state_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \s_axis_V_data_V_0_state[0]_i_1_n_1\,
      Q => \s_axis_V_data_V_0_state_reg_n_1_[0]\,
      R => ap_rst_n_inv
    );
\s_axis_V_data_V_0_state_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => s_axis_V_data_V_0_state(1),
      Q => s_axis_V_data_V_0_ack_in,
      R => ap_rst_n_inv
    );
\s_axis_V_dest_V_0_payload_A[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"EFEE2022"
    )
        port map (
      I0 => s_axis_TDEST(0),
      I1 => s_axis_V_dest_V_0_sel_wr,
      I2 => \^s_axis_tready\,
      I3 => \s_axis_V_dest_V_0_state_reg_n_1_[0]\,
      I4 => s_axis_V_dest_V_0_payload_A,
      O => \s_axis_V_dest_V_0_payload_A[0]_i_1_n_1\
    );
\s_axis_V_dest_V_0_payload_A_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \s_axis_V_dest_V_0_payload_A[0]_i_1_n_1\,
      Q => s_axis_V_dest_V_0_payload_A,
      R => '0'
    );
\s_axis_V_dest_V_0_payload_B[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"BFBB8088"
    )
        port map (
      I0 => s_axis_TDEST(0),
      I1 => s_axis_V_dest_V_0_sel_wr,
      I2 => \^s_axis_tready\,
      I3 => \s_axis_V_dest_V_0_state_reg_n_1_[0]\,
      I4 => s_axis_V_dest_V_0_payload_B,
      O => \s_axis_V_dest_V_0_payload_B[0]_i_1_n_1\
    );
\s_axis_V_dest_V_0_payload_B_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \s_axis_V_dest_V_0_payload_B[0]_i_1_n_1\,
      Q => s_axis_V_dest_V_0_payload_B,
      R => '0'
    );
s_axis_V_dest_V_0_sel_rd_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"78"
    )
        port map (
      I0 => \i_0_reg_143[0]_i_2_n_1\,
      I1 => \s_axis_V_dest_V_0_state_reg_n_1_[0]\,
      I2 => s_axis_V_dest_V_0_sel,
      O => s_axis_V_dest_V_0_sel_rd_i_1_n_1
    );
s_axis_V_dest_V_0_sel_rd_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => s_axis_V_dest_V_0_sel_rd_i_1_n_1,
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
      O => s_axis_V_dest_V_0_sel_wr_i_1_n_1
    );
s_axis_V_dest_V_0_sel_wr_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => s_axis_V_dest_V_0_sel_wr_i_1_n_1,
      Q => s_axis_V_dest_V_0_sel_wr,
      R => ap_rst_n_inv
    );
\s_axis_V_dest_V_0_state[0]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F7C0"
    )
        port map (
      I0 => \i_0_reg_143[0]_i_2_n_1\,
      I1 => \^s_axis_tready\,
      I2 => s_axis_TVALID,
      I3 => \s_axis_V_dest_V_0_state_reg_n_1_[0]\,
      O => \s_axis_V_dest_V_0_state[0]_i_1_n_1\
    );
\s_axis_V_dest_V_0_state[1]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BBFB"
    )
        port map (
      I0 => \i_0_reg_143[0]_i_2_n_1\,
      I1 => \s_axis_V_dest_V_0_state_reg_n_1_[0]\,
      I2 => \^s_axis_tready\,
      I3 => s_axis_TVALID,
      O => s_axis_V_dest_V_0_state(1)
    );
\s_axis_V_dest_V_0_state_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \s_axis_V_dest_V_0_state[0]_i_1_n_1\,
      Q => \s_axis_V_dest_V_0_state_reg_n_1_[0]\,
      R => ap_rst_n_inv
    );
\s_axis_V_dest_V_0_state_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => s_axis_V_dest_V_0_state(1),
      Q => \^s_axis_tready\,
      R => ap_rst_n_inv
    );
\s_axis_V_id_V_0_payload_A[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"EFEE2022"
    )
        port map (
      I0 => s_axis_TID(0),
      I1 => s_axis_V_id_V_0_sel_wr,
      I2 => s_axis_V_id_V_0_ack_in,
      I3 => \s_axis_V_id_V_0_state_reg_n_1_[0]\,
      I4 => s_axis_V_id_V_0_payload_A,
      O => \s_axis_V_id_V_0_payload_A[0]_i_1_n_1\
    );
\s_axis_V_id_V_0_payload_A_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \s_axis_V_id_V_0_payload_A[0]_i_1_n_1\,
      Q => s_axis_V_id_V_0_payload_A,
      R => '0'
    );
\s_axis_V_id_V_0_payload_B[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"BFBB8088"
    )
        port map (
      I0 => s_axis_TID(0),
      I1 => s_axis_V_id_V_0_sel_wr,
      I2 => s_axis_V_id_V_0_ack_in,
      I3 => \s_axis_V_id_V_0_state_reg_n_1_[0]\,
      I4 => s_axis_V_id_V_0_payload_B,
      O => \s_axis_V_id_V_0_payload_B[0]_i_1_n_1\
    );
\s_axis_V_id_V_0_payload_B_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \s_axis_V_id_V_0_payload_B[0]_i_1_n_1\,
      Q => s_axis_V_id_V_0_payload_B,
      R => '0'
    );
s_axis_V_id_V_0_sel_rd_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"78"
    )
        port map (
      I0 => \i_0_reg_143[0]_i_2_n_1\,
      I1 => \s_axis_V_id_V_0_state_reg_n_1_[0]\,
      I2 => s_axis_V_id_V_0_sel,
      O => s_axis_V_id_V_0_sel_rd_i_1_n_1
    );
s_axis_V_id_V_0_sel_rd_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => s_axis_V_id_V_0_sel_rd_i_1_n_1,
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
      O => s_axis_V_id_V_0_sel_wr_i_1_n_1
    );
s_axis_V_id_V_0_sel_wr_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => s_axis_V_id_V_0_sel_wr_i_1_n_1,
      Q => s_axis_V_id_V_0_sel_wr,
      R => ap_rst_n_inv
    );
\s_axis_V_id_V_0_state[0]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F7C0"
    )
        port map (
      I0 => \i_0_reg_143[0]_i_2_n_1\,
      I1 => s_axis_V_id_V_0_ack_in,
      I2 => s_axis_TVALID,
      I3 => \s_axis_V_id_V_0_state_reg_n_1_[0]\,
      O => \s_axis_V_id_V_0_state[0]_i_1_n_1\
    );
\s_axis_V_id_V_0_state[1]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BBFB"
    )
        port map (
      I0 => \i_0_reg_143[0]_i_2_n_1\,
      I1 => \s_axis_V_id_V_0_state_reg_n_1_[0]\,
      I2 => s_axis_V_id_V_0_ack_in,
      I3 => s_axis_TVALID,
      O => s_axis_V_id_V_0_state(1)
    );
\s_axis_V_id_V_0_state_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \s_axis_V_id_V_0_state[0]_i_1_n_1\,
      Q => \s_axis_V_id_V_0_state_reg_n_1_[0]\,
      R => ap_rst_n_inv
    );
\s_axis_V_id_V_0_state_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => s_axis_V_id_V_0_state(1),
      Q => s_axis_V_id_V_0_ack_in,
      R => ap_rst_n_inv
    );
\s_axis_V_keep_V_0_payload_A[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"EFEE2022"
    )
        port map (
      I0 => s_axis_TKEEP(0),
      I1 => s_axis_V_keep_V_0_sel_wr,
      I2 => s_axis_V_keep_V_0_ack_in,
      I3 => \s_axis_V_keep_V_0_state_reg_n_1_[0]\,
      I4 => s_axis_V_keep_V_0_payload_A,
      O => \s_axis_V_keep_V_0_payload_A[0]_i_1_n_1\
    );
\s_axis_V_keep_V_0_payload_A_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \s_axis_V_keep_V_0_payload_A[0]_i_1_n_1\,
      Q => s_axis_V_keep_V_0_payload_A,
      R => '0'
    );
\s_axis_V_keep_V_0_payload_B[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"BFBB8088"
    )
        port map (
      I0 => s_axis_TKEEP(0),
      I1 => s_axis_V_keep_V_0_sel_wr,
      I2 => s_axis_V_keep_V_0_ack_in,
      I3 => \s_axis_V_keep_V_0_state_reg_n_1_[0]\,
      I4 => s_axis_V_keep_V_0_payload_B,
      O => \s_axis_V_keep_V_0_payload_B[0]_i_1_n_1\
    );
\s_axis_V_keep_V_0_payload_B_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \s_axis_V_keep_V_0_payload_B[0]_i_1_n_1\,
      Q => s_axis_V_keep_V_0_payload_B,
      R => '0'
    );
s_axis_V_keep_V_0_sel_rd_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"78"
    )
        port map (
      I0 => \i_0_reg_143[0]_i_2_n_1\,
      I1 => \s_axis_V_keep_V_0_state_reg_n_1_[0]\,
      I2 => s_axis_V_keep_V_0_sel,
      O => s_axis_V_keep_V_0_sel_rd_i_1_n_1
    );
s_axis_V_keep_V_0_sel_rd_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => s_axis_V_keep_V_0_sel_rd_i_1_n_1,
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
      O => s_axis_V_keep_V_0_sel_wr_i_1_n_1
    );
s_axis_V_keep_V_0_sel_wr_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => s_axis_V_keep_V_0_sel_wr_i_1_n_1,
      Q => s_axis_V_keep_V_0_sel_wr,
      R => ap_rst_n_inv
    );
\s_axis_V_keep_V_0_state[0]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F7C0"
    )
        port map (
      I0 => \i_0_reg_143[0]_i_2_n_1\,
      I1 => s_axis_V_keep_V_0_ack_in,
      I2 => s_axis_TVALID,
      I3 => \s_axis_V_keep_V_0_state_reg_n_1_[0]\,
      O => \s_axis_V_keep_V_0_state[0]_i_1_n_1\
    );
\s_axis_V_keep_V_0_state[1]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BBFB"
    )
        port map (
      I0 => \i_0_reg_143[0]_i_2_n_1\,
      I1 => \s_axis_V_keep_V_0_state_reg_n_1_[0]\,
      I2 => s_axis_V_keep_V_0_ack_in,
      I3 => s_axis_TVALID,
      O => s_axis_V_keep_V_0_state(1)
    );
\s_axis_V_keep_V_0_state_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \s_axis_V_keep_V_0_state[0]_i_1_n_1\,
      Q => \s_axis_V_keep_V_0_state_reg_n_1_[0]\,
      R => ap_rst_n_inv
    );
\s_axis_V_keep_V_0_state_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => s_axis_V_keep_V_0_state(1),
      Q => s_axis_V_keep_V_0_ack_in,
      R => ap_rst_n_inv
    );
\s_axis_V_last_V_0_payload_A[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"EFEE2022"
    )
        port map (
      I0 => s_axis_TLAST(0),
      I1 => s_axis_V_last_V_0_sel_wr,
      I2 => s_axis_V_last_V_0_ack_in,
      I3 => \s_axis_V_last_V_0_state_reg_n_1_[0]\,
      I4 => s_axis_V_last_V_0_payload_A,
      O => \s_axis_V_last_V_0_payload_A[0]_i_1_n_1\
    );
\s_axis_V_last_V_0_payload_A_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \s_axis_V_last_V_0_payload_A[0]_i_1_n_1\,
      Q => s_axis_V_last_V_0_payload_A,
      R => '0'
    );
\s_axis_V_last_V_0_payload_B[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"BFBB8088"
    )
        port map (
      I0 => s_axis_TLAST(0),
      I1 => s_axis_V_last_V_0_sel_wr,
      I2 => s_axis_V_last_V_0_ack_in,
      I3 => \s_axis_V_last_V_0_state_reg_n_1_[0]\,
      I4 => s_axis_V_last_V_0_payload_B,
      O => \s_axis_V_last_V_0_payload_B[0]_i_1_n_1\
    );
\s_axis_V_last_V_0_payload_B_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \s_axis_V_last_V_0_payload_B[0]_i_1_n_1\,
      Q => s_axis_V_last_V_0_payload_B,
      R => '0'
    );
s_axis_V_last_V_0_sel_rd_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"78"
    )
        port map (
      I0 => \i_0_reg_143[0]_i_2_n_1\,
      I1 => \s_axis_V_last_V_0_state_reg_n_1_[0]\,
      I2 => s_axis_V_last_V_0_sel,
      O => s_axis_V_last_V_0_sel_rd_i_1_n_1
    );
s_axis_V_last_V_0_sel_rd_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => s_axis_V_last_V_0_sel_rd_i_1_n_1,
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
      O => s_axis_V_last_V_0_sel_wr_i_1_n_1
    );
s_axis_V_last_V_0_sel_wr_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => s_axis_V_last_V_0_sel_wr_i_1_n_1,
      Q => s_axis_V_last_V_0_sel_wr,
      R => ap_rst_n_inv
    );
\s_axis_V_last_V_0_state[0]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F7C0"
    )
        port map (
      I0 => \i_0_reg_143[0]_i_2_n_1\,
      I1 => s_axis_V_last_V_0_ack_in,
      I2 => s_axis_TVALID,
      I3 => \s_axis_V_last_V_0_state_reg_n_1_[0]\,
      O => \s_axis_V_last_V_0_state[0]_i_1_n_1\
    );
\s_axis_V_last_V_0_state[1]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BBFB"
    )
        port map (
      I0 => \i_0_reg_143[0]_i_2_n_1\,
      I1 => \s_axis_V_last_V_0_state_reg_n_1_[0]\,
      I2 => s_axis_V_last_V_0_ack_in,
      I3 => s_axis_TVALID,
      O => s_axis_V_last_V_0_state(1)
    );
\s_axis_V_last_V_0_state_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \s_axis_V_last_V_0_state[0]_i_1_n_1\,
      Q => \s_axis_V_last_V_0_state_reg_n_1_[0]\,
      R => ap_rst_n_inv
    );
\s_axis_V_last_V_0_state_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => s_axis_V_last_V_0_state(1),
      Q => s_axis_V_last_V_0_ack_in,
      R => ap_rst_n_inv
    );
\s_axis_V_strb_V_0_payload_A[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"EFEE2022"
    )
        port map (
      I0 => s_axis_TSTRB(0),
      I1 => s_axis_V_strb_V_0_sel_wr,
      I2 => s_axis_V_strb_V_0_ack_in,
      I3 => \s_axis_V_strb_V_0_state_reg_n_1_[0]\,
      I4 => s_axis_V_strb_V_0_payload_A,
      O => \s_axis_V_strb_V_0_payload_A[0]_i_1_n_1\
    );
\s_axis_V_strb_V_0_payload_A_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \s_axis_V_strb_V_0_payload_A[0]_i_1_n_1\,
      Q => s_axis_V_strb_V_0_payload_A,
      R => '0'
    );
\s_axis_V_strb_V_0_payload_B[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"BFBB8088"
    )
        port map (
      I0 => s_axis_TSTRB(0),
      I1 => s_axis_V_strb_V_0_sel_wr,
      I2 => s_axis_V_strb_V_0_ack_in,
      I3 => \s_axis_V_strb_V_0_state_reg_n_1_[0]\,
      I4 => s_axis_V_strb_V_0_payload_B,
      O => \s_axis_V_strb_V_0_payload_B[0]_i_1_n_1\
    );
\s_axis_V_strb_V_0_payload_B_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \s_axis_V_strb_V_0_payload_B[0]_i_1_n_1\,
      Q => s_axis_V_strb_V_0_payload_B,
      R => '0'
    );
s_axis_V_strb_V_0_sel_rd_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"78"
    )
        port map (
      I0 => \i_0_reg_143[0]_i_2_n_1\,
      I1 => \s_axis_V_strb_V_0_state_reg_n_1_[0]\,
      I2 => s_axis_V_strb_V_0_sel,
      O => s_axis_V_strb_V_0_sel_rd_i_1_n_1
    );
s_axis_V_strb_V_0_sel_rd_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => s_axis_V_strb_V_0_sel_rd_i_1_n_1,
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
      O => s_axis_V_strb_V_0_sel_wr_i_1_n_1
    );
s_axis_V_strb_V_0_sel_wr_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => s_axis_V_strb_V_0_sel_wr_i_1_n_1,
      Q => s_axis_V_strb_V_0_sel_wr,
      R => ap_rst_n_inv
    );
\s_axis_V_strb_V_0_state[0]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F7C0"
    )
        port map (
      I0 => \i_0_reg_143[0]_i_2_n_1\,
      I1 => s_axis_V_strb_V_0_ack_in,
      I2 => s_axis_TVALID,
      I3 => \s_axis_V_strb_V_0_state_reg_n_1_[0]\,
      O => \s_axis_V_strb_V_0_state[0]_i_1_n_1\
    );
\s_axis_V_strb_V_0_state[1]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BBFB"
    )
        port map (
      I0 => \i_0_reg_143[0]_i_2_n_1\,
      I1 => \s_axis_V_strb_V_0_state_reg_n_1_[0]\,
      I2 => s_axis_V_strb_V_0_ack_in,
      I3 => s_axis_TVALID,
      O => s_axis_V_strb_V_0_state(1)
    );
\s_axis_V_strb_V_0_state_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \s_axis_V_strb_V_0_state[0]_i_1_n_1\,
      Q => \s_axis_V_strb_V_0_state_reg_n_1_[0]\,
      R => ap_rst_n_inv
    );
\s_axis_V_strb_V_0_state_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => s_axis_V_strb_V_0_state(1),
      Q => s_axis_V_strb_V_0_ack_in,
      R => ap_rst_n_inv
    );
\s_axis_V_user_V_0_payload_A[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"EFEE2022"
    )
        port map (
      I0 => s_axis_TUSER(0),
      I1 => s_axis_V_user_V_0_sel_wr,
      I2 => s_axis_V_user_V_0_ack_in,
      I3 => \s_axis_V_user_V_0_state_reg_n_1_[0]\,
      I4 => s_axis_V_user_V_0_payload_A,
      O => \s_axis_V_user_V_0_payload_A[0]_i_1_n_1\
    );
\s_axis_V_user_V_0_payload_A_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \s_axis_V_user_V_0_payload_A[0]_i_1_n_1\,
      Q => s_axis_V_user_V_0_payload_A,
      R => '0'
    );
\s_axis_V_user_V_0_payload_B[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"BFBB8088"
    )
        port map (
      I0 => s_axis_TUSER(0),
      I1 => s_axis_V_user_V_0_sel_wr,
      I2 => s_axis_V_user_V_0_ack_in,
      I3 => \s_axis_V_user_V_0_state_reg_n_1_[0]\,
      I4 => s_axis_V_user_V_0_payload_B,
      O => \s_axis_V_user_V_0_payload_B[0]_i_1_n_1\
    );
\s_axis_V_user_V_0_payload_B_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \s_axis_V_user_V_0_payload_B[0]_i_1_n_1\,
      Q => s_axis_V_user_V_0_payload_B,
      R => '0'
    );
s_axis_V_user_V_0_sel_rd_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"78"
    )
        port map (
      I0 => \i_0_reg_143[0]_i_2_n_1\,
      I1 => \s_axis_V_user_V_0_state_reg_n_1_[0]\,
      I2 => s_axis_V_user_V_0_sel,
      O => s_axis_V_user_V_0_sel_rd_i_1_n_1
    );
s_axis_V_user_V_0_sel_rd_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => s_axis_V_user_V_0_sel_rd_i_1_n_1,
      Q => s_axis_V_user_V_0_sel,
      R => ap_rst_n_inv
    );
s_axis_V_user_V_0_sel_wr_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"78"
    )
        port map (
      I0 => s_axis_TVALID,
      I1 => s_axis_V_user_V_0_ack_in,
      I2 => s_axis_V_user_V_0_sel_wr,
      O => s_axis_V_user_V_0_sel_wr_i_1_n_1
    );
s_axis_V_user_V_0_sel_wr_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => s_axis_V_user_V_0_sel_wr_i_1_n_1,
      Q => s_axis_V_user_V_0_sel_wr,
      R => ap_rst_n_inv
    );
\s_axis_V_user_V_0_state[0]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F7C0"
    )
        port map (
      I0 => \i_0_reg_143[0]_i_2_n_1\,
      I1 => s_axis_V_user_V_0_ack_in,
      I2 => s_axis_TVALID,
      I3 => \s_axis_V_user_V_0_state_reg_n_1_[0]\,
      O => \s_axis_V_user_V_0_state[0]_i_1_n_1\
    );
\s_axis_V_user_V_0_state[1]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BBFB"
    )
        port map (
      I0 => \i_0_reg_143[0]_i_2_n_1\,
      I1 => \s_axis_V_user_V_0_state_reg_n_1_[0]\,
      I2 => s_axis_V_user_V_0_ack_in,
      I3 => s_axis_TVALID,
      O => s_axis_V_user_V_0_state(1)
    );
\s_axis_V_user_V_0_state_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \s_axis_V_user_V_0_state[0]_i_1_n_1\,
      Q => \s_axis_V_user_V_0_state_reg_n_1_[0]\,
      R => ap_rst_n_inv
    );
\s_axis_V_user_V_0_state_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => s_axis_V_user_V_0_state(1),
      Q => s_axis_V_user_V_0_ack_in,
      R => ap_rst_n_inv
    );
\threshold_V_read_reg_222_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm1,
      D => threshold_V(0),
      Q => threshold_V_read_reg_222(0),
      R => '0'
    );
\threshold_V_read_reg_222_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm1,
      D => threshold_V(1),
      Q => threshold_V_read_reg_222(1),
      R => '0'
    );
\threshold_V_read_reg_222_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm1,
      D => threshold_V(2),
      Q => threshold_V_read_reg_222(2),
      R => '0'
    );
\threshold_V_read_reg_222_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm1,
      D => threshold_V(3),
      Q => threshold_V_read_reg_222(3),
      R => '0'
    );
\threshold_V_read_reg_222_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm1,
      D => threshold_V(4),
      Q => threshold_V_read_reg_222(4),
      R => '0'
    );
\threshold_V_read_reg_222_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm1,
      D => threshold_V(5),
      Q => threshold_V_read_reg_222(5),
      R => '0'
    );
\threshold_V_read_reg_222_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm1,
      D => threshold_V(6),
      Q => threshold_V_read_reg_222(6),
      R => '0'
    );
\threshold_V_read_reg_222_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm1,
      D => threshold_V(7),
      Q => threshold_V_read_reg_222(7),
      R => '0'
    );
\threshold_enable_rea_reg_217_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm1,
      D => threshold_enable,
      Q => threshold_enable_rea_reg_217,
      R => '0'
    );
\tmp_data_V_2_reg_271[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"DDD88D88"
    )
        port map (
      I0 => threshold_enable_rea_reg_217,
      I1 => tmp_data_V_1_fu_202_p3,
      I2 => s_axis_V_data_V_0_sel,
      I3 => s_axis_V_data_V_0_payload_A(0),
      I4 => s_axis_V_data_V_0_payload_B(0),
      O => \tmp_data_V_2_reg_271[0]_i_1_n_1\
    );
\tmp_data_V_2_reg_271[1]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"DDD88D88"
    )
        port map (
      I0 => threshold_enable_rea_reg_217,
      I1 => tmp_data_V_1_fu_202_p3,
      I2 => s_axis_V_data_V_0_sel,
      I3 => s_axis_V_data_V_0_payload_A(1),
      I4 => s_axis_V_data_V_0_payload_B(1),
      O => \tmp_data_V_2_reg_271[1]_i_1_n_1\
    );
\tmp_data_V_2_reg_271[2]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"DDD88D88"
    )
        port map (
      I0 => threshold_enable_rea_reg_217,
      I1 => tmp_data_V_1_fu_202_p3,
      I2 => s_axis_V_data_V_0_sel,
      I3 => s_axis_V_data_V_0_payload_A(2),
      I4 => s_axis_V_data_V_0_payload_B(2),
      O => \tmp_data_V_2_reg_271[2]_i_1_n_1\
    );
\tmp_data_V_2_reg_271[3]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"DDD88D88"
    )
        port map (
      I0 => threshold_enable_rea_reg_217,
      I1 => tmp_data_V_1_fu_202_p3,
      I2 => s_axis_V_data_V_0_sel,
      I3 => s_axis_V_data_V_0_payload_A(3),
      I4 => s_axis_V_data_V_0_payload_B(3),
      O => \tmp_data_V_2_reg_271[3]_i_1_n_1\
    );
\tmp_data_V_2_reg_271[4]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"DDD88D88"
    )
        port map (
      I0 => threshold_enable_rea_reg_217,
      I1 => tmp_data_V_1_fu_202_p3,
      I2 => s_axis_V_data_V_0_sel,
      I3 => s_axis_V_data_V_0_payload_A(4),
      I4 => s_axis_V_data_V_0_payload_B(4),
      O => \tmp_data_V_2_reg_271[4]_i_1_n_1\
    );
\tmp_data_V_2_reg_271[5]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"DDD88D88"
    )
        port map (
      I0 => threshold_enable_rea_reg_217,
      I1 => tmp_data_V_1_fu_202_p3,
      I2 => s_axis_V_data_V_0_sel,
      I3 => s_axis_V_data_V_0_payload_A(5),
      I4 => s_axis_V_data_V_0_payload_B(5),
      O => \tmp_data_V_2_reg_271[5]_i_1_n_1\
    );
\tmp_data_V_2_reg_271[6]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"DDD88D88"
    )
        port map (
      I0 => threshold_enable_rea_reg_217,
      I1 => tmp_data_V_1_fu_202_p3,
      I2 => s_axis_V_data_V_0_sel,
      I3 => s_axis_V_data_V_0_payload_A(6),
      I4 => s_axis_V_data_V_0_payload_B(6),
      O => \tmp_data_V_2_reg_271[6]_i_1_n_1\
    );
\tmp_data_V_2_reg_271[7]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"45000000"
    )
        port map (
      I0 => \tmp_data_V_2_reg_271[7]_i_3_n_1\,
      I1 => \s_axis_V_data_V_0_state_reg_n_1_[0]\,
      I2 => ap_enable_reg_pp0_iter0,
      I3 => ap_CS_fsm_pp0_stage0,
      I4 => icmp_ln17_fu_158_p2,
      O => tmp_data_V_2_reg_2710
    );
\tmp_data_V_2_reg_271[7]_i_10\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2F02"
    )
        port map (
      I0 => pixel_count_read_reg_227(24),
      I1 => i_0_reg_143_reg(24),
      I2 => i_0_reg_143_reg(25),
      I3 => pixel_count_read_reg_227(25),
      O => \tmp_data_V_2_reg_271[7]_i_10_n_1\
    );
\tmp_data_V_2_reg_271[7]_i_11\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"21"
    )
        port map (
      I0 => i_0_reg_143_reg(30),
      I1 => pixel_count_read_reg_227(31),
      I2 => pixel_count_read_reg_227(30),
      O => \tmp_data_V_2_reg_271[7]_i_11_n_1\
    );
\tmp_data_V_2_reg_271[7]_i_12\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => i_0_reg_143_reg(28),
      I1 => pixel_count_read_reg_227(28),
      I2 => i_0_reg_143_reg(29),
      I3 => pixel_count_read_reg_227(29),
      O => \tmp_data_V_2_reg_271[7]_i_12_n_1\
    );
\tmp_data_V_2_reg_271[7]_i_13\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => i_0_reg_143_reg(26),
      I1 => pixel_count_read_reg_227(26),
      I2 => i_0_reg_143_reg(27),
      I3 => pixel_count_read_reg_227(27),
      O => \tmp_data_V_2_reg_271[7]_i_13_n_1\
    );
\tmp_data_V_2_reg_271[7]_i_14\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => i_0_reg_143_reg(24),
      I1 => pixel_count_read_reg_227(24),
      I2 => i_0_reg_143_reg(25),
      I3 => pixel_count_read_reg_227(25),
      O => \tmp_data_V_2_reg_271[7]_i_14_n_1\
    );
\tmp_data_V_2_reg_271[7]_i_15\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00E4FFFF000000E4"
    )
        port map (
      I0 => s_axis_V_data_V_0_sel,
      I1 => s_axis_V_data_V_0_payload_A(6),
      I2 => s_axis_V_data_V_0_payload_B(6),
      I3 => threshold_V_read_reg_222(6),
      I4 => threshold_V_read_reg_222(7),
      I5 => s_axis_V_data_V_0_data_out(7),
      O => \tmp_data_V_2_reg_271[7]_i_15_n_1\
    );
\tmp_data_V_2_reg_271[7]_i_16\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00E4FFFF000000E4"
    )
        port map (
      I0 => s_axis_V_data_V_0_sel,
      I1 => s_axis_V_data_V_0_payload_A(4),
      I2 => s_axis_V_data_V_0_payload_B(4),
      I3 => threshold_V_read_reg_222(4),
      I4 => threshold_V_read_reg_222(5),
      I5 => s_axis_V_data_V_0_data_out(5),
      O => \tmp_data_V_2_reg_271[7]_i_16_n_1\
    );
\tmp_data_V_2_reg_271[7]_i_17\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00E4FFFF000000E4"
    )
        port map (
      I0 => s_axis_V_data_V_0_sel,
      I1 => s_axis_V_data_V_0_payload_A(2),
      I2 => s_axis_V_data_V_0_payload_B(2),
      I3 => threshold_V_read_reg_222(2),
      I4 => threshold_V_read_reg_222(3),
      I5 => s_axis_V_data_V_0_data_out(3),
      O => \tmp_data_V_2_reg_271[7]_i_17_n_1\
    );
\tmp_data_V_2_reg_271[7]_i_18\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00E4FFFF000000E4"
    )
        port map (
      I0 => s_axis_V_data_V_0_sel,
      I1 => s_axis_V_data_V_0_payload_A(0),
      I2 => s_axis_V_data_V_0_payload_B(0),
      I3 => threshold_V_read_reg_222(0),
      I4 => threshold_V_read_reg_222(1),
      I5 => s_axis_V_data_V_0_data_out(1),
      O => \tmp_data_V_2_reg_271[7]_i_18_n_1\
    );
\tmp_data_V_2_reg_271[7]_i_19\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AC5300000000AC53"
    )
        port map (
      I0 => s_axis_V_data_V_0_payload_B(6),
      I1 => s_axis_V_data_V_0_payload_A(6),
      I2 => s_axis_V_data_V_0_sel,
      I3 => threshold_V_read_reg_222(6),
      I4 => s_axis_V_data_V_0_data_out(7),
      I5 => threshold_V_read_reg_222(7),
      O => \tmp_data_V_2_reg_271[7]_i_19_n_1\
    );
\tmp_data_V_2_reg_271[7]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"DDD88D88"
    )
        port map (
      I0 => threshold_enable_rea_reg_217,
      I1 => tmp_data_V_1_fu_202_p3,
      I2 => s_axis_V_data_V_0_sel,
      I3 => s_axis_V_data_V_0_payload_A(7),
      I4 => s_axis_V_data_V_0_payload_B(7),
      O => \tmp_data_V_2_reg_271[7]_i_2_n_1\
    );
\tmp_data_V_2_reg_271[7]_i_20\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AC5300000000AC53"
    )
        port map (
      I0 => s_axis_V_data_V_0_payload_B(4),
      I1 => s_axis_V_data_V_0_payload_A(4),
      I2 => s_axis_V_data_V_0_sel,
      I3 => threshold_V_read_reg_222(4),
      I4 => s_axis_V_data_V_0_data_out(5),
      I5 => threshold_V_read_reg_222(5),
      O => \tmp_data_V_2_reg_271[7]_i_20_n_1\
    );
\tmp_data_V_2_reg_271[7]_i_21\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AC5300000000AC53"
    )
        port map (
      I0 => s_axis_V_data_V_0_payload_B(2),
      I1 => s_axis_V_data_V_0_payload_A(2),
      I2 => s_axis_V_data_V_0_sel,
      I3 => threshold_V_read_reg_222(2),
      I4 => s_axis_V_data_V_0_data_out(3),
      I5 => threshold_V_read_reg_222(3),
      O => \tmp_data_V_2_reg_271[7]_i_21_n_1\
    );
\tmp_data_V_2_reg_271[7]_i_22\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AC5300000000AC53"
    )
        port map (
      I0 => s_axis_V_data_V_0_payload_B(0),
      I1 => s_axis_V_data_V_0_payload_A(0),
      I2 => s_axis_V_data_V_0_sel,
      I3 => threshold_V_read_reg_222(0),
      I4 => s_axis_V_data_V_0_data_out(1),
      I5 => threshold_V_read_reg_222(1),
      O => \tmp_data_V_2_reg_271[7]_i_22_n_1\
    );
\tmp_data_V_2_reg_271[7]_i_24\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2F02"
    )
        port map (
      I0 => pixel_count_read_reg_227(22),
      I1 => i_0_reg_143_reg(22),
      I2 => i_0_reg_143_reg(23),
      I3 => pixel_count_read_reg_227(23),
      O => \tmp_data_V_2_reg_271[7]_i_24_n_1\
    );
\tmp_data_V_2_reg_271[7]_i_25\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2F02"
    )
        port map (
      I0 => pixel_count_read_reg_227(20),
      I1 => i_0_reg_143_reg(20),
      I2 => i_0_reg_143_reg(21),
      I3 => pixel_count_read_reg_227(21),
      O => \tmp_data_V_2_reg_271[7]_i_25_n_1\
    );
\tmp_data_V_2_reg_271[7]_i_26\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2F02"
    )
        port map (
      I0 => pixel_count_read_reg_227(18),
      I1 => i_0_reg_143_reg(18),
      I2 => i_0_reg_143_reg(19),
      I3 => pixel_count_read_reg_227(19),
      O => \tmp_data_V_2_reg_271[7]_i_26_n_1\
    );
\tmp_data_V_2_reg_271[7]_i_27\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2F02"
    )
        port map (
      I0 => pixel_count_read_reg_227(16),
      I1 => i_0_reg_143_reg(16),
      I2 => i_0_reg_143_reg(17),
      I3 => pixel_count_read_reg_227(17),
      O => \tmp_data_V_2_reg_271[7]_i_27_n_1\
    );
\tmp_data_V_2_reg_271[7]_i_28\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => i_0_reg_143_reg(22),
      I1 => pixel_count_read_reg_227(22),
      I2 => i_0_reg_143_reg(23),
      I3 => pixel_count_read_reg_227(23),
      O => \tmp_data_V_2_reg_271[7]_i_28_n_1\
    );
\tmp_data_V_2_reg_271[7]_i_29\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => i_0_reg_143_reg(20),
      I1 => pixel_count_read_reg_227(20),
      I2 => i_0_reg_143_reg(21),
      I3 => pixel_count_read_reg_227(21),
      O => \tmp_data_V_2_reg_271[7]_i_29_n_1\
    );
\tmp_data_V_2_reg_271[7]_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0000F888"
    )
        port map (
      I0 => icmp_ln17_reg_232,
      I1 => ap_enable_reg_pp0_iter1_reg_n_1,
      I2 => ap_enable_reg_pp0_iter2_reg_n_1,
      I3 => icmp_ln17_reg_232_pp0_iter1_reg,
      I4 => m_axis_V_data_V_1_ack_in,
      O => \tmp_data_V_2_reg_271[7]_i_3_n_1\
    );
\tmp_data_V_2_reg_271[7]_i_30\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => i_0_reg_143_reg(18),
      I1 => pixel_count_read_reg_227(18),
      I2 => i_0_reg_143_reg(19),
      I3 => pixel_count_read_reg_227(19),
      O => \tmp_data_V_2_reg_271[7]_i_30_n_1\
    );
\tmp_data_V_2_reg_271[7]_i_31\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => i_0_reg_143_reg(16),
      I1 => pixel_count_read_reg_227(16),
      I2 => i_0_reg_143_reg(17),
      I3 => pixel_count_read_reg_227(17),
      O => \tmp_data_V_2_reg_271[7]_i_31_n_1\
    );
\tmp_data_V_2_reg_271[7]_i_32\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => s_axis_V_data_V_0_payload_B(7),
      I1 => s_axis_V_data_V_0_payload_A(7),
      I2 => s_axis_V_data_V_0_sel,
      O => s_axis_V_data_V_0_data_out(7)
    );
\tmp_data_V_2_reg_271[7]_i_33\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => s_axis_V_data_V_0_payload_B(5),
      I1 => s_axis_V_data_V_0_payload_A(5),
      I2 => s_axis_V_data_V_0_sel,
      O => s_axis_V_data_V_0_data_out(5)
    );
\tmp_data_V_2_reg_271[7]_i_34\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => s_axis_V_data_V_0_payload_B(3),
      I1 => s_axis_V_data_V_0_payload_A(3),
      I2 => s_axis_V_data_V_0_sel,
      O => s_axis_V_data_V_0_data_out(3)
    );
\tmp_data_V_2_reg_271[7]_i_35\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => s_axis_V_data_V_0_payload_B(1),
      I1 => s_axis_V_data_V_0_payload_A(1),
      I2 => s_axis_V_data_V_0_sel,
      O => s_axis_V_data_V_0_data_out(1)
    );
\tmp_data_V_2_reg_271[7]_i_37\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2F02"
    )
        port map (
      I0 => pixel_count_read_reg_227(14),
      I1 => i_0_reg_143_reg(14),
      I2 => i_0_reg_143_reg(15),
      I3 => pixel_count_read_reg_227(15),
      O => \tmp_data_V_2_reg_271[7]_i_37_n_1\
    );
\tmp_data_V_2_reg_271[7]_i_38\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2F02"
    )
        port map (
      I0 => pixel_count_read_reg_227(12),
      I1 => i_0_reg_143_reg(12),
      I2 => i_0_reg_143_reg(13),
      I3 => pixel_count_read_reg_227(13),
      O => \tmp_data_V_2_reg_271[7]_i_38_n_1\
    );
\tmp_data_V_2_reg_271[7]_i_39\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2F02"
    )
        port map (
      I0 => pixel_count_read_reg_227(10),
      I1 => i_0_reg_143_reg(10),
      I2 => i_0_reg_143_reg(11),
      I3 => pixel_count_read_reg_227(11),
      O => \tmp_data_V_2_reg_271[7]_i_39_n_1\
    );
\tmp_data_V_2_reg_271[7]_i_40\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2F02"
    )
        port map (
      I0 => pixel_count_read_reg_227(8),
      I1 => i_0_reg_143_reg(8),
      I2 => i_0_reg_143_reg(9),
      I3 => pixel_count_read_reg_227(9),
      O => \tmp_data_V_2_reg_271[7]_i_40_n_1\
    );
\tmp_data_V_2_reg_271[7]_i_41\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => i_0_reg_143_reg(14),
      I1 => pixel_count_read_reg_227(14),
      I2 => i_0_reg_143_reg(15),
      I3 => pixel_count_read_reg_227(15),
      O => \tmp_data_V_2_reg_271[7]_i_41_n_1\
    );
\tmp_data_V_2_reg_271[7]_i_42\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => i_0_reg_143_reg(12),
      I1 => pixel_count_read_reg_227(12),
      I2 => i_0_reg_143_reg(13),
      I3 => pixel_count_read_reg_227(13),
      O => \tmp_data_V_2_reg_271[7]_i_42_n_1\
    );
\tmp_data_V_2_reg_271[7]_i_43\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => i_0_reg_143_reg(10),
      I1 => pixel_count_read_reg_227(10),
      I2 => i_0_reg_143_reg(11),
      I3 => pixel_count_read_reg_227(11),
      O => \tmp_data_V_2_reg_271[7]_i_43_n_1\
    );
\tmp_data_V_2_reg_271[7]_i_44\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => i_0_reg_143_reg(8),
      I1 => pixel_count_read_reg_227(8),
      I2 => i_0_reg_143_reg(9),
      I3 => pixel_count_read_reg_227(9),
      O => \tmp_data_V_2_reg_271[7]_i_44_n_1\
    );
\tmp_data_V_2_reg_271[7]_i_45\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2F02"
    )
        port map (
      I0 => pixel_count_read_reg_227(6),
      I1 => i_0_reg_143_reg(6),
      I2 => i_0_reg_143_reg(7),
      I3 => pixel_count_read_reg_227(7),
      O => \tmp_data_V_2_reg_271[7]_i_45_n_1\
    );
\tmp_data_V_2_reg_271[7]_i_46\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2F02"
    )
        port map (
      I0 => pixel_count_read_reg_227(4),
      I1 => i_0_reg_143_reg(4),
      I2 => i_0_reg_143_reg(5),
      I3 => pixel_count_read_reg_227(5),
      O => \tmp_data_V_2_reg_271[7]_i_46_n_1\
    );
\tmp_data_V_2_reg_271[7]_i_47\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2F02"
    )
        port map (
      I0 => pixel_count_read_reg_227(2),
      I1 => i_0_reg_143_reg(2),
      I2 => i_0_reg_143_reg(3),
      I3 => pixel_count_read_reg_227(3),
      O => \tmp_data_V_2_reg_271[7]_i_47_n_1\
    );
\tmp_data_V_2_reg_271[7]_i_48\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2F02"
    )
        port map (
      I0 => pixel_count_read_reg_227(0),
      I1 => i_0_reg_143_reg(0),
      I2 => i_0_reg_143_reg(1),
      I3 => pixel_count_read_reg_227(1),
      O => \tmp_data_V_2_reg_271[7]_i_48_n_1\
    );
\tmp_data_V_2_reg_271[7]_i_49\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => i_0_reg_143_reg(6),
      I1 => pixel_count_read_reg_227(6),
      I2 => i_0_reg_143_reg(7),
      I3 => pixel_count_read_reg_227(7),
      O => \tmp_data_V_2_reg_271[7]_i_49_n_1\
    );
\tmp_data_V_2_reg_271[7]_i_50\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => i_0_reg_143_reg(4),
      I1 => pixel_count_read_reg_227(4),
      I2 => i_0_reg_143_reg(5),
      I3 => pixel_count_read_reg_227(5),
      O => \tmp_data_V_2_reg_271[7]_i_50_n_1\
    );
\tmp_data_V_2_reg_271[7]_i_51\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => i_0_reg_143_reg(2),
      I1 => pixel_count_read_reg_227(2),
      I2 => i_0_reg_143_reg(3),
      I3 => pixel_count_read_reg_227(3),
      O => \tmp_data_V_2_reg_271[7]_i_51_n_1\
    );
\tmp_data_V_2_reg_271[7]_i_52\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => i_0_reg_143_reg(0),
      I1 => pixel_count_read_reg_227(0),
      I2 => i_0_reg_143_reg(1),
      I3 => pixel_count_read_reg_227(1),
      O => \tmp_data_V_2_reg_271[7]_i_52_n_1\
    );
\tmp_data_V_2_reg_271[7]_i_7\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"04"
    )
        port map (
      I0 => pixel_count_read_reg_227(31),
      I1 => pixel_count_read_reg_227(30),
      I2 => i_0_reg_143_reg(30),
      O => \tmp_data_V_2_reg_271[7]_i_7_n_1\
    );
\tmp_data_V_2_reg_271[7]_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2F02"
    )
        port map (
      I0 => pixel_count_read_reg_227(28),
      I1 => i_0_reg_143_reg(28),
      I2 => i_0_reg_143_reg(29),
      I3 => pixel_count_read_reg_227(29),
      O => \tmp_data_V_2_reg_271[7]_i_8_n_1\
    );
\tmp_data_V_2_reg_271[7]_i_9\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2F02"
    )
        port map (
      I0 => pixel_count_read_reg_227(26),
      I1 => i_0_reg_143_reg(26),
      I2 => i_0_reg_143_reg(27),
      I3 => pixel_count_read_reg_227(27),
      O => \tmp_data_V_2_reg_271[7]_i_9_n_1\
    );
\tmp_data_V_2_reg_271_reg[0]\: unisim.vcomponents.FDSE
     port map (
      C => ap_clk,
      CE => tmp_data_V_2_reg_2710,
      D => \tmp_data_V_2_reg_271[0]_i_1_n_1\,
      Q => tmp_data_V_2_reg_271(0),
      S => '0'
    );
\tmp_data_V_2_reg_271_reg[1]\: unisim.vcomponents.FDSE
     port map (
      C => ap_clk,
      CE => tmp_data_V_2_reg_2710,
      D => \tmp_data_V_2_reg_271[1]_i_1_n_1\,
      Q => tmp_data_V_2_reg_271(1),
      S => '0'
    );
\tmp_data_V_2_reg_271_reg[2]\: unisim.vcomponents.FDSE
     port map (
      C => ap_clk,
      CE => tmp_data_V_2_reg_2710,
      D => \tmp_data_V_2_reg_271[2]_i_1_n_1\,
      Q => tmp_data_V_2_reg_271(2),
      S => '0'
    );
\tmp_data_V_2_reg_271_reg[3]\: unisim.vcomponents.FDSE
     port map (
      C => ap_clk,
      CE => tmp_data_V_2_reg_2710,
      D => \tmp_data_V_2_reg_271[3]_i_1_n_1\,
      Q => tmp_data_V_2_reg_271(3),
      S => '0'
    );
\tmp_data_V_2_reg_271_reg[4]\: unisim.vcomponents.FDSE
     port map (
      C => ap_clk,
      CE => tmp_data_V_2_reg_2710,
      D => \tmp_data_V_2_reg_271[4]_i_1_n_1\,
      Q => tmp_data_V_2_reg_271(4),
      S => '0'
    );
\tmp_data_V_2_reg_271_reg[5]\: unisim.vcomponents.FDSE
     port map (
      C => ap_clk,
      CE => tmp_data_V_2_reg_2710,
      D => \tmp_data_V_2_reg_271[5]_i_1_n_1\,
      Q => tmp_data_V_2_reg_271(5),
      S => '0'
    );
\tmp_data_V_2_reg_271_reg[6]\: unisim.vcomponents.FDSE
     port map (
      C => ap_clk,
      CE => tmp_data_V_2_reg_2710,
      D => \tmp_data_V_2_reg_271[6]_i_1_n_1\,
      Q => tmp_data_V_2_reg_271(6),
      S => '0'
    );
\tmp_data_V_2_reg_271_reg[7]\: unisim.vcomponents.FDSE
     port map (
      C => ap_clk,
      CE => tmp_data_V_2_reg_2710,
      D => \tmp_data_V_2_reg_271[7]_i_2_n_1\,
      Q => tmp_data_V_2_reg_271(7),
      S => '0'
    );
\tmp_data_V_2_reg_271_reg[7]_i_23\: unisim.vcomponents.CARRY4
     port map (
      CI => \tmp_data_V_2_reg_271_reg[7]_i_36_n_1\,
      CO(3) => \tmp_data_V_2_reg_271_reg[7]_i_23_n_1\,
      CO(2) => \tmp_data_V_2_reg_271_reg[7]_i_23_n_2\,
      CO(1) => \tmp_data_V_2_reg_271_reg[7]_i_23_n_3\,
      CO(0) => \tmp_data_V_2_reg_271_reg[7]_i_23_n_4\,
      CYINIT => '0',
      DI(3) => \tmp_data_V_2_reg_271[7]_i_37_n_1\,
      DI(2) => \tmp_data_V_2_reg_271[7]_i_38_n_1\,
      DI(1) => \tmp_data_V_2_reg_271[7]_i_39_n_1\,
      DI(0) => \tmp_data_V_2_reg_271[7]_i_40_n_1\,
      O(3 downto 0) => \NLW_tmp_data_V_2_reg_271_reg[7]_i_23_O_UNCONNECTED\(3 downto 0),
      S(3) => \tmp_data_V_2_reg_271[7]_i_41_n_1\,
      S(2) => \tmp_data_V_2_reg_271[7]_i_42_n_1\,
      S(1) => \tmp_data_V_2_reg_271[7]_i_43_n_1\,
      S(0) => \tmp_data_V_2_reg_271[7]_i_44_n_1\
    );
\tmp_data_V_2_reg_271_reg[7]_i_36\: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => \tmp_data_V_2_reg_271_reg[7]_i_36_n_1\,
      CO(2) => \tmp_data_V_2_reg_271_reg[7]_i_36_n_2\,
      CO(1) => \tmp_data_V_2_reg_271_reg[7]_i_36_n_3\,
      CO(0) => \tmp_data_V_2_reg_271_reg[7]_i_36_n_4\,
      CYINIT => '0',
      DI(3) => \tmp_data_V_2_reg_271[7]_i_45_n_1\,
      DI(2) => \tmp_data_V_2_reg_271[7]_i_46_n_1\,
      DI(1) => \tmp_data_V_2_reg_271[7]_i_47_n_1\,
      DI(0) => \tmp_data_V_2_reg_271[7]_i_48_n_1\,
      O(3 downto 0) => \NLW_tmp_data_V_2_reg_271_reg[7]_i_36_O_UNCONNECTED\(3 downto 0),
      S(3) => \tmp_data_V_2_reg_271[7]_i_49_n_1\,
      S(2) => \tmp_data_V_2_reg_271[7]_i_50_n_1\,
      S(1) => \tmp_data_V_2_reg_271[7]_i_51_n_1\,
      S(0) => \tmp_data_V_2_reg_271[7]_i_52_n_1\
    );
\tmp_data_V_2_reg_271_reg[7]_i_4\: unisim.vcomponents.CARRY4
     port map (
      CI => \tmp_data_V_2_reg_271_reg[7]_i_6_n_1\,
      CO(3) => icmp_ln17_fu_158_p2,
      CO(2) => \tmp_data_V_2_reg_271_reg[7]_i_4_n_2\,
      CO(1) => \tmp_data_V_2_reg_271_reg[7]_i_4_n_3\,
      CO(0) => \tmp_data_V_2_reg_271_reg[7]_i_4_n_4\,
      CYINIT => '0',
      DI(3) => \tmp_data_V_2_reg_271[7]_i_7_n_1\,
      DI(2) => \tmp_data_V_2_reg_271[7]_i_8_n_1\,
      DI(1) => \tmp_data_V_2_reg_271[7]_i_9_n_1\,
      DI(0) => \tmp_data_V_2_reg_271[7]_i_10_n_1\,
      O(3 downto 0) => \NLW_tmp_data_V_2_reg_271_reg[7]_i_4_O_UNCONNECTED\(3 downto 0),
      S(3) => \tmp_data_V_2_reg_271[7]_i_11_n_1\,
      S(2) => \tmp_data_V_2_reg_271[7]_i_12_n_1\,
      S(1) => \tmp_data_V_2_reg_271[7]_i_13_n_1\,
      S(0) => \tmp_data_V_2_reg_271[7]_i_14_n_1\
    );
\tmp_data_V_2_reg_271_reg[7]_i_5\: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => tmp_data_V_1_fu_202_p3,
      CO(2) => \tmp_data_V_2_reg_271_reg[7]_i_5_n_2\,
      CO(1) => \tmp_data_V_2_reg_271_reg[7]_i_5_n_3\,
      CO(0) => \tmp_data_V_2_reg_271_reg[7]_i_5_n_4\,
      CYINIT => '0',
      DI(3) => \tmp_data_V_2_reg_271[7]_i_15_n_1\,
      DI(2) => \tmp_data_V_2_reg_271[7]_i_16_n_1\,
      DI(1) => \tmp_data_V_2_reg_271[7]_i_17_n_1\,
      DI(0) => \tmp_data_V_2_reg_271[7]_i_18_n_1\,
      O(3 downto 0) => \NLW_tmp_data_V_2_reg_271_reg[7]_i_5_O_UNCONNECTED\(3 downto 0),
      S(3) => \tmp_data_V_2_reg_271[7]_i_19_n_1\,
      S(2) => \tmp_data_V_2_reg_271[7]_i_20_n_1\,
      S(1) => \tmp_data_V_2_reg_271[7]_i_21_n_1\,
      S(0) => \tmp_data_V_2_reg_271[7]_i_22_n_1\
    );
\tmp_data_V_2_reg_271_reg[7]_i_6\: unisim.vcomponents.CARRY4
     port map (
      CI => \tmp_data_V_2_reg_271_reg[7]_i_23_n_1\,
      CO(3) => \tmp_data_V_2_reg_271_reg[7]_i_6_n_1\,
      CO(2) => \tmp_data_V_2_reg_271_reg[7]_i_6_n_2\,
      CO(1) => \tmp_data_V_2_reg_271_reg[7]_i_6_n_3\,
      CO(0) => \tmp_data_V_2_reg_271_reg[7]_i_6_n_4\,
      CYINIT => '0',
      DI(3) => \tmp_data_V_2_reg_271[7]_i_24_n_1\,
      DI(2) => \tmp_data_V_2_reg_271[7]_i_25_n_1\,
      DI(1) => \tmp_data_V_2_reg_271[7]_i_26_n_1\,
      DI(0) => \tmp_data_V_2_reg_271[7]_i_27_n_1\,
      O(3 downto 0) => \NLW_tmp_data_V_2_reg_271_reg[7]_i_6_O_UNCONNECTED\(3 downto 0),
      S(3) => \tmp_data_V_2_reg_271[7]_i_28_n_1\,
      S(2) => \tmp_data_V_2_reg_271[7]_i_29_n_1\,
      S(1) => \tmp_data_V_2_reg_271[7]_i_30_n_1\,
      S(0) => \tmp_data_V_2_reg_271[7]_i_31_n_1\
    );
\tmp_dest_V_reg_266[0]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axis_V_dest_V_0_payload_B,
      I1 => s_axis_V_dest_V_0_sel,
      I2 => s_axis_V_dest_V_0_payload_A,
      O => s_axis_V_dest_V_0_data_out
    );
\tmp_dest_V_reg_266_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => tmp_data_V_2_reg_2710,
      D => s_axis_V_dest_V_0_data_out,
      Q => tmp_dest_V_reg_266,
      R => '0'
    );
\tmp_id_V_reg_261[0]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axis_V_id_V_0_payload_B,
      I1 => s_axis_V_id_V_0_sel,
      I2 => s_axis_V_id_V_0_payload_A,
      O => s_axis_V_id_V_0_data_out
    );
\tmp_id_V_reg_261_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => tmp_data_V_2_reg_2710,
      D => s_axis_V_id_V_0_data_out,
      Q => tmp_id_V_reg_261,
      R => '0'
    );
\tmp_keep_V_reg_241[0]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axis_V_keep_V_0_payload_B,
      I1 => s_axis_V_keep_V_0_sel,
      I2 => s_axis_V_keep_V_0_payload_A,
      O => s_axis_V_keep_V_0_data_out
    );
\tmp_keep_V_reg_241_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => tmp_data_V_2_reg_2710,
      D => s_axis_V_keep_V_0_data_out,
      Q => tmp_keep_V_reg_241,
      R => '0'
    );
\tmp_last_V_reg_256[0]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axis_V_last_V_0_payload_B,
      I1 => s_axis_V_last_V_0_sel,
      I2 => s_axis_V_last_V_0_payload_A,
      O => s_axis_V_last_V_0_data_out
    );
\tmp_last_V_reg_256_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => tmp_data_V_2_reg_2710,
      D => s_axis_V_last_V_0_data_out,
      Q => tmp_last_V_reg_256,
      R => '0'
    );
\tmp_strb_V_reg_246[0]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axis_V_strb_V_0_payload_B,
      I1 => s_axis_V_strb_V_0_sel,
      I2 => s_axis_V_strb_V_0_payload_A,
      O => s_axis_V_strb_V_0_data_out
    );
\tmp_strb_V_reg_246_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => tmp_data_V_2_reg_2710,
      D => s_axis_V_strb_V_0_data_out,
      Q => tmp_strb_V_reg_246,
      R => '0'
    );
\tmp_user_V_reg_251[0]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axis_V_user_V_0_payload_B,
      I1 => s_axis_V_user_V_0_sel,
      I2 => s_axis_V_user_V_0_payload_A,
      O => s_axis_V_user_V_0_data_out
    );
\tmp_user_V_reg_251_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => tmp_data_V_2_reg_2710,
      D => s_axis_V_user_V_0_data_out,
      Q => tmp_user_V_reg_251,
      R => '0'
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix is
  port (
    s_axi_CTRL_AWADDR : in STD_LOGIC_VECTOR ( 5 downto 0 );
    s_axi_CTRL_AWVALID : in STD_LOGIC;
    s_axi_CTRL_AWREADY : out STD_LOGIC;
    s_axi_CTRL_WDATA : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_CTRL_WSTRB : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_CTRL_WVALID : in STD_LOGIC;
    s_axi_CTRL_WREADY : out STD_LOGIC;
    s_axi_CTRL_BRESP : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_CTRL_BVALID : out STD_LOGIC;
    s_axi_CTRL_BREADY : in STD_LOGIC;
    s_axi_CTRL_ARADDR : in STD_LOGIC_VECTOR ( 5 downto 0 );
    s_axi_CTRL_ARVALID : in STD_LOGIC;
    s_axi_CTRL_ARREADY : out STD_LOGIC;
    s_axi_CTRL_RDATA : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_CTRL_RRESP : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_CTRL_RVALID : out STD_LOGIC;
    s_axi_CTRL_RREADY : in STD_LOGIC;
    ap_clk : in STD_LOGIC;
    ap_rst_n : in STD_LOGIC;
    interrupt : out STD_LOGIC;
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
  attribute NotValidForBitStream of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix : entity is "cubeocc_hls_0,cubeocc_hls,{}";
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix : entity is "yes";
  attribute IP_DEFINITION_SOURCE : string;
  attribute IP_DEFINITION_SOURCE of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix : entity is "HLS";
  attribute X_CORE_INFO : string;
  attribute X_CORE_INFO of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix : entity is "cubeocc_hls,Vivado 2019.1";
  attribute hls_module : string;
  attribute hls_module of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix : entity is "yes";
end decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix;

architecture STRUCTURE of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix is
  attribute C_S_AXI_CTRL_ADDR_WIDTH : integer;
  attribute C_S_AXI_CTRL_ADDR_WIDTH of inst : label is 6;
  attribute C_S_AXI_CTRL_DATA_WIDTH : integer;
  attribute C_S_AXI_CTRL_DATA_WIDTH of inst : label is 32;
  attribute C_S_AXI_CTRL_WSTRB_WIDTH : integer;
  attribute C_S_AXI_CTRL_WSTRB_WIDTH of inst : label is 4;
  attribute C_S_AXI_DATA_WIDTH : integer;
  attribute C_S_AXI_DATA_WIDTH of inst : label is 32;
  attribute C_S_AXI_WSTRB_WIDTH : integer;
  attribute C_S_AXI_WSTRB_WIDTH of inst : label is 4;
  attribute ap_ST_fsm_pp0_stage0 : string;
  attribute ap_ST_fsm_pp0_stage0 of inst : label is "3'b010";
  attribute ap_ST_fsm_state1 : string;
  attribute ap_ST_fsm_state1 of inst : label is "3'b001";
  attribute ap_ST_fsm_state5 : string;
  attribute ap_ST_fsm_state5 of inst : label is "3'b100";
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of ap_clk : signal is "xilinx.com:signal:clock:1.0 ap_clk CLK";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of ap_clk : signal is "XIL_INTERFACENAME ap_clk, ASSOCIATED_BUSIF s_axi_CTRL:s_axis:m_axis, ASSOCIATED_RESET ap_rst_n, FREQ_HZ 100000000, PHASE 0.000, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of ap_rst_n : signal is "xilinx.com:signal:reset:1.0 ap_rst_n RST";
  attribute X_INTERFACE_PARAMETER of ap_rst_n : signal is "XIL_INTERFACENAME ap_rst_n, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of interrupt : signal is "xilinx.com:signal:interrupt:1.0 interrupt INTERRUPT";
  attribute X_INTERFACE_PARAMETER of interrupt : signal is "XIL_INTERFACENAME interrupt, SENSITIVITY LEVEL_HIGH, PortWidth 1";
  attribute X_INTERFACE_INFO of m_axis_TREADY : signal is "xilinx.com:interface:axis:1.0 m_axis TREADY";
  attribute X_INTERFACE_INFO of m_axis_TVALID : signal is "xilinx.com:interface:axis:1.0 m_axis TVALID";
  attribute X_INTERFACE_INFO of s_axi_CTRL_ARREADY : signal is "xilinx.com:interface:aximm:1.0 s_axi_CTRL ARREADY";
  attribute X_INTERFACE_INFO of s_axi_CTRL_ARVALID : signal is "xilinx.com:interface:aximm:1.0 s_axi_CTRL ARVALID";
  attribute X_INTERFACE_INFO of s_axi_CTRL_AWREADY : signal is "xilinx.com:interface:aximm:1.0 s_axi_CTRL AWREADY";
  attribute X_INTERFACE_INFO of s_axi_CTRL_AWVALID : signal is "xilinx.com:interface:aximm:1.0 s_axi_CTRL AWVALID";
  attribute X_INTERFACE_INFO of s_axi_CTRL_BREADY : signal is "xilinx.com:interface:aximm:1.0 s_axi_CTRL BREADY";
  attribute X_INTERFACE_INFO of s_axi_CTRL_BVALID : signal is "xilinx.com:interface:aximm:1.0 s_axi_CTRL BVALID";
  attribute X_INTERFACE_INFO of s_axi_CTRL_RREADY : signal is "xilinx.com:interface:aximm:1.0 s_axi_CTRL RREADY";
  attribute X_INTERFACE_PARAMETER of s_axi_CTRL_RREADY : signal is "XIL_INTERFACENAME s_axi_CTRL, ADDR_WIDTH 6, DATA_WIDTH 32, PROTOCOL AXI4LITE, READ_WRITE_MODE READ_WRITE, FREQ_HZ 100000000, ID_WIDTH 0, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 0, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 0, NUM_READ_OUTSTANDING 1, NUM_WRITE_OUTSTANDING 1, MAX_BURST_LENGTH 1, PHASE 0.000, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of s_axi_CTRL_RVALID : signal is "xilinx.com:interface:aximm:1.0 s_axi_CTRL RVALID";
  attribute X_INTERFACE_INFO of s_axi_CTRL_WREADY : signal is "xilinx.com:interface:aximm:1.0 s_axi_CTRL WREADY";
  attribute X_INTERFACE_INFO of s_axi_CTRL_WVALID : signal is "xilinx.com:interface:aximm:1.0 s_axi_CTRL WVALID";
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
  attribute X_INTERFACE_INFO of s_axi_CTRL_ARADDR : signal is "xilinx.com:interface:aximm:1.0 s_axi_CTRL ARADDR";
  attribute X_INTERFACE_INFO of s_axi_CTRL_AWADDR : signal is "xilinx.com:interface:aximm:1.0 s_axi_CTRL AWADDR";
  attribute X_INTERFACE_INFO of s_axi_CTRL_BRESP : signal is "xilinx.com:interface:aximm:1.0 s_axi_CTRL BRESP";
  attribute X_INTERFACE_INFO of s_axi_CTRL_RDATA : signal is "xilinx.com:interface:aximm:1.0 s_axi_CTRL RDATA";
  attribute X_INTERFACE_INFO of s_axi_CTRL_RRESP : signal is "xilinx.com:interface:aximm:1.0 s_axi_CTRL RRESP";
  attribute X_INTERFACE_INFO of s_axi_CTRL_WDATA : signal is "xilinx.com:interface:aximm:1.0 s_axi_CTRL WDATA";
  attribute X_INTERFACE_INFO of s_axi_CTRL_WSTRB : signal is "xilinx.com:interface:aximm:1.0 s_axi_CTRL WSTRB";
  attribute X_INTERFACE_INFO of s_axis_TDATA : signal is "xilinx.com:interface:axis:1.0 s_axis TDATA";
  attribute X_INTERFACE_INFO of s_axis_TDEST : signal is "xilinx.com:interface:axis:1.0 s_axis TDEST";
  attribute X_INTERFACE_INFO of s_axis_TID : signal is "xilinx.com:interface:axis:1.0 s_axis TID";
  attribute X_INTERFACE_PARAMETER of s_axis_TID : signal is "XIL_INTERFACENAME s_axis, TDATA_NUM_BYTES 1, TDEST_WIDTH 1, TID_WIDTH 1, TUSER_WIDTH 1, HAS_TREADY 1, HAS_TSTRB 1, HAS_TKEEP 1, HAS_TLAST 1, FREQ_HZ 100000000, PHASE 0.000, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of s_axis_TKEEP : signal is "xilinx.com:interface:axis:1.0 s_axis TKEEP";
  attribute X_INTERFACE_INFO of s_axis_TLAST : signal is "xilinx.com:interface:axis:1.0 s_axis TLAST";
  attribute X_INTERFACE_INFO of s_axis_TSTRB : signal is "xilinx.com:interface:axis:1.0 s_axis TSTRB";
  attribute X_INTERFACE_INFO of s_axis_TUSER : signal is "xilinx.com:interface:axis:1.0 s_axis TUSER";
begin
inst: entity work.decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_cubeocc_hls
     port map (
      ap_clk => ap_clk,
      ap_rst_n => ap_rst_n,
      interrupt => interrupt,
      m_axis_TDATA(7 downto 0) => m_axis_TDATA(7 downto 0),
      m_axis_TDEST(0) => m_axis_TDEST(0),
      m_axis_TID(0) => m_axis_TID(0),
      m_axis_TKEEP(0) => m_axis_TKEEP(0),
      m_axis_TLAST(0) => m_axis_TLAST(0),
      m_axis_TREADY => m_axis_TREADY,
      m_axis_TSTRB(0) => m_axis_TSTRB(0),
      m_axis_TUSER(0) => m_axis_TUSER(0),
      m_axis_TVALID => m_axis_TVALID,
      s_axi_CTRL_ARADDR(5 downto 0) => s_axi_CTRL_ARADDR(5 downto 0),
      s_axi_CTRL_ARREADY => s_axi_CTRL_ARREADY,
      s_axi_CTRL_ARVALID => s_axi_CTRL_ARVALID,
      s_axi_CTRL_AWADDR(5 downto 0) => s_axi_CTRL_AWADDR(5 downto 0),
      s_axi_CTRL_AWREADY => s_axi_CTRL_AWREADY,
      s_axi_CTRL_AWVALID => s_axi_CTRL_AWVALID,
      s_axi_CTRL_BREADY => s_axi_CTRL_BREADY,
      s_axi_CTRL_BRESP(1 downto 0) => s_axi_CTRL_BRESP(1 downto 0),
      s_axi_CTRL_BVALID => s_axi_CTRL_BVALID,
      s_axi_CTRL_RDATA(31 downto 0) => s_axi_CTRL_RDATA(31 downto 0),
      s_axi_CTRL_RREADY => s_axi_CTRL_RREADY,
      s_axi_CTRL_RRESP(1 downto 0) => s_axi_CTRL_RRESP(1 downto 0),
      s_axi_CTRL_RVALID => s_axi_CTRL_RVALID,
      s_axi_CTRL_WDATA(31 downto 0) => s_axi_CTRL_WDATA(31 downto 0),
      s_axi_CTRL_WREADY => s_axi_CTRL_WREADY,
      s_axi_CTRL_WSTRB(3 downto 0) => s_axi_CTRL_WSTRB(3 downto 0),
      s_axi_CTRL_WVALID => s_axi_CTRL_WVALID,
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
