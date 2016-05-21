`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Student: Nelson Pinto
//
// Create Date: 08.04.2016 11:30:16
// Design Name:
// Module Name: MemoryAccess
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

`include "pipelinedefs.v"

module MemoryAccess(
    input Clk,//clock
    input Rst,//reset
    input [2:0]  WB_in,//write_back control signal
    input [1:0]  MA,//memory access control signals
    input [31:0] ALU_rsl_in,// resultado da ALU
    input [31:0] Rs2_val, //valor do regiter source 2
    input [4:0] Rs2_address, //endere?o do registo do register source 2
    input [31:0] PC_in, //program counter
    input [4:0] Rdst_in, //registo de destino
    input [31:0] mux_wb,//resultado do write back (forwarding)
    input OP1_MemS, //forwrding unit signal
    output[31:0] PC_out, //program counter para ser colocado no pipeline register MA/WB
    output[4:0] Rdst_out, //endere?o do registo de sa?da
    output [31:0] ALU_rsl_out, //resultado do ALU a ser colocado no pipeline register MA/WB
    output [2:0] WB_out, //sinais de controlo da write back a serem colocados no pipeline register MA/WB
    output [4:0] EX_MEM_Rs2,//colocar o endere?o do source register 2 na forward unit,
    output [1:0] EX_MEM_MA,
    output miss, // falha no acesso de mem?ria
    output [31:0] mem_out,
    
    /**************/
    output [65:0] Dcache_bus_out,
    input [32:0] Dcache_bus_in
);

    wire [31:0] data_in;//entra de dados na mem?ria
    wire [31:0] data_out;//sa?da para ser coloca no registo pipeline

    assign WB_out = WB_in; //enviar os sinais de controlo write back para a forwarding unit
    assign PC_out = PC_in; //colocar program counter no registo pipeline seguinte
    assign Rdst_out = Rdst_in;//colocar o registo de destino no pr?ximo registo pipeline
    assign EX_MEM_Rs2 = Rs2_address; //colocar o endere?o do registo de origem 2 forwarding unit
    assign EX_MEM_MA = MA;
    assign data_in = (~OP1_MemS)? Rs2_val : mux_wb; //dependendo do sinal de controlo da forwarding unit, os dados a entrar na mem?ria
                                                         //ser?o do register source 2 ou a sa?da do write back da instru??o anterior
    assign ALU_rsl_out = ALU_rsl_in; //colocar no pr?ximo registo pipeline a sa?da da ALU
    assign mem_out = data_out;
    
    assign Dcache_bus_out = {ALU_rsl_in, data_in, MA};
    assign data_out =  Dcache_bus_in[31:0];
    assign miss = Dcache_bus_in[32];

//    RAM ram(//instacia?O RAM
//        .Clk(Clk),//clock
//        .Rst(Rst),//reset
//        .address(ALU_rsl_in),//endere?o da mem?ria a aceder
//        .data_in(data_in),//dados a escrever
//        .rw(MA[`MA_RW]),//read
//        .en(MA[`MA_EN]),//write
//        .data_out(data_out),//dados de sa?da lidos
//        .miss(miss)//falha no acesso ? mem?ria
//    );



endmodule
