onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib cubeocc_hls_0_opt

do {wave.do}

view wave
view structure
view signals

do {cubeocc_hls_0.udo}

run -all

quit -force
