`timescale 1ns / 1ps

module PC_cnt_in(
    input clk,
    input rst_n,
    input mode,
    output [31:0] PC,
    input [31:0] cnt_in,
    input EN
    );

    wire [31:0] PC_inc;
    wire [31:0] mux_out;
    wire [31:0] pc_r_out;

    assign PC = pc_r_out;
    assign PC_inc = pc_r_out + 32'd4;

    Register_asyn pc_r(
        .clk(clk),
        .rst_n(rst_n),
        .din(mux_out),
        .dout(pc_r_out),
        .EN(EN)
    );



    Multiplexer2to1 pc_mux(
        // mode = 0, increase 4
        .CS(mode),
        .din0(PC_inc),
        .din1(cnt_in),
        .dout(mux_out)
    );
endmodule
