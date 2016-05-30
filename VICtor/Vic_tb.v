`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/18/2016 02:37:09 PM
// Design Name: 
// Module Name: Vic_tb
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


module Vic_tb(

    );
    
   reg clk;
   reg rst;
   reg [31:0] i_PC;    
   reg [3:0] i_VIC_data;
   reg [4:0] i_VIC_regaddr;
   reg i_VIC_we;
   reg [30:0] i_ext;
   reg i_reti;
   reg [3:0] i_CCodes;
       
   wire [3:0] o_CCodes;
   wire [3:0] o_VIC_data;
   wire [31:0] o_VIC_iaddr;
   wire o_VIC_ctrl;
   reg r_NOT_FLUSH;

   Vic vic(
        .clk(clk),
        .rst(rst),
        .i_PC(i_PC),    
        .i_VIC_data(i_VIC_data),   
        .i_VIC_regaddr(i_VIC_regaddr),
        .i_VIC_we(i_VIC_we),
        .i_ext(i_ext),
        .i_reti(i_reti),
        .i_CCodes(i_CCodes),
        .i_NOT_FLUSH(r_NOT_FLUSH),
        .o_CCodes(o_CCodes),
        .o_VIC_data(o_VIC_data),
        .o_VIC_iaddr(o_VIC_iaddr),
        .o_VIC_ctrl(o_VIC_ctrl)
        );
        
    initial begin
       
        clk=0;
        rst=0;
        i_CCodes = 4'b1111;
        i_PC = 32'hffff_ffff;
        i_reti = 0;
        i_ext = 0;
        i_VIC_we = 1;
        r_NOT_FLUSH = 1;
        
        #5
        rst=1;
        #10
        rst = 0;
        
        i_VIC_regaddr = 1;
        i_VIC_data = 4'b1100;   //rise
        #10
        i_VIC_regaddr = 8;
        i_VIC_data = 4'b1010;   //fall
        #10
        i_VIC_regaddr = 2;
        i_VIC_data = 4'b1001;    //high
        #10
        i_VIC_regaddr = 3;
        i_VIC_data = 4'b1000;   //low
        #10
        i_VIC_regaddr = 31; //ENABLE
        i_VIC_data = 4'b1111;   //low
        
        #5
        
        #10 i_ext[1]=1;
        #4  i_ext[1]=0;
               
        #10 i_ext[8]=1;
            i_ext[2]=1;
        #15 i_ext[8]=0;
        #10 i_ext[2]=0;
        #500 i_ext[3]=1;
            i_VIC_we = 0;
            #10
            i_VIC_we = 1;
       
        
        #2000
        $finish;
    end    
    
    always #5 clk=~clk; 
    
    always #205 begin
        i_reti = 1;
        #10
        i_reti = 0;
        end 
    
endmodule
