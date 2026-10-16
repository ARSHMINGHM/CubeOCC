if {[info exists ::env(CUBEOCC_ROOT)]} {
    set root_dir $::env(CUBEOCC_ROOT)
} else {
    set root_dir [file dirname [file dirname [file normalize [info script]]]]
}
set out_dir [file join $root_dir sim camera2_resource_reports]
file mkdir $out_dir

proc synth_and_report {root_dir out_dir top source} {
    create_project -in_memory -part xc7a35tcpg236-1
    read_verilog -sv [file join $root_dir $source]
    synth_design -top $top -part xc7a35tcpg236-1 -mode out_of_context
    set clock_port [get_ports -quiet pclk]
    if {[llength $clock_port] == 0} {
        set clock_port [get_ports -quiet clk]
    }
    if {[llength $clock_port] != 0} {
        create_clock -name processing_clock -period 10.000 $clock_port
    }
    report_utilization -file [file join $out_dir ${top}_utilization.rpt]
    report_timing_summary -file [file join $out_dir ${top}_timing.rpt]
    close_project
}

proc synth_many_and_report {root_dir out_dir top sources} {
    create_project -in_memory -part xc7a35tcpg236-1
    foreach source $sources {
        read_verilog -sv [file join $root_dir $source]
    }
    synth_design -top $top -part xc7a35tcpg236-1 -mode out_of_context
    set clock_port [get_ports -quiet pclk]
    if {[llength $clock_port] == 0} {
        set clock_port [get_ports -quiet clk]
    }
    if {[llength $clock_port] != 0} {
        create_clock -name processing_clock -period 10.000 $clock_port
    }
    report_utilization -file [file join $out_dir ${top}_utilization.rpt]
    report_timing_summary -file [file join $out_dir ${top}_timing.rpt]
    close_project
}

synth_many_and_report $root_dir $out_dir roi_warp_grid_pipeline [list \
    rtl/roi_start_detector.sv \
    rtl/projective_warp_160x120.sv \
    rtl/grayscale_grid_8x8.sv \
    rtl/grid_corner_frame_guard.sv \
    rtl/roi_warp_grid_pipeline.sv]
synth_many_and_report $root_dir $out_dir cubeocc_top [list \
    rtl/roi_start_detector.sv \
    rtl/projective_warp_160x120.sv \
    rtl/grayscale_grid_8x8.sv \
    rtl/grid_corner_frame_guard.sv \
    rtl/roi_warp_grid_pipeline.sv \
    rtl/linear_rule_sampler.sv \
    rtl/cubeocc_top.sv]
synth_and_report $root_dir $out_dir linear_rule_sampler rtl/linear_rule_sampler.sv
synth_and_report $root_dir $out_dir projective_warp_160x120 rtl/projective_warp_160x120.sv
synth_and_report $root_dir $out_dir grayscale_grid_8x8 rtl/grayscale_grid_8x8.sv
synth_and_report $root_dir $out_dir perspective_warp_160x120 rtl/perspective_warp_160x120.sv
synth_and_report $root_dir $out_dir camera2_roi_programmer rtl/camera2_roi_programmer.sv
puts "Camera 2 resource reports written to $out_dir"
