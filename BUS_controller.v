`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/13 16:39:51
// Design Name: 
// Module Name: BUS_controller
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


module BUS_controller(
    input clk,
    input rst_n,
    input BUS_data_valid,
    output rvalid,
    output [31:0] rdata,
    input [31:0] addr,
    input [31:0] wdata
    );
endmodule
