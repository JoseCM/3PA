`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.05.2016 10:38:44
// Design Name: 
// Module Name: DCache
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


module DCache(
    //MemController Signals
        input Clk,
        input Rst,
        input En,
        input RW,
        input [31:0] WData,
        input [31:0] Address,
        output [31:0] RData,
        output Stall,   
    //Store Buffer Signals
        output LW_Enable,
        input  LW_Completed,
        output [255:0] oLineData,
        input [31:0] LineWriteBufAddr,
    //Line Fill Buffer Signals
        output LB_Enable,
        input LB_Completed,
        input LB_FirstWord,
        input [255:0] LB_LineData,
        input [31:0] LB_LineAddr,
        output RWordSelect
    );
    
    wire W_Enable;
    wire R_Enable;
    // wire C_RW;
    wire Merge;
    wire dirty;
    wire writeType;
    wire StoreBuff_Enable;
    // assign Stall = CtrlStall || C_Ctrl;
    reg [31:0] StoreBuff;
    reg [31:0] StoreBuffAddr;
    
    
    /*Store buffer for writes*/
    always @(posedge Clk) begin
        if(Rst) begin
            StoreBuff <= 0;
            StoreBuffAddr <= 0;
        end
        else if(StoreBuff_Enable) begin    
            StoreBuff <= WData;
            StoreBuffAddr <= Address;
        end
    end
    
    /*Cache Read Write Control Unit*/
    CacheIControl CC (
        .Clk(Clk),
        .Rst(Rst),
        /*CPU*/
        .En(En),
        .RW(RW),
        /*Cache*/        
        .Stall(Stall),
        .WordAddress(Address),
        .LineAddress(LB_LineAddr),
        .C_Dirty(dirty),
        .WriteType(writeType),
        .C_Miss(~hit),
        .W_Enable(W_Enable),
        .R_Enable(R_Enable),
        .Merge(Merge),
        /*StoreBuffer*/
        .LW_Enable(LW_Enable),
        .LW_Completed(LW_Completed),
        /*LineFillBuffer*/
        .LB_Completed(LB_Completed),
        .LB_FirstWord(LB_FirstWord),
        .LB_Enable(LB_Enable),
         /*StoreBuffer*/
        .StoreBuff_Enable(StoreBuff_Enable),
        .FromStoreBuffer(FromStoreBuffer),
        /**/
        .CrtWord(RWordSelect)
    );
    
    /*Merge Unit, gets word from StoreBuffer and merges with
    cache line read from memory*/
    wire[255:0] MergedLine;
    MergeUnit MU (
       .Address_LSBs(StoreBuffAddr[2:0]),
       .WriteData(StoreBuff),
       .CacheLine(LB_LineData),
       .MergeOutput(MergedLine)
    );

    /*Mux to use merge, in case of a write miss or just Line Fill buffer
    in case of a read miss*/
    assign WCacheLine = (Merge == 1)? MergedLine : LB_LineData; 
    /*Mux to use address from store buffer or directly from CPU*/
    assign WordAddress = (FromStoreBuffer == 1) ? StoreBuffAddr : Address;
    assign WordWrite = (FromStoreBuffer == 1) ? StoreBuff : WData;
    
    DCacheMem DCMem(
        .clk(Clk),
        .rst(Rst),
        /*Enable read and/or write channels*/
        .W_Enable(W_Enable), 
        .R_Enable(R_Enable),
        /*Word related cache signals*/
        .word(WData),
        .addr(Address),
        .inst(RData),
        .hit(hit),
        .dirty(dirty),
        /*Line related cache signals*/
        .RWLine(Merge),            //Indicates if the write from memory was issued by a Read (RWLine = 0) or a Write (RWLine = 1)
        .LineAddr(LB_LineAddr),     //Indicates the address of the write from memory
        .write_type(writeType),     //Enable a write from memory to cache (1)
        .mem_data(WCacheLine),      //line to write on cache
        .mem_addr(LineWriteBufAddr),//Indicates the address memory of the set that is going to be replaced and has dirty =1
        .cache_write_data(oLineData)//line to write on memory
    );
    
endmodule
