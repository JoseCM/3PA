`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2016 04:35:02 PM
// Design Name: 
// Module Name: registerFile_tb
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


module registerFile_tb(

    );
    reg clk;
    reg reset;
    
    reg [4:0] r_addr1;
    reg [4:0] r_addr2;
    reg [4:0] w_addr;
    wire [31:0] r_data1;
    wire [31:0] r_data2;
    reg [31:0] w_data;
    reg rf_we;
    
    registerFile regF(
        .oRAddr1(r_addr1),
        .oRAddr2(r_addr2),
        .oData1(r_data1),
        .oData2(r_data2),
        .iWAddr(w_addr),
        .iWData(w_data),
        .we(rf_we),
        .clk(clk),
        .reset(reset)
        );
        
initial begin  
    $display("**Testing Register file**");
    
    clk = 1'b0;
    rf_we = 1'b0;
    reset = 1'b1;
    
    #10;
    reset = 1'b0;       
    
    // write and read test
    /* write 1 to register 0 */
    w_addr <= 2;
    w_data <= 1;
    rf_we = 1;
    #10
    /* pause for a bit */
    rf_we <= 0;
    #10
    /* write 2 to register 1 */
    w_addr <= 1;
    w_data <= 2;
    rf_we <= 1;
    #10  
    /* zero write signals */
    rf_we = 0;
    w_addr <= 0;
    w_data <= 0;
    
    /*read register 0 and 1 */
    r_addr1 = 2;
    r_addr2 = 1;
    
    #0 //force wait after attribution
     $write("\t*Register file test is ");
    if((r_data1 == 1) && (r_data2 == 2))
       $display("successful!");
    else
       $display("unsuccessful...");
        
    #20
    $finish;
end 

    always #5 clk = ~clk;

endmodule
