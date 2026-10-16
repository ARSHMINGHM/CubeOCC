---
project: CubeOCC
type: fpga-output
status: implemented
last_reviewed: 2026-10-16
---

# FPGA UART Output and Simulation Decoder

## Purpose

Close the grayscale receiver path by sending classified optical frames out of
the FPGA through one serial pin:

```text
camera pixels
-> RTL ROI
-> RTL projective warp
-> RTL 8x8 grid
-> selected directional SVM
-> 64 classified cells + frame kind
-> UART packet
-> one uart_tx pin
-> simulation or PC decoder
-> recovered payload bits/message
```

The FPGA does not perform file reconstruction or ECC decoding here. It sends
the recovered frame word and metadata. Decoding remains outside the FPGA, as
requested.

## Why UART instead of native USB

`uart_tx` is a normal 3.3 V FPGA output pin using UART 8-N-1. For physical use,
connect it to either:

- the board's built-in USB-to-UART bridge RX input, if available; or
- an external 3.3 V USB-to-UART adapter RX input, with common ground.

Do not connect `uart_tx` directly to USB D+ or D-. Native USB requires a USB PHY
and protocol controller. Also do not connect it to old bipolar RS-232 voltage
levels without a level converter.

The XDC package pin is board-specific and is intentionally not guessed. Add the
real board pin before physical implementation:

```tcl
set_property PACKAGE_PIN <BOARD_UART_RX_PIN> [get_ports uart_tx]
set_property IOSTANDARD LVCMOS33 [get_ports uart_tx]
```

## FPGA top and model selection

The compact output top is:

```text
rtl/cubeocc_uart_stream_top.sv
```

Its only external result output is `uart_tx`; the large classifier debug buses
and internal status signals are not exposed as FPGA pins.

Choose the classifier at synthesis time:

| `CLASSIFIER_MODEL` | Model | Measured grouped-CV error |
|---:|---|---:|
| 1 | `old_poly` directional degree-2 SVM | 0.7181% |
| 2 | `pca30_fused` directional degree-2 SVM | 0.6201% |

Example:

```tcl
set_property top cubeocc_uart_stream_top [get_filesets sources_1]
set_property generic {CLASSIFIER_MODEL=2 CLOCK_HZ=100000000 UART_BAUD=115200} [get_filesets sources_1]
update_compile_order -fileset sources_1
```

Then add the board XDC, reset Synthesis, and rebuild Implementation and the
bitstream. `CLASSIFIER_MODEL=2` is the recommended current experiment.

The easiest Vivado Tcl Console commands are:

```tcl
# UART output with the 0.7181% old polynomial model
source C:/Users/arshm/Desktop/CubeOCC/vivado/use_uart_old_poly.tcl

# UART output with the 0.6201% PCA30-fused model
source C:/Users/arshm/Desktop/CubeOCC/vivado/use_uart_pca30_fused.tcl
```

These scripts add missing RTL sources, select `cubeocc_uart_stream_top`, and set
the clock, baud rate, and classifier generic. They do not guess the board pin;
the correct XDC is still required.

## UART packet format

Every classifier result becomes one fixed 15-byte packet. UART adds one start
and one stop bit around every byte.

| Byte | Meaning |
|---:|---|
| 0 | sync `0xA5` |
| 1 | sync `0x5A` |
| 2 | packet version `1` |
| 3 | model ID: `1=old_poly`, `2=pca30_fused` |
| 4 | UART packet sequence, modulo 256 |
| 5 | frame kind |
| 6..13 | classified 64-cell word, most-significant byte first |
| 14 | XOR of bytes 2 through 13 |

Frame kinds are inherited from the classifier:

| Kind | Meaning |
|---:|---|
| 0 | ignored/unknown |
| 1 | START |
| 2 | DATA |
| 3 | END |
| 4 | discarded frame diagnostic |

The UART sequence checks lost UART packets. It is separate from the optical CLK
cell at row 0, column 1.

## Simulation decoder behavior

`tb/cubeocc_uart_stream_tb.sv` acts like the external receiver. It:

1. sends classified START, DATA, and END words into the UART packetizer;
2. samples the serialized `uart_tx` waveform using UART 8-N-1 timing;
3. finds and validates packet headers;
4. checks sequence, model ID, frame kind, and XOR checksum;
5. rebuilds the 64-cell DATA word;
6. removes TL, TR, BL, BR, and CLK cells;
7. reads the remaining 59 payload bits in row-major order;
8. reconstructs the message `CubeOCC`.

