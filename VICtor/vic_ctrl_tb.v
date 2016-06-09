`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/16/2016 11:30:47 PM
// Design Name: 
// Module Name: vic_ctrl_tb
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


module vic_ctrl_tb(

    );
    
     reg clk;
     reg rst;
     reg [31:0] i_PC;
     reg i_PC_stall;
     reg i_reti;
     reg [31:0] i_ISR_addr;
     reg i_IRQ;
     reg [3:0] i_CCodes;
     wire o_IRQ_PC;
     wire [31:0] o_VIC_iaddr;
     wire [3:0] o_VIC_CCodes;
     wire o_IRQ_VIC;
     wire o_IRQ_Flush_ctrl; 
    
    vic_ctrl vicctrl(
        .clk(clk),
        .rst(rst),
        .i_PC(i_PC),
        .i_PC_stall(i_PC_stall),
        .i_reti(i_reti),
        .i_ISR_addr(i_ISR_addr),
        .i_IRQ(i_IRQ),
        .i_CCodes(i_CCodes),
        .o_IRQ_PC(o_IRQ_PC),
        .o_VIC_iaddr(o_VIC_iaddr),
        .o_VIC_CCodes(o_VIC_CCodes),
        .o_IRQ_VIC(o_IRQ_VIC),
        .o_IRQ_Flush_ctrl(o_IRQ_Flush_ctrl)
        );

         initial begin
             i_PC = 32'hffff_ffff;
             i_PC_stall = 1'b0;
             i_ISR_addr = 32'h1111_1111;
             i_reti = 1'b0;
             i_IRQ = 1'b0;
             clk=0;
             rst=0;
             i_CCodes = 4'b1111;
             
             #5
             rst=1;
             #10
             rst = 0;
             
             #199
             i_IRQ = 1'b1;
             #1
             i_IRQ = 1'b0;
             
             #300
             i_reti = 1'b1;
             #1
             i_reti = 1'b0;
             //other
             i_ISR_addr = 32'h2222_2222;
             i_IRQ = 1'b1;
             #1
             i_IRQ = 1'b0;
             
             #300
             i_reti = 1'b1;
             #1
             i_reti = 1'b0;
             //other
             i_ISR_addr = 32'h3333_3333;
             i_IRQ = 1'b1;
             #1
             i_IRQ = 1'b0;
             
             #100
             i_reti = 1'b1;
             #1
             i_reti = 1'b0;
             
             
             
             
             #1000
             $finish;
             
         end
             
            always #5 clk=~clk;
endmodule
