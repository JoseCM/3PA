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
    output [31:0] InstrAddr, //changed here
    input FlushPipeandPC,
    input PCStall,
    input [31:0] Predict,
    input PCSource,
    input [31:0] JmpAddr,
    
    input IF_ID_Flush,
    input IF_ID_Stall,
    output  [31:0]IR,
    output Imiss,
   
   /**************************/
    output [31:0] Icache_bus_out,
    input [32:0] Icache_bus_in,

    /**********VIC*************/
    input i_VIC_ctrl,
    input [31:0] i_VIC_iaddr
    
    );                                              
     
       reg [31:0] new_InstrAddr;
       wire [31:0] new_IR;
       
   
       assign Icache_bus_out =  new_InstrAddr;
       assign Imiss = Icache_bus_in[32];
       assign new_IR = Rst ? 32'b0 : Icache_bus_in[31:0];
       
       always @(posedge Clk)
       begin
       
           if(Rst)
           begin
                   new_InstrAddr <= 0;
           end
           else
           begin
                 new_InstrAddr <=  (i_VIC_ctrl)                             ?  i_VIC_iaddr:
                                                       (FlushPipeandPC)               ?  JmpAddr:
                                                       (PCStall || IF_ID_Stall)       ?  InstrAddr:                           
                                                       (PCSource)                     ?  Predict:
                                                                    PC ;
           end                         
           
       end
       
       assign InstrAddr = Rst ? 32'b0 : new_InstrAddr;
       assign IR = Rst? 32'b0 : new_IR;
       assign PC = Rst? 32'b0 : 
                   (i_VIC_ctrl ||(!IF_ID_Stall && (FlushPipeandPC || !IF_ID_Flush))) ? new_InstrAddr + 4'b0100 :
                   PC;
                                           
       
endmodule