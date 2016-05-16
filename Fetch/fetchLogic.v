`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/12/2016 01:48:11 PM
// Design Name: 
// Module Name: fetchLogic
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


module fetchLogic(
    //========================= General
    input Clk,
    input Rst,
    //========================= Hazard UNit
    input FlushPipeandPC,
    input PCStall,
    input IF_ID_Flush,
    input IF_ID_Stall,
    input WriteEnable,
    input [1:0] CB_o,
    output Imiss,
    //========================= From Execute 
    input [31:0] JmpAddr,
    input [31:0] CHJmpAddr,
    input [31:0] JmpInstrAddr,
    //========================= To Pipeline Registers
    output [31:0] IR,
    output [31:0] PC,
    output [31:0] InstrAddr,
    output PCSource,
    output [31:0] Predict,
    output [1:0] CB,
    output PC_Match,
    //=========================
    output [31:0] Icache_bus_out,
    input [32:0] Icache_bus_in,
    output [65:0] Dcache_bus_out,
    input [32:0] Dcache_bus_in
    );
    
   PCUpdate pcupdate(
       .Clk(Clk),
       .Rst(Rst),
       .PC(PC),
       .InstrAddr(InstrAddr),
       .FlushPipeandPC(FlushPipeandPC),
       .PCStall(PCStall),
       .Predict(Predict),
       .PCSource(PCSource),
       .JmpAddr(JmpAddr),
       
       .IF_ID_Flush(IF_ID_Flush),
       .IF_ID_Stall(IF_ID_Stall),
       .IR(IR),
       .Imiss(Imiss),
       
       .Icache_bus_out(Icache_bus_out),
       .Icache_bus_in(Icache_bus_in)
    );
    
    wire [33:0] PPC_CB;
    
    PredictCache predictcache(
        .Rst(Rst),
        .Clk(Clk),
        .RAddr(InstrAddr),  
        .WAddr(JmpInstrAddr), 
        .WE(WriteEnable),
        .Instr_new_CB(CB_o),
        .PPC_CB(PPC_CB),
        .Data(CHJmpAddr),
        .PC_Source(PCSource),
        .PCMatch(PC_Match)
    );
    
   assign CB=PPC_CB[1:0];
   assign Predict=PPC_CB[33:2];

endmodule
