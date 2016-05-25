`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.05.2016 21:50:26
// Design Name: 
// Module Name: LinefillBuffer
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


/**
AXI wraps adress??
TODO: testbench linefill
*/
module LinefillBuffer(
    input Clk,
    input Enable,
    input [31:0] Address, //start adress
    output reg [31:0] BaseAddress, //saved start adress
    output reg LineReadCompleted, // read a whole line
    output wire [255:0] Line, //read line
    output wire [31:0] CriticalWord, // critical word = mem[BaseAddress]
    output FirstDataAcquired, //received the first word (critical word)
    output reg AXIStartRead, //start AXI reading
    input RequestAttended,
    input [31:0] Data //Read word from memory
    );
    
    parameter IDLE = 0, 
              RUNNING = 1;
    
    reg [2:0] Counter;
    reg [31:0] Buff[7:0];
    reg state;
    reg FirstEnable;
    
    assign Line = {Buff[7],Buff[6],Buff[5],Buff[4],Buff[3],Buff[2],Buff[1],Buff[0]};
    wire [2:0]WordAddress = BaseAddress[2:0];
    assign CriticalWord = Data & {32{FirstDataAcquired}};//word is determined by LSB of address
    
    wire [2:0] wordIndex = (Counter + WordAddress) & 32'b111; //store only the 3 LSB of the sum, so it wraps
    
    /*Write in the correct buffer*/
    always @(posedge Clk) begin
        if(!Enable) begin
            Counter <= 0; 
        end
        else if(RequestAttended) begin
            if(Counter == 7 && RequestAttended) begin
                LineReadCompleted <= 1;
            end
            if(!LineReadCompleted) begin
                Buff[wordIndex] <= Data;
                Counter <= Counter + 1;
            end
        end
    end
    
//    //Check all words read
//    always @(posedge Clk) begin
//        if(!Enable) begin
//        end
//        else if(Counter == 7 && state == RUNNING) begin
//            Counter <= 0; //reset counter
//        end
//    end
    
    //check that the first word is read
    assign FirstDataAcquired = Enable && (Counter == 0 && RequestAttended );
    //state machine
    always @(posedge Clk) begin
        if(!Enable) begin
            state <= IDLE;
            AXIStartRead <= 0;
            FirstEnable <= 1;
            Counter <= 0;
            LineReadCompleted <= 0;
        end
        else begin
            case(state)
                IDLE:
                begin
                    if(FirstEnable) begin
                        FirstEnable <= 0;
                        BaseAddress <= Address;
                        AXIStartRead = 1;
                    end
                    else begin
                        AXIStartRead = 0;
                    end
                    if(!RequestAttended) begin
                         state <= IDLE;
                    end
                    else begin
                         state <= RUNNING;
                    end
                    
                end
                RUNNING:
                    if((Counter == 7 && state == RUNNING)) begin //read completed
                        state <= IDLE;
                    end
                    else begin
                        state <= RUNNING;
                    end
            endcase
        end
    end         
endmodule
