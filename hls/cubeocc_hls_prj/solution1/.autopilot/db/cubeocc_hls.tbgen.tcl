set moduleName cubeocc_hls
set isTopModule 1
set isTaskLevelControl 1
set isCombinational 0
set isDatapathOnly 0
set isFreeRunPipelineModule 0
set isPipelined 1
set pipeline_type function
set FunctionProtocol ap_ctrl_none
set isOneStateSeq 0
set ProfileFlag 0
set StallSigGenFlag 0
set isEnableWaveformDebug 1
set C_modelName {cubeocc_hls}
set C_modelType { void 0 }
set C_modelArgList {
	{ s_axis_V_data_V int 8 regular {axi_s 0 volatile  { s_axis Data } }  }
	{ s_axis_V_keep_V int 1 regular {axi_s 0 volatile  { s_axis Keep } }  }
	{ s_axis_V_strb_V int 1 regular {axi_s 0 volatile  { s_axis Strb } }  }
	{ s_axis_V_user_V int 1 regular {axi_s 0 volatile  { s_axis User } }  }
	{ s_axis_V_last_V int 1 regular {axi_s 0 volatile  { s_axis Last } }  }
	{ s_axis_V_id_V int 1 regular {axi_s 0 volatile  { s_axis ID } }  }
	{ s_axis_V_dest_V int 1 regular {axi_s 0 volatile  { s_axis Dest } }  }
	{ m_axis_V_data_V int 8 regular {axi_s 1 volatile  { m_axis Data } }  }
	{ m_axis_V_keep_V int 1 regular {axi_s 1 volatile  { m_axis Keep } }  }
	{ m_axis_V_strb_V int 1 regular {axi_s 1 volatile  { m_axis Strb } }  }
	{ m_axis_V_user_V int 1 regular {axi_s 1 volatile  { m_axis User } }  }
	{ m_axis_V_last_V int 1 regular {axi_s 1 volatile  { m_axis Last } }  }
	{ m_axis_V_id_V int 1 regular {axi_s 1 volatile  { m_axis ID } }  }
	{ m_axis_V_dest_V int 1 regular {axi_s 1 volatile  { m_axis Dest } }  }
}
set C_modelArgMapList {[ 
	{ "Name" : "s_axis_V_data_V", "interface" : "axis", "bitwidth" : 8, "direction" : "READONLY", "bitSlice":[{"low":0,"up":7,"cElement": [{"cName": "s_axis.V.data.V","cData": "uint8","bit_use": { "low": 0,"up": 7},"cArray": [{"low" : 0,"up" : 0,"step" : 1}]}]}]} , 
 	{ "Name" : "s_axis_V_keep_V", "interface" : "axis", "bitwidth" : 1, "direction" : "READONLY", "bitSlice":[{"low":0,"up":0,"cElement": [{"cName": "s_axis.V.keep.V","cData": "uint1","bit_use": { "low": 0,"up": 0},"cArray": [{"low" : 0,"up" : 0,"step" : 1}]}]}]} , 
 	{ "Name" : "s_axis_V_strb_V", "interface" : "axis", "bitwidth" : 1, "direction" : "READONLY", "bitSlice":[{"low":0,"up":0,"cElement": [{"cName": "s_axis.V.strb.V","cData": "uint1","bit_use": { "low": 0,"up": 0},"cArray": [{"low" : 0,"up" : 0,"step" : 1}]}]}]} , 
 	{ "Name" : "s_axis_V_user_V", "interface" : "axis", "bitwidth" : 1, "direction" : "READONLY", "bitSlice":[{"low":0,"up":0,"cElement": [{"cName": "s_axis.V.user.V","cData": "uint1","bit_use": { "low": 0,"up": 0},"cArray": [{"low" : 0,"up" : 0,"step" : 1}]}]}]} , 
 	{ "Name" : "s_axis_V_last_V", "interface" : "axis", "bitwidth" : 1, "direction" : "READONLY", "bitSlice":[{"low":0,"up":0,"cElement": [{"cName": "s_axis.V.last.V","cData": "uint1","bit_use": { "low": 0,"up": 0},"cArray": [{"low" : 0,"up" : 0,"step" : 1}]}]}]} , 
 	{ "Name" : "s_axis_V_id_V", "interface" : "axis", "bitwidth" : 1, "direction" : "READONLY", "bitSlice":[{"low":0,"up":0,"cElement": [{"cName": "s_axis.V.id.V","cData": "uint1","bit_use": { "low": 0,"up": 0},"cArray": [{"low" : 0,"up" : 0,"step" : 1}]}]}]} , 
 	{ "Name" : "s_axis_V_dest_V", "interface" : "axis", "bitwidth" : 1, "direction" : "READONLY", "bitSlice":[{"low":0,"up":0,"cElement": [{"cName": "s_axis.V.dest.V","cData": "uint1","bit_use": { "low": 0,"up": 0},"cArray": [{"low" : 0,"up" : 0,"step" : 1}]}]}]} , 
 	{ "Name" : "m_axis_V_data_V", "interface" : "axis", "bitwidth" : 8, "direction" : "WRITEONLY", "bitSlice":[{"low":0,"up":7,"cElement": [{"cName": "m_axis.V.data.V","cData": "uint8","bit_use": { "low": 0,"up": 7},"cArray": [{"low" : 0,"up" : 0,"step" : 1}]}]}]} , 
 	{ "Name" : "m_axis_V_keep_V", "interface" : "axis", "bitwidth" : 1, "direction" : "WRITEONLY", "bitSlice":[{"low":0,"up":0,"cElement": [{"cName": "m_axis.V.keep.V","cData": "uint1","bit_use": { "low": 0,"up": 0},"cArray": [{"low" : 0,"up" : 0,"step" : 1}]}]}]} , 
 	{ "Name" : "m_axis_V_strb_V", "interface" : "axis", "bitwidth" : 1, "direction" : "WRITEONLY", "bitSlice":[{"low":0,"up":0,"cElement": [{"cName": "m_axis.V.strb.V","cData": "uint1","bit_use": { "low": 0,"up": 0},"cArray": [{"low" : 0,"up" : 0,"step" : 1}]}]}]} , 
 	{ "Name" : "m_axis_V_user_V", "interface" : "axis", "bitwidth" : 1, "direction" : "WRITEONLY", "bitSlice":[{"low":0,"up":0,"cElement": [{"cName": "m_axis.V.user.V","cData": "uint1","bit_use": { "low": 0,"up": 0},"cArray": [{"low" : 0,"up" : 0,"step" : 1}]}]}]} , 
 	{ "Name" : "m_axis_V_last_V", "interface" : "axis", "bitwidth" : 1, "direction" : "WRITEONLY", "bitSlice":[{"low":0,"up":0,"cElement": [{"cName": "m_axis.V.last.V","cData": "uint1","bit_use": { "low": 0,"up": 0},"cArray": [{"low" : 0,"up" : 0,"step" : 1}]}]}]} , 
 	{ "Name" : "m_axis_V_id_V", "interface" : "axis", "bitwidth" : 1, "direction" : "WRITEONLY", "bitSlice":[{"low":0,"up":0,"cElement": [{"cName": "m_axis.V.id.V","cData": "uint1","bit_use": { "low": 0,"up": 0},"cArray": [{"low" : 0,"up" : 0,"step" : 1}]}]}]} , 
 	{ "Name" : "m_axis_V_dest_V", "interface" : "axis", "bitwidth" : 1, "direction" : "WRITEONLY", "bitSlice":[{"low":0,"up":0,"cElement": [{"cName": "m_axis.V.dest.V","cData": "uint1","bit_use": { "low": 0,"up": 0},"cArray": [{"low" : 0,"up" : 0,"step" : 1}]}]}]} ]}
