vlib work
vlib activehdl

vlib activehdl/xil_defaultlib

vmap xil_defaultlib activehdl/xil_defaultlib

vlog -work xil_defaultlib  -v2k5 \
"../../../ipstatic/hdl/verilog/cubeocc_hls.v" \
"../../../../CubeOCC.srcs/sources_1/ip/cubeocc_hls_0/sim/cubeocc_hls_0.v" \


vlog -work xil_defaultlib \
"glbl.v"

