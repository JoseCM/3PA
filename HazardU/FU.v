`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.04.2016 17:40:30
// Design Name: 
// Module Name: FU
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

`define MemtoReg 2'b00

module FU(
    input clk,
    input rst,
    ///////////////////////////IF_ID
    input IFid__Need_Rs2,
    input [4:0] IFid__Rs2,
    ////////////////////////////ID_EX REG
    input IDex__Need_Rs2,
    input IDex__Need_Rs1,
    input [4:0] IDex__Rs1,
    input [4:0] IDex__Rs2,
    ////////////////////////////EX_MEM REG
    input EXmem__RW_MEM,
    input EXmem__MemEnable,
    input EXmem__R_WE,
    input [4:0] EXmem__Rdst,
    input [1:0] EXmem__RDst_S,
    ////////////////////////////MEM_WB REG
    input [4:0] MEMwb__Rdst,
    input MEMwb__R_WE,
    ////////////////////////////OUTPUT
    output [1:0] OP1_ExS,
    output [1:0] OP2_ExS,
    output OP2_IdS,
    output Need_Stall
    );
    
    reg BubbleMA;
    
    assign OP1_ExS = ( (EXmem__R_WE) && (EXmem__RDst_S!=`MemtoReg) && (IDex__Need_Rs1) && (EXmem__Rdst==IDex__Rs1) )     ?   2'b10:
                     ( (MEMwb__R_WE) && (IDex__Need_Rs1)  && (MEMwb__Rdst==IDex__Rs1) )                                  ?   2'b01:  
                                                                                                                             2'b00;                                                                                
                                                                                                                                                                                                                                          
    assign OP2_ExS = ( (EXmem__R_WE) && (EXmem__RDst_S!=`MemtoReg) && (IDex__Need_Rs2) && (EXmem__Rdst==IDex__Rs2) )     ?   2'b10:
                     ( (MEMwb__R_WE) && (IDex__Need_Rs2)  && (MEMwb__Rdst==IDex__Rs2) )                                  ?   2'b01: 
                                                                                                                             2'b00;
                                                                                                                             
    assign OP2_IdS = (MEMwb__R_WE && IFid__Need_Rs2 && (MEMwb__Rdst==IFid__Rs2))  ? 1'b1 : //forward RS2 from write back to decde
                                                                                    1'b0;
                                                                                                                            
    assign Need_Stall = ( (!EXmem__RW_MEM && EXmem__MemEnable) && ( ((IDex__Need_Rs1) && (EXmem__Rdst==IDex__Rs1)) || ((IDex__Need_Rs2) && (EXmem__Rdst==IDex__Rs2)) ))     ?   1'b1:
                                                                                                                                                             1'b0;
    always @(posedge clk)
    begin
        if(rst) begin
            BubbleMA <= 0;
        end else begin
            BubbleMA <= Need_Stall; 
        end          
    end       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
endmodule

