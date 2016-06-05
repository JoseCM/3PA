`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/08/2016 02:54:51 PM
// Design Name: 
// Module Name: signExtend
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

`include "defines.vh"

module signExtend(
    input [1:0] msb,
    input [22:0] imm_i,
    output [31:0] imm_o
    );
    
    assign imm_o =  (msb == `EXT16) ? {{(31-15){imm_i[15]}},imm_i[15:0]} : 
                        (msb == `EXT17) ? {{(31-16){imm_i[16]}},imm_i[16:0]} :
                            (msb == `EXT22) ? {{(31-21){imm_i[21]}},imm_i[21:0]} : 
                                (msb == `EXT23) ? {{(31-22){imm_i[22]}},imm_i[22:0]} : 0;
    
endmodule
