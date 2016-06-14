`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Rass Industries
// Engineer: 
// 
// Create Date: 05/13/2016 04:00:23 PM
// Design Name: 
// Module Name: vic_irq
// Project Name: VICtor
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


module vic_irq(
    input i_IRQ,
    output reg o_IRQ=0,
    input [123:0] i_reg, //en/rise/fall/level
    input i_clk,
    input i_rst,
    input [30:0] i_ext,
    input i_en,
    output reg [4:0] o_irq_addr=0 //num. interr atual
    );
    
reg  [30:0] irq_x=0;
   
genvar i;

generate //verificar a necessidade de generate
    for (i=0; i<31; i=i+1 ) begin
        always@(i_ext[i] or aux_IRQ[i] or i_reg[4*i+3:4*i]) begin
            irq_x[i] =  (i_rst)  ?                                                           0 : 
                        (~aux_IRQ[i] && irq_x[i] && i_en)?                                   0 :
                        (i_reg[4*i+3:4*i+1]==3'b100 && i_reg[4*i]==i_ext[i])?                1 : 
                        (i_reg[4*i+3] && i_ext[i] && ~aux_ext[i] && i_reg[4*i+2])?           1 : 
                        (i_reg[4*i+3] && ~i_ext[i] && aux_ext[i] && i_reg[4*i+1])?           1 : 
                                                                                             irq_x[i];
            aux_ext[i]=i_ext[i];
        end 
    end
endgenerate
//No reset as interrupcoes ativas ao nivel sao ignoradas até acontecer uma transicao
//isto acontece porque os perifericos devem ser configurados antes de poderem interromper o CPU
reg [30:0]aux_ext=0;
reg aux_i_irq=0;
reg [30:0] aux_IRQ=0;
always@(irq_x or i_IRQ or i_en) begin //A interrupcao atual terminou o processamento
    if(~i_IRQ && aux_i_irq && i_en)begin
        if(i_reg[4*o_irq_addr+2]!=0 || i_reg[4*o_irq_addr+1]!=0 || i_reg[4*o_irq_addr]!=i_ext[o_irq_addr]) //Se nao estiver ativa ao nivel
            aux_IRQ[o_irq_addr] = 0; //apaga a interrupcao individual a ser atendida
        else 
            new_interrupt;
        aux_i_irq=i_IRQ;
    end
    else if(irq_x!=0 && ~i_rst && i_en)begin
        new_interrupt;
        aux_IRQ=irq_x; 
        aux_i_irq=i_IRQ;
    end 
end

task new_interrupt;
    integer k;
    if(irq_x != 0 && i_IRQ == 0 && i_en == 1) begin
        for (k=30; k>=0; k=k-1 ) begin
            if(irq_x[k])
                o_irq_addr = k;
        end
        o_IRQ = 1;
        #1
        o_IRQ = 0;
    end
endtask    
   
endmodule
