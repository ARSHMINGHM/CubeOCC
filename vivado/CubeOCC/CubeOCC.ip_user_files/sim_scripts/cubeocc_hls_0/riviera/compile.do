vlib work
vlib riviera

vlib riviera/xil_defaultlib

vmap xil_defaultlib riviera/xil_defaultlib

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../CubeOCC.srcs/sources_1/ip/cubeocc_hls_0/drivers/cubeocc_hls_v1_0/src" \
"../../../ipstatic/hdl/verilog/cubeocc_hls_CTRL_s_axi.v" \
"../../../ipstatic/hdl/verilog/cubeocc_hls.v" \
"../../../../CubeOCC.srcs/sources_1/ip/cubeocc_hls_0/sim/cubeocc_hls_0.v" \


vlog -work xil_defaultlib \
"glbl.v"

