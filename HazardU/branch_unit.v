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
    
    /***************VIC*******************/
    input   IRQ, //NEW INPUT FROM VIC, telling if there is an interruption to be attended
    
    output  reg [1:0] CtrlOut,
    output  FlushPipePC,
    output  reg WriteEnable,
    output  reg [1:0] NPC
    
    );
    
    //changed here
    wire [6:0] inputcat = {PcMatchValid,JumpTaken,BranchInstr,JumpInstr,PredicEqRes,CtrlIn};  
    
    //Could be reg?
    reg [1:0] Flush;   //auxiliar wire to determine if FlushPipePC should be asserted. Flush[1] is modified by the IRQ and Flush[0] is modified by the switch case
                        //if one of both is asserted then the Flush of Fetch and Decode should be done (FlushPipePC = 1)
    
    
    //If any of the bits the Flush bus is asserted then the Flush of the Fetch and Decode must happen    
    assign FlushPipePC = (|Flush);
    
    always @(inputcat or IRQ)
    begin  
   
    // If there is an IRQ to be attended, the fetch and the decode should be flushed
    // The following if asserts one of the bits of the Flush bus.
    if (IRQ)
        Flush[1] <= 1;
    else
        Flush[1] <= 0;  
    
    
    casex(inputcat)    
        7'bxx00xxx : 
        begin
        CtrlOut <= 2'b00;
        Flush[0] <= 1'b0;
        WriteEnable <= 1'b0;
        NPC <= 2'b00;       
        end
        
        7'b1x010xx: 
        begin
        CtrlOut <= 2'b10;
        Flush[0] <= 1'b1;
        WriteEnable <= 1'b1;
        NPC <= 2'b00;       
        end
        
        7'b1x011xx:   
        begin
        CtrlOut <= 2'b10;
        Flush[0] <= 1'b0;
        WriteEnable <= 1'b1;
        NPC <= 2'b00;       
        end
        
        7'b0x01xxx: 
        begin
        CtrlOut <= 2'b10;
        Flush[0] <= 1'b1;
        WriteEnable <= 1'b1;
        NPC <= 2'b00;       
        end       
        
        7'b0010xxx: 
        begin
        CtrlOut <= 2'b00;
        Flush[0] <= 1'b0;
        WriteEnable <= 1'b1;
        NPC <= 2'b01;       
        end   
        
        
        7'b0110xxx: 
        begin
        CtrlOut <= 2'b10;
        Flush[0] <= 1'b1;
        WriteEnable <= 1'b1;
        NPC <= 2'b00;       
        end 
                
        7'b1010x00: 
        begin
        CtrlOut <= 2'b00;
        Flush[0] <= 1'b0;
        WriteEnable <= 1'b1;
        NPC <= 2'b01;       
        end 
        
        7'b1010x01: 
        begin
        CtrlOut <= 2'b00;
        Flush[0] <= 1'b0;
        WriteEnable <= 1'b1;
        NPC <= 2'b01;       
        end 
        
        7'b1010x10: 
        begin
        CtrlOut <= 2'b11;
        Flush[0] <= 1'b1;
        WriteEnable <= 1'b1;
        NPC <= 2'b01;       
        end 
        
        7'b1010x11:
        begin
        CtrlOut <= 2'b00;
        Flush[0] <= 1'b1;
        WriteEnable <= 1'b1;
        NPC <= 2'b01;       
        end  
        
        7'b1110x00: 
        begin
        CtrlOut <= 2'b01;
        Flush[0] <= 1'b1;
        WriteEnable <= 1'b1;
        NPC <= 2'b00;       
        end  
        
        7'b1110x01: 
        begin
        CtrlOut <= 2'b10;
        Flush[0] <= 1'b1;
        WriteEnable <= 1'b1;
        NPC <= 2'b00;       
        end  
        
        7'b1110x10:
        begin
        CtrlOut <= 2'b10;
        Flush[0] <= 1'b0;
        WriteEnable <= 1'b1;
        NPC <= 2'b00;       
        end  
        
    
        7'b1110x11:
        begin
        CtrlOut <= 2'b10;
        Flush[0] <= 1'b0;
        WriteEnable <= 1'b1;
        NPC <= 2'b00;       
        end         
        
        
        /* New line in the table */
        /* RETI INSTRUCTION - both BranchInstr and JumpInstr asserted */
        
        7'bxx11xxx:
        begin
        CtrlOut <= 2'b00;
        Flush[0] <= 1'b1;
        WriteEnable <= 1'b0;
        NPC <= 2'b10;       
        end  
        
       /* End of the RETI instruction*/
        
       default:
       begin
       CtrlOut <= 2'b00;
       Flush[0] <= 1'b0;
       WriteEnable <= 1'b0;
       NPC <= 2'b00;       
       end         
    endcase
    end
endmodule


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
