`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/13/2016 04:35:02 PM
// Design Name: 
// Module Name: decoder_tb
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

module decoder_tb(

    );
    
    reg Clk;
    reg reset;
    reg rf_we;
    reg [4:0] WAddr;
    reg [31:0] WData;
    /*reg pipeline registers from fetch*/
    reg [`IC_WIDTH-1:0] iIC;
    reg [`PPCCB_WIDTH-1:0] iPPCCB;
    reg [`PC_WIDTH-1:0] iPC; 
    reg [`VALID_WIDTH-1:0] iValid;
    reg [`INST_WIDTH-1:0] iIR;
    /*reg to stall or flush*/
    reg stall;
    reg flush;
    /*wire pipeline registers to execute*/
        /*Fowarded from fetch*/
    wire [`IC_WIDTH-1:0] oIC;
    wire [`PPCCB_WIDTH-1:0] oPPCCB;
    wire [`PC_WIDTH-1:0] oPC; 
    wire [`VALID_WIDTH-1:0] oValid;
        /*Produced wires to execute*/
    wire [`RDSADDR_WIDTH-1:0] oRDS;
    wire [`RS1ADDR_WIDTH-1:0] oRS2;
    wire [`RS2ADDR_WIDTH-1:0] oRS1;
    wire [`OP1_WIDTH-1:0] oOP1;
    wire [`OP2_WIDTH-1:0] oOP2;
    wire [`IM_WIDTH-1:0] oIM;
    
    reg iR2Select;
    reg [1:0] iSignExtCtrl;
    
    
    DecodeStage ID(
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
        .oRS2(oRS2),
        .oRS1(oRS1),
        .oOP1(oOP1),
        .oOP2(oOP2),
        .oIM(oIM),
        .iR2Select(iR2Select),
        .iSignExtCtrl(iSignExtCtrl)
    );
    
    initial
    begin
        $display("**Testing Decoder Stage**");
        reset <=0;
        Clk <= 0;
        stall <= 0;
        flush <= 0;
        iIC <= 32'd7;
        iPPCCB <= 1;
        iPC <= 8;
        iValid <= 1;
        iR2Select <= 0;
        iSignExtCtrl <= 0;
        rf_we <= 0;
        #10
        
        WAddr <= 1;
        WData <= 1;
        rf_we <= 1;
        #10
        
        rf_we <= 0;
        #10
        
        WAddr <= 2;
        WData <= 2;
        rf_we <= 1;
        #10
        
        rf_we <= 0;
        #10   
        
        #10 testRegisterFlux;
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

