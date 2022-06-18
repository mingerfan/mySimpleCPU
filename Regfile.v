`timescale 1ns / 1ps
// from https://blog.csdn.net/xszxyll/article/details/123685934

module Regfile(
    input clk_n,
    input rst_n,
    input [4:0] Rs1,     //First READ addr
    input [4:0] Rs2,     //Second READ addr
    input [4:0] Rd,      //load Addder
    
    input Wen,          //Write enable
    output [31:0]BusA,      
    output [31:0]BusB,      //Reg out B
    input [31:0]BusW       //Write IN
);

    reg [31:0] DataReg[31:0];

    integer i;
    
    always@(negedge clk_n or negedge rst_n)begin
        if(!rst_n)begin
            for(i=0;i<32;i=i+1)
                DataReg[i] <= 32'B0;
        end
        else if(Wen&Rd!=5'd0) DataReg[Rd]<=BusW;
    end
    
    assign BusA=DataReg[Rs1];
    assign BusB=DataReg[Rs2];
 
endmodule