`timescale 1ns / 1ps
`define WIDTH 32
`define DEPTH 65536

module RAM(
    input Clk,//clock
    input Rst,//reset
    input [15:0] address,//endereço da memória
    input [`WIDTH-1:0] data_in,//dados a escrever na memória
    input rw,//read or write
    input en,//enable read and write
    output [`WIDTH-1:0] data_out,//dados a serem lidos
    output miss// falha no acesso à memória
    );
    
    //Logic to enable IP ram
    wire [`WIDTH-1:0] d_out;
    wire enable;
     
    assign miss = 0;
    assign enable = en && rw;
    assign data_out = (en & ~rw)? d_out : 32'h00000000;
    
    //RAM IP 
    RAM_DM ram_ip(
        .clk(Clk),
        .a(address),
        .d(data_in),
        .spo(d_out),
        .we(enable)
    );         
endmodule
