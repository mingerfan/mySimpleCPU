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

    reg T1_act, T2_act, T3_act, T4_act;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n || (next_state != EX1 && next_state != IF1)) begin
            T1_act <= 1'b0;
        end
        else if (T1) begin
            T1_act <= 1'b1;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n || (next_state != EX2 && next_state != IF2)) begin
            T2_act <= 1'b0;
        end
        else if (T2) begin
            T2_act <= 1'b1;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n || next_state != EX3) begin
            T3_act <= 1'b0;
        end
        else if (T3) begin
            T3_act <= 1'b1;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n || next_state != EX4) begin
            T4_act <= 1'b0;
        end
        else if (T4) begin
            T4_act <= 1'b1;
        end
    end

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
                if (stop) begin
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
                    T2_r = 1'b0;
                    T3_r = 1'b0;
                    T4_r = 1'b0;
                    if (~T1_act && ~T1) begin
                        T1_r = 1'b1;
                    end
                    else begin
                        T1_r = 1'b0;
                    end 
                end 
                IF2: begin
                    Mif_r = 1'b1;
                    Mex_r = 1'b0;
                    T1_r = 1'b0;
                    T3_r = 1'b0;
                    T4_r = 1'b0; 
                    if (~T2_act && ~T2) begin
                        T2_r = 1'b1;
                    end
                    else begin
                        T2_r = 1'b0;
                    end                          
                end
                EX1: begin
                    cnt = cnt_set;
                    Mif_r = 1'b0;
                    Mex_r = 1'b1;
                    T2_r = 1'b0;
                    T3_r = 1'b0;
                    T4_r = 1'b0;
                    if (~T1_act && ~T1) begin
                        T1_r = 1'b1;
                    end
                    else begin
                        T1_r = 1'b0;
                    end 
                end
                EX2: begin
                    Mif_r = 1'b0;
                    Mex_r = 1'b1;
                    T1_r = 1'b0;
                    T3_r = 1'b0;
                    T4_r = 1'b0;
                    if (~T2_act && ~T2) begin
                        T2_r = 1'b1;
                    end
                    else begin
                        T2_r = 1'b0;
                    end                     
                end
                EX3: begin
                    Mif_r = 1'b0;
                    Mex_r = 1'b1;
                    T1_r = 1'b0;
                    T2_r = 1'b0;
                    T4_r = 1'b0;
                    if (~T3_act && ~T3) begin
                        T3_r = 1'b1;
                    end
                    else begin
                        T3_r = 1'b0;
                    end                           
                end
                EX4: begin
                    Mif_r = 1'b0;
                    Mex_r = 1'b1;
                    T1_r = 1'b0;
                    T2_r = 1'b0;
                    T3_r = 1'b0;
                    if (~T4_act && ~T4) begin
                        T4_r = 1'b1;
                    end
                    else begin
                        T4_r = 1'b0;
                    end                          
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
