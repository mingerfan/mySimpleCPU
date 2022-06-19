`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/19 22:03:47
// Design Name: 
// Module Name: CPU
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


module MyCPU(
    input clk,
    input rst_n,
    input RUN
    );

    wire [31:0] BUS_addr;
    wire [31:0] BUS_wdata;
    wire [31:0] BUS_rdata;
    wire BUS_valid;
    wire BUS_wready;
    wire BUS_rready;
    wire BUS_rvalid;
    wire BUS_mode;

    CPU_core my_core(
        .clk(clk),
        .rst_n(rst_n),
        .RUN(RUN),
        .BUS_addr(BUS_addr),
        .BUS_wdata(BUS_wdata),
        .BUS_rdata(BUS_rdata),
        .BUS_valid(BUS_valid),
        .BUS_wready(BUS_wready),
        .BUS_rready(BUS_rready),
        .BUS_rvalid(BUS_rvalid),
        .BUS_mode(BUS_mode)
    );

    RAM_Slave my_slave (
        .clk(sys_clk),
        .rst_n(sys_rst_n),
        .BUS_addr(BUS_addr),
        .BUS_wdata(BUS_wdata),
        .BUS_rdata(BUS_rdata),
        .BUS_valid(BUS_valid),
        .BUS_wready(BUS_wready),
        .BUS_rready(BUS_rready),
        .BUS_rvalid(BUS_rvalid),
        .BUS_mode(BUS_mode)
    );


endmodule
