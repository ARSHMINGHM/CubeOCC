// ==============================================================
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2019.1 (64-bit)
// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef XCUBEOCC_HLS_H
#define XCUBEOCC_HLS_H

#ifdef __cplusplus
extern "C" {
#endif

/***************************** Include Files *********************************/
#ifndef __linux__
#include "xil_types.h"
#include "xil_assert.h"
#include "xstatus.h"
#include "xil_io.h"
#else
#include <stdint.h>
#include <assert.h>
#include <dirent.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
#include <stddef.h>
#endif
#include "xcubeocc_hls_hw.h"

/**************************** Type Definitions ******************************/
#ifdef __linux__
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
#else
typedef struct {
    u16 DeviceId;
    u32 Ctrl_BaseAddress;
} XCubeocc_hls_Config;
#endif

typedef struct {
    u32 Ctrl_BaseAddress;
    u32 IsReady;
} XCubeocc_hls;

/***************** Macros (Inline Functions) Definitions *********************/
#ifndef __linux__
#define XCubeocc_hls_WriteReg(BaseAddress, RegOffset, Data) \
    Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))
#define XCubeocc_hls_ReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))
#else
#define XCubeocc_hls_WriteReg(BaseAddress, RegOffset, Data) \
    *(volatile u32*)((BaseAddress) + (RegOffset)) = (u32)(Data)
#define XCubeocc_hls_ReadReg(BaseAddress, RegOffset) \
    *(volatile u32*)((BaseAddress) + (RegOffset))

#define Xil_AssertVoid(expr)    assert(expr)
#define Xil_AssertNonvoid(expr) assert(expr)

#define XST_SUCCESS             0
#define XST_DEVICE_NOT_FOUND    2
#define XST_OPEN_DEVICE_FAILED  3
#define XIL_COMPONENT_IS_READY  1
#endif

/************************** Function Prototypes *****************************/
#ifndef __linux__
int XCubeocc_hls_Initialize(XCubeocc_hls *InstancePtr, u16 DeviceId);
XCubeocc_hls_Config* XCubeocc_hls_LookupConfig(u16 DeviceId);
int XCubeocc_hls_CfgInitialize(XCubeocc_hls *InstancePtr, XCubeocc_hls_Config *ConfigPtr);
#else
int XCubeocc_hls_Initialize(XCubeocc_hls *InstancePtr, const char* InstanceName);
int XCubeocc_hls_Release(XCubeocc_hls *InstancePtr);
#endif

void XCubeocc_hls_Start(XCubeocc_hls *InstancePtr);
u32 XCubeocc_hls_IsDone(XCubeocc_hls *InstancePtr);
u32 XCubeocc_hls_IsIdle(XCubeocc_hls *InstancePtr);
u32 XCubeocc_hls_IsReady(XCubeocc_hls *InstancePtr);
void XCubeocc_hls_EnableAutoRestart(XCubeocc_hls *InstancePtr);
void XCubeocc_hls_DisableAutoRestart(XCubeocc_hls *InstancePtr);

void XCubeocc_hls_Set_pixel_count(XCubeocc_hls *InstancePtr, u32 Data);
u32 XCubeocc_hls_Get_pixel_count(XCubeocc_hls *InstancePtr);
void XCubeocc_hls_Set_threshold_V(XCubeocc_hls *InstancePtr, u32 Data);
u32 XCubeocc_hls_Get_threshold_V(XCubeocc_hls *InstancePtr);
void XCubeocc_hls_Set_threshold_enable(XCubeocc_hls *InstancePtr, u32 Data);
u32 XCubeocc_hls_Get_threshold_enable(XCubeocc_hls *InstancePtr);

void XCubeocc_hls_InterruptGlobalEnable(XCubeocc_hls *InstancePtr);
void XCubeocc_hls_InterruptGlobalDisable(XCubeocc_hls *InstancePtr);
void XCubeocc_hls_InterruptEnable(XCubeocc_hls *InstancePtr, u32 Mask);
void XCubeocc_hls_InterruptDisable(XCubeocc_hls *InstancePtr, u32 Mask);
void XCubeocc_hls_InterruptClear(XCubeocc_hls *InstancePtr, u32 Mask);
u32 XCubeocc_hls_InterruptGetEnabled(XCubeocc_hls *InstancePtr);
u32 XCubeocc_hls_InterruptGetStatus(XCubeocc_hls *InstancePtr);

#ifdef __cplusplus
}
#endif

#endif
