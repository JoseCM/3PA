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
`define ALU_NOP     4'b0000 
`define ALU_ADD     4'b0001
`define ALU_SUB     4'b0010
`define ALU_OR      4'b0011
`define ALU_AND     4'b0100
`define ALU_NOT     4'b0101
`define ALU_XOR     4'b0110
`define ALU_MUL     4'b0111
`define ALU_DIV     4'b1000
`define ALU_ASR     4'b1001
`define ALU_ASL     4'b1010
`define ALU_LSR     4'b1011
`define ALU_LSL     4'b1100

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
    input [3:0] i_ALU_Ctrl, // Alu operation control signals
    
    /*reset signal*/
    input reset,
    
    /****************VIC*****************/
    input i_VIC_CCodes_ctrl,
    input [3:0] i_VIC_CCodes,

    /* Outputs */
    output reg [`WIDTH-1:0] ro_ALU_rslt, 
    output reg [3:0] ro_CCodes
    );
    
    //reg c; //Auxiliar to carry out determination
    reg [`WIDTH-1:0] AUX_SL ; //Substitute of the previous c register. 
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
        else if(i_CC_WE || i_VIC_CCodes_ctrl)
        begin
            if(i_VIC_CCodes_ctrl)
            begin
                ro_CCodes <= i_VIC_CCodes;
            end
            else begin
                ro_CCodes[`ZERO] <= (~( |ro_ALU_rslt[`WIDTH-1:0]));
                ro_CCodes[`NEGATIVE] <=  ro_ALU_rslt[`WIDTH-1];
                ro_CCodes[`CARRY] <= ((|AUX_SL[`WIDTH-1:0]) & ((i_ALU_Ctrl == `ALU_ADD) | (i_ALU_Ctrl == `ALU_SUB) | (i_ALU_Ctrl == `ALU_ASL) | (i_ALU_Ctrl == `ALU_MUL) | (i_ALU_Ctrl == `ALU_DIV)));
                ro_CCodes[`OVERFLOW] <=  ((ro_ALU_rslt[`WIDTH-1] & ~i_Op1[`WIDTH-1] & ~(subt^i_Op2[`WIDTH-1])) | (~ro_ALU_rslt[`WIDTH-1] & i_Op1[`WIDTH-1] & (subt^i_Op2[`WIDTH-1])));        
                //~reset & ( (ro_ALU_rslt[`WIDTH-1] & ~i_Op1[`WIDTH-1] & ~(subt^i_Op2[`WIDTH-1])) | (~ro_ALU_rslt[`WIDTH-1] & i_Op1[`WIDTH-1] & (subt^i_Op2[`WIDTH-1])))  & ((i_ALU_Ctrl == `ALU_ADD) | (i_ALU_Ctrl == `ALU_SUB));
            end
        end
    end
    
    always@(*)
        case (i_ALU_Ctrl)
            `ALU_NOP: ro_ALU_rslt           <= 32'b0;
            `ALU_ADD: {AUX_SL,ro_ALU_rslt}  <= i_Op1 + i_Op2;
            `ALU_SUB: {AUX_SL,ro_ALU_rslt}  <= i_Op1 - i_Op2;
            `ALU_OR : ro_ALU_rslt           <= i_Op1 | i_Op2;
            `ALU_AND: ro_ALU_rslt           <= i_Op1 & i_Op2;
            `ALU_NOT: ro_ALU_rslt           <= ~i_Op1;
            `ALU_XOR: ro_ALU_rslt           <= i_Op1 ^ i_Op2;
            `ALU_MUL: {AUX_SL,ro_ALU_rslt}  <= i_Op1 * i_Op2;
            `ALU_DIV: {AUX_SL,ro_ALU_rslt}  <= i_Op1 / i_Op2;
            `ALU_ASR: ro_ALU_rslt           <= $signed(i_Op1) >>> i_Op2[4:0]; //$signed task is synthetizable. Check Coding Guidelines for Datapath Synthesis (Synopsys)
            `ALU_ASL: {AUX_SL,ro_ALU_rslt}  <= $signed(i_Op1) <<< i_Op2[4:0];
            `ALU_LSR: ro_ALU_rslt           <= i_Op1 >> i_Op2;
            `ALU_LSL: ro_ALU_rslt           <= i_Op1 << i_Op2;
            default:  ro_ALU_rslt           <= 32'b0;
        endcase
endmodule
