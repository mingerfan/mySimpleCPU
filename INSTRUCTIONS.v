`define R_OP 7'b011_0011
`define I_OP 7'b000_0011
`define S_OP 7'b010_0011
`define J_OP 7'b110_1111
`define IMM_OP 7'b001_0011
`define LUI_OP 7'b011_0111


`define R_FUN7_ADD 7'b000_0000
`define R_FUN7_SUB 7'b010_0000


`define R_FUN3_ADD 3'b000
`define R_FUN3_SUB 3'b000

`define I_FUN3_LW 3'b010

`define IMM_FUN3_ADDI 3'b000

`define S_FUN3_SW 3'b010

`define OP_range 6:0
`define FUN3_range 14:12
`define FUN7_range 31:25

`define rs1_range 19:15
`define rs2_range 24:20
`define rd_range 11:7

`define ADD_cnt  2'd0
`define ADDI_cnt 2'd0
`define SUB_cnt  2'd0
`define JAL_cnt  2'd0
`define LUI_cnt  2'd0
`define SW_cnt   2'd1
`define LW_cnt   2'd2

`define PC_CS_ALU  2'd0
`define PC_CS_reg1 2'd1
`define PC_CS_reg2 2'd2
`define PC_CS_IM   2'd3

`define PC_mode_inc 2'd0
`define PC_mode_jal 2'd1

`define reg_CS_ALU    3'd0
`define reg_CS_rdata1 3'd1
`define reg_CS_rdata2 3'd2
`define reg_CS_PC     3'd3
`define reg_CS_IM     3'd4
`define reg_CS_BUS    3'd5

`define ALU_mode_ADD 1'b1
`define ALU_mode_SUB 1'b0

`define ALU_CS1_reg0 2'd0
`define ALU_CS1_IM   2'd1
`define ALU_CS1_PC   2'd2
`define ALU_CS1_reg1 2'd3

`define ALU_CS2_reg0 2'd0
`define ALU_CS2_IM   2'd1
`define ALU_CS2_PC   2'd2
`define ALU_CS2_reg1 2'd3

`define BUS_ADDR_CS_ALU  3'd0
`define BUS_ADDR_CS_reg0 3'd1
`define BUS_ADDR_CS_reg1 3'd2
`define BUS_ADDR_CS_PC   3'd3
`define BUS_ADDR_CS_IM   3'd4

`define BUS_DATA_CS_ALU  2'd0
`define BUS_DATA_CS_reg0 2'd1
`define BUS_DATA_CS_reg1 2'd2
`define BUS_DATA_CS_IM   2'd3

`define BUS_mode_READ  1'b0
`define BUS_mode_WRITE 1'b1