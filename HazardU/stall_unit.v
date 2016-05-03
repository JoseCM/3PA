`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/12/2016 06:40:09 PM
// Design Name: 
// Module Name: stall_unit
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


module Stall_Unit(
    /* Inputs */
    input i_Need_Stall,  // From Forward Unit
    
    input i_DCache_Miss, // From Data Cache in MEM stage
    input i_ICache_Miss, // From Instruction Cache in IF stage
    
    /* Outputs */
     //Stall Signals
    output o_PC_Stall,   // To IF stage
    output o_IFID_Stall, // To IFID pipeline register
    output o_IDEX_Stall, // To IDEX pipeline register
    output o_EXMA_Stall, // To EXMA pipeline register
    
     //Flush Signals
    output o_IFID_Flush, // To flush IFID pipeline register
    output o_IDEX_Flush,
    output o_EXMA_Flush, // To flush EXMA pipleine Register 
    output o_MAWB_Flush // To flush MAWB pipeline register
    );
    
    assign o_PC_Stall = i_Need_Stall | i_DCache_Miss | i_ICache_Miss;
    assign o_IFID_Stall = i_Need_Stall | i_DCache_Miss; 
    assign o_IDEX_Stall = i_Need_Stall | i_DCache_Miss;
    assign o_EXMA_Stall = i_DCache_Miss;
    
    assign o_IFID_Flush = i_ICache_Miss & ~i_Need_Stall & ~i_DCache_Miss;
    assign o_EXMA_Flush = i_Need_Stall & ~i_DCache_Miss;
    assign o_MAWB_Flush = i_DCache_Miss;
    
    assign o_IDEX_Flush = 0; //shouldn't be here
    
endmodule
