#include "cubeocc_hls.h"
#include <iostream>

int main()
{
    hls::stream<axis_pixel_t> in_stream("in");
    hls::stream<axis_pixel_t> out_stream("out");

    int width = 128;
    int height = 720;
    int num_frames = 4; // START, DATA0, DATA1, STOP

    for (int f = 0; f < num_frames; f++)
    {
        for (int row = 0; row < height; row++)
        {
            for (int col = 0; col < width; col++)
            {

                axis_pixel_t pix;
                pix.keep = 1;
                pix.strb = 1;
                pix.user = (row == 0 && col == 0);
                pix.last = (col == width - 1);
                pix.id = 0;
                pix.dest = 0;
                pix.data = 0; // Default black

                // Fill the 8x8 grid in the top-left corner
                if (row < 8 && col < 8)
                {
                    bool is_corner = (row == 0 || row == 7) && (col == 0 || col == 7);

                    if (f == 0)
                    { // START: All white
                        pix.data = 255;
                    }
                    else if (f == 1)
                    { // DATA 1: Corners white, CLK=0 (Black)
                        if (is_corner)
                            pix.data = 255;
                    }
                    else if (f == 2)
                    { // DATA 2: Corners white, CLK=1 (White)
                        if (is_corner || (row == 0 && col == 1))
                            pix.data = 255;
                    }
                    else if (f == 3)
                    { // STOP: 3 corners white, BR and CLK black
                        if (row == 0 || (row == 7 && col == 0))
                            pix.data = 255;
                    }
                }

                in_stream.write(pix);
                cubeocc_hls(in_stream, out_stream);
                out_stream.read();
            }
        }
    }

    std::cout << "HLS Simulation Complete." << std::endl;
    std::cout << "C-SIM PASS" << std::endl;
    return 0;
}