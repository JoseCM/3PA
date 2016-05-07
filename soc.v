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
    input Rst
    );
    
    wire [`DBUSI_WIDTH - 1 : 0] dcache_bus_i; 
    wire [`DBUSO_WIDTH - 1 : 0] dcache_bus_o; 
    wire [`MA_WIDTH - 1: 0] dcache_bus_i_ma = dcache_bus_i[`DBUSI_MA];
    
    processor  cpu(
           .Clk(Clk),
           .Rst(Rst),
           
           /***************************/
           .Dcache_bus_out(dcache_bus_o),
           .Dcache_bus_in(dcache_bus_i)         
    );
    
    RAM ram(
            .Clk(Clk),//clock
            .Rst(Rst),//reset
            .address(dcache_bus_i[`DBUSI_ADDR]),//endere?o da mem?ria a aceder
            .data_in(dcache_bus_i[`DBUSI_DATA]),//dados a escrever
            .rw(dcache_bus_i_ma[`MA_RW]),//read
            .en(dcache_bus_i_ma[`MA_EN]),//write
            .data_out(dcache_bus_o[`DBUSO_DATA] ),//dados de sa?da lidos
            .miss(dcache_bus_o[`DBUSO_MISS])//falha no acesso ? mem?ria
    );
    
    
endmodule
