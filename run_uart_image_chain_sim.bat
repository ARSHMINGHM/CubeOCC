@echo off
setlocal
cd /d "%~dp0"
set "VIVADO_BIN=X:\xilinx\Vivado\2019.1\bin"

call "%VIVADO_BIN%\xvlog.bat" -sv -i rtl ^
  rtl\roi_start_detector.sv ^
  rtl\projective_warp_160x120.sv ^
  rtl\grayscale_grid_8x8.sv ^
  rtl\grid_corner_frame_guard.sv ^
  rtl\roi_warp_grid_pipeline.sv ^
  rtl\directional_dual_polynomial_sampler.sv ^
  rtl\cubeocc_dual_classifier_top.sv ^
  rtl\uart_tx_byte.sv ^
  rtl\cubeocc_uart_frame_streamer.sv ^
  rtl\cubeocc_uart_stream_top.sv ^
  tb\cubeocc_uart_image_chain_tb.sv
if errorlevel 1 exit /b 1

call "%VIVADO_BIN%\xelab.bat" cubeocc_uart_image_chain_tb -s uart_image_chain_behav
if errorlevel 1 exit /b 1

call "%VIVADO_BIN%\xsim.bat" uart_image_chain_behav -runall
exit /b %errorlevel%
