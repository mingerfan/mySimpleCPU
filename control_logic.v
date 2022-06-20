`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/19 19:18:45
// Design Name: 
// Module Name: control_logic
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

module control_logic(
    input BUS_rdata_valid,
    input BUS_write_done,
    input Mif,
    input Mex,
    input T1,
    input T2,
    input T3,
    input T4,
    input T1_Mif,
    input T2_Mif,
    input [2:0] cur_state,

    output reg output_done,
    output wire ins_reg_en,
    output reg reg_wen,
    output reg [2:0] reg_CS,
    output reg [1:0] PC_CS,
    output reg PC_EN,
    output reg PC_mode,
    output reg ALU_mode,
    output wire [1:0] ALU_CS1,
    output reg [1:0] ALU_CS2,
    output reg [2:0] BUS_ADDR_CS,
    output wire [2:0] BUS_DATA_CS,
    output reg BUS_mode,
    output reg BUS_start_transaction,
    
    input ins_ADD,
    input ins_SUB,
    input ins_SW, // save data to mem
    input ins_LW, // load data to reg
    input ins_ADDI, // immediate add
    input ins_LUI, // load immediate number
    input ins_JAL
    );

    localparam [2:0] IDLE = 3'd0,
        IF1 = 3'd1,
        IF2 = 3'd2,
        EX1 = 3'd3,
        EX2 = 3'd4,
        EX3 = 3'd5,
        EX4 = 3'd6;

    assign ins_reg_en = BUS_rdata_valid && Mif;

    always @(*) begin
        BUS_mode = 1'b0;
        if (Mif) begin
            BUS_mode = 1'b0; 
        end
        else if (Mex && ins_SW) begin
            BUS_mode = `BUS_mode_WRITE;
        end
        else if (Mex && ins_LW) begin
            BUS_mode = `BUS_mode_READ;
        end
        else begin
            BUS_mode = 1'b0;
        end
    end

    always @(*) begin
        BUS_start_transaction = 1'b0;
        if (Mif && T1_Mif) begin
            BUS_start_transaction = 1'b1;
        end
        else if (Mex && ins_SW && T2) begin
            BUS_start_transaction = 1'b1;
        end
        else if (Mex && ins_LW && T2) begin
            BUS_start_transaction = 1'b1;
        end
        else begin
            BUS_start_transaction = 1'b0;
        end
    end

    always @(*) begin
        output_done = 1'b0;
        if (Mif) begin
            output_done = BUS_rdata_valid;
        end
        else if (Mex && ins_SW && cur_state == EX2) begin
            output_done = BUS_write_done;
        end
        else if (Mex && ins_LW && cur_state == EX2) begin
            output_done = BUS_rdata_valid;
        end
        else begin
            output_done = T1 || T2 || T3 || T4;
        end
    end

    always @(*) begin
        reg_wen = 1'b0;
        if (Mex && ins_ADD && T1) begin
            reg_wen = 1'b1;
        end
        else if (Mex && ins_ADDI && T1) begin
            reg_wen = 1'b1;
        end
        else if (Mex && ins_SUB && T1) begin
            reg_wen = 1'b1;
        end
        else if (Mex && ins_LW && T3) begin
            reg_wen = 1'b1;
        end
        else if (Mex && ins_LUI && T1) begin
            reg_wen = 1'b1;
        end
        else if (Mex && ins_JAL && T1) begin
            reg_wen = 1'b1;
        end
        else begin
            reg_wen = 1'b0;
        end
    end

    always @(*) begin
        reg_CS = `reg_CS_ALU;
        if (Mex && (ins_ADD || ins_ADDI || ins_SUB)) begin
            reg_CS = `reg_CS_ALU;
        end
        else if (Mex && ins_LW) begin
            reg_CS = `reg_CS_BUS;
        end
        else if (Mex && ins_LUI) begin
            reg_CS = `reg_CS_IM;
        end
        else if (Mex && ins_JAL) begin
            reg_CS = `reg_CS_PC;
        end
    end

    always @(*) begin
        PC_CS = 2'd0;
        // don't need for mode will set it
        // if (Mif && T1) begin
        //     PC_CS = PC_CS_ALU;
        // end
        if (ins_JAL) begin
            PC_CS = `PC_CS_ALU;
        end
        else begin
            PC_CS = 2'd0;
        end
    end

    always @(*) begin
        PC_mode = `PC_mode_inc;
        if (Mif) begin
            PC_mode = `PC_mode_inc;
        end
        else if (ins_JAL) begin
            PC_mode = `PC_mode_jal;
        end
        else begin
            PC_mode = `PC_mode_inc;
        end
    end

    always @(*) begin
        PC_EN = 1'b0;
        if (Mif && T1_Mif) begin
            PC_EN = 1'b1;
        end
        else if (Mex && ins_JAL) begin
            PC_EN = 1'b1;
        end
        else begin
            PC_EN = 1'b0;
        end
    end

    always @(*) begin
        ALU_mode = `ALU_mode_ADD;
        if (ins_ADD || ins_ADDI) begin
            ALU_mode = `ALU_mode_ADD;
        end
        else if (ins_SUB) begin
            ALU_mode = `ALU_mode_SUB;
        end
    end

   assign ALU_CS1 = `ALU_CS1_reg0;

    always @(*) begin
        ALU_CS2 = `ALU_CS2_reg1;
        if (ins_ADDI || ins_SW || ins_LW) begin
            ALU_CS2 = `ALU_CS2_IM;
        end
        else begin
            ALU_CS2 = `ALU_CS2_reg1;
        end
    end

    always @(*) begin
        BUS_ADDR_CS = `BUS_ADDR_CS_PC;
        if (Mif) begin
            BUS_ADDR_CS = `BUS_ADDR_CS_PC;
        end
        else if (Mex && ins_SW) begin
            BUS_ADDR_CS = `BUS_ADDR_CS_ALU;
        end
        else if (Mex && ins_LW) begin
            BUS_ADDR_CS = `BUS_ADDR_CS_ALU;
        end
        else begin
            BUS_ADDR_CS = `BUS_ADDR_CS_PC;
        end
    end
    
    assign BUS_DATA_CS = `BUS_DATA_CS_reg0;

endmodule
