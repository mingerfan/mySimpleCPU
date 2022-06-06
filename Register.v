`timescale 1ns / 1ps


module Register_asyn #(
    parameter width = 32
)
(
    input clk,
    input rst_n,
    input [width-1:0] din,
    output [width-1:0] dout,
    input EN
);

    reg [width-1:0] dout_r;
    assign dout = dout_r;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dout_r <= 32'b0;
        end
        else begin
            if (EN == 1'b1) begin
                dout_r <= din;
            end
            else begin
                dout_r <= dout_r;
            end
        end
    end

endmodule