# RTL Port declarations: 
set portNum 20
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst_n sc_in sc_logic 1 reset -1 active_low_sync } 
	{ s_axis_TDATA sc_in sc_lv 8 signal 0 } 
	{ s_axis_TVALID sc_in sc_logic 1 invld 6 } 
	{ s_axis_TREADY sc_out sc_logic 1 inacc 6 } 
	{ s_axis_TKEEP sc_in sc_lv 1 signal 1 } 
	{ s_axis_TSTRB sc_in sc_lv 1 signal 2 } 
	{ s_axis_TUSER sc_in sc_lv 1 signal 3 } 
	{ s_axis_TLAST sc_in sc_lv 1 signal 4 } 
	{ s_axis_TID sc_in sc_lv 1 signal 5 } 
	{ s_axis_TDEST sc_in sc_lv 1 signal 6 } 
	{ m_axis_TDATA sc_out sc_lv 8 signal 7 } 
	{ m_axis_TVALID sc_out sc_logic 1 outvld 13 } 
	{ m_axis_TREADY sc_in sc_logic 1 outacc 7 } 
	{ m_axis_TKEEP sc_out sc_lv 1 signal 8 } 
	{ m_axis_TSTRB sc_out sc_lv 1 signal 9 } 
	{ m_axis_TUSER sc_out sc_lv 1 signal 10 } 
	{ m_axis_TLAST sc_out sc_lv 1 signal 11 } 
	{ m_axis_TID sc_out sc_lv 1 signal 12 } 
	{ m_axis_TDEST sc_out sc_lv 1 signal 13 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst_n", "role": "default" }} , 
 	{ "name": "s_axis_TDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "s_axis_V_data_V", "role": "default" }} , 
 	{ "name": "s_axis_TVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "invld", "bundle":{"name": "s_axis_V_dest_V", "role": "default" }} , 
 	{ "name": "s_axis_TREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "inacc", "bundle":{"name": "s_axis_V_dest_V", "role": "default" }} , 
 	{ "name": "s_axis_TKEEP", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "s_axis_V_keep_V", "role": "default" }} , 
 	{ "name": "s_axis_TSTRB", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "s_axis_V_strb_V", "role": "default" }} , 
 	{ "name": "s_axis_TUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "s_axis_V_user_V", "role": "default" }} , 
 	{ "name": "s_axis_TLAST", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "s_axis_V_last_V", "role": "default" }} , 
 	{ "name": "s_axis_TID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "s_axis_V_id_V", "role": "default" }} , 
 	{ "name": "s_axis_TDEST", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "s_axis_V_dest_V", "role": "default" }} , 
 	{ "name": "m_axis_TDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "m_axis_V_data_V", "role": "default" }} , 
 	{ "name": "m_axis_TVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "m_axis_V_dest_V", "role": "default" }} , 
 	{ "name": "m_axis_TREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "outacc", "bundle":{"name": "m_axis_V_data_V", "role": "default" }} , 
 	{ "name": "m_axis_TKEEP", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "m_axis_V_keep_V", "role": "default" }} , 
 	{ "name": "m_axis_TSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "m_axis_V_strb_V", "role": "default" }} , 
 	{ "name": "m_axis_TUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "m_axis_V_user_V", "role": "default" }} , 
 	{ "name": "m_axis_TLAST", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "m_axis_V_last_V", "role": "default" }} , 
 	{ "name": "m_axis_TID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "m_axis_V_id_V", "role": "default" }} , 
 	{ "name": "m_axis_TDEST", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "m_axis_V_dest_V", "role": "default" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "",
		"CDFG" : "cubeocc_hls",
		"Protocol" : "ap_ctrl_none",
		"ControlExist" : "0", "ap_start" : "0", "ap_ready" : "0", "ap_done" : "0", "ap_continue" : "0", "ap_idle" : "0",
		"Pipeline" : "Aligned", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "1",
		"VariableLatency" : "0", "ExactLatency" : "1", "EstimateLatencyMin" : "1", "EstimateLatencyMax" : "1",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"Port" : [
			{"Name" : "s_axis_V_data_V", "Type" : "Axis", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "s_axis_TDATA_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "s_axis_V_keep_V", "Type" : "Axis", "Direction" : "I"},
			{"Name" : "s_axis_V_strb_V", "Type" : "Axis", "Direction" : "I"},
			{"Name" : "s_axis_V_user_V", "Type" : "Axis", "Direction" : "I"},
			{"Name" : "s_axis_V_last_V", "Type" : "Axis", "Direction" : "I"},
			{"Name" : "s_axis_V_id_V", "Type" : "Axis", "Direction" : "I"},
			{"Name" : "s_axis_V_dest_V", "Type" : "Axis", "Direction" : "I"},
			{"Name" : "m_axis_V_data_V", "Type" : "Axis", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "m_axis_TDATA_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "m_axis_V_keep_V", "Type" : "Axis", "Direction" : "O"},
			{"Name" : "m_axis_V_strb_V", "Type" : "Axis", "Direction" : "O"},
			{"Name" : "m_axis_V_user_V", "Type" : "Axis", "Direction" : "O"},
			{"Name" : "m_axis_V_last_V", "Type" : "Axis", "Direction" : "O"},
			{"Name" : "m_axis_V_id_V", "Type" : "Axis", "Direction" : "O"},
			{"Name" : "m_axis_V_dest_V", "Type" : "Axis", "Direction" : "O"},
			{"Name" : "row", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "col", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "grid_V_0_0", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "grid_V_0_7", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "grid_V_7_0", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "grid_V_7_7", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "grid_V_0_1", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "frame_active", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "prev_clk_V", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "frame_id", "Type" : "OVld", "Direction" : "IO"}]}]}


set ArgLastReadFirstWriteLatency {
	cubeocc_hls {
		s_axis_V_data_V {Type I LastRead 0 FirstWrite -1}
		s_axis_V_keep_V {Type I LastRead 0 FirstWrite -1}
		s_axis_V_strb_V {Type I LastRead 0 FirstWrite -1}
		s_axis_V_user_V {Type I LastRead 0 FirstWrite -1}
		s_axis_V_last_V {Type I LastRead 0 FirstWrite -1}
		s_axis_V_id_V {Type I LastRead 0 FirstWrite -1}
		s_axis_V_dest_V {Type I LastRead 0 FirstWrite -1}
		m_axis_V_data_V {Type O LastRead -1 FirstWrite 0}
		m_axis_V_keep_V {Type O LastRead -1 FirstWrite 0}
		m_axis_V_strb_V {Type O LastRead -1 FirstWrite 0}
		m_axis_V_user_V {Type O LastRead -1 FirstWrite 0}
		m_axis_V_last_V {Type O LastRead -1 FirstWrite 0}
		m_axis_V_id_V {Type O LastRead -1 FirstWrite 0}
		m_axis_V_dest_V {Type O LastRead -1 FirstWrite 0}
		row {Type IO LastRead -1 FirstWrite -1}
		col {Type IO LastRead -1 FirstWrite -1}
		grid_V_0_0 {Type IO LastRead -1 FirstWrite -1}
		grid_V_0_7 {Type IO LastRead -1 FirstWrite -1}
		grid_V_7_0 {Type IO LastRead -1 FirstWrite -1}
		grid_V_7_7 {Type IO LastRead -1 FirstWrite -1}
		grid_V_0_1 {Type IO LastRead -1 FirstWrite -1}
		frame_active {Type IO LastRead -1 FirstWrite -1}
		prev_clk_V {Type IO LastRead -1 FirstWrite -1}
		frame_id {Type IO LastRead -1 FirstWrite -1}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "1", "Max" : "1"}
	, {"Name" : "Interval", "Min" : "1", "Max" : "1"}
]}

set PipelineEnableSignalInfo {[
	{"Pipeline" : "0", "EnableSignal" : "ap_enable_pp0"}
]}

set Spec2ImplPortList { 
	s_axis_V_data_V { axis {  { s_axis_TDATA in_data 0 8 } } }
	s_axis_V_keep_V { axis {  { s_axis_TKEEP in_data 0 1 } } }
	s_axis_V_strb_V { axis {  { s_axis_TSTRB in_data 0 1 } } }
	s_axis_V_user_V { axis {  { s_axis_TUSER in_data 0 1 } } }
	s_axis_V_last_V { axis {  { s_axis_TLAST in_data 0 1 } } }
	s_axis_V_id_V { axis {  { s_axis_TID in_data 0 1 } } }
	s_axis_V_dest_V { axis {  { s_axis_TVALID in_vld 0 1 }  { s_axis_TREADY in_acc 1 1 }  { s_axis_TDEST in_data 0 1 } } }
	m_axis_V_data_V { axis {  { m_axis_TDATA out_data 1 8 }  { m_axis_TREADY out_acc 0 1 } } }
	m_axis_V_keep_V { axis {  { m_axis_TKEEP out_data 1 1 } } }
	m_axis_V_strb_V { axis {  { m_axis_TSTRB out_data 1 1 } } }
	m_axis_V_user_V { axis {  { m_axis_TUSER out_data 1 1 } } }
	m_axis_V_last_V { axis {  { m_axis_TLAST out_data 1 1 } } }
	m_axis_V_id_V { axis {  { m_axis_TID out_data 1 1 } } }
	m_axis_V_dest_V { axis {  { m_axis_TVALID out_vld 1 1 }  { m_axis_TDEST out_data 1 1 } } }
}

set busDeadlockParameterList { 
}

# RTL port scheduling information:
set fifoSchedulingInfoList { 
}

# RTL bus port read request latency information:
set busReadReqLatencyList { 
}

# RTL bus port write response latency information:
set busWriteResLatencyList { 
}

# RTL array port load latency information:
set memoryLoadLatencyList { 
}
