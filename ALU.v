`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/18 15:27:56
// Design Name: 
// Module Name: ALU
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


module ALU(
    input ALU_mode, // mode 1 is add
    input [1:0] num1_CS,
    input [1:0] num2_CS,
    input [31:0] PC_din,
    input [31:0] IM_din,
    input [31:0] reg_din0,
    input [31:0] reg_din1,
    output [31:0] ALU_out
    );

    wire [31:0] num1, num2;

    Multiplexer4to1 ALU_mux(
        .CS(num1_CS),
        .din0(reg_din0),
        .din1(IM_din),
        .din2(PC_din),
        .din3(reg_din1),
        .dout(num1)
    );

    Multiplexer4to1 ALU_mux1(
        .CS(num2_CS),
        .din0(reg_din0),
        .din1(IM_din),
        .din2(PC_din),
        .din3(reg_din1),
        .dout(num2)
    );

    Add_sub cpu_add_sub(
        .add(ALU_mode),
        .num1(num1),
        .num2(num2),
        .result(ALU_out)
    );
endmodule
