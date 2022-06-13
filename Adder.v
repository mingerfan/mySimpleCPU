`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/13 14:32:47
// Design Name: 
// Module Name: Adder
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


module Add_sub(
    input add,
    input [31:0] num1,
    input [31:0] num2,
    output [31:0] result
    );

    c_addsub_0 add_sub_ip(
        .A(num1),      // input wire [31 : 0] A
        .B(num2),      // input wire [31 : 0] B
        .ADD(add),  // input wire ADD
        .S(result)      // output wire [31 : 0] S
    );

endmodule
