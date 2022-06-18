`timescale 1ns / 1ps

module CPU_core(
    input clk,
    input rst_n,
    input RUN,
    output [31:0] BUS_addr,
    output [31:0] BUS_wdata,
    input [31:0] BUS_rdata,
    output BUS_valid,
    input BUS_wready,
    output BUS_rready,
    input BUS_rvalid,
    output BUS_mode
    );

    wire PC_mode;
    wire [1:0] PC_CS;
    wire PC_EN;
    wire [31:0] PC;

    // wire [31:0] DATA_BUS;
    wire [4:0] ctrl_unit_cs;

    wire [1:0] addr_CS;
    wire [2:0] data_CS;
    
    // wire [31:0] ALU_din;
    // wire [31:0] reg_din0;
    // wire [31:0] reg_din1;
    // wire [31:0] IM_din;
    // wire [31:0] ALU_addrin;
    // wire [31:0] reg_addrin0;
    // wire [31:0] reg_addrin1;
    // wire [31:0] PC_addrin;
    // wire [31:0] IM_addrin;

    wire [31:0] reg_raddr1;
    wire [31:0] reg_raddr2;
    wire [31:0] reg_waddr;
    wire reg_wen;
    wire [31:0] reg_rdata1;
    wire [31:0] reg_rdata2;
    wire [31:0] reg_wdata;
    
    wire add_sub_mode;
    wire [31:0] add_sub_out;

    wire mode_BUS;
    wire rdata_valid_BUS;
    wire write_done_BUS;
    wire start_transaction_BUS;
    wire [31:0] rdata_BUS;


    PC_cnt cpu_PC(
        .clk(clk),
        .rst_n(rst_n),
        .CS(PC_CS),
        .mode(PC_mode),
        .PC(PC),
        .ALU_din(add_sub_out),
        .Reg_din0(reg_rdata1),
        .Reg_din1(reg_rdata2),
        .IM_din(),
        .EN(EN)
    );


    Add_sub cpu_add_sub(
        .add(add_sub_mode),
        .num1(reg_raddr1),
        .num2(reg_rdata2),
        .result(add_sub_out)
    );

    Regfile CPU_Reg(
        .clk_n(clk),
        .rst_n(rst_n),
        .Rs1(reg_raddr1),
        .Rs2(reg_raddr2),
        .Rd(reg_waddr),
        .Wen(reg_wen),
        .BusA(reg_rdata1),
        .BusB(reg_rdata2),
        .BusW(reg_wdata)
    );

    BUS_controller_top CPU_BUS (
        .clk(clk),
        .rst_n(rst_n),
        .mode(mode_BUS),
        .addr_CS(addr_CS),
        .data_CS(data_CS),
        .ALU_din(add_sub_out),
        .reg_din0(reg_rdata1),
        .reg_din1(reg_rdata2),
        .IM_din(),
        .ALU_addrin(add_sub_out),
        .reg_addrin0(reg_rdata1),
        .reg_addrin1(reg_rdata2),
        .PC_addrin(PC),
        .IM_addrin(),
        .rdata_valid(rdata_valid_BUS),
        .write_done(write_done_BUS),
        .start_transaction(start_transaction_BUS),
        .rdata(rdata_BUS),
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

