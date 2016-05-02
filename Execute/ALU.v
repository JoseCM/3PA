`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Compilas 
// Group n�4  
// 
// Create Date: 04/11/2016 09:03:50 PM
// Design Name: Vespa
// Module Name: ALU
// Project Name: Cenas
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

//Operations Signal Specification
`define ALU_NOP 3'b000 
`define ALU_ADD 3'b001
`define ALU_SUB 3'b010
`define ALU_OR  3'b011
`define ALU_AND 3'b100
`define ALU_NOT 3'b101
`define ALU_XOR 3'b110

//Condition Codes Index Definition
`define ZERO 0
`define NEGATIVE 1
`define CARRY 2
`define OVERFLOW 3 

module ALU(
    input clk,
    /* Input Operands */
    input [`WIDTH-1:0] i_Op1,
    input [`WIDTH-1:0] i_Op2,
    
    /* Ctrl Signals */
    input i_CC_WE,           // Condition Code Write Enable
    input [2:0] i_ALU_Ctrl, // Alu operation control signals
    
    /*reset signal*/
    input reset,

    /* Outputs */
    output reg [`WIDTH-1:0] ro_ALU_rslt, 
    output reg [3:0] ro_CCodes
    );
    
    reg c; //Auxiliar to carry out determination
    wire subt = (i_ALU_Ctrl == `ALU_SUB); //In case it's a subb operation
 

   
    always@(posedge clk)
    begin
        if (reset)
        begin
            ro_CCodes[`ZERO]        <= 0;
            ro_CCodes[`NEGATIVE]    <= 0;
            ro_CCodes[`CARRY]       <= 0;
            ro_CCodes[`OVERFLOW]    <= 0;        
        end
        /*CARRY -> UNSIGNEDS........OVERFLOWS -> SIGNEDS*/
        else if(i_CC_WE)
        begin
            ro_CCodes[`ZERO] <= (~( |ro_ALU_rslt[`WIDTH-1:0]));
            ro_CCodes[`NEGATIVE] <=  ro_ALU_rslt[`WIDTH-1];
            ro_CCodes[`CARRY] <= c & ((i_ALU_Ctrl == `ALU_ADD) | (i_ALU_Ctrl == `ALU_SUB));
            ro_CCodes[`OVERFLOW] <=  ((ro_ALU_rslt[`WIDTH-1] & ~i_Op1[`WIDTH-1] & ~(subt^i_Op2[`WIDTH-1])) | (~ro_ALU_rslt[`WIDTH-1] & i_Op1[`WIDTH-1] & (subt^i_Op2[`WIDTH-1])));        
            //~reset & ( (ro_ALU_rslt[`WIDTH-1] & ~i_Op1[`WIDTH-1] & ~(subt^i_Op2[`WIDTH-1])) | (~ro_ALU_rslt[`WIDTH-1] & i_Op1[`WIDTH-1] & (subt^i_Op2[`WIDTH-1])))  & ((i_ALU_Ctrl == `ALU_ADD) | (i_ALU_Ctrl == `ALU_SUB));
        end
    end
    
    always@(*)
     case (i_ALU_Ctrl)
        `ALU_NOP: ro_ALU_rslt <= 32'b0;
        `ALU_ADD: {c,ro_ALU_rslt} <= i_Op1 + i_Op2;
        `ALU_SUB: {c,ro_ALU_rslt} <= i_Op1 - i_Op2;
        `ALU_OR: ro_ALU_rslt <= i_Op1 | i_Op2;
        `ALU_AND: ro_ALU_rslt <= i_Op1 & i_Op2;
        `ALU_NOT: ro_ALU_rslt <= ~i_Op1;
        `ALU_XOR: ro_ALU_rslt <= i_Op1 ^ i_Op2;
        default: ro_ALU_rslt <= 32'b0;
     endcase
endmodule
