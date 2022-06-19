module BUS_controller_top #(
    parameter [6:0] DATA_WIDTH = 32,
    parameter [6:0] ADDR_WIDTH = 32
)
(
    input clk,
    input rst_n,
    input mode, // mode 0 read, mode 1 write
    input [2:0] addr_CS,
    input [1:0] data_CS,
    input [31:0] ALU_din,
    input [31:0] reg_din0,
    input [31:0] reg_din1,
    input [31:0] IM_din,
    input [31:0] ALU_addrin,
    input [31:0] reg_addrin0,
    input [31:0] reg_addrin1,
    input [31:0] PC_addrin,
    input [31:0] IM_addrin,
    output rdata_valid,
    output write_done,
    input start_transaction,
    output [DATA_WIDTH-1:0] rdata,
    output [ADDR_WIDTH-1:0] BUS_addr,
    output [DATA_WIDTH-1:0] BUS_wdata,
    input [DATA_WIDTH-1:0] BUS_rdata,
    output BUS_valid,
    input BUS_wready,
    output BUS_rready,
    input BUS_rvalid,
    output BUS_mode
);

//    wire [31:0] rdata;
    wire [31:0] addr;
    wire [31:0] wdata;

    Multiplexer4to1 DATA_MUX(
        .CS(data_CS),
        .din0(ALU_din),
        .din1(reg_din0),
        .din2(reg_din1),
        .din3(IM_din),
        .dout(wdata)
    );

    Multiplexer8to1 ADDR_MUX(
        .CS(addr_CS),
        .din0(ALU_addrin),
        .din1(reg_addrin0),
        .din2(reg_addrin1),
        .din3(PC_addrin),
        .din4(IM_addrin),
        .din5(32'd0),
        .din6(32'd0),
        .din7(32'd0),
        .dout(addr)
    );

    BUS_controller CPU_BUS (
        .clk(clk),
        .rst_n(rst_n),
        .mode(mode),
        .rdata_valid(rdata_valid),
        .write_done(write_done),
        .start_transaction(start_transaction),
        .rdata(rdata),
        .addr(addr),
        .wdata(wdata),
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