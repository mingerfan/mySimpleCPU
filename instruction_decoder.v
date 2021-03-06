`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/19 15:18:26
// Design Name: 
// Module Name: instruction_decoder
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
`include "INSTRUCTIONS.v"

module instruction_decoder(
    input [31:0] instruction,
    output ins_ADD,
    output ins_SUB,
    output ins_SW, // save data to mem
    output ins_LW, // load data to reg
    output ins_ADDI, // immediate add
    output ins_LUI, // load immediate number
    output ins_JAL,
    output [31:0] IM,
    output reg [4:0] reg_rs1,
    output reg [4:0] reg_rs2,
    output reg [4:0] reg_rd,
    output [1:0] cnt_set,
    output stop
    );

    wire R, I, S, J, IMM, LUI;

    reg [1:0] cnt_set_r;
    assign cnt_set = cnt_set_r;

    reg [31:0] IM_in;
    assign IM = IM_in;

    assign stop = ~R & ~I & ~S & ~J & ~IMM & ~LUI;

    assign R = (instruction[`OP_range] == `R_OP);
    assign I = (instruction[`OP_range] == `I_OP);
    assign S = (instruction[`OP_range] == `S_OP);
    assign J = (instruction[`OP_range] == `J_OP);
    assign IMM = (instruction[`OP_range] == `IMM_OP);
    assign LUI = (instruction[`OP_range] == `LUI_OP);

    assign ins_ADD = R && (instruction[`FUN3_range] == `R_FUN3_ADD)
        && (instruction[`FUN7_range] ==`R_FUN7_ADD);
    
    assign ins_SUB = R && (instruction[`FUN3_range] == `R_FUN3_SUB)
        && (instruction[`FUN7_range] == `R_FUN7_SUB);
    
    assign ins_LW = I && (instruction[`FUN3_range] == `I_FUN3_LW);
    assign ins_SW = S && (instruction[`FUN3_range] == `S_FUN3_SW);
    assign ins_JAL = J;
    assign ins_ADDI = IMM && (instruction[`FUN3_range] == `IMM_FUN3_ADDI);
    assign ins_LUI = LUI;
    
    
    always @(*) begin
        IM_in = 32'b0;
        if (ins_LW) begin
            IM_in = {20'b0, instruction[31:20]};
        end
        else if (ins_SW) begin
            IM_in = {20'b0, instruction[31:25],instruction[11:7]};
        end
        else if (ins_ADDI) begin
            IM_in = {{20{instruction[31]}}, instruction[31:20]};
        end
        else if (ins_LUI) begin
            IM_in = {instruction[31:12], 12'b0};
        end
        else if (ins_JAL) begin
            IM_in = {11'b0 ,instruction[31], instruction[19:12], 
            instruction[20], instruction[30:21], 1'b0};
        end
        else begin
            IM_in = 32'b0;
        end
    end

    always @(*) begin
        reg_rs1 = 5'b0;
        if (ins_LW) begin
            reg_rs1 = instruction[`rs1_range];
        end
        else if (ins_SW) begin
            reg_rs1 = instruction[`rs1_range];
        end
        else if (ins_ADD) begin
            reg_rs1 = instruction[`rs1_range];
        end
        else if (ins_SUB) begin
            reg_rs1 = instruction[`rs1_range];
        end
        else if (ins_ADDI) begin
            reg_rs1 = instruction[`rs1_range];
        end
        else begin
            reg_rs1 = 5'b0;
        end
    end

    always @(*) begin
        reg_rs2 = 5'b0;
        if (ins_SW) begin
            reg_rs2 = instruction[`rs2_range];
        end
        else if (ins_ADD) begin
            reg_rs2 = instruction[`rs2_range];
        end
        else if (ins_SUB) begin
            reg_rs2 = instruction[`rs2_range];
        end
        else begin
            reg_rs2 = 5'b0;
        end
    end

    always @(*) begin
        reg_rd = 5'b0;
        if (ins_LW) begin
            reg_rd = instruction[`rd_range];
        end
        else if (ins_ADD) begin
            reg_rd = instruction[`rd_range];
        end
        else if (ins_SUB) begin
            reg_rd = instruction[`rd_range];
        end
        else if (ins_ADDI) begin
            reg_rd = instruction[`rd_range];
        end
        else if (ins_LUI) begin
            reg_rd = instruction[`rd_range];
        end
        else if (ins_JAL) begin
            reg_rd = instruction[`rd_range];
        end
        else begin
            reg_rd = 5'b0;
        end
    end

    always @(*) begin
        cnt_set_r = 2'd0;
        if (ins_ADD) begin
            cnt_set_r = `ADD_cnt;
        end
        else if (ins_ADDI) begin
            cnt_set_r = `ADDI_cnt;
        end
        else if (ins_SUB) begin
            cnt_set_r = `SUB_cnt;
        end
        else if (ins_JAL) begin
            cnt_set_r = `JAL_cnt;
        end
        else if (ins_LUI) begin
            cnt_set_r = `LUI_cnt;
        end
        else if (ins_SW) begin
            cnt_set_r = `SW_cnt;
        end
        else if (ins_LW) begin
            cnt_set_r = `LW_cnt;
        end
        else begin
            cnt_set_r = 2'd0;
        end
    end

endmodule
