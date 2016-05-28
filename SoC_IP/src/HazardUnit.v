`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/19/2016 11:27:12 AM
// Design Name: 
// Module Name: HazardUnit
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


module HazardUnit(
    input clk,
    input rst,
    //FORWARD UNIT
    input IDex__RW_MEM,         //MA control signals from Execute
    input IDex__MemEnable,      //used to detect stores 
    input IDex__Need_Rs2,
    input IDex__Need_Rs1,
    input IFid__Need_Rs2,
    input [4:0] IDex__Rs1,
    input [4:0] IDex__Rs2,
    input [4:0] IFid__Rs2,
    input EXmem__RW_MEM,
    input EXmem__MemEnable,
    input EXmem__R_WE,
    input [4:0] EXmem__Rdst,
    input [1:0] EXmem__RDst_S,
    input EXMA__Need_Rs2,
    input [4:0] EXMA__Rs2, //--modifying
    input [1:0] MEMwb__RDst_S,
    input [4:0] MEMwb__Rdst,
    input MEMwb__R_WE,
    input [4:0] VWB__Rdst,  //virtual
    input VWB__R_WE,        //virtual
    output [1:0] OP1_ExS,
    output [1:0] OP2_ExS,
    output OP2_IdS,
    output OP_MemS,
    
    
    //BRANCH UNIT
    input   PcMatchValid,
    input   BranchInstr,
    input   JumpInstr,
    input   PredicEqRes,
    input   [1:0] CtrlIn,
    output  [1:0] CtrlOut,
    output  FlushPipePC,
    output  WriteEnable,
    output  [1:0] NPC,
    
    //CHECK CC
    input [3:0]cc4,			// The condition code bits
    input [3:0]cond_bits,
    
    //STALL UNIT
    input i_DCache_Miss, // From Data Cache in MEM stage
    input i_ICache_Miss, // From Instruction Cache in IF stage
    output o_PC_Stall,   // To IF stage
    output o_IFID_Stall, // To IFID pipeline register
    output o_IDEX_Stall, // To IDEX pipeline register
    output o_EXMA_Stall, // To EXMA pipeline register
    output o_EXMA_Flush, // To flush EXMA pipleine Register 
    output o_MAWB_Flush, // To flush MAWB pipeline register
    output o_MAWB_Stall, // To MAWB pipeline register
    
    //Pipeline Registers 
    output Flush_IF_ID,
    output Flush_ID_EX
    );
    
    FU ForwardUnit(
        .clk(clk),
        .rst(rst),
        ///////////////////////////IF_ID
        .IDex__RW_MEM(IDex__RW_MEM),         //MA control signals from Execute
        .IDex__MemEnable(IDex__MemEnable),
        .IFid__Need_Rs2(IFid__Need_Rs2),
        .IFid__Rs2(IFid__Rs2),
        //////////////////////ID_EX REG
        .IDex__Need_Rs2(IDex__Need_Rs2),
        .IDex__Need_Rs1(IDex__Need_Rs1),
        .IDex__Rs1(IDex__Rs1),
        .IDex__Rs2(IDex__Rs2),
        //////////////////////EX_MEM REG
        .EXmem__RW_MEM(EXmem__RW_MEM),  //changed here
        .EXmem__MemEnable(EXmem__MemEnable),//changed here
        //deleted here
        .EXmem__R_WE(EXmem__R_WE),
        .EXmem__Rdst(EXmem__Rdst),
        .EXmem__RDst_S(EXmem__RDst_S),
        .EXMA__Need_Rs2(EXMA__Need_Rs2),
        .EXMA__Rs2(EXMA__Rs2),
        //////////////////////MEM_WB REG
        .MEMwb__RDst_S(MEMwb__RDst_S),
        .MEMwb__Rdst(MEMwb__Rdst),
        .MEMwb__R_WE(MEMwb__R_WE),
        ///////////////////////////virtualWB
        .VWB__Rdst(VWB__Rdst),
        .VWB__R_WE(VWB__R_WE), 
        //////////////////////OUTPUT
        .OP1_ExS(OP1_ExS),
        .OP2_ExS(OP2_ExS),
        .OP2_IdS(OP2_IdS),
        .Need_Stall(Need_Stall),
        .OP_MemS(OP_MemS)
        );
    

    branch_unit BranchUnit(
        .PcMatchValid(PcMatchValid),
        .JumpTaken(branch_taken),
        .BranchInstr(BranchInstr),
        .JumpInstr(JumpInstr),
        .PredicEqRes(PredicEqRes),
        .CtrlIn(CtrlIn),
        .CtrlOut(CtrlOut),
        .FlushPipePC(FlushPipePC),
        .WriteEnable(WriteEnable),
        .NPC(NPC)
        );
        
     checkcc ChechCC(
        .cc4(cc4),            // The condition code bits
        .cond_bits(cond_bits),
        .branch_taken(branch_taken)
     );
     
     Stall_Unit StallUnit(
         /* Inputs */
         .i_Need_Stall(Need_Stall),  // From Forward Unit
         
         .i_DCache_Miss(i_DCache_Miss), // From Data Cache in MEM stage
         .i_ICache_Miss(i_ICache_Miss), // From Instruction Cache in IF stage
         
         /* Outputs */
          //Stall Signals
         .o_PC_Stall(o_PC_Stall),   // To IF stage
         .o_IFID_Stall(o_IFID_Stall), // To IFID pipeline register
         .o_IDEX_Stall(o_IDEX_Stall), // To IDEX pipeline register
         .o_EXMA_Stall(o_EXMA_Stall), // To EXMA pipeline register
         .o_MAWB_Stall(o_MAWB_Stall), // To MAWB pipeline register
         
          //Flush Signals
         .o_IFID_Flush(o_IFID_Flush), // To flush IFID pipeline register
         .o_IDEX_Flush(o_IDEX_Flush),
         .o_EXMA_Flush(o_EXMA_Flush), // To flush EXMA pipleine Register 
         .o_MAWB_Flush(o_MAWB_Flush) // To flush MAWB pipeline register
         );
         
     assign Flush_IF_ID =  FlushPipePC | o_IFID_Flush;
     assign Flush_ID_EX = FlushPipePC /*| o_IDEX_Flush*/;
    
endmodule
