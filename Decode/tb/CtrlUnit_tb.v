`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/13/2016 08:44:51 PM
// Design Name: 
// Module Name: CtrlUnit_tb
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

`include "pipelinedefs.vh"

module CtrlUnit_tb(

    );
    
    reg [4:0] opcode;
    reg bit16;
    wire [1:0] SignExt;
    wire RS2_Select;
    wire [14:0] EXStage;
    wire [1:0] MAStage;
    wire [2:0] WBStage;
    
    ControlUnit ctrlU(
        .opcode(opcode),
        .bit16(bit16),
        .SignExt(SignExt),
        .RS2_Sel(RS2_Select),
        .EXStage(EXStage),
        .MAStage(MAStage),
        .WBStage(WBStage)
    );

    wire [22:0] LARGE_CONCAT;
    reg [22:0] CURRENT_CONCAT;
    assign LARGE_CONCAT = {SignExt,RS2_Select,EXStage,MAStage,WBStage};
    
    wire [3:0] CondBits = EXStage[`EX_CondBits];
    wire [2:0] ALU_CTRL = EXStage[`EX_ALUCTRL];  
    wire [1:0] ALU_SRC1 = EXStage[`EX_ALU_SRC1]; 
    wire ALU_SRC2       = EXStage[`EX_ALU_SRC2]; 
    wire CC_WE          = EXStage[`EX_CC_WE];    
    wire JMP            = EXStage[`EX_JMP];      
    wire BXX            = EXStage[`EX_BXX ];     
    wire NEED_RS1       = EXStage[`EX_NEED_RS1]; 
    wire NEED_RS2       = EXStage[`EX_NEED_RS2]; 
                
                /* MA */
    wire MA_RW          = MAStage[`MA_RW];
    wire MEM_EN         = MAStage[`MA_EN];                  
                
                /* WB */ 
    wire Reg_WE         =  WBStage[`WB_R_WE];
    wire [1:0] RDST     = WBStage[`WB_RDST_MUX];         

    initial
    begin
        #10 testNop;
        #10 testAdd;
        #10 testSub;
        #10 testOr;
        #10 testAnd;
        #10 testXor;
        #10 testCmp;
        #10 testAddI;
        #10 testSubI;
        #10 testOrI;
        #10 testAndI;
        #10 testXorI;
        #10 testCmpI;
        #10 testBxx;
        #10 testNot;
        #10 testJmp;
        #10 testJmpLink;
        #10 testLd;
        #10 testLdi;
        #10 testLdx;
        #10 testSt;
        #10 testStx;
        #10 testHlt;
        #10 $finish;
    end
 
 
task testNop;
    begin
    $display("*Testing NOP");

    opcode = 5'b0;
    bit16 = 1'bx;
    #1;
    $write("\tTesting NOP is ");


    CURRENT_CONCAT = {2'bx,1'bx,4'bx,3'b000,2'bx,1'bx,1'b0,1'b0,1'b0,1'bx,1'bx,1'b0,1'b0,1'b0,2'b0};
    if(LARGE_CONCAT === CURRENT_CONCAT)
        $display("successful!");
    else begin
        $display("unsuccessful...");
        $display("Expected %x - Real %x", CURRENT_CONCAT, LARGE_CONCAT);
    end
    
    $display("");
end
endtask
    
    
task testAdd;
begin
    $display("*Testing ADD");

    opcode = 5'b1;
    bit16 = 1'b0;
    #1;
    $write("\tTesting ADD is ");
    
    CURRENT_CONCAT = {2'bx,1'b0,4'bx,3'b001,2'b00,1'b0,1'b1,1'b0,1'b0,1'b1,1'b1,1'b0,1'b0,1'b1,2'b01};
    if(LARGE_CONCAT === CURRENT_CONCAT)
        $display("successful!");
    else begin
        $display("unsuccessful...");
        $display("Expected %x - Real %x", CURRENT_CONCAT, LARGE_CONCAT);
    end
    
    $display("");
end
endtask


task testSub;
begin
    $display("*Testing SUB");

    opcode = 5'b10;
    bit16 = 1'b0;
    #1;
    $write("\tTesting SUB is ");
    
    CURRENT_CONCAT = {2'bx,1'b0,4'bx,3'b010,2'b0,1'b0,1'b1,1'b0,1'b0,1'b1,1'b1,1'b0,1'b0,1'b1,2'b01};
    if(LARGE_CONCAT === CURRENT_CONCAT)
        $display("successful!");
    else begin
        $display("unsuccessful...");
        $display("Expected %x - Real %x", CURRENT_CONCAT, LARGE_CONCAT);
    end
    
    $display("");
end
endtask


task testOr;
begin
    $display("*Testing OR");

    opcode = 5'b11;
    bit16 = 1'b0;
    #1;
    $write("\tTesting OR is ");
    
    CURRENT_CONCAT = {2'bx,1'b0,4'bx,3'b011,2'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1,1'b0,1'b0,1'b1,2'b01};
    if(LARGE_CONCAT === CURRENT_CONCAT)
        $display("successful!");
    else begin
        $display("unsuccessful...");
        $display("Expected %x - Real %x", CURRENT_CONCAT, LARGE_CONCAT);
    end
    
    $display("");
end
endtask


task testAnd;
begin
    $display("*Testing AND");

    opcode = 5'b100;
    bit16 = 1'b0;
    #1;
    $write("\tTesting AND is ");
    
    CURRENT_CONCAT = {2'bx,1'b0,4'bx,3'b100,2'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1,1'b0,1'b0,1'b1,2'b01};
    if(LARGE_CONCAT === CURRENT_CONCAT)
        $display("successful!");
    else begin
        $display("unsuccessful...");
        $display("Expected %x - Real %x", CURRENT_CONCAT, LARGE_CONCAT);
    end
    
    $display("");
end
endtask


task testNot;
begin
    $display("*Testing NOT");
    
    opcode = 5'b101;
    //bit16 = 1'b0;
    #1;
    $write("\tTesting NOT is ");
    
    CURRENT_CONCAT = {2'bx,1'bx,4'bx,3'b101,2'b00,1'b0,1'b0,1'b0,1'b0,1'b1,1'b0,1'b0,1'b0,1'b1,2'b01};
    if(LARGE_CONCAT === CURRENT_CONCAT)
        $display("successful!");
    else begin
        $display("unsuccessful...");
        $display("Expected %x - Real %x", CURRENT_CONCAT, LARGE_CONCAT);
    end
    
    $display("");
end
endtask


task testXor;
begin
    $display("*Testing XOR");

    opcode = 5'b00110;
    bit16 = 1'b0;
    #1;
    $write("\tTesting XOR is ");
    
    CURRENT_CONCAT = {2'bx,1'b0,4'bx,3'b110,2'b00,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1,1'b0,1'b0,1'b1,2'b01};
    if(LARGE_CONCAT === CURRENT_CONCAT)
        $display("successful!");
    else begin
        $display("unsuccessful...");
        $display("Expected %x - Real %x", CURRENT_CONCAT, LARGE_CONCAT);
    end
    
    $display("");
end
endtask


task testCmp;
begin
    $display("*Testing CMP");

    opcode = 5'b00111;
    bit16 = 1'b0;
    #1;
    $write("\tTesting CMP is ");
    
    CURRENT_CONCAT = {2'bx,1'b0,4'bx,3'b111,2'b00,1'b0,1'b1,1'b0,1'b0,1'b1,1'b1,1'b0,1'b0,1'b1,2'b01};
    if(LARGE_CONCAT === CURRENT_CONCAT)
        $display("successful!");
    else begin
        $display("unsuccessful...");
        $display("Expected %x - Real %x", CURRENT_CONCAT, LARGE_CONCAT);
    end
    
    $display("");
end
endtask


task testAddI;
begin
    $display("*Testing ADD immediate");

    opcode = 5'b1;
    bit16 = 1'b1;
    #1;
    $write("\tTesting ADD is ");
    
    CURRENT_CONCAT = {2'b00,1'b0,4'bx,3'b001,2'b00,1'b1,1'b1,1'b0,1'b0,1'b1,1'b0,1'b0,1'b0,1'b1,2'b01};
    if(LARGE_CONCAT === CURRENT_CONCAT)
        $display("successful!");
    else begin
        $display("unsuccessful...");
        $display("Expected %x - Real %x", CURRENT_CONCAT, LARGE_CONCAT);
    end
    
    $display("");
end
endtask


task testSubI;
begin
    $display("*Testing SUB immediate");

    opcode = 5'b00010;
    bit16 = 1'b1;
    #1;
    $write("\tTesting SUB is ");
    
    CURRENT_CONCAT = {2'b00,1'b0,4'bx,3'b010,2'b00,1'b1,1'b1,1'b0,1'b0,1'b1,1'b0,1'b0,1'b0,1'b1,2'b01};
    if(LARGE_CONCAT === CURRENT_CONCAT)
        $display("successful!");
    else begin
        $display("unsuccessful...");
        $display("Expected %x - Real %x", CURRENT_CONCAT, LARGE_CONCAT);
    end
    
    $display("");
end
endtask


task testOrI;
begin
    $display("*Testing OR immediate");

    opcode = 5'b00011;
    bit16 = 1'b1;
    #1;
    $write("\tTesting OR is ");
    
    CURRENT_CONCAT = {2'b00,1'b0,4'bx,3'b011,2'b00,1'b1,1'b0,1'b0,1'b0,1'b1,1'b0,1'b0,1'b0,1'b1,2'b01};
    if(LARGE_CONCAT === CURRENT_CONCAT)
        $display("successful!");
    else begin
        $display("unsuccessful...");
        $display("Expected %x - Real %x", CURRENT_CONCAT, LARGE_CONCAT);
    end
    
    $display("");
end
endtask


task testAndI;
begin
    $display("*Testing AND immediate");

    opcode = 5'b00100;
    bit16 = 1'b1;
    #1;
    $write("\tTesting AND is ");
    
    CURRENT_CONCAT = {2'b00,1'b0,4'bx,3'b100,2'b00,1'b1,1'b0,1'b0,1'b0,1'b1,1'b0,1'b0,1'b0,1'b1,2'b01};
    if(LARGE_CONCAT === CURRENT_CONCAT)
        $display("successful!");
    else begin
        $display("unsuccessful...");
        $display("Expected %x - Real %x", CURRENT_CONCAT, LARGE_CONCAT);
    end
    
    $display("");
end
endtask


task testXorI;
begin
    $display("*Testing XOR immediate");

    opcode = 5'b00110;
    bit16 = 1'b1;
    #1;
    $write("\tTesting XOR is ");
    
    CURRENT_CONCAT = {2'b00,1'b0,4'bx,3'b110,2'b00,1'b1,1'b0,1'b0,1'b0,1'b1,1'b0,1'b0,1'b0,1'b1,2'b01};
    if(LARGE_CONCAT === CURRENT_CONCAT)
        $display("successful!");
    else begin
        $display("unsuccessful...");
        $display("Expected %x - Real %x", CURRENT_CONCAT, LARGE_CONCAT);
    end
    
    $display("");
end
endtask


task testCmpI;
begin
    $display("*Testing CMP immediate");
    
    opcode = 5'b00111;
    bit16 = 1'b1;

    #1;
    $write("\tTesting CMP is ");
    
    CURRENT_CONCAT = {2'b0,1'b0,4'bx,3'b111,2'b00,1'b1,1'b1,1'b0,1'b0,1'b1,1'b0,1'b0,1'b0,1'b1,2'b01};
    if(LARGE_CONCAT === CURRENT_CONCAT)
        $display("successful!");
    else begin
        $display("unsuccessful...");
        $display("Expected %x - Real %x", CURRENT_CONCAT, LARGE_CONCAT);
    end
    
    $display("");
end
endtask


task testBxx;
begin
    $display("*Testing BXX");
    
    opcode = 5'b01000;
    bit16 = 1'b0;
    
    #1;
    $write("\tTesting BXX is ");
    
    CURRENT_CONCAT = {2'b11,1'bx,CondBits,3'b001,2'b01,1'b1,1'b0,1'b0,1'b1,1'b0,1'b0,1'b0,1'b0,1'b0,2'bx};
    if(LARGE_CONCAT === CURRENT_CONCAT)
        $display("successful!");
    else begin
        $display("unsuccessful...");
        $display("Expected %x - Real %x", CURRENT_CONCAT, LARGE_CONCAT);
    end
    
    $display("");
end
endtask


task testJmp;
begin
    $display("*Testing Jump");

    opcode = 5'b01001;
    bit16 = 1'b0;
    #1;
    $write("\tTesting JMP is ");
    
    CURRENT_CONCAT = {2'b00,1'b0,4'bx,3'b001,2'b00,1'b1,1'b0,1'b1,1'b0,1'b1,1'b0,1'b0,1'b0,1'b0,2'bxx};
    if(LARGE_CONCAT === CURRENT_CONCAT)
        $display("successful!");
    else begin
        $display("unsuccessful...");
        $display("Expected %x - Real %x", CURRENT_CONCAT, LARGE_CONCAT);
    end
    
    $display("");
end
endtask


task testJmpLink;
begin
    $display("*Testing Jump and Link");

    opcode = 5'b01001;
    bit16 = 1'b1;
    #1;
    $write("\tTesting JMPL is ");
    
    CURRENT_CONCAT = {2'b00,1'b0,4'bx,3'b001,2'b00,1'b1,1'b0,1'b1,1'b0,1'b1,1'b0,1'b0,1'b0,1'b1,2'b10};
    if(LARGE_CONCAT === CURRENT_CONCAT)
        $display("successful!");
    else begin
        $display("unsuccessful...");
        $display("Expected %x - Real %x", CURRENT_CONCAT, LARGE_CONCAT);
    end
    
    $display("");
end
endtask


task testLd;
begin
    $display("*Testing Load");

    opcode = 5'b01010;
    bit16 = 1'bx;
    #1;
    $write("\tTesting LD is ");
    
    CURRENT_CONCAT = {2'b10,1'b0,4'bx,3'b001,2'b10,1'b1,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1,2'b00};
    if(LARGE_CONCAT === CURRENT_CONCAT)
        $display("successful!");
    else begin
        $display("unsuccessful...");
        $display("Expected %x - Real %x", CURRENT_CONCAT, LARGE_CONCAT);
    end
    
    $display("");
end
endtask


task testLdi;
begin
    $display("*Testing Load Immediate");

    opcode = 5'b01011;
    bit16 = 1'bx;
    #1;
    $write("\tTesting LDI is ");
     
    CURRENT_CONCAT = {2'b10,1'b0,4'bx,3'b001,2'b10,1'b1,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1,2'b00};
    if(LARGE_CONCAT === CURRENT_CONCAT)
        $display("successful!");
    else begin
        $display("unsuccessful...");
        $display("Expected %x - Real %x", CURRENT_CONCAT, LARGE_CONCAT);
    end
    
    $display("");
end
endtask


task testLdx;
begin
    $display("*Testing Load Index");

    opcode = 5'b01100;
    bit16 = 1'bx;
    #1;
    $write("\tTesting LDX is ");
    
    CURRENT_CONCAT = {2'b01,1'b0,4'bx,3'b001,2'b00,1'b1,1'b0,1'b0,1'b0,1'b1,1'b0,1'b0,1'b1,1'b1,2'b00};
    if(LARGE_CONCAT === CURRENT_CONCAT)
        $display("successful!");
    else begin
        $display("unsuccessful...");
        $display("Expected %x - Real %x", CURRENT_CONCAT, LARGE_CONCAT);
    end
    
    $display("");
end
endtask


task testSt;
begin
    $display("*Testing Store");

    opcode = 5'b01101;
    bit16 = 1'bx;
    #1;
    $write("\tTesting ST is ");
    
    CURRENT_CONCAT = {2'b10,1'b1,4'bx,3'b001,2'b10,1'b1,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1,1'b1,1'b0,2'bx};
    if(LARGE_CONCAT === CURRENT_CONCAT)
        $display("successful!");
    else begin
        $display("unsuccessful...");
        $display("Expected %x - Real %x", CURRENT_CONCAT, LARGE_CONCAT);
    end
    
    $display("");
end
endtask


task testStx;
begin
    $display("*Testing Store Index");

    opcode = 5'b01110;
    bit16 = 1'bx;
    #1;
    $write("\tTesting STX is ");
    
    CURRENT_CONCAT = {2'b01,1'b1,4'bx,3'b001,2'b00,1'b1,1'b0,1'b0,1'b0,1'b1,1'b1,1'b1,1'b1,1'b0,2'bx};
    if(LARGE_CONCAT === CURRENT_CONCAT)
        $display("successful!");
    else begin
        $display("unsuccessful...");
        $display("Expected %x - Real %x", CURRENT_CONCAT, LARGE_CONCAT);
    end
    
    $display("");
end
endtask


task testHlt;
begin
    $display("*Testing Halt");

    opcode = 5'b11111;
    bit16 = 1'bx;
    #1;
    $write("\tTesting HLT is ");
   
    CURRENT_CONCAT = {2'bx,1'bx,4'bx,3'b000,2'b00,1'bx,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,2'bx};
    if(LARGE_CONCAT === CURRENT_CONCAT)
        $display("successful!");
    else begin
        $display("unsuccessful...");
        $display("Expected %x - Real %x", CURRENT_CONCAT, LARGE_CONCAT);
    end
    
    $display("");
end
endtask
    
endmodule