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
    input add_sub_mode,
    input 
    );

    Add_sub cpu_add_sub(
        .add(add_sub_mode),
        .num1(reg_raddr1),
        .num2(reg_rdata2),
        .result(add_sub_out)
    );
endmodule
