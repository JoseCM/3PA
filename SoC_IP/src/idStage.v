`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/08/2016 02:54:51 PM
// Design Name: 
// Module Name: idStage
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
`include "defines.v"

module idStage(
    input [`INST_WIDTH-1:0] iIR,
    input rf_we,
    input [4:0] WAddr,
    input [31:0] WData,

    output [`RDSADDR_WIDTH-1:0] woRdsAddr,
    output [`RS1ADDR_WIDTH-1:0] woRs1Addr,
    output [`RS2ADDR_WIDTH-1:0] woRs2Addr,
    output [`OP1_WIDTH-1:0] woOP1,
    output [`OP2_WIDTH-1:0] woOP2,
    output [`IM_WIDTH-1:0] woIMM,

    input clk,
    input reset,
    
    /*Forward signals*/
    input [31:0]fwdRS2,
    input fwdRS2_Sel,

    
    /*for testing without ctrl_unit*/
    //*
    input iR2Select,
    input [1:0] iSignExtCtrl    
    //*/
    );
    
    /*CTRL_Unit*/
    /*input opcode = instruction[31:27]*/
    /*input bit16 = instruction[16]*/
    /*input BranchConditionBits = instruction[26:23]*/
    /*output R2_Select*/
    /*output [1:0]SignExtCtrl*/
    /*output [x:0]CTRL*/
   
    wire [31:0]RfRs2;
    
    
    wire [4:0] Rs2 = iIR[`RS2];
    wire [4:0] Rst = iIR[`RST];
    assign woRs1Addr = iIR[`RS1];
    assign woRs2Addr = (iR2Select) ? Rst : Rs2; //mux
    assign woOP2 = (fwdRS2_Sel) ? fwdRS2 : RfRs2;
    assign woRdsAddr = iIR[`RDst];
        
    registerFile regF(
        .iRAddr1(woRs1Addr),
        .iRAddr2(woRs2Addr),
        .oData1(woOP1),
        .oData2(RfRs2),
        .iWAddr(WAddr),
        .iWData(WData),
        .we(rf_we),
        .clk(clk),
        .reset(reset)
    );
    
    signExtend sext(
        .msb(iSignExtCtrl),
        .imm_i(iIR[`IMM]),
        .imm_o(woIMM)
    );
    
endmodule
