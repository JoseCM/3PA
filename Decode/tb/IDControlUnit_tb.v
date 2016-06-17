`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/16/2016 11:03:09 PM
// Design Name: 
// Module Name: IDControlUnit_tb
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
`include "defines.vh"

module IDControlUnit_tb(

    );
    
    reg Clk;
    reg reset;
    reg rf_we;
    reg [4:0] WAddr;
    reg [31:0] WData;
    reg [`IC_WIDTH-1:0] iIC;
    reg [`PPCCB_WIDTH-1:0] iPPCCB;
    reg [`PC_WIDTH-1:0] iPC; 
    reg [`VALID_WIDTH-1:0] iValid;
    reg [`INST_WIDTH-1:0] iIR;
    reg stall;
    reg flush;
    
    wire [`IC_WIDTH-1:0] oIC;
    wire [`PPCCB_WIDTH-1:0] oPPCCB;
    wire [`PC_WIDTH-1:0] oPC; 
    wire [`VALID_WIDTH-1:0] oValid;
    wire [`RDSADDR_WIDTH-1:0] oRDS;
    wire [`RS1ADDR_WIDTH-1:0] oRS1;
    wire [`RS2ADDR_WIDTH-1:0] oRS2;
    wire [`OP1_WIDTH-1:0] oOP1;
    wire [`OP2_WIDTH-1:0] oOP2;
    wire [`IM_WIDTH-1:0] oIM;
    wire [`EX_WIDTH-1:0] oEX;     
    wire [`MA_WIDTH-1:0] oMA;
    wire [`WB_WIDTH-1:0] oWB;
    
    
    IDControlUnit IDControl(
    .Clk(Clk),
    .reset(reset),
    .rf_we(rf_we),
    .WAddr(WAddr),
    .WData(WData),
    .iIC(iIC),
    .iPPCCB(iPPCCB),
    .iPC(iPC), 
    .iValid(iValid),
    .iIR(iIR),
    .stall(stall),
    .flush(flush),
    .oIC(oIC),
    .oPPCCB(oPPCCB),
    .oPC(oPC), 
    .oValid(oValid),
    .oRDS(oRDS),
    .oRS1(oRS1),
    .oRS2(oRS2),
    .oOP1(oOP1),
    .oOP2(oOP2),
    .oIM(oIM),
    .oWB(oWB),
    .oMA(oMA),
    .oEX(oEX)
    );
    
    
    initial
    begin
        $display("**Testing Decoder Stage**");
        reset <= 0;
        Clk <= 0;
        stall <= 0;
        flush <= 0;
        iIC <= 32'd7;
        iPPCCB <= 1;
        iPC <= 8;
        iValid <= 1;
        rf_we <= 0;
        #10
        
        //Write 1 to register 1
        WAddr <= 1;
        WData <= 1;
        rf_we <= 1;
        #10
        
        /* pause for a bit */
        rf_we <= 0;
        #10
        
        //Write 2 to register 2
        WAddr <= 2;
        WData <= 2;
        rf_we <= 1;
        #10
        
        /* pause for a bit */
        rf_we <= 0;
        #10
        
        #10 testRegisterFlux;
        #10 testNop;
        #10 testAddReg;
        #10 testSubReg;
        #10 testOrReg;
        #10 testAndReg;
        #10 testXorReg;
        #10 testCmpReg;
        #10 testAddImm;
        #10 testSubImm;
        #10 testOrImm;
        #10 testAndImm;
        #10 testXorImm;
        #10 testCmpImm;
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
 
    
task testRegisterFlux;
begin
    $write("\t*Instruction Counter test is ");
    if(oIC == 7)
        $display("successful");
    else
        $display("unsuccessful");
         
         
    $write("\t*PPCCB test is ");
    if(oPPCCB == 1)
        $display("successful");
    else
    $display("unsuccessful");
    
    
    $write("\t*Program Counter test is ");
    if(oPC == 8)
        $display("successful");
    else
        $display("unsuccessful");
        
    
    $write("\t*Valid Bit test is ");
    if(oValid == 1)
        $display("successful");
    else
        $display("unsuccessful");
    
    $display("");
end
endtask



