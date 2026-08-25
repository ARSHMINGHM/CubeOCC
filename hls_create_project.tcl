# Vivado HLS / Vitis HLS project setup for CubeOCC.
# Usage from Vivado HLS or Vitis HLS Tcl Console:
#   cd C:/Users/arshm/Desktop/CubeOCC
#   source hls_create_project.tcl

set script_dir [file dirname [file normalize [info script]]]
set hls_dir    [file join $script_dir hls]

open_project -reset [file join $hls_dir cubeocc_hls_prj]
set_top cubeocc_hls

add_files [file join $hls_dir cubeocc_hls.cpp]
add_files [file join $hls_dir cubeocc_hls.h]
add_files -tb [file join $hls_dir cubeocc_hls_tb.cpp]

open_solution -reset solution1

# Change this part if your board/FPGA is different.
set_part {xc7a35tcpg236-1}
create_clock -period 10 -name default

csim_design
csynth_design
export_design -format ip_catalog

puts "CubeOCC HLS project created at: [file join $hls_dir cubeocc_hls_prj]"
puts "Exported IP can be added to the Vivado IP Catalog."
