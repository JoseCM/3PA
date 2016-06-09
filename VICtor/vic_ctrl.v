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
    
    always @(posedge i_IRQ) //Assim que se sinalize uma interrupt pelo vic_irq
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
   
    always @(negedge clk)
    begin
        //delay = i_NOT_FLUSH;         
        if(CC_PC_NotSaved && i_NOT_FLUSH) // If There's not a bubble on the Execute Stage
        begin
               CommonITHandle(i_CCodes, i_PC);
        end
    end
   
    always @(posedge clk)
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
              
            //delay = i_NOT_FLUSH;
             
            /*if(CC_PC_NotSaved && i_NOT_FLUSH) // If There's not a bubble on the Execute Stage
            begin
                   CommonITHandle(i_CCodes, i_PC);
            end*/
            
            if(~CC_PC_NotSaved)
            begin
                if(~i_reti)
                begin
                    o_VIC_CCodes_ctrl = 1'b0;    
                end
            end
        end     
    end
    //When a ISR is finished
    always @(posedge i_reti) begin
        o_VIC_iaddr <= saved_PC;
        o_IRQ_PC <= 1'b1;
        o_VIC_CCodes <= saved_CC;
        o_VIC_CCodes_ctrl <= 1'b1;
        o_IRQ_VIC <= 1'b0;
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
