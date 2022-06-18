`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/18 14:01:34
// Design Name: 
// Module Name: Multiplexer8to1
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


module Multiplexer8to1#(
    parameter width = 32
) 
(
    input [2:0] CS,

    input [width-1:0] din0,
    input [width-1:0] din1,
    input [width-1:0] din2,
    input [width-1:0] din3,
    input [width-1:0] din4,
    input [width-1:0] din5,
    input [width-1:0] din6,
    input [width-1:0] din7,

    output reg [width-1:0] dout
);

always @(*) begin
    case (CS)
        3'd0: dout = din0;
        3'd1: dout = din1;
        3'd2: dout = din2;
        3'd3: dout = din3;
        3'd4: dout = din4;
        3'd5: dout = din5;
        3'd6: dout = din6;
        3'd7: dout = din7;
        default: dout = 32'd0;
    endcase
end

endmodule

