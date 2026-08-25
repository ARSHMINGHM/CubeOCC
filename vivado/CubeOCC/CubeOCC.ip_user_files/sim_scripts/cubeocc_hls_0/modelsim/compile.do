vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xil_defaultlib

vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib

vlog -work xil_defaultlib -64 -incr "+incdir+../../../../CubeOCC.srcs/sources_1/ip/cubeocc_hls_0/drivers/cubeocc_hls_v1_0/src" \
"../../../ipstatic/hdl/verilog/cubeocc_hls_CTRL_s_axi.v" \
"../../../ipstatic/hdl/verilog/cubeocc_hls.v" \
"../../../../CubeOCC.srcs/sources_1/ip/cubeocc_hls_0/sim/cubeocc_hls_0.v" \


vlog -work xil_defaultlib \
"glbl.v"

