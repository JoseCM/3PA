`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.04.2016 14:28:41
// Design Name: 
// Module Name: stageMA
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
`define WIDTH   32
`include "pipelinedefs.v"

module stageMA(

    input clk,//clock
    input rst,//reset
    input [2:0]  i_ma_WB,//write_back control signal
    input [1:0]  i_ma_MA,//memory access control signals
    input [`WIDTH-1:0] i_ma_ALU_rslt,// resultado da ALU
    input [`WIDTH-1:0] i_ma_Rs2_val, //valor do regiter source 2
    input [4:0] i_ma_Rs2_addr, //endere?o do registo do register source 2
    input [`WIDTH-1:0] i_ma_PC, //program counter
    input [4:0] i_ma_Rdst, //registo de destino
    input [`WIDTH-1:0] i_ma_mux_wb,//resultado do write back (forwarding)
    input i_OP1_MemS, //forwrding unit signal
    input i_ma_flush,
    input i_ma_stall,
    
    output [`WIDTH-1:0] o_ma_PC, //program counter para ser colocado no pipeline register MA/WB
    output [4:0] o_ma_Rdst, //endere�o do registo de sa�da
    output [`WIDTH-1:0] o_ma_ALU_rslt, //resultado do ALU a ser colocado no pipeline register MA/WB
    output [2:0] o_ma_WB, //sinais de controlo da write back a serem colocados no pipeline register MA/WB
    output [4:0] o_ma_EX_MEM_Rs2,//colocar o endere�o do source register 2 na forward unit,
    output [1:0] o_ma_EX_MEM_MA,
    output o_miss, // falha no acesso de mem�ria
    output [`WIDTH-1:0] o_ma_mem_out
    
    );
    
    wire[`WIDTH-1:0] ma_PC; //program counter para ser colocado no pipeline register MA/WB
    wire[4:0] ma_Rdst; //endere?o do registo de sa?da
    wire [`WIDTH-1:0] ma_ALU_rslt; //resultado do ALU a ser colocado no pipeline register MA/WB
    wire [`WIDTH-1:0] mem_data;
    wire [2:0] ma_WB; //sinais de controlo da write back a serem colocados no pipeline register MA/WB
    wire [`MAWB_WIDTH-1:0] o_ma;
    
    MemoryAccess memory_access(
        //inputs
        .Clk(clk),
        .Rst(rst),
        .WB_in(i_ma_WB),
        .MA(i_ma_MA),
        .ALU_rsl_in(i_ma_ALU_rslt),
        .Rs2_val(i_ma_Rs2_val),
        .Rs2_address(i_ma_Rs2_addr),
        .PC_in(i_ma_PC),
        .Rdst_in(i_ma_Rdst),
        .mux_wb(i_ma_mux_wb),
        .OP1_MemS(i_OP1_MemS),
        //outputs
        .PC_out(ma_PC),
        .Rdst_out(ma_Rdst),
        .ALU_rsl_out(ma_ALU_rslt),
        .WB_out(ma_WB),
        .EX_MEM_Rs2(o_ma_EX_MEM_Rs2),
        .EX_MEM_MA(o_ma_EX_MEM_MA),
        .miss(o_miss),
        .mem_out(mem_data)
    );

    pipereg #(`MAWB_WIDTH) MA_WB(
        .clk(clk),
        .rst(rst),
        .flush(i_ma_flush),
        .stall(i_ma_stall),
        .in({ma_Rdst,ma_PC, mem_data, ma_ALU_rslt, ma_WB}),
        .out(o_ma)
    );
    
    assign o_ma_Rdst = o_ma[`MAWB_RDS];
    assign o_ma_PC = o_ma[`MAWB_PC];
    assign o_ma_mem_out = o_ma[`MAWB_MEMOUT];
    assign o_ma_ALU_rslt = o_ma[`MAWB_ALURSLT];
    assign o_ma_WB = o_ma[`MAWB_WB];
    
    
endmodule
