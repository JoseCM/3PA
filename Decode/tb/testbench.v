`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/08/2016 04:55:41 PM
// Design Name: 
// Module Name: testbench
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

`include "defines.v"
`include "pipelinedefs.v"

module testbench(

    );
    reg clk;
    reg reset;
    
    reg rf_we;
    reg [4:0] WAddr;
    reg [31:0] WData;    
        
    reg r2Sel;
    reg [1:0] sExtCtrl;
        
    reg [`IC_WIDTH-1:0] ID_IC;
    reg [`PPCCB_WIDTH-1:0] ID_PPCCB;
    reg [`PC_WIDTH-1:0] ID_PC;
    reg [`VALID_WIDTH-1:0] ID_Valid;
    reg [`INST_WIDTH-1:0] ID_IR;
        
    wire [`IC_WIDTH-1:0] EX_IC;
    wire [`PPCCB_WIDTH-1:0] EX_PPCCB;
    wire [`PC_WIDTH-1:0] EX_PC;
    wire [`VALID_WIDTH-1:0] EX_PCSource;
    wire [`RDSADDR_WIDTH-1:0] EX_Rdst;
    wire [`RS1ADDR_WIDTH-1:0] EX_Rs1;
    wire [`RS2ADDR_WIDTH-1:0] EX_Rs2;
    wire [`OP1_WIDTH-1:0] EX_OP1;
    wire [`OP2_WIDTH-1:0] EX_OP2;
    wire [`IM_WIDTH-1:0] EX_IMM;
        
    wire [`OP1_WIDTH-1:0] op1;
    wire [`OP2_WIDTH-1:0] op2;
    wire [`RS1ADDR_WIDTH-1:0] add1;
    wire [`RS2ADDR_WIDTH-1:0] add2;
    
    idStage uut(
        .clk(clk),
        .reset(reset),
        
        .iIR(ID_IR),
        .rf_we(rf_we),
        .WAddr(WAddr),
        .WData(WData),

        .woRdsAddr(EX_Rdst),
        .woRs1Addr(EX_Rs1),
        .woRs2Addr(EX_Rs2),
        .woOP1(EX_OP1),
        .woOP2(EX_OP2),
        .woIMM(EX_IMM),
        
        /* temp */
        .iR2Select(r2Sel),
        .iSignExtCtrl(sExtCtrl)
    );
      
      
    initial
    begin  
        clk = 1'b0;  
        reset = 1'b0;
        r2Sel = 0;
        rf_we = 0;
        #10
        
        WAddr = 1;
        WData = 1;
        rf_we = 1;
        #10
        
        rf_we = 0;
        #10
        
        WAddr = 2;
        WData = 2;
        rf_we = 1;
        #10
        
        rf_we = 0;
        #10        
        
        
        #10 testAddReg;
        #10 testAddImm;
        #10 testBxx;
        #10 testJmp;
        #10 testJmpAndLink;
        #10 testLoad;
        #10 testLoadIdx;
        #10 testStore;
        #10 testStoreIdx;
        
        #10 $finish;
    end    


