`timescale 1ns/1ps

// Linear per-cell decision for the V1 grayscale protocol (no divider, no frame buffer).
//
// For every cell the sampler accumulates the 81 pixels of the circular sampling
// region (dist_sq <= 25), as before. At frame end each of the 64 integer sums S
// is classified with a rule found by cross-validated training (dataset/
// export_linear_rule.py, model "I"):
//
//   score = WC * S_cell  +  WN[n] * (sum of the S of the n neighbours)
//                        +  WW * (S_TL + S_TR + S_BL + S_BR)
//   bit   = score > 0                      n = 2 (grid corner), 3 (edge), 4 (interior)
//
// The 1/81, 1/n and 1/4 of the means are folded into the constants, so the rule
// needs only integer multiplies and adds. The four corner markers are white in
// every DATA frame by protocol and are forced to 1; they only feed the white
// reference. START / END frames are decided by grid_corner_frame_guard (corner
// based) and emitted as their protocol patterns; m_axis_tuser tells what the
// frame was.
//
// Timing: classification runs after grid_frame_done and takes 8 cycles per cell
// (about 530 cycles). The warp cannot start the next output frame earlier than
// one input frame time (>= 19,000 cycles), so the 64 sums are not overwritten;
// if pixels ever arrive while busy, `overrun` is set (sticky) and they are dropped.
//
// Simulation-only compatibility: `state` and `dynamic_thresh` keep the names read
// by cubeocc_top_image_tb.sv. state: 0 = accumulating, 1 = classifying.
// dynamic_thresh: mean white level of the 4 corners for the last frame (logging).
module linear_rule_sampler #(
    parameter signed [11:0] WC  = 12'sd2047,
    parameter signed [11:0] WN2 = -12'sd354,
    parameter signed [11:0] WN3 = -12'sd236,
    parameter signed [11:0] WN4 = -12'sd177,
    parameter signed [11:0] WW  = -12'sd278
)(
    input  logic       clk,
    input  logic       rst_n,

    input  logic       grid_pixel_valid,
    input  logic [7:0] grid_pixel_gray,
    input  logic [5:0] grid_cell,
    input  logic [2:0] grid_col,
    input  logic [2:0] grid_row,
    input  logic [9:0] grid_pixel_x,
    input  logic [9:0] grid_pixel_y,
    input  logic       grid_frame_done,
    input  logic       roi_valid,

    // grid_corner_frame_guard decisions for the same frame (pulses one clock
    // after grid_frame_done, well before the classification finishes)
    input  logic       guard_frame_checked,
    input  logic       guard_start,
    input  logic       guard_data_valid,
    input  logic       guard_end,
    input  logic       guard_discarded,

    output logic        m_axis_tvalid,
    input  logic        m_axis_tready,
    output logic [63:0] m_axis_tdata,
    output logic        m_axis_tlast,
    output logic [2:0]  m_axis_tuser     // 0 ignored, 1 START, 2 DATA, 3 END, 4 discarded DATA
);
    localparam [2:0] M_IDLE       = 3'd0;
    localparam [2:0] M_CORNER     = 3'd1;
    localparam [2:0] M_CORNER_MUL = 3'd2;
    localparam [2:0] M_CELL       = 3'd3;
    localparam [2:0] M_FINISH     = 3'd4;

    localparam [63:0] START_WORD = 64'hFFFF_FFFF_FFFF_FFFF;
    localparam [63:0] END_WORD   = 64'h0100_0000_0000_0081;   // TL, TR, BL white; BR off

    logic [14:0] sum_acc [0:63];            // 81 * 255 = 20655 < 2^15

    logic [2:0]  mode;
    logic [2:0]  ph;
    logic [5:0]  cidx;
    logic [14:0] s_c;
    logic [16:0] nb_acc;
    logic [16:0] corner_sum;
    logic signed [31:0] corner_term;
    logic signed [31:0] prod_c;
    logic signed [31:0] prod_n;
    logic signed [31:0] score;
    logic [63:0] work;

    logic        lat_start, lat_data, lat_end, lat_disc;
    logic        overrun;
    logic        valid_out;
    logic [63:0] symbols_reg;
    logic [2:0]  kind_reg;
    logic [15:0] dynamic_thresh;
    logic [1:0]  state;

    // circular sampling region inside the 20 x 15 cell (centre 10, 7)
    logic [9:0]  col_origin;
    logic [9:0]  row_origin;
    logic [4:0]  lx;
    logic [3:0]  ly;
    logic [4:0]  abs_dx;
    logic [3:0]  abs_dy;
    logic [11:0] dist_sq;

    assign col_origin = grid_col * 10'd20;
    assign row_origin = grid_row * 10'd15;
    assign lx = (grid_pixel_x - col_origin) & 5'h1f;
    assign ly = (grid_pixel_y - row_origin) & 4'h0f;
    assign abs_dx = (lx >= 5'd10) ? (lx - 5'd10) : (5'd10 - lx);
    assign abs_dy = (ly >= 4'd7)  ? (ly - 4'd7)  : (4'd7 - ly);
    assign dist_sq = (abs_dx * abs_dx) + (abs_dy * abs_dy);

    // neighbour structure of the cell being classified
    logic [2:0] cr, cc;
    logic       v_up, v_dn, v_lf, v_rt;
    logic [2:0] n_nb;
    logic signed [11:0] wn_sel;
    logic       cell_is_corner;

    assign cr = cidx[5:3];
    assign cc = cidx[2:0];
    assign v_up = (cr != 3'd0);
    assign v_dn = (cr != 3'd7);
    assign v_lf = (cc != 3'd0);
    assign v_rt = (cc != 3'd7);
    assign n_nb = {2'b00, v_up} + {2'b00, v_dn} + {2'b00, v_lf} + {2'b00, v_rt};
    assign wn_sel = (n_nb == 3'd2) ? WN2 : ((n_nb == 3'd3) ? WN3 : WN4);
    assign cell_is_corner = (cidx == 6'd0) || (cidx == 6'd7) || (cidx == 6'd56) || (cidx == 6'd63);

    assign state = (mode == M_IDLE) ? 2'd0 : 2'd1;

    integer i;
    always @(posedge clk) begin
        if (!rst_n) begin
            mode <= M_IDLE;
            ph <= 3'd0;
            cidx <= 6'd0;
            s_c <= 15'd0;
            nb_acc <= 17'd0;
            corner_sum <= 17'd0;
            corner_term <= 32'sd0;
            prod_c <= 32'sd0;
            prod_n <= 32'sd0;
            score <= 32'sd0;
            work <= 64'd0;
            lat_start <= 1'b0; lat_data <= 1'b0; lat_end <= 1'b0; lat_disc <= 1'b0;
            overrun <= 1'b0;
            valid_out <= 1'b0;
            symbols_reg <= 64'd0;
            kind_reg <= 3'd0;
            dynamic_thresh <= 16'd0;
            for (i = 0; i < 64; i = i + 1) sum_acc[i] <= 15'd0;
        end else begin
            if (valid_out && m_axis_tready) valid_out <= 1'b0;

            // remember what the guard decided for the frame being classified
            if (guard_frame_checked) begin
                lat_start <= guard_start;
                lat_data  <= guard_data_valid;
                lat_end   <= guard_end;
                lat_disc  <= guard_discarded;
            end

            // per-cell circular accumulation (blocked while classifying)
            if (grid_pixel_valid && roi_valid && (dist_sq <= 12'd25)) begin
                if (mode == M_IDLE)
                    sum_acc[grid_cell] <= sum_acc[grid_cell] + grid_pixel_gray;
                else
                    overrun <= 1'b1;
            end

            case (mode)
                M_IDLE: begin
                    if (grid_frame_done) mode <= M_CORNER;
                end

                M_CORNER: begin
                    corner_sum <= {2'b00, sum_acc[0]} + {2'b00, sum_acc[7]}
                                + {2'b00, sum_acc[56]} + {2'b00, sum_acc[63]};
                    mode <= M_CORNER_MUL;
                end

                M_CORNER_MUL: begin
                    corner_term <= $signed(WW) * $signed({1'b0, corner_sum});
                    // corner_sum / 324 (4 corners x 81 pixels), logging only
                    dynamic_thresh <= ({8'b0, corner_sum} * 25'd202) >> 16;
                    cidx <= 6'd0;
                    ph <= 3'd0;
                    mode <= M_CELL;
                end

                M_CELL: begin
                    case (ph)
                        3'd0: begin
                            s_c <= sum_acc[cidx];
                            nb_acc <= 17'd0;
                            ph <= 3'd1;
                        end
                        3'd1: begin
                            if (v_up) nb_acc <= nb_acc + {2'b00, sum_acc[cidx - 6'd8]};
                            ph <= 3'd2;
                        end
                        3'd2: begin
                            if (v_dn) nb_acc <= nb_acc + {2'b00, sum_acc[cidx + 6'd8]};
                            ph <= 3'd3;
                        end
                        3'd3: begin
                            if (v_lf) nb_acc <= nb_acc + {2'b00, sum_acc[cidx - 6'd1]};
                            ph <= 3'd4;
                        end
                        3'd4: begin
                            if (v_rt) nb_acc <= nb_acc + {2'b00, sum_acc[cidx + 6'd1]};
                            ph <= 3'd5;
                        end
                        3'd5: begin
                            prod_c <= $signed(WC)     * $signed({1'b0, s_c});
                            prod_n <= $signed(wn_sel) * $signed({1'b0, nb_acc});
                            ph <= 3'd6;
                        end
                        3'd6: begin
                            score <= prod_c + prod_n + corner_term;
                            ph <= 3'd7;
                        end
                        default: begin
                            work[cidx] <= cell_is_corner ? 1'b1 : (score > 32'sd0);
                            ph <= 3'd0;
                            if (cidx == 6'd63) mode <= M_FINISH;
                            else cidx <= cidx + 6'd1;
                        end
                    endcase
                end

                default: begin   // M_FINISH
                    if (lat_start) begin
                        symbols_reg <= START_WORD; kind_reg <= 3'd1;
                    end else if (lat_end) begin
                        symbols_reg <= END_WORD;   kind_reg <= 3'd3;
                    end else if (lat_data) begin
                        symbols_reg <= work;       kind_reg <= 3'd2;
                    end else if (lat_disc) begin
                        symbols_reg <= work;       kind_reg <= 3'd4;
                    end else begin
                        symbols_reg <= work;       kind_reg <= 3'd0;
                    end
                    for (i = 0; i < 64; i = i + 1) sum_acc[i] <= 15'd0;
                    lat_start <= 1'b0; lat_data <= 1'b0; lat_end <= 1'b0; lat_disc <= 1'b0;
                    valid_out <= 1'b1;
                    mode <= M_IDLE;
                end
            endcase
        end
    end

    assign m_axis_tvalid = valid_out;
    assign m_axis_tdata  = symbols_reg;
    assign m_axis_tlast  = 1'b1;
    assign m_axis_tuser  = kind_reg;
endmodule