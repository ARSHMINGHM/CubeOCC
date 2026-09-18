`timescale 1ns/1ps

module signed_divider_32 (
    input  logic               clk,
    input  logic               rst_n,
    input  logic               start,
    input  logic signed [31:0] dividend,
    input  logic signed [31:0] divisor,
    output logic               busy,
    output logic               done,
    output logic signed [31:0] quotient
);
    logic [31:0] dividend_work, divisor_mag, quotient_work;
    logic [32:0] remainder;
    logic [5:0] count;
    logic negative_result;
    logic [32:0] shifted_remainder;
    logic [31:0] next_quotient;

    always_comb begin
        shifted_remainder = {remainder[31:0], dividend_work[31]};
        next_quotient = {quotient_work[30:0], 1'b0};
        if (shifted_remainder >= {1'b0, divisor_mag})
            next_quotient[0] = 1'b1;
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            busy <= 1'b0;
            done <= 1'b0;
            quotient <= 0;
            dividend_work <= 0;
            divisor_mag <= 0;
            quotient_work <= 0;
            remainder <= 0;
            count <= 0;
            negative_result <= 1'b0;
        end else begin
            done <= 1'b0;
            if (start && !busy) begin
                if (divisor == 0) begin
                    quotient <= 0;
                    done <= 1'b1;
                end else begin
                    dividend_work <= dividend[31] ? -dividend : dividend;
                    divisor_mag <= divisor[31] ? -divisor : divisor;
                    quotient_work <= 0;
                    remainder <= 0;
                    count <= 0;
                    negative_result <= dividend[31] ^ divisor[31];
                    busy <= 1'b1;
                end
            end else if (busy) begin
                dividend_work <= {dividend_work[30:0], 1'b0};
                quotient_work <= next_quotient;
                if (shifted_remainder >= {1'b0, divisor_mag})
                    remainder <= shifted_remainder - {1'b0, divisor_mag};
                else
                    remainder <= shifted_remainder;
                if (count == 31) begin
                    quotient <= negative_result ? -$signed(next_quotient) : $signed(next_quotient);
                    busy <= 1'b0;
                    done <= 1'b1;
                end else begin
                    count <= count + 1'b1;
                end
            end
        end
    end
endmodule

module coordinate_divider_8 (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        start,
    input  logic [31:0] numerator,
    input  logic [31:0] denominator,
    output logic        busy,
    output logic        done,
    output logic [7:0]  quotient
);
    logic [39:0] remainder;
    logic [39:0] shifted_denominator;
    logic [2:0] bit_index;

    always_comb
        shifted_denominator = {8'd0, denominator} << bit_index;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            busy <= 1'b0;
            done <= 1'b0;
            quotient <= 0;
            remainder <= 0;
            bit_index <= 0;
        end else begin
            done <= 1'b0;
            if (start && !busy) begin
                if (denominator == 0) begin
                    quotient <= 0;
                    done <= 1'b1;
                end else begin
                    remainder <= {8'd0, numerator};
                    quotient <= 0;
                    bit_index <= 3'd7;
                    busy <= 1'b1;
                end
            end else if (busy) begin
                if (remainder >= shifted_denominator) begin
                    remainder <= remainder - shifted_denominator;
                    quotient[bit_index] <= 1'b1;
                end
                if (bit_index == 0) begin
                    busy <= 1'b0;
                    done <= 1'b1;
                end else begin
                    bit_index <= bit_index - 1'b1;
                end
            end
        end
    end
endmodule

// Fixed-point inverse projective mapper for a 160x120 grayscale raster.
// Two compact iterative dividers calculate one source coordinate pair, which
// is stored in a 160-byte row buffer. The completed row is then emitted as a
// continuous DVP line for the existing streaming grid mapper.
module projective_warp_160x120 #(
    parameter X_BITS = 10,
    parameter Y_BITS = 10,
    parameter FRAC_BITS = 16
)(
    input  logic              pclk,
    input  logic              rst_n,
    input  logic              in_vsync,
    input  logic              in_href,
    input  logic [7:0]        in_gray,
    input  logic              rectify_enable,
    input  logic [X_BITS-1:0] tl_x, tr_x, br_x, bl_x,
    input  logic [Y_BITS-1:0] tl_y, tr_y, br_y, bl_y,
    output logic              busy,
    output logic              out_vsync,
    output logic              out_href,
    output logic [7:0]        out_gray,
    output logic              out_frame_done
);
    localparam integer WIDTH = 160;
    localparam integer HEIGHT = 120;
    localparam integer PIXELS = WIDTH * HEIGHT;
    localparam signed [31:0] Q_ONE = 32'sd1 <<< FRAC_BITS;

    (* ram_style = "block" *) logic [7:0] frame_mem [0:PIXELS-1];
    (* ram_style = "distributed" *) logic [7:0] line_mem [0:WIDTH-1];

    typedef enum logic [3:0] {
        WAIT_FRAME, G_DIV_START, G_DIV_WAIT, H_DIV_START, H_DIV_WAIT,
        COEFFICIENT_SETUP, STEP_SETUP, LINE_SETUP, COORD_START,
        COORD_WAIT, PIXEL_READ, PIXEL_STORE, EMIT_LINE, LINE_GAP
    } state_t;
    state_t state;

    logic prev_vsync;
    logic [14:0] write_addr;
    logic [7:0] map_x, emit_x;
    logic [6:0] map_y;

    logic signed [31:0] dx3_x, dx3_y;
    logic signed [31:0] edge_ax, edge_ay, edge_bx, edge_by;
    logic signed [31:0] projective_denominator;
    logic signed [31:0] projective_g_numerator;
    logic signed [31:0] projective_h_numerator;
    logic signed [31:0] g_q, h_q;
    logic signed [31:0] a_q, b_q, c_q;
    logic signed [31:0] d_q, e_q, f_q;
    logic signed [31:0] a_step_q, b_step_q;
    logic signed [31:0] d_step_q, e_step_q;
    logic signed [31:0] g_step_q, h_step_q;
    logic signed [31:0] row_u_q, row_v_q, row_w_q;
    logic signed [31:0] pixel_u_q, pixel_v_q, pixel_w_q;

    logic setup_div_start, setup_div_busy, setup_div_done;
    logic signed [31:0] setup_dividend, setup_divisor, setup_quotient;
    logic coord_start, coord_x_busy, coord_y_busy, coord_x_done, coord_y_done;
    logic [31:0] coord_x_numerator, coord_y_numerator, coord_denominator;
    logic [7:0] coord_x_quotient, coord_y_quotient;
    logic [7:0] source_x;
    logic [6:0] source_y;
    logic [14:0] read_addr;
    logic [7:0] frame_read_data;

    signed_divider_32 setup_divider (
        .clk(pclk), .rst_n, .start(setup_div_start),
        .dividend(setup_dividend), .divisor(setup_divisor),
        .busy(setup_div_busy), .done(setup_div_done), .quotient(setup_quotient)
    );

    coordinate_divider_8 x_divider (
        .clk(pclk), .rst_n, .start(coord_start),
        .numerator(coord_x_numerator), .denominator(coord_denominator),
        .busy(coord_x_busy), .done(coord_x_done), .quotient(coord_x_quotient)
    );

    coordinate_divider_8 y_divider (
        .clk(pclk), .rst_n, .start(coord_start),
        .numerator(coord_y_numerator), .denominator(coord_denominator),
        .busy(coord_y_busy), .done(coord_y_done), .quotient(coord_y_quotient)
    );

    always_comb begin
        dx3_x = $signed({1'b0, tl_x}) - $signed({1'b0, tr_x})
              + $signed({1'b0, br_x}) - $signed({1'b0, bl_x});
        dx3_y = $signed({1'b0, tl_y}) - $signed({1'b0, tr_y})
              + $signed({1'b0, br_y}) - $signed({1'b0, bl_y});
        edge_ax = $signed({1'b0, tr_x}) - $signed({1'b0, br_x});
        edge_ay = $signed({1'b0, tr_y}) - $signed({1'b0, br_y});
        edge_bx = $signed({1'b0, bl_x}) - $signed({1'b0, br_x});
        edge_by = $signed({1'b0, bl_y}) - $signed({1'b0, br_y});
        projective_denominator = edge_ax * edge_by - edge_bx * edge_ay;
        projective_g_numerator = dx3_x * edge_by - edge_bx * dx3_y;
        projective_h_numerator = edge_ax * dx3_y - dx3_x * edge_ay;

        setup_div_start = (state == G_DIV_START) || (state == H_DIV_START);
        setup_divisor = projective_denominator;
        setup_dividend = (state == G_DIV_START)
            ? projective_g_numerator <<< FRAC_BITS
            : projective_h_numerator <<< FRAC_BITS;

        coord_start = (state == COORD_START);
        coord_denominator = pixel_w_q > 0 ? pixel_w_q : 32'd1;
        coord_x_numerator = pixel_u_q < 0 ? 0 : pixel_u_q + (pixel_w_q >>> 1);
        coord_y_numerator = pixel_v_q < 0 ? 0 : pixel_v_q + (pixel_w_q >>> 1);
        source_x = coord_x_quotient > WIDTH - 1 ? WIDTH - 1 : coord_x_quotient;
        source_y = coord_y_quotient > HEIGHT - 1 ? HEIGHT - 1 : coord_y_quotient[6:0];
        read_addr = ({{8{1'b0}}, source_y} << 7)
                  + ({{8{1'b0}}, source_y} << 5)
                  + {{7{1'b0}}, source_x};
    end

    always_ff @(posedge pclk) begin
        if (state == WAIT_FRAME && !in_vsync && in_href && write_addr < PIXELS)
            frame_mem[write_addr] <= in_gray;
        if (state == PIXEL_READ)
            frame_read_data <= frame_mem[read_addr];
        if (state == PIXEL_STORE)
            line_mem[map_x] <= frame_read_data;
    end

    always_ff @(posedge pclk or negedge rst_n) begin
        if (!rst_n) begin
            state <= WAIT_FRAME;
            prev_vsync <= 1'b1;
            write_addr <= 0;
            map_x <= 0;
            map_y <= 0;
            emit_x <= 0;
            busy <= 1'b0;
            out_vsync <= 1'b1;
            out_href <= 1'b0;
            out_gray <= 0;
            out_frame_done <= 1'b0;
            g_q <= 0; h_q <= 0;
            a_q <= 0; b_q <= 0; c_q <= 0;
            d_q <= 0; e_q <= 0; f_q <= 0;
            a_step_q <= 0; b_step_q <= 0;
            d_step_q <= 0; e_step_q <= 0;
            g_step_q <= 0; h_step_q <= 0;
            row_u_q <= 0; row_v_q <= 0; row_w_q <= Q_ONE;
            pixel_u_q <= 0; pixel_v_q <= 0; pixel_w_q <= Q_ONE;
        end else begin
            prev_vsync <= in_vsync;
            out_frame_done <= 1'b0;

            case (state)
                WAIT_FRAME: begin
                    out_vsync <= 1'b1;
                    out_href <= 1'b0;
                    busy <= 1'b0;
                    if (prev_vsync && !in_vsync)
                        write_addr <= 0;
                    if (!in_vsync && in_href && write_addr < PIXELS)
                        write_addr <= write_addr + 1'b1;
                    if (!prev_vsync && in_vsync && write_addr >= PIXELS && rectify_enable) begin
                        busy <= 1'b1;
                        out_vsync <= 1'b0;
                        state <= G_DIV_START;
                    end
                end

                G_DIV_START: state <= G_DIV_WAIT;
                G_DIV_WAIT: if (setup_div_done) begin
                    g_q <= setup_quotient;
                    state <= H_DIV_START;
                end
                H_DIV_START: state <= H_DIV_WAIT;
                H_DIV_WAIT: if (setup_div_done) begin
                    h_q <= setup_quotient;
                    state <= COEFFICIENT_SETUP;
                end

                COEFFICIENT_SETUP: begin
                    a_q <= (($signed({1'b0, tr_x}) - $signed({1'b0, tl_x})) <<< FRAC_BITS)
                         + g_q * $signed({1'b0, tr_x});
                    b_q <= (($signed({1'b0, bl_x}) - $signed({1'b0, tl_x})) <<< FRAC_BITS)
                         + h_q * $signed({1'b0, bl_x});
                    c_q <= $signed({1'b0, tl_x}) <<< FRAC_BITS;
                    d_q <= (($signed({1'b0, tr_y}) - $signed({1'b0, tl_y})) <<< FRAC_BITS)
                         + g_q * $signed({1'b0, tr_y});
                    e_q <= (($signed({1'b0, bl_y}) - $signed({1'b0, tl_y})) <<< FRAC_BITS)
                         + h_q * $signed({1'b0, bl_y});
                    f_q <= $signed({1'b0, tl_y}) <<< FRAC_BITS;
                    state <= STEP_SETUP;
                end

                STEP_SETUP: begin
                    a_step_q <= a_q / (WIDTH - 1);
                    b_step_q <= b_q / (HEIGHT - 1);
                    d_step_q <= d_q / (WIDTH - 1);
                    e_step_q <= e_q / (HEIGHT - 1);
                    g_step_q <= g_q / (WIDTH - 1);
                    h_step_q <= h_q / (HEIGHT - 1);
                    row_u_q <= c_q;
                    row_v_q <= f_q;
                    row_w_q <= Q_ONE;
                    map_x <= 0;
                    map_y <= 0;
                    state <= LINE_SETUP;
                end

                LINE_SETUP: begin
                    pixel_u_q <= row_u_q;
                    pixel_v_q <= row_v_q;
                    pixel_w_q <= row_w_q;
                    map_x <= 0;
                    state <= COORD_START;
                end

                COORD_START: state <= COORD_WAIT;
                COORD_WAIT: if (coord_x_done && coord_y_done)
                    state <= PIXEL_READ;

                PIXEL_READ: state <= PIXEL_STORE;

                PIXEL_STORE: begin
                    if (map_x == WIDTH - 1) begin
                        emit_x <= 0;
                        state <= EMIT_LINE;
                    end else begin
                        map_x <= map_x + 1'b1;
                        pixel_u_q <= pixel_u_q + a_step_q;
                        pixel_v_q <= pixel_v_q + d_step_q;
                        pixel_w_q <= pixel_w_q + g_step_q;
                        state <= COORD_START;
                    end
                end

                EMIT_LINE: begin
                    out_href <= 1'b1;
                    out_gray <= line_mem[emit_x];
                    if (emit_x == WIDTH - 1)
                        state <= LINE_GAP;
                    else
                        emit_x <= emit_x + 1'b1;
                end

                default: begin
                    out_href <= 1'b0;
                    if (map_y == HEIGHT - 1) begin
                        out_vsync <= 1'b1;
                        out_frame_done <= 1'b1;
                        busy <= 1'b0;
                        state <= WAIT_FRAME;
                    end else begin
                        map_y <= map_y + 1'b1;
                        row_u_q <= row_u_q + b_step_q;
                        row_v_q <= row_v_q + e_step_q;
                        row_w_q <= row_w_q + h_step_q;
                        state <= LINE_SETUP;
                    end
                end
            endcase
        end
    end
endmodule