task testAddReg;
begin
    $display("Testing ADD register");
    ID_IR = {`ADD,5'd0,5'd1,1'd0,5'd2,11'b0}; // instruction is ADD r0, r1, r2
    
    #0;        
    $write("\t*Register 1 addr and data test is ");
    if((1 == EX_Rs1) && (1 == EX_OP1))
        $display("successful");
    else
        $display("unsuccessful with value %x", EX_Rs1);                                         
    
    $write("\t*Register 2 addr and data test is ");
    if((2 == EX_Rs2) && (2 == EX_OP2))
        $display("successful");
    else
        $display("unsuccessful with value %x", EX_Rs2);  
    
    $write("\t*Register dest addr test is ");
    if(0 == EX_Rdst)
        $display("successful");
    else
        $display("unsuccessful");
        
     $display("");    
end
endtask

task testAddImm;
begin
    $display("Testing Add immediate");
    ID_IR = {`ADD,5'd0,5'd1,1'd1,16'h8000}; // instruction is ADD r0, r1, imm
    sExtCtrl = `EXT16;
    
    #0;
    $write("\t*Register 1 addr and data test is ");
    if((1 == EX_Rs1) && (1 == EX_OP1))
        $display("successful");
    else
        $display("unsuccessful with value %x", EX_Rs1);                                         
    
    $write("\t*Register dest addr test is ");
    if(0 == EX_Rdst)
        $display("successful");
    else
        $display("unsuccessful");
    #10;
    
    $write("\t*Immediate test is ");
    if('hffff8000 == EX_IMM)
       $display("successful");
    else
       $display("unsuccessful with %x", EX_IMM);  

     $display("");

end
endtask

task testBxx;
begin
    $display("Testing Bxx");
    ID_IR = {`BXX,4'd0,23'h400000}; // instruction is ADD r0, r1, imm
    sExtCtrl = `EXT23;
    
    #0;
    $write("\t*Immediate test is ");
    if(32'hffc00000 == EX_IMM)
      $display("successful");
    else
      $display("unsuccessful with %x", EX_IMM); 
    #10;
    
     $display("");
end
endtask

task testJmp;
begin
    $display("Testing Jump");
    ID_IR = {`JMP,5'd0,5'd1,1'd0,16'h8000}; // instruction is ADD r0, r1, imm
    sExtCtrl = `EXT16;
    
    #0;
    $write("\t*Register 1 addr and data test is ");
    if((1 == EX_Rs1) && (1 == EX_OP1))
      $display("successful");
    else
      $display("unsuccessful with value %x", EX_Rs1); 
    
    $write("\t*Immediate test is ");
    if('hffff8000 == EX_IMM)
      $display("successful");
    else
      $display("unsuccessful with %x", EX_IMM);  
      
     $display("");
end
endtask

task testJmpAndLink;
begin
    $display("Testing Jump and Link");
    ID_IR <= {`JMP,5'd0,5'd1,1'd1,16'h8000}; // instruction is ADD r0, r1, imm
    sExtCtrl <= `EXT16;
    
    #0;
    $write("\t*Register 1 addr and data test is ");
    if((1 == EX_Rs1) && (1 == EX_OP1))
        $display("successful");
    else
        $display("unsuccessful with value %x", EX_Rs1); 
    
    $write("\t*Immediate test is ");
    if('hffff8000 == EX_IMM)
        $display("successful");
    else
        $display("unsuccessful with %x", EX_IMM);   
    
    $write("\t*Register dest addr test is ");
    if(0 == EX_Rdst)
        $display("successful");
    else
        $display("unsuccessful");   

     $display("");
end
endtask

task testLoad;
begin
    $display("Testing Load");
    ID_IR = {`LD,5'd0,23'h200000}; // instruction is ADD r0, r1, imm
    sExtCtrl = `EXT22;
    
    #0;
    $write("\t*Register dest addr test is ");
    if(0 == EX_Rdst)
        $display("successful");
    else
        $display("unsuccessful");
    
    $write("\t*Testing 23bit sign extension ");
    if(EX_IMM == 32'hffe00000)
        $display("successful!");
    else
        $display("unsuccessful...");
        
     $display("");
end
endtask

task testLoadIdx;
begin
    $display("Testing indexed Load");
    ID_IR = {`LDX,5'd0,5'd1,17'h10000}; // instruction is ADD r0, r1, imm
    sExtCtrl = `EXT17;
    
    #0;
    if(EX_Rdst == 0)
        $display("\t*Register dest addr test: successful!");
    else
        $display("\t*Register dest addr test: unsuccessful!");
    
    if((1 == EX_Rs1) && (1 == EX_OP1))
        $display("\t*Register rs1 addr and data test: successful!");
    else
        $display("\t*Register rs1 addr and data test: unsuccessful!");
    
    if(EX_IMM == 32'hffff0000)
        $display("\t*Immediate test: successful!");
    else 
        $display("\t*Immediate test: unsuccessful! Value: %x", EX_IMM);
        
     $display("");

end
endtask

task testStore;
begin
    $display("Testing store");
    ID_IR = {`ST, 5'd2, 22'h3f8000};
    sExtCtrl = `EXT22;
    r2Sel = 1'b1;
    #0        //IMPORTANTE COLOCAR ESTE DELAY
    
    if((2 == EX_Rs2) && (2 == EX_OP2))
       $display("\t*Register rst(rs2) addr test: successful!");
    else
       $display("\t*Register rst(rs2) addr test: unsuccessful!");
       
    if(EX_IMM == 32'hffff8000)
       $display("\t*Immediate test: successful!");
    else 
       $display("\t*Immediate test: unsuccessful! Value: %x", EX_IMM);

     $display("");

end
endtask

task testStoreIdx;
begin
    $display("Testing index store");
    ID_IR = {`STX, 5'd0, 5'd1, 17'h1c000};
    sExtCtrl = `EXT17;
    r2Sel = 1'b1;
    #0        //IMPORTANTE COLOCAR ESTE DELAY
    
    if(EX_Rs2 == 0)
       $display("\t*Register rst(rs2) addr test: successful!");
    else
       $display("\t*Register rst(rs2) addr test: unsuccessful!");
       
    if((1 == EX_Rs1) && (1 == EX_OP1))
       $display("\t*Register rs1 addr and data test: successful!");
    else
       $display("\t*Register rs1 addr test: unsuccessful!");
       
    if(EX_IMM == 32'hffffc000)
       $display("\t*Immediate test: successful!");
    else 
       $display("\t*Immediate test: unsuccessful! Value: %x", EX_IMM);

     $display("");

end
endtask

    always #5 clk = ~clk;
    
endmodule
