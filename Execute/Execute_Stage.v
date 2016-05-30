`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/12/2016 01:19:38 AM
// Design Name: 
// Module Name: Execute_Stage
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

`include "pipelinedefs.v"

`define WIDTH 32

module EX_Stage(
        /*Input clock and reset*/
        input clk,
        input reset,
        
        /*Fowarding data from WB and MEM Stage*/
        input [`WIDTH-1:0] i_Data_From_WB,         
        input [`WIDTH-1:0] i_Data_From_MEM,
        input [`WIDTH-1:0] i_Data_From_vWB,   
        
        /*Foward Unit Control Signals*/
        input [1:0] i_Fwrd_Ctrl1,      //OP1_ExS
        input [1:0] i_Fwrd_Ctrl2,     //OP2_ExS
        
        /*Stall Unit  Control Signals*/
        input i_EXMA_flush,
        input i_EXMA_stall,
        
        /*Branch Unit Control Signal*/
        input i_NPC_Ctrl,
        
        /*Input data from IDEX register*/
        input [`WB_WIDTH-1:0] i_WB_Ctrl,
        input [`MA_WIDTH-1:0] i_MEM_Ctrl,
        input [`EX_WIDTH-1:0] i_EX_Ctrl,
        input i_PC_Match,  //----the same as the below one???
        input i_Valid_Bit,
        input [`OP1_WIDTH-1:0] i_Rs1,                      // OP1
        input [`OP2_WIDTH-1:0] i_Rs2,                     //OP2
        input [`IM_WIDTH-1:0] i_Immediate,     //  
        input [`RS1ADDR_WIDTH-1:0] i_Rs1_addr,
        input [`RS2ADDR_WIDTH-1:0] i_Rs2_addr,
        input [`RDSADDR_WIDTH-1:0] i_Rds_addr,
        input [`PC_WIDTH-1:0] i_PC, 
        input [`PPCCB_WIDTH-1:0] i_PPCCB,
        input [`IC_WIDTH-1:0] i_IC,
              
        /****************VIC*****************/
        input i_VIC_CCodes_ctrl,
        input [3:0] i_VIC_CCodes,
        output [`WIDTH-1:0] o_PC_VIC,
        
        /*External Outputs data and signals(No Connection to the Pipeline Register)*/
        output [1:0] o_CB,
        output o_Valid_Bit,
        output o_Jmp_Ctrl,
        output o_Branch_Ctrl,
        output [3:0]o_CondBits,
        output [3:0]o_CCodes,
        output o_PPC_Eq,
        output [`WIDTH-1:0]o_IC,
        output [`WIDTH-1:0] o_New_PC,
        output [`RS1ADDR_WIDTH-1:0] o_Rs1_addr,
        output [`RS2ADDR_WIDTH-1:0] o_Rs2_addr,
        output [`RDSADDR_WIDTH-1:0] o_Rds_addr,
        output o_need_Rs1,
        output o_need_Rs2,

        
        /*EXMA register output data*/
        output [`WIDTH-1:0] o_CH_Jump_Addr,
        output [`WB_WIDTH-1:0] o_EXMA_WB,
        output [`MA_WIDTH-1:0] o_EXMA_MEM,
        output [`WIDTH-1:0] o_EXMA_ALU_rslt,
        output [`WIDTH-1:0] o_EXMA_Rs2_val,
        output [`RS2ADDR_WIDTH-1:0] o_EXMA_Rs2_addr,
        output [`WIDTH-1:0] o_EXMA_PC,
        output [`RDSADDR_WIDTH-1:0] o_EXMA_Rds_addr
    );

            
wire [1:0] i_ALU_src1_Ctrl ;
wire i_ALU_src2_Ctrl;
wire [3:0] i_ALU_Ctrl;
wire i_CC_WE;
wire[`WIDTH-1:0] i_PPC = i_PPCCB[`PPCCB_WIDTH-1:2];
                            
wire [`WIDTH-1:0] w_ALU_Op1; //*Connecting OpSel and alu modules
wire [`WIDTH-1:0] w_ALU_Op2; //*with the alu operands     
wire [`WIDTH-1:0] o_ALU_rslt;
wire [`WIDTH-1:0] o_Store_Data;

wire [`EXMA_WIDTH-1:0] i_EXMA_indata;      
wire [`EXMA_WIDTH-1:0] o_EXMA_outdata;     
          
assign o_Valid_Bit = i_Valid_Bit;
assign o_CB = i_PPCCB[1:0];
assign o_Rds_addr = i_Rds_addr;
assign o_Rs1_addr = i_Rs1_addr;
assign o_Rs2_addr = i_Rs2_addr;
assign o_IC = i_IC;

