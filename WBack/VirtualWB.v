`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.05.2016 20:18:11
// Design Name: 
// Module Name: VirtualWB
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

`include "pipelinedefs.vh"

`define WIDTH 32

module VirtualWB(
        input clk,
        input rst,
        input [4:0]i_vwb_rdst,               // Register to save data in RegFile
        input i_vwb_reg_write_rf,            // Control signal that allows the writing in the RegFile
        input [`WIDTH-1:0] i_vwb_mux,        // Output of the WB
        output reg [4:0]o_vwb_rdst,               // Register to save data in RegFile one clock late
        output reg o_vwb_reg_write_rf,            // Control signal that allows the writing in the RegFile one clock late
        output reg [`WIDTH-1:0] o_vwb_mux        // Output of the WB one clock late
    );
    
    always @(posedge clk)
    begin
        if(rst) begin
            o_vwb_rdst <= 0;
            o_vwb_reg_write_rf <= 0;
            o_vwb_mux <= 0;
            end
        else begin
            o_vwb_rdst <= i_vwb_rdst;
            o_vwb_reg_write_rf <= i_vwb_reg_write_rf;
            o_vwb_mux <= i_vwb_mux;
            end
    end
endmodule
