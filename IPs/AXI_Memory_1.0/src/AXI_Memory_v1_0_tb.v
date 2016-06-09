`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.05.2016 17:06:49
// Design Name: 
// Module Name: AXI_Slave_Memory_v1_0_tb
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


module AXI_Memory_v1_0_tb;
    integer i;
    parameter integer C_S00_AXI_MEM_INSTR_MIN=0;
    parameter integer C_S00_AXI_MEM_INSTR_MAX=511;
    parameter integer C_S00_AXI_MEM_DATA_MIN=512;
    parameter integer C_S00_AXI_MEM_DATA_MAX=65535;
    parameter integer C_S00_AXI_ID_WIDTH	= 1;
    parameter integer C_S00_AXI_DATA_WIDTH	= 32;
    parameter integer C_S00_AXI_ADDR_WIDTH	= 32;
    parameter integer C_S00_AXI_AWUSER_WIDTH	= 0;
    parameter integer C_S00_AXI_ARUSER_WIDTH	= 0;
    parameter integer C_S00_AXI_WUSER_WIDTH	= 0;
    parameter integer C_S00_AXI_RUSER_WIDTH	= 0;
    parameter integer C_S00_AXI_BUSER_WIDTH	= 0;
    
    wire  s00_axi_mem_address_violation;
    reg  s00_axi_aclk;
    reg  s00_axi_aresetn;
    reg [C_S00_AXI_ID_WIDTH-1 : 0] s00_axi_awid;
    reg [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_awaddr;
    reg [7 : 0] s00_axi_awlen;
    reg [2 : 0] s00_axi_awsize;
    reg [1 : 0] s00_axi_awburst;
    reg  s00_axi_awlock;
    reg [3 : 0] s00_axi_awcache;
    reg [2 : 0] s00_axi_awprot;
    reg [3 : 0] s00_axi_awqos;
    reg [3 : 0] s00_axi_awregion;
    reg [C_S00_AXI_AWUSER_WIDTH-1 : 0] s00_axi_awuser;
    reg  s00_axi_awvalid;
    wire  s00_axi_awready;
    reg [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_wdata;
    reg [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s00_axi_wstrb;
    reg  s00_axi_wlast;
    reg [C_S00_AXI_WUSER_WIDTH-1 : 0] s00_axi_wuser;
    reg  s00_axi_wvalid;
    wire  s00_axi_wready;
    wire [C_S00_AXI_ID_WIDTH-1 : 0] s00_axi_bid;
    wire [1 : 0] s00_axi_bresp;
    wire [C_S00_AXI_BUSER_WIDTH-1 : 0] s00_axi_buser;
    wire  s00_axi_bvalid;
    reg  s00_axi_bready;
    reg [C_S00_AXI_ID_WIDTH-1 : 0] s00_axi_arid;
    reg [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_araddr;
    reg [7 : 0] s00_axi_arlen;
    reg [2 : 0] s00_axi_arsize;
    reg [1 : 0] s00_axi_arburst;
    reg  s00_axi_arlock;
    reg [3 : 0] s00_axi_arcache;
    reg [2 : 0] s00_axi_arprot;
    reg [3 : 0] s00_axi_arqos;
    reg [3 : 0] s00_axi_arregion;
    reg [C_S00_AXI_ARUSER_WIDTH-1 : 0] s00_axi_aruser;
    reg  s00_axi_arvalid;
    wire  s00_axi_arready;
    wire [C_S00_AXI_ID_WIDTH-1 : 0] s00_axi_rid;
    wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_rdata;
    wire [1 : 0] s00_axi_rresp;
    wire  s00_axi_rlast;
    wire [C_S00_AXI_RUSER_WIDTH-1 : 0] s00_axi_ruser;
    wire  s00_axi_rvalid;
    reg  s00_axi_rready;
    
    AXI_Memory_v1_0 uut(
        .s00_axi_mem_address_violation(s00_axi_mem_address_violation),
        .s00_axi_aclk(s00_axi_aclk),
        .s00_axi_aresetn(s00_axi_aresetn),
        .s00_axi_awid(s00_axi_awid),
        .s00_axi_awaddr(s00_axi_awaddr),
        .s00_axi_awlen(s00_axi_awlen),
        .s00_axi_awsize(s00_axi_awsize),
        .s00_axi_awburst(s00_axi_awburst),
        .s00_axi_awlock(s00_axi_awlock),
        .s00_axi_awcache(s00_axi_awcache),
        .s00_axi_awprot(s00_axi_awprot),
        .s00_axi_awqos(s00_axi_awqos),
        .s00_axi_awregion(s00_axi_awregion),
        .s00_axi_awuser(s00_axi_awuser),
        .s00_axi_awvalid(s00_axi_awvalid),
        .s00_axi_awready(s00_axi_awready),
        .s00_axi_wdata(s00_axi_wdata),
        .s00_axi_wstrb(s00_axi_wstrb),
        .s00_axi_wlast(s00_axi_wlast),
        .s00_axi_wuser(s00_axi_wuser),
        .s00_axi_wvalid(s00_axi_wvalid),
        .s00_axi_wready(s00_axi_wready),
        .s00_axi_bid(s00_axi_bid),
        .s00_axi_bresp(s00_axi_bresp),
        .s00_axi_buser(s00_axi_buser),
        .s00_axi_bvalid(s00_axi_bvalid),
        .s00_axi_bready(s00_axi_bready),
        .s00_axi_arid(s00_axi_arid),
        .s00_axi_araddr(s00_axi_araddr),
        .s00_axi_arlen(s00_axi_arlen),
        .s00_axi_arsize(s00_axi_arsize),
        .s00_axi_arburst(s00_axi_arburst),
        .s00_axi_arlock(s00_axi_arlock),
        .s00_axi_arcache(s00_axi_arcache),
        .s00_axi_arprot(s00_axi_arprot),
        .s00_axi_arqos(s00_axi_arqos),
        .s00_axi_arregion(s00_axi_arregion),
        .s00_axi_aruser(s00_axi_aruser),
        .s00_axi_arvalid(s00_axi_arvalid),
        .s00_axi_arready(s00_axi_arready),
        .s00_axi_rid(s00_axi_rid),
        .s00_axi_rdata(s00_axi_rdata),
        .s00_axi_rresp(s00_axi_rresp),
        .s00_axi_rlast(s00_axi_rlast),
        .s00_axi_ruser(s00_axi_ruser),
        .s00_axi_rvalid(s00_axi_rvalid),
        .s00_axi_rready(s00_axi_rready)
    );
    
    initial
    begin
        s00_axi_aclk <= 0;                                
        s00_axi_aresetn <= 0;                             
        s00_axi_awid <= 0;      
        s00_axi_awaddr <= 0;  
        s00_axi_awlen <= 0;                        
        s00_axi_awsize <= 0;                       
        s00_axi_awburst <= 0;                      
        s00_axi_awlock <= 0;                              
        s00_axi_awcache <= 0;                      
        s00_axi_awprot <= 0;                       
        s00_axi_awqos <= 0;                        
        s00_axi_awregion <= 0;                     
        s00_axi_awuser <= 0;
        s00_axi_awvalid <= 0;                             
        s00_axi_wdata <= 0;    
        s00_axi_wstrb <= 0;
        s00_axi_wlast <= 0;                                
        s00_axi_wuser <= 0;   
        s00_axi_wvalid <= 0;                               
        s00_axi_bready <= 0;                              
        s00_axi_arid <= 0;      
        s00_axi_araddr <= 0;  
        s00_axi_arlen <= 0;                        
        s00_axi_arsize <= 0;                       
        s00_axi_arburst <= 0;                      
        s00_axi_arlock <= 0;                              
        s00_axi_arcache <= 0;                      
        s00_axi_arprot <= 0;                       
        s00_axi_arqos <= 0;                        
        s00_axi_arregion <= 0;                     
        s00_axi_aruser <= 0;
        s00_axi_arvalid <= 0;                             
        s00_axi_rready <=0;
        #10
        s00_axi_aresetn <= 1;
        #10
        `define ADDR1 32'h00000000
        `define DATA1 32'haaaabeef
        `define BURST1 16
        //Burst Read - tested
        $display("Burst Read");
        //$display("Writing %h to %h", `DATA1, `ADDR1);
        s00_axi_arvalid<=1;
        s00_axi_araddr<=`ADDR1;
        s00_axi_arsize <= 2'b10; //Burst size: 4
        s00_axi_arlen <= `BURST1; //Burst length: 4
        s00_axi_arburst <=2'b01; //Burst type: INCR
        s00_axi_rready<=1; //Must be kept asserted for the burst read
        for (i=0; i<=`BURST1; i=i+1) begin
            #10;
            s00_axi_arvalid<=0;
            s00_axi_arsize <= 0;
            s00_axi_arlen <= 0;
            s00_axi_arburst <= 0;
            $display("Read %h", s00_axi_rdata);
        end
        if (s00_axi_rvalid && s00_axi_rlast && ~s00_axi_rresp) //if read is the last an response is OKAY
        begin
            $display("Read OKAY");
            #10
            s00_axi_rready<=0;
        end
        
        //Write        
        $display("Simple Write");
        $display("Writing %h to %h", `DATA1, `ADDR1);
        s00_axi_awvalid<=1;
        s00_axi_awaddr<=`ADDR1;
        s00_axi_wvalid<=1;
        s00_axi_wdata<=`DATA1;        
        s00_axi_wlast<=1;
        s00_axi_wstrb<=4'b1111; //Which bytes to write
        #10
        s00_axi_awvalid<=0;
        #20 //wait 2 clock cycles for the BVALID
        if (s00_axi_bvalid && ~s00_axi_bresp) //if write response is OKAY
        begin
            $display("Write Response OKAY");
            s00_axi_bready<=1;
            s00_axi_wlast<=0;
            s00_axi_wvalid<=0;
            #10
            s00_axi_bready<=0;
        end        
        
        //Read
        $display("Simple Read");
        $display("Reading from %h", `ADDR1);
        s00_axi_arvalid<=1;
        s00_axi_araddr<=`ADDR1;        
        #20 //wait 2 clock cycles for the RVALID
        if (s00_axi_rvalid && ~s00_axi_rresp) //if read response is OKAY
        begin
            $display("Read %h", s00_axi_rdata);
            $display("Read OKAY");
            s00_axi_rready<=1;
            s00_axi_arvalid<=0;
            #10
            s00_axi_rready<=0;
        end
        
        //Burst Write
        $display("Burst Write");
        //$display("Writing %h to %h", `DATA1, `ADDR1);
        s00_axi_awvalid <= 1;
        s00_axi_awaddr <= `ADDR1;
        s00_axi_wdata <= `DATA1;
        s00_axi_awsize <= 2'b10; //Burst size: 4
        s00_axi_awlen <= `BURST1; //Burst length: 16
        s00_axi_awburst <= 2'b01; //Burst type: INCR
        s00_axi_wvalid <= 1;
        s00_axi_wlast <= 0;
        s00_axi_wstrb <= 4'b1111; //Which bytes to write
        for (i=0; i<=`BURST1; i=i+1) begin
            #10;            
        end
        s00_axi_awvalid<=0;
        #10
        s00_axi_wlast<=1;
        #10
        if (s00_axi_bvalid && ~s00_axi_bresp) //if write response is OKAY
        begin
            $display("Write Response OKAY");
            s00_axi_wlast <= 0;
            s00_axi_wvalid <= 0;
            s00_axi_bready<=1;
            #10
            s00_axi_bready<=0;
            s00_axi_awsize <= 0; 
            s00_axi_awlen <= 0;  
            s00_axi_awburst <= 0;
        end
        
        //Burst Read - tested
        $display("Burst Read");
        //$display("Writing %h to %h", `DATA1, `ADDR1);
        s00_axi_arvalid<=1;
        s00_axi_araddr<=`ADDR1;
        s00_axi_arsize <= 2'b10; //Burst size: 4
        s00_axi_arlen <= `BURST1; //Burst length: 4
        s00_axi_arburst <=2'b01; //Burst type: INCR
        s00_axi_rready<=1; //Must be kept asserted for the burst read
        for (i=0; i<=`BURST1; i=i+1) begin
            #10;
            s00_axi_arvalid<=0;
            s00_axi_arsize <= 0;
            s00_axi_arlen <= 0;
            s00_axi_arburst <= 0;
            $display("Read %h", s00_axi_rdata);
        end
        if (s00_axi_rvalid && s00_axi_rlast && ~s00_axi_rresp) //if read is the last an response is OKAY
        begin
            $display("Read OKAY");
            #10
            s00_axi_rready<=0;
        end
        
        //Write        
        `define ADDR2 32'h00000200
        `define DATA2 32'hdeadbeef
        $display("Simple Write");
        $display("Writing %h to %h", `DATA2, `ADDR2);
        s00_axi_awvalid<=1;
        s00_axi_awaddr<=`ADDR2;
        s00_axi_wvalid<=1;
        s00_axi_wdata<=`DATA2;        
        s00_axi_wlast<=1;
        s00_axi_wstrb<=4'b1111; //Which bytes to write
        #10
        s00_axi_awvalid<=0;
        #20 //wait 2 clock cycles for the BVALID
        if (s00_axi_bvalid && ~s00_axi_bresp) //if write response is OKAY
        begin
            $display("Write Response OKAY");
            s00_axi_bready<=1;
            s00_axi_wlast<=0;
            s00_axi_wvalid<=0;
            #10
            s00_axi_bready<=0;
        end
        
        //Read
        $display("Simple Read");
        $display("Reading from %h", `ADDR2);
        s00_axi_arvalid<=1;
        s00_axi_araddr<=`ADDR2;        
        #20 //wait 2 clock cycles for the RVALID
        if (s00_axi_rvalid && ~s00_axi_rresp) //if read response is OKAY
        begin
            $display("Read %h", s00_axi_rdata);
            $display("Read OKAY");
            s00_axi_rready<=1;
            s00_axi_arvalid<=0;
            #10
            s00_axi_rready<=0;
        end
        #10 
        $finish;
    end
    
    always #5 s00_axi_aclk=~s00_axi_aclk;
    
endmodule
