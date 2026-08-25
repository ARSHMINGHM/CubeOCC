-- (c) Copyright 1995-2026 Xilinx, Inc. All rights reserved.
-- 
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
-- 
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
-- 
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
-- 
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
-- 
-- DO NOT MODIFY THIS FILE.

-- IP VLNV: xilinx.com:hls:cubeocc_hls:1.0
-- IP Revision: 1

-- The following code must appear in the VHDL architecture header.

------------- Begin Cut here for COMPONENT Declaration ------ COMP_TAG
COMPONENT cubeocc_hls_1
  PORT (
    s_axi_CTRL_AWADDR : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
    s_axi_CTRL_AWVALID : IN STD_LOGIC;
    s_axi_CTRL_AWREADY : OUT STD_LOGIC;
    s_axi_CTRL_WDATA : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axi_CTRL_WSTRB : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    s_axi_CTRL_WVALID : IN STD_LOGIC;
    s_axi_CTRL_WREADY : OUT STD_LOGIC;
    s_axi_CTRL_BRESP : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    s_axi_CTRL_BVALID : OUT STD_LOGIC;
    s_axi_CTRL_BREADY : IN STD_LOGIC;
    s_axi_CTRL_ARADDR : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
    s_axi_CTRL_ARVALID : IN STD_LOGIC;
    s_axi_CTRL_ARREADY : OUT STD_LOGIC;
    s_axi_CTRL_RDATA : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axi_CTRL_RRESP : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    s_axi_CTRL_RVALID : OUT STD_LOGIC;
    s_axi_CTRL_RREADY : IN STD_LOGIC;
    ap_clk : IN STD_LOGIC;
    ap_rst_n : IN STD_LOGIC;
    interrupt : OUT STD_LOGIC;
    s_axis_TVALID : IN STD_LOGIC;
    s_axis_TREADY : OUT STD_LOGIC;
    s_axis_TDATA : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    s_axis_TDEST : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    s_axis_TKEEP : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    s_axis_TSTRB : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    s_axis_TUSER : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    s_axis_TLAST : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    s_axis_TID : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    m_axis_TVALID : OUT STD_LOGIC;
    m_axis_TREADY : IN STD_LOGIC;
    m_axis_TDATA : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    m_axis_TDEST : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    m_axis_TKEEP : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    m_axis_TSTRB : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    m_axis_TUSER : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    m_axis_TLAST : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    m_axis_TID : OUT STD_LOGIC_VECTOR(0 DOWNTO 0)
  );
END COMPONENT;
-- COMP_TAG_END ------ End COMPONENT Declaration ------------

-- The following code must appear in the VHDL architecture
-- body. Substitute your own instance name and net names.

------------- Begin Cut here for INSTANTIATION Template ----- INST_TAG
your_instance_name : cubeocc_hls_1
  PORT MAP (
    s_axi_CTRL_AWADDR => s_axi_CTRL_AWADDR,
    s_axi_CTRL_AWVALID => s_axi_CTRL_AWVALID,
    s_axi_CTRL_AWREADY => s_axi_CTRL_AWREADY,
    s_axi_CTRL_WDATA => s_axi_CTRL_WDATA,
    s_axi_CTRL_WSTRB => s_axi_CTRL_WSTRB,
    s_axi_CTRL_WVALID => s_axi_CTRL_WVALID,
    s_axi_CTRL_WREADY => s_axi_CTRL_WREADY,
    s_axi_CTRL_BRESP => s_axi_CTRL_BRESP,
    s_axi_CTRL_BVALID => s_axi_CTRL_BVALID,
    s_axi_CTRL_BREADY => s_axi_CTRL_BREADY,
    s_axi_CTRL_ARADDR => s_axi_CTRL_ARADDR,
    s_axi_CTRL_ARVALID => s_axi_CTRL_ARVALID,
    s_axi_CTRL_ARREADY => s_axi_CTRL_ARREADY,
    s_axi_CTRL_RDATA => s_axi_CTRL_RDATA,
    s_axi_CTRL_RRESP => s_axi_CTRL_RRESP,
    s_axi_CTRL_RVALID => s_axi_CTRL_RVALID,
    s_axi_CTRL_RREADY => s_axi_CTRL_RREADY,
    ap_clk => ap_clk,
    ap_rst_n => ap_rst_n,
    interrupt => interrupt,
    s_axis_TVALID => s_axis_TVALID,
    s_axis_TREADY => s_axis_TREADY,
    s_axis_TDATA => s_axis_TDATA,
    s_axis_TDEST => s_axis_TDEST,
    s_axis_TKEEP => s_axis_TKEEP,
    s_axis_TSTRB => s_axis_TSTRB,
    s_axis_TUSER => s_axis_TUSER,
    s_axis_TLAST => s_axis_TLAST,
    s_axis_TID => s_axis_TID,
    m_axis_TVALID => m_axis_TVALID,
    m_axis_TREADY => m_axis_TREADY,
    m_axis_TDATA => m_axis_TDATA,
    m_axis_TDEST => m_axis_TDEST,
    m_axis_TKEEP => m_axis_TKEEP,
    m_axis_TSTRB => m_axis_TSTRB,
    m_axis_TUSER => m_axis_TUSER,
    m_axis_TLAST => m_axis_TLAST,
    m_axis_TID => m_axis_TID
  );
-- INST_TAG_END ------ End INSTANTIATION Template ---------

-- You must compile the wrapper file cubeocc_hls_1.vhd when simulating
-- the core, cubeocc_hls_1. When compiling the wrapper file, be sure to
-- reference the VHDL simulation library.

