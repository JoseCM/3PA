`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/10/2016 11:15:17 PM
// Design Name: 
// Module Name: PredictCache
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

//`define PPC         PPC_CB[31:0]         //Predicted PC
//`define CB          PPC_CB[33:32]        //Control bits


`define IAddr           66:35           //Instruction Addr
`define IAddrWidth      32              //Instruction Address width
//`define PPC_CB        34:1            //PredictionPC and CB
//`define PPC_CB        34:1            //PredictionPC and CB width
`define PPC             34:3            //Prediction PC
`define PPCWidth        32              //Prediction PC width
`define CB              2:1             //Control Bits
`define CBWidth         2               //Control Bits width 
`define Valid           0               //Valid bit
`define ValidWidth      1               //Valid bit width

`define CacheWidth      (`IAddrWidth + `PPCWidth + `CBWidth + `ValidWidth)             //Cache width

`define CacheNumLines   8               //Number of cache lines 
`define CacheAddrBits   2:0             //Cache Addressing bits

module PredictCache(
    input Rst,
    input Clk,
    input [31:0] RAddr,         //Mem?ria/endere?o da instru??o atual a ser lida da cache
    input [31:0] WAddr,         //endere?o de mem?ria da instru??o a ser escrita na cache
    input WE,                   //Sinal para permitir a escrita na cache
    input [1:0] Instr_new_CB,   //Novos valores da estrat?gia de previs?o a ser usada para a instru??o a ser escrita
    input [31:0] Data,          //Endere?o destino relativo ? instru??o de salto a ser escrita 
    output wire [33:0] PPC_CB,  //PPC and CB
    output PC_Source,            //1-Usar o Prediction PC 0-Usar o PC+4
    output PCMatch              //PCMatch && valid value
    );

reg [`CacheWidth-1:0] cache [`CacheNumLines-1:0];   //cache de CacheWidth bits com CacheLines linhas(endere??vel a 3 bits)
wire [`CacheWidth-1:0] RcacheLine;               //Cache line que est? a ser lida

//wire [2:0] WcacheLine = WAddr[`CacheAddrBits]; //Cache line respetiva ao Write Address

assign RcacheLine = cache[RAddr[`CacheAddrBits]];     //Conter? sempre o valor lido da cache line respetiva aos LSB CacheAddrBits de RAddr 

assign PC_Source = ((RAddr == RcacheLine[`IAddr]) && ((RcacheLine[`CB] == 2'b10) || (RcacheLine[`CB] == 2'b11)) && (RcacheLine[`Valid]));
     
assign PCMatch =  (RAddr == RcacheLine[`IAddr]) && (RcacheLine[`Valid]);
                                                                                                                   
assign PPC_CB = {RcacheLine[`PPC],RcacheLine[`CB]};

integer i;

always@(posedge Clk) begin
    if(Rst)
        begin
            //Falta limpar as outras linhas da cache
            for (i=0; i<`CacheNumLines;i=i+1)
                cache[i] <= {(`CacheWidth-1){1'd0}};
        end
    else if (WE)
        cache[WAddr[`CacheAddrBits]] = {WAddr,Data,Instr_new_CB,1'b1}; 
end
    
endmodule
