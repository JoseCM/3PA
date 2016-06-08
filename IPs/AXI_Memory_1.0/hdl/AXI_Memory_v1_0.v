`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.05.2016 02:43:28
// Design Name: 
// Module Name: AXI_Memory_v1_0
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


module AXI_Memory_v1_0 # (
		// Users to add parameters here
        parameter integer C_S00_AXI_MEM_INSTR_MIN=0,
        parameter integer C_S00_AXI_MEM_INSTR_MAX=511,
        parameter integer C_S00_AXI_MEM_DATA_MIN=512,
        parameter integer C_S00_AXI_MEM_DATA_MAX=65535,
		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Slave Bus Interface S00_AXI
		parameter integer C_S00_AXI_ID_WIDTH	= 3,
		parameter integer C_S00_AXI_DATA_WIDTH	= 32,
		parameter integer C_S00_AXI_ADDR_WIDTH	= 32,
		parameter integer C_S00_AXI_AWUSER_WIDTH	= 0,
		parameter integer C_S00_AXI_ARUSER_WIDTH	= 0,
		parameter integer C_S00_AXI_WUSER_WIDTH	= 0,
		parameter integer C_S00_AXI_RUSER_WIDTH	= 0,
		parameter integer C_S00_AXI_BUSER_WIDTH	= 0
		
	)
	(
		// Users to add ports here
        output wire  s00_axi_mem_address_violation,
		// User ports ends
		// Do not modify the ports beyond this line


		// Ports of Axi Slave Bus Interface S00_AXI
		input wire  s00_axi_aclk,
		input wire  s00_axi_aresetn,
		input wire [C_S00_AXI_ID_WIDTH-1 : 0] s00_axi_awid,
		input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_awaddr,
		input wire [7 : 0] s00_axi_awlen,
		input wire [2 : 0] s00_axi_awsize,
		input wire [1 : 0] s00_axi_awburst,
		input wire  s00_axi_awlock,
		input wire [3 : 0] s00_axi_awcache,
		input wire [2 : 0] s00_axi_awprot,
		input wire [3 : 0] s00_axi_awqos,
		input wire [3 : 0] s00_axi_awregion,
		input wire [C_S00_AXI_AWUSER_WIDTH-1 : 0] s00_axi_awuser,
		input wire  s00_axi_awvalid,
		output wire  s00_axi_awready,
		input wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_wdata,
		input wire [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s00_axi_wstrb,
		input wire  s00_axi_wlast,
		input wire [C_S00_AXI_WUSER_WIDTH-1 : 0] s00_axi_wuser,
		input wire  s00_axi_wvalid,
		output wire  s00_axi_wready,
		output wire [C_S00_AXI_ID_WIDTH-1 : 0] s00_axi_bid,
		output wire [1 : 0] s00_axi_bresp,
		output wire [C_S00_AXI_BUSER_WIDTH-1 : 0] s00_axi_buser,
		output wire  s00_axi_bvalid,
		input wire  s00_axi_bready,
		input wire [C_S00_AXI_ID_WIDTH-1 : 0] s00_axi_arid,
		input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_araddr,
		input wire [7 : 0] s00_axi_arlen,
		input wire [2 : 0] s00_axi_arsize,
		input wire [1 : 0] s00_axi_arburst,
		input wire  s00_axi_arlock,
		input wire [3 : 0] s00_axi_arcache,
		input wire [2 : 0] s00_axi_arprot,
		input wire [3 : 0] s00_axi_arqos,
		input wire [3 : 0] s00_axi_arregion,
		input wire [C_S00_AXI_ARUSER_WIDTH-1 : 0] s00_axi_aruser,
		input wire  s00_axi_arvalid,
		output wire  s00_axi_arready,
		output wire [C_S00_AXI_ID_WIDTH-1 : 0] s00_axi_rid,
		output wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_rdata,
		output wire [1 : 0] s00_axi_rresp,
		output wire  s00_axi_rlast,
		output wire [C_S00_AXI_RUSER_WIDTH-1 : 0] s00_axi_ruser,
		output wire  s00_axi_rvalid,
		input wire  s00_axi_rready
	);	
	
	localparam integer ADDR_LSB = (C_S00_AXI_DATA_WIDTH/32)+ 1;
    localparam integer OPT_MEM_ADDR_BITS = 29; //7;
    
    wire [C_S00_AXI_ADDR_WIDTH-1 : 0] axi_awaddr_w;
	
//Instantiation of Axi Bus Interface S00_AXI
	blk_mem_gen_0 memor (
		s00_axi_aclk,
		s00_axi_aresetn,
		s00_axi_awid,
		axi_awaddr_w,//s00_axi_awaddr,
		s00_axi_awlen,
		s00_axi_awsize,
		s00_axi_awburst,
		s00_axi_awvalid,
		s00_axi_awready,
		s00_axi_wdata,
		s00_axi_wstrb,
		s00_axi_wlast,
		s00_axi_wvalid,
		s00_axi_wready,
		s00_axi_bid,
		s00_axi_bresp,
		s00_axi_bvalid,
		s00_axi_bready,
		s00_axi_arid,
		s00_axi_araddr,
		s00_axi_arlen,
		s00_axi_arsize,
		s00_axi_arburst,
		s00_axi_arvalid,
		s00_axi_arready,
		s00_axi_rid,
		s00_axi_rdata,
		s00_axi_rresp,
		s00_axi_rlast,
		s00_axi_rvalid,
		s00_axi_rready
	);

    // if address is in the non-write zone (instructions zone)
    assign axi_awaddr_w = ((s00_axi_awaddr >= C_S00_AXI_MEM_INSTR_MIN) && (s00_axi_awaddr  <= C_S00_AXI_MEM_INSTR_MAX) && s00_axi_awvalid)?
                        32'h0000ffff : s00_axi_awaddr;
                        
    assign s00_axi_mem_address_violation = ((s00_axi_awaddr >= C_S00_AXI_MEM_INSTR_MIN) && (s00_axi_awaddr  <= C_S00_AXI_MEM_INSTR_MAX) && s00_axi_awvalid)?
                                                1 : 0;
    
endmodule
