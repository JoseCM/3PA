`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.05.2016 09:11:22
// Design Name: 
// Module Name: Controller
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


module PeriphController(
    input Clk,
    input RW,
    input En,
    input PeripheralAccess,
    output Stall,
    output StartAXIRead,
    output StartAXIWrite,
    input WriteCompleted,
    input ReadCompleted,
    input [31:0] oAddress,
    input [31:0] LB_LineAddres
    );
    
   parameter [1:0] IDLE = 0,
             R_BUSY = 1,
             W_BUSY = 2;           
   reg [1:0] state; 
   reg Done;
   
   assign StartAXIRead  =  (!RW && En && !Done) ? 1 : 0;
   assign StartAXIWrite = (RW && En && !Done) ? 1 : 0;
   
   assign Stall = (PeripheralAccess && !ReadCompleted && !WriteCompleted ) ? 1 : 0;
   
   always @(posedge Clk) begin
    if(!En) begin
        state <= IDLE;
        Done  <= 0;
    end
    else
        case (state) 
        IDLE:
            if(!RW && PeripheralAccess) begin
                state <= R_BUSY;
                Done  <= 1;
            end
            else if (RW && PeripheralAccess) begin
                state <= W_BUSY;
                Done  <= 1;
            end
            else begin 
                state <= IDLE;
                
            end
        R_BUSY: begin
                if(ReadCompleted) begin
                    state <= IDLE;
                    Done  <= 0;
                end
            end
        W_BUSY: begin
                if(WriteCompleted) begin      
                    state <= IDLE;
                    Done  <= 0;
                end
            end
    endcase
   end
    
endmodule
