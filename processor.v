`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 19.04.2016 09:46:33
// Design Name:
// Module Name: processor
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

`include "pipelinedefs.vh"

module processor(
       input Clk,
       input Rst,
       input [30:0] i_ext, // input vic peripheral
       
       /***************************/
       output [65:0] Dcache_bus_out,
       input [32:0] Dcache_bus_in,
       //changes
       output [65:0] Icache_bus_out,
       input [32:0] Icache_bus_in
       
    );
    
        //need this desclaration
    //gives an error if they are not here, gives warning when they are not here.
        wire [1:0] HU_MEM_RW;
        wire [1:0] MA_EX_MA;
        //wire [2:0] WB_RWE;
        
        wire [4:0] o_vwb_rdst;               // Register to save data in RegFile one clock late
        wire o_vwb_reg_write_rf;           // Control signal that allows the writing in the RegFile one clock late
        wire [31:0] o_vwb_mux;       // Output of the WB one clock late
    
       /* wire [4:0] w_Rs1_addr;
        wire [4:0] w_Rs2_addr;
        wire [4:0] Rdsaddr_EX_MA;
        wire [4:0] WB_RdsAddr;
        wire [1:0] EX_Op1_ExS;
        wire [1:0] EX_Op2_ExS;
        wire [1:0] BR_CBI;*/
        wire [1:0] EX_NPC;
        /*wire [3:0] condCodes;
        wire [3:0] condBits;*/
        
        wire [31:0] DataFromWB;
        wire [31:0] ALU_Rslt_MA_WB;              
        wire [1:0] EX_Op1_ExS;
        wire [1:0] EX_Op2_ExS;
       // wire [1:0] EX_NPC;
        /*wire [2:0] EX_WB;
        wire [1:0] EX_MA;        
        wire [14:0] EX_ExCtrl;*/
        wire [4:0] EX_Rs1;             //OP1
        wire [4:0] EX_Rs2;             //OP2
        /*wire [31:0] EX_Im;       //  
        wire [4:0] EX_Op1;
        wire [4:0] EX_Op2;
        wire [4:0] EX_Rds;
        wire [31:0] EX_PC; 
        wire [33:0] EX_PPCCB;
        wire [32:0] EX_IC;*/
        wire [1:0] BR_CBI;        
        wire [3:0] condBits;
        wire [3:0] condCodes;
        wire [4:0] w_Rs1_addr;
        wire [4:0] w_Rs2_addr;
        wire [4:0] w_Rds_addr;    //Rds not necessary in ID stage
        wire [2:0] WB_EX_MA;
       // wire [1:0] MA_EX_MA;
        wire [31:0] ALUrslt_EX_MA;
        wire [31:0] Rs2val_EX_MA;
        wire [4:0] Rs2addr_EX_MA; //Not necessary anymore
        wire [31:0] PC_EX_MA;
        wire [4:0] Rdsaddr_EX_MA;

    wire [1:0] ID_CB_o;
    wire [31:0] JMPIC;
    wire [31:0] JMPAddr;
    wire [31:0] ID_IR;
    wire [31:0] ID_PC;
    wire [31:0] ID_IAddr;
    wire [33:0] ID_PPCCB;
    wire [31:0] w_CHJumpAddr;
    
    /**********VIC*************/
    wire i_VIC_ctrl;            //signal that goes to the mux in fetch stage and to branch unit(to flush)
    wire [31:0] i_VIC_iaddr;    //input address for the mux in fetch stage        
    wire i_VIC_CCodes_ctrl;     //control signal to execute stage (for ccodes store logic)
    wire [3:0] i_VIC_CCodes;    //CCodes stored before interrupt
    wire RETI_Inst;             //RETI signal
    wire NOT_FLUSH;             
    wire VIC_NOT_FLUSH;
    wire [31:0] PC_EX_VIC;
    /*********VIC2**************/
    wire [4:0] o_vic_index;
    wire [3:0] o_vic_data;
    wire o_vic_WRe;
    wire [3:0] i_vic_data;

    IF fetch(
        //General
         .Clk(Clk),
         .Rst(Rst),
        //Branch Unit
         .FlushPipeandPC(ID_FlushPipeandPC),
         .WriteEnable(ID_WriteEnable),
         .CB_o(ID_CB_o),  
        //Stall Unit
         .PCStall(PCStall),
         .IF_ID_Stall(IF_ID_Stall),
         .IF_ID_Flush(IF_ID_Flush),
         .Imiss(Imiss),
        //From Execute
         .CHJmpAddr(w_CHJumpAddr),
         .JmpAddr(JMPAddr),
         .JmpInstrAddr(JMPIC),
        //To Pipeline Registers
         .IR(ID_IR),
         .PC(ID_PC),
         .InstrAddr(ID_IAddr),
         .PCSource(ID_PCSrc),
         .PPCCB(ID_PPCCB),
                
         .Icache_bus_out(Icache_bus_out),
         .Icache_bus_in(Icache_bus_in),
         
         /**********VIC*************/
         .i_VIC_ctrl(i_VIC_ctrl),
         .i_VIC_iaddr(i_VIC_iaddr),        
         .o_IFID_NOT_FLUSH(NOT_FLUSH)
    );

    //wire WB_RWE;
    
    wire [4:0] WB_RdsAddr;
    //wire [31:0] WB_RdsData;
    wire [31:0] EX_IC;
    wire [33:0] EX_PPCCB;
    wire [31:0] EX_PC;
    wire [4:0] EX_Rds;
    /*wire [4:0] EX_Rs1;
    wire [4:0] EX_Rs2;*/
    wire [31:0] EX_Op1;
    wire [31:0] EX_Op2;
    wire [31:0] EX_Im;
    wire [`EX_WIDTH-1:0] EX_ExCtrl;
    wire [1:0] EX_MA;
    wire [2:0] EX_WB;   
    
    IDControlUnit decode(
         .Clk(Clk),
         .reset(Rst),
        
         /*Input pipeline registers from writeback*/
         .rf_we(WB_RWE),
         .WAddr(WB_RdsAddr),
         .WData(DataFromWB),
         /*Input pipeline registers from fetch*/
         .iIC(ID_IAddr),
         .iPPCCB(ID_PPCCB),
         .iPC(ID_PC), 
         .iValid(ID_PCSrc),
         .iIR(ID_IR),
 
         /*Input to stall or flush*/
         .stall(IDEX_Stall),
         .flush(IDEX_Flush),
         /*forward unit signals from wb*/
         .fwdRS2(DataFromWB),
         .fwdRS2_Sel(fwdRS2_Sel),
         /*forward unit signals from decode*/
         .IFid__Need_Rs2(IFid__Need_Rs2),
         .IFid__Rs2(IFid__Rs2),
         /*Output pipeline registers to execute*/
         /*Fowarded from fetch*/

         .oIC(EX_IC),
         .oPPCCB(EX_PPCCB),
         .oPC(EX_PC),
         .oValid(EX_Valid), 
            /*Produced outputs to execute*/
         .oRDS(EX_Rds),
         .oRS1(EX_Rs1),
         .oRS2(EX_Rs2),
         .oOP1(EX_Op1),
         .oOP2(EX_Op2),
         .oIM(EX_Im),

         .oEX(EX_ExCtrl),
         .oMA(EX_MA),
         .oWB(EX_WB),
         
         /************VIC****************/
         .o_RETI(RETI_Inst), //RETI Signal        
         .i_NOT_FLUSH(NOT_FLUSH),
         .o_NOT_FLUSH(VIC_NOT_FLUSH)//later for vic
    );


        
         EX_Stage execute(
        /*Input clock and reset*/
        .clk(Clk),
        .reset(Rst),
        
        /*Fowarding data from WB and MEM Stage*/
        .i_Data_From_WB(DataFromWB),
        .i_Data_From_MEM(ALUrslt_EX_MA),
        .i_Data_From_vWB(o_vwb_mux),
        
        /*Foward Unit Control Signals*/
        .i_Fwrd_Ctrl1(EX_Op1_ExS),
        .i_Fwrd_Ctrl2(EX_Op2_ExS),
        
        /*Stall Unit Control Signal*/
        .i_EXMA_flush(EX_EXMA_Flush),
        .i_EXMA_stall(EX_EXMA_Stall),
        
        /*Branch Unit Control Signal*/
        .i_NPC_Ctrl(EX_NPC[0]),
        
        /*Input data from IDEX register*/
        .i_WB_Ctrl(EX_WB),
        .i_MEM_Ctrl(EX_MA),
        
        .i_EX_Ctrl(EX_ExCtrl),
        .i_PC_Match(EX_Valid),//What? two valid bits?
        .i_Valid_Bit(EX_Valid),
        .i_Rs1(EX_Op1),             //OP1
        .i_Rs2(EX_Op2),             //OP2
        .i_Immediate(EX_Im),        //  
        .i_Rs1_addr(EX_Rs1),
        .i_Rs2_addr(EX_Rs2),
        .i_Rds_addr(EX_Rds),
        .i_PC(EX_PC), 
        .i_PPCCB(EX_PPCCB),
        .i_IC(EX_IC),
       
        /****************VIC*****************/
        .i_VIC_CCodes_ctrl(i_VIC_CCodes_ctrl),
        .i_VIC_CCodes(i_VIC_CCodes),
        .o_PC_VIC(PC_EX_VIC),
        
        /*External Outputs data and signals(No Connection to the Pipeline Register)*/
        .o_CB(BR_CBI),
        .o_Valid_Bit(BR_Valid),
        .o_Jmp_Ctrl(BR_JmpCtrl),
        .o_Branch_Ctrl(BR_BranchCtrl),
        .o_CondBits(condBits),
        .o_CCodes(condCodes),
        .o_PPC_Eq(PPC_Eq),
        .o_IC(JMPIC),
        .o_New_PC(JMPAddr),
        .o_Rs1_addr(w_Rs1_addr),
        .o_Rs2_addr(w_Rs2_addr),
        .o_Rds_addr(w_Rds_addr),    //Rds not necessary in ID stage
        .o_need_Rs1(w_need_Rs1),
        .o_need_Rs2(w_need_Rs2),
        
        /*EXMA register output data*/
        .o_CH_Jump_Addr(w_CHJumpAddr),
        .o_EXMA_WB(WB_EX_MA),
        .o_EXMA_MEM(MA_EX_MA),
        .o_EXMA_ALU_rslt(ALUrslt_EX_MA),
        .o_EXMA_Rs2_val(Rs2val_EX_MA),
        .o_EXMA_Rs2_addr(Rs2addr_EX_MA), //Not necessary anymore
        .o_EXMA_PC(PC_EX_MA),
        .o_EXMA_Rds_addr(Rdsaddr_EX_MA),
        
        
        /*******FROM BRANCH**********/
        .BranchInstr(BR_BranchCtrl),
        .JumpInstr(BR_JmpCtrl)
          
        );

        /*wire [2:0] WB_EX_MA;
        wire [1:0] MA_EX_MA;
        wire [31:0] ALUrslt_EX_MA;
        wire [31:0] Rs2val_EX_MA;
        wire [4:0] Rs2addr_EX_MA;
        wire [31:0] PC_EX_MA;
        wire [4:0] Rdsaddr_EX_MA;
        wire [31:0] DataFromWB;*/
        wire [31:0] PCSrc_MA_WB;
        wire [4:0] RDS_MA_WB;
        //wire [31:0] ALU_Rslt_MA_WB;
        wire [2:0] o_ma_WB;
        wire [31:0] Data_Mem_MA_WB;              
        
    stageMA MAccesss(
        .clk(Clk),//clock
        .rst(Rst),//reset
        .i_ma_WB(WB_EX_MA),//write_back control signal
        .i_ma_MA(MA_EX_MA),//memory access control signals
        .i_ma_ALU_rslt(ALUrslt_EX_MA),// resultado da ALU
        .i_ma_Rs2_val(Rs2val_EX_MA), //valor do regiter source 2
        .i_ma_Rs2_addr(Rs2addr_EX_MA), //endere?o do registo do register source 2
        .i_ma_PC(PC_EX_MA), //program counter
        .i_ma_Rdst(Rdsaddr_EX_MA), //registo de destino
        .i_ma_mux_wb(DataFromWB),//resultado do write back (forwarding)
        .i_OP1_MemS(0), //forwrding unit signal, not necessary anymore
        .i_ma_flush(MAWB_Flush),
        .i_ma_stall(0), // Este Stall fica sempre descligado

        .o_ma_PC(PCSrc_MA_WB), //program counter para ser colocado no pipeline register MA/WB
        .o_ma_Rdst(RDS_MA_WB), //endere�o do registo de sa�da
        .o_ma_ALU_rslt(ALU_Rslt_MA_WB), //resultado do ALU a ser colocado no pipeline register MA/WB
        .o_ma_WB(o_ma_WB), //sinais de controlo da write back a serem colocados no pipeline register MA/WB
        .o_ma_EX_MEM_Rs2(),//colocar o endere�o do source register 2 na forward unit,
        .o_ma_EX_MEM_MA(HU_MEM_RW),
        .o_miss(Dmiss), // falha no acesso de mem�ria
        .o_ma_mem_out(Data_Mem_MA_WB),
        
        .Dcache_bus_out(Dcache_bus_out),
        .Dcache_bus_in(Dcache_bus_in),
        
         /*****************VIC2******************/ 
       .o_vic_index(o_vic_index),
       .o_vic_data(o_vic_data),
       .o_vic_WRe(o_vic_WRe),
       .i_vic_data(i_vic_data)    
    );
    
        /*wire [31:0] PCSrc_MA_WB;
        wire [31:0] Data_Mem_MA_WB;
        wire [31:0] ALU_Rslt_MA_WB;
        wire [2:0] o_ma_WB;
        wire [4:0] RDS_MA_WB;
        wire [31:0] WB_RdsAddr;*/
        //wire [2:0] WB_RWE;
        //wire [31:0] DataFromWB;
        
    stage_wb WBack (

        .clk(Clk),
        .rst(Rst),
        .i_wb_pc(PCSrc_MA_WB),
        .i_wb_data_o_ma(Data_Mem_MA_WB), // Output from memory
        .i_wb_alu_rslt(ALU_Rslt_MA_WB), // result of the ALU
        .i_wb_cntrl(o_ma_WB),// bits [1:0] slect mux, bit 2 reg_write_rf_in
        .i_wb_rdst(RDS_MA_WB),// input of Rdst
        .o_wb_rdst(WB_RdsAddr),// output of Rdst to forward
        .o_wb_reg_write_rf(WB_RWE),//output of the third input control bit
        .o_wb_mux(DataFromWB),// Data for the input of the register file
        .o_wb_reg_dst_s(),// select mux out <-------------------------------------- <------------------------------------
        .o_vwb_rdst(o_vwb_rdst),               // Register to save data in RegFile one clock late
        .o_vwb_reg_write_rf(o_vwb_reg_write_rf),            // Control signal that allows the writing in the RegFile one clock late
        .o_vwb_mux(o_vwb_mux)        // Output of the WB one clock late
    );


        
    HazardUnit HazardU(
         .clk(Clk),
         .rst(rst),
         //FORWARD UNIT
         
         .IDex__Need_Rs2(w_need_Rs2),
         .IDex__Need_Rs1(w_need_Rs1),
         .IFid__Need_Rs2(IFid__Need_Rs2),
         
         .IDex__Rs1(w_Rs1_addr),
         .IDex__Rs2(w_Rs2_addr),
         .IFid__Rs2(IFid__Rs2),
         .EXmem__RW_MEM(HU_MEM_RW[`MA_RW]),
         .EXmem__MemEnable(HU_MEM_RW[`MA_EN]),
         .EXmem__R_WE(WB_EX_MA[`WB_R_WE]),
         .EXmem__Rdst(Rdsaddr_EX_MA),
         .EXmem__RDst_S(WB_EX_MA[`WB_RDST_MUX]),
         .MEMwb__Rdst(WB_RdsAddr),
         .MEMwb__R_WE(WB_RWE),
         .VWB__Rdst(o_vwb_rdst),
         .VWB__R_WE(o_vwb_reg_write_rf), 
         .OP1_ExS(EX_Op1_ExS),
         .OP2_ExS(EX_Op2_ExS),
         .OP2_IdS(fwdRS2_Sel),

         //BRANCH UNIT
         .PcMatchValid(BR_Valid),
         .BranchInstr(BR_BranchCtrl),
         .JumpInstr(BR_JmpCtrl),
         .PredicEqRes(PPC_Eq),
         .CtrlIn(BR_CBI),
         .i_VIC_ctrl(i_VIC_ctrl),
         .CtrlOut(ID_CB_o),
         .FlushPipePC(ID_FlushPipeandPC),
         .WriteEnable(ID_WriteEnable),
         .NPC(EX_NPC),
         

          //CHECK CC
         .cc4(condCodes),            // The condition code bits
         .cond_bits(condBits),

          //STALL UNIT
         .i_DCache_Miss(Dmiss), // From Data Cache in MEM stage
         .i_ICache_Miss(Imiss), // From Instruction Cache in IF stage
         .o_PC_Stall(PCStall),   // To IF stage
         .o_IFID_Stall(IF_ID_Stall), // To IFID pipeline register
         .o_IDEX_Stall(IDEX_Stall), // To IDEX pipeline register
         .o_EXMA_Stall(EX_EXMA_Stall), // To EXMA pipeline register
         .o_EXMA_Flush(EX_EXMA_Flush), // To flush EXMA pipleine Register
         .o_MAWB_Flush(MAWB_Flush), // To flush MAWB pipeline register

          //Pipeline Registers
         .Flush_IF_ID(IF_ID_Flush),
         .Flush_ID_EX(IDEX_Flush)
        );

    Vic vic(           
            .clk(Clk),
            .rst(Rst),         
                          
            /*Execute Signals*/
            .i_PC(PC_EX_VIC),
            .i_CCodes(condCodes), //saving cc from execute stage            
            .i_reti(RETI_Inst),   //Reti value from Decode          
            .i_NOT_FLUSH(VIC_NOT_FLUSH),      
                      
             /*Memory Stage*/
            .i_VIC_data(o_vic_data), 
            .i_VIC_regaddr(o_vic_index),
            .i_VIC_we(o_vic_WRe),  
                
             /*Peripherals*/
            .i_ext(i_ext), // input peripheral    
               
            /*Execute Signals*/
            .o_CCodes(i_VIC_CCodes),
            .o_VIC_CCodes_ctrl(i_VIC_CCodes_ctrl),     
                  
            /*Memory Stage*/
            .o_VIC_data(i_vic_data),           
            
            /*Fetch Stage*/
            .o_VIC_iaddr(i_VIC_iaddr),
            .o_VIC_ctrl(i_VIC_ctrl)           
            );
            
endmodule
