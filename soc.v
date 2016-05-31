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

module soc(
    input Clk,
    input Rst,
    output [0 : 0] m00_axi_awid,
    output [31 : 0] m00_axi_awaddr,
    output [7 : 0] m00_axi_awlen,
    output [2 : 0] m00_axi_awsize,
    output [1 : 0] m00_axi_awburst,
    output m00_axi_awlock,
    output [3 : 0] m00_axi_awcache,
    output [2 : 0] m00_axi_awprot,
    output [3 : 0] m00_axi_awqos,
    output m00_axi_awvalid,
    input m00_axi_awready,
    output [31 : 0] m00_axi_wdata,
    output [3 : 0] m00_axi_wstrb,
    output m00_axi_wlast,
    output m00_axi_wvalid,
    input m00_axi_wready,
    input [0 : 0] m00_axi_bid,
    input [1 : 0] m00_axi_bresp,
    input m00_axi_bvalid,
    output m00_axi_bready,
    output [0 : 0] m00_axi_arid,
    output [31 : 0] m00_axi_araddr,
    output [7 : 0] m00_axi_arlen,
    output [2 : 0] m00_axi_arsize,
    output [1 : 0] m00_axi_arburst,
    output m00_axi_arlock,
    output [3 : 0] m00_axi_arcache,
    output [2 : 0] m00_axi_arprot,
    output [3 : 0] m00_axi_arqos,
    output m00_axi_arvalid,
    input m00_axi_arready,
    input [0 : 0] m00_axi_rid,
    input [31 : 0] m00_axi_rdata,
    input [1 : 0] m00_axi_rresp,
    input m00_axi_rlast,
    input m00_axi_rvalid,
    output m00_axi_rready,
    input m00_axi_aclk,
    input m00_axi_aresetn
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
    
    
    
    RAM ram(
        .Clk(Clk),//clock
        .Rst(Rst),//reset
        .address(dcache_bus_o[`DBUSI_ADDR]),//endere?o da mem?ria a aceder
        .data_in(dcache_bus_o[`DBUSI_DATA]),//dados a escrever
        .rw(dcache_bus_o_ma[`MA_RW]),//read
        .en(dcache_bus_o_ma[`MA_EN]),//write
        .data_out(dcache_bus_i[`DBUSO_DATA] ),//dados de sa?da lidos
        .miss(dcache_bus_i[`DBUSO_MISS])//falha no acesso ? mem?ria
    );
    
    ledmaster_0 icache (
        .miss(icache_bus_i[`IBUSO_MISS]),
        .data(icache_bus_i[`IBUSO_DATA]),
        .slave_addr(icache_bus_o[`IBUSI_ADDR]),
        .m00_axi_awid(m00_axi_awid),
        .m00_axi_awaddr(m00_axi_awaddr),
        .m00_axi_awlen(m00_axi_awlen),
        .m00_axi_awsize(m00_axi_awsize),
        .m00_axi_awburst(m00_axi_awburst),
        .m00_axi_awlock(m00_axi_awlock),
        .m00_axi_awcache(m00_axi_awcache),
        .m00_axi_awprot(m00_axi_awprot),
        .m00_axi_awqos(m00_axi_awqos),
        .m00_axi_awvalid(m00_axi_awvalid),
        .m00_axi_awready(m00_axi_awready),
        .m00_axi_wdata(m00_axi_wdata),
        .m00_axi_wstrb(m00_axi_wstrb),
        .m00_axi_wlast(m00_axi_wlast),
        .m00_axi_wvalid(m00_axi_wvalid),
        .m00_axi_wready(m00_axi_wready),
        .m00_axi_bid(m00_axi_bid),
        .m00_axi_bresp(m00_axi_bresp),
        .m00_axi_bvalid(m00_axi_bvalid),
        .m00_axi_bready(m00_axi_bready),
        .m00_axi_arid(m00_axi_arid),
        .m00_axi_araddr(m00_axi_araddr),
        .m00_axi_arlen(m00_axi_arlen),
        .m00_axi_arsize(m00_axi_arsize),
        .m00_axi_arburst(m00_axi_arburst),
        .m00_axi_arlock(m00_axi_arlock),
        .m00_axi_arcache(m00_axi_arcache),
        .m00_axi_arprot(m00_axi_arprot),
        .m00_axi_arqos(m00_axi_arqos),
        .m00_axi_arvalid(m00_axi_arvalid),
        .m00_axi_arready(m00_axi_arready),
        .m00_axi_rid(m00_axi_rid),
        .m00_axi_rdata(m00_axi_rdata),
        .m00_axi_rresp(m00_axi_rresp),
        .m00_axi_rlast(m00_axi_rlast),
        .m00_axi_rvalid(m00_axi_rvalid),
        .m00_axi_rready(m00_axi_rready),
        .m00_axi_aclk(m00_axi_aclk),
        .m00_axi_aresetn(~m00_axi_aresetn) //Negate if Rst and m00_axi_aresetn are connected
    );
    
//    ROM inst_mem(
//     .Clk(Clk),                                                   
//     .Rst(Rst),                                                   
//     .En(1), 
//     //changes                                                 
//     .Addr(icache_bus_o[`IBUSI_ADDR]),                                                    
//     .Data(icache_bus_i[`IBUSO_DATA]),
//     .Imiss(icache_bus_i[`IBUSO_MISS])                                                         
//    );
    
    
endmodule