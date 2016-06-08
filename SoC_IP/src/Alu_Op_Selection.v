`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/12/2016 03:25:35 PM
// Design Name: 
// Module Name: Alu_Op_Selection
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

`define WIDTH 32


module Alu_Op_Selection( 

    	/*Inputs from ID/EX registers*/
	input [`WIDTH-1:0] i_Data_From_MEM,
	input [`WIDTH-1:0] i_Data_From_WB,  
	input [`WIDTH-1:0] i_Data_From_vWB,  
	input [`WIDTH-1:0] i_Rs1,
	input [`WIDTH-1:0] i_Rs2,
	input [`WIDTH-1:0] i_Immediate,  
	input [`WIDTH-1:0] i_PC, 
	
	/*Input Control Signals from Forward Unit*/
	input [1:0] i_Fwrd_Ctrl1, 
	input [1:0] i_Fwrd_Ctrl2, 
	
	/*Input Control Signals from Control Unit*/
	input [1:0] i_ALU_src1_Ctrl, 
	input i_ALU_src2_Ctrl,
	
    /*Output Data */
    output reg [`WIDTH-1:0] o_Op1,
    output [`WIDTH-1:0] o_Op2,
    output [`WIDTH-1:0] o_Store_Data
);

/*Internal registers first muxes to second muxes*/
reg [`WIDTH-1:0] r_Alu_Src1; 
reg [`WIDTH-1:0] r_Alu_Src2;

/*ALU second input selection*/
assign o_Op2 = (i_ALU_src2_Ctrl == 0) ? r_Alu_Src2 : i_Immediate;

/*Bypass data to store in memory (Store instruction)*/
assign o_Store_Data = r_Alu_Src2;

always @(*)
    begin
	/*Second muxes inputs selections*/
        case(i_Fwrd_Ctrl1)
            2'b00   :   r_Alu_Src1 <= i_Rs1;
            2'b01   :   r_Alu_Src1 <= i_Data_From_WB;
            2'b10   :   r_Alu_Src1 <= i_Data_From_MEM;
            2'b11   :   r_Alu_Src1 <= i_Data_From_vWB;
            default: r_Alu_Src1 <= 0;
        endcase

        case(i_Fwrd_Ctrl2)
            2'b00   :   r_Alu_Src2 <= i_Rs2;
            2'b01   :   r_Alu_Src2 <= i_Data_From_WB;
            2'b10   :   r_Alu_Src2 <= i_Data_From_MEM;
            2'b11   :   r_Alu_Src2 <= i_Data_From_vWB;
            default: r_Alu_Src2 <= 0;
        endcase

	/*ALU first input selection*/
        case(i_ALU_src1_Ctrl)
            2'b00   :   o_Op1 <= r_Alu_Src1;
            2'b01   :   o_Op1 <= i_PC;
            2'b10   :   o_Op1 <= 0;
            default: o_Op1 <= 0;
        endcase
        
    end
    
endmodule
