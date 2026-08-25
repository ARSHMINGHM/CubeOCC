// ==============================================================
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2019.1 (64-bit)
// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef __linux__

#include "xstatus.h"
#include "xparameters.h"
#include "xcubeocc_hls.h"

extern XCubeocc_hls_Config XCubeocc_hls_ConfigTable[];

XCubeocc_hls_Config *XCubeocc_hls_LookupConfig(u16 DeviceId) {
	XCubeocc_hls_Config *ConfigPtr = NULL;

	int Index;

	for (Index = 0; Index < XPAR_XCUBEOCC_HLS_NUM_INSTANCES; Index++) {
		if (XCubeocc_hls_ConfigTable[Index].DeviceId == DeviceId) {
			ConfigPtr = &XCubeocc_hls_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XCubeocc_hls_Initialize(XCubeocc_hls *InstancePtr, u16 DeviceId) {
	XCubeocc_hls_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XCubeocc_hls_LookupConfig(DeviceId);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XCubeocc_hls_CfgInitialize(InstancePtr, ConfigPtr);
}

#endif

