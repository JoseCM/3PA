`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/08/2016 03:42:47 PM
// Design Name: 
// Module Name: PCUpdate
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

module PCUpdate(
    input Clk,
    input Rst,
    output [31:0] PC,
    output reg [31:0] InstrAddr, //changed here
    input FlushPipeandPC,
    input PCStall,
    input [31:0] Predict,
    input PCSource,
    input [31:0] JmpAddr
    );
    
    //reg  [31:0]    InstrAddr;     //changed here
    wire [31:0]    new_InstrAddr;

    //wire     [31:0] 	PC;		//change here									// Program Counter    
    
    
    
    always@ (posedge Clk)
    begin
        InstrAddr <= new_InstrAddr; 
    end
    
    assign PC = (Rst)                       ?  0 :
                                               InstrAddr+4'b0100;     
    
    assign new_InstrAddr = (Rst)            ?  32'b0:
                           (FlushPipeandPC) ?  JmpAddr:
                           (PCStall)        ?  InstrAddr:                            (PCSource)  ?  Predict:
                                               PC;
                           
endmodule
