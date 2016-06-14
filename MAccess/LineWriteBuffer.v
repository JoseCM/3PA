`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.05.2016 18:12:58
// Design Name: 
// Module Name: LineWriteBuffer
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

/**
TODO: testbench linewritebuffer
*/
module LineWriteBuffer(
    input Clk,
    input Enable,
    input [255:0] Data,
    input [31:0] Address, 
    input  AXICompleted,
    output reg [255:0] AXIData,
    output reg [31:0]  AXIAddr,
    output AXIStartWrite,
    output LW_Completed
    );
    
    parameter [2:0] IDLE=0, WAITING=1;
    reg State;
    reg StartWrite;
    reg FirstEnable;
    
    assign LW_Completed = (WAITING) ? AXICompleted : 0;
    assign AXIStartWrite = StartWrite;
    
    always @(posedge Clk) begin
     if(!Enable) begin
        State <= IDLE;
        StartWrite <= 0;
        FirstEnable <= 1;
     end
     else begin
        case(State)
            IDLE: begin
                if(FirstEnable) begin
                    State <= WAITING;
                    StartWrite <=1;
                    AXIData <= Data;
                    AXIAddr <= Address;
                    FirstEnable <= 0;
                end
            end
            WAITING: begin
                StartWrite <=0;
                if(LW_Completed) begin
                    State <= IDLE;
                end
            end
        endcase
     end
    end 
endmodule
