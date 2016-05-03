`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/08/2016 02:54:51 PM
// Design Name: 
// Module Name: registerFile
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


module registerFile(
    input [4:0] iRAddr1,
    input [4:0] iRAddr2,
    output [31:0] oData1,
    output [31:0] oData2,
    input [4:0] iWAddr,
    input [31:0] iWData,
    input we,
    input clk,
    input reset
    );
    
	reg [31:0] buff[31:0];
   
	assign oData1 = (we && (iRAddr1 == iWAddr)) ? iWData :
                       buff[iRAddr1];
	assign oData2 = (we && (iRAddr2 == iWAddr)) ? iWData :
	                   buff[iRAddr2];
   
always@ (posedge clk) 
begin
    if(reset) begin
        buff[ 0] <= 0;                                                                                                                                                                                                                  
        buff[ 1] <= 0;                                                                                                                                                                                                                  
        buff[ 2] <= 0;                                                                                                                                                                                                                  
        buff[ 3] <= 0;                                                                                                                                                                                                                  
        buff[ 4] <= 0;                                                                                                                                                                                                                  
        buff[ 5] <= 0;                                                                                                                                                                                                                  
        buff[ 6] <= 0;                                                                                                                                                                                                                  
        buff[ 7] <= 0;                                                                                                                                                                                                                  
        buff[ 8] <= 0;                                                                                                                                                                                                                  
        buff[ 9] <= 0;                                                                                                                                                                                                                  
        buff[10] <= 0;                                                                                                                                                                                                                  
        buff[11] <= 0;                                                                                                                                                                                                                  
        buff[12] <= 0;                                                                                                                                                                                                                  
        buff[13] <= 0;                                                                                                                                                                                                                  
        buff[14] <= 0;                                                                                                                                                                                                                  
        buff[15] <= 0;                                                                                                                                                                                                                  
        buff[16] <= 0;                                                                                                                                                                                                                  
        buff[17] <= 0;                                                                                                                                                                                                                  
        buff[18] <= 0;                                                                                                                                                                                                                  
        buff[19] <= 0;                                                                                                                                                                                                                  
        buff[20] <= 0;                                                                                                                                                                                                                  
        buff[21] <= 0;                                                                                                                                                                                                                  
        buff[22] <= 0;                                                                                                                                                                                                                  
        buff[23] <= 0;                                                                                                                                                                                                                  
        buff[24] <= 0;                                                                                                                                                                                                                  
        buff[25] <= 0;                                                                                                                                                                                                                  
        buff[26] <= 0;                                                                                                                                                                                                                  
        buff[27] <= 0;                                                                                                                                                                                                                  
        buff[28] <= 0;                                                                                                                                                                                                                  
        buff[29] <= 0;                                                                                                                                                                                                                  
        buff[30] <= 0;                                                                                                                                                                                                                  
        buff[31] <= 0;
    end
    else if(we) begin
        buff[iWAddr] <= iWData;
    end
    
end
    
endmodule