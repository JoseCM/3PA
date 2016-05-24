`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 09.04.2016 13:01:52
// Design Name:
// Module Name: pipelinedefs
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
`ifndef	_PIPE_DEFS_
`define _PIPE_DEFS_


/**************************************************
*
*   IF/ID Pipeline Registers
*
**************************************************/


`define INST_WIDTH      32
`define VALID_WIDTH      1
`define PC_WIDTH        32
`define PPCCB_WIDTH     34
`define IC_WIDTH        32

`define IFID_WIDTH           (`INST_WIDTH + `VALID_WIDTH + `PC_WIDTH + `PPCCB_WIDTH + `IC_WIDTH)

`define IFID_INST_LSB        (0)
`define IFID_INST_MSB        (`INST_WIDTH - 1 + `IFID_INST_LSB)
`define IFID_INST            `IFID_INST_MSB : `IFID_INST_LSB

`define IFID_VALID_LSB       (`IFID_INST_MSB + 1)
`define IFID_VALID_MSB       (`VALID_WIDTH - 1 + `IFID_VALID_LSB)
`define IFID_VALID           `IFID_VALID_MSB : `IFID_VALID_LSB

`define IFID_PC_LSB          (`IFID_VALID_MSB + 1)
`define IFID_PC_MSB          (`PC_WIDTH - 1 + `IFID_PC_LSB)
`define IFID_PC              `IFID_PC_MSB : `IFID_PC_LSB

`define IFID_PPCCB_LSB       (`IFID_PC_MSB + 1)
`define IFID_PPCCB_MSB       (`PPCCB_WIDTH - 1 + `IFID_PPCCB_LSB)
`define IFID_PPCCB           `IFID_PPCCB_MSB : `IFID_PPCCB_LSB

`define IFID_IC_LSB          (`IFID_PPCCB_MSB + 1)
`define IFID_IC_MSB          (`IC_WIDTH - 1 + `IFID_IC_LSB)
`define IFID_IC              `IFID_IC_MSB : `IFID_IC_LSB

/**************************************************
*
*   ID/EX Pipeline Registers
*
**************************************************/

`define WB_WIDTH                  3 // RE_Enable + RDST(2)
`define MA_WIDTH                  2 // enable + R/W
`define EX_WIDTH                 16 // needs(2) + alu_src1(2) + alu_src2(1) + cc_we(1) + alu_ctrl(4) + jump/branchinst(2) + condbits(4)
`define OP1_WIDTH                32
`define OP2_WIDTH                32
`define IM_WIDTH                 32
`define RDSADDR_WIDTH             5 //Modified
`define RS1ADDR_WIDTH             5
`define RS2ADDR_WIDTH             5

`define IDEX_WIDTH     (`WB_WIDTH + `MA_WIDTH + `EX_WIDTH + `VALID_WIDTH + `OP1_WIDTH + `OP2_WIDTH + `IM_WIDTH + `RDSADDR_WIDTH + `RS1ADDR_WIDTH + `RS2ADDR_WIDTH + `PC_WIDTH + `PPCCB_WIDTH + `IC_WIDTH)

`define IDEX_WB_LSB        (0)
`define IDEX_WB_MSB        (`WB_WIDTH - 1 + `IDEX_WB_LSB)
`define IDEX_WB            `IDEX_WB_MSB : `IDEX_WB_LSB
/*Control Values for Execute*/
`define WB_R_WE     2
`define WB_RDST_MUX 1:0

`define IDEX_MA_LSB        (`IDEX_WB_MSB + 1)
`define IDEX_MA_MSB        (`MA_WIDTH - 1 + `IDEX_MA_LSB)
`define IDEX_MA            `IDEX_MA_MSB : `IDEX_MA_LSB

/*Control Values for MA stage*/
`define MA_RW 1
`define MA_EN 0

`define IDEX_EX_LSB        (`IDEX_MA_MSB + 1)
`define IDEX_EX_MSB        (`EX_WIDTH - 1 + `IDEX_EX_LSB)
`define IDEX_EX            `IDEX_EX_MSB : `IDEX_EX_LSB

/* Control Values for execute stage*/
`define EX_CondBits     15:12
`define EX_ALUCTRL      11:8
`define EX_ALU_SRC1     7:6
`define EX_ALU_SRC2     5
`define EX_CC_WE        4
`define EX_JMP          3
`define EX_BXX          2
`define EX_NEED_RS1     1
`define EX_NEED_RS2     0


`define IDEX_VALID_LSB     (`IDEX_EX_MSB + 1)
`define IDEX_VALID_MSB     (`VALID_WIDTH - 1 + `IDEX_VALID_LSB)
`define IDEX_VALID         `IDEX_VALID_MSB : `IDEX_VALID_LSB

`define IDEX_OP1_LSB       (`IDEX_VALID_MSB + 1)
`define IDEX_OP1_MSB       (`OP1_WIDTH - 1 + `IDEX_OP1_LSB)
`define IDEX_OP1           `IDEX_OP1_MSB : `IDEX_OP1_LSB

`define IDEX_OP2_LSB       (`IDEX_OP1_MSB + 1)
`define IDEX_OP2_MSB       (`OP2_WIDTH - 1 + `IDEX_OP2_LSB)
`define IDEX_OP2           `IDEX_OP2_MSB : `IDEX_OP2_LSB

`define IDEX_IM_LSB        (`IDEX_OP2_MSB + 1)
`define IDEX_IM_MSB        (`IM_WIDTH - 1 + `IDEX_IM_LSB)
`define IDEX_IM            `IDEX_IM_MSB : `IDEX_IM_LSB

`define IDEX_RDSADDR_LSB       (`IDEX_IM_MSB + 1)
`define IDEX_RDSADDR_MSB       (`RDSADDR_WIDTH - 1 + `IDEX_RDSADDR_LSB)
`define IDEX_RDSADDR           `IDEX_RDSADDR_MSB : `IDEX_RDSADDR_LSB

