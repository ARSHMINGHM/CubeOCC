`timescale 1ns/1ps

// Linear per-cell decision for the V1 grayscale protocol (no divider, no frame buffer).
//
// For every cell the sampler accumulates the 81 pixels of the circular sampling
// region (dist_sq <= 25), as before. At frame end each of the 64 integer sums S
// is classified with a rule found by cross-validated training (dataset/
// export_linear_rule.py, model "I"):
//
//   score = WC * S_cell  +  WN[n] * (sum of the S of the n neighbours)
//                        +  WW * S_white[cell]
//   bit   = score > 0                      n = 2 (grid corner), 3 (edge), 4 (interior)
//
// S_white[cell] is the sum of the same cell in the START frame (all cells white), so
// every cell has its own white reference and a brightness gradient across the
// screen (viewing angle, vignetting) is calibrated out. Until a START has been
// accepted, a flat map is used instead: the mean of the 4 corner sums.
// The 1/81 and 1/n of the means are folded into the constants, so the rule needs only
// integer multiplies and adds. The four corner markers are white in every DATA
// frame by protocol and are forced to 1. START / END frames are decided by
// grid_corner_frame_guard (corner based) and emitted as their protocol patterns;
// m_axis_tuser tells what the frame was.
//
// Ambiguous Frame Flag: If a DATA frame has >= 3 cells with margin < 0.069 * white,
// it is flagged as kind 5 (Ambiguous) instead of 2 (DATA).
// This flags transition frames caught mid-update by the camera for downstream handling.
// In hardware, this is elegantly checked as abs(score) < (abs(prod_w) >> 3) without
// needing any new multipliers.
module linear_rule_sampler #(
    // constants from dataset/export_linear_rule.py --white-ref start (62 capture sets)
    parameter signed [11:0] WC  = 12'sd2047,
    parameter signed [11:0] WN2 = -12'sd272,
    parameter signed [11:0] WN3 = -12'sd181,
    parameter signed [11:0] WN4 = -12'sd136,
    parameter signed [11:0] WW  = -12'sd1126
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
    output logic [2:0]  m_axis_tuser     // 0 ignored, 1 START, 2 DATA, 3 END, 4 discarded, 5 ambiguous
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
    logic [14:0] corner_avg;                 // flat white map used before the first START
    logic [14:0] start_sum [0:63];           // per-cell white map = sums of the START frame
    logic        start_valid;
    logic [14:0] w_cell;
    
    // Signed arithmetic for SVM
    logic signed [31:0] prod_c;
    logic signed [31:0] prod_n;
    logic signed [31:0] prod_w;
    logic signed [31:0] score;
    
    // Unsigned magnitudes for ambiguous check
    logic [31:0] abs_score;
    logic [31:0] ambig_thresh;
    logic [6:0]  ambig_cnt;
    
    logic [63:0] work;

    logic        lat_start, lat_data, lat_end, lat_disc;
    logic        valid_out;
    logic [63:0] symbols_reg;
    logic [2:0]  kind_reg;

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

    integer i;
    always @(posedge clk) begin
        if (!rst_n) begin
            mode <= M_IDLE;
            ph <= 3'd0;
            cidx <= 6'd0;
            s_c <= 15'd0;
            nb_acc <= 17'd0;
            corner_sum <= 17'd0;
            corner_avg <= 15'd0;
            start_valid <= 1'b0;
            w_cell <= 15'd0;
            prod_c <= 32'sd0;
            prod_n <= 32'sd0;
            prod_w <= 32'sd0;
            score <= 32'sd0;
            abs_score <= 32'd0;
            ambig_thresh <= 32'd0;
            ambig_cnt <= 7'd0;
            work <= 64'd0;
            lat_start <= 1'b0; lat_data <= 1'b0; lat_end <= 1'b0; lat_disc <= 1'b0;
            valid_out <= 1'b0;
            symbols_reg <= 64'd0;
            kind_reg <= 3'd0;
            for (i = 0; i < 64; i = i + 1) begin
                sum_acc[i] <= 15'd0;
                start_sum[i] <= 15'd0;
            end
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
                    corner_avg <= corner_sum[16:2];          // mean of the 4 corner sums
                    cidx <= 6'd0;
                    ph <= 3'd0;
                    ambig_cnt <= 7'd0;
                    mode <= M_CELL;
                end

                M_CELL: begin
                    case (ph)
                        3'd0: begin
                            s_c <= sum_acc[cidx];
                            w_cell <= start_valid ? start_sum[cidx] : corner_avg;
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
                            // Calculate products (non-blocking, available in ph=6)
                            prod_c <= $signed(WC)     * $signed({1'b0, s_c});
                            prod_n <= $signed(wn_sel) * $signed({1'b0, nb_acc});
                            prod_w <= $signed(WW)     * $signed({1'b0, w_cell});
                            ph <= 3'd6;
                        end
                        3'd6: begin
                            // Calculate score and ambiguity threshold
                            score <= prod_c + prod_n + prod_w;
                            
                            // Absolute score
                            if ((prod_c + prod_n + prod_w) < 0) begin
                                abs_score <= -(prod_c + prod_n + prod_w);
                            end else begin
                                abs_score <= (prod_c + prod_n + prod_w);
                            end
                            
                            // Absolute prod_w shifted by 3 (division by 8)
                            // Since WW is negative and w_cell is positive, prod_w is always negative.
                            // So -prod_w is positive.
                            ambig_thresh <= (-prod_w) >> 3;
                            
                            ph <= 3'd7;
                        end
                        default: begin // ph == 3'd7
                            work[cidx] <= cell_is_corner ? 1'b1 : (score > 32'sd0);
                            // Check if cell is ambiguous using valid abs_score and ambig_thresh
                            if (!cell_is_corner && (abs_score < ambig_thresh)) begin
                                ambig_cnt <= ambig_cnt + 1;
                            end
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
                        symbols_reg <= work;
                        // Ambiguous check: if >= 3 ambiguous cells, flag as kind 5
                        kind_reg <= (ambig_cnt >= 7'd3) ? 3'd5 : 3'd2;
                    end else if (lat_disc) begin
                        symbols_reg <= work;       kind_reg <= 3'd4;
                    end else begin
                        symbols_reg <= work;       kind_reg <= 3'd0;
                    end
                    if (lat_start) begin
                        // an accepted START frame becomes the per-cell white map
                        for (i = 0; i < 64; i = i + 1) start_sum[i] <= sum_acc[i];
                        start_valid <= 1'b1;
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