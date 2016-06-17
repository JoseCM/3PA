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


module CacheIControl(
    input Clk,
    input Rst,
    input En, //só fica a1 no acesso
    input RW,
    output Stall,
    input [31:0] WordAddress,
    /*Cache*/
    input C_Dirty,
    input C_Miss,
    output WriteType,
    output W_Enable,
    output R_Enable,
    output reg Merge,
    /*LineWrite Buffer*/
    input LW_Completed,
    output LW_Enable,
    /*LineFill _Enable*/
    input LB_Completed,
    input LB_FirstWord,
    output LB_Enable,
    input [31:0] LineAddress,
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
       
    `define LINE_T	11
    `define LINE_B  5        //7 bits to address 128 lines
                                
    reg [2:0] ReadState;
    reg [2:0] WriteState;
    reg RBusy;
    reg WBusy;
    reg WC_OEn; //Enable para permitir o acesso à cache com o processador num write
    reg RC_OEn; //Enable para permitir o acesso à cache com o processador num read
    wire RStall;
    wire WStall;
    reg WriteCacheDummy;
    
    reg LW_EnableW; //enable LW from write state machine
    reg LW_EnableR; //enable LW from read state machine
    reg LB_EnableW; //enable LB from write state machine
    reg LB_EnableR; //enable LB from read state 
    
    assign LW_Enable = LW_EnableW | LW_EnableR;
    assign LB_Enable = LB_EnableW | LB_EnableR;

    reg LB_OccupiedW;
    reg LB_OccupiedR;
    reg LW_OccupiedW;
    reg LW_OccupiedR;
    assign LB_Occupied = LB_OccupiedW | LB_OccupiedR;
    assign LW_Occupied = LW_OccupiedW | LW_OccupiedR;


    reg WriteTypeW;
    reg WriteTypeR;
    assign WriteType = WriteTypeW | WriteTypeR;

    wire SameLine = (LineAddress[`LINE_T:`LINE_B] == WordAddress[`LINE_T:`LINE_B]) && RBusy;
    
    //If Read/Write and Read/WriteState is Idle use Idle Values
    //Else use Write or Read State Machine Values.
    assign W_Enable = (En && WriteState == IDLE && RW && !SameLine) && WC_OEn;
    
    assign R_Enable = (En && !RW  && RC_OEn && (
                            ((ReadState == IDLE) || (ReadState == WAIT_COMPLETION_DIRTY) || (ReadState == WAIT_COMPLETION_NON_DIRTY)) && (!SameLine)
                            ));
    
    
    assign CrtWord = (En && ((ReadState == READ_MISS_DIRTY) || (ReadState == READ_MISS_NOT_DIRTY)) && LB_FirstWord);
    
    
    assign Stall = WStall || RStall;
    
    assign RStall = En && ((ReadState == IDLE) && (C_Miss && !RW)) || //read state, idle transitions, wether it's write is busy or not
                    En && (((ReadState == READ_MISS_DIRTY) || (ReadState == READ_MISS_NOT_DIRTY)) && (!LB_FirstWord)) || //Stall until the critical word arrives
                    En && (((ReadState == WAIT_COMPLETION_NON_DIRTY) || (ReadState == WAIT_COMPLETION_DIRTY)) && (C_Miss & !RW)) || //Stall if another read miss is issued
                    En && (((ReadState == WAIT_COMPLETION_NON_DIRTY) || (ReadState == WAIT_COMPLETION_DIRTY)) && ((LB_Completed || !LB_Occupied) && (LW_Completed || !LW_Occupied)) && !RW) ||
                    En && ((ReadState == WRITE_CACHE) && (/*C_Miss &*/ !RW)) || //Stall if we're writting the cache line
                    En && !RW && SameLine && (WBusy || (RBusy && !LB_FirstWord)) ;
                    
    assign WStall = En && (!C_Miss && RW && SameLine) || //Stalls if the write tries to write on the same cache line of the LineBuffer
                    En && (C_Miss && RW && RBusy) || //Stalls if there's a write miss and the LineBuffer is occupied by previous misses
                    En && (RW && WBusy);    //Stalls if there's a write and the previous one hasn't finished

//----------------------------WRITE STATE MACHINE-------------------------

    //Write
    always @(posedge Clk) begin
     if(Rst) begin
        WriteState <= IDLE;
	    WC_OEn <= 1;
        Merge <= 0;
        WBusy <= 0;
        WriteTypeW <= 0;
        LW_EnableW <= 0;
        LB_EnableW <= 0;
        StoreBuff_Enable <= 1;
        FromStoreBuffer <= 0;
        WBusy <= 0;
        WriteCacheDummy <= 0;
     end
     else 
        case(WriteState)
            IDLE: 
            begin
               FromStoreBuffer <= 0;
               if(!C_Miss && RW && En) begin //TODO verify if the atual state is writecache
                    if(SameLine) begin
                        //Wait one cycle
                        WriteState <= WWORD_ON_CACHE;
                        WBusy <= 1;
                        WC_OEn <= 0;
                        Merge <= 0;
                        StoreBuff_Enable <= 0;
                        FromStoreBuffer <= 1;
                    end
                    else begin
                        //Combinational Write
                    end    
                end
                else if(C_Miss && C_Dirty && !RBusy && En && RW) begin
                    WriteState <= START_AXI_RW;
                    LB_OccupiedW <= 1;
                    LW_OccupiedW <= 1;
                    WBusy <= 1;
                    WC_OEn <= 0;
                    Merge <= 0;
                    LW_EnableW <= 1;
                    LB_EnableW <= 1;
                    StoreBuff_Enable <= 0;
                    FromStoreBuffer <= 0;
                end
                else if(C_Miss && !C_Dirty && !RBusy && En && RW) begin
                    WriteState <= START_AXI_R;
                    LB_OccupiedW <= 1;
                    WBusy <= 1;
                    WC_OEn <= 0;
                    Merge <= 0;
                    LB_EnableW <= 1;
                    StoreBuff_Enable <= 0;
                    FromStoreBuffer <= 0;
                end
                else if(!RW && En) begin
                    WriteState <= IDLE;
                    WBusy <= 0; 
                    WC_OEn <= 1;
                    Merge <= 0;
                    StoreBuff_Enable <= 1;
                    FromStoreBuffer <= 0;
                end
            end
            WWORD_ON_CACHE: 
            begin   
                if(!SameLine)
                begin
                //Write cache and go IDLE
                WriteState <= IDLE;
                WBusy <= 0;
                WC_OEn <= 1;
                Merge <= 0;
                StoreBuff_Enable <= 1;
                FromStoreBuffer <= 0;
                end
            end
            START_AXI_RW:
            begin
                if(LB_Completed)
                begin
                    LB_OccupiedW <= 0;
                    LB_EnableW <= 0;
                end
                if(LW_Completed)
                begin
                    LW_OccupiedW <= 0;
                    LW_EnableW <= 0;
                end
                if((LB_Completed || !LB_OccupiedW) && (LW_Completed || !LW_OccupiedW)) begin
                    WriteState <= MERGE_RESULTS;
                    WBusy <= 1;
                    WC_OEn <= 0;
                    Merge <= 1;
                    WriteTypeW <= 1;                    
                    StoreBuff_Enable <= 0;
                end   
            end
            START_AXI_R:
            begin
               // WBusy <= 1;
               if(LB_Completed)
               begin
                 WriteState <= MERGE_RESULTS;
                 LB_OccupiedW <= 0;
                 WBusy <= 1;
                 WC_OEn <= 0;
                 Merge <= 1;
                 WriteTypeW <= 1;
                 LB_EnableW <= 0;
                 StoreBuff_Enable <= 0;
               end
            end
            MERGE_RESULTS:
            begin
               WriteState <= IDLE;
               WBusy <= 0;
               WC_OEn <= 1;
               Merge <= 0;
               WriteTypeW <= 0;
               StoreBuff_Enable <= 0;
               //FromStoreBuffer <= 1;
            end
        endcase
    end
    
 //----------------------------READ STATE MACHINE-------------------------   
    //Read
    always @(posedge Clk) begin
        if(Rst) begin
            ReadState  <= IDLE;
            LB_OccupiedR <= 0;
            LW_OccupiedR <= 0;
            RC_OEn <= 1;
            WriteTypeR <= 0;
            RBusy <= 0;
            LB_EnableR <= 0;
            WriteCacheDummy <= 0;
        end
        else
            case(ReadState)
            IDLE:
            begin
                WriteCacheDummy <= 0;
                if(C_Miss && !RW && C_Dirty && !WBusy && En) begin
                    ReadState <= READ_MISS_DIRTY;
                    LB_EnableR <= 1;
                    LB_OccupiedR <= 1;
                    LW_EnableR <= 1;
                    LW_OccupiedR <= 1;
                    RC_OEn <= 0;
                    RBusy <= 1;
                end
                else if(C_Miss && !RW && !C_Dirty && !WBusy && En) begin
                    ReadState <= READ_MISS_NOT_DIRTY;
                    LB_OccupiedR <= 1;
                    LB_EnableR <= 1;
                    RC_OEn <= 0;
                    RBusy <= 1;
                end
                else if(RW && En) begin
                    ReadState <= IDLE;
                    RBusy <= 0;
                    RC_OEn <= 1;
                end
            end
            READ_MISS_DIRTY:
            begin
                if(LB_FirstWord) begin
                    ReadState <= WAIT_COMPLETION_DIRTY;
                    LB_OccupiedR <= 1;
                    LB_EnableR <= 1;
                    //Activate Write ST Signals
                    LW_OccupiedR <= 1;
                    RC_OEn <= 1;
                end
                else begin
                    ReadState <= READ_MISS_DIRTY;
                    LB_EnableR <= 1;
                    LB_OccupiedR <= 1;
                    //Activate Write ST Signals
                    LW_OccupiedR <= 1;
                    LW_EnableR <= 1;
                    RBusy <= 1;
                end
            end
            READ_MISS_NOT_DIRTY:
            begin           
                if(LB_FirstWord) begin
                    ReadState <= WAIT_COMPLETION_NON_DIRTY;
                    LB_OccupiedR <= 1;
                    LB_EnableR <= 1;
                    RC_OEn <= 1;
                    RBusy <= 1;
                end
                else begin
                    ReadState <= READ_MISS_NOT_DIRTY;
                    //Activate Write LB Signals
                    LB_OccupiedR <= 1;
                    LB_EnableR <= 1;
                    RBusy <= 1;
                end
            end
            WAIT_COMPLETION_DIRTY:
            begin
                if(LB_Completed) begin
                    LB_OccupiedR <= 0;
                    LB_EnableR <= 0; //Stop the buffer
                end
                if(LW_Completed) begin
                    LW_OccupiedR <= 0;
                    LW_EnableR <= 0;
                end
                if((LB_Completed || !LB_OccupiedR) && (LW_Completed || !LW_OccupiedR)) begin
                    ReadState <= WRITE_CACHE;
                    WriteTypeR <= 1;
                    RC_OEn <= 1;
                    RBusy <= 1;
                end
                else begin
                    ReadState <= WAIT_COMPLETION_DIRTY;
                    LB_OccupiedR <= LB_OccupiedR;
                    LB_EnableR <= LB_EnableR;
                    LW_OccupiedR <= LW_OccupiedR;
                    LW_EnableR <= LW_EnableR; 
                    RC_OEn <= 1;
                    RBusy <= 1;
                end  
            end
            WAIT_COMPLETION_NON_DIRTY:
            begin
                if(LB_Completed) begin
                    ReadState <= WRITE_CACHE;
                    LB_OccupiedR <= 0;
                    LB_EnableR <= 0; //Stop the buffer
                    WriteTypeR <= 1; //write cacheline
                    RBusy <= 1;
                end
                else begin
                    ReadState <= WAIT_COMPLETION_NON_DIRTY;
                    LB_OccupiedR <= 1;
                    LB_EnableR <= 1; //Stop the buffer
                    RBusy <= 1;
                end
            end
            WRITE_CACHE:
            begin
                ReadState <= IDLE;
                WriteCacheDummy <= 1;
                //Activate Write ST Signals
                RBusy <= 0;
                WriteTypeR <= 0;            
            end
        endcase
    end
    
endmodule
