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
`include "pipelinedefs.v"

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
    parameter integer C_M00_AXI_BUSER_WIDTH    = 0
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
    output wire  m00_axi_rready
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
    .P_ReadCompleted(P_ReadCompleted)
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
    
   ROM inst_mem(
     .Clk(Clk),                                                   
     .Rst(Rst),                                                   
     .En(1), 
     //changes                                                 
     .Addr(icache_bus_o[`IBUSI_ADDR]),                                                    
     .Data(icache_bus_i[`IBUSO_DATA]),
     .Imiss(icache_bus_i[`IBUSO_MISS])                                                         
    );
    
    
endmodule