task testNop;
begin
    $display("Testing NOP");
    iIR = {`NOP,27'b0};
    
    #10;        
    $write("\t*WB control bits test is ");
    if({/*R_WE*/1'b0,/*RDst_S[2]*/2'b0} === oWB)
        $display("successful");
    else
        $display("unsuccessful with %x", oWB);
      
        
    $write("\t*MA control bits test is ");
    if({/*M_RW*/1'b0,/*M_EN*/1'b0} === oMA)
        $display("successful");
    else
        $display("unsuccessful with %x", oMA);
       
        
    $write("\t*EX control bits test is ");
    if({/*CC*/4'bx,/*ALU_CTRL*/3'b000,/*ALU_SRC1[2]*/2'bx,/*ALU_SRC2*/1'bx,/*CC_WE*/1'b0,
        /*JMP*/1'b0,/*BR*/1'b0,/*Need_RS1*/1'bx,/*Need_RS2*/1'bx} === oEX)
        $display("successful");
    else
        $display("unsuccessful with %x", oEX);
        

    $display("");    
end
endtask



task testAddReg;
begin
    $display("Testing ADD register");
    iIR = {`ADD,5'd0,5'd1,1'd0,5'd2,11'b0};
    
    #10;        
    $write("\t*Register 1 addr and data test is ");
    if((1 == oRS1) && (1 == oOP1))
        $display("successful");
    else
        $display("unsuccessful with value %x", oRS1);                                         
    
    
    $write("\t*Register 2 addr and data test is ");
    if((2 == oRS2) && (2 == oOP2))
        $display("successful");
    else
        $display("unsuccessful with value %x", oRS2);  
    
    
    $write("\t*Register dest addr test is ");
    if(0 == oRDS)
        $display("successful");
    else
        $display("unsuccessful");
    
    
    $write("\t*WB control bits test is ");
    if({/*R_WE*/1'b1,/*RDst_S[2]*/2'b01} === oWB)
        $display("successful");
    else
        $display("unsuccessful with %x", oWB);
      
        
    $write("\t*MA control bits test is ");
    if({/*M_RW*/1'b0,/*M_EN*/1'b0} === oMA)
        $display("successful");
    else
        $display("unsuccessful with %x", oMA);
       
        
    $write("\t*EX control bits test is ");
    if({/*CC*/4'bx,/*ALU_CTRL*/3'b001,/*ALU_SRC1[2]*/2'b00,/*ALU_SRC2*/1'b0,/*CC_WE*/1'b1,
        /*JMP*/1'b0,/*BR*/1'b0,/*Need_RS1*/1'b1,/*Need_RS2*/1'b1} === oEX)
        $display("successful");
    else
        $display("unsuccessful with %x", oEX);
        

    $display("");    
end
endtask



task testSubReg;
begin
    $display("Testing SUB register");
    iIR = {`SUB,5'd0,5'd1,1'd0,5'd2,11'b0};
    
    #10;        
    $write("\t*Register 1 addr and data test is ");
    if((1 == oRS1) && (1 == oOP1))
        $display("successful");
    else
        $display("unsuccessful with value %x", oRS1);                                         
    
    
    $write("\t*Register 2 addr and data test is ");
    if((2 == oRS2) && (2 == oOP2))
        $display("successful");
    else
        $display("unsuccessful with value %x", oRS2);  
    
    
    $write("\t*Register dest addr test is ");
    if(0 == oRDS)
        $display("successful");
    else
        $display("unsuccessful");
    
    
    $write("\t*WB control bits test is ");
    if({/*R_WE*/1'b1,/*RDst_S[2]*/2'b01} === oWB)
        $display("successful");
    else
        $display("unsuccessful with %x", oWB);
      
        
    $write("\t*MA control bits test is ");
    if({/*M_RW*/1'b0,/*M_EN*/1'b0} === oMA)
        $display("successful");
    else
        $display("unsuccessful with %x", oMA);
       
        
    $write("\t*EX control bits test is ");
    if({/*CC*/4'bx,/*ALU_CTRL*/3'b010,/*ALU_SRC1[2]*/2'b0,/*ALU_SRC2*/1'b0,/*CC_WE*/1'b1,
        /*JMP*/1'b0,/*BR*/1'b0,/*Need_RS1*/1'b1,/*Need_RS2*/1'b1} === oEX)
        $display("successful");
    else
        $display("unsuccessful with %x", oEX);
        

    $display("");    
end
endtask



task testOrReg;
begin
    $display("Testing OR register");
    iIR = {`OR,5'd0,5'd1,1'd0,5'd2,11'b0};
    
    #10;        
    $write("\t*Register 1 addr and data test is ");
    if((1 == oRS1) && (1 == oOP1))
        $display("successful");
    else
        $display("unsuccessful with value %x", oRS1);                                         
    
    
    $write("\t*Register 2 addr and data test is ");
    if((2 == oRS2) && (2 == oOP2))
        $display("successful");
    else
        $display("unsuccessful with value %x", oRS2);  
    
    
    $write("\t*Register dest addr test is ");
    if(0 == oRDS)
        $display("successful");
    else
        $display("unsuccessful");
    
    
    $write("\t*WB control bits test is ");
    if({/*R_WE*/1'b1,/*RDst_S[2]*/2'b01} === oWB)
        $display("successful");
    else
        $display("unsuccessful with %x", oWB);
      
        
    $write("\t*MA control bits test is ");
    if({/*M_RW*/1'b0,/*M_EN*/1'b0} === oMA)
        $display("successful");
    else
        $display("unsuccessful with %x", oMA);
       
        
    $write("\t*EX control bits test is ");
    if({/*CC*/4'bx,/*ALU_CTRL*/3'b011,/*ALU_SRC1[2]*/2'b0,/*ALU_SRC2*/1'b0,/*CC_WE*/1'b0,
        /*JMP*/1'b0,/*BR*/1'b0,/*Need_RS1*/1'b1,/*Need_RS2*/1'b1} === oEX)
        $display("successful");
    else
        $display("unsuccessful with %x", oEX);
        

    $display("");    
end
endtask



task testAndReg;
begin
    $display("Testing AND register");
    iIR = {`AND,5'd0,5'd1,1'd0,5'd2,11'b0};
    
    #10;        
    $write("\t*Register 1 addr and data test is ");
    if((1 == oRS1) && (1 == oOP1))
        $display("successful");
    else
        $display("unsuccessful with value %x", oRS1);                                         
    
    
    $write("\t**Register 2 addr and data test is ");
    if((2 == oRS2) && (2 == oOP2))
        $display("successful");
    else
        $display("unsuccessful with value %x", oRS2);  
    
    
    $write("\t*Register dest addr test is ");
    if(0 == oRDS)
        $display("successful");
    else
        $display("unsuccessful");
    
    
    $write("\t*WB control bits test is ");
    if({/*R_WE*/1'b1,/*RDst_S[2]*/2'b01} === oWB)
        $display("successful");
    else
        $display("unsuccessful with %x", oWB);
      
        
    $write("\t*MA control bits test is ");
    if({/*M_RW*/1'b0,/*M_EN*/1'b0} === oMA)
        $display("successful");
    else
        $display("unsuccessful with %x", oMA);
       
        
    $write("\t*EX control bits test is ");
    if({/*CC*/4'bx,/*ALU_CTRL*/3'b100,/*ALU_SRC1[2]*/2'b0,/*ALU_SRC2*/1'b0,/*CC_WE*/1'b0,
        /*JMP*/1'b0,/*BR*/1'b0,/*Need_RS1*/1'b1,/*Need_RS2*/1'b1} === oEX)
        $display("successful");
    else
        $display("unsuccessful with %x", oEX);
        

    $display("");    
end
endtask



task testXorReg;
begin
    $display("Testing XOR register");
    iIR = {`XOR,5'd0,5'd1,1'd0,5'd2,11'b0}; // instruction is ADD r0, r1, r2
    
    #10;        
    $write("\t*Register 1 addr and data test is ");
    if((1 == oRS1) && (1 == oOP1))
        $display("successful");
    else
        $display("unsuccessful with value %x", oRS1); 
        
        
    $write("\t*Register 2 addr and data test is ");
    if((2 == oRS2) && (2 == oOP2))
        $display("successful");
    else
        $display("unsuccessful with value %x", oRS2);                                         
    
    
    $write("\t*Register dest addr test is ");
    if(0 == oRDS)
        $display("successful");
    else
        $display("unsuccessful");
    
    
    $write("\t*WB control bits test is ");
    if({/*R_WE*/1'b1,/*RDst_S[2]*/2'b01} === oWB)
        $display("successful");
    else
        $display("unsuccessful with %x", oWB);
      
        
    $write("\t*MA control bits test is ");
    if({/*M_RW*/1'b0,/*M_EN*/1'b0} === oMA)
        $display("successful");
    else
        $display("unsuccessful with %x", oMA);
       
        
    $write("\t*EX control bits test is ");
    if({/*CC*/4'bx,/*ALU_CTRL*/3'b110,/*ALU_SRC1[2]*/2'b0,/*ALU_SRC2*/1'b0,/*CC_WE*/1'b0,
        /*JMP*/1'b0,/*BR*/1'b0,/*Need_RS1*/1'b1,/*Need_RS2*/1'b1} === oEX)
        $display("successful");
    else
        $display("unsuccessful with %x", oEX);
        

    $display("");    
end
endtask



task testCmpReg;
begin
    $display("Testing CMP register");
    iIR = {`CMP,5'd0,5'd1,1'd0,5'd2,11'b0}; // instruction is ADD r0, r1, r2
    
    #10;        
    $write("\t*Register 1 addr and data test is ");
    if((1 == oRS1) && (1 == oOP1))
        $display("successful");
    else
        $display("unsuccessful with value %x", oRS1); 
        
        
    $write("\t*Register 2 addr and data test is ");
    if((2 == oRS2) && (2 == oOP2))
        $display("successful");
    else
        $display("unsuccessful with value %x", oRS2);                                         
    
    
    $write("\t*WB control bits test is ");
    if({/*R_WE*/1'b1,/*RDst_S[2]*/2'b01} === oWB)
        $display("successful");
    else
        $display("unsuccessful with %x", oWB);
      
        
    $write("\t*MA control bits test is ");
    if({/*M_RW*/1'b0,/*M_EN*/1'b0} === oMA)
        $display("successful");
    else
        $display("unsuccessful with %x", oMA);
       
        
    $write("\t*EX control bits test is ");
    if({/*CC*/4'bx,/*ALU_CTRL*/3'b111,/*ALU_SRC1[2]*/2'b0,/*ALU_SRC2*/1'b0,/*CC_WE*/1'b1,
        /*JMP*/1'b0,/*BR*/1'b0,/*Need_RS1*/1'b1,/*Need_RS2*/1'b1} === oEX)
        $display("successful");
    else
        $display("unsuccessful with %x", oEX);
        

    $display("");    
end
endtask



task testAddImm;
begin
    $display("Testing Add immediate");
    iIR = {`ADD,5'd0,5'd1,1'd1,16'h8000}; // instruction is ADD r0, r1, imm
    
    #10;
    $write("\t*Register 1 addr and data test is ");
    if((1 == oRS1) && (1 == oOP1))
        $display("successful");
    else
        $display("unsuccessful with value %x", oRS1);                                         
    
    
    $write("\t*Register dest addr test is ");
    if(0 == oRDS)
        $display("successful");
    else
        $display("unsuccessful");
    
    
    $write("\t*Immediate test is ");
    if(32'hffff8000 == oIM)
       $display("successful");
    else
       $display("unsuccessful with %x", oIM);  


    $write("\t*WB control bits test is ");
    if({/*R_WE*/1'b1,/*RDst_S[2]*/2'b01} === oWB)
        $display("successful");
    else
        $display("unsuccessful with %x", oWB);
      
        
    $write("\t*MA control bits test is ");
    if({/*M_RW*/1'b0,/*M_EN*/1'b0} === oMA)
        $display("successful");
    else
        $display("unsuccessful with %x", oMA);
       
        
    $write("\t*EX control bits test is ");
    if({/*CC*/4'bx,/*ALU_CTRL*/3'b001,/*ALU_SRC1[2]*/2'b00,/*ALU_SRC2*/1'b1,/*CC_WE*/1'b1,
        /*JMP*/1'b0,/*BR*/1'b0,/*Need_RS1*/1'b1,/*Need_RS2*/1'b0} === oEX)
        $display("successful");
    else
        $display("unsuccessful with %x", oEX);
    
    $display("");

end
endtask



task testSubImm;
begin
    $display("Testing SUB immediate");
    iIR = {`SUB,5'd0,5'd1,1'd1,16'h8000}; // instruction is ADD r0, r1, imm
    
    #10;
    $write("\t*Register 1 addr and data test is ");
    if((1 == oRS1) && (1 == oOP1))
        $display("successful");
    else
        $display("unsuccessful with value %x", oRS1);                                        
    
    
    $write("\t*Register dest addr test is ");
    if(0 == oRDS)
        $display("successful");
    else
        $display("unsuccessful");
    
    
    $write("\t*Immediate test is ");
    if(32'hffff8000 == oIM)
       $display("successful");
    else
       $display("unsuccessful with %x", oIM);  


    $write("\t*WB control bits test is ");
    if({/*R_WE*/1'b1,/*RDst_S[2]*/2'b01} === oWB)
        $display("successful");
    else
        $display("unsuccessful with %x", oWB);
      
        
    $write("\t*MA control bits test is ");
    if({/*M_RW*/1'b0,/*M_EN*/1'b0} === oMA)
        $display("successful");
    else
        $display("unsuccessful with %x", oMA);
       
        
    $write("\t*EX control bits test is ");
    if({/*CC*/4'bx,/*ALU_CTRL*/3'b010,/*ALU_SRC1[2]*/2'b00,/*ALU_SRC2*/1'b1,/*CC_WE*/1'b1,
        /*JMP*/1'b0,/*BR*/1'b0,/*Need_RS1*/1'b1,/*Need_RS2*/1'b0} === oEX)
        $display("successful");
    else
        $display("unsuccessful with %x", oEX);
    
    $display("");

end
endtask



task testOrImm;
begin
    $display("Testing OR immediate");
    iIR = {`OR,5'd0,5'd1,1'd1,16'h8000}; // instruction is ADD r0, r1, imm
    
    #10;
    $write("\t*Register 1 addr and data test is ");
    if((1 == oRS1) && (1 == oOP1))
        $display("successful");
    else
        $display("unsuccessful with value %x", oRS1);                                        
    
    
    $write("\t*Register dest addr test is ");
    if(0 == oRDS)
        $display("successful");
    else
        $display("unsuccessful");
    
    
    $write("\t*Immediate test is ");
    if(32'hffff8000 == oIM)
       $display("successful");
    else
       $display("unsuccessful with %x", oIM);  


    $write("\t*WB control bits test is ");
    if({/*R_WE*/1'b1,/*RDst_S[2]*/2'b01} === oWB)
        $display("successful");
    else
        $display("unsuccessful with %x", oWB);
      
        
    $write("\t*MA control bits test is ");
    if({/*M_RW*/1'b0,/*M_EN*/1'b0} === oMA)
        $display("successful");
    else
        $display("unsuccessful with %x", oMA);
       
        
    $write("\t*EX control bits test is ");
    if({/*CC*/4'bx,/*ALU_CTRL*/3'b011,/*ALU_SRC1[2]*/2'b00,/*ALU_SRC2*/1'b1,/*CC_WE*/1'b0,
        /*JMP*/1'b0,/*BR*/1'b0,/*Need_RS1*/1'b1,/*Need_RS2*/1'b0} === oEX)
        $display("successful");
    else
        $display("unsuccessful with %x", oEX);
    
    $display("");

end
endtask



task testAndImm;
begin
    $display("Testing AND immediate");
    iIR = {`AND,5'd0,5'd1,1'd1,16'h8000}; // instruction is ADD r0, r1, imm
    
    #10;
    $write("\t*Register 1 addr and data test is ");
    if((1 == oRS1) && (1 == oOP1))
        $display("successful");
    else
        $display("unsuccessful with value %x", oRS1);                                        
    
    
    $write("\t*Register dest addr test is ");
    if(0 == oRDS)
        $display("successful");
    else
        $display("unsuccessful");
    
    
    $write("\t*Immediate test is ");
    if(32'hffff8000 == oIM)
       $display("successful");
    else
       $display("unsuccessful with %x", oIM);  


    $write("\t*WB control bits test is ");
    if({/*R_WE*/1'b1,/*RDst_S[2]*/2'b01} === oWB)
        $display("successful");
    else
        $display("unsuccessful with %x", oWB);
      
        
    $write("\t*MA control bits test is ");
    if({/*M_RW*/1'b0,/*M_EN*/1'b0} === oMA)
        $display("successful");
    else
        $display("unsuccessful with %x", oMA);
       
        
    $write("\t*EX control bits test is ");
    if({/*CC*/4'bx,/*ALU_CTRL*/3'b100,/*ALU_SRC1[2]*/2'b00,/*ALU_SRC2*/1'b1,/*CC_WE*/1'b0,
        /*JMP*/1'b0,/*BR*/1'b0,/*Need_RS1*/1'b1,/*Need_RS2*/1'b0} === oEX)
        $display("successful");
    else
        $display("unsuccessful with %x", oEX);
    
    $display("");

end
endtask



task testXorImm;
begin
    $display("Testing XOR immediate");
    iIR = {`XOR,5'd0,5'd1,1'd1,16'h8000}; // instruction is ADD r0, r1, imm
    
    #10;
    $write("\t*Register 1 addr and data test is ");
    if((1 == oRS1) && (1 == oOP1))
        $display("successful");
    else
        $display("unsuccessful with value %x", oRS1);                                        
    
    
    $write("\t*Register dest addr test is ");
    if(0 == oRDS)
        $display("successful");
    else
        $display("unsuccessful");
    
    
    $write("\t*Immediate test is ");
    if(32'hffff8000 == oIM)
       $display("successful");
    else
       $display("unsuccessful with %x", oIM);  


    $write("\t*WB control bits test is ");
    if({/*R_WE*/1'b1,/*RDst_S[2]*/2'b01} === oWB)
        $display("successful");
    else
        $display("unsuccessful with %x", oWB);
      
        
    $write("\t*MA control bits test is ");
    if({/*M_RW*/1'b0,/*M_EN*/1'b0} === oMA)
        $display("successful");
    else
        $display("unsuccessful with %x", oMA);
       
        
    $write("\t*EX control bits test is ");
    if({/*CC*/4'bx,/*ALU_CTRL*/3'b110,/*ALU_SRC1[2]*/2'b00,/*ALU_SRC2*/1'b1,/*CC_WE*/1'b0,
        /*JMP*/1'b0,/*BR*/1'b0,/*Need_RS1*/1'b1,/*Need_RS2*/1'b0} === oEX)
        $display("successful");
    else
        $display("unsuccessful with %x", oEX);
    
    $display("");

end
endtask



task testCmpImm;
begin
    $display("Testing CMP immediate");
    iIR = {`CMP,5'd0,5'd1,1'd1,16'h8000}; // instruction is ADD r0, r1, imm
    
    #10;
    $write("\t*Register 1 addr and data test is ");
    if((1 == oRS1) && (1 == oOP1))
        $display("successful");
    else
        $display("unsuccessful with value %x", oRS1);                                         
    
    
    $write("\t*Immediate test is ");
    if(32'hffff8000 == oIM)
       $display("successful");
    else
       $display("unsuccessful with %x", oIM);  


    $write("\t*WB control bits test is ");
    if({/*R_WE*/1'b1,/*RDst_S[2]*/2'b01} === oWB)
        $display("successful");
    else
        $display("unsuccessful with %x", oWB);
      
        
    $write("\t*MA control bits test is ");
    if({/*M_RW*/1'b0,/*M_EN*/1'b0} === oMA)
        $display("successful");
    else
        $display("unsuccessful with %x", oMA);
       
        
    $write("\t*EX control bits test is ");
    if({/*CC*/4'bx,/*ALU_CTRL*/3'b111,/*ALU_SRC1[2]*/2'b00,/*ALU_SRC2*/1'b1,/*CC_WE*/1'b1,
        /*JMP*/1'b0,/*BR*/1'b0,/*Need_RS1*/1'b1,/*Need_RS2*/1'b0} === oEX)
        $display("successful");
    else
        $display("unsuccessful with %x", oEX);
    
    $display("");

end
endtask



task testBxx;
begin
    $display("Testing BXX");
    iIR = {`BXX,4'd0,23'h400000}; // instruction is ADD r0, r1, imm
    
    #10;                                             
    $write("\t*Immediate test is ");
    if(32'hffc00000 == oIM)
       $display("successful");
    else
       $display("unsuccessful with %x", oIM);  


    $write("\t*WB control bits test is ");
    if({/*R_WE*/1'b0,/*RDst_S[2]*/2'bx} === oWB)
        $display("successful");
    else
        $display("unsuccessful with %x", oWB);
      
        
    $write("\t*MA control bits test is ");
    if({/*M_RW*/1'b0,/*M_EN*/1'b0} === oMA)
        $display("successful");
    else
        $display("unsuccessful with %x", oMA);
       
        
    $write("\t*EX control bits test is ");
    if({/*CC*/4'b0,/*ALU_CTRL*/3'b001,/*ALU_SRC1[2]*/2'b01,/*ALU_SRC2*/1'b1,/*CC_WE*/1'b0,
        /*JMP*/1'b0,/*BR*/1'b1,/*Need_RS1*/1'b0,/*Need_RS2*/1'b0} === oEX)
        $display("successful");
    else
        $display("unsuccessful with %x", oEX);
    
    $display("");

end
endtask



task testNot;
begin
    $display("Testing NOT");
    iIR = {`NOT,5'd0,5'd1,1'd1,16'h8000}; // instruction is ADD r0, r1, imm
    
    #10;
    $write("\t*Register 1 addr and data test is ");
    if((1 == oRS1) && (1 == oOP1))
        $display("successful");
    else
        $display("unsuccessful with value %x", oRS1);                                         
    
    
    $write("\t*Register dest addr test is ");
    if(0 == oRDS)
        $display("successful");
    else
        $display("unsuccessful");


    $write("\t*WB control bits test is ");
    if({/*R_WE*/1'b1,/*RDst_S[2]*/2'b01} === oWB)
        $display("successful");
    else
        $display("unsuccessful with %x", oWB);
      
        
    $write("\t*MA control bits test is ");
    if({/*M_RW*/1'b0,/*M_EN*/1'b0} === oMA)
        $display("successful");
    else
        $display("unsuccessful with %x", oMA);
       
        
    $write("\t*EX control bits test is ");
    if({/*CC*/4'bx,/*ALU_CTRL*/3'b101,/*ALU_SRC1[2]*/2'b00,/*ALU_SRC2*/1'b0,/*CC_WE*/1'b0,
        /*JMP*/1'b0,/*BR*/1'b0,/*Need_RS1*/1'b1,/*Need_RS2*/1'b0} === oEX)
        $display("successful");
    else
        $display("unsuccessful with %x", oEX);
    
    $display("");

end
endtask



task testJmp;
begin
    $display("Testing JMP");
    iIR = {`JMP,5'd0,5'd1,1'd0,16'h8000};
    
    #10;        
    $write("\t*Register 1 addr and data test is ");
    if((1 == oRS1) && (1 == oOP1))
        $display("successful");
    else
        $display("unsuccessful with value %x", oRS1);                                        
    
    
    $write("\t*Immediate test is ");
    if(32'hffff8000 == oIM)
       $display("successful");
    else
       $display("unsuccessful with %x", oIM);     
    
    
    $write("\t*WB control bits test is ");
    if({/*R_WE*/1'b0,/*RDst_S[2]*/2'bx} === oWB)
        $display("successful");
    else
        $display("unsuccessful with %x", oWB);
      
        
    $write("\t*MA control bits test is ");
    if({/*M_RW*/1'b0,/*M_EN*/1'b0} === oMA)
        $display("successful");
    else
        $display("unsuccessful with %x", oMA);
       
        
    $write("\t*EX control bits test is ");
    if({/*CC*/4'bx,/*ALU_CTRL*/3'b001,/*ALU_SRC1[2]*/2'b00,/*ALU_SRC2*/1'b1,/*CC_WE*/1'b0,
        /*JMP*/1'b1,/*BR*/1'b0,/*Need_RS1*/1'b1,/*Need_RS2*/1'b0} === oEX)
        $display("successful");
    else
        $display("unsuccessful with %x", oEX);
        

    $display("");    
end
endtask



task testJmpLink;
begin
    $display("Testing JMPL");
    iIR = {`JMP,5'd0,5'd1,1'd1,16'h8000};
    
    #10;        
    $write("\t*Register 1 addr and data test is ");
    if((1 == oRS1) && (1 == oOP1))
        $display("successful");
    else
        $display("unsuccessful with value %x", oRS1);                                         
    
    
    $write("\t*Register dest addr test is ");
    if(0 == oRDS)
        $display("successful");
    else
        $display("unsuccessful");
            
    
    $write("\t*Immediate test is ");
    if(32'hffff8000 == oIM)
       $display("successful");
    else
       $display("unsuccessful with %x", oIM);     
    
    
    $write("\t*WB control bits test is ");
    if({/*R_WE*/1'b1,/*RDst_S[2]*/2'b10} === oWB)
        $display("successful");
    else
        $display("unsuccessful with %x", oWB);
      
        
    $write("\t*MA control bits test is ");
    if({/*M_RW*/1'b0,/*M_EN*/1'b0} === oMA)
        $display("successful");
    else
        $display("unsuccessful with %x", oMA);
       
        
    $write("\t*EX control bits test is ");
    if({/*CC*/4'bx,/*ALU_CTRL*/3'b001,/*ALU_SRC1[2]*/2'b00,/*ALU_SRC2*/1'b1,/*CC_WE*/1'b0,
        /*JMP*/1'b1,/*BR*/1'b0,/*Need_RS1*/1'b1,/*Need_RS2*/1'b0} === oEX)
        $display("successful");
    else
        $display("unsuccessful with %x", oEX);
        

    $display("");    
end
endtask



task testLd;
begin
    $display("Testing LD");
    iIR = {`LD, 5'd0, 22'h200000};
    
    #10;        
    $write("\t*Register dest addr test is ");
    if(0 == oRDS)
        $display("successful");
    else
        $display("unsuccessful");
            
    
    $write("\t*Immediate test is ");
    if(32'hffe00000 == oIM)
       $display("successful");
    else
       $display("unsuccessful with %x", oIM);     
    
    
    $write("\t*WB control bits test is ");
    if({/*R_WE*/1'b1,/*RDst_S[2]*/2'b00} === oWB)
        $display("successful");
    else
        $display("unsuccessful with %x", oWB);
      
        
    $write("\t*MA control bits test is ");
    if({/*M_RW*/1'b0,/*M_EN*/1'b1} === oMA)
        $display("successful");
    else
        $display("unsuccessful with %x", oMA);
       
        
    $write("\t*EX control bits test is ");
    if({/*CC*/4'bx,/*ALU_CTRL*/3'b001,/*ALU_SRC1[2]*/2'b10,/*ALU_SRC2*/1'b1,/*CC_WE*/1'b0,
        /*JMP*/1'b0,/*BR*/1'b0,/*Need_RS1*/1'b0,/*Need_RS2*/1'b0} === oEX)
        $display("successful");
    else
        $display("unsuccessful with %x", oEX);
        

    $display("");    
end
endtask



task testLdi;
begin
    $display("Testing LDI");
    iIR = {`LDI, 5'd0, 22'h200000};
    
    #10;        
    $write("\t*Register dest addr test is ");
    if(0 == oRDS)
        $display("successful");
    else
        $display("unsuccessful");
            
    
    $write("\t*Immediate test is ");
    if(32'hffe00000 == oIM)
       $display("successful");
    else
       $display("unsuccessful with %x", oIM);     
    
    
    $write("\t*WB control bits test is ");
    if({/*R_WE*/1'b1,/*RDst_S[2]*/2'b00} === oWB)
        $display("successful");
    else
        $display("unsuccessful with %x", oWB);
      
        
    $write("\t*MA control bits test is ");
    if({/*M_RW*/1'b0,/*M_EN*/1'b1} === oMA)
        $display("successful");
    else
        $display("unsuccessful with %x", oMA);
       
        
    $write("\t*EX control bits test is ");
    if({/*CC*/4'bx,/*ALU_CTRL*/3'b001,/*ALU_SRC1[2]*/2'b10,/*ALU_SRC2*/1'b1,/*CC_WE*/1'b0,
        /*JMP*/1'b0,/*BR*/1'b0,/*Need_RS1*/1'b0,/*Need_RS2*/1'b0} === oEX)
        $display("successful");
    else
        $display("unsuccessful with %x", oEX);
        

    $display("");    
end
endtask



task testLdx;
begin
    $display("Testing LDX");
    iIR = {`LDX,5'd0,5'd1,17'h10000};
    
    #10; 
    $write("\t*Register 1 addr and data test is ");
    if((1 == oRS1) && (1 == oOP1))
        $display("successful");
    else
        $display("unsuccessful with value %x", oRS1); 
        
               
    $write("\t*Register dest addr test is ");
    if(0 == oRDS)
        $display("successful");
    else
        $display("unsuccessful");
            
    
    $write("\t*Immediate test is ");
    if(32'hffff0000 == oIM)
       $display("successful");
    else
       $display("unsuccessful with %x", oIM);     
    
    
    $write("\t*WB control bits test is ");
    if({/*R_WE*/1'b1,/*RDst_S[2]*/2'b00} === oWB)
        $display("successful");
    else
        $display("unsuccessful with %x", oWB);
      
        
    $write("\t*MA control bits test is ");
    if({/*M_RW*/1'b0,/*M_EN*/1'b1} === oMA)
        $display("successful");
    else
        $display("unsuccessful with %x", oMA);
       
        
    $write("\t*EX control bits test is ");
    if({/*CC*/4'bx,/*ALU_CTRL*/3'b001,/*ALU_SRC1[2]*/2'b00,/*ALU_SRC2*/1'b1,/*CC_WE*/1'b0,
        /*JMP*/1'b0,/*BR*/1'b0,/*Need_RS1*/1'b1,/*Need_RS2*/1'b0} === oEX)
        $display("successful");
    else
        $display("unsuccessful with %x", oEX);
        

    $display("");    
end
endtask



task testSt;
begin
    $display("Testing ST");
    iIR = {`ST, 5'd2, 22'h3f8000};
    
    #10; 
    $write("\t*Register rst addr test is ");
    if(2 == oRS2)
        $display("successful");
    else
        $display("unsuccessful with value %x", oRS2); 
            
    
    $write("\t*Immediate test is ");
    if(32'hffff8000 == oIM)
       $display("successful");
    else
       $display("unsuccessful with %x", oIM);     
    
    
    $write("\t*WB control bits test is ");
    if({/*R_WE*/1'b0,/*RDst_S[2]*/2'bx} === oWB)
        $display("successful");
    else
        $display("unsuccessful with %x", oWB);
      
        
    $write("\t*MA control bits test is ");
    if({/*M_RW*/1'b1,/*M_EN*/1'b1} === oMA)
        $display("successful");
    else
        $display("unsuccessful with %x", oMA);
       
        
    $write("\t*EX control bits test is ");
    if({/*CC*/4'bx,/*ALU_CTRL*/3'b001,/*ALU_SRC1[2]*/2'b10,/*ALU_SRC2*/1'b1,/*CC_WE*/1'b0,
        /*JMP*/1'b0,/*BR*/1'b0,/*Need_RS1*/1'b0,/*Need_RS2*/1'b1} === oEX)
        $display("successful");
    else
        $display("unsuccessful with %x", oEX);
        

    $display("");    
end
endtask



task testStx;
begin
    $display("Testing STX");
    iIR = {`STX, 5'd0, 5'd1, 17'h1c000};
    
    #10; 
    $write("\t*Register 1 addr and data test is ");
    if((1 == oRS1) && (1 == oOP1))
        $display("successful");
    else
        $display("unsuccessful with value %x", oRS1);  
        
    
    $write("\t*Register rst addr test is ");
    if(0 == oRS2)
        $display("successful");
    else
        $display("unsuccessful with value %x", oRS2); 
            
    
    $write("\t*Immediate test is ");
    if(32'hffffc000 == oIM)
       $display("successful");
    else
       $display("unsuccessful with %x", oIM);     
    
    
    $write("\t*WB control bits test is ");
    if({/*R_WE*/1'b0,/*RDst_S[2]*/2'bx} === oWB)
        $display("successful");
    else
        $display("unsuccessful with %x", oWB);
      
        
    $write("\t*MA control bits test is ");
    if({/*M_RW*/1'b1,/*M_EN*/1'b1} === oMA)
        $display("successful");
    else
        $display("unsuccessful with %x", oMA);
       
        
    $write("\t*EX control bits test is ");
    if({/*CC*/4'bx,/*ALU_CTRL*/3'b001,/*ALU_SRC1[2]*/2'b00,/*ALU_SRC2*/1'b1,/*CC_WE*/1'b0,
        /*JMP*/1'b0,/*BR*/1'b0,/*Need_RS1*/1'b1,/*Need_RS2*/1'b1} === oEX)
        $display("successful");
    else
        $display("unsuccessful with %x", oEX);
        

    $display("");    
end
endtask



task testHlt;
begin
    $display("Testing Hlt");
    iIR = {`HLT, 27'b0};
    
    #10;        
    $write("\t*WB control bits test is ");
    if({/*R_WE*/1'b0,/*RDst_S[2]*/2'bx} === oWB)
        $display("successful");
    else
        $display("unsuccessful with %x", oWB);
      
        
    $write("\t*MA control bits test is ");
    if({/*M_RW*/1'b0,/*M_EN*/1'b0} === oMA)
        $display("successful");
    else
        $display("unsuccessful with %x", oMA);
       
        
    $write("\t*EX control bits test is ");
    if({/*CC*/4'bx,/*ALU_CTRL*/3'b000,/*ALU_SRC1[2]*/2'b0,/*ALU_SRC2*/1'bx,/*CC_WE*/1'b0,
        /*JMP*/1'b0,/*BR*/1'b0,/*Need_RS1*/1'b0,/*Need_RS2*/1'b0} === oEX)
        $display("successful");
    else
        $display("unsuccessful with %x", oEX);
        

    $display("");    
end
endtask

    always #5 Clk = ~Clk;
endmodule