task testAddReg;
begin
    $display("Testing ADD register");
    iIR = {`ADD,5'd0,5'd1,1'd0,5'd2,11'b0}; // instruction is ADD r0, r1, r2
    
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
        
     $display("");    
end
endtask


task testAddImm;
begin
    $display("Testing Add immediate");
    iIR = {`ADD,5'd0,5'd1,1'd1,16'h8000}; // instruction is ADD r0, r1, imm
    iSignExtCtrl = `EXT16;
    
    #10;
    $write("\t*Register 1 addr test is ");
    if(1 == oRS1)
        $display("successful");
    else
        $display("unsuccessful with value %x", oRS1);                                         
    
    $write("\t*Register dest addr test is ");
    if(0 == oRDS)
        $display("successful");
    else
        $display("unsuccessful");
    #10;
    
    $write("\t*Immediate test is ");
    if('hffff8000 == oIM)
       $display("successful");
    else
       $display("unsuccessful with %x", oIM);  

     $display("");

end
endtask


task testBxx;
begin
    $display("Testing Bxx");
    iIR = {`BXX,4'd0,23'h400000}; // instruction is ADD r0, r1, imm
    iSignExtCtrl = `EXT23;
    
    #10;
    $write("\t*Immediate test is ");
    if(32'hffc00000 == oIM)
      $display("successful");
    else
      $display("unsuccessful with %x", oIM); 
    #10;
    
     $display("");
end
endtask


task testJmp;
begin
    $display("Testing Jump");
    iIR = {`JMP,5'd0,5'd1,1'd0,16'h8000}; // instruction is ADD r0, r1, imm
    iSignExtCtrl = `EXT16;
    
    #10;
    $write("\t*Register 1 addr test is ");
    if(1 == oRS1)
      $display("successful");
    else
      $display("unsuccessful with value %x", oRS1); 
    
    $write("\t*Immediate test is ");
    if('hffff8000 == oIM)
      $display("successful");
    else
      $display("unsuccessful with %x", oIM);  
      
     $display("");
end
endtask


task testJmpAndLink;
begin
    $display("Testing Jump and Link");
    iIR = {`JMP,5'd0,5'd1,1'd1,16'h8000}; // instruction is ADD r0, r1, imm
    iSignExtCtrl = `EXT16;
    
    #10
    $write("\t*Register 1 addr test is ");
    if(1 == oRS1)
        $display("successful");
    else
        $display("unsuccessful with value %x", oRS1); 
    
    $write("\t*Immediate test is ");
    if('hffff8000 == oIM)
        $display("successful");
    else
        $display("unsuccessful with %x", oIM);   
    
    $write("\t*Register dest addr test is ");
    if(0 == oRDS)
        $display("successful");
    else
        $display("unsuccessful");   

     $display("");
end
endtask


task testLoad;
begin
    $display("Testing Load");
    iIR = {`LD,5'd0,22'h200000}; // instruction is ADD r0, r1, imm
    iSignExtCtrl = `EXT22;
    
    #10;
    $write("\t*Register dest addr test is ");
    if(0 == oRDS)
        $display("successful");
    else
        $display("unsuccessful");
    
    $write("\t*Testing 23bit sign extension ");
    if(oIM == 32'hffe00000)
        $display("successful!");
    else
        $display("unsuccessful...");
        
     $display("");
end
endtask


task testLoadIdx;
begin
    $display("Testing indexed Load");
    iIR = {`LDX,5'd0,5'd1,17'h10000}; // instruction is ADD r0, r1, imm
    iSignExtCtrl = `EXT17;
    
    #10;
    if(oRDS == 0)
        $display("\t*Register dest addr test: successful!");
    else
        $display("\t*Register dest addr test: unsuccessful!");
    
    if(oRS1 == 1)
        $display("\t*Register rs1 addr test: successful!");
    else
        $display("\t*Register rs1 addr test: unsuccessful!");
    
    if(oIM == 32'hffff0000)
        $display("\t*Immediate test: successful!");
    else 
        $display("\t*Immediate test: unsuccessful! Value: %x", oIM);
        
     $display("");
end
endtask


task testStore;
begin
    $display("Testing store");
    iIR = {`ST, 5'd2, 22'h3f8000};
    iSignExtCtrl = `EXT22;
    iR2Select = 1'b1;
    
    #10        //IMPORTANTE COLOCAR ESTE DELAY
    if(oRS2 == 2)
       $display("\t*Register rst(rs2) addr test: successful!");
    else
       $display("\t*Register rst(rs2) addr test: unsuccessful!");
       
    if(oIM == 32'hffff8000)
       $display("\t*Immediate test: successful!");
    else 
       $display("\t*Immediate test: unsuccessful! Value: %x", oIM);

     $display("");
end
endtask


task testStoreIdx;
begin
    $display("Testing index store");
    iIR = {`STX, 5'd0, 5'd1, 17'h1c000};
    iSignExtCtrl = `EXT17;
    iR2Select = 1'b1;
    #10        //IMPORTANTE COLOCAR ESTE DELAY
    
    if(oRS2 == 0)
       $display("\t*Register rst(rs2) addr test: successful!");
    else
       $display("\t*Register rst(rs2) addr test: unsuccessful!");
       
    if(oRS1 == 1)
       $display("\t*Register rs1 addr test: successful!");
    else
       $display("\t*Register rs1 addr test: unsuccessful!");
       
    if(oIM == 32'hffffc000)
       $display("\t*Immediate test: successful!");
    else 
       $display("\t*Immediate test: unsuccessful! Value: %x", oIM);

     $display("");
end
endtask

    always #5 Clk = ~Clk;

endmodule
