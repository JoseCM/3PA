`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/13/2016 04:36:46 PM
// Design Name: 
// Module Name: vic_registers
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

`define CONFREG_WIDTH 4
`define CONFREGADDR_WIDTH 5   //<------- FFFFFFA0 FFFFFF00 FFFFFFE0 F0000000
`define ARRAY_LENGTH 32
`define BUFF_WIDTH `CONFREG_WIDTH*(`ARRAY_LENGTH-1)
`define ENA_INDEX 31

module vic_registers(
        input clk,
        input rst, 
        input [`CONFREGADDR_WIDTH-1:0] i_VIC_regaddr, //register address
        input [`CONFREG_WIDTH-1:0] i_VIC_data, //Input data
        output reg [`CONFREG_WIDTH-1:0] o_VIC_data, //Output Data
        output o_enable, //Global Enable
        input i_VIC_we, //Write Operation signal
        output [`BUFF_WIDTH-1:0] o_buffer// Configuration Registers
    );
    
    //Configuration Registers Memory
    reg [`CONFREG_WIDTH-1:0] buffer_store_data [`ARRAY_LENGTH-1:0]; 
    
    assign o_enable = buffer_store_data[`ENA_INDEX][0];
    
    generate
    genvar i;
        //Bind the output bus to the respective memory location    
        for (i = 0; i < `ARRAY_LENGTH - 1; i = i + 1) begin
            assign o_buffer[`CONFREG_WIDTH * i + `CONFREG_WIDTH - 1: `CONFREG_WIDTH * i] = buffer_store_data[i][`CONFREG_WIDTH - 1:0];
        end
    endgenerate
    
    integer j;
    always @(posedge clk) begin
        if(rst) begin  
            //Initializing  memory with zeros    
            for ( j = 0; j < `ARRAY_LENGTH; j = j + 1 ) 
                buffer_store_data[j] = 4'b0000;
        end
        
        else begin
            if(i_VIC_we) // Write Operation
                buffer_store_data[i_VIC_regaddr] = i_VIC_data;
            else  // Read Operation
                o_VIC_data = buffer_store_data[i_VIC_regaddr];     
        end
    end
endmodule