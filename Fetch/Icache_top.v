   
`timescale 1 ns / 1 ps

	module Icache_AXIMaster #
	(
		// Users to add parameters here
        parameter CACHE_LINE_NO = 8,
        parameter CACHE_LINE_SIZE = 128,
        parameter BURST_TYPE = 1,
		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Master Bus Interface M02_AXI
		//parameter  C_M02_AXI_TARGET_SLAVE_BASE_ADDR	= 32'h40000000,
		//parameter integer C_M02_AXI_BURST_LEN	= 128,
		parameter integer C_M02_AXI_ID_WIDTH	= 1,
		parameter integer C_M02_AXI_ADDR_WIDTH	= 32,
		parameter integer C_M02_AXI_DATA_WIDTH	= 32,
		parameter integer C_M02_AXI_AWUSER_WIDTH	= 0,
		parameter integer C_M02_AXI_ARUSER_WIDTH	= 0,
		parameter integer C_M02_AXI_WUSER_WIDTH	= 0,
		parameter integer C_M02_AXI_RUSER_WIDTH	= 0,
		parameter integer C_M02_AXI_BUSER_WIDTH	= 0
	)
	(
		// Users to add ports here
		output wire miss,
        output wire [31:0] data,
        input wire [C_M02_AXI_ADDR_WIDTH - 1:0] slave_addr,
		// User ports ends
		// Do not modify the ports beyond this line


		// Ports of Axi Master Bus Interface M02_AXI
//		input wire  m02_axi_init_axi_txn,
//		input wire  m02_axi_init_axi_wrn,
//		output wire  m02_axi_txn_done,
//		output wire  m02_axi_error,
		input wire  m02_axi_aclk,
		input wire  m02_axi_aresetn,
		output wire [C_M02_AXI_ID_WIDTH-1 : 0] m02_axi_awid,
		output wire [C_M02_AXI_ADDR_WIDTH-1 : 0] m02_axi_awaddr,
		output wire [7 : 0] m02_axi_awlen,
		output wire [2 : 0] m02_axi_awsize,
		output wire [1 : 0] m02_axi_awburst,
		output wire  m02_axi_awlock,
		output wire [3 : 0] m02_axi_awcache,
		output wire [2 : 0] m02_axi_awprot,
		output wire [3 : 0] m02_axi_awqos,
		output wire [C_M02_AXI_AWUSER_WIDTH-1 : 0] m02_axi_awuser,
		output wire  m02_axi_awvalid,
		input wire  m02_axi_awready,
		output wire [C_M02_AXI_DATA_WIDTH-1 : 0] m02_axi_wdata,
		output wire [C_M02_AXI_DATA_WIDTH/8-1 : 0] m02_axi_wstrb,
		output wire  m02_axi_wlast,
		output wire [C_M02_AXI_WUSER_WIDTH-1 : 0] m02_axi_wuser,
		output wire  m02_axi_wvalid,
		input wire  m02_axi_wready,
		input wire [C_M02_AXI_ID_WIDTH-1 : 0] m02_axi_bid,
		input wire [1 : 0] m02_axi_bresp,
		input wire [C_M02_AXI_BUSER_WIDTH-1 : 0] m02_axi_buser,
		input wire  m02_axi_bvalid,
		output wire  m02_axi_bready,
		output wire [C_M02_AXI_ID_WIDTH-1 : 0] m02_axi_arid,
		output wire [C_M02_AXI_ADDR_WIDTH-1 : 0] m02_axi_araddr,
		output wire [7 : 0] m02_axi_arlen,
		output wire [2 : 0] m02_axi_arsize,
		output wire [1 : 0] m02_axi_arburst,
		output wire  m02_axi_arlock,
		output wire [3 : 0] m02_axi_arcache,
		output wire [2 : 0] m02_axi_arprot,
		output wire [3 : 0] m02_axi_arqos,
		output wire [C_M02_AXI_ARUSER_WIDTH-1 : 0] m02_axi_aruser,
		output wire  m02_axi_arvalid,
		input wire  m02_axi_arready,
		input wire [C_M02_AXI_ID_WIDTH-1 : 0] m02_axi_rid,
		input wire [C_M02_AXI_DATA_WIDTH-1 : 0] m02_axi_rdata,
		input wire [1 : 0] m02_axi_rresp,
		input wire  m02_axi_rlast,
		input wire [C_M02_AXI_RUSER_WIDTH-1 : 0] m02_axi_ruser,
		input wire  m02_axi_rvalid,
		output wire  m02_axi_rready
	);
// Instantiation of Axi Bus Interface M02_AXI
	ICache_AXIMaster_core # ( 
	    .CACHE_LINE_NO(CACHE_LINE_NO),
        .CACHE_LINE_SIZE(CACHE_LINE_SIZE),
        .BURST_TYPE(BURST_TYPE),
		//.C_M_TARGET_SLAVE_BASE_ADDR(C_M02_AXI_TARGET_SLAVE_BASE_ADDR),
		//.C_M_AXI_BURST_LEN(C_M02_AXI_BURST_LEN),
		.C_M_AXI_ID_WIDTH(C_M02_AXI_ID_WIDTH),
		.C_M_AXI_ADDR_WIDTH(C_M02_AXI_ADDR_WIDTH),
		.C_M_AXI_DATA_WIDTH(C_M02_AXI_DATA_WIDTH),
		.C_M_AXI_AWUSER_WIDTH(C_M02_AXI_AWUSER_WIDTH),
		.C_M_AXI_ARUSER_WIDTH(C_M02_AXI_ARUSER_WIDTH),
		.C_M_AXI_WUSER_WIDTH(C_M02_AXI_WUSER_WIDTH),
		.C_M_AXI_RUSER_WIDTH(C_M02_AXI_RUSER_WIDTH),
		.C_M_AXI_BUSER_WIDTH(C_M02_AXI_BUSER_WIDTH)
	) ICache_AXIMaster_corel_inst (
	    .miss(miss),
	    .data(data),
	    .address(slave_addr),
//	    .INIT_AXI_WRN(m02_axi_init_axi_wrn),
//		.INIT_AXI_TXN(m02_axi_init_axi_txn),
//		.TXN_DONE(m02_axi_txn_done),
//		.ERROR(m02_axi_error),
		.M_AXI_ACLK(m02_axi_aclk),
		.M_AXI_ARESETN(m02_axi_aresetn),
		.M_AXI_AWID(m02_axi_awid),
		.M_AXI_AWADDR(m02_axi_awaddr),
		.M_AXI_AWLEN(m02_axi_awlen),
		.M_AXI_AWSIZE(m02_axi_awsize),
		.M_AXI_AWBURST(m02_axi_awburst),
		.M_AXI_AWLOCK(m02_axi_awlock),
		.M_AXI_AWCACHE(m02_axi_awcache),
		.M_AXI_AWPROT(m02_axi_awprot),
		.M_AXI_AWQOS(m02_axi_awqos),
		.M_AXI_AWUSER(m02_axi_awuser),
		.M_AXI_AWVALID(m02_axi_awvalid),
		.M_AXI_AWREADY(m02_axi_awready),
		.M_AXI_WDATA(m02_axi_wdata),
		.M_AXI_WSTRB(m02_axi_wstrb),
		.M_AXI_WLAST(m02_axi_wlast),
		.M_AXI_WUSER(m02_axi_wuser),
		.M_AXI_WVALID(m02_axi_wvalid),
		.M_AXI_WREADY(m02_axi_wready),
		.M_AXI_BID(m02_axi_bid),
		.M_AXI_BRESP(m02_axi_bresp),
		.M_AXI_BUSER(m02_axi_buser),
		.M_AXI_BVALID(m02_axi_bvalid),
		.M_AXI_BREADY(m02_axi_bready),
		.M_AXI_ARID(m02_axi_arid),
		.M_AXI_ARADDR(m02_axi_araddr),
		.M_AXI_ARLEN(m02_axi_arlen),
		.M_AXI_ARSIZE(m02_axi_arsize),
		.M_AXI_ARBURST(m02_axi_arburst),
		.M_AXI_ARLOCK(m02_axi_arlock),
		.M_AXI_ARCACHE(m02_axi_arcache),
		.M_AXI_ARPROT(m02_axi_arprot),
		.M_AXI_ARQOS(m02_axi_arqos),
		.M_AXI_ARUSER(m02_axi_aruser),
		.M_AXI_ARVALID(m02_axi_arvalid),
		.M_AXI_ARREADY(m02_axi_arready),
		.M_AXI_RID(m02_axi_rid),
		.M_AXI_RDATA(m02_axi_rdata),
		.M_AXI_RRESP(m02_axi_rresp),
		.M_AXI_RLAST(m02_axi_rlast),
		.M_AXI_RUSER(m02_axi_ruser),
		.M_AXI_RVALID(m02_axi_rvalid),
		.M_AXI_RREADY(m02_axi_rready)
	);

	// Add user logic here

	// User logic ends

	endmodule