`define IDEX_RS1ADDR_LSB   (`IDEX_RDSADDR_MSB + 1)
`define IDEX_RS1ADDR_MSB   (`RS1ADDR_WIDTH - 1 + `IDEX_RS1ADDR_LSB)
`define IDEX_RS1ADDR       `IDEX_RS1ADDR_MSB : `IDEX_RS1ADDR_LSB

`define IDEX_RS2ADDR_LSB        (`IDEX_RS1ADDR_MSB + 1)
`define IDEX_RS2ADDR_MSB        (`RS2ADDR_WIDTH - 1 + `IDEX_RS2ADDR_LSB)
`define IDEX_RS2ADDR            `IDEX_RS2ADDR_MSB : `IDEX_RS2ADDR_LSB

`define IDEX_PC_LSB          (`IDEX_RS2ADDR_MSB + 1)
`define IDEX_PC_MSB          (`PC_WIDTH - 1 + `IDEX_PC_LSB)
`define IDEX_PC              `IDEX_PC_MSB : `IDEX_PC_LSB

`define IDEX_PPCCB_LSB       (`IDEX_PC_MSB + 1)
`define IDEX_PPCCB_MSB       (`PPCCB_WIDTH - 1 + `IDEX_PPCCB_LSB)
`define IDEX_PPCCB           `IDEX_PPCCB_MSB : `IDEX_PPCCB_LSB

`define IDEX_IC_LSB          (`IDEX_PPCCB_MSB + 1)
`define IDEX_IC_MSB          (`IC_WIDTH - 1 + `IDEX_IC_LSB)
`define IDEX_IC              `IDEX_IC_MSB : `IDEX_IC_LSB

/**************************************************
*
*   EX/MA Pipeline Registers
*
**************************************************/

`define ALURSLT_WIDTH   32
`define RS2VAL_WIDTH    32

`define EXMA_WIDTH     (`WB_WIDTH + `MA_WIDTH + `ALURSLT_WIDTH + `RS2VAL_WIDTH +  `RS2ADDR_WIDTH + `PC_WIDTH  + `RDSADDR_WIDTH)

