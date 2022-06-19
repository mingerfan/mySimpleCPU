`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/17 10:46:28
// Design Name: 
// Module Name: BUS_slave
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


module BUS_slave #(
    parameter [6:0] DATA_WIDTH = 32,
    parameter [6:0] ADDR_WIDTH = 32,
    parameter [ADDR_WIDTH-1:0] START_ADDR = 'h0001_0000,
    parameter [ADDR_WIDTH-1:0] END_ADDR = 'h0001_FFFF
) 
(
    input clk,
    input rst_n,
    output write_en,
    output read_en,
    input write_ready,
    input read_valid,
    output [ADDR_WIDTH-1:0] addr,
    output [DATA_WIDTH-1:0] wdata,
    input [DATA_WIDTH-1:0] rdata,
    input [ADDR_WIDTH-1:0] BUS_addr,
    input [DATA_WIDTH-1:0] BUS_wdata,
    output [DATA_WIDTH-1:0] BUS_rdata,
    input BUS_valid,
    output BUS_wready,
    input BUS_rready,
    output BUS_rvalid,
    input BUS_mode
);

localparam [1:0] IDLE = 2'd0,
    WRITE = 2'd1,
    READ = 2'd2;

reg [1:0] cur_state, next_state;
// reg [ADDR_WIDTH-1:0] addr_r;
// reg [DATA_WIDTH-1:0] wdata_r;
reg [DATA_WIDTH-1:0] BUS_rdata_r;
reg BUS_wready_r;
reg BUS_rvalid_r;

reg write_en_r, read_en_r;

wire addr_match;

assign addr = addr_match ? (BUS_addr - START_ADDR) : 0;
assign wdata = BUS_wdata;
assign BUS_rdata = BUS_rdata_r;
assign BUS_wready = BUS_wready_r;
assign BUS_rvalid = BUS_rvalid_r;

assign write_en = write_en_r;
assign read_en = read_en_r;


assign addr_match = (BUS_addr >= START_ADDR) && (BUS_addr <= END_ADDR);

/************** write logic ***************/
always @(posedge clk or negedge rst_n) begin
    if (!rst_n || cur_state != WRITE) begin
        BUS_wready_r <= 1'b0;
    end
    else begin
        if (~BUS_wready_r && write_ready && BUS_valid) begin
            BUS_wready_r <= 1'b1;
        end
        else begin
            BUS_wready_r <= 1'b0;
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n || cur_state != WRITE) begin
        write_en_r <= 1'b0;
    end
    else begin
        if (~write_en_r && write_ready && BUS_valid) begin
            write_en_r <= 1'b1;
        end
        else begin
            write_en_r <= 1'b0;
        end
    end
end
/************** write logic end ***************/


/************** read logic *****************/
always @(posedge clk or negedge rst_n) begin
    if (!rst_n || cur_state != READ) begin
        BUS_rvalid_r <= 1'b0;
    end
    else begin
        if (BUS_valid && BUS_mode == 0 && addr_match && read_valid) begin
            BUS_rvalid_r <= 1'b1;
        end
        else if (BUS_rready && BUS_rvalid) begin
            BUS_rvalid_r <= 1'b0;
        end
        else begin
            BUS_rvalid_r <= BUS_rvalid_r;
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n || cur_state != READ) begin
        BUS_rdata_r <= 0;
    end
    else begin
        if (BUS_valid && BUS_mode == 0 && addr_match && read_valid) begin
            BUS_rdata_r <= rdata;
        end
        else begin
            BUS_rdata_r <= BUS_rdata_r;
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n || cur_state != READ) begin
        read_en_r <= 1'b0;
    end
    else begin
        if (BUS_valid && BUS_mode == 0 && addr_match) begin
            read_en_r <= 1'b1;
        end
        else if (read_valid) begin
            read_en_r <= 1'b0;
        end
        else begin
            read_en_r <= read_en_r;
        end
    end
end
/**************** read logic *****************/

/************** state machine *************/
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
            if (BUS_valid && BUS_mode == 0 && addr_match) begin
                next_state = READ;
            end
            else if (BUS_valid && BUS_mode == 1 && addr_match) begin
                next_state = WRITE;
            end
            else begin
                next_state = IDLE;
            end
        end
        READ: begin
            if (BUS_valid && BUS_rready) begin
                next_state = IDLE;
            end
            else begin
                next_state = READ;
            end
        end
        WRITE: begin
            if (BUS_valid && BUS_wready) begin
                next_state = IDLE;
            end
            else begin
                next_state = WRITE;
            end
        end
        default: next_state = IDLE; 
    endcase
end
/************** state machine end *************/

endmodule
