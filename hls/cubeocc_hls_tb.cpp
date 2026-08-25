#include "cubeocc_hls.h"
#include <iostream>

static const int WIDTH = 128;
static const int HEIGHT = 720;
static const int PIXELS = WIDTH * HEIGHT;

int main() {
    hls::stream<axis_pixel_t> in_stream;
    hls::stream<axis_pixel_t> out_stream;

    for (int i = 0; i < PIXELS; i++) {
        axis_pixel_t pix;
        pix.data = i & 0xff;
        pix.keep = 1;
        pix.strb = 1;
        pix.user = (i == 0) ? 1 : 0;
        pix.last = ((i % WIDTH) == (WIDTH - 1)) ? 1 : 0;
        pix.id = 0;
        pix.dest = 0;
        in_stream.write(pix);
    }

    for (int i = 0; i < PIXELS; i++) {
        cubeocc_hls(in_stream, out_stream);
    }

    int sof_count = 0;
    int line_count = 0;
    int mismatch_count = 0;

    for (int i = 0; i < PIXELS; i++) {
        axis_pixel_t pix = out_stream.read();
        ap_uint<8> expected = i & 0xff;

        if (pix.data != expected) {
            mismatch_count++;
        }
        if (pix.user) {
            sof_count++;
        }
        if (pix.last) {
            line_count++;
        }
    }

    if (mismatch_count == 0 && sof_count == 1 && line_count == HEIGHT) {
        std::cout << "C/RTL-ready HLS test PASS" << std::endl;
        return 0;
    }

    std::cout << "HLS test FAIL: mismatches=" << mismatch_count
              << " sof_count=" << sof_count
              << " line_count=" << line_count << std::endl;
    return 1;
}
