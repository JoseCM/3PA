`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.05.2016 16:06:22
// Design Name: 
// Module Name: soc_tb
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


module soc_tb(

    );
    
    reg Clk;
    reg Rst;
    reg [30:0] i_ext;
    
    soc uut
    (
       .Clk(Clk),
       .Rst(Rst),
       .i_ext(i_ext)
    );
    
    initial
    begin
        i_ext = 31'h00000000;
        Clk=0;
        Rst=1;
	i_ext[3]=1;
        #10
        Rst = 0;
       
       #300 i_ext[1]=1;
       #4  i_ext[1]=0;
       #10 i_ext[8]=1;
       i_ext[2]=1;
       #15 i_ext[8]=0;
       #10 i_ext[2]=0;


       
        #1000
        $finish;
    end
    
   always #5 Clk=~Clk;
        
endmodule
