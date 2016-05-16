`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.04.2016 11:35:38
// Design Name: 
// Module Name: processor_tb
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


module processor_tb(
    );
    
    reg Clk;
    reg Rst;
    
    processor uut
    (
       .Clk(Clk),
       .Rst(Rst)
    );
    
    initial
    begin
        Clk=0;
        Rst=1;
        #10
        Rst = 0;
        
        #1000
        $finish;
    end
    
   always #5 Clk=~Clk;
    
    
endmodule
