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
    input ALU_mode,
    input [1:0] num1_CS,
    input [31:0] PC_din_num1,
    input [31:0] IM_din_num1,
    input [31:0] reg_din0_num1,
    input [31:0] reg_din1_num2,
    output [31:0] ALU_out
    );

    wire [31:0] num1;

    Multiplexer4to1 ALU_mux(
        .CS(num1_CS),
        .din0(reg_din0_num1),
        .din1(IM_din_num1),
        .din2(PC_din_num1),
        .din3(32'd0),
        .dout(num1)
    );

    Add_sub cpu_add_sub(
        .add(ALU_mode),
        .num1(num1),
        .num2(reg_din1_num2),
        .result(ALU_out)
    );
endmodule
