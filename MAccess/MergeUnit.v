`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.05.2016 23:33:24
// Design Name: 
// Module Name: MergeUnit
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


module MergeUnit(
    input [2:0] Address_LSBs,
    input [31:0] WriteData,
    input [255:0] CacheLine,
    output [255:0] MergeOutput
    );
    
    assign MergeOutput =  Address_LSBs == 3'b000 ? {CacheLine[255:32],WriteData}                  :
                          Address_LSBs == 3'b001 ? {CacheLine[255:64],WriteData,CacheLine[31:0]}  :
                          Address_LSBs == 3'b010 ? {CacheLine[255:96],WriteData,CacheLine[63:0]}  :
                          Address_LSBs == 3'b011 ? {CacheLine[255:128],WriteData,CacheLine[95:0]} :
                          Address_LSBs == 3'b100 ? {CacheLine[255:160],WriteData,CacheLine[127:0]}:
                          Address_LSBs == 3'b101 ? {CacheLine[255:192],WriteData,CacheLine[159:0]}:
                          Address_LSBs == 3'b110 ? {CacheLine[255:224],WriteData,CacheLine[191:0]}:
                          Address_LSBs == 3'b111 ? {WriteData,CacheLine[223:0]}                   : 0;
                  
endmodule
