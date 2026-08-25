//------------------------------------------------------------------------
// camera_regs_pkg.sv
// Updated to match OV5640 Datasheet Register Map for Windowing (ROI)
//------------------------------------------------------------------------
package camera_regs_pkg;

  // Using 16-bit addresses to match OV5640 SCCB/I2C protocol
  typedef enum logic [15:0] {
    REG_STREAM_ENABLE = 16'h3008, // System reset / power down (Placeholder for stream enable)
    REG_ROI_HSTART    = 16'h3800, // Horizontal start (HSTART)
    REG_ROI_VSTART    = 16'h3802, // Vertical start (VSTART)
    REG_ROI_HSIZE     = 16'h3804, // Horizontal size (Width)
    REG_ROI_VSIZE     = 16'h3806  // Vertical size (Height)
  } camera_reg_addr_e;

  // REG_FRAME_STATUS bit map
  localparam int FS_FRAME_ACTIVE = 0;
  localparam int FS_LINE_ACTIVE  = 1;
  localparam int FS_STREAMING    = 2;

  // Simple synchronous test-pattern generator
  function automatic logic [7:0] test_pixel(input int row, input int col);
    test_pixel = (row[7:0] ^ col[7:0]) + 8'd1;
  endfunction

endpackage : camera_regs_pkg