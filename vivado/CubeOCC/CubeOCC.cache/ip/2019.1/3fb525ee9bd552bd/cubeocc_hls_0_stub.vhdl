-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
-- Date        : Thu Aug 27 17:03:56 2026
-- Host        : DESKTOP-RQHJO7S running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
--               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ cubeocc_hls_0_stub.vhdl
-- Design      : cubeocc_hls_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a35tcpg236-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix is
  Port ( 
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

end decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix;

architecture stub of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "ap_clk,ap_rst_n,s_axis_TVALID,s_axis_TREADY,s_axis_TDATA[7:0],s_axis_TDEST[0:0],s_axis_TKEEP[0:0],s_axis_TSTRB[0:0],s_axis_TUSER[0:0],s_axis_TLAST[0:0],s_axis_TID[0:0],m_axis_TVALID,m_axis_TREADY,m_axis_TDATA[7:0],m_axis_TDEST[0:0],m_axis_TKEEP[0:0],m_axis_TSTRB[0:0],m_axis_TUSER[0:0],m_axis_TLAST[0:0],m_axis_TID[0:0]";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "cubeocc_hls,Vivado 2019.1";
begin
end;
