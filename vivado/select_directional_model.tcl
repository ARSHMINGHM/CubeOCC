# Common implementation used by the three user-facing model selector scripts.
if {![info exists cubeocc_model_select]} {
    error "Set cubeocc_model_select to 0, 1, or 2 before sourcing this file."
}
if {$cubeocc_model_select < 0 || $cubeocc_model_select > 2} {
    error "cubeocc_model_select must be 0 (both), 1 (old_poly), or 2 (pca30_fused)."
}
if {[llength [get_projects -quiet]] == 0} {
    error "Open the CubeOCC Vivado project before selecting a classifier model."
}

set selector_dir [file dirname [file normalize [info script]]]
set root_dir [file dirname $selector_dir]
set model_sources [list \
    rtl/roi_start_detector.sv \
    rtl/projective_warp_160x120.sv \
    rtl/grayscale_grid_8x8.sv \
    rtl/grid_corner_frame_guard.sv \
    rtl/roi_warp_grid_pipeline.sv \
    rtl/directional_dual_polynomial_sampler.sv \
    rtl/cubeocc_dual_classifier_top.sv]

# Older .xpr files may predate the alternate classifier. Add only missing files.
foreach relative_path $model_sources {
    set source_path [file normalize [file join $root_dir $relative_path]]
    if {[llength [get_files -quiet $source_path]] == 0} {
        add_files -norecurse -fileset sources_1 $source_path
    }
}

set rtl_dir [file normalize [file join $root_dir rtl]]
set include_dirs [get_property include_dirs [get_filesets sources_1]]
if {[lsearch -exact $include_dirs $rtl_dir] < 0} {
    lappend include_dirs $rtl_dir
    set_property include_dirs $include_dirs [get_filesets sources_1]
}

set_property top cubeocc_dual_classifier_top [get_filesets sources_1]
set_property generic "MODEL_SELECT=$cubeocc_model_select" [get_filesets sources_1]
update_compile_order -fileset sources_1

set model_names [list BOTH OLD_POLY PCA30_FUSED]
puts "CubeOCC classifier selection: [lindex $model_names $cubeocc_model_select]"
puts "Reset and rerun synthesis for this selection to change the netlist."
unset cubeocc_model_select
