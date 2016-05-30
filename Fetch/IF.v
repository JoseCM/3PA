`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/08/2016 11:05:25 AM
// Design Name: 
// Module Name: Stage1
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

module IF(
    //General
    input Clk,
    input Rst,
    //Branch Unit
    input FlushPipeandPC,
    input WriteEnable,
    input [1:0] CB_o,
    //Stall Unit
    input PCStall,    
    input IF_ID_Stall,
    input IF_ID_Flush,
    output Imiss,
    //From Execute 
    input [31:0] CHJmpAddr,
    input [31:0] JmpAddr,
    input [31:0] JmpInstrAddr,
    //To Pipeline Registers
    output [31:0] IR,
    output [31:0] PC,
    output [31:0] InstrAddr,
    output PCSource,
    output [33:0] PPCCB,
    
    output [65:0] Dcache_bus_out,
    input [32:0] Dcache_bus_in,
    //Changes
    output [31:0] Icache_bus_out,
    
    input [32:0] Icache_bus_in,
    
    /**********VIC*************/
    input i_VIC_ctrl,
    input [31:0] i_VIC_iaddr,
    output o_IFID_NOT_FLUSH
);

    wire [31:0] IR_w, PC_w, InstrAddr_w, Predict_w;
    wire PCSource_w;
    wire [1:0] CB_w;

    fetchLogic fetchlogic(
        .Clk(Clk),               
        .Rst(Rst),               
        .FlushPipeandPC(FlushPipeandPC),
        .PCStall(PCStall),   
        .IF_ID_Flush(IF_ID_Flush),              
        .IF_ID_Stall(IF_ID_Stall),      
        .WriteEnable(WriteEnable),   
        .CB_o(CB_o),          
        .Imiss(Imiss),
        .CHJmpAddr(CHJmpAddr),         
        .JmpAddr(JmpAddr),       
        .JmpInstrAddr(JmpInstrAddr),        
        .IR(IR_w),            
        .PC(PC_w),            
        .InstrAddr(InstrAddr_w),         
        .PCSource(PCSource_w),      
        .Predict(Predict_w),       
        .CB(CB_w),
        .PC_Match(PCMatch_w),
                   
        .Icache_bus_out(Icache_bus_out),
        .Icache_bus_in(Icache_bus_in), 
        
         /**********VIC*************/
        .i_VIC_ctrl(i_VIC_ctrl),
        .i_VIC_iaddr(i_VIC_iaddr)      
    );

    wire [`IFID_WIDTH-1:0]in;
    assign in = (Rst)          ?      0:
                                      {InstrAddr_w,Predict_w,CB_w,PC_w,PCMatch_w,IR_w,1'b1};    //less significant bit for flush (VIC stuff)

    wire [`IFID_WIDTH-1:0]out;
    assign IR = (Rst)          ?      0:
                                      out[`IFID_INST];
    
    assign PC = (Rst)          ?      0:
                                      out[`IFID_PC];
                                      
    assign InstrAddr = (Rst)   ?      0:
                                      out[`IFID_IC];
                                      
    assign PPCCB = (Rst)       ?      0:                 
                                      out[`IFID_PPCCB];
                                      
    assign PCSource = (Rst)    ?      0:   
                                      out[`IFID_VALID];
                                      
    assign o_IFID_NOT_FLUSH = (Rst)  ?  0: 
                                      out[`IFID_NOT_FLUSH];
    
   
    pipereg #(`IFID_WIDTH) IFIDreg(
        .clk(Clk),                
        .rst(Rst),                
        .flush(IF_ID_Flush),              
        .stall(IF_ID_Stall),              
        .in(in),     
        .out(out)  
    );
   
endmodule
