`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.05.2016 09:48:37
// Design Name: 
// Module Name: MemController
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

`define AccType_None   2'd0
`define AccType_Periph 2'd1
`define AccType_Mem    2'd2
`define AccType_NTypes 2'd3

module MemController(
        input Clk,
        input Rst,
        //CPU Input
        input RW,
        input En,
        input [31:0] Address,
        input [31:0] IData,
        //CPU Output
        output Stall,
        output [31:0] OData,
        
        //For Periph Master AXI
        output [31:0] P_AXIAddr,
        output P_StartAXIRead,
        output P_StartAXIWrite,    
        output [31:0] P_WriteData,
        input  [31:0] P_ReadData,
        input  P_WriteCompleted,
        input  P_ReadCompleted,

        
        //For Cache
        output C_En,
        output C_RW,
        output [31:0] C_WriteData,
        output [31:0] C_Address,
        input  [31:0] C_ReadData,
        input  C_Stall
    );
    
        wire [`AccType_NTypes-1:0] AccessType; 
        wire Periph_AccessCondition =  En && Address >= 32'h10000 && Address <= 32'h20000;
        wire Mem_AccessCondition =    En && ~Periph_AccessCondition;
        
        assign AccessType = Periph_AccessCondition ? `AccType_Periph : 
                            Mem_AccessCondition ? `AccType_Mem :
                                                     `AccType_None;
                                                       
        assign Stall = AccessType == `AccType_Periph ? P_Stall : 
                       AccessType == `AccType_Mem ? C_Stall : 0 ; //Stall não vai impedir o funcioamento?
                       
        assign OData = AccessType  == `AccType_Periph ? P_ReadData :
                       AccessType  == `AccType_Mem ? C_ReadData : 0;
                                                                                                       
        assign P_AXIAddr = Address;
        assign P_WriteData = IData; //Always use processor input data for periph AXI    
        
        //For Cache Signals 
        assign C_En = (AccessType == `AccType_Mem);
        assign C_RW = RW;
        assign C_WriteData = IData;
        assign C_Address = Address;
    
    PeriphController PController(
    .Clk(Clk),
    .PeripheralAccess(AccessType == `AccType_Periph),
    .RW(RW),
    .En(En),
    .Stall(P_Stall),
    .StartAXIRead(P_StartAXIRead),
    .StartAXIWrite(P_StartAXIWrite),
    .WriteCompleted(P_WriteCompleted),
    .ReadCompleted(P_ReadCompleted)
    );

    
endmodule
