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
    input i_NOT_FLUSH,
    input FlushPipeAndPC,
    
    output [3:0] o_CCodes,
    output [3:0] o_VIC_data,
    output [31:0] o_VIC_iaddr,
    output o_VIC_ctrl,
    output o_VIC_CCodes_ctrl
    );
    
    wire [4:0]o_irq_addr;
    wire o_IRQ;
    wire i_IRQ;
    wire i_en;
    
    wire [123:0] buffer;
    
    vic_ctrl vcu (
        .clk(clk),                              //Clock
        .rst(rst),                              //Reset
        .i_PC(i_PC),                            //Program Counter from execute stage
        .i_reti(i_reti),                        //reti signal from Control unit
        .i_ISR_addr(o_irq_addr),                //interrupt routine address
        .i_IRQ(o_IRQ),                          //IRQ signal from vic_irq (interrupt occured)
        .i_CCodes(i_CCodes),                    //condition codes from execute stage
        .i_NOT_FLUSH(i_NOT_FLUSH),              //signal from execute stage that tells if its present an instruction or a bubble in that stage
        .i_FlushPipeAndPC(FlushPipeAndPC),
        .o_IRQ_PC(o_VIC_ctrl),                  //signal to select the mux in the fetch stage and to flush the pipeline (flush IF/ID and ID/EX)
        .o_VIC_iaddr(o_VIC_iaddr),              //address that goes in to the new mux in the fetch stage
        .o_VIC_CCodes(o_CCodes),                //output condition codes (when reti occurs and when the context before interrupt must be re-established)
        .o_IRQ_VIC(i_IRQ),                      //output signal to notify irq_vic that a reti occured (end of interruption)
        .o_VIC_CCodes_ctrl(o_VIC_CCodes_ctrl)   //signal for the execute stage (ALU)---> to restore the ccodes stored before an interrupt or to store ccodes normally
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
