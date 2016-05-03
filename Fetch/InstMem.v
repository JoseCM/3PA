`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/08/2016 11:16:18 AM
// Design Name: 
// Module Name: InstMem
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

module ROM(
    input Clk,
    input Rst,
    input En,
    input [31:0] Addr,
    output [31:0] Data,
    output Imiss 
);


wire [31:0] o_rom;
wire [5:0] Address_LSBs;


//assign Address_LSBs = Addr[5:0] / 32'h4;

rom rom(
    .a(Addr[7:2]),
    .spo(o_rom)
);
 
//reg [31:0] mem[255:0];

assign Data =   (Rst)     ?     0:  
                (En)      ?     o_rom: 
                                Data;
assign Imiss = 0;                          
/*initial
      $readmemh("v.out",mem);    // init memory
      */
endmodule
