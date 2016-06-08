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

module soc(
    input Clk,
    input Rst,
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