`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:01:48 04/12/2012 
// Design Name: 
// Module Name:    ins_cache 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

/*
//	CACHE METRICS
//
//##Memory details: 256K Bytes#######################
//#													#
//#memory width:		64 bit				    	#
//#memory depth:		32 lines					#
//#memory address bus:	5 bit						#
//#													#
//##################################################
//
//##Address space:	4 KBytes#########################
//#													#
//#word lenght: 	32 bit							#
//#line size: 		8 word (8*4bytes = 32 byte line)#
//#					(balance with memory throughput)#
//#cache storage:	16Kbytes Bytes					#
//#cache lines:	16KBytes/4*32Bytes = 128 lines		#
//#						4sets						#
//##################################################
//
//##Address lenght: 32 bit (4GB memory positions)############################
//#				the first 2 bit are ignored (b1:b0)  		              	#
//#word address:	8 words per line -> 3 bit (b4:b2)              	     	#
//#line address:	128 lines per set -> 7 bit (b11:b5)		              	#
//#tag lenght:		remaining bits + val bit -> 32-2-3-7+2 = 22 bit         #
//#					In tag only 6 bits will be used since memory is of 256KB#
//###########################################################################
*/



`define TAG_T	31
`define TAG_B	12       //20 bits but only 6 bits are used to address 64 tags

`define LINE_T	11
`define LINE_B	5        //7 bits to address 128 lines

`define WORD_T	4
`define WORD_B  2       //3 bits to address 8 words

module DCacheMem(
//PROCESSOR INTERFACE
    input clk,
    input rst,
    input W_Enable,
    input R_Enable,               
    input [31:0] addr,      //address of the word requested by the processor
    input [31:0] word,      //Word to write on cache when it's a write from CPU to cache
    output [31:0] inst,     //word requested by the processor
	output hit,             //equals 1 if hit and 0 if not
	output dirty,           //1 if there's a dirty bit 0 if not
	 
//MEMORY INTERFACE
    input RWLine,
    input [31:0] LineAddr,      //address of the line to be written on cache
	output [31:0] mem_addr,  //Address of the line to write on mem       
	input write_type,      //Indicates if is a write from memory to cache (1) or a write from CPU to cache (0)
	input [255:0] mem_data,             //line from memory to write on cache
	output [255:0] cache_write_data     //Data to write on memory on a cache miss with dirty=1
    );
     
    reg[255:0] cache_set[127:0];    //cache_set with 128 lines, and 64bytes each line
    reg[255:0] cache_set2[127:0];   //cache_set2 with 128 lines, and 64bytes each line
    reg[255:0] cache_set3[127:0];    //cache_set3 with 128 lines, and 64bytes each line
    reg[255:0] cache_set4[127:0];   //cache_set4 with 128 lines, and 64bytes each line
    reg[21:0]  cache_tag[127:0];    //dirty+valid+tag bits for set 1
    reg[21:0]  cache_tag2[127:0];   //dirty+valid+tag bits for set 2
    reg[21:0]  cache_tag3[127:0];   //dirty+valid+tag bits for set 3
    reg[21:0]  cache_tag4[127:0];   //dirty+valid+tag bits for set 4
    reg[2:0]   cache_lru[127:0];    //LRU bits
    
     
     //Wires for reads and writes from CPU
    wire[255:0] write_cache;
    wire[255:0]	new_cache_set;
    wire[255:0]	new_cache_set2;
    wire[255:0]	new_cache_set3;
    wire[255:0]	new_cache_set4;
    wire[21:0]	new_cache_tag;
    wire[21:0]	new_cache_tag2;
    wire[21:0]	new_cache_tag3;
    wire[21:0]	new_cache_tag4;
    
    wire[2:0]   new_cache_lru;
    
    
    wire cache_hit;
    wire cache_hit_set;
    wire cache_hit_set2;
    wire cache_hit_set3;
    wire cache_hit_set4;
    
    wire[255:0] line_source;
    wire[21:0] cache_tag_temp;
    wire[21:0] cache_tag2_temp;
    wire[21:0] cache_tag3_temp;
    wire[21:0] cache_tag4_temp;
    wire[2:0]  cache_lru_temp;
    
     //Wires for reads and writes from Mem
    //wire[255:0] write_cache_mem;
    wire[255:0]	new_cache_set_mem;
    wire[255:0]	new_cache_set2_mem;
    wire[255:0]	new_cache_set3_mem;
    wire[255:0]	new_cache_set4_mem;
    wire[21:0]	new_cache_tag_mem;
    wire[21:0]	new_cache_tag2_mem;
    wire[21:0]	new_cache_tag3_mem;
    wire[21:0]	new_cache_tag4_mem;
    
    wire[2:0]   new_cache_lru_mem;
    
    //wire[255:0] line_source_mem;
    wire[21:0] cache_tag_temp_mem;
    wire[21:0] cache_tag2_temp_mem;
    wire[21:0] cache_tag3_temp_mem;
    wire[21:0] cache_tag4_temp_mem;
    wire[2:0]  cache_lru_temp_mem;
    integer i;
    
    //////ALIAS/////////
    wire[6:0] line_addr;
    assign line_addr = addr[`LINE_T:`LINE_B];
    
    wire[2:0] word_addr;
    assign word_addr = addr[`WORD_T:`WORD_B];
    
    wire[6:0] line_addr_mem;
    assign line_addr_mem = LineAddr[`LINE_T:`LINE_B];
    
    /*
    wire[2:0] word_addr_mem;
    assign word_addr_mem = LineAddr[`WORD_T:`WORD_B];*/
    ///////////////////
    
    
    always @(posedge clk) begin
        if (rst) begin
            for (i=0; i<128 ; i=i+1  ) begin
                cache_set[i] <= 256'b0;
                cache_set2[i] <= 256'b0;
                cache_set3[i] <= 256'b0;
                cache_set4[i] <= 256'b0;
                cache_tag[i] <= 22'b0;
                cache_tag2[i] <= 22'b0;
                cache_tag3[i] <= 22'b0;
                cache_tag4[i] <= 22'b0;
                cache_lru[i] <= 3'b0;
            end
        end
        else begin
        
           //New sets and tags for sets in a Mem write or "read" to cache
            cache_set[line_addr_mem] <= new_cache_set_mem;
            cache_tag[line_addr_mem] <= new_cache_tag_mem;
            cache_set2[line_addr_mem] <= new_cache_set2_mem;
            cache_tag2[line_addr_mem] <= new_cache_tag2_mem;
            cache_set3[line_addr_mem] <= new_cache_set3_mem;
            cache_tag3[line_addr_mem] <= new_cache_tag3_mem;
            cache_set4[line_addr_mem] <= new_cache_set4_mem;
            cache_tag4[line_addr_mem] <= new_cache_tag4_mem;
            
            cache_lru[line_addr_mem] = new_cache_lru_mem;
        
            //New sets and tags for sets in a CPU write or read to cache
            cache_set[line_addr] <= new_cache_set;
            cache_tag[line_addr] <= new_cache_tag;
            cache_set2[line_addr] <= new_cache_set2;
            cache_tag2[line_addr] <= new_cache_tag2;
            cache_set3[line_addr] <= new_cache_set3;
            cache_tag3[line_addr] <= new_cache_tag3;
            cache_set4[line_addr] <= new_cache_set4;
            cache_tag4[line_addr] <= new_cache_tag4;
            
            cache_lru[line_addr] = new_cache_lru;
           
        end           
    end
    
    //STATE MACHINE AND REGISTER ASSIGN//////////////////////////////////////////////////////////
    
    assign cache_tag_temp = cache_tag[line_addr];
    assign cache_tag2_temp = cache_tag2[line_addr];
    assign cache_tag3_temp = cache_tag3[line_addr];
    assign cache_tag4_temp = cache_tag4[line_addr];
    assign cache_lru_temp = cache_lru[line_addr];
    
    assign cache_tag_temp_mem = cache_tag[line_addr_mem];
    assign cache_tag2_temp_mem = cache_tag2[line_addr_mem];
    assign cache_tag3_temp_mem = cache_tag3[line_addr_mem];
    assign cache_tag4_temp_mem = cache_tag4[line_addr_mem];
    assign cache_lru_temp_mem = cache_lru[line_addr_mem];
    
    assign cache_hit_set  = (({1'b1,addr[`TAG_T:`TAG_B]} == cache_tag_temp[20:0]) && (W_Enable || R_Enable))?	1'b1	:
                                                                                    1'b0	;
          
    assign cache_hit_set2 = (({1'b1,addr[`TAG_T:`TAG_B]} == cache_tag2_temp[20:0]) && (W_Enable || R_Enable))?	1'b1	:
                                                                                    1'b0    ;    	
                                                                                    
    assign cache_hit_set3 = (({1'b1,addr[`TAG_T:`TAG_B]} == cache_tag3_temp[20:0]) && (W_Enable || R_Enable))?	1'b1	:
                                                                                    1'b0    ;  																	
    
    assign cache_hit_set4 = (({1'b1,addr[`TAG_T:`TAG_B]} == cache_tag4_temp[20:0]) && (W_Enable || R_Enable))?	1'b1	:
                                                                                    1'b0    ;  	
                                                                                      
    assign cache_hit = (cache_hit_set || cache_hit_set2 || cache_hit_set3 || cache_hit_set4) ? 1'b1:
                                                                                               1'b0;
    //New sets and tags for a write or read from CPU																							
    assign new_cache_set =  (W_Enable && cache_hit_set)?                         write_cache         :
                            (write_type && line_addr == line_addr_mem)?                   new_cache_set_mem:
                                                                                 cache_set[line_addr];
    
    assign new_cache_set2 = (W_Enable && cache_hit_set2)?                         write_cache        :
                            (write_type && line_addr == line_addr_mem)?                   new_cache_set2_mem:
                                                                                 cache_set2[line_addr] ;
    
    assign new_cache_set3 = (W_Enable && cache_hit_set3)?                         write_cache        :
                            (write_type && line_addr == line_addr_mem)?                   new_cache_set3_mem:
                                                                                 cache_set3[line_addr]	;
    
    assign new_cache_set4 = (W_Enable && cache_hit_set4)?                         write_cache        :
                            (write_type && line_addr == line_addr_mem)?                   new_cache_set4_mem:
                                                                                 cache_set4[line_addr]	;
    
    //-------
    assign new_cache_tag = (W_Enable && cache_hit_set)? {2'b11,addr[`TAG_T:`TAG_B]}	:
                            (write_type && line_addr == line_addr_mem)?    new_cache_tag_mem:
                                                          cache_tag[line_addr]		;
    
    assign new_cache_tag2 = (W_Enable && cache_hit_set2)?	{2'b11,addr[`TAG_T:`TAG_B]}	:
                             (write_type && line_addr == line_addr_mem)?    new_cache_tag2_mem:
                                                              cache_tag2[line_addr]		;
    
    assign new_cache_tag3 = (W_Enable && cache_hit_set3)?	{2'b11,addr[`TAG_T:`TAG_B]}	:
                             (write_type && line_addr == line_addr_mem)?    new_cache_tag3_mem:
                                                              cache_tag3[line_addr]		;
                                                                                                
    assign new_cache_tag4 = (W_Enable && cache_hit_set4)?	{2'b11,addr[`TAG_T:`TAG_B]}	:
                             (write_type && line_addr == line_addr_mem)?    new_cache_tag4_mem:
                                                             cache_tag4[line_addr]      ;	
        
                                                                                                    
    //New sets and tags for a write or read from Mem																							
    assign new_cache_set_mem = ( write_type && !(W_Enable && cache_hit_set) && !cache_lru_temp_mem[0] && !cache_lru_temp_mem[1] )    ?    mem_data               :
                                cache_set[line_addr_mem];
    
    assign new_cache_set2_mem = ( write_type && !(W_Enable && cache_hit_set2) && !cache_lru_temp_mem[0] && cache_lru_temp_mem[1] )    ?    mem_data            :
                                cache_set2[line_addr_mem]    ;
    
    assign new_cache_set3_mem = ( write_type && !(W_Enable && cache_hit_set3) && cache_lru_temp_mem[0] && !cache_lru_temp_mem[2])    ?   mem_data            :
                                cache_set3[line_addr_mem]    ;
    
    assign new_cache_set4_mem = (write_type && !(W_Enable && cache_hit_set4) && cache_lru_temp_mem[0] && cache_lru_temp_mem[2])  ?      mem_data            :
                                cache_set4[line_addr_mem]    ;
    
    assign new_cache_tag_mem = (write_type && !RWLine && !cache_lru_temp_mem[0] && !cache_lru_temp_mem[1] )    ?    {2'b01,LineAddr[`TAG_T:`TAG_B]}    :
                            (write_type && RWLine && !cache_lru_temp_mem[0] && !cache_lru_temp_mem[1] )    ?    {2'b11,LineAddr[`TAG_T:`TAG_B]}    :
                                 cache_tag[line_addr_mem]        ;
    
    assign new_cache_tag2_mem = (write_type && !RWLine && !cache_lru_temp_mem[0] && cache_lru_temp_mem[1])    ?    {2'b01,LineAddr[`TAG_T:`TAG_B]}    :
                            (write_type && RWLine && !cache_lru_temp_mem[0] && cache_lru_temp_mem[1])        ?    {2'b11,LineAddr[`TAG_T:`TAG_B]}    :
                                   cache_tag2[line_addr_mem]        ;
    
    assign new_cache_tag3_mem = (write_type && !RWLine && cache_lru_temp_mem[0] && !cache_lru_temp_mem[2])    ?    {2'b01,LineAddr[`TAG_T:`TAG_B]}    :
                            (write_type && RWLine && cache_lru_temp_mem[0] && !cache_lru_temp_mem[2])      ?    {2'b11,LineAddr[`TAG_T:`TAG_B]}    :
                                   cache_tag3[line_addr_mem]        ;
                         
    assign new_cache_tag4_mem = (write_type && !RWLine && cache_lru_temp_mem[0] && cache_lru_temp_mem[2])    ?    {2'b01,LineAddr[`TAG_T:`TAG_B]}    :
                            (write_type && RWLine && cache_lru_temp_mem[0] && cache_lru_temp_mem[2])    ?    {2'b11,LineAddr[`TAG_T:`TAG_B]}    :
                              cache_tag4[line_addr_mem]      ;    
                                                                                                                            
    //OUTPUT ASSIGN//////////////////////////////////////////////////////////////////////////////
        //processor outputs													
    
    assign line_source = //((status == `WAIT) && mem_rd_rdy && rd_en)	?	mem_data				:
                         (cache_hit_set)                            ?   cache_set[line_addr]	:
                         (cache_hit_set2)                            ?   cache_set2[line_addr]	:
                         (cache_hit_set3)                            ?   cache_set3[line_addr]	:
                         (cache_hit_set4)                            ?   cache_set4[line_addr]	:
                                                                                          256'b0;
        
    //wire [31:0] inst_wire;
    assign inst =	    (word_addr == 3'b000)	?	line_source[31:0] 	:
                        (word_addr == 3'b001)	?	line_source[63:32] 	:
                        (word_addr == 3'b010)	?	line_source[95:64] 	:
                        (word_addr == 3'b011)	?	line_source[127:96] :
                        (word_addr == 3'b100)	?	line_source[159:128]:
                        (word_addr == 3'b101)   ?   line_source[191:160]:
                        (word_addr == 3'b110)   ?   line_source[223:192]:
                       /*(word_addr == 3'b111)  ?*/ line_source[255:224];
                       /* (word_addr == 4'b1000)  ?  	line_source[287:256]:
                        (word_addr == 4'b1001)  ?   line_source[319:288]:
                        (word_addr == 4'b1010)  ?   line_source[351:320]:
                        (word_addr == 4'b1011)  ?   line_source[383:352]:
                        (word_addr == 4'b1100)  ?   line_source[415:384]:
                        (word_addr == 4'b1101)  ?   line_source[447:416]:
                        (word_addr == 4'b1110)  ?   line_source[479:448]:
                                                    line_source[511:480];*/
                                                    
    assign write_cache =(word_addr == 3'b000)	 ? {line_source[255:32],word} 	                  :
                        (word_addr == 3'b001)    ? {line_source[255:64],word,line_source[31:0]}   :
                        (word_addr == 3'b010)    ? {line_source[255:96],word,line_source[63:0]}   :
                        (word_addr == 3'b011)    ? {line_source[255:128],word,line_source[95:0]}  :
                        (word_addr == 3'b100)    ? {line_source[255:160],word,line_source[127:0]} :
                        (word_addr == 3'b101)   ?  {line_source[255:192],word,line_source[159:0]} :
                        (word_addr == 3'b110)   ?  {line_source[255:224],word,line_source[191:0]} :
                       /*(word_addr == 3'b111)  ?*/{word,line_source[223:0]}                      ;
                       /* (word_addr == 4'b1000)  ?      line_source[287:256]:
                        (word_addr == 4'b1001)  ?   line_source[319:288]:
                        (word_addr == 4'b1010)  ?   line_source[351:320]:
                        (word_addr == 4'b1011)  ?   line_source[383:352]:
                        (word_addr == 4'b1100)  ?   line_source[415:384]:
                        (word_addr == 4'b1101)  ?   line_source[447:416]:
                        (word_addr == 4'b1110)  ?   line_source[479:448]:
                                                    line_source[511:480];*/
    
    assign new_cache_lru[0] = ( cache_hit_set || cache_hit_set2 )      ?               1'b1:
                              ( cache_hit_set3 || cache_hit_set4)      ?               1'b0:
                              (write_type && line_addr == line_addr_mem)?    new_cache_lru_mem[0]:
                                                                          cache_lru_temp[0];
                                                     
    assign new_cache_lru[1] = ( cache_hit_set)                                                ?      1'b1:
                              ( cache_hit_set2 )                                              ?      1'b0:
                              (write_type && line_addr == line_addr_mem)?    new_cache_lru_mem[1]:
                                                                                        cache_lru_temp[1];          
                                                       
    assign new_cache_lru[2] = ( cache_hit_set3 )                                             ?       1'b1:
                              ( cache_hit_set4 )                                             ?       1'b0: 
                              (write_type && line_addr == line_addr_mem)?    new_cache_lru_mem[2]:
                                                                                        cache_lru_temp[2];  
                                                                                        
    //New LRU bits from a MEM write
    assign new_cache_lru_mem[0] = ( write_type && !(W_Enable && (cache_hit_set3 || cache_hit_set4) && line_addr == line_addr_mem) && !cache_lru_temp_mem[0])?               1'b1:
                                  ( write_type && !(W_Enable && (cache_hit_set || cache_hit_set2) && line_addr == line_addr_mem) && cache_lru_temp_mem[0]) ?               1'b0: 
                                                                          cache_lru_temp_mem[0];
                                                     
    assign new_cache_lru_mem[1] = ( !cache_lru_temp_mem[0] &&  write_type && !(W_Enable && (cache_hit_set2) && line_addr == line_addr_mem) && !cache_lru_temp_mem[1])?      1'b1:
                              ( !cache_lru_temp_mem[0] &&  write_type && !(W_Enable && (cache_hit_set) && line_addr == line_addr_mem) && cache_lru_temp_mem[1]) ?      1'b0: 
                                                                                        cache_lru_temp_mem[1];          
                                                       
    assign new_cache_lru_mem[2] = ( cache_lru_temp_mem[0] &&  write_type && !(W_Enable && (cache_hit_set4) && line_addr == line_addr_mem) && !cache_lru_temp_mem[2])?       1'b1:
                              ( cache_lru_temp_mem[0] &&  write_type && !(W_Enable && (cache_hit_set3) && line_addr == line_addr_mem) && cache_lru_temp_mem[2]) ?       1'b0: 
                                                                                        cache_lru_temp_mem[2];         
    
    //always@(posedge clk) begin
        
    //	inst <= inst_wire;
    //end
    
    //Only used in a write or read miss from CPU
    wire [33:0] temp =  ( !cache_lru_temp[0] && !cache_lru_temp[1] ) ? {cache_tag_temp[21:0],line_addr,5'b0} :
                        ( !cache_lru_temp[0] && cache_lru_temp[1] )  ? {cache_tag2_temp[21:0],line_addr,5'b0} :
                        ( cache_lru_temp[0] && !cache_lru_temp[2] )  ? {cache_tag3_temp[21:0],line_addr,5'b0} :
                        ( cache_lru_temp[0] && cache_lru_temp[2] )   ? {cache_tag4_temp[21:0],line_addr,5'b0} :
                                                                                                            0;
    
    assign cache_write_data =  ( !cache_lru_temp[0] && !cache_lru_temp[1] ) ? cache_set[line_addr] :
                        ( !cache_lru_temp[0] && cache_lru_temp[1] )  ? cache_set2[line_addr] :
                        ( cache_lru_temp[0] && !cache_lru_temp[2] )  ? cache_set3[line_addr] :
                        ( cache_lru_temp[0] && cache_lru_temp[2] )   ? cache_set4[line_addr] :
                                                                                            0;
    
        //memory outputs
    assign mem_addr = temp[31:0];
    
    assign dirty = temp[33];
    
    assign hit = cache_hit;
	
endmodule
