module Multiplexer2to1 #(
    parameter width = 32
) 
(
    input [0:0] CS,

    input [width-1:0] din0,
    input [width-1:0] din1,

    output reg [width-1:0] dout
);

always @(*) begin
    case (CS)
        1'b0: dout = din0;
        1'b1: dout = din1; 
        default: dout = 32'd0;
    endcase
end
    
endmodule