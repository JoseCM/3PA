`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/13/2016 02:04:54 PM
// Design Name: 
// Module Name: ControlUnit
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

`include "defines.vh"
`include "pipelinedefs.vh"

module ControlUnit(
        input [4:0] opcode,
        input bit16,
        input [3:0] CondBits,
        //output [2:0] DEStage,
        output reg [1:0] SignExt,
        output reg RS2_Sel,
        output reg [`EX_WIDTH-1:0] EXStage,
        output reg [1:0] MAStage,
        output reg [2:0] WBStage,
        output reg IFid__Need_Rs2,
        output reg RETI_Inst
    );
    
always @(opcode or bit16 or CondBits) 
begin
    case(opcode) 
        `NOP :
        begin
            SignExt <= 2'bx;
            RS2_Sel <= 1'bx;
            IFid__Need_Rs2 <= 0;
            RETI_Inst <= 1'b0;//RETI
            
            /* Ex */
            EXStage[`EX_CondBits] <= 4'b0;
            EXStage[`EX_ALUCTRL] <= 4'b0000;
            EXStage[`EX_ALU_SRC1] <= 2'b0;
            EXStage[`EX_ALU_SRC2] <= 1'b0;
            EXStage[`EX_CC_WE] <= 0;
            EXStage[`EX_JMP] <= 0;
            EXStage[`EX_BXX ] <= 0;
            EXStage[`EX_NEED_RS1] <= 1'b0;
            EXStage[`EX_NEED_RS2] <=  1'b0;
            
            /* MA */
            MAStage[`MA_RW] <= 0;
            MAStage[`MA_EN] <= 0;                  
            
            /* WB */ 
            WBStage[`WB_R_WE] <= 0;
            WBStage[`WB_RDST_MUX] <= 2'b0;           
        end
        `ADD : 
        begin
            SignExt <= bit16 ? 0 : 2'b0;
            RS2_Sel <= 1'b0;
            IFid__Need_Rs2 <= !bit16;
            RETI_Inst <= 1'b0;//RETI

            /* Ex */
            EXStage[`EX_CondBits] <= 4'b0;
            EXStage[`EX_ALUCTRL] <= 4'b0001;
            EXStage[`EX_ALU_SRC1] <= 2'b00;
            EXStage[`EX_ALU_SRC2] <= bit16;
            EXStage[`EX_CC_WE] <= 1;
            EXStage[`EX_JMP] <= 0;
            EXStage[`EX_BXX ] <= 0;
            EXStage[`EX_NEED_RS1] <= 1;
            EXStage[`EX_NEED_RS2] <= !bit16;
            
            /* MA */
            MAStage[`MA_RW] <= 0;
            MAStage[`MA_EN] <= 0;               
               
            /* WB */ 
            WBStage[`WB_R_WE] <= 1;
            WBStage[`WB_RDST_MUX] <= 2'b01;           
        end
                
        `SUB :
        begin
            SignExt <= bit16 ? 0 : 2'b0;
            RS2_Sel <= 1'b0;
            IFid__Need_Rs2 <= !bit16;
            RETI_Inst <= 1'b0;//RETI
            
            /* Ex */
            EXStage[`EX_CondBits] <= 4'b0;
            EXStage[`EX_ALUCTRL] <= 4'b0010;
            EXStage[`EX_ALU_SRC1] <= 2'b00;
            EXStage[`EX_ALU_SRC2] <= bit16;
            EXStage[`EX_CC_WE] <= 1;
            EXStage[`EX_JMP] <= 0;
            EXStage[`EX_BXX ] <= 0;
            EXStage[`EX_NEED_RS1] <= 1;
            EXStage[`EX_NEED_RS2] <= !bit16;
            
            /* MA */
            MAStage[`MA_RW] <= 0; 
            MAStage[`MA_EN] <= 0;               
              
            /* WB */ 
            WBStage[`WB_R_WE] <= 1;
            WBStage[`WB_RDST_MUX] <= 2'b01;           
        end
        `OR  :
        begin
            SignExt <= bit16 ? 0 : 2'b0;
            RS2_Sel <= 1'b0;
            IFid__Need_Rs2 <= !bit16;
            RETI_Inst <= 1'b0;//RETI

            /*Ex*/
            EXStage[`EX_CondBits] <= 4'b0;
            EXStage[`EX_ALUCTRL] <= 4'b0011;
            EXStage[`EX_ALU_SRC1] <= 2'b00;
            EXStage[`EX_ALU_SRC2] <= bit16;
            EXStage[`EX_CC_WE] <= 0;
            EXStage[`EX_JMP] <= 0;
            EXStage[`EX_BXX] <= 0;
            EXStage[`EX_NEED_RS1] <= 1;
            EXStage[`EX_NEED_RS2] <= !bit16;
            
            /* MA */
            MAStage[`MA_RW] <= 0;
            MAStage[`MA_EN] <= 0;               
            
            /* WB */
            WBStage[`WB_R_WE] <= 1;
            WBStage[`WB_RDST_MUX] <= 2'b01;           
        end  
        `AND : 
        begin
            SignExt <= bit16 ? 0 : 2'b0;
            RS2_Sel <= 1'b0;
            IFid__Need_Rs2 <= !bit16;
            RETI_Inst <= 1'b0;//RETI
            
            /*Ex*/
            EXStage[`EX_CondBits] <= 4'b0;
            EXStage[`EX_ALUCTRL] <= 4'b0100;
            EXStage[`EX_ALU_SRC1] <= 2'b00;
            EXStage[`EX_ALU_SRC2] <= bit16;
            EXStage[`EX_CC_WE] <= 0;
            EXStage[`EX_JMP] <= 0;
            EXStage[`EX_BXX ] <= 0;
            EXStage[`EX_NEED_RS1] <= 1;
            EXStage[`EX_NEED_RS2] <= !bit16;
            
            /* MA */
            MAStage[`MA_RW] <= 0;
            MAStage[`MA_EN] <= 0;               
            
            /* WB */ 
            WBStage[`WB_R_WE] <= 1;
            WBStage[`WB_RDST_MUX] <= 2'b01; 
        end
        `NOT :
        begin
            SignExt <= 2'b0;
            RS2_Sel <= 1'b0;
            IFid__Need_Rs2 <= 0;
            RETI_Inst <= 1'b0;//RETI
           
            /* Ex */
            EXStage[`EX_CondBits] <= 4'b0;
            EXStage[`EX_ALUCTRL] <= 4'b0101;
            EXStage[`EX_ALU_SRC1] <= 2'b00;
            EXStage[`EX_ALU_SRC2] <= 1'b0;
            EXStage[`EX_CC_WE] <= 0;
            EXStage[`EX_JMP] <= 0;
            EXStage[`EX_BXX ] <= 0;
            EXStage[`EX_NEED_RS1] <= 1;
            EXStage[`EX_NEED_RS2] <= 0;
            
            /* MA */
            MAStage[`MA_RW] <= 0; 
            MAStage[`MA_EN] <= 0;               
            
            /* WB */ 
            WBStage[`WB_R_WE] <= 1;
            WBStage[`WB_RDST_MUX] <= 2'b01;           
        end
        `XOR :
        begin
            SignExt <= bit16 ? 0 : 2'b0;
            RS2_Sel <= 1'b0;
            IFid__Need_Rs2 <= !bit16;
            RETI_Inst <= 1'b0;//RETI
            
            /* EX */
            EXStage[`EX_CondBits] <= 4'b0;
            EXStage[`EX_ALUCTRL] <= 4'b0110;
            EXStage[`EX_ALU_SRC1] <= 2'b00;
            EXStage[`EX_ALU_SRC2] <= bit16;
            EXStage[`EX_CC_WE] <= 0;
            EXStage[`EX_JMP] <= 0;
            EXStage[`EX_BXX] <= 0;
            EXStage[`EX_NEED_RS1] <= 1;
            EXStage[`EX_NEED_RS2] <= !bit16;
            
            /* MA */
            MAStage[`MA_RW] <= 0;
            MAStage[`MA_EN] <= 0;               
            
            /* WB */
            WBStage[`WB_R_WE] <= 1;
            WBStage[`WB_RDST_MUX] <= 2'b01; 
        end
        `CMP :
        begin
            SignExt <= bit16 ? 0 : 2'b0;
            RS2_Sel <= 1'b0;
            IFid__Need_Rs2 <= !bit16;
            RETI_Inst <= 1'b0;//RETI
            
            /*Ex*/
            EXStage[`EX_CondBits] <= 4'b0;
            EXStage[`EX_ALUCTRL] <= 4'b0010;
            EXStage[`EX_ALU_SRC1] <= 2'b00;
            EXStage[`EX_ALU_SRC2] <= bit16;
            EXStage[`EX_CC_WE] <= 1;
            EXStage[`EX_JMP] <= 0;
            EXStage[`EX_BXX] <= 0;
            EXStage[`EX_NEED_RS1] <= 1;
            EXStage[`EX_NEED_RS2] <= !bit16;
            
            /* MA */
            MAStage[`MA_RW] <= 0;
            MAStage[`MA_EN] <= 0;               
            
            /* WB */ 
            WBStage[`WB_R_WE] <= 0;              
            WBStage[`WB_RDST_MUX] <= 2'b01; 
        end
        `BXX :
        begin
            SignExt <= 2'b11;
            RS2_Sel <= 1'b0;
            IFid__Need_Rs2 <= 0;
            RETI_Inst <= 1'b0;//RETI
        
            /* Ex */
            EXStage[`EX_CondBits] <= CondBits;
            EXStage[`EX_ALUCTRL] <= 4'b0001;
            EXStage[`EX_ALU_SRC1] <= 2'b01;
            EXStage[`EX_ALU_SRC2] <= 1'b1;
            EXStage[`EX_CC_WE] <= 0;
            EXStage[`EX_JMP] <= 0;
            EXStage[`EX_BXX ] <= 1;
            EXStage[`EX_NEED_RS1] <= 0;
            EXStage[`EX_NEED_RS2] <= 0;
            
            /* MA */
            MAStage[`MA_RW] <= 0; 
            MAStage[`MA_EN] <= 0;               
            
            /* WB */ 
            WBStage[`WB_R_WE] <= 0;
            WBStage[`WB_RDST_MUX] <= 2'b0;           
        end
        `JMP :
        begin
            SignExt <= 2'b00;
            RS2_Sel <= 1'b0;
            IFid__Need_Rs2 <= 0;
            RETI_Inst <= 1'b0;//RETI
        
            /* EX */
            EXStage[`EX_CondBits] <= 4'b0;
            EXStage[`EX_ALUCTRL] <= 4'b0001;
            EXStage[`EX_ALU_SRC1] <= 2'b00;
            EXStage[`EX_ALU_SRC2] <= 1'b1;
            EXStage[`EX_CC_WE] <= 0;
            EXStage[`EX_JMP] <= 1;
            EXStage[`EX_BXX] <= 0;
            EXStage[`EX_NEED_RS1] <= 1;
            EXStage[`EX_NEED_RS2] <= 0;
            
            /* MA */
            MAStage[`MA_RW] <= 0;
            MAStage[`MA_EN] <= 0;                     
            
            /* WB */
            WBStage[`WB_R_WE] <= bit16;
            WBStage[`WB_RDST_MUX] <= (bit16)? 2'b10:2'b0; 
        end
        `LD :
        begin
            SignExt <= 2'b10;
            RS2_Sel <= 1'b0;
            IFid__Need_Rs2 <= 0;
            RETI_Inst <= 1'b0;//RETI
        
            /*Ex*/
            EXStage[`EX_CondBits] <= 4'b0;
            EXStage[`EX_ALUCTRL] <= 4'b0001;
            EXStage[`EX_ALU_SRC1] <= 2'b10;
            EXStage[`EX_ALU_SRC2] <= 1;
            EXStage[`EX_CC_WE] <= 0;
            EXStage[`EX_JMP] <= 0;
            EXStage[`EX_BXX ] <= 0;
            EXStage[`EX_NEED_RS1] <= 0;
            EXStage[`EX_NEED_RS2] <= 0;
            
            /* MA */
            MAStage[`MA_RW] <= 0;
            MAStage[`MA_EN] <= 1;               
            
            /* WB */ 
            WBStage[`WB_R_WE] <= 1;
            WBStage[`WB_RDST_MUX] <= 2'b00; 
        end
        `LDI :
        begin
            SignExt <= 2'b10;
            RS2_Sel <= 1'b0;
            IFid__Need_Rs2 <= 0;
            RETI_Inst <= 1'b0;//RETI
        
            /* Ex */
            EXStage[`EX_CondBits] <= 4'b0;
            EXStage[`EX_ALUCTRL] <= 4'b0001;
            EXStage[`EX_ALU_SRC1] <= 2'b10;
            EXStage[`EX_ALU_SRC2] <= 1'b1;
            EXStage[`EX_CC_WE] <= 0;
            EXStage[`EX_JMP] <= 0;
            EXStage[`EX_BXX ] <= 0;
            EXStage[`EX_NEED_RS1] <= 0;
            EXStage[`EX_NEED_RS2] <= 0;
            
            /* MA */
            MAStage[`MA_RW] <= 0;
            MAStage[`MA_EN] <= 0;               
            
            /* WB */ 
            WBStage[`WB_R_WE] <= 1;
            WBStage[`WB_RDST_MUX] <= 2'b01; // foi mudado           
        end
        `LDX :
        begin
            SignExt <= 2'b01;
            RS2_Sel <= 1'b0;
            IFid__Need_Rs2 <= 1;//?
            RETI_Inst <= 1'b0;//RETI
        
            /* Ex */
            EXStage[`EX_CondBits] <= 4'b0;
            EXStage[`EX_ALUCTRL] <= 4'b0001;
            EXStage[`EX_ALU_SRC1] <= 2'b00;
            EXStage[`EX_ALU_SRC2] <= 1'b1;
            EXStage[`EX_CC_WE] <= 0;
            EXStage[`EX_JMP] <= 0;
            EXStage[`EX_BXX ] <= 0;
            EXStage[`EX_NEED_RS1] <= 1;
            EXStage[`EX_NEED_RS2] <= 0;//?
            
            /* MA */
            MAStage[`MA_RW] <= 0; 
            MAStage[`MA_EN] <= 1;               
            
            /* WB */ 
            WBStage[`WB_R_WE] <= 1;
            WBStage[`WB_RDST_MUX] <= 2'b00;
        end
        `ST : 
        begin
            SignExt <= 2'b10;
            RS2_Sel <= 1'b1;
            IFid__Need_Rs2 <= 0;
            RETI_Inst <= 1'b0;//RETI
        
            /*Ex*/
            EXStage[`EX_CondBits] <= 4'b0;
            EXStage[`EX_ALUCTRL] <= 4'b0001;
            EXStage[`EX_ALU_SRC1] <= 2'b10;
            EXStage[`EX_ALU_SRC2] <= 1'b1;
            EXStage[`EX_CC_WE] <= 0;
            EXStage[`EX_JMP] <= 0;
            EXStage[`EX_BXX ] <= 0;
            EXStage[`EX_NEED_RS1] <= 0;
            EXStage[`EX_NEED_RS2] <= 1;
            
            /* MA */
            MAStage[`MA_RW] <= 1;
            MAStage[`MA_EN] <= 1;                
            
            /* WB */ 
            WBStage[`WB_R_WE] <= 0;
            WBStage[`WB_RDST_MUX] <= 2'b01; 
        end
        `STX :
        begin
            SignExt <= 2'b01;
            RS2_Sel <= 1'b1;
            IFid__Need_Rs2 <= 1;
            RETI_Inst <= 1'b0;//RETI
        
            /* Ex */
            EXStage[`EX_CondBits] <= 4'b0;
            EXStage[`EX_ALUCTRL] <= 4'b0001;
            EXStage[`EX_ALU_SRC1] <= 2'b00;
            EXStage[`EX_ALU_SRC2] <= 1'b1;
            EXStage[`EX_CC_WE] <= 0;
            EXStage[`EX_JMP] <= 0;
            EXStage[`EX_BXX ] <= 0;
            EXStage[`EX_NEED_RS1] <= 1;
            EXStage[`EX_NEED_RS2] <= 1;
            
            /* MA */
            MAStage[`MA_RW] <= 1;
            MAStage[`MA_EN] <= 1;               
            
            /* WB */ 
            WBStage[`WB_R_WE] <= 0;
            WBStage[`WB_RDST_MUX] <= 2'b01;           
        end
        `HLT :
        begin
            SignExt <= 2'b0;
            RS2_Sel <= 1'b0;
            RETI_Inst <= 1'b0;//RETI
            
            /* EX */
            EXStage[`EX_CondBits] <= 4'b0;
            EXStage[`EX_ALUCTRL] <= 4'b0000;
            EXStage[`EX_ALU_SRC1] <= 2'b00;
            EXStage[`EX_ALU_SRC2] <= 1'b0;
            EXStage[`EX_CC_WE] <= 0;
            EXStage[`EX_JMP] <= 0;
            EXStage[`EX_BXX] <= 0;
            EXStage[`EX_NEED_RS1] <= 0;
            EXStage[`EX_NEED_RS2] <= 0;
            
            /* MA */
            MAStage[`MA_RW] <= 0;
            MAStage[`MA_EN] <= 0;               
            
            /* WB */
            WBStage[`WB_R_WE] <= 0;
            WBStage[`WB_RDST_MUX] <= 2'b0; 
        end
        `MUL:
        begin
            SignExt <= bit16 ? 0 : 2'b0;
            RS2_Sel <= 1'b0;
            IFid__Need_Rs2 <= !bit16;
    
            /* Ex */
            EXStage[`EX_CondBits] <= 4'b0;
            EXStage[`EX_ALUCTRL] <= 4'b0111;
            EXStage[`EX_ALU_SRC1] <= 2'b00;
            EXStage[`EX_ALU_SRC2] <= bit16;
            EXStage[`EX_CC_WE] <= 1;
            EXStage[`EX_JMP] <= 0;
            EXStage[`EX_BXX ] <= 0;
            EXStage[`EX_NEED_RS1] <= 1;
            EXStage[`EX_NEED_RS2] <= !bit16;
            
            /* MA */
            MAStage[`MA_RW] <= 0;
            MAStage[`MA_EN] <= 0;               
               
            /* WB */ 
            WBStage[`WB_R_WE] <= 1;
            WBStage[`WB_RDST_MUX] <= 2'b01; 
        end
        `DIV:
        begin
            SignExt <= bit16 ? 0 : 2'b0;
            RS2_Sel <= 1'b0;
            IFid__Need_Rs2 <= !bit16;
            
            /* Ex */
            EXStage[`EX_CondBits] <= 4'b0;
            EXStage[`EX_ALUCTRL] <= 4'b1000;
            EXStage[`EX_ALU_SRC1] <= 2'b00;
            EXStage[`EX_ALU_SRC2] <= bit16;
            EXStage[`EX_CC_WE] <= 1;
            EXStage[`EX_JMP] <= 0;
            EXStage[`EX_BXX ] <= 0;
            EXStage[`EX_NEED_RS1] <= 1;
            EXStage[`EX_NEED_RS2] <= !bit16;
            
            /* MA */
            MAStage[`MA_RW] <= 0;
            MAStage[`MA_EN] <= 0;               
            
            /* WB */ 
            WBStage[`WB_R_WE] <= 1;
            WBStage[`WB_RDST_MUX] <= 2'b01;
        end
        //---------------NEW SHIfTS----------------//
        
        `ASR :
        begin
            SignExt <= bit16 ? 0 : 2'b0;
            RS2_Sel <= 1'b0;
            IFid__Need_Rs2 <= !bit16;
            RETI_Inst <= 1'b0;//RETI
            
            /* Ex */
            EXStage[`EX_CondBits] <= 4'b0;
            EXStage[`EX_ALUCTRL] <= 4'b1001;
            EXStage[`EX_ALU_SRC1] <= 2'b00;
            EXStage[`EX_ALU_SRC2] <= bit16;
            EXStage[`EX_CC_WE] <= 1;
            EXStage[`EX_JMP] <= 0;
            EXStage[`EX_BXX ] <= 0;
            EXStage[`EX_NEED_RS1] <= 1;
            EXStage[`EX_NEED_RS2] <= !bit16;
            
            /* MA */
            MAStage[`MA_RW] <= 0; 
            MAStage[`MA_EN] <= 0;               
              
            /* WB */ 
            WBStage[`WB_R_WE] <= 1;
            WBStage[`WB_RDST_MUX] <= 2'b01;           
        end
        `ASL :
        begin
            SignExt <= bit16 ? 0 : 2'b0;
            RS2_Sel <= 1'b0;
            IFid__Need_Rs2 <= !bit16;
            RETI_Inst <= 1'b0;//RETI
            
            /* Ex */
            EXStage[`EX_CondBits] <= 4'b0;
            EXStage[`EX_ALUCTRL] <= 4'b1010;
            EXStage[`EX_ALU_SRC1] <= 2'b00;
            EXStage[`EX_ALU_SRC2] <= bit16;
            EXStage[`EX_CC_WE] <= 1;
            EXStage[`EX_JMP] <= 0;
            EXStage[`EX_BXX ] <= 0;
            EXStage[`EX_NEED_RS1] <= 1;
            EXStage[`EX_NEED_RS2] <= !bit16;
            
            /* MA */
            MAStage[`MA_RW] <= 0; 
            MAStage[`MA_EN] <= 0;               
              
            /* WB */ 
            WBStage[`WB_R_WE] <= 1;
            WBStage[`WB_RDST_MUX] <= 2'b01;           
        end
        `LSR  :
        begin
            SignExt <= bit16 ? 0 : 2'b0;
            RS2_Sel <= 1'b0;
            IFid__Need_Rs2 <= !bit16;
            RETI_Inst <= 1'b0;//RETI

            /*Ex*/
            EXStage[`EX_CondBits] <= 4'b0;
            EXStage[`EX_ALUCTRL] <= 4'b1011;
            EXStage[`EX_ALU_SRC1] <= 2'b00;
            EXStage[`EX_ALU_SRC2] <= bit16;
            EXStage[`EX_CC_WE] <= 0;
            EXStage[`EX_JMP] <= 0;
            EXStage[`EX_BXX] <= 0;
            EXStage[`EX_NEED_RS1] <= 1;
            EXStage[`EX_NEED_RS2] <= !bit16;
            
            /* MA */
            MAStage[`MA_RW] <= 0;
            MAStage[`MA_EN] <= 0;               
            
            /* WB */
            WBStage[`WB_R_WE] <= 1;
            WBStage[`WB_RDST_MUX] <= 2'b01;           
        end  
        `LSL  :
        begin
            SignExt <= bit16 ? 0 : 2'b0;
            RS2_Sel <= 1'b0;
            IFid__Need_Rs2 <= !bit16;
            RETI_Inst <= 1'b0;//RETI

            /*Ex*/
            EXStage[`EX_CondBits] <= 4'b0;
            EXStage[`EX_ALUCTRL] <= 4'b1100;
            EXStage[`EX_ALU_SRC1] <= 2'b00;
            EXStage[`EX_ALU_SRC2] <= bit16;
            EXStage[`EX_CC_WE] <= 0;
            EXStage[`EX_JMP] <= 0;
            EXStage[`EX_BXX] <= 0;
            EXStage[`EX_NEED_RS1] <= 1;
            EXStage[`EX_NEED_RS2] <= !bit16;
            
            /* MA */
            MAStage[`MA_RW] <= 0;
            MAStage[`MA_EN] <= 0;               
            
            /* WB */
            WBStage[`WB_R_WE] <= 1;
            WBStage[`WB_RDST_MUX] <= 2'b01;           
        end            
            `RETI :
            begin
            SignExt <= 2'bx;
            RS2_Sel <= 1'bx;
            IFid__Need_Rs2 <= 0;
            RETI_Inst <= 1'b1;
            
            /* Ex */
            EXStage[`EX_CondBits] <= 4'b0;
            EXStage[`EX_ALUCTRL] <= 4'b0000;
            EXStage[`EX_ALU_SRC1] <= 2'b0;
            EXStage[`EX_ALU_SRC2] <= 1'b0;
            EXStage[`EX_CC_WE] <= 0;
            EXStage[`EX_JMP] <= 1;
            EXStage[`EX_BXX ] <= 1;
            EXStage[`EX_NEED_RS1] <= 1'b0;
            EXStage[`EX_NEED_RS2] <=  1'b0;
            
            /* MA */
            MAStage[`MA_RW] <= 0;
            MAStage[`MA_EN] <= 0;                  
            
            /* WB */ 
            WBStage[`WB_R_WE] <= 0;
            WBStage[`WB_RDST_MUX] <= 2'b0;           
        end
    endcase

end    

endmodule
