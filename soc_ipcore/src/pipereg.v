`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.04.2016 15:59:15
// Design Name: 
// Module Name: pipereg
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
////////////////////////////////////////////////////////////////////////////////

module  pipereg (
        input clk,
        input rst,
        input flush,
        input stall,
        input [WIDTH-1:0] in,
        output reg [WIDTH-1:0] out
    );
    
    parameter WIDTH = 32;
    
    always @(posedge clk)
    begin
    if(rst)
       out <= {WIDTH{1'b0}};
    else 
       out <= stall == 1 ? out :
              flush == 1 ? {WIDTH{1'b0}}  :
                           in  ;
    end
    
endmodule
