if {![info exists cubeocc_uart_model]} {
    error "Set cubeocc_uart_model to 1 (old_poly) or 2 (pca30_fused)."
}
if {$cubeocc_uart_model != 1 && $cubeocc_uart_model != 2} {
    error "cubeocc_uart_model must be 1 (old_poly) or 2 (pca30_fused)."
}
if {[llength [get_projects -quiet]] == 0} {
    error "Open the CubeOCC Vivado project before selecting UART output."
}

set selector_dir [file dirname [file normalize [info script]]]
set root_dir [file dirname $selector_dir]
set sources [list \
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

foreach relative_path $sources {
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

set_property top cubeocc_uart_stream_top [get_filesets sources_1]
set_property generic "CLASSIFIER_MODEL=$cubeocc_uart_model CLOCK_HZ=100000000 UART_BAUD=115200" [get_filesets sources_1]
update_compile_order -fileset sources_1
puts "CubeOCC UART output selected with classifier model $cubeocc_uart_model."
puts "Add the board XDC pin for uart_tx, then reset and rerun synthesis."
unset cubeocc_uart_model
