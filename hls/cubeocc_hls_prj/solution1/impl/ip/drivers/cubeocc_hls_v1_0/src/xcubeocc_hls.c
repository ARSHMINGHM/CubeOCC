// ==============================================================
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2019.1 (64-bit)
// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// ==============================================================
/***************************** Include Files *********************************/
#include "xcubeocc_hls.h"

/************************** Function Implementation *************************/
#ifndef __linux__
int XCubeocc_hls_CfgInitialize(XCubeocc_hls *InstancePtr, XCubeocc_hls_Config *ConfigPtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(ConfigPtr != NULL);

    InstancePtr->Ctrl_BaseAddress = ConfigPtr->Ctrl_BaseAddress;
    InstancePtr->IsReady = XIL_COMPONENT_IS_READY;

    return XST_SUCCESS;
}
#endif

void XCubeocc_hls_Start(XCubeocc_hls *InstancePtr) {
    u32 Data;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XCubeocc_hls_ReadReg(InstancePtr->Ctrl_BaseAddress, XCUBEOCC_HLS_CTRL_ADDR_AP_CTRL) & 0x80;
    XCubeocc_hls_WriteReg(InstancePtr->Ctrl_BaseAddress, XCUBEOCC_HLS_CTRL_ADDR_AP_CTRL, Data | 0x01);
}

u32 XCubeocc_hls_IsDone(XCubeocc_hls *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XCubeocc_hls_ReadReg(InstancePtr->Ctrl_BaseAddress, XCUBEOCC_HLS_CTRL_ADDR_AP_CTRL);
    return (Data >> 1) & 0x1;
}

u32 XCubeocc_hls_IsIdle(XCubeocc_hls *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XCubeocc_hls_ReadReg(InstancePtr->Ctrl_BaseAddress, XCUBEOCC_HLS_CTRL_ADDR_AP_CTRL);
    return (Data >> 2) & 0x1;
}

u32 XCubeocc_hls_IsReady(XCubeocc_hls *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XCubeocc_hls_ReadReg(InstancePtr->Ctrl_BaseAddress, XCUBEOCC_HLS_CTRL_ADDR_AP_CTRL);
    // check ap_start to see if the pcore is ready for next input
    return !(Data & 0x1);
}

void XCubeocc_hls_EnableAutoRestart(XCubeocc_hls *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XCubeocc_hls_WriteReg(InstancePtr->Ctrl_BaseAddress, XCUBEOCC_HLS_CTRL_ADDR_AP_CTRL, 0x80);
}

void XCubeocc_hls_DisableAutoRestart(XCubeocc_hls *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XCubeocc_hls_WriteReg(InstancePtr->Ctrl_BaseAddress, XCUBEOCC_HLS_CTRL_ADDR_AP_CTRL, 0);
}

void XCubeocc_hls_Set_pixel_count(XCubeocc_hls *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XCubeocc_hls_WriteReg(InstancePtr->Ctrl_BaseAddress, XCUBEOCC_HLS_CTRL_ADDR_PIXEL_COUNT_DATA, Data);
}

u32 XCubeocc_hls_Get_pixel_count(XCubeocc_hls *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XCubeocc_hls_ReadReg(InstancePtr->Ctrl_BaseAddress, XCUBEOCC_HLS_CTRL_ADDR_PIXEL_COUNT_DATA);
    return Data;
}

void XCubeocc_hls_Set_threshold_V(XCubeocc_hls *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XCubeocc_hls_WriteReg(InstancePtr->Ctrl_BaseAddress, XCUBEOCC_HLS_CTRL_ADDR_THRESHOLD_V_DATA, Data);
}

u32 XCubeocc_hls_Get_threshold_V(XCubeocc_hls *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XCubeocc_hls_ReadReg(InstancePtr->Ctrl_BaseAddress, XCUBEOCC_HLS_CTRL_ADDR_THRESHOLD_V_DATA);
    return Data;
}

void XCubeocc_hls_Set_threshold_enable(XCubeocc_hls *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XCubeocc_hls_WriteReg(InstancePtr->Ctrl_BaseAddress, XCUBEOCC_HLS_CTRL_ADDR_THRESHOLD_ENABLE_DATA, Data);
}

u32 XCubeocc_hls_Get_threshold_enable(XCubeocc_hls *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XCubeocc_hls_ReadReg(InstancePtr->Ctrl_BaseAddress, XCUBEOCC_HLS_CTRL_ADDR_THRESHOLD_ENABLE_DATA);
    return Data;
}

void XCubeocc_hls_InterruptGlobalEnable(XCubeocc_hls *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XCubeocc_hls_WriteReg(InstancePtr->Ctrl_BaseAddress, XCUBEOCC_HLS_CTRL_ADDR_GIE, 1);
}

void XCubeocc_hls_InterruptGlobalDisable(XCubeocc_hls *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XCubeocc_hls_WriteReg(InstancePtr->Ctrl_BaseAddress, XCUBEOCC_HLS_CTRL_ADDR_GIE, 0);
}

void XCubeocc_hls_InterruptEnable(XCubeocc_hls *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XCubeocc_hls_ReadReg(InstancePtr->Ctrl_BaseAddress, XCUBEOCC_HLS_CTRL_ADDR_IER);
    XCubeocc_hls_WriteReg(InstancePtr->Ctrl_BaseAddress, XCUBEOCC_HLS_CTRL_ADDR_IER, Register | Mask);
}

void XCubeocc_hls_InterruptDisable(XCubeocc_hls *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XCubeocc_hls_ReadReg(InstancePtr->Ctrl_BaseAddress, XCUBEOCC_HLS_CTRL_ADDR_IER);
    XCubeocc_hls_WriteReg(InstancePtr->Ctrl_BaseAddress, XCUBEOCC_HLS_CTRL_ADDR_IER, Register & (~Mask));
}

void XCubeocc_hls_InterruptClear(XCubeocc_hls *InstancePtr, u32 Mask) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XCubeocc_hls_WriteReg(InstancePtr->Ctrl_BaseAddress, XCUBEOCC_HLS_CTRL_ADDR_ISR, Mask);
}

u32 XCubeocc_hls_InterruptGetEnabled(XCubeocc_hls *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XCubeocc_hls_ReadReg(InstancePtr->Ctrl_BaseAddress, XCUBEOCC_HLS_CTRL_ADDR_IER);
}

u32 XCubeocc_hls_InterruptGetStatus(XCubeocc_hls *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XCubeocc_hls_ReadReg(InstancePtr->Ctrl_BaseAddress, XCUBEOCC_HLS_CTRL_ADDR_ISR);
}

