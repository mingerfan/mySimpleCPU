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
    wire PC_EN;
    wire [31:0] PC;

    wire [31:0] DATA_BUS;
    wire [4:0] ctrl_unit_cs;

    wire [31:0] reg_out0;
    wire [31:0] reg_out1;
    wire [31:0] reg_out2;
    wire [31:0] reg_out3;
    wire [31:0] reg_out4;
    wire [31:0] reg_out5;
    wire [31:0] reg_out6;
    wire [31:0] reg_out7;
    wire [31:0] reg_out8;
    wire [31:0] reg_out9;
    wire [31:0] reg_out10;
    wire [31:0] reg_out11;
    wire [31:0] reg_out12;
    wire [31:0] reg_out13;
    wire [31:0] reg_out14;
    wire [31:0] reg_out15;
    wire [31:0] reg_adder_in;   // output of adder input reg
    wire [31:0] reg_adder_out;
    wire [31:0] reg_addr_out;

    wire reg_en0;
    wire reg_en1;
    wire reg_en2;
    wire reg_en3;
    wire reg_en4;
    wire reg_en5;
    wire reg_en6;
    wire reg_en7;
    wire reg_en8;
    wire reg_en9;
    wire reg_en10;
    wire reg_en11;
    wire reg_en12;
    wire reg_en13;
    wire reg_en14;
    wire reg_en15;
    wire reg_adder_in_en;
    wire reg_adder_out_en;
    wire reg_addr_en;
    

    wire add_sub_mode;
    wire [31:0] add_sub_out;

    wire mode_BUS;
    wire rdata_valid_BUS;
    wire write_done_BUS;
    wire start_transaction_BUS;
    wire [31:0] rdata_BUS;
    wire [31:0] addr_BUS;
    wire [31:0] wdata_BUS;

    assign addr_BUS = reg_addr_out;
    assign wdata_BUS = DATA_BUS;

    PC_cnt cpu_PC(
        .clk(clk),
        .rst_n(rst_n),
        .mode(PC_mode),
        .PC(PC),
        .cnt_in(DATA_BUS),
        .EN(PC_EN)
    );

    Register_asyn R0(
        .clk(clk),
        .rst_n(rst_n),
        .din(DATA_BUS),
        .dout(reg_out0),
        .EN(reg_en0)
    );

    Register_asyn R1(
        .clk(clk),
        .rst_n(rst_n),
        .din(DATA_BUS),
        .dout(reg_out1),
        .EN(reg_en1)
    );

    Register_asyn R2(
        .clk(clk),
        .rst_n(rst_n),
        .din(DATA_BUS),
        .dout(reg_out2),
        .EN(reg_en2)
    );

    Register_asyn R3(
        .clk(clk),
        .rst_n(rst_n),
        .din(DATA_BUS),
        .dout(reg_out3),
        .EN(reg_en3)
    );

    Register_asyn R4(
        .clk(clk),
        .rst_n(rst_n),
        .din(DATA_BUS),
        .dout(reg_out4),
        .EN(reg_en4)
    );

    Register_asyn R5(
        .clk(clk),
        .rst_n(rst_n),
        .din(DATA_BUS),
        .dout(reg_out5),
        .EN(reg_en5)
    );

    Register_asyn R6(
        .clk(clk),
        .rst_n(rst_n),
        .din(DATA_BUS),
        .dout(reg_out6),
        .EN(reg_en6)
    );

    Register_asyn R7(
        .clk(clk),
        .rst_n(rst_n),
        .din(DATA_BUS),
        .dout(reg_out7),
        .EN(reg_en7)
    );

    Register_asyn R8(
        .clk(clk),
        .rst_n(rst_n),
        .din(DATA_BUS),
        .dout(reg_out8),
        .EN(reg_en8)
    );

    Register_asyn R9(
        .clk(clk),
        .rst_n(rst_n),
        .din(DATA_BUS),
        .dout(reg_out9),
        .EN(reg_en9)
    );

    Register_asyn R10(
        .clk(clk),
        .rst_n(rst_n),
        .din(DATA_BUS),
        .dout(reg_out10),
        .EN(reg_en10)
    );

    Register_asyn R11(
        .clk(clk),
        .rst_n(rst_n),
        .din(DATA_BUS),
        .dout(reg_out11),
        .EN(reg_en11)
    );

    Register_asyn R12(
        .clk(clk),
        .rst_n(rst_n),
        .din(DATA_BUS),
        .dout(reg_out12),
        .EN(reg_en12)
    );

    Register_asyn R13(
        .clk(clk),
        .rst_n(rst_n),
        .din(DATA_BUS),
        .dout(reg_out13),
        .EN(reg_en13)
    );

    Register_asyn R14(
        .clk(clk),
        .rst_n(rst_n),
        .din(DATA_BUS),
        .dout(reg_out14),
        .EN(reg_en14)
    );

    Register_asyn R15(
        .clk(clk),
        .rst_n(rst_n),
        .din(DATA_BUS),
        .dout(reg_out15),
        .EN(reg_en15)
    );

    Register_asyn R_ADDER_IN(
        .clk(clk),
        .rst_n(rst_n),
        .din(DATA_BUS),
        .dout(reg_adder_in),
        .EN(reg_adder_in_en)
    );

    Register_asyn R_ADDER_OUT(
        .clk(clk),
        .rst_n(rst_n),
        .din(add_sub_out),
        .dout(reg_adder_out),
        .EN(reg_adder_out_en)
    );

    Register_asyn R_ADDR(
        .clk(clk),
        .rst_n(rst_n),
        .din(DATA_BUS),
        .dout(reg_addr_out),
        .EN(reg_addr_en)
    );

    Add_sub cpu_add_sub(
        .add(add_sub_mode),
        .num1(reg_adder_in),
        .num2(DATA_BUS),
        .result(add_sub_out)
    );


    Multiplexer core_mux(
        .CS(ctrl_unit_cs),
        .din0(reg_out0),
        .din1(reg_out1),
        .din2(reg_out2),
        .din3(reg_out3),
        .din4(reg_out4),
        .din5(reg_out5),
        .din6(reg_out6),
        .din7(reg_out7),
        .din8(reg_out8),
        .din9(reg_out9),
        .din10(reg_out10),
        .din11(reg_out11),
        .din12(reg_out12),
        .din13(reg_out13),
        .din14(reg_out14),
        .din15(reg_out15),
        .din16(reg_adder_out),
        .din17(PC),
        .din18(rdata_BUS),
        .din19(reg_addr_out),
        .din20(32'd0),
        .din21(32'd0),
        .din22(32'd0),
        .din23(32'd0),
        .din24(32'd0),
        .din25(32'd0),
        .din26(32'd0),
        .din27(32'd0),
        .din28(32'd0),
        .din29(32'd0),
        .din30(32'd0),
        .din31(32'd0),
        .dout(DATA_BUS)
    );

    BUS_controller CPU_BUS (
        .clk(clk),
        .rst_n(rst_n),
        .mode(mode_BUS),
        .rdata_valid(rdata_valid_BUS),
        .write_done(write_done_BUS),
        .start_transaction(start_transaction_BUS),
        .rdata(rdata_BUS),
        .addr(addr_BUS),
        .wdata(wdata_BUS),
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

