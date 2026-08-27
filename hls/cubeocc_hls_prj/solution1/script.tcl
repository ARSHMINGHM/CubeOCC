############################################################
## This file is generated automatically by Vivado HLS.
## Please DO NOT edit it.
## Copyright (C) 1986-2019 Xilinx, Inc. All Rights Reserved.
############################################################
open_project cubeocc_hls_prj
set_top cubeocc_hls
add_files cubeocc_hls.cpp
add_files cubeocc_hls.h
add_files -tb cubeocc_hls_tb.cpp
open_solution "solution1"
set_part {xc7a35t-cpg236-1} -tool vivado
create_clock -period 10 -name default
config_export -format ip_catalog -rtl vhdl
#source "./cubeocc_hls_prj/solution1/directives.tcl"
csim_design
csynth_design
cosim_design
export_design -rtl vhdl -format ip_catalog
