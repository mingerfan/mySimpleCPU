`timescale 1ns / 1ps

module PC_cnt(
    input clk,
    input rst_n,
    input [1:0] CS,
    input mode,
    output [31:0] PC,
    input [31:0] ALU_din,
    input [31:0] Reg_din0,
    input [31:0] Reg_din1,
    input [31:0] IM_din,
    input EN
    );

    wire [31:0] cnt_in;

    Multiplexer4to1 PC_mux(
        .CS(CS),
        .din0(ALU_din),
        .din1(Reg_din0),
        .din2(Reg_din1),
        .din3(IM_din),
        .dout(cnt_in)
    );

    PC_cnt_in cpu_PC(
        .clk(clk),
        .rst_n(rst_n),
        .mode(PC_mode),
        .PC(PC),
        .cnt_in(cnt_in),
        .EN(EN)
    );
    
endmodule
