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
    
    wire P_Stall;
    
    wire [2:0] AccessType; 
    assign AccessType = (Address >= 32'h44A00000 && Address <= 32'h44A10000 && En) ? 3'b001 : 
                        (Address >= 32'h0 && Address <= 32'hFFFF && En)            ? 3'b010 :
                                                                                     3'b000;
    assign Stall = AccessType == 3'b001 ? P_Stall : 
                   AccessType == 3'b010 ? C_Stall : 0 ; 
                   
    assign OData = AccessType  == 3'b001 ? P_ReadData :
                   AccessType  == 3'b010 ? C_ReadData : 0;
                                                                                                   
    assign P_AXIAddr = Address; //Always use processor address
    assign P_WriteData = IData; //Always use processor input data for periph AXI

    
    PeriphController PController(
    .Clk(Clk),
    .PeripheralAccess(AccessType[0]),
    .RW(RW),
    .En(En),
    .Stall(P_Stall),
    .StartAXIRead(P_StartAXIRead),
    .StartAXIWrite(P_StartAXIWrite),
    .WriteCompleted(P_WriteCompleted),
    .ReadCompleted(P_ReadCompleted)
    );
    
    
    //For Cache Forward Signals 
    assign C_En = AccessType[1];
    assign C_RW = RW;
    assign C_WriteData = IData;
    assign C_Address = Address;
    
endmodule