/*Parse EX Control Signals*/
assign o_need_Rs1 = i_EX_Ctrl[`EX_NEED_RS1];
assign o_need_Rs2 = i_EX_Ctrl[`EX_NEED_RS2];
assign o_Jmp_Ctrl =  i_EX_Ctrl[`EX_JMP];
assign o_Branch_Ctrl =  i_EX_Ctrl[`EX_BXX];
assign o_CondBits = i_EX_Ctrl[`EX_CondBits];
assign i_ALU_src1_Ctrl =  i_EX_Ctrl[`EX_ALU_SRC1];
assign i_ALU_src2_Ctrl =  i_EX_Ctrl[`EX_ALU_SRC2];
assign i_ALU_Ctrl = i_EX_Ctrl[`EX_ALUCTRL];
assign i_CC_WE = i_EX_Ctrl[`EX_CC_WE];


/*Concatenate data to EXMA register bus and desconcatenate*/

assign i_EXMA_indata[`EXMA_WB] = i_WB_Ctrl;
assign i_EXMA_indata[`EXMA_MA] = i_MEM_Ctrl;
assign i_EXMA_indata[`EXMA_ALURSLT] = o_ALU_rslt;
assign i_EXMA_indata[`EXMA_RS2VAL] = o_Store_Data;
assign i_EXMA_indata[`EXMA_RS2ADDR] = i_Rs2_addr;
assign i_EXMA_indata[`EXMA_PC] = i_PC;
assign i_EXMA_indata[`EXMA_RDS] = i_Rds_addr;

assign o_CH_Jump_Addr = o_ALU_rslt;
assign o_EXMA_WB = o_EXMA_outdata[`EXMA_WB];
assign o_EXMA_MEM = o_EXMA_outdata[`EXMA_MA];
assign o_EXMA_ALU_rslt = o_EXMA_outdata[`EXMA_ALURSLT];
assign o_EXMA_Rs2_val = o_EXMA_outdata[`EXMA_RS2VAL];
assign o_EXMA_Rs2_addr = o_EXMA_outdata[`EXMA_RS2ADDR];
assign o_EXMA_PC = o_EXMA_outdata[`EXMA_PC];
assign o_EXMA_Rds_addr = o_EXMA_outdata[`EXMA_RDS];


Alu_Op_Selection OpSelection(
                .i_Rs1(i_Rs1),
                .i_Rs2(i_Rs2),
                .i_Data_From_WB(i_Data_From_WB),
                .i_Data_From_MEM(i_Data_From_MEM),
                .i_Data_From_vWB(i_Data_From_vWB),
                .i_Immediate(i_Immediate),
                .i_PC(i_PC),
                .i_Fwrd_Ctrl1(i_Fwrd_Ctrl1),
                .i_Fwrd_Ctrl2(i_Fwrd_Ctrl2),
                .i_ALU_src1_Ctrl(i_ALU_src1_Ctrl),
                .i_ALU_src2_Ctrl(i_ALU_src2_Ctrl),
                .o_Op1(w_ALU_Op1),
                .o_Op2(w_ALU_Op2),
                .o_Store_Data(o_Store_Data)
    );

ALU alu(
                 .clk(clk),
                 .i_Op1(w_ALU_Op1),
                 .i_Op2(w_ALU_Op2),
                 .i_CC_WE(i_CC_WE),
                 .i_ALU_Ctrl(i_ALU_Ctrl),
                 .reset(reset),
                 .i_VIC_CCodes_ctrl(i_VIC_CCodes_ctrl),
                 .i_VIC_CCodes(i_VIC_CCodes),
                 .ro_ALU_rslt(o_ALU_rslt),
                 .ro_CCodes(o_CCodes)
        );

PC_Eval new_pc(
                 .i_PC(i_PC),
                 .i_ALU_rslt(o_ALU_rslt),
                 .i_PPC(i_PPC),
                 .i_NPC_Ctrl(i_NPC_Ctrl),
                 .o_New_PC(o_New_PC),
                 .o_PPC_Eq(o_PPC_Eq),
                 .o_PC_VIC(o_PC_VIC)
        );
        
        

pipereg #(`EXMA_WIDTH) EX_MA(
                .clk(clk),
                .rst(reset),
                .flush(i_EXMA_flush),
                .stall(i_EXMA_stall),
                .in(i_EXMA_indata),
                .out(o_EXMA_outdata)
                );
                
                
endmodule

