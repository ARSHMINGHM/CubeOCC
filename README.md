# CubeOCC

**CubeOCC** is an FPGA-based optical communication project that encodes and transmits digital data using RGB / ON-OFF cube frames.

The project focuses on designing and simulating the complete communication protocol in HDL, including frame generation, synchronization, payload transmission, error correction, and frame detection.

## Overview

CubeOCC represents data as a grid of illuminated cubes. Each cube can encode information using its state or color.

The initial design uses an **8×8 frame**, giving a total of **64 cubes per frame**.

Each frame contains:

* **4 fixed markers** for orientation and frame detection
* **1 clock marker** used to distinguish consecutive frames
* **59 remaining cubes** for payload and error-correction data

The clock marker is especially useful when two consecutive payload frames would otherwise appear identical.

## Frame Structure

```text
8 × 8 Frame
┌───────────────────────────────┐
│ Fixed markers                │
│                              │
│        Payload / ECC         │
│                              │
│                    Clock     │
└───────────────────────────────┘
```

The exact payload and error-correction layout may evolve as the protocol is developed.

## Transfer Sequence

A transmission consists of three main stages:

```text
START FRAME
     ↓
DATA FRAMES
     ↓
END FRAME
```

### Start Frame

A dedicated bright/white frame acts as the transmission preamble.

It tells the receiver that a new CubeOCC transfer is beginning.

### Data Frames

Data is divided into 8×8 frames containing:

* orientation markers
* clock information
* payload
* error-correction information

### End Frame

A dedicated mostly-black frame indicates that the transmission has finished.

The orientation markers remain visible while the clock and designated end marker are disabled, allowing the receiver to distinguish the end frame from ordinary data.

## FPGA Simulation

The first version of CubeOCC is intended to be implemented and verified entirely through an FPGA testbench.

The simulation will cover:

* frame generation
* start-frame detection
* end-frame detection
* clock handling
* payload encoding
* payload decoding
* error detection/correction
* complete transmission sequences

A simulated button press will be used to start a transmission, making the design easier to adapt to physical FPGA hardware later.

## Project Goals

The main goals of CubeOCC are to:

* Design a reliable optical frame protocol
* Implement the protocol in HDL
* Create an FPGA transmitter and receiver
* Detect frame orientation automatically
* Synchronize consecutive frames
* Add error correction
* Verify the entire system through simulation
* Keep the design suitable for a future physical RGB/LED implementation

## Repository Structure

```text
CubeOCC/
├── rtl/        # HDL modules
├── tb/         # Testbenches
├── sim/        # Simulation files and outputs
├── docs/       # Protocol documentation
└── README.md
```

The directory structure may change as development progresses.

## Status

🚧 **CubeOCC is currently under development.**

The initial phase focuses on defining the frame protocol and implementing the transmitter, receiver, and verification environment.

## Team

CubeOCC is being developed as a **two-person FPGA project**.

