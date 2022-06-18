`timescale 1ns / 1ps
// from https://blog.csdn.net/xszxyll/article/details/123685934

module Regfile(
    input clk_n,
    input rst_n,
    input [4:0]Rs1,     //第一个寄存器地址
    input [4:0]Rs2,     //第二个寄存器地址
    input [4:0]Rd,      //写入的寄存器地址
    
    input Wen,          //控制信号
    output [31:0]BusA,      //输出第一个寄存器中的值
    output [31:0]BusB,      //输出第二个寄存器中的值
    input [31:0]BusW       //写个的寄存器的值
 
 
);
    reg [31:0] DataReg[31:0];

    integer i;
    
    //写
    always@(negedge clk_n or negedge rst_n)begin
        if(!rst_n)begin
            for(i=0;i<32;i=i+1)
                DataReg[i] <= `ZeroWord;
        end
        else if(Wen&Rd!=5'd0) DataReg[Rd]<=BusW;
    end
    
    //读
    assign BusA=DataReg[Rs1];
    assign BusB=DataReg[Rs2];
 
 
 
endmodule