Current result:

```text
UART_STREAM_RESULT packets=3 message=CubeOCC failures=0
```

No decoder is instantiated in the FPGA RTL.

There is also a real-image integration regression. It replays the first 13
monitor-capture frames through ROI, warp, grid, PCA30-fused classification, and
the physical UART waveform. The external testbench decoder checks every packet
against the previously verified classifier words:

```text
UART_IMAGE_CHAIN_RESULT frames=13 packets=13 mismatches=0
```

Run it with:

```powershell
./run_uart_image_chain_sim.bat
```

This integration test uses the existing
`sim/dual_classifier_top_smoke/frame_list.txt` real-image list.

## Run the simulation

From Command Prompt or PowerShell in the repository root:

```powershell
./run_uart_stream_sim.bat
```

This avoids PowerShell execution-policy problems because it is a `.bat` file.
The success line must report `failures=0`.

Manual Vivado commands are:

```powershell
X:\xilinx\Vivado\2019.1\bin\xvlog.bat -sv `
  rtl\uart_tx_byte.sv `
  rtl\cubeocc_uart_frame_streamer.sv `
  tb\cubeocc_uart_stream_tb.sv

X:\xilinx\Vivado\2019.1\bin\xelab.bat `
  cubeocc_uart_stream_tb -s uart_stream_behav

X:\xilinx\Vivado\2019.1\bin\xsim.bat uart_stream_behav -runall
```

## Throughput

At 115,200 baud:

```text
15 bytes x 10 UART bits = 150 wire bits per classified frame
150 / 115200 = 1.3021 ms per packet
maximum UART capacity = about 768 classified frames/s
```

This is comfortably above 30 or 60 camera frames/s. At 60 FPS, grayscale DATA
still carries `59 x 60 = 3,540` optical coded payload bits/s before ECC and
padding. UART is transporting the complete classified frame plus diagnostics,
so it is not the bottleneck at these frame rates.

The internal `uart_overflow` flag is sticky. It becomes high if another
classifier result arrives while the one-packet queue is occupied. It remains
available for simulation or a future status-register/ILA wrapper, but it is not
another physical top-level pin. It should remain low at 30/60 FPS and 115,200
baud.

## Measured Vivado resources

Device: `xc7a35tcpg236-1`, Vivado 2019.1, 10 ns out-of-context clock.

| Design | LUT | FF | BRAM | DSP | WNS |
|---|---:|---:|---:|---:|---:|
| UART packetizer only | 81 | 122 | 0 | 0 | +6.425 ns |
| Full UART top, `old_poly` | 9,636 | 5,295 | 8 | 16 | -11.808 ns |
| Full UART top, `pca30_fused` | 9,634 | 5,293 | 8 | 16 | -11.808 ns |

Relative to the corresponding non-UART tops, UART adds 61-65 LUT and 98-102 FF
after full-top optimization, with no BRAM or DSP increase.

The packetizer itself meets 100 MHz. The full top still fails the 100 MHz
constraint because the unchanged projective warp has the existing 21.753 ns
critical path. UART is not the timing bottleneck.

Regenerate reports with:

```powershell
X:\xilinx\Vivado\2019.1\bin\vivado.bat -mode batch `
  -source vivado\report_uart_stream_resources.tcl -nojournal -nolog
```

Compact tracked results are in
`rtl/generated/uart_stream_resource_summary.json`.

## Files

- `rtl/uart_tx_byte.sv`: one-byte UART 8-N-1 transmitter
- `rtl/cubeocc_uart_frame_streamer.sv`: 15-byte packet builder and queue
- `rtl/cubeocc_uart_stream_top.sv`: camera/classifier/UART integration top
- `tb/cubeocc_uart_stream_tb.sv`: external simulation receiver and decoder
- `tb/cubeocc_uart_image_chain_tb.sv`: 13-frame real-image UART regression
- `run_uart_stream_sim.bat`: one-command regression
- `run_uart_image_chain_sim.bat`: complete real-image chain regression
- `vivado/report_uart_stream_resources.tcl`: synthesis reports

## Related notes

- [[03_FRAME_AND_LINK_PROTOCOL]]
- [[07_03_SENDER_FRAME_MAPPING]]
- [[15_24_DUAL_POLYNOMIAL_FPGA_CLASSIFIERS]]
