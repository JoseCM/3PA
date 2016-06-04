
`timescale 1 ns / 1 ps

	module ICache_AXIMaster_core #
	(
		// Users to add parameters here
        parameter CACHE_LINE_NO = 8,
        parameter CACHE_LINE_SIZE = 128,
        parameter BURST_TYPE = 1,
		// User parameters ends
		// Do not modify the parameters beyond this line

		// Base address of targeted slave
		//parameter  C_M_TARGET_SLAVE_BASE_ADDR	= 32'b00000000,
		// Burst Length. Supports 1, 2, 4, 8, 16, 32, 64, 128, 256 burst lengths
		//parameter integer C_M_AXI_BURST_LEN	= 128,
		// Thread ID Width
		parameter integer C_M_AXI_ID_WIDTH	= 1,
		// Width of Address Bus
		parameter integer C_M_AXI_ADDR_WIDTH	= 32,
		// Width of Data Bus
		parameter integer C_M_AXI_DATA_WIDTH	= 32,
		// Width of User Write Address Bus
		parameter integer C_M_AXI_AWUSER_WIDTH	= 0,
		// Width of User Read Address Bus
		parameter integer C_M_AXI_ARUSER_WIDTH	= 0,
		// Width of User Write Data Bus
		parameter integer C_M_AXI_WUSER_WIDTH	= 0,
		// Width of User Read Data Bus
		parameter integer C_M_AXI_RUSER_WIDTH	= 0,
		// Width of User Response Bus
		parameter integer C_M_AXI_BUSER_WIDTH	= 0
	)
	(
		// Users to add ports here
		output wire miss,
		output wire [31:0] data,
        input wire [C_M_AXI_ADDR_WIDTH - 1:0] address,
		// User ports ends
		// Do not modify the ports beyond this line

		// Initiate AXI transactions
//		input wire  INIT_AXI_TXN,
//		input wire  INIT_AXI_WRN,
//		// Asserts when transaction is complete
//		output wire  TXN_DONE,
//		// Asserts when ERROR is detected
//		output reg  ERROR,
		// Global Clock Signal.
		input wire  M_AXI_ACLK,
		// Global Reset Singal. This Signal is Active Low
		input wire  M_AXI_ARESETN,
		// Master Interface Write Address ID
		output wire [C_M_AXI_ID_WIDTH-1 : 0] M_AXI_AWID,
		// Master Interface Write Address
		output wire [C_M_AXI_ADDR_WIDTH-1 : 0] M_AXI_AWADDR,
		// Burst length. The burst length gives the exact number of transfers in a burst
		output wire [7 : 0] M_AXI_AWLEN,
		// Burst size. This signal indicates the size of each transfer in the burst
		output wire [2 : 0] M_AXI_AWSIZE,
		// Burst type. The burst type and the size information, 
    // determine how the address for each transfer within the burst is calculated.
		output wire [1 : 0] M_AXI_AWBURST,
		// Lock type. Provides additional information about the
    // atomic characteristics of the transfer.
		output wire  M_AXI_AWLOCK,
		// Memory type. This signal indicates how transactions
    // are required to progress through a system.
		output wire [3 : 0] M_AXI_AWCACHE,
		// Protection type. This signal indicates the privilege
    // and security level of the transaction, and whether
    // the transaction is a data access or an instruction access.
		output wire [2 : 0] M_AXI_AWPROT,
		// Quality of Service, QoS identifier sent for each write transaction.
		output wire [3 : 0] M_AXI_AWQOS,
		// Optional User-defined signal in the write address channel.
		output wire [C_M_AXI_AWUSER_WIDTH-1 : 0] M_AXI_AWUSER,
		// Write address valid. This signal indicates that
    // the channel is signaling valid write address and control information.
		output wire  M_AXI_AWVALID,
		// Write address ready. This signal indicates that
    // the slave is ready to accept an address and associated control signals
		input wire  M_AXI_AWREADY,
		// Master Interface Write Data.
		output wire [C_M_AXI_DATA_WIDTH-1 : 0] M_AXI_WDATA,
		
		// Write strobes. This signal indicates which byte
    // lanes hold valid data. There is one write strobe
    // bit for each eight bits of the write data bus.
		output wire [C_M_AXI_DATA_WIDTH/8-1 : 0] M_AXI_WSTRB,
		// Write last. This signal indicates the last transfer in a write burst.
		output wire  M_AXI_WLAST,
		// Optional User-defined signal in the write data channel.
		output wire [C_M_AXI_WUSER_WIDTH-1 : 0] M_AXI_WUSER,
		// Write valid. This signal indicates that valid write
    // data and strobes are available
		output wire  M_AXI_WVALID,
		// Write ready. This signal indicates that the slave
    // can accept the write data.
		input wire  M_AXI_WREADY,
		// Master Interface Write Response.
		input wire [C_M_AXI_ID_WIDTH-1 : 0] M_AXI_BID,
		// Write response. This signal indicates the status of the write transaction.
		input wire [1 : 0] M_AXI_BRESP,
		// Optional User-defined signal in the write response channel
		input wire [C_M_AXI_BUSER_WIDTH-1 : 0] M_AXI_BUSER,
		// Write response valid. This signal indicates that the
    // channel is signaling a valid write response.
		input wire  M_AXI_BVALID,
		// Response ready. This signal indicates that the master
    // can accept a write response.
		output wire  M_AXI_BREADY,
		// Master Interface Read Address.
		output wire [C_M_AXI_ID_WIDTH-1 : 0] M_AXI_ARID,
		// Read address. This signal indicates the initial
    // address of a read burst transaction.
		output wire [C_M_AXI_ADDR_WIDTH-1 : 0] M_AXI_ARADDR,
		// Burst length. The burst length gives the exact number of transfers in a burst
		output wire [7 : 0] M_AXI_ARLEN,
		// Burst size. This signal indicates the size of each transfer in the burst
		output wire [2 : 0] M_AXI_ARSIZE,
		// Burst type. The burst type and the size information, 
    // determine how the address for each transfer within the burst is calculated.
		output wire [1 : 0] M_AXI_ARBURST,
		// Lock type. Provides additional information about the
    // atomic characteristics of the transfer.
		output wire  M_AXI_ARLOCK,
		// Memory type. This signal indicates how transactions
    // are required to progress through a system.
		output wire [3 : 0] M_AXI_ARCACHE,
		// Protection type. This signal indicates the privilege
    // and security level of the transaction, and whether
    // the transaction is a data access or an instruction access.
		output wire [2 : 0] M_AXI_ARPROT,
		// Quality of Service, QoS identifier sent for each read transaction
		output wire [3 : 0] M_AXI_ARQOS,
		// Optional User-defined signal in the read address channel.
		output wire [C_M_AXI_ARUSER_WIDTH-1 : 0] M_AXI_ARUSER,
		// Write address valid. This signal indicates that
    // the channel is signaling valid read address and control information
		output wire  M_AXI_ARVALID,
		// Read address ready. This signal indicates that
    // the slave is ready to accept an address and associated control signals
		input wire  M_AXI_ARREADY,
		// Read ID tag. This signal is the identification tag
    // for the read data group of signals generated by the slave.
		input wire [C_M_AXI_ID_WIDTH-1 : 0] M_AXI_RID,
		// Master Read Data
		input wire [C_M_AXI_DATA_WIDTH-1 : 0] M_AXI_RDATA,
		// Read response. This signal indicates the status of the read transfer
		input wire [1 : 0] M_AXI_RRESP,
		// Read last. This signal indicates the last transfer in a read burst
		input wire  M_AXI_RLAST,
		// Optional User-defined signal in the read address channel.
		input wire [C_M_AXI_RUSER_WIDTH-1 : 0] M_AXI_RUSER,
		// Read valid. This signal indicates that the channel
    // is signaling the required read data.
		input wire  M_AXI_RVALID,
		// Read ready. This signal indicates that the master can
    // accept the read data and response information.
		output wire  M_AXI_RREADY
	);

    localparam integer C_M_AXI_BURST_LEN	= CACHE_LINE_SIZE / 4;
	// function called clogb2 that returns an integer which has the
	//value of the ceiling of the log base 2

	  // function called clogb2 that returns an integer which has the 
	  // value of the ceiling of the log base 2.                      
	  function integer clogb2 (input integer bit_depth);              
	  begin                                                           
	    for(clogb2=0; bit_depth>0; clogb2=clogb2+1)                   
	      bit_depth = bit_depth >> 1;                                 
	    end                                                           
	  endfunction                                                     

	// C_TRANSACTIONS_NUM is the width of the index counter for 
	// number of write or read transaction.
	 localparam integer C_TRANSACTIONS_NUM = clogb2(C_M_AXI_BURST_LEN-1);

	// Burst length for transactions, in C_M_AXI_DATA_WIDTHs.
	// Non-2^n lengths will eventually cause bursts across 4K address boundaries.
	 localparam integer C_MASTER_LENGTH	= 12;
	// total number of burst transfers is master length divided by burst length and burst size
	 localparam integer C_NO_BURSTS_REQ = C_MASTER_LENGTH-clogb2((C_M_AXI_BURST_LEN*C_M_AXI_DATA_WIDTH/8)-1);
	// Example State machine to initialize counter, initialize write transactions, 
	// initialize read transactions and comparison of read data with the 
	// written data words.
	parameter [1:0] IDLE = 2'b00, // This state initiates AXI4Lite transaction 
			// after the state machine changes state to INIT_WRITE 
			// when there is 0 to 1 transition on INIT_AXI_TXN
		INIT_WRITE   = 2'b01, // This state initializes write transaction,
			// once writes are done, the state machine 
			// changes state to INIT_READ 
		INIT_READ = 2'b10, // This state initializes read transaction
			// once reads are done, the state machine 
			// changes state to INIT_COMPARE 
		INIT_COMPARE = 2'b11; // This state issues the status of comparison 
			// of the written data with the read data	

	 reg [1:0] mst_exec_state;

	// AXI4LITE signals
	//AXI4 internal temp signals
	reg [C_M_AXI_ADDR_WIDTH-1 : 0] 	axi_awaddr;
	reg  	axi_awvalid;
	reg [C_M_AXI_DATA_WIDTH-1 : 0] 	axi_wdata;
	reg  	axi_wlast;
	reg  	axi_wvalid;
	reg  	axi_bready;
	reg [C_M_AXI_ADDR_WIDTH-1 : 0] 	axi_araddr;
	reg  	axi_arvalid;
	reg  	axi_rready;
	//write beat count in a burst
	reg [C_TRANSACTIONS_NUM : 0] 	write_index;
	//read beat count in a burst
	reg [C_TRANSACTIONS_NUM : 0] 	read_index;
	localparam integer OFFSET_LEN = clogb2(CACHE_LINE_SIZE) - 1;
	reg [OFFSET_LEN - 1 : 0] 	my_read_index;
	reg [OFFSET_LEN - 1 : 0] 	start_read_index;
	//size of C_M_AXI_BURST_LEN length burst in bytes
	wire [C_TRANSACTIONS_NUM+2 : 0] 	burst_size_bytes;
	//The burst counters are used to track the number of burst transfers of C_M_AXI_BURST_LEN burst length needed to transfer 2^C_MASTER_LENGTH bytes of data.
	reg [C_NO_BURSTS_REQ : 0] 	write_burst_counter;
	reg [C_NO_BURSTS_REQ : 0] 	read_burst_counter;
	reg  	start_single_burst_write;
	reg  	start_single_burst_read;
	reg  	writes_done;
	reg  	reads_done;
	reg  	error_reg;
	reg  	compare_done;
	reg  	read_mismatch;
	reg  	burst_write_active;
	reg  	burst_read_active;
	reg [C_M_AXI_DATA_WIDTH-1 : 0] 	expected_rdata;
	//Interface response error flags
	wire  	write_resp_error;
	wire  	read_resp_error;
	wire  	wnext;
	wire  	rnext;
	reg  	init_txn_ff;
	reg  	init_txn_ff2;
	reg  	init_txn_edge;
	wire  	init_txn_pulse;
    reg  	init_wrn_ff;
    reg      init_wrn_ff2;
    reg      init_wrn_edge;
    wire     init_wrn_pulse;

	// I/O Connections assignments

	//I/O Connections. Write Address (AW)
	assign M_AXI_AWID	= 'b0;
	//The AXI address is a concatenation of the target base address + active offset range
	wire [31:0] mask =  ~(CACHE_LINE_SIZE - 1);
	//wire slave_adress_stall = (burst_read_active);
	wire [31:0] slave_addr = start_read ?  slave_address : slave_addr;

//	reg [31:0] slave_addr;
//	always @(posedge M_AXI_ACLK or posedge start_read)
//	begin
//	   if (M_AXI_ARESETN == 0 ) 
//	       slave_addr <= 0;
//	   else if(start_read)
//	       slave_addr <= slave_address;
//	   else
//	       slave_addr <= slave_addr;
//	end

//    reg [31:0] slave_address;
//    always @(negedge M_AXI_ACLK)
//    begin
//        slave_address <= address;
//    end

    wire [31:0]  slave_address = address;
	
	assign M_AXI_AWADDR	= (slave_addr)  + axi_awaddr;
	//Burst LENgth is number of transaction beats, minus 1
	assign M_AXI_AWLEN = C_M_AXI_BURST_LEN - 1;
	//Size should be C_M_AXI_DATA_WIDTH, in 2^SIZE bytes, otherwise narrow bursts are used
	assign M_AXI_AWSIZE	= clogb2((C_M_AXI_DATA_WIDTH/8)-1);
	//INCR burst type is usually used, except for keyhole bursts
	assign M_AXI_AWBURST	= BURST_TYPE;//2'b01;
	assign M_AXI_AWLOCK	= 1'b0;
	//Update value to 4'b0011 if coherent accesses to be used via the Zynq ACP port. Not Allocated, Modifiable, not Bufferable. Not Bufferable since this example is meant to test memory, not intermediate cache. 
	assign M_AXI_AWCACHE	= 4'b0010;
	assign M_AXI_AWPROT	= 3'h0;
	assign M_AXI_AWQOS	= 4'h0;
	assign M_AXI_AWUSER	= 'b1;
	assign M_AXI_AWVALID	= axi_awvalid;
	//Write Data(W)
	assign M_AXI_WDATA	= axi_wdata;
	//All bursts are complete and aligned in this example
	assign M_AXI_WSTRB	= {(C_M_AXI_DATA_WIDTH/8){1'b1}};
	assign M_AXI_WLAST	= axi_wlast;
	assign M_AXI_WUSER	= 'b0;
	assign M_AXI_WVALID	= axi_wvalid;
	//Write Response (B)
	assign M_AXI_BREADY	= axi_bready;
	//Read Address (AR)
	assign M_AXI_ARID	= 'b0;
	assign M_AXI_ARADDR	= (slave_addr)  + axi_araddr;
	//Burst LENgth is number of transaction beats, minus 1
	assign M_AXI_ARLEN	= C_M_AXI_BURST_LEN - 1;
	//Size should be C_M_AXI_DATA_WIDTH, in 2^n bytes, otherwise narrow bursts are used
	assign M_AXI_ARSIZE	= clogb2((C_M_AXI_DATA_WIDTH/8)-1);
	//INCR burst type is usually used, except for keyhole bursts
	assign M_AXI_ARBURST	= BURST_TYPE;
	assign M_AXI_ARLOCK	= 1'b0;
	//Update value to 4'b0011 if coherent accesses to be used via the Zynq ACP port. Not Allocated, Modifiable, not Bufferable. Not Bufferable since this example is meant to test memory, not intermediate cache. 
	assign M_AXI_ARCACHE	= 4'b0010;
	assign M_AXI_ARPROT	= 3'h0;
	assign M_AXI_ARQOS	= 4'h0;
	assign M_AXI_ARUSER	= 'b1;
	assign M_AXI_ARVALID	= axi_arvalid;
	//Read and Read Response (R)
	assign M_AXI_RREADY	= axi_rready;
	//Example design I/O
//	assign TXN_DONE	= compare_done;
	//Burst size in bytes
	assign burst_size_bytes	= C_M_AXI_BURST_LEN * C_M_AXI_DATA_WIDTH/8;
	assign init_txn_pulse	= (!init_txn_ff2) && init_txn_ff;
    assign init_wrn_pulse	= (!init_wrn_ff2) && init_wrn_ff;

	//Generate a pulse to initiate AXI transaction.
	wire start_read;
	always @(posedge M_AXI_ACLK)										      
	  begin                                                                        
	    // Initiates AXI transaction delay    
	    if (M_AXI_ARESETN == 0 )                                                   
	      begin                                                                    
	        init_txn_ff <= 1'b0;                                                   
	        init_txn_ff2 <= 1'b0;                                                   
	      end                                                                               
	    else                                                                       
	      begin  
	        init_txn_ff <=  start_read;
	        init_txn_ff2 <= init_txn_ff;                                                                 
	      end                                                                      
	  end                                                                                                                                              

	//----------------------------
	//Read Address Channel
	//----------------------------

	//The Read Address Channel (AW) provides a similar function to the
	//Write Address channel- to provide the tranfer qualifiers for the burst.

	//In this example, the read address increments in the same
	//manner as the write address channel.

	  always @(posedge M_AXI_ACLK)                                 
	  begin                                                              
	                                                                     
	    if (M_AXI_ARESETN == 0 || init_txn_pulse == 1'b1 )                                         
	      begin                                                          
	        axi_arvalid <= 1'b0;                                         
	      end                                                            
	    // If previously not valid , start next transaction              
	    else if (~axi_arvalid && start_single_burst_read)                
	      begin                                                          
	        axi_arvalid <= 1'b1;                                         
	      end                                                            
	    else if (M_AXI_ARREADY && axi_arvalid)                           
	      begin                                                          
	        axi_arvalid <= 1'b0;                                         
	      end                                                            
	    else                                                             
	      axi_arvalid <= axi_arvalid;                                    
	  end                                                                
	                                                                     
	                                                                     
	// Next address after ARREADY indicates previous address acceptance  
	  always @(posedge M_AXI_ACLK)                                       
	  begin                                                              
	    if (M_AXI_ARESETN == 0 || init_txn_pulse == 1'b1)                                          
	      begin                                                          
	        axi_araddr <= 'b0;                                           
	      end                                                            
	    else if (M_AXI_ARREADY && axi_arvalid)                           
	      begin                                                          
	        axi_araddr <= axi_araddr + burst_size_bytes;                 
	      end                                                            
	    else                                                             
	      axi_araddr <= axi_araddr;                                      
	  end                                                                


	//--------------------------------
	//Read Data (and Response) Channel
	//--------------------------------

	 // Forward movement occurs when the channel is valid and ready   
	  assign rnext = M_AXI_RVALID && axi_rready;                            
	                                                                        
	                                                                        
	// Burst length counter. Uses extra counter register bit to indicate    
	// terminal count to reduce decode logic                                
	  always @(posedge M_AXI_ACLK)                                          
	  begin                                                                 
	    if (M_AXI_ARESETN == 0 || init_txn_pulse == 1'b1 || start_single_burst_read)                  
	      begin                                                             
	        read_index <= 0; 
	        my_read_index <= slave_addr[index_lsb-1:0];  
	        start_read_index <= slave_addr[index_lsb-1:0];                                      
	      end                                                               
	    else if (rnext && (read_index != C_M_AXI_BURST_LEN-1))              
	      begin                                                             
	        read_index <= (read_index + 1);   
	        my_read_index <= (my_read_index + 4);//  & (CACHE_LINE_SIZE-1);                       
	      end                                                               
	    else       
	      begin                                                         
	      read_index <= read_index;   
	      my_read_index <= my_read_index;   
	      end                                   
	  end                                                                   
	                                                                        
	                                                                        
	/*                                                                      
	 The Read Data channel returns the results of the read request          
	                                                                        
	 In this example the data checker is always able to accept              
	 more data, so no need to throttle the RREADY signal                    
	 */                                                                     
	  always @(posedge M_AXI_ACLK or posedge M_AXI_RVALID)                                          
	  begin                                                                 
	    if (M_AXI_ARESETN == 0 || init_txn_pulse == 1'b1 )                  
	      begin                                                             
	        axi_rready <= 1'b0;                                             
	      end                                                               
	    // accept/acknowledge rdata/rresp with axi_rready by the master     
	    // when M_AXI_RVALID is asserted by slave                           
	    else if (M_AXI_RVALID)                       
	      begin                                      
	         if (M_AXI_RLAST && axi_rready)          
	          begin                                  
	            axi_rready <= 1'b0;                  
	          end                                    
	         else                                    
	           begin                                 
	             axi_rready <= 1'b1;                 
	           end                                   
	      end                                        
	    // retain the previous value                 
	  end                                            
                                                                                                    
	                                                                                                            
//	 // read_burst_counter counter keeps track with the number of burst transaction initiated                   
//	 // against the number of burst transactions the master needs to initiate                                   
	  always @(posedge M_AXI_ACLK)                                                                              
	  begin                                                                                                     
	    if (M_AXI_ARESETN == 0 || init_txn_pulse == 1'b1)                                                                                 
	      begin                                                                                                 
	        read_burst_counter <= 'b0;                                                                          
	      end                                                                                                   
	    else if (M_AXI_ARREADY && axi_arvalid)                                                                  
	      begin                                                                                                 
	        if (read_burst_counter[C_NO_BURSTS_REQ] == 1'b0)                                                    
	          begin                                                                                             
	            read_burst_counter <= read_burst_counter + 1'b1;                                                
	            //read_burst_counter[C_NO_BURSTS_REQ] <= 1'b1;                                                  
	          end                                                                                               
	      end                                                                                                   
	    else                                                                                                    
	      read_burst_counter <= read_burst_counter;                                                             
	  end                                                                                                       
	                                                                                                                                                                                                                                                                                                                      
                                                                                             
//	  // burst_read_active signal is asserted when there is a burst write transaction                           
//	  // is initiated by the assertion of start_single_burst_write. start_single_burst_read                     
//	  // signal remains asserted until the burst read is accepted by the master                                 
	  always @(posedge M_AXI_ACLK)                                                                              
	  begin                                                                                                     
	    if (M_AXI_ARESETN == 0 || init_txn_pulse == 1'b1)                                                                                 
	      burst_read_active <= 1'b0;                                                                            
	                                                                                                            
	    //The burst_write_active is asserted when a write burst transaction is initiated                        
	    else if (start_single_burst_read)                                                                       
	      burst_read_active <= 1'b1;                                                                            
	    else if (M_AXI_RVALID && axi_rready && M_AXI_RLAST)                                                     
	      burst_read_active <= 0;                                                                               
	    end                                                                                                     
	                                                                                                            
	                                                                                                            
//	 // Check for last read completion.                                                                         
	                                                                                                            
//	 // This logic is to qualify the last read count with the final read                                        
//	 // response. This demonstrates how to confirm that a read has been                                         
//	 // committed.                                                                                              
	                                                                                                            
	  always @(posedge M_AXI_ACLK)                                                                              
	  begin                                                                                                     
	    if (M_AXI_ARESETN == 0 || init_txn_pulse == 1'b1)                                                                                 
	      reads_done <= 1'b0;                                                                                   
	                                                                                                            
	    //The reads_done should be associated with a rready response                                            
	    //else if (M_AXI_BVALID && axi_bready && (write_burst_counter == {(C_NO_BURSTS_REQ-1){1}}) && axi_wlast)
	    else if (M_AXI_RVALID && axi_rready && (read_index == C_M_AXI_BURST_LEN-1) && (read_burst_counter[C_NO_BURSTS_REQ]))
	      reads_done <= 1'b1;                                                                                   
	    else                                                                                                    
	      reads_done <= reads_done;                                                                             
	    end                                                                                                     


	// Add user logic here
	localparam integer index_lsb = clogb2(CACHE_LINE_SIZE) - 1;
	localparam integer index_len = clogb2(CACHE_LINE_NO) - 1;
	localparam integer tag_lsb = index_lsb + index_len;
	localparam integer index_msb = tag_lsb - 1;
	
	reg [7:0] cache [CACHE_LINE_NO - 1:0][CACHE_LINE_SIZE - 1:0];
	reg valid [CACHE_LINE_NO - 1:0];
	reg [31: tag_lsb] tag [CACHE_LINE_NO - 1:0];
	reg read_cache_lines [CACHE_LINE_SIZE/4 - 1:0];
	reg missreg, prev_miss;
	reg dup_miss;
	
	//ATENÇAO! ESTE DELAY NAO DEVE ESTAR AQUI
	wire hit1 = (valid[slave_address[index_msb:index_lsb]] && (tag[slave_address[index_msb:index_lsb]] == slave_address[31:tag_lsb]));
	wire hit2 = (burst_read_active && read_cache_lines[slave_address[index_lsb-1:2]]) && (slave_address[31:index_lsb] == slave_addr[31:index_lsb] );
	wire hit3 = (M_AXI_RVALID && (slave_address[index_lsb-1:0] == my_read_index) && (slave_address[31:index_lsb] == slave_addr[31:index_lsb] ));
	assign miss =  (M_AXI_ARESETN == 0) ? 1'b0 : 
	               (M_AXI_ACLK)         ? miss : ~( hit1 || hit2 || hit3 );
	
	
	assign data = (miss) ? 32'b0 : (hit1 || hit2) ? {cache[slave_address[index_msb:index_lsb]][slave_address[index_lsb-1:0] + 3],
	                              cache[slave_address[index_msb:index_lsb]][slave_address[index_lsb-1:0] + 2],
	                              cache[slave_address[index_msb:index_lsb]][slave_address[index_lsb-1:0] + 1],
	                              cache[slave_address[index_msb:index_lsb]][slave_address[index_lsb-1:0] + 0] } :
	                              M_AXI_RDATA
	                              ;
	                           
	wire [index_len-1:0] line =  slave_address[index_msb:index_lsb];  
	                           
	always @(miss)
	begin
	   missreg <= miss;
	end
	                          
	always @(posedge M_AXI_ACLK)
	begin
	   prev_miss <= missreg; 
	end
	
	always @(posedge M_AXI_ACLK)
	begin
	   dup_miss <= (M_AXI_RLAST & M_AXI_RVALID & M_AXI_RREADY) && miss;
	end
	
	wire is_reading = init_txn_pulse | start_single_burst_read | burst_read_active;
    assign  start_read = ((miss & ~prev_miss)  || dup_miss) & ~is_reading;

    always @(posedge start_read)
    begin
        valid[slave_address[index_msb:index_lsb]] <= 0;
    end

    integer i;
	always @(posedge M_AXI_ACLK)
	begin
	   if(M_AXI_ARESETN == 0)
	   begin  	       
	       for(i = 0; i < CACHE_LINE_NO; i=i+1)
	       begin
	           tag[i] <= 0;
	           valid[i] <= 0;
	       end
	   end
	   else if(M_AXI_RLAST & M_AXI_RVALID & M_AXI_RREADY) 
	   begin
	      tag[slave_addr[index_msb:index_lsb]] <= slave_addr[31:tag_lsb];
	      valid[slave_addr[index_msb:index_lsb]] <= 1'b1;
	   end	       
	end
	
	always @(posedge M_AXI_ACLK) 
	begin
	if(rnext && burst_read_active)
	begin
        cache[slave_addr[index_msb:index_lsb]][(my_read_index) + 3] <= M_AXI_RDATA[31:24];
        cache[slave_addr[index_msb:index_lsb]][(my_read_index) + 2] <= M_AXI_RDATA[23:16];
        cache[slave_addr[index_msb:index_lsb]][(my_read_index) + 1] <= M_AXI_RDATA[15:8];
        cache[slave_addr[index_msb:index_lsb]][(my_read_index) + 0] <= M_AXI_RDATA[7:0];
        read_cache_lines[my_read_index/4] <= 1'b1;
    end
	end
    
    integer j;
    always @(posedge M_AXI_ACLK)                                                                              
    begin 
        if (~axi_arvalid && ~burst_read_active && ~start_single_burst_read && init_txn_pulse)     
        begin                                                                                                       
            start_single_burst_read <= 1'b1;          
            for(j = 0; j < CACHE_LINE_SIZE/4; j=j+1)
                read_cache_lines[j] <= 1'b0;       
        end                                                                                                                     
        else                                                                                                                                                                              
            start_single_burst_read <= 1'b0; //Negate to generate a pulse                            
    end   
    
	endmodule