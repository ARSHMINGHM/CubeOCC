set root_dir [file dirname [file dirname [file normalize [info script]]]]
set out_dir [file join $root_dir sim dual_classifier_resource_reports]
file mkdir $out_dir

proc report_design {root_dir out_dir report_name top sources {generic ""}} {
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

report_design $root_dir $out_dir directional_dual_polynomial_sampler directional_dual_polynomial_sampler [list \
    rtl/directional_dual_polynomial_sampler.sv]

set full_sources [list \
    rtl/roi_start_detector.sv \
    rtl/projective_warp_160x120.sv \
    rtl/grayscale_grid_8x8.sv \
    rtl/grid_corner_frame_guard.sv \
    rtl/roi_warp_grid_pipeline.sv \
    rtl/directional_dual_polynomial_sampler.sv \
    rtl/cubeocc_dual_classifier_top.sv]

report_design $root_dir $out_dir cubeocc_dual_classifier_top cubeocc_dual_classifier_top $full_sources
report_design $root_dir $out_dir cubeocc_old_poly_only cubeocc_dual_classifier_top $full_sources MODEL_SELECT=1
report_design $root_dir $out_dir cubeocc_pca30_only cubeocc_dual_classifier_top $full_sources MODEL_SELECT=2

puts "Dual classifier reports written to $out_dir"
