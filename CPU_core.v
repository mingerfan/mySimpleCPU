`timescale 1ns / 1ps

module CPU_core(
    input clk,
    input rst_n,
    input [31:0] ROM_IN,
    input RUN,
    output [31:0] ADDR_BUS,
    output [31:0] DATA_WBUS,
    output BUS_VALID,
    input SLAVE_READY,
    output [31:0] ROM_ADDR
    );

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

    wire [31:0] reg_en0;
    wire [31:0] reg_en1;
    wire [31:0] reg_en2;
    wire [31:0] reg_en3;
    wire [31:0] reg_en4;
    wire [31:0] reg_en5;
    wire [31:0] reg_en6;
    wire [31:0] reg_en7;
    wire [31:0] reg_en8;
    wire [31:0] reg_en9;
    wire [31:0] reg_en10;
    wire [31:0] reg_en11;
    wire [31:0] reg_en12;
    wire [31:0] reg_en13;
    wire [31:0] reg_en14;
    wire [31:0] reg_en15;


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
        .din16(32'd0),
        .din17(32'd0),
        .din18(32'd0),
        .din19(32'd0),
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

    
    
endmodule

