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
    output reg [31:0] PC,
    output reg [31:0] InstrAddr, //changed here
    input FlushPipeandPC,
    input PCStall,
    input [31:0] Predict,
    input PCSource,
    input [31:0] JmpAddr,
    
    input IF_ID_Flush,
    input IF_ID_Stall,
    output reg [31:0]IR,
    output Imiss,
    
    /**************************/
    output [31:0] Icache_bus_out,
    input [32:0] Icache_bus_in,
    
    /**********VIC*************/
    input i_VIC_ctrl,
    input [31:0] i_VIC_iaddr
    
    );
    
    //reg  [31:0]    InstrAddr;     //changed here
    wire [31:0] new_InstrAddr;
    wire [31:0] newIR;
 
    
    assign new_InstrAddr = (Rst)                           ?  32'b0:
                           (i_VIC_ctrl)                    ?  i_VIC_iaddr:
                           (FlushPipeandPC)                ?  JmpAddr:
                           (PCStall || IF_ID_Stall)        ?  InstrAddr:                           
                           (PCSource)                      ?  Predict:
 
                                                           PC;

//    ROM inst_mem(
//     .Clk(Clk),                                                   
//     .Rst(Rst),                                                   
//     .En(1),                                                  
//     .Addr(new_InstrAddr),                                                    
//     .Data(newIR),
//     .Imiss(Imiss)                                                         
//    );

    assign Icache_bus_out =  new_InstrAddr;
    assign Imiss = Icache_bus_in[32];
    assign newIR = Icache_bus_in[31:0];
    
    always@ (posedge Clk)
    begin
    if(Rst)
    begin
            PC <= 32'b0;
            InstrAddr <= 32'b0;
            IR = 0;
    end
    else if (i_VIC_ctrl || (!IF_ID_Stall && (FlushPipeandPC || !IF_ID_Flush)))
    begin
            InstrAddr = new_InstrAddr; 
            PC =  InstrAddr +4'b0100;
            IR = newIR;
    end
    end  
    
                            
endmodule