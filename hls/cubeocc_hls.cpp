#include "cubeocc_hls.h"

#define GRID_W 8
#define GRID_H 8
#define CLK_ROW 0
#define CLK_COL 1
#define THRESHOLD 127

void cubeocc_hls(
    hls::stream<axis_pixel_t> &s_axis,
    hls::stream<axis_pixel_t> &m_axis)
{
#pragma HLS INTERFACE axis port = s_axis
#pragma HLS INTERFACE axis port = m_axis
#pragma HLS INTERFACE ap_ctrl_none port = return
#pragma HLS PIPELINE II = 1

    static int row = 0;
    static int col = 0;
    static ap_uint<8> grid[GRID_H][GRID_W];
#pragma HLS ARRAY_PARTITION variable = grid complete dim = 0

    static bool frame_active = false;
    static ap_uint<1> prev_clk = 0;
    static int frame_id = 0;

    // 177-bit bitstream to hold the 59 cells x 3 bits
    static ap_uint<177> payload_bits = 0;

    axis_pixel_t pix = s_axis.read();

    if (pix.user)
    {
        row = 0;
        col = 0;
    }
    else
    {
        if (pix.last)
        {
            col = 0;
            row++;
        }
        else
        {
            col++;
        }
    }

    if (row < GRID_H && col < GRID_W)
    {
        grid[row][col] = pix.data;
    }

    if (row == GRID_H && col == 0)
    {
        bool tl = grid[0][0] > THRESHOLD;
        bool tr = grid[0][7] > THRESHOLD;
        bool bl = grid[7][0] > THRESHOLD;
        bool br = grid[7][7] > THRESHOLD;
        bool clk_state = grid[CLK_ROW][CLK_COL] > THRESHOLD;

        if (tl && tr && bl && br)
        {
            frame_active = true;
            prev_clk = clk_state;
        }
        else if (tl && tr && bl && !br && !clk_state)
        {
            frame_active = false;
        }
        else if (frame_active)
        {
            if (clk_state != prev_clk)
            {
                // New valid frame detected! Extract the payload.
                frame_id++;
                prev_clk = clk_state;

                payload_bits = 0; // Reset before filling
                int bit_idx = 0;

                // Iterate through all 64 cells
                for (int r = 0; r < GRID_H; r++)
                {
                    for (int c = 0; c < GRID_W; c++)
                    {
                        // Skip the 4 corners and the 1 CLK cell
                        bool is_corner = (r == 0 || r == 7) && (c == 0 || c == 7);
                        bool is_clk = (r == CLK_ROW && c == CLK_COL);

                        if (!is_corner && !is_clk)
                        {
                            ap_uint<8> px = grid[r][c];
                            ap_uint<1> r_bit = (px > THRESHOLD) ? 1 : 0; // Simplified: treat >127 as 1

                            // NOTE: In real RGB, we will extract R, G, B separately.
                            // For Grayscale V1, we just take 1 bit per cell to simulate the symbol.
                            // Later we will upgrade this to 3 bits per cell.
                            payload_bits[bit_idx] = r_bit;
                            bit_idx++;
                        }
                    }
                }
                // Now payload_bits contains the extracted data (up to 59 bits for Grayscale V1).
            }
        }
    }

    m_axis.write(pix);
}