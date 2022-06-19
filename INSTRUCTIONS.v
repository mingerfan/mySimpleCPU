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