`define EXMA_WB_LSB        (0)
`define EXMA_WB_MSB        (`WB_WIDTH - 1 + `EXMA_WB_LSB)
`define EXMA_WB            `EXMA_WB_MSB : `EXMA_WB_LSB

`define EXMA_MA_LSB        (`EXMA_WB_MSB + 1)
`define EXMA_MA_MSB        (`MA_WIDTH - 1 + `EXMA_MA_LSB)
`define EXMA_MA            `EXMA_MA_MSB : `EXMA_MA_LSB

`define EXMA_ALURSLT_LSB        (`EXMA_MA_MSB + 1)
`define EXMA_ALURSLT_MSB        (`ALURSLT_WIDTH - 1 + `EXMA_ALURSLT_LSB)
`define EXMA_ALURSLT            `EXMA_ALURSLT_MSB : `EXMA_ALURSLT_LSB

`define EXMA_RS2VAL_LSB        (`EXMA_ALURSLT_MSB + 1)
`define EXMA_RS2VAL_MSB        (`RS2VAL_WIDTH - 1 + `EXMA_RS2VAL_LSB)
`define EXMA_RS2VAL            `EXMA_RS2VAL_MSB : `EXMA_RS2VAL_LSB

`define EXMA_RS2ADDR_LSB        (`EXMA_RS2VAL_MSB + 1)
`define EXMA_RS2ADDR_MSB        (`RS2ADDR_WIDTH - 1 + `EXMA_RS2ADDR_LSB)
`define EXMA_RS2ADDR            `EXMA_RS2ADDR_MSB : `EXMA_RS2ADDR_LSB

`define EXMA_PC_LSB        (`EXMA_RS2ADDR_MSB + 1)
`define EXMA_PC_MSB        (`PC_WIDTH - 1 + `EXMA_PC_LSB)
`define EXMA_PC            `EXMA_PC_MSB : `EXMA_PC_LSB

`define EXMA_RDS_LSB        (`EXMA_PC_MSB + 1)
`define EXMA_RDS_MSB        (`RDSADDR_WIDTH - 1 + `EXMA_RDS_LSB)
`define EXMA_RDS            `EXMA_RDS_MSB : `EXMA_RDS_LSB

/**************************************************
*
*   MA/WB Pipeline Registers
*
**************************************************/

`define MEMOUT_WIDTH  32

`define MAWB_WIDTH              (`WB_WIDTH + `PC_WIDTH + `RDSADDR_WIDTH + `ALURSLT_WIDTH + `MEMOUT_WIDTH)

`define MAWB_WB_LSB             (0)
`define MAWB_WB_MSB             (`WB_WIDTH - 1 + `MAWB_WB_LSB)
`define MAWB_WB                 `MAWB_WB_MSB : `MAWB_WB_LSB

`define MAWB_ALURSLT_LSB        (`MAWB_WB_MSB + 1)
`define MAWB_ALURSLT_MSB        (`ALURSLT_WIDTH - 1 + `MAWB_ALURSLT_LSB)
`define MAWB_ALURSLT            `MAWB_ALURSLT_MSB : `MAWB_ALURSLT_LSB

`define MAWB_MEMOUT_LSB         (`MAWB_ALURSLT_MSB + 1)
`define MAWB_MEMOUT_MSB         (`MEMOUT_WIDTH - 1 + `MAWB_MEMOUT_LSB)
`define MAWB_MEMOUT             `MAWB_MEMOUT_MSB : `MAWB_MEMOUT_LSB

`define MAWB_PC_LSB             (`MAWB_MEMOUT_MSB + 1)
`define MAWB_PC_MSB             (`PC_WIDTH - 1 + `MAWB_PC_LSB)
`define MAWB_PC                 `MAWB_PC_MSB : `MAWB_PC_LSB

`define MAWB_RDS_LSB            (`MAWB_PC_MSB + 1)
`define MAWB_RDS_MSB            (`RDSADDR_WIDTH - 1 + `MAWB_RDS_LSB)
`define MAWB_RDS                `MAWB_RDS_MSB : `MAWB_RDS_LSB

`endif

