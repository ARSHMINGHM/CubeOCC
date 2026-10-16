@echo off
setlocal
cd /d "%~dp0"
set "VIVADO_BIN=X:\xilinx\Vivado\2019.1\bin"

call "%VIVADO_BIN%\xvlog.bat" -sv rtl\uart_tx_byte.sv rtl\cubeocc_uart_frame_streamer.sv tb\cubeocc_uart_stream_tb.sv
if errorlevel 1 exit /b 1

call "%VIVADO_BIN%\xelab.bat" cubeocc_uart_stream_tb -s uart_stream_behav
if errorlevel 1 exit /b 1

call "%VIVADO_BIN%\xsim.bat" uart_stream_behav -runall
exit /b %errorlevel%
