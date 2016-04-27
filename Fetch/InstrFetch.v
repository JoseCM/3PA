`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/08/2016 03:05:30 PM
// Design Name: 
// Module Name: InstrFetch
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


module InstrFetch(
    input Clk,
    input Rst,
    input [31:0] InstrAddr,
    input IF_ID_Flush,
    input IF_ID_Stall,
    output [31:0] IR,
    output Imiss
    );
    
    //wire [31:0] IR_temp;
    
     ROM inst_mem(
      .Clk(Clk),                                                   
      .Rst(Rst),                                                    
      .En(~(IF_ID_Flush | IF_ID_Stall)),                                                  
      .Addr(InstrAddr),                                                    
      .Data(IR),
      .Imiss(Imiss)                                                         
    );
    
      
    
endmodule
