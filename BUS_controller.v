`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/16 22:14:02
// Design Name: 
// Module Name: BUS_controller
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


module BUS_controller #(
    parameter [6:0] DATA_WIDTH = 32,
    parameter [6:0] ADDR_WIDTH = 32
)
(
    input clk,
    input rst_n,
    input mode, // mode 0 read, mode 1 write
    output rdata_valid,
    output write_done,
    input start_transaction,
    output [DATA_WIDTH-1:0] rdata,
    input [ADDR_WIDTH-1:0] addr,
    input [DATA_WIDTH-1:0] wdata,
    output [ADDR_WIDTH-1:0] BUS_addr,
    output [DATA_WIDTH-1:0] BUS_wdata,
    input [DATA_WIDTH-1:0] BUS_rdata,
    output BUS_valid,
    input BUS_wready,
    output BUS_rready,
    input BUS_rvalid,
    output BUS_mode
);

localparam [1:0] IDLE = 2'd0,
    WRITE = 2'd1,
    READ = 2'd2;

reg [1:0] cur_state, next_state;
reg start_write, write_active;
reg start_read, read_active;

// reg rdata_valid_r;
reg [DATA_WIDTH-1:0] rdata_r;

reg [ADDR_WIDTH-1:0] BUS_addr_r;
reg [DATA_WIDTH-1:0] BUS_wdata_r;
reg [DATA_WIDTH-1:0] BUS_rdata_r;
reg BUS_wvalid_r;
reg BUS_rready_r;
reg BUS_mode_r;

wire write_done_in;
wire read_done;

assign write_done = write_done_in;
assign rdata_valid = read_done;

// assign rdata_valid = rdata_valid_r;
assign rdata = rdata_r;

assign BUS_addr = BUS_addr_r;
assign BUS_wdata = BUS_wdata_r;
assign BUS_valid = (cur_state == WRITE) ? BUS_wvalid_r : (start_read || read_active);
assign BUS_rready = BUS_rready_r;
assign BUS_mode = BUS_mode_r;


always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        BUS_addr_r <= 0;
    end
    else begin
        if (start_transaction) begin
            BUS_addr_r <= addr;
        end
        else begin
            BUS_addr_r <= BUS_addr_r;
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        BUS_mode_r <= 1'b0;
    end
    else begin
        if (start_transaction) begin
            BUS_mode_r <= mode;
        end
        else begin
            BUS_mode_r <= BUS_mode_r;
        end
    end
end

/************** write logic **************/
assign write_done_in = BUS_wvalid_r & BUS_wready;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n || cur_state == IDLE) begin
        write_active <= 1'b0;
    end
    else begin
        if (start_write && ~write_active) begin
            write_active <= 1'b1;
        end
        else if (write_active && write_done_in) begin
            write_active <= 1'b0;
        end
        else begin
            write_active <= write_active;
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n || cur_state == IDLE) begin
        BUS_wvalid_r <= 1'b0;
    end
    else begin
        if (start_write) begin
            BUS_wvalid_r <= 1'b1;
        end
        else if (BUS_wvalid_r && write_active && BUS_wready) begin
            BUS_wvalid_r <= 1'b0;
        end
        else begin
            BUS_wvalid_r <= BUS_wvalid_r;
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        BUS_wdata_r <= 0;
    end
    else if (start_transaction && mode == 1) begin
        BUS_wdata_r <= wdata;
    end
    else begin
        BUS_wdata_r <= BUS_wdata_r;
    end
end
/************** write logic end **************/

assign read_done = BUS_rvalid & BUS_rready;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n || cur_state == IDLE) begin
        read_active <= 1'b0;
    end
    else begin
        if (start_read && ~read_active) begin
            read_active <= 1'b1;
        end
        else if (read_active && read_done) begin
            read_active <= 1'b0;
        end
        else begin
            read_active <= read_active;
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n || cur_state == IDLE) begin
        BUS_rready_r <= 1'b0;
    end
    else begin
        if (BUS_rvalid && read_active && ~BUS_rready_r) begin
            BUS_rready_r <= 1'b1;
        end
        else begin
            BUS_rready_r <= 1'b0;
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        rdata_r <= 0;
    end
    else begin
        if (BUS_rvalid && read_active) begin
            rdata_r <= BUS_rdata;
        end
        else begin
            rdata_r <= rdata_r;
        end
    end
end
/***************** state machine *****************/
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cur_state <= 1'b0;
    end
    else begin
        cur_state <= next_state;
    end
end

always @(*) begin
    next_state = IDLE;
    case (cur_state)
        IDLE: begin
            if (start_transaction && mode == 0) begin
                next_state = READ;
            end
            else if (start_transaction && mode == 1) begin
                next_state = WRITE;
            end
            else begin
                next_state = IDLE;
            end
        end 
        WRITE: begin
            if (write_active && write_done_in) begin
                next_state = IDLE;
            end
            else begin
                next_state = WRITE;
            end
        end
        READ: begin
            if (read_active && read_done) begin
                next_state = IDLE;
            end
            else begin
                next_state = READ;
            end
        end
        default: next_state = IDLE;
    endcase
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cur_state <= 1'b0;
        start_write <= 1'b0;
        start_read <= 1'b0;
    end
    else begin
        case (cur_state)
            WRITE: begin
                if (~start_write && ~write_active) begin
                    start_write <= 1'b1;
                end
                else begin
                    start_write <= 1'b0;
                end
            end 
            READ: begin
                if (~start_read && ~read_active) begin
                    start_read <= 1'b1;
                end
                else begin
                    start_read <= 1'b0;
                end
            end
        endcase
    end
end
/***************** state machine end *****************/

endmodule