`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: RassIndustries & BL(B�ias Lindo) LDA
// Engineers: Grupo 2/4
// 
// Create Date: 05/13/2016 03:46:15 PM
// Design Name: VICtor Borges
// Module Name: vic
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Vectored Interrupt Controller
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Vic(
    input clk,
    input rst,
    input [31:0] i_PC,    
    input [3:0] i_VIC_data,   
    input [4:0] i_VIC_regaddr,
    input i_VIC_we,
    input [30:0] i_ext,
    input i_reti,
    input [3:0] i_CCodes,
    
    output [3:0] o_CCodes,
    output [3:0] o_VIC_data,
    output [31:0] o_VIC_iaddr,
    output o_VIC_ctrl
    );
    
    wire [4:0]o_irq_addr;
    wire o_IRQ;
    wire i_IRQ;
    wire i_en;
    
    wire [123:0] buffer;
    
    vic_ctrl vcu (
        .clk(clk),
        .rst(rst),
        .i_PC(i_PC),
        .i_reti(i_reti),
        .i_ISR_addr(o_irq_addr),
        .i_IRQ(o_IRQ),
        .i_CCodes(i_CCodes),
        .o_IRQ_PC(o_VIC_ctrl),
        .o_VIC_iaddr(o_VIC_iaddr),
        .o_VIC_CCodes(o_CCodes),
        .o_IRQ_VIC(i_IRQ)
    );

    vic_registers vr (
         .clk(clk),
         .rst(rst), 
         .i_VIC_regaddr(i_VIC_regaddr), //register address
         .i_VIC_data(i_VIC_data), //Input data
         .o_VIC_data(o_VIC_data), //Output Data
         .o_enable(i_en), //Global Enable
         .i_VIC_we(i_VIC_we), //Write Operation signal
         .o_buffer(buffer)// Configuration Registers
    );
    
    vic_irq virq(
        .i_IRQ(i_IRQ),
        .o_IRQ(o_IRQ),
        .i_reg(buffer), //en/rise/fall/level
        .i_clk(clk),
        .i_rst(rst),
        .i_ext(i_ext),
        .i_en(i_en),
        .o_irq_addr(o_irq_addr) //num. interr atual
        );
        
endmodule
