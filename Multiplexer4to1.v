`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/18 13:49:20
// Design Name: 
// Module Name: Multiplexer4to1
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


module Multiplexer4to1#(
    parameter width = 32
) 
(
    input [1:0] CS,

    input [width-1:0] din0,
    input [width-1:0] din1,
    input [width-1:0] din2,
    input [width-1:0] din3,

    output reg [width-1:0] dout
);

always @(*) begin
    case (CS)
        2'd0: dout = din0;
        2'd1: dout = din1;
        2'd2: dout = din2;
        2'd3: dout = din3;
        default: dout = 32'd0;
    endcase
end

endmodule
