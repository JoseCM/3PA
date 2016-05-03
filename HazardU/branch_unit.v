`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.04.2016 16:59:45
// Design Name: 
// Module Name: branch_unit
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

module branch_unit(
    input   PcMatchValid,
    input   JumpTaken,
    input   BranchInstr,
    input   JumpInstr,
    input   PredicEqRes,
    input   [1:0] CtrlIn,
    
    output  reg [1:0] CtrlOut,
    output  reg FlushPipePC,
    output  reg WriteEnable,
    output  reg [1:0] NPC
    
    );
    
    //changed here
    wire [6:0] inputcat = {PcMatchValid,JumpTaken,BranchInstr,JumpInstr,PredicEqRes,CtrlIn};  
    
    always @(inputcat)
    begin  
    
    casex(inputcat)
    
        7'bxx00xxx : 
        begin
        CtrlOut <= 2'b00;
        FlushPipePC <= 1'b0;
        WriteEnable <= 1'b0;
        NPC <= 2'b00;       
        end
        
        7'b1x010xx: 
        begin
        CtrlOut <= 2'b10;
        FlushPipePC <= 1'b1;
        WriteEnable <= 1'b1;
        NPC <= 2'b00;       
        end
        
        7'b1x011xx:   
        begin
        CtrlOut <= 2'b10;
        FlushPipePC <= 1'b0;
        WriteEnable <= 1'b1;
        NPC <= 2'b00;       
        end
        
        7'b0x01xxx: 
        begin
        CtrlOut <= 2'b10;
        FlushPipePC <= 1'b1;
        WriteEnable <= 1'b1;
        NPC <= 2'b00;       
        end       
        
        7'b0010xxx: 
        begin
        CtrlOut <= 2'b00;
        FlushPipePC <= 1'b0;
        WriteEnable <= 1'b1;
        NPC <= 2'b01;       
        end   
        
        
        7'b0110xxx: 
        begin
        CtrlOut <= 2'b10;
        FlushPipePC <= 1'b1;
        WriteEnable <= 1'b1;
        NPC <= 2'b00;       
        end 
                
        7'b1010x00: 
        begin
        CtrlOut <= 2'b00;
        FlushPipePC <= 1'b0;
        WriteEnable <= 1'b1;
        NPC <= 2'b01;       
        end 
        
        7'b1010x01: 
        begin
        CtrlOut <= 2'b00;
        FlushPipePC <= 1'b0;
        WriteEnable <= 1'b1;
        NPC <= 2'b01;       
        end 
        
        7'b1010x10: 
        begin
        CtrlOut <= 2'b11;
        FlushPipePC <= 1'b1;
        WriteEnable <= 1'b1;
        NPC <= 2'b01;       
        end 
        
        7'b1010x11:
        begin
        CtrlOut <= 2'b00;
        FlushPipePC <= 1'b1;
        WriteEnable <= 1'b1;
        NPC <= 2'b01;       
        end  
        
        7'b1110x00: 
        begin
        CtrlOut <= 2'b01;
        FlushPipePC <= 1'b1;
        WriteEnable <= 1'b1;
        NPC <= 2'b00;       
        end  
        
        7'b1110x01: 
        begin
        CtrlOut <= 2'b10;
        FlushPipePC <= 1'b1;
        WriteEnable <= 1'b1;
        NPC <= 2'b00;       
        end  
        
        7'b1110x10:
        begin
        CtrlOut <= 2'b10;
        FlushPipePC <= 1'b0;
        WriteEnable <= 1'b1;
        NPC <= 2'b00;       
        end  
        
        
        7'b1110x11:
        begin
        CtrlOut <= 2'b10;
        FlushPipePC <= 1'b0;
        WriteEnable <= 1'b1;
        NPC <= 2'b00;       
        end         
        
//        7'b0x01xxx: 
//        begin
//        CtrlOut <= 2'b01;
//        FlushPipePC <= 1'b1;
//        WriteEnable <= 1'b1;
//        NPC <= 2'b01;       
//        end     
           
//        7'b0110xxx: 
//        begin
//        CtrlOut <= 2'b00;
//        FlushPipePC <= 1'b0;
//        WriteEnable <= 1'b1;
//        NPC <= 2'b10;       
//        end
        
       default:
       begin
       CtrlOut <= 2'b00;
       FlushPipePC <= 1'b0;
       WriteEnable <= 1'b0;
       NPC <= 2'b00;       
       end 
        
    endcase
    end
endmodule
