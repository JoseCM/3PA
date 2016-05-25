`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.05.2016 10:41:00
// Design Name: 
// Module Name: CacheIControl
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

/**
TODO: tb cache control
TODO: Stall logic
TODO: fill and store buffer outputs/inputs
*/
module CacheIControl(
    input Clk,
    input Rst,
    input En,
    input RW,
    output Stall,
    /*Cache*/
    input C_Dirty,
    input C_Miss,
    output reg WriteType,
    output W_Enable,
    output R_Enable,
    output reg Merge,
    /*LineWrite Buffer*/
    input LW_Completed,
    output reg LW_Enable,
    /*LineFill _Enable*/
    input LB_Completed,
    input LB_FirstWord,
    output reg LB_Enable,
    /*StoreBuffer*/
    output reg StoreBuff_Enable,
    output reg FromStoreBuffer,
    /**/
    output CrtWord
    );

    //write States
    parameter [2:0] IDLE = 0, WWORD_ON_CACHE = 1, START_AXI_RW = 2,
                    START_AXI_R = 3, MERGE_RESULTS = 4, WRITE_LB_ON_CACHE = 5;
                  
    //Read States                
    parameter [2:0] READ_MISS_DIRTY = 1, READ_MISS_NOT_DIRTY = 2,
                    WAIT_COMPLETION_DIRTY = 3, WAIT_COMPLETION_NON_DIRTY = 4, WRITE_CACHE = 5;
                                    
    reg [2:0] ReadState;
    reg [2:0] WriteState;
    reg RBusy;
    reg WBusy;
    reg LB_Occupied;
    reg LW_Occupied;
    reg WC_OEn; //Enable para permitir o acesso à cache com o processador num write
    reg RC_OEn; //Enable para permitir o acesso à cache com o processador num read
    reg RStall;
    reg WStall;
    reg ReadLineWrite;

    wire SameLine = 1'b0;
    
    //If Read/Write and Read/WriteState is Idle use Idle Values
    //Else use Write or Read State Machine Values.
    assign W_Enable = (En && WriteState == IDLE && RW && !Stall) & WC_OEn;
    
    assign R_Enable = (En && ((ReadState == IDLE) || (ReadState == WAIT_COMPLETION_DIRTY) || (ReadState == WAIT_COMPLETION_NON_DIRTY)) && !RW && !Stall) & RC_OEn;
    
    //assign WriteType = (WriteState == WRITE_LB_ON_CACHE || ReadState == WRITE_CACHE);
    
    /*assign Stall = (En && (WriteState == IDLE) && (C_Miss && RBusy) && RW)? 1'b1:
                    (En && (WriteState == WWORD_ON_CACHE) && RW)? 1'b1:
                    (En && (WriteState == START_AXI_RW) && RW)? 1'b1:
                    (En && (WriteState == START_AXI_R) && RW)? 1'b1:
                    (En && (WriteState == MERGE_RESULTS) && RW)? 1'b1:
                    (En && (WriteState == WRITE_LB_ON_CACHE) && RW)? 1'b1:
                    //(En && (WriteState == WWORD_ON_CACHE) && RW)? 1'b1:
                    //Stall in case of a write to cache when LBuffer tries to write on cache too
                    (En && (ReadState == IDLE) && (C_Miss && WBusy) && !RW)? 1'b1:
                    (En && (ReadState == READ_MISS_DIRTY) && !RW)? 1'b1:
                    (En && (ReadState == READ_MISS_NOT_DIRTY) && !RW)? 1'b1:
                    (En && (ReadState == WAIT_COMPLETION_DIRTY) && !RW)? 1'b1:
                    (En && (ReadState == WAIT_COMPLETION_NON_DIRTY) && !RW)? 1'b1:
                    (En && (ReadState == WRITE_CACHE) && !RW)? 1'b1:
                                                                1'b0;*/

    assign Stall = WStall || (RStall);
                    
   // assign Stall = (!En) ? 1'b0:
    //               ( En && (WriteState == IDLE) && RW && ())
    //wire C_Dirty = 1'b0;

//----------------------------WRITE STATE MACHINE-------------------------

    //Write
    always @(posedge Clk) begin
     if(Rst) begin
        WriteState <= IDLE;
	    WC_OEn <= 1;
        WStall <= 0;
        Merge <= 0;
        WriteType <= 0;
        LW_Enable <= 0;
        LB_Enable <= 0;
        StoreBuff_Enable <= 1;
        FromStoreBuffer <= 0;
     end
     else 
        case(WriteState)
            IDLE: 
            begin
                if(!En || (En && !RW)) begin
                    WriteState <= IDLE;
                    WBusy <= 0; 
                    WC_OEn <= 1;
                    WStall <= 0;
                    Merge <= 0;
                    WriteType <= 0;
                    StoreBuff_Enable <= 1;
                    FromStoreBuffer <= 0;
                end
                else if(!C_Miss) begin //TODO verify if the atual state is writecache
                    if(ReadLineWrite /*&& (LineWriteAddr == LineBuffAddr)*/) begin
                        //Wait one cycle
                        WriteState <= WWORD_ON_CACHE;
                        LB_Occupied <= 0;
                        LW_Occupied <= 0;
                        WBusy <= 1;
                        WC_OEn <= 0;
                        RStall <= 0;
                        WStall <= 1;
                        Merge <= 0;
                        WriteType <= 0;
                        LW_Enable <= 0;
                        LB_Enable <= 0;
                        StoreBuff_Enable <= 0;
                        FromStoreBuffer <= 1;
                    end
                    else begin
                        //Combinational Write
                    end    

                end
                else if(C_Miss && C_Dirty && !RBusy) begin
                    WriteState <= START_AXI_RW;
                    LB_Occupied <= 1;
                    LW_Occupied <= 1;
                    WBusy <= 1;
                    WC_OEn <= 0;
                    RStall <= 0;
                    WStall <= 0;
                    Merge <= 0;
                    WriteType <= 0;
                    LW_Enable <= 1;
                    LB_Enable <= 1;
                    StoreBuff_Enable <= 0;
                    FromStoreBuffer <= 0;
                end
                else if(C_Miss && !C_Dirty && !RBusy) begin
                    WriteState <= START_AXI_R;
                    LB_Occupied <= 1;
                    LW_Occupied <= 0;
                    WBusy <= 1;
                    WC_OEn <= 0;
                    RStall <= 0;
                    WStall <= 0;
                    Merge <= 0;
                    WriteType <= 0;
                    LW_Enable <= 0;
                    LB_Enable <= 1;
                    StoreBuff_Enable <= 0;
                    FromStoreBuffer <= 0;
                end
            end
            WWORD_ON_CACHE: 
            begin   
                //Write cache and go IDLE
                WriteState <= IDLE;
                LB_Occupied <= 0;
                LW_Occupied <= 0;
                WBusy <= 0;
                WC_OEn <= 1;
                RStall <= 0;
                WStall <= 0;
                Merge <= 0;
                WriteType <= 0;
                LW_Enable <= 0;
                LB_Enable <= 0;
                StoreBuff_Enable <= 1;
                FromStoreBuffer <= 0;
            end
            START_AXI_RW:
            begin
                if(LB_Completed)
                begin
                    LB_Occupied <= 0;
                    LB_Enable <= 0;
                end
                if(LW_Completed)
                begin
                    LW_Occupied <= 0;
                    LW_Enable <= 0;
                end
                if(LB_Occupied && LW_Occupied) begin
                    WriteState <= MERGE_RESULTS;
                    LB_Occupied <= 0;
                    LW_Occupied <= 0;
                    WBusy <= 1;
                    WC_OEn <= 0;
                    RStall <= 0;
                    WStall <= 0;
                    Merge <= 1;
                    WriteType <= 1;
                    LW_Enable <= 0;
                    LB_Enable <= 0;
                    StoreBuff_Enable <= 0;
                    FromStoreBuffer <= 0;
                end   
            end
            START_AXI_R:
            begin
               // WBusy <= 1;
               if(LB_Completed)
               begin
                 WriteState <= MERGE_RESULTS;
                 LB_Occupied <= 0;
                 LW_Occupied <= 0;
                 WBusy <= 1;
                 WC_OEn <= 0;
                 RStall <= 0;
                 WStall <= 0;
                 Merge <= 1;
                 WriteType <= 1;
                 LW_Enable <= 0;
                 LB_Enable <= 0;
                 StoreBuff_Enable <= 0;
                 FromStoreBuffer <= 0;
               end
            end
            MERGE_RESULTS:
            begin
               WriteState <= IDLE;
               //Enable to write on Cache
               LB_Occupied <= 0;
               LW_Occupied <= 0;
               WBusy <= 0;
               WC_OEn <= 0;
               RStall <= 0;
               WStall <= 0;
               Merge <= 0;
               WriteType <= 0;
               LW_Enable <= 0;
               LB_Enable <= 0;
               StoreBuff_Enable <= 1;
               FromStoreBuffer <= 0;
                //Activate Write LB Signals
            end
            /*WRITE_LB_ON_CACHE:
            begin
                WriteState <= IDLE;
                WBusy <= 0;
                WC_OEn <= 1;
            end*/
        endcase
    end
    
 //----------------------------READ STATE MACHINE-------------------------   
    //Read
    always @(posedge Clk) begin
        if(Rst) begin
            ReadState  <= IDLE;
            LB_Occupied <= 0;
            LW_Occupied <= 0;
            RC_OEn <= 1;
            RBusy <= 0;
            RStall <= 0;
            LB_Enable <= 0;
        end
        else
            case(ReadState)
            IDLE:
            begin
                if(!En || (En && RW)) begin
                    ReadState <= IDLE;
                    RBusy <= 0;
                    RStall <= 0;
                    RC_OEn <= 1;
                end
                else if(C_Miss && !RW && C_Dirty && !WBusy) begin
                    ReadState <= READ_MISS_DIRTY;
                    LB_Enable <= 1;
                    LB_Occupied <= 1;
                    LW_Enable <= 1;
                    LW_Occupied <= 1;
                    RC_OEn <= 0;
                    RBusy <= 1;
                    RStall <= 1; // waiting for word so we need to stall
                end
                else if(C_Miss && !RW && !C_Dirty && !WBusy) begin
                    ReadState <= READ_MISS_NOT_DIRTY;
                    LB_Occupied <= 1;
                    LB_Enable <= 1;
                    LW_Occupied <= 0;
                    RC_OEn <= 0;
                    RBusy <= 1;
                    RStall <= 1; // waiting for word so we need to stall
                end
                else if(C_Miss && !RW) begin
                    RStall <= 1;
                    RC_OEn <= 0;
                end
            end
            READ_MISS_DIRTY:
            begin
                if(LB_FirstWord) begin
                    ReadState <= WAIT_COMPLETION_DIRTY;
                    LB_Occupied <= 1;
                    LB_Enable <= 1;
                    //Activate Write ST Signals
                    LW_Occupied <= 1;
                    RStall <= 0; // word has arrived, no need to stall
                end
                else begin
                    ReadState <= READ_MISS_DIRTY;
                    LB_Enable <= 1;
                    LB_Occupied <= 1;
                    //Activate Write ST Signals
                    LW_Occupied <= 1;
                    RStall <= 1; // waiting for word so we need to stall
                end
            end
            READ_MISS_NOT_DIRTY:
            begin           
                if(LB_FirstWord) begin
                    ReadState <= WAIT_COMPLETION_NON_DIRTY;
                    LB_Occupied <= 1;
                    LB_Enable <= 1;
                    RStall <= 0; // word has arrived, no need to stall
                end
                else begin
                    ReadState <= READ_MISS_NOT_DIRTY;
                    //Activate Write LB Signals
                    LB_Occupied <= 1;
                    RStall <= 1; // waiting for word so we need to stall
                end
            end
            WAIT_COMPLETION_DIRTY:
            begin
                if(LB_Completed) begin
                    LB_Occupied <= 0;
                end
                if(LW_Completed) begin
                    LW_Occupied <= 0;
                end
                if((LB_Completed || !LB_Occupied) && (LW_Completed || !LW_Occupied)) begin
                    ReadState <= WRITE_CACHE;
                    ReadLineWrite <= 1;
                    LB_Enable <= 0; //Stop the buffer
                    LW_Enable <= 0;
                    //write cacheline
                    RStall <= C_Miss; // Only stall if there's a reading miss
                    RC_OEn <= 1;
                end
                else begin
                    ReadState <= WAIT_COMPLETION_DIRTY;
                    RStall <= C_Miss; // Only stall if there's a reading miss
                    LB_Occupied <= LB_Occupied;
                    LB_Enable <= LB_Occupied;
                    LW_Occupied <= LW_Occupied;
                    LW_Enable <= LB_Occupied; 
                    RC_OEn <= 1;
                end  
            end
            WAIT_COMPLETION_NON_DIRTY:
            begin
                if(LB_Completed) begin
                    LB_Occupied <= 0;
                end
                if(LB_Completed || !LB_Occupied) begin
                    ReadState <= WRITE_CACHE;
                    ReadLineWrite <= 1;
                    LB_Enable <= 0; //Stop the buffer
                    //write cacheline
                    RStall <= C_Miss; // Only stall if there's a reading miss
                    RBusy <= 0;
                end
                else begin
                    ReadState <= WAIT_COMPLETION_NON_DIRTY;
                    LB_Occupied <= LB_Occupied;
                    RStall <= C_Miss; // Only stall if there's a reading miss
                    RBusy <= 1;
                end
            end
            WRITE_CACHE:
            begin
	            ReadLineWrite <= 0;
                ReadState <= IDLE;
                //Activate Write ST Signals
                RBusy <= 0;
                RStall <= 0;               
            end
        endcase
    end
    
endmodule
