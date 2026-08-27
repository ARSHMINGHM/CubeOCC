#ifndef CUBEOCC_HLS_H
#define CUBEOCC_HLS_H

#include <ap_axi_sdata.h>
#include <ap_int.h>
#include <hls_stream.h>

typedef ap_axiu<8, 1, 1, 1> axis_pixel_t;

void cubeocc_hls(
    hls::stream<axis_pixel_t> &s_axis,
    hls::stream<axis_pixel_t> &m_axis);

#endif