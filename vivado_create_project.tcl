# Vivado project setup for CubeOCC.
# Usage from Vivado Tcl Console:
#   cd C:/Users/arshm/Desktop/CubeOCC
#   source vivado_create_project.tcl

set script_dir [file dirname [file normalize [info script]]]
set proj_dir   [file join $script_dir vivado CubeOCC]

create_project CubeOCC $proj_dir -force

# Change this part if your board/FPGA is different.
set_property part xc7a35tcpg236-1 [current_project]

# Vivado project language uses Verilog/VHDL here; .sv files are still
# compiled as SystemVerilog because of their file extension.
set_property target_language Verilog [current_project]
set_property simulator_language Mixed [current_project]

add_files -fileset sources_1 [list \
  [file join $script_dir rtl i2c_master.sv] \
  [file join $script_dir rtl dvp_to_axis.sv] \
  [file join $script_dir rtl roi_start_detector.sv] \
  [file join $script_dir rtl cubeocc_top.sv] \
]

add_files -fileset sim_1 [list \
  [file join $script_dir camera_sim camera_regs_pkg.sv] \
  [file join $script_dir camera_sim dvp_camera_model.sv] \
  [file join $script_dir camera_sim mipi_camera_model.sv] \
  [file join $script_dir tb i2c_camera_slave_model.sv] \
  [file join $script_dir tb dvp_camera_tb.sv] \
  [file join $script_dir tb mipi_camera_tb.sv] \
  [file join $script_dir tb i2c_cam_tb.sv] \
  [file join $script_dir tb axis_cam_tb.sv] \
  [file join $script_dir tb roi_start_detector_tb.sv] \
  [file join $script_dir tb cubeocc_top_tb.sv] \
]

update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
set_property top cubeocc_top [get_filesets sources_1]

# Pick a default simulation top. You can change this in Settings > Simulation.
set_property top axis_cam_tb [get_filesets sim_1]

puts "CubeOCC Vivado project created at: $proj_dir"
puts "Default sim top: axis_cam_tb"
