if {[info exists ::env(CUBEOCC_REPO)]} {
    set repo_dir $::env(CUBEOCC_REPO)
} else {
    set script_path [string map [list "\\" "/"] [info script]]
    set script_dir [file dirname [file normalize $script_path]]
    set repo_dir [file dirname $script_dir]
}
set out_dir [file join $repo_dir sim roi_start_detector_resources]
file mkdir $out_dir
set_param general.maxThreads 1

read_verilog -sv [file join $repo_dir rtl roi_start_detector.sv]
set synth_options [list -top roi_start_detector -part xc7a35tcpg236-1 -flatten_hierarchy rebuilt]
if {[info exists ::env(ROI_X_BITS)]} {
    lappend synth_options -generic "X_BITS=$::env(ROI_X_BITS)"
}
if {[info exists ::env(ROI_Y_BITS)]} {
    lappend synth_options -generic "Y_BITS=$::env(ROI_Y_BITS)"
}
synth_design {*}$synth_options
create_clock -name pclk -period 10.000 [get_ports pclk]

report_utilization -hierarchical -file [file join $out_dir utilization_hierarchical.rpt]
report_utilization -file [file join $out_dir utilization.rpt]
report_timing_summary -delay_type max -max_paths 10 -file [file join $out_dir timing_summary.rpt]
write_checkpoint -force [file join $out_dir roi_start_detector_synth.dcp]

puts "ROI_RESOURCE_REPORT=[file join $out_dir utilization.rpt]"
puts "ROI_TIMING_REPORT=[file join $out_dir timing_summary.rpt]"
