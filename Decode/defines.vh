`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2016 01:02:45 PM
// Design Name: 
// Module Name: defines
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

`ifndef _DEFINES_
`define _DEFINES_


/* sign extend ctrl bits */
`define EXT16 2'b00
`define EXT17 2'b01
`define EXT22 2'b10
`define EXT23 2'b11

/*IR parameters*/
`define RS1       21:17
`define RS2       15:11
`define RST       26:22
`define RDst      26:22
`define IMM       22:0
`define OPCODE    31:27
`define CondBits  26:23

/*OPCODE*/
`define	NOP	5'd0
`define	ADD	5'd1
`define	SUB	5'd2
`define	OR	5'd3
`define	AND	5'd4
`define	NOT	5'd5
`define XOR 5'd6
`define	CMP	5'd7
`define	BXX	5'd8
`define	JMP	5'd9
`define	LD	5'd10
`define	LDI	5'd11
`define	LDX	5'd12
`define	ST	5'd13
`define	STX	5'd14
`define	MUL	5'd15
`define	DIV	5'd16
`define	ASR	5'd17
`define	ASL	5'd18
`define	LSR	5'd19
`define	LSL	5'd20
`define RETI 5'd21
`define	HLT	5'd31

`endif