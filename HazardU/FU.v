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
    input IDex__RW_MEM,         //MA control signals from Execute
    input IDex__MemEnable,      //used to detect stores 
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
    input EXMA__Need_Rs2,
    input [4:0] EXMA__Rs2,
    ////////////////////////////MEM_WB REG
    input [1:0] MEMwb__RDst_S,
    input [4:0] MEMwb__Rdst,
    input MEMwb__R_WE,
    ///////////////////////////virtualWB
    input [4:0] VWB__Rdst,
    input VWB__R_WE, 
    ////////////////////////////OUTPUT
    output [1:0] OP1_ExS,
    output [1:0] OP2_ExS,
    output OP2_IdS,
    output Need_Stall,
    output OP_MemS
    );
    
    reg BubbleMA;
    
    assign OP1_ExS = ( (EXmem__R_WE) && (EXmem__RDst_S!=`MemtoReg) && (IDex__Need_Rs1) && (EXmem__Rdst==IDex__Rs1) )     ?   2'b10:
                     ( (MEMwb__R_WE) && (IDex__Need_Rs1)  && (MEMwb__Rdst==IDex__Rs1) )                                  ?   2'b01:       
                     ( (VWB__R_WE) &&   (IDex__Need_Rs1)  && (VWB__Rdst==IDex__Rs1) )                                    ?   2'b11:                  
                                                                                                                             2'b00;                                                                                
                                                                                                                                                                                                                                          
    assign OP2_ExS = ( (EXmem__R_WE) && (EXmem__RDst_S!=`MemtoReg) && (IDex__Need_Rs2) && (EXmem__Rdst==IDex__Rs2) )     ?   2'b10: 
                     ( (MEMwb__R_WE) && (IDex__Need_Rs2)  && (MEMwb__Rdst==IDex__Rs2) )                                  ?   2'b01:  
                     ( (VWB__R_WE)   && (IDex__Need_Rs2)  && (VWB__Rdst==IDex__Rs2))                                     ?   2'b11:                  
                                                                                                                             2'b00;
    
    assign OP_MemS = ( (MEMwb__RDst_S == `MemtoReg) && (EXmem__RW_MEM && EXmem__MemEnable) && EXMA__Need_Rs2 && (MEMwb__Rdst==EXMA__Rs2) && MEMwb__R_WE)  ? 1'b1 : //forward from write back to MA
                                                                                                                                                            1'b0;
                                                                                                                             
    assign OP2_IdS = 0;/*(MEMwb__R_WE && IFid__Need_Rs2 && (MEMwb__Rdst==IFid__Rs2))  ? 1'b1 : //forward RS2 from write back to decde
                                                                                    1'b0;*/
                                                                                                                            
    assign Need_Stall = ( !(IDex__RW_MEM && IDex__MemEnable && !IDex__Need_Rs1) && (!EXmem__RW_MEM && EXmem__MemEnable) && ( ((IDex__Need_Rs1) && (EXmem__Rdst==IDex__Rs1)) || ((IDex__Need_Rs2) && (EXmem__Rdst==IDex__Rs2)) ))     ?   1'b1:
                                                                                                                                                                                                                      1'b0;
                        //!(IDex__RW_MEM && IDex__MemEnable) was added to prevent a stall when there's a Load followed by a store  
    always @(posedge clk)
    begin
        if(rst) begin
            BubbleMA <= 0;
        end else begin
            BubbleMA <= Need_Stall; 
        end          
    end       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
endmodule

