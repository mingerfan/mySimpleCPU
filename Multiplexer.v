`timescale 1ns / 1ps


module Multiplexer #(
    parameter width = 32
)
(
    input [0:4] CS,

    input [width-1:0] din0,
    input [width-1:0] din1,
    input [width-1:0] din2,
    input [width-1:0] din3,
    input [width-1:0] din4,
    input [width-1:0] din5,
    input [width-1:0] din6,
    input [width-1:0] din7,
    input [width-1:0] din8,
    input [width-1:0] din9,
    input [width-1:0] din10,
    input [width-1:0] din11,
    input [width-1:0] din12,
    input [width-1:0] din13,
    input [width-1:0] din14,
    input [width-1:0] din15,
    input [width-1:0] din16,
    input [width-1:0] din17,
    input [width-1:0] din18,
    input [width-1:0] din19,
    input [width-1:0] din20,
    input [width-1:0] din21,
    input [width-1:0] din22,
    input [width-1:0] din23,
    input [width-1:0] din24,
    input [width-1:0] din25,
    input [width-1:0] din26,
    input [width-1:0] din27,
    input [width-1:0] din28,
    input [width-1:0] din29,
    input [width-1:0] din30,
    input [width-1:0] din31,

    output reg [width-1:0] dout
);

always @(*) begin
    case (CS)
        5'd0: dout = din0; 
        5'd1: dout = din1;
        5'd2: dout = din2;
        5'd3: dout = din3;
        5'd4: dout = din4;
        5'd5: dout = din5;
        5'd6: dout = din6;
        5'd7: dout = din7;
        5'd8: dout = din8;
        5'd9: dout = din9;
        5'd10: dout = din10;
        5'd11: dout = din11;
        5'd12: dout = din12;
        5'd13: dout = din13;
        5'd14: dout = din14;
        5'd15: dout = din15;
        5'd16: dout = din16;
        5'd17: dout = din17;
        5'd18: dout = din18;
        5'd19: dout = din19;
        5'd20: dout = din20;
        5'd21: dout = din21;
        5'd22: dout = din22;
        5'd23: dout = din23;
        5'd24: dout = din24;
        5'd25: dout = din25;
        5'd26: dout = din26;
        5'd27: dout = din27;
        5'd28: dout = din28;
        5'd29: dout = din29;
        5'd30: dout = din30;
        5'd31: dout = din31;
        default: dout = 32'd0;
    endcase
end

endmodule
