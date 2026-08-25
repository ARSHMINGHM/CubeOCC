# This script segment is generated automatically by AutoPilot

set axilite_register_dict [dict create]
set port_CTRL {
ap_start { }
ap_done { }
ap_ready { }
ap_idle { }
pixel_count { 
	dir I
	width 32
	depth 1
	mode ap_none
	offset 16
	offset_end 23
}
threshold_V { 
	dir I
	width 8
	depth 1
	mode ap_none
	offset 24
	offset_end 31
}
threshold_enable { 
	dir I
	width 1
	depth 1
	mode ap_none
	offset 32
	offset_end 39
}
}
dict set axilite_register_dict CTRL $port_CTRL


