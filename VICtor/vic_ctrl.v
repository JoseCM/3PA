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

module vic_ctrl(
   input clk,
   input rst,
   input [31:0] i_PC,
   input i_reti,
   input [4:0] i_ISR_addr,
   input i_IRQ,
   input [3:0] i_CCodes,
   input i_NOT_FLUSH,
   output reg o_IRQ_PC,
   output reg [31:0] o_VIC_iaddr,
   output reg [3:0] o_VIC_CCodes,
   output reg o_IRQ_VIC,
   output reg o_VIC_CCodes_ctrl
   );
    
    
    reg [31:0]saved_PC; // stores the PC value   
    reg [3:0] saved_CC;
    reg CC_PC_NotSaved;
    reg delay;

    reg r_irq;
    reg r_clk;
    reg r_reti;

    wire dummy=1'b1;
    
    always @(i_IRQ or clk or i_reti) //Assim que se sinalize uma interrup��o pelo vic_irq
    begin  
        if(i_IRQ && r_irq==0)
        begin
            o_IRQ_VIC <= 1'b1;
                
            if(i_reti) // Consecutive Interruptions
            begin  
                CommonITHandle(saved_CC, saved_PC);
            end
            else 
                if (i_NOT_FLUSH)
                    CommonITHandle(i_CCodes, i_PC);
                else
                    CC_PC_NotSaved <= 1'b1;
        end  
        
        if(clk && r_clk==0)    //posedge clk
        begin
            if(rst)
            begin
                o_IRQ_VIC <= 1'b0;
                o_IRQ_PC <= 1'b0;
                saved_PC <= 0;
                o_VIC_CCodes_ctrl <= 0;
                CC_PC_NotSaved <= 0;
                o_VIC_CCodes <= 0;
                saved_CC <= 0;
                saved_PC <= 0;
                o_VIC_iaddr <= 0;
            end
            else
            begin          
                if(o_IRQ_PC)
                    begin
                        o_IRQ_PC <= 0;               
                    end
                
                if(~CC_PC_NotSaved)
                begin
                    if(~i_reti)
                    begin
                        o_VIC_CCodes_ctrl = 1'b0;    
                    end
                end
            end
        end
        
        if(~clk && r_clk==1) // negedge clk
        begin
            if(CC_PC_NotSaved && i_NOT_FLUSH) // If There's not a bubble on the Execute Stage
            begin
                   CommonITHandle(i_CCodes, i_PC);
            end
        end
        if(i_reti && r_reti==0)
        begin
            o_VIC_iaddr <= saved_PC;
            o_IRQ_PC <= 1'b1;         
            o_VIC_CCodes <= saved_CC;
            o_VIC_CCodes_ctrl <= 1'b1;
            o_IRQ_VIC <= 1'b0;
        end
        r_reti<=i_reti;
        if(clk && dummy)
        begin
            r_clk<=1;
        end
        else
        begin
            r_clk<=0;
        end
        r_irq<=i_IRQ;    
    end       
   

task CommonITHandle;
input [3:0]CCode_attribution; 
input [31:0]PC_attribution;
begin
    saved_PC <= PC_attribution;  
    saved_CC <= CCode_attribution;
    o_IRQ_PC <= 1'b1;
    o_VIC_iaddr <= ({27'b0000_0000_0000_0000_0000_0000_000,i_ISR_addr}) << 4;   //addr of ISR to fetch*/
    CC_PC_NotSaved <= 1'b0;
end
endtask
endmodule
