`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/12/2016 04:08:26 PM
// Design Name: 
// Module Name: PC_Eval
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

module PC_Eval(
	   /*Input data from ID/EX registers*/
    	input [`WIDTH-1:0] i_PC,
    	input [`WIDTH-1:0] i_ALU_rslt,
    	input [`WIDTH-1:0] i_PPC,

	   /*Input Control Signal from Branch Unit*/
    	input i_NPC_Ctrl,

	   /*Output data*/
    	output [`WIDTH-1:0] o_New_PC,    
    	output o_PPC_Eq,
    	
    	/*************VIC*************/
    	//SOLUTION OUTPUT
    	output [`WIDTH-1:0] o_PC_VIC,
    	
    	/*******FROM BRANCH**********/
        input BranchInstr,
        input JumpInstr
    	);
    
    /*New Program Counter Selection*/
    assign o_New_PC = (i_NPC_Ctrl == 1) ? i_PC : i_ALU_rslt;

    /*Check if the result of the predicted PC is equal to the ALU result (1 is equal / 0 not equal)*/
    assign o_PPC_Eq = (i_PPC == i_ALU_rslt);  
    
    //MAYBE A SOLUTION TO VIC
    assign o_PC_VIC = (!(JumpInstr || BranchInstr)) ? i_PC :
                                         o_PPC_Eq   ? i_PC : 
                                         i_ALU_rslt;    
    
endmodule
