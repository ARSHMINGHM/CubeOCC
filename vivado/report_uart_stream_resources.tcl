set root_dir [file dirname [file dirname [file normalize [info script]]]]
set out_dir [file join $root_dir sim uart_stream_resource_reports]
file mkdir $out_dir

proc report_uart_design {root_dir out_dir report_name top sources {generic ""}} {
    create_project -in_memory -part xc7a35tcpg236-1
    set_property include_dirs [list [file join $root_dir rtl]] [current_fileset]
    foreach source $sources {
        read_verilog -sv [file join $root_dir $source]
    }
    if {$generic eq ""} {
        synth_design -top $top -part xc7a35tcpg236-1 -mode out_of_context
    } else {
        synth_design -top $top -part xc7a35tcpg236-1 -mode out_of_context -generic $generic
    }
    set clock_port [get_ports -quiet pclk]
    if {[llength $clock_port] == 0} {
        set clock_port [get_ports -quiet clk]
    }
    if {[llength $clock_port] != 0} {
        create_clock -name processing_clock -period 10.000 $clock_port
    }
    report_utilization -file [file join $out_dir ${report_name}_utilization.rpt]
    report_timing_summary -file [file join $out_dir ${report_name}_timing.rpt]
    close_project
}

set uart_sources [list \
    rtl/uart_tx_byte.sv \
    rtl/cubeocc_uart_frame_streamer.sv]
report_uart_design $root_dir $out_dir cubeocc_uart_frame_streamer \
    cubeocc_uart_frame_streamer $uart_sources

set full_sources [list \
    rtl/roi_start_detector.sv \
    rtl/projective_warp_160x120.sv \
    rtl/grayscale_grid_8x8.sv \
    rtl/grid_corner_frame_guard.sv \
    rtl/roi_warp_grid_pipeline.sv \
    rtl/directional_dual_polynomial_sampler.sv \
    rtl/cubeocc_dual_classifier_top.sv \
    rtl/uart_tx_byte.sv \
    rtl/cubeocc_uart_frame_streamer.sv \
    rtl/cubeocc_uart_stream_top.sv]

report_uart_design $root_dir $out_dir cubeocc_uart_old_poly \
    cubeocc_uart_stream_top $full_sources CLASSIFIER_MODEL=1
report_uart_design $root_dir $out_dir cubeocc_uart_pca30_fused \
    cubeocc_uart_stream_top $full_sources CLASSIFIER_MODEL=2

puts "UART stream reports written to $out_dir"
