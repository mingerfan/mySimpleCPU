`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/17 15:23:36
// Design Name: 
// Module Name: RAM_Slave
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


module RAM_Slave #(
    parameter [6:0] DATA_WIDTH = 32,
    parameter [6:0] ADDR_WIDTH = 32
) 
(
    input clk,
    input rst_n,
    input [ADDR_WIDTH-1:0] BUS_addr,
    input [DATA_WIDTH-1:0] BUS_wdata,
    output [DATA_WIDTH-1:0] BUS_rdata,
    input BUS_valid,
    output BUS_wready,
    input BUS_rready,
    output BUS_rvalid,
    input BUS_mode
);

    wire [ADDR_WIDTH-1:0] addr;
    wire [DATA_WIDTH-1:0] wdata;
    wire [DATA_WIDTH-1:0] rdata;
    wire write_en;
    wire read_en;
    wire read_valid;

    assign read_valid = read_en;

    blk_mem_gen_0 my_ram (
        .clka(clk),    // input wire clka
        .wea(write_en),      // input wire [0 : 0] wea
        .addra(addr >> 2),  // input wire [9 : 0] addra
        .dina(wdata),    // input wire [31 : 0] dina
        .douta(rdata)  // output wire [31 : 0] douta
    );

    BUS_slave #(
        .START_ADDR('h0000_0000),
        .END_ADDR('h0000_FFFF)
    )
    my_slave
    (
        .clk(clk),
        .rst_n(rst_n),
        .write_en(write_en),
        .read_en(read_en),
        .write_ready(1'b1),
        .read_valid(read_valid),
        .addr(addr),
        .wdata(wdata),
        .rdata(rdata),
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
