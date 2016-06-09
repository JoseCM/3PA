`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/13/2016 05:35:09 PM
// Design Name: 
// Module Name: vic_registers_tb
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


module vic_registers_tb(

    );
    
    reg Clk;
    reg Rst;
    reg [4:0]index;
    reg [3:0]i_data;
    wire [3:0]o_data;
    reg we;
    wire [123:0] buffer;
    wire o_enable;
    
    
    vic_registers vr(       
        .clk(Clk),
        .rst(Rst),
        .i_VIC_regaddr(index),
        .i_VIC_data(i_data),
        .o_VIC_data(o_data),
        .i_VIC_we(we),
        .o_buffer(buffer),
        .o_enable(o_enable)
    );
    
    integer i;
    
    initial begin
        we = 1'b0;
        Clk=0;
        Rst=0;
        #5
        Rst=1;
        #10
        Rst = 0;
        
        for (i = 0 ; i < 31 ; i = i + 1)
            begin    
                index = i;
                i_data = $random;
                #10
                we = 1'b1;
                #10
                we = 1'b0;
                #10;
            end
        
        index = 31;
        i_data = 4'b1111; //enable
        #10
        we = 1'b1;
        #10
        we = 1'b0;
                     
        #1200
        $finish;
        
    end
        
       always #5 Clk=~Clk;
    
endmodule
