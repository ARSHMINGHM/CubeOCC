#include "cubeocc_hls.h"

void cubeocc_hls(
    hls::stream<axis_pixel_t> &s_axis,
    hls::stream<axis_pixel_t> &m_axis
) {
#pragma HLS INTERFACE axis port=s_axis
#pragma HLS INTERFACE axis port=m_axis
#pragma HLS INTERFACE ap_ctrl_none port=return
#pragma HLS PIPELINE II=1

    axis_pixel_t pix = s_axis.read();
    m_axis.write(pix);
}
