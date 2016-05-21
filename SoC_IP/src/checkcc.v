`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.04.2016 11:42:46
// Design Name: 
// Module Name: checkcc
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

// Define the conditions available in a conditional branch.

`define	BRA	4'b0000 //branch always
`define	BNV	4'b1000 //branch never
`define	BCC	4'b0001 //branch on carry clear 
`define	BCS	4'b1001 //branch on carry set
`define	BVC	4'b0010 //branch on overflow clear
`define	BVS	4'b1010 //branch on overflow set
`define	BEQ	4'b0011 //branch equal 
`define	BNE	4'b1011 //branch not equal
`define	BGE	4'b0100 //branch greater or equal
`define	BLT	4'b1100 //branch less
`define	BGT	4'b0101 //branch greater
`define	BLE	4'b1101 //branch less or equal
`define	BPL	4'b0110 //branch plus
`define	BMI	4'b1110 //branch minus

`define z 0
`define n 1
`define c 2
`define v 3

module checkcc(
    input [3:0]cc4,			// The condition code bits
    input [3:0]cond_bits,
    output branch_taken
    );

    assign branch_taken = (cond_bits == `BRA)?  1 : 
        (cond_bits == `BNV)? 0 : 
        (cond_bits == `BCC)? ~cc4[`c] :
        (cond_bits == `BCS)? cc4[`c] :
        (cond_bits == `BVC)? ~cc4[`v] :
        (cond_bits == `BVS)? cc4[`v] :
        (cond_bits == `BEQ)? cc4[`z] :
        (cond_bits == `BNE)? ~cc4[`z] : 
        (cond_bits == `BGE)? (~cc4[`n] & ~cc4[`v]) | (cc4[`n] & cc4[`v]) :  
        (cond_bits == `BLT)? (cc4[`n] & ~cc4[`v]) | (~cc4[`n] & cc4[`v]) : 
        (cond_bits == `BGT)? ~cc4[`z] & ((~cc4[`n] & ~cc4[`v]) | (cc4[`n] & cc4[`v])) : 
        (cond_bits == `BLE)? cc4[`z] | ((cc4[`n] & ~cc4[`v]) | (~cc4[`n] & cc4[`v])) : 
        (cond_bits == `BPL)? ~cc4[`n] :
        (cond_bits == `BMI)? cc4[`n] : 0;
        
endmodule
