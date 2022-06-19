`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/19 12:33:41
// Design Name: 
// Module Name: timing_generate
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


module timing_generate(
    input clk,
    input rst_n,
    input RUN,
    input stop,
    input done,
    input [1:0] cnt_set,
    output Mif,
    output Mex,
    output T1,
    output T2,
    output T3,
    output T4
    );

    parameter [2:0] IDLE = 3'd0,
        IF1 = 3'd1,
        IF2 = 3'd2,
        EX1 = 3'd3,
        EX2 = 3'd4,
        EX3 = 3'd5,
        EX4 = 3'd6;

    reg [3:0] cur_state, next_state;
    reg [1:0] cnt;
    reg Mif_r, Mex_r, T1_r, T2_r, T3_r, T4_r;

    assign Mif = Mif_r;
    assign Mex = Mex_r;
    assign T1 = T1_r;
    assign T2 = T2_r;
    assign T3 = T3_r;
    assign T4 = T4_r;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cur_state <= IDLE;
        end
        else begin
            cur_state <= next_state;
        end
    end

    always @(*) begin
        next_state = IDLE;
        case (cur_state)
            IDLE: begin
                if (RUN == 1'b1) begin
                    next_state = IF1;
                end
                else begin
                    next_state = IDLE;
                end
            end 
            IF1: begin
                if (done) begin
                    next_state = IF2;
                end
                else begin
                    next_state = IF1;
                end
            end
            IF2: begin
                if (done && stop) begin
                    next_state = IDLE;
                end
                else if (done && ~stop) begin
                    next_state = EX1;
                end
                else begin
                    next_state = IF2;
                end
            end
            EX1: begin
                if (done && cnt != 0) begin
                    next_state = EX2;
                end
                else if (done && cnt == 0) begin
                    next_state = IF1;
                end
                else begin
                    next_state = EX1;
                end
            end
            EX2: begin
                if (done && cnt != 0) begin
                    next_state = EX3;
                end
                else if (done && cnt == 0) begin
                    next_state = IF1;
                end
                else begin
                    next_state = EX2;
                end
            end
            EX3: begin
                if (done && cnt != 0) begin
                    next_state = EX4;
                end
                else if (done && cnt == 0) begin
                    next_state = IF1;
                end
            end
            EX4: begin
                if (done) begin
                    next_state = IF1;
                end
                else begin
                    next_state = EX4;
                end
            end
            default: next_state = IDLE;
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            Mif_r = 1'b0;
            Mex_r = 1'b0;
            T1_r = 1'b0;
            T2_r = 1'b0;
            T3_r = 1'b0;
            T4_r = 1'b0;
            cnt = 2'd0;
        end
        else begin
            case (next_state)
                IDLE: begin
                    Mif_r = 1'b0;
                    Mex_r = 1'b0;
                    T1_r = 1'b0;
                    T2_r = 1'b0;
                    T3_r = 1'b0;
                    T4_r = 1'b0;
                end
                IF1: begin
                    Mif_r = 1'b1;
                    Mex_r = 1'b0;
                    T1_r = 1'b1;
                    T2_r = 1'b0;
                    T3_r = 1'b0;
                    T4_r = 1'b0;
                end 
                IF2: begin
                    Mif_r = 1'b1;
                    Mex_r = 1'b0;
                    T1_r = 1'b0;
                    T2_r = 1'b1;
                    T3_r = 1'b0;
                    T4_r = 1'b0;                    
                end
                EX1: begin
                    cnt = cnt_set;
                    Mif_r = 1'b0;
                    Mex_r = 1'b1;
                    T1_r = 1'b1;
                    T2_r = 1'b0;
                    T3_r = 1'b0;
                    T4_r = 1'b0;                    
                end
                EX2: begin
                    Mif_r = 1'b0;
                    Mex_r = 1'b1;
                    T1_r = 1'b0;
                    T2_r = 1'b1;
                    T3_r = 1'b0;
                    T4_r = 1'b0;                    
                end
                EX3: begin
                    Mif_r = 1'b0;
                    Mex_r = 1'b1;
                    T1_r = 1'b0;
                    T2_r = 1'b0;
                    T3_r = 1'b1;
                    T4_r = 1'b0;                     
                end
                EX4: begin
                    Mif_r = 1'b0;
                    Mex_r = 1'b1;
                    T1_r = 1'b0;
                    T2_r = 1'b0;
                    T3_r = 1'b0;
                    T4_r = 1'b1;                     
                end
                default: begin
                    Mif_r = 1'b0;
                    Mex_r = 1'b0;
                    T1_r = 1'b0;
                    T2_r = 1'b0;
                    T3_r = 1'b0;
                    T4_r = 1'b0;                    
                end
            endcase
        end
    end

endmodule
