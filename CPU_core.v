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

    wire [31:0] IM;

    wire [2:0] addr_CS;
    wire [2:0] data_CS; 

    wire [31:0] reg_raddr1;
    wire [31:0] reg_raddr2;
    wire [31:0] reg_waddr;
    wire reg_wen;
    wire [31:0] reg_rdata1;
    wire [31:0] reg_rdata2;
    wire [31:0] reg_wdata;
    wire [2:0] reg_CS;
    
    wire ALU_mode;
    wire [1:0] ALU_CS;
    wire [31:0] ALU_out;

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
        .ALU_din(ALU_out),
        .Reg_din0(reg_rdata1),
        .Reg_din1(reg_rdata2),
        .IM_din(IM),
        .EN(PC_EN)
    );


    ALU ALU(
        .ALU_mode(ALU_mode),
        .num1_CS(ALU_CS),
        .PC_din_num1(PC),
        .IM_din_num1(IM),
        .reg_din0_num1(reg_rdata1),
        .reg_din1_num2(reg_rdata2),
        .ALU_out(ALU_out)
    );

    Multiplexer8to1 regfile_mux(
        .CS(reg_CS),
        .din0(ALU_out),
        .din1(reg_rdata1),
        .din2(reg_rdata2),
        .din3(PC),
        .din4(IM),
        .din5(rdata_BUS),
        .din6(32'd0),
        .din7(32'd0),
        .dout(reg_wdata)
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
        .ALU_din(ALU_out),
        .reg_din0(reg_rdata1),
        .reg_din1(reg_rdata2),
        .IM_din(IM),
        .ALU_addrin(ALU_out),
        .reg_addrin0(reg_rdata1),
        .reg_addrin1(reg_rdata2),
        .PC_addrin(PC),
        .IM_addrin(IM),
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

    comtrol_unit CPU_control(
        .clk(clk),
        .rst_n(rst_n),
        .RUN(RUN),
        .BUS_rdata_valid(rdata_valid_BUS),
        .BUS_write_done(write_done_BUS),
        .reg_mux_CS(reg_CS),
        .reg_rd(reg_waddr),
        .reg_rs1(reg_raddr1),
        .reg_rs2(reg_raddr2),
        .reg_wen(reg_wen),
        .PC_CS(PC_CS),
        .PC_EN(PC_EN),
        .PC_mode(PC_mode),
        .ALU_mode(ALU_mode),
        .ALU_CS(ALU_CS),
        .BUS_ADDR_CS(addr_CS),
        .BUS_DATA_CS(data_CS),
        .BUS_mode(mode_BUS),
        .BUS_start_transaction(start_transaction_BUS)
    );
    
endmodule

