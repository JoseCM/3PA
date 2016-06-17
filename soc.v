`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.05.2016 15:24:10
// Design Name: 
// Module Name: soc
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
`include "mem_bus_defines.vh"
`include "pipelinedefs.vh"

module soc # (
    // Parameters of Axi Master Bus Interface PAXI
    parameter  C_M00_AXI_TARGET_SLAVE_BASE_ADDR    = 32'h40000000,
    parameter integer C_M00_AXI_ID_WIDTH    = 1,
    parameter integer C_M00_AXI_ADDR_WIDTH    = 32,
    parameter integer C_M00_AXI_DATA_WIDTH    = 32,
    parameter integer C_M00_AXI_AWUSER_WIDTH    = 0,
    parameter integer C_M00_AXI_ARUSER_WIDTH    = 0,
    parameter integer C_M00_AXI_WUSER_WIDTH    = 0,
    parameter integer C_M00_AXI_RUSER_WIDTH    = 0,
    parameter integer C_M00_AXI_BUSER_WIDTH    = 0,
    
    // Parameters of Axi Master Bus Interface M01_AXI
    parameter  C_M01_AXI_TARGET_SLAVE_BASE_ADDR    = 32'h40000000,
    parameter integer C_M01_AXI_ID_WIDTH    = 3,
    parameter integer C_M01_AXI_ADDR_WIDTH    = 32,
    parameter integer C_M01_AXI_DATA_WIDTH    = 32,
    parameter integer C_M01_AXI_AWUSER_WIDTH    = 0,
    parameter integer C_M01_AXI_ARUSER_WIDTH    = 0,
    parameter integer C_M01_AXI_WUSER_WIDTH    = 0,
    parameter integer C_M01_AXI_RUSER_WIDTH    = 0,
    parameter integer C_M01_AXI_BUSER_WIDTH    = 0,
    
    // Parameters for Instricton Cache AXI Master
    parameter CACHE_LINE_NO = 8,
    parameter CACHE_LINE_SIZE = 64,
    parameter BURST_TYPE = 2,
    parameter integer C_M02_AXI_ID_WIDTH    = 3,
    parameter integer C_M02_AXI_ADDR_WIDTH    = 32,
    parameter integer C_M02_AXI_DATA_WIDTH    = 32,
    parameter integer C_M02_AXI_AWUSER_WIDTH    = 0,
    parameter integer C_M02_AXI_ARUSER_WIDTH    = 1,
    parameter integer C_M02_AXI_WUSER_WIDTH    = 0,
    parameter integer C_M02_AXI_RUSER_WIDTH    = 1,
    parameter integer C_M02_AXI_BUSER_WIDTH    = 0
)
(
    input Clk,
    input Rst,
    output NotRst,
    // Ports of Axi Master Bus Interface M00_AXI
	output wire [C_M00_AXI_ID_WIDTH-1 : 0] m00_axi_awid,
    output wire [C_M00_AXI_ADDR_WIDTH-1 : 0] m00_axi_awaddr,
    output wire [7 : 0] m00_axi_awlen,
    output wire [2 : 0] m00_axi_awsize,
    output wire [1 : 0] m00_axi_awburst,
    output wire  m00_axi_awlock,
    output wire [3 : 0] m00_axi_awcache,
    output wire [2 : 0] m00_axi_awprot,
    output wire [3 : 0] m00_axi_awqos,
    output wire [C_M00_AXI_AWUSER_WIDTH-1 : 0] m00_axi_awuser,
    output wire  m00_axi_awvalid,
    input wire  m00_axi_awready,
    output wire [C_M00_AXI_DATA_WIDTH-1 : 0] m00_axi_wdata,
    output wire [C_M00_AXI_DATA_WIDTH/8-1 : 0] m00_axi_wstrb,
    output wire  m00_axi_wlast,
    output wire [C_M00_AXI_WUSER_WIDTH-1 : 0] m00_axi_wuser,
    output wire  m00_axi_wvalid,
    input wire  m00_axi_wready,
    input wire [C_M00_AXI_ID_WIDTH-1 : 0] m00_axi_bid,
    input wire [1 : 0] m00_axi_bresp,
    input wire [C_M00_AXI_BUSER_WIDTH-1 : 0] m00_axi_buser,
    input wire  m00_axi_bvalid,
    output wire  m00_axi_bready,
    output wire [C_M00_AXI_ID_WIDTH-1 : 0] m00_axi_arid,
    output wire [C_M00_AXI_ADDR_WIDTH-1 : 0] m00_axi_araddr,
    output wire [7 : 0] m00_axi_arlen,
    output wire [2 : 0] m00_axi_arsize,
    output wire [1 : 0] m00_axi_arburst,
    output wire  m00_axi_arlock,
    output wire [3 : 0] m00_axi_arcache,
    output wire [2 : 0] m00_axi_arprot,
    output wire [3 : 0] m00_axi_arqos,
    output wire [C_M00_AXI_ARUSER_WIDTH-1 : 0] m00_axi_aruser,
    output wire  m00_axi_arvalid,
    input wire  m00_axi_arready,
    input wire [C_M00_AXI_ID_WIDTH-1 : 0] m00_axi_rid,
    input wire [C_M00_AXI_DATA_WIDTH-1 : 0] m00_axi_rdata,
    input wire [1 : 0] m00_axi_rresp,
    input wire  m00_axi_rlast,
    input wire [C_M00_AXI_RUSER_WIDTH-1 : 0] m00_axi_ruser,
    input wire  m00_axi_rvalid,
    output wire  m00_axi_rready,
    
    // Ports of Axi Master Bus Interface M01_AXI
    output wire [C_M01_AXI_ID_WIDTH-1 : 0] m01_axi_awid,
    output wire [C_M01_AXI_ADDR_WIDTH-1 : 0] m01_axi_awaddr,
    output wire [7 : 0] m01_axi_awlen,
    output wire [2 : 0] m01_axi_awsize,
    output wire [1 : 0] m01_axi_awburst,
    output wire  m01_axi_awlock,
    output wire [3 : 0] m01_axi_awcache,
    output wire [2 : 0] m01_axi_awprot,
    output wire [3 : 0] m01_axi_awqos,
    output wire [C_M01_AXI_AWUSER_WIDTH-1 : 0] m01_axi_awuser,
    output wire  m01_axi_awvalid,
    input wire  m01_axi_awready,
    output wire [C_M01_AXI_DATA_WIDTH-1 : 0] m01_axi_wdata,
    output wire [C_M01_AXI_DATA_WIDTH/8-1 : 0] m01_axi_wstrb,
    output wire  m01_axi_wlast,
    output wire [C_M01_AXI_WUSER_WIDTH-1 : 0] m01_axi_wuser,
    output wire  m01_axi_wvalid,
    input wire  m01_axi_wready,
    input wire [C_M01_AXI_ID_WIDTH-1 : 0] m01_axi_bid,
    input wire [1 : 0] m01_axi_bresp,
    input wire [C_M01_AXI_BUSER_WIDTH-1 : 0] m01_axi_buser,
    input wire  m01_axi_bvalid,
    output wire  m01_axi_bready,
    output wire [C_M01_AXI_ID_WIDTH-1 : 0] m01_axi_arid,
    output wire [C_M01_AXI_ADDR_WIDTH-1 : 0] m01_axi_araddr,
    output wire [7 : 0] m01_axi_arlen,
    output wire [2 : 0] m01_axi_arsize,
    output wire [1 : 0] m01_axi_arburst,
    output wire  m01_axi_arlock,
    output wire [3 : 0] m01_axi_arcache,
    output wire [2 : 0] m01_axi_arprot,
    output wire [3 : 0] m01_axi_arqos,
    output wire [C_M01_AXI_ARUSER_WIDTH-1 : 0] m01_axi_aruser,
    output wire  m01_axi_arvalid,
    input wire  m01_axi_arready,
    input wire [C_M01_AXI_ID_WIDTH-1 : 0] m01_axi_rid,
    input wire [C_M01_AXI_DATA_WIDTH-1 : 0] m01_axi_rdata,
    input wire [1 : 0] m01_axi_rresp,
    input wire  m01_axi_rlast,
    input wire [C_M01_AXI_RUSER_WIDTH-1 : 0] m01_axi_ruser,
    input wire  m01_axi_rvalid,
    output wire  m01_axi_rready,
    
    //Instruction Cache AXI Master Interface
      output [0 : 0] m02_axi_awid,
      output [31 : 0] m02_axi_awaddr,
      output [7 : 0] m02_axi_awlen,
      output [2 : 0] m02_axi_awsize,
      output [1 : 0] m02_axi_awburst,
      output m02_axi_awlock,
      output [3 : 0] m02_axi_awcache,
      output [2 : 0] m02_axi_awprot,
      output [3 : 0] m02_axi_awqos,
      output m02_axi_awvalid,
      input m02_axi_awready,
      output [31 : 0] m02_axi_wdata,
      output [3 : 0] m02_axi_wstrb,
      output m02_axi_wlast,
      output m02_axi_wvalid,
      input m02_axi_wready,
      input [0 : 0] m02_axi_bid,
      input [1 : 0] m02_axi_bresp,
      input m02_axi_bvalid,
      output m02_axi_bready,
      output [0 : 0] m02_axi_arid,
      output [31 : 0] m02_axi_araddr,
      output [7 : 0] m02_axi_arlen,
      output [2 : 0] m02_axi_arsize,
      output [1 : 0] m02_axi_arburst,
      output m02_axi_arlock,
      output [3 : 0] m02_axi_arcache,
      output [2 : 0] m02_axi_arprot,
      output [3 : 0] m02_axi_arqos,
      output m02_axi_arvalid,
      input m02_axi_arready,
      input [0 : 0] m02_axi_rid,
      input [31 : 0] m02_axi_rdata,
      input [1 : 0] m02_axi_rresp,
      input m02_axi_rlast,
      input m02_axi_rvalid,
      output m02_axi_rready,
	  input [30:0] i_ext
    );
    
    wire [`DBUSO_WIDTH - 1 : 0] dcache_bus_i; 
    wire [`DBUSI_WIDTH - 1 : 0] dcache_bus_o; 
    wire [`MA_WIDTH - 1: 0] dcache_bus_o_ma = dcache_bus_o[`DBUSI_MA];
    
    wire [`IBUSO_WIDTH - 1 : 0] icache_bus_i;
    //changes 
    wire [`ADDR_WIDTH - 1 : 0] icache_bus_o; 
    
    processor  cpu(
           .Clk(Clk),
           .Rst(Rst),
           .i_ext(i_ext), // input vic peripheral
           /***************************/
           .Dcache_bus_out(dcache_bus_o),
           .Dcache_bus_in(dcache_bus_i),
           //changes
           .Icache_bus_out(icache_bus_o),
           .Icache_bus_in(icache_bus_i)         
    );
     
    wire [31:0] P_AXIAddr;
    wire P_StartAXIRead;
    wire P_StartAXIWrite;
    wire [31:0] P_WriteData;
    wire [31:0] P_ReadData;
    wire P_WriteCompleted;
    wire P_ReadCompleted;
    wire start_write_wire;
    wire start_read_wire;
    wire [31:0] C_WriteData;
    wire [31:0] C_ReadData;
    wire [31:0] C_Address;
    wire [31:0] LW_Output_Addr;
    wire [255:0] LW_AXIData;
    wire WriteCompleted;
    wire [31:0] LB_Output_Addr;
    wire ReadCompleted;
    wire [31:0] ReadData;
    wire NewWordAvailable;
    wire [31:0] LB_CriticalWord;
    wire [255:0] LB_ReadLine; 
    wire [255:0] LW_CacheLineToWrite;
    wire RWordSelect;
    wire C_Stall;
    wire LB_Enable;
    wire LW_Enable;
    wire [31:0] LineWriteBufAddr;
    
    wire NotRst;
    assign NotRst = !Rst;
    
    MemController MemC(
    .Clk(Clk),
    .Rst(NotRst),
    .RW(dcache_bus_o_ma[`MA_RW]),
    .En(dcache_bus_o_ma[`MA_EN]),
    .Address(dcache_bus_o[`DBUSI_ADDR]),
    .IData(dcache_bus_o[`DBUSI_DATA]),
    .Stall(dcache_bus_i[`DBUSO_MISS]),
    .OData(dcache_bus_i[`DBUSO_DATA]),
    //For Periph Master AXI
    .P_AXIAddr(P_AXIAddr),
    .P_StartAXIRead(P_StartAXIRead),
    .P_StartAXIWrite(P_StartAXIWrite),    
    .P_WriteData(P_WriteData),
    .P_ReadData(P_ReadData),
    .P_WriteCompleted(P_WriteCompleted),
    .P_ReadCompleted(P_ReadCompleted),
    //For cache control
    .C_En(C_En),
    .C_RW(C_RW),
    .C_WriteData(C_WriteData),
    .C_Address(C_Address),
    .C_ReadData(C_ReadData),
    .C_Stall(C_Stall),
    /**/
    .RWordSelect(RWordSelect),
    .LB_CriticalWord(LB_CriticalWord)
    );
    
   //Cache & Cache Controller
   DCache datacache(
   .Clk(Clk),
   .Rst(Rst),
   /*CPU*/
   .En(C_En),
   .RW(C_RW),
   .Address(C_Address),
   .WData(C_WriteData),
   .RData(C_ReadData),
   .Stall(C_Stall),
   /*LineWriteBuffer*/
   .LW_Enable(LW_Enable),
   .LW_Completed(LW_Completed),
   .LineWriteBufAddr(LineWriteBufAddr),
   .oLineData(LW_CacheLineToWrite),
   /*LineFillBuffer*/
   .LB_Completed(LB_LineReadCompleted),
   .LB_FirstWord(LB_FirstDataAcquired),
   .LB_Enable(LB_Enable),
   .LB_LineData(LB_ReadLine),
   .LB_LineAddr(LB_Output_Addr),
   .RWordSelect(RWordSelect)
   );
   
   assign RData = (RWordSelect) ? LB_CriticalWord : C_ReadData;

    reg [31:0] AddressDelay;
    always@ (posedge Clk) begin
        if(!LB_Enable) AddressDelay <= {C_Address[31:2],{2'b00}};
        else AddressDelay <= AddressDelay;
    end
   
   //Read
   LinefillBuffer lfb (
   .Clk(Clk),
   .Enable(LB_Enable),
   .Address(AddressDelay), //start adress // Always ignore address' which are not aligned
   .BaseAddress(LB_Output_Addr), //saved start adress
   .LineReadCompleted(LB_LineReadCompleted), // read a whole line
   .Line(LB_ReadLine), //read line
   .CriticalWord(LB_CriticalWord), // critical word = mem[BaseAddress]
   .FirstDataAcquired(LB_FirstDataAcquired), //received the first word (critical word)
   .AXIStartRead(start_read_wire), //start AXI reading
   .RequestAttended(NewWordAvailable),
   .Data(ReadData) //Read word from memory
   );
   
   //Write
   LineWriteBuffer lwb (
   .Clk(Clk),
   .Enable(LW_Enable),
   .Data(LW_CacheLineToWrite),
   .Address(LineWriteBufAddr), 
   .AXICompleted(WriteCompleted),
   .AXIData(LW_AXIData),
   .AXIAddr(LW_Output_Addr),
   .AXIStartWrite(start_write_wire),
   .LW_Completed(LW_Completed)
   );

    // Instantiation of Axi Bus Interface M00_AXI
    AXIMaster #( 
            .C_M_TARGET_SLAVE_BASE_ADDR(C_M00_AXI_TARGET_SLAVE_BASE_ADDR),
            .C_M_AXI_ID_WIDTH(C_M00_AXI_ID_WIDTH),
            .C_M_AXI_ADDR_WIDTH(C_M00_AXI_ADDR_WIDTH),
            .C_M_AXI_DATA_WIDTH(C_M00_AXI_DATA_WIDTH),
            .C_M_AXI_AWUSER_WIDTH(C_M00_AXI_AWUSER_WIDTH),
            .C_M_AXI_ARUSER_WIDTH(C_M00_AXI_ARUSER_WIDTH),
            .C_M_AXI_WUSER_WIDTH(C_M00_AXI_WUSER_WIDTH),
            .C_M_AXI_RUSER_WIDTH(C_M00_AXI_RUSER_WIDTH),
            .C_M_AXI_BUSER_WIDTH(C_M00_AXI_BUSER_WIDTH) 
     ) PAXI(
        //.ReadError(ReadError),
        //.WriteError(WriteError),
        .WriteCompleted(P_WriteCompleted),
        .ReadCompleted(P_ReadCompleted),
        .axi_awaddr_input(P_AXIAddr),
        .axi_araddr_input(P_AXIAddr),
        .start_write_wire(P_StartAXIWrite),
        .start_read_wire(P_StartAXIRead),
        .R_isCache(0),
        .W_isCache(0),
        .WriteData(P_WriteData),
        .ReadData(P_ReadData),
        //.ValidReadData(ValidReadData),
        .M_AXI_ACLK(Clk),
        .M_AXI_ARESETN(NotRst),
        .M_AXI_AWID(m00_axi_awid),
        .M_AXI_AWADDR(m00_axi_awaddr),
        .M_AXI_AWLEN(m00_axi_awlen),
        .M_AXI_AWSIZE(m00_axi_awsize),
        .M_AXI_AWBURST(m00_axi_awburst),
        .M_AXI_AWLOCK(m00_axi_awlock),
        .M_AXI_AWCACHE(m00_axi_awcache),
        .M_AXI_AWPROT(m00_axi_awprot),
        .M_AXI_AWQOS(m00_axi_awqos),
        .M_AXI_AWUSER(m00_axi_awuser),
        .M_AXI_AWVALID(m00_axi_awvalid),
        .M_AXI_AWREADY(m00_axi_awready),
        .M_AXI_WDATA(m00_axi_wdata),
        .M_AXI_WSTRB(m00_axi_wstrb),
        .M_AXI_WLAST(m00_axi_wlast),
        .M_AXI_WUSER(m00_axi_wuser),
        .M_AXI_WVALID(m00_axi_wvalid),
        .M_AXI_WREADY(m00_axi_wready),
        .M_AXI_BID(m00_axi_bid),
        .M_AXI_BRESP(m00_axi_bresp),
        .M_AXI_BUSER(m00_axi_buser),
        .M_AXI_BVALID(m00_axi_bvalid),
        .M_AXI_BREADY(m00_axi_bready),
        .M_AXI_ARID(m00_axi_arid),
        .M_AXI_ARADDR(m00_axi_araddr),
        .M_AXI_ARLEN(m00_axi_arlen),
        .M_AXI_ARSIZE(m00_axi_arsize),
        .M_AXI_ARBURST(m00_axi_arburst),
        .M_AXI_ARLOCK(m00_axi_arlock),
        .M_AXI_ARCACHE(m00_axi_arcache),
        .M_AXI_ARPROT(m00_axi_arprot),
        .M_AXI_ARQOS(m00_axi_arqos),
        .M_AXI_ARUSER(m00_axi_aruser),
        .M_AXI_ARVALID(m00_axi_arvalid),
        .M_AXI_ARREADY(m00_axi_arready),
        .M_AXI_RID(m00_axi_rid),
        .M_AXI_RDATA(m00_axi_rdata),
        .M_AXI_RRESP(m00_axi_rresp),
        .M_AXI_RLAST(m00_axi_rlast),
        .M_AXI_RUSER(m00_axi_ruser),
        .M_AXI_RVALID(m00_axi_rvalid),
        .M_AXI_RREADY(m00_axi_rready)
    );
    
    // Instantiation of Axi Bus Interface M01_AXI
    AXIMaster #( 
            .C_M_TARGET_SLAVE_BASE_ADDR(C_M01_AXI_TARGET_SLAVE_BASE_ADDR),
            .C_M_AXI_ID_WIDTH(C_M01_AXI_ID_WIDTH),
            .C_M_AXI_ADDR_WIDTH(C_M01_AXI_ADDR_WIDTH),
            .C_M_AXI_DATA_WIDTH(C_M01_AXI_DATA_WIDTH),
            .C_M_AXI_AWUSER_WIDTH(C_M01_AXI_AWUSER_WIDTH),
            .C_M_AXI_ARUSER_WIDTH(C_M01_AXI_ARUSER_WIDTH),
            .C_M_AXI_WUSER_WIDTH(C_M01_AXI_WUSER_WIDTH),
            .C_M_AXI_RUSER_WIDTH(C_M01_AXI_RUSER_WIDTH),
            .C_M_AXI_BUSER_WIDTH(C_M01_AXI_BUSER_WIDTH) 
     ) CAXI(
        //.ReadError(ReadError),
        //.WriteError(WriteError),
        .WriteCompleted(WriteCompleted),
        .ReadCompleted(ReadCompleted),
        .axi_awaddr_input(LW_Output_Addr),
        .axi_araddr_input(LB_Output_Addr),
        .start_write_wire(start_write_wire),
        .start_read_wire(start_read_wire),
        .R_isCache(1),
        .W_isCache(1),
        .WriteData(LW_AXIData),
        .ReadData(ReadData),
        .ValidReadData(NewWordAvailable),
        .M_AXI_ACLK(Clk),
        .M_AXI_ARESETN(NotRst),
        .M_AXI_AWID(m01_axi_awid),
        .M_AXI_AWADDR(m01_axi_awaddr),
        .M_AXI_AWLEN(m01_axi_awlen),
        .M_AXI_AWSIZE(m01_axi_awsize),
        .M_AXI_AWBURST(m01_axi_awburst),
        .M_AXI_AWLOCK(m01_axi_awlock),
        .M_AXI_AWCACHE(m01_axi_awcache),
        .M_AXI_AWPROT(m01_axi_awprot),
        .M_AXI_AWQOS(m01_axi_awqos),
        .M_AXI_AWUSER(m01_axi_awuser),
        .M_AXI_AWVALID(m01_axi_awvalid),
        .M_AXI_AWREADY(m01_axi_awready),
        .M_AXI_WDATA(m01_axi_wdata),
        .M_AXI_WSTRB(m01_axi_wstrb),
        .M_AXI_WLAST(m01_axi_wlast),
        .M_AXI_WUSER(m01_axi_wuser),
        .M_AXI_WVALID(m01_axi_wvalid),
        .M_AXI_WREADY(m01_axi_wready),
        .M_AXI_BID(m01_axi_bid),
        .M_AXI_BRESP(m01_axi_bresp),
        .M_AXI_BUSER(m01_axi_buser),
        .M_AXI_BVALID(m01_axi_bvalid),
        .M_AXI_BREADY(m01_axi_bready),
        .M_AXI_ARID(m01_axi_arid),
        .M_AXI_ARADDR(m01_axi_araddr),
        .M_AXI_ARLEN(m01_axi_arlen),
        .M_AXI_ARSIZE(m01_axi_arsize),
        .M_AXI_ARBURST(m01_axi_arburst),
        .M_AXI_ARLOCK(m01_axi_arlock),
        .M_AXI_ARCACHE(m01_axi_arcache),
        .M_AXI_ARPROT(m01_axi_arprot),
        .M_AXI_ARQOS(m01_axi_arqos),
        .M_AXI_ARUSER(m01_axi_aruser),
        .M_AXI_ARVALID(m01_axi_arvalid),
        .M_AXI_ARREADY(m01_axi_arready),
        .M_AXI_RID(m01_axi_rid),
        .M_AXI_RDATA(m01_axi_rdata),
        .M_AXI_RRESP(m01_axi_rresp),
        .M_AXI_RLAST(m01_axi_rlast),
        .M_AXI_RUSER(m01_axi_ruser),
        .M_AXI_RVALID(m01_axi_rvalid),
        .M_AXI_RREADY(m01_axi_rready)
    );
    
      Icache_AXIMaster #(
        .C_M02_AXI_ID_WIDTH(C_M02_AXI_ID_WIDTH),  // Thread ID Width
        .C_M02_AXI_ADDR_WIDTH(C_M02_AXI_ADDR_WIDTH),  // Width of Address Bus
        .C_M02_AXI_DATA_WIDTH(C_M02_AXI_DATA_WIDTH),  // Width of Data Bus
        .C_M02_AXI_AWUSER_WIDTH(C_M02_AXI_AWUSER_WIDTH),  // Width of User Write Address Bus
        .C_M02_AXI_ARUSER_WIDTH(C_M02_AXI_ARUSER_WIDTH),  // Width of User Read Address Bus
        .C_M02_AXI_WUSER_WIDTH(C_M02_AXI_WUSER_WIDTH),  // Width of User Write Data Bus
        .C_M02_AXI_RUSER_WIDTH(C_M02_AXI_RUSER_WIDTH),  // Width of User Read Data Bus
        .C_M02_AXI_BUSER_WIDTH(C_M02_AXI_BUSER_WIDTH),  // Width of User Response Bus
        .CACHE_LINE_NO(CACHE_LINE_NO),
        .CACHE_LINE_SIZE(CACHE_LINE_SIZE),
        .BURST_TYPE(BURST_TYPE)
      ) inst (
        .miss(icache_bus_i[`IBUSO_MISS]),
        .data(icache_bus_i[`IBUSO_DATA]),
        .slave_addr(icache_bus_o[`IBUSI_ADDR]),
        .m02_axi_awid(m02_axi_awid),
        .m02_axi_awaddr(m02_axi_awaddr),
        .m02_axi_awlen(m02_axi_awlen),
        .m02_axi_awsize(m02_axi_awsize),
        .m02_axi_awburst(m02_axi_awburst),
        .m02_axi_awlock(m02_axi_awlock),
        .m02_axi_awcache(m02_axi_awcache),
        .m02_axi_awprot(m02_axi_awprot),
        .m02_axi_awqos(m02_axi_awqos),
        .m02_axi_awuser(),
        .m02_axi_awvalid(m02_axi_awvalid),
        .m02_axi_awready(m02_axi_awready),
        .m02_axi_wdata(m02_axi_wdata),
        .m02_axi_wstrb(m02_axi_wstrb),
        .m02_axi_wlast(m02_axi_wlast),
        .m02_axi_wuser(),
        .m02_axi_wvalid(m02_axi_wvalid),
        .m02_axi_wready(m02_axi_wready),
        .m02_axi_bid(m02_axi_bid),
        .m02_axi_bresp(m02_axi_bresp),
        .m02_axi_buser(1'B0),
        .m02_axi_bvalid(m02_axi_bvalid),
        .m02_axi_bready(m02_axi_bready),
        .m02_axi_arid(m02_axi_arid),
        .m02_axi_araddr(m02_axi_araddr),
        .m02_axi_arlen(m02_axi_arlen),
        .m02_axi_arsize(m02_axi_arsize),
        .m02_axi_arburst(m02_axi_arburst),
        .m02_axi_arlock(m02_axi_arlock),
        .m02_axi_arcache(m02_axi_arcache),
        .m02_axi_arprot(m02_axi_arprot),
        .m02_axi_arqos(m02_axi_arqos),
        .m02_axi_aruser(),
        .m02_axi_arvalid(m02_axi_arvalid),
        .m02_axi_arready(m02_axi_arready),
        .m02_axi_rid(m02_axi_rid),
        .m02_axi_rdata(m02_axi_rdata),
        .m02_axi_rresp(m02_axi_rresp),
        .m02_axi_rlast(m02_axi_rlast),
        .m02_axi_ruser(1'B0),
        .m02_axi_rvalid(m02_axi_rvalid),
        .m02_axi_rready(m02_axi_rready),
        .m02_axi_aclk(Clk),
        .m02_axi_aresetn(NotRst)
      );
    
endmodule
