`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/19 09:44:51
// Design Name: 
// Module Name: comtrol_unit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module comtrol_unit(
    input clk,
    input rst_n,
    input RUN,
    input [31:0] instruction,
    input BUS_rdata_valid,
    input BUS_write_done,
    output [2:0] reg_mux_CS,
    output [4:0] reg_rd,
    output [4:0] reg_rs1,
    output [4:0] reg_rs2,
    output reg_wen,
    output [1:0] PC_CS,
    output PC_EN,
    output PC_mode,
    output ALU_mode,
    output [1:0] ALU_CS,
    output [2:0] BUS_ADDR_CS,
    output [2:0] BUS_DATA_CS,
    output BUS_mode,
    output BUS_start_transaction,
    output [31:0] IM
    );

    wire stop;
    wire done;
    wire [1:0] cnt_set;
    wire Mif, Mex, T1, T2, T3, T4;

    reg ins_reg_EN;

    wire [31:0] reg_instruction;
    wire ins_ADD, ins_SUB, ins_SW, ins_LW, 
        ins_ADDI, ins_LUI;

    Register_asyn ins_reg(
        .clk(clk),
        .rst_n(rst_n),
        .EN(ins_reg_EN),
        .din(instruction),
        .dout(reg_instruction)
    );

    timing_generate timing_gen (
        .clk(clk),
        .rst_n(rst_n),
        .RUN(RUN),
        .stop(stop),
        .done(done),
        .cnt_set(cnt_set),
        .Mif(Mif),
        .T1(T1),
        .T2(T2),
        .T3(T3),
        .T4(T4)
    );

    instruction_decoder decoder(
        .instruction(reg_instruction),
        .ins_ADD(ins_ADD),
        .ins_SUB(ins_SUB),
        .ins_SW(ins_SW),
        .ins_LW(ins_LW),
        .ins_ADDI(ins_ADDI),
        .ins_LUI(ins_LUI),
        .IM(IM),
        .reg_rs1(reg_rs1),
        .reg_rs2(reg_rs2),
        .reg_rd(reg_rd)
    );

endmodule
