`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/08/2016 04:55:41 PM
// Design Name: 
// Module Name: testbench
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

`include "defines.v"

module SignExtend_tb(

    );
    reg clk;
    reg reset;
    
/*sign extend test*/
    reg [22:0] immed_i;
    reg [1:0] msb;
    wire [31:0] immed_o;
    
    signExtend sExt(
        .msb(msb),
        .imm_i(immed_i),
        .imm_o(immed_o)
    );
    
    initial
    begin
        $display("**Testing Sign Extension**");

        immed_i = 23'h8000;
        msb = `EXT16;
        #0;
        $write("\t*Testing 16bit sign extension: ");
        if(immed_o == 32'hffff8000)
            $display("successful!");
        else
            $display("unsuccessful... %x", immed_o);
        
        #10
        immed_i = 23'h10000;
        msb = `EXT17;
        #0;
        $write("\t*Testing 17bit sign extension: ");
        if(immed_o == 32'hffff0000)
           $display("successful!");
        else
           $display("unsuccessful...");
            
        #10
        immed_i = 23'h200000;
        msb = `EXT22;
        #0;
        $write("\t*Testing 22bit sign extension: ");
        if(immed_o == 32'hffe00000)
            $display("successful!");
        else
            $display("unsuccessful...");
        
        #10
        immed_i = 23'h400000;
        msb = `EXT23;
        #0;
        $write("\t*Testing 23bit sign extension: ");
        if(immed_o == 32'hffc00000)
            $display("successful!");
        else
            $display("unsuccessful...");        
        #10
        $finish;
    end
    always #5 clk = ~clk;
    
endmodule
