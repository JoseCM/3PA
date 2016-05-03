-- Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2015.4 (win64) Build 1412921 Wed Nov 18 09:43:45 MST 2015
-- Date        : Tue May 03 14:47:50 2016
-- Host        : DESKTOP-ONL2NNM running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode funcsim D:/3PA_Processor/IPs/rom/rom_sim_netlist.vhdl
-- Design      : rom
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7z010clg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity rom_dist_mem_gen_v8_0_9 is
  port (
    a : in STD_LOGIC_VECTOR ( 5 downto 0 );
    d : in STD_LOGIC_VECTOR ( 31 downto 0 );
    dpra : in STD_LOGIC_VECTOR ( 5 downto 0 );
    clk : in STD_LOGIC;
    we : in STD_LOGIC;
    i_ce : in STD_LOGIC;
    qspo_ce : in STD_LOGIC;
    qdpo_ce : in STD_LOGIC;
    qdpo_clk : in STD_LOGIC;
    qspo_rst : in STD_LOGIC;
    qdpo_rst : in STD_LOGIC;
    qspo_srst : in STD_LOGIC;
    qdpo_srst : in STD_LOGIC;
    spo : out STD_LOGIC_VECTOR ( 31 downto 0 );
    dpo : out STD_LOGIC_VECTOR ( 31 downto 0 );
    qspo : out STD_LOGIC_VECTOR ( 31 downto 0 );
    qdpo : out STD_LOGIC_VECTOR ( 31 downto 0 )
  );
  attribute C_ADDR_WIDTH : integer;
  attribute C_ADDR_WIDTH of rom_dist_mem_gen_v8_0_9 : entity is 6;
  attribute C_DEFAULT_DATA : string;
  attribute C_DEFAULT_DATA of rom_dist_mem_gen_v8_0_9 : entity is "0";
  attribute C_DEPTH : integer;
  attribute C_DEPTH of rom_dist_mem_gen_v8_0_9 : entity is 64;
  attribute C_ELABORATION_DIR : string;
  attribute C_ELABORATION_DIR of rom_dist_mem_gen_v8_0_9 : entity is "./";
  attribute C_FAMILY : string;
  attribute C_FAMILY of rom_dist_mem_gen_v8_0_9 : entity is "zynq";
  attribute C_HAS_CLK : integer;
  attribute C_HAS_CLK of rom_dist_mem_gen_v8_0_9 : entity is 0;
  attribute C_HAS_D : integer;
  attribute C_HAS_D of rom_dist_mem_gen_v8_0_9 : entity is 0;
  attribute C_HAS_DPO : integer;
  attribute C_HAS_DPO of rom_dist_mem_gen_v8_0_9 : entity is 0;
  attribute C_HAS_DPRA : integer;
  attribute C_HAS_DPRA of rom_dist_mem_gen_v8_0_9 : entity is 0;
  attribute C_HAS_I_CE : integer;
  attribute C_HAS_I_CE of rom_dist_mem_gen_v8_0_9 : entity is 0;
  attribute C_HAS_QDPO : integer;
  attribute C_HAS_QDPO of rom_dist_mem_gen_v8_0_9 : entity is 0;
  attribute C_HAS_QDPO_CE : integer;
  attribute C_HAS_QDPO_CE of rom_dist_mem_gen_v8_0_9 : entity is 0;
  attribute C_HAS_QDPO_CLK : integer;
  attribute C_HAS_QDPO_CLK of rom_dist_mem_gen_v8_0_9 : entity is 0;
  attribute C_HAS_QDPO_RST : integer;
  attribute C_HAS_QDPO_RST of rom_dist_mem_gen_v8_0_9 : entity is 0;
  attribute C_HAS_QDPO_SRST : integer;
  attribute C_HAS_QDPO_SRST of rom_dist_mem_gen_v8_0_9 : entity is 0;
  attribute C_HAS_QSPO : integer;
  attribute C_HAS_QSPO of rom_dist_mem_gen_v8_0_9 : entity is 0;
  attribute C_HAS_QSPO_CE : integer;
  attribute C_HAS_QSPO_CE of rom_dist_mem_gen_v8_0_9 : entity is 0;
  attribute C_HAS_QSPO_RST : integer;
  attribute C_HAS_QSPO_RST of rom_dist_mem_gen_v8_0_9 : entity is 0;
  attribute C_HAS_QSPO_SRST : integer;
  attribute C_HAS_QSPO_SRST of rom_dist_mem_gen_v8_0_9 : entity is 0;
  attribute C_HAS_SPO : integer;
  attribute C_HAS_SPO of rom_dist_mem_gen_v8_0_9 : entity is 1;
  attribute C_HAS_WE : integer;
  attribute C_HAS_WE of rom_dist_mem_gen_v8_0_9 : entity is 0;
  attribute C_MEM_INIT_FILE : string;
  attribute C_MEM_INIT_FILE of rom_dist_mem_gen_v8_0_9 : entity is "rom.mif";
  attribute C_MEM_TYPE : integer;
  attribute C_MEM_TYPE of rom_dist_mem_gen_v8_0_9 : entity is 0;
  attribute C_PARSER_TYPE : integer;
  attribute C_PARSER_TYPE of rom_dist_mem_gen_v8_0_9 : entity is 1;
  attribute C_PIPELINE_STAGES : integer;
  attribute C_PIPELINE_STAGES of rom_dist_mem_gen_v8_0_9 : entity is 0;
  attribute C_QCE_JOINED : integer;
  attribute C_QCE_JOINED of rom_dist_mem_gen_v8_0_9 : entity is 0;
  attribute C_QUALIFY_WE : integer;
  attribute C_QUALIFY_WE of rom_dist_mem_gen_v8_0_9 : entity is 0;
  attribute C_READ_MIF : integer;
  attribute C_READ_MIF of rom_dist_mem_gen_v8_0_9 : entity is 1;
  attribute C_REG_A_D_INPUTS : integer;
  attribute C_REG_A_D_INPUTS of rom_dist_mem_gen_v8_0_9 : entity is 0;
  attribute C_REG_DPRA_INPUT : integer;
  attribute C_REG_DPRA_INPUT of rom_dist_mem_gen_v8_0_9 : entity is 0;
  attribute C_SYNC_ENABLE : integer;
  attribute C_SYNC_ENABLE of rom_dist_mem_gen_v8_0_9 : entity is 1;
  attribute C_WIDTH : integer;
  attribute C_WIDTH of rom_dist_mem_gen_v8_0_9 : entity is 32;
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of rom_dist_mem_gen_v8_0_9 : entity is "dist_mem_gen_v8_0_9";
end rom_dist_mem_gen_v8_0_9;

architecture STRUCTURE of rom_dist_mem_gen_v8_0_9 is
  signal \<const0>\ : STD_LOGIC;
  signal \^spo\ : STD_LOGIC_VECTOR ( 31 downto 2 );
begin
  dpo(31) <= \<const0>\;
  dpo(30) <= \<const0>\;
  dpo(29) <= \<const0>\;
  dpo(28) <= \<const0>\;
  dpo(27) <= \<const0>\;
  dpo(26) <= \<const0>\;
  dpo(25) <= \<const0>\;
  dpo(24) <= \<const0>\;
  dpo(23) <= \<const0>\;
  dpo(22) <= \<const0>\;
  dpo(21) <= \<const0>\;
  dpo(20) <= \<const0>\;
  dpo(19) <= \<const0>\;
  dpo(18) <= \<const0>\;
  dpo(17) <= \<const0>\;
  dpo(16) <= \<const0>\;
  dpo(15) <= \<const0>\;
  dpo(14) <= \<const0>\;
  dpo(13) <= \<const0>\;
  dpo(12) <= \<const0>\;
  dpo(11) <= \<const0>\;
  dpo(10) <= \<const0>\;
  dpo(9) <= \<const0>\;
  dpo(8) <= \<const0>\;
  dpo(7) <= \<const0>\;
  dpo(6) <= \<const0>\;
  dpo(5) <= \<const0>\;
  dpo(4) <= \<const0>\;
  dpo(3) <= \<const0>\;
  dpo(2) <= \<const0>\;
  dpo(1) <= \<const0>\;
  dpo(0) <= \<const0>\;
  qdpo(31) <= \<const0>\;
  qdpo(30) <= \<const0>\;
  qdpo(29) <= \<const0>\;
  qdpo(28) <= \<const0>\;
  qdpo(27) <= \<const0>\;
  qdpo(26) <= \<const0>\;
  qdpo(25) <= \<const0>\;
  qdpo(24) <= \<const0>\;
  qdpo(23) <= \<const0>\;
  qdpo(22) <= \<const0>\;
  qdpo(21) <= \<const0>\;
  qdpo(20) <= \<const0>\;
  qdpo(19) <= \<const0>\;
  qdpo(18) <= \<const0>\;
  qdpo(17) <= \<const0>\;
  qdpo(16) <= \<const0>\;
  qdpo(15) <= \<const0>\;
  qdpo(14) <= \<const0>\;
  qdpo(13) <= \<const0>\;
  qdpo(12) <= \<const0>\;
  qdpo(11) <= \<const0>\;
  qdpo(10) <= \<const0>\;
  qdpo(9) <= \<const0>\;
  qdpo(8) <= \<const0>\;
  qdpo(7) <= \<const0>\;
  qdpo(6) <= \<const0>\;
  qdpo(5) <= \<const0>\;
  qdpo(4) <= \<const0>\;
  qdpo(3) <= \<const0>\;
  qdpo(2) <= \<const0>\;
  qdpo(1) <= \<const0>\;
  qdpo(0) <= \<const0>\;
  qspo(31) <= \<const0>\;
  qspo(30) <= \<const0>\;
  qspo(29) <= \<const0>\;
  qspo(28) <= \<const0>\;
  qspo(27) <= \<const0>\;
  qspo(26) <= \<const0>\;
  qspo(25) <= \<const0>\;
  qspo(24) <= \<const0>\;
  qspo(23) <= \<const0>\;
  qspo(22) <= \<const0>\;
  qspo(21) <= \<const0>\;
  qspo(20) <= \<const0>\;
  qspo(19) <= \<const0>\;
  qspo(18) <= \<const0>\;
  qspo(17) <= \<const0>\;
  qspo(16) <= \<const0>\;
  qspo(15) <= \<const0>\;
  qspo(14) <= \<const0>\;
  qspo(13) <= \<const0>\;
  qspo(12) <= \<const0>\;
  qspo(11) <= \<const0>\;
  qspo(10) <= \<const0>\;
  qspo(9) <= \<const0>\;
  qspo(8) <= \<const0>\;
  qspo(7) <= \<const0>\;
  qspo(6) <= \<const0>\;
  qspo(5) <= \<const0>\;
  qspo(4) <= \<const0>\;
  qspo(3) <= \<const0>\;
  qspo(2) <= \<const0>\;
  qspo(1) <= \<const0>\;
  qspo(0) <= \<const0>\;
  spo(31 downto 27) <= \^spo\(31 downto 27);
  spo(26) <= \<const0>\;
  spo(25) <= \<const0>\;
  spo(24) <= \<const0>\;
  spo(23) <= \^spo\(16);
  spo(22) <= \^spo\(22);
  spo(21) <= \<const0>\;
  spo(20) <= \<const0>\;
  spo(19) <= \<const0>\;
  spo(18) <= \<const0>\;
  spo(17) <= \^spo\(16);
  spo(16) <= \^spo\(16);
  spo(15) <= \<const0>\;
  spo(14) <= \<const0>\;
  spo(13) <= \<const0>\;
  spo(12) <= \<const0>\;
  spo(11) <= \<const0>\;
  spo(10) <= \<const0>\;
  spo(9) <= \<const0>\;
  spo(8) <= \<const0>\;
  spo(7) <= \<const0>\;
  spo(6) <= \<const0>\;
  spo(5) <= \<const0>\;
  spo(4 downto 2) <= \^spo\(4 downto 2);
  spo(1) <= \^spo\(3);
  spo(0) <= \^spo\(16);
GND: unisim.vcomponents.GND
     port map (
      G => \<const0>\
    );
\spo[0]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0001000000000000"
    )
        port map (
      I0 => a(2),
      I1 => a(3),
      I2 => a(4),
      I3 => a(5),
      I4 => a(1),
      I5 => a(0),
      O => \^spo\(16)
    );
\spo[1]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000001"
    )
        port map (
      I0 => a(2),
      I1 => a(3),
      I2 => a(4),
      I3 => a(5),
      I4 => a(1),
      I5 => a(0),
      O => \^spo\(3)
    );
\spo[22]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000010000"
    )
        port map (
      I0 => a(2),
      I1 => a(3),
      I2 => a(4),
      I3 => a(5),
      I4 => a(1),
      I5 => a(0),
      O => \^spo\(22)
    );
\spo[27]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000400000007"
    )
        port map (
      I0 => a(2),
      I1 => a(0),
      I2 => a(3),
      I3 => a(4),
      I4 => a(5),
      I5 => a(1),
      O => \^spo\(27)
    );
\spo[28]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000010101"
    )
        port map (
      I0 => a(3),
      I1 => a(4),
      I2 => a(5),
      I3 => a(2),
      I4 => a(1),
      I5 => a(0),
      O => \^spo\(28)
    );
\spo[29]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000100000002"
    )
        port map (
      I0 => a(0),
      I1 => a(1),
      I2 => a(5),
      I3 => a(4),
      I4 => a(3),
      I5 => a(2),
      O => \^spo\(29)
    );
\spo[2]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000000000000000E"
    )
        port map (
      I0 => a(0),
      I1 => a(1),
      I2 => a(5),
      I3 => a(4),
      I4 => a(3),
      I5 => a(2),
      O => \^spo\(2)
    );
\spo[30]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000017"
    )
        port map (
      I0 => a(0),
      I1 => a(1),
      I2 => a(2),
      I3 => a(5),
      I4 => a(4),
      I5 => a(3),
      O => \^spo\(30)
    );
\spo[31]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000002"
    )
        port map (
      I0 => a(2),
      I1 => a(3),
      I2 => a(4),
      I3 => a(5),
      I4 => a(1),
      I5 => a(0),
      O => \^spo\(31)
    );
\spo[4]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000006"
    )
        port map (
      I0 => a(0),
      I1 => a(1),
      I2 => a(5),
      I3 => a(4),
      I4 => a(3),
      I5 => a(2),
      O => \^spo\(4)
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity rom is
  port (
    a : in STD_LOGIC_VECTOR ( 5 downto 0 );
    spo : out STD_LOGIC_VECTOR ( 31 downto 0 )
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of rom : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of rom : entity is "rom,dist_mem_gen_v8_0_9,{}";
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of rom : entity is "xil_defaultlib_rom";
  attribute core_generation_info : string;
  attribute core_generation_info of rom : entity is "rom,dist_mem_gen_v8_0_9,{x_ipProduct=Vivado 2015.4,x_ipVendor=xilinx.com,x_ipLibrary=ip,x_ipName=dist_mem_gen,x_ipVersion=8.0,x_ipCoreRevision=9,x_ipLanguage=VERILOG,x_ipSimLanguage=MIXED,C_FAMILY=zynq,C_ADDR_WIDTH=6,C_DEFAULT_DATA=0,C_DEPTH=64,C_HAS_CLK=0,C_HAS_D=0,C_HAS_DPO=0,C_HAS_DPRA=0,C_HAS_I_CE=0,C_HAS_QDPO=0,C_HAS_QDPO_CE=0,C_HAS_QDPO_CLK=0,C_HAS_QDPO_RST=0,C_HAS_QDPO_SRST=0,C_HAS_QSPO=0,C_HAS_QSPO_CE=0,C_HAS_QSPO_RST=0,C_HAS_QSPO_SRST=0,C_HAS_SPO=1,C_HAS_WE=0,C_MEM_INIT_FILE=rom.mif,C_ELABORATION_DIR=./,C_MEM_TYPE=0,C_PIPELINE_STAGES=0,C_QCE_JOINED=0,C_QUALIFY_WE=0,C_READ_MIF=1,C_REG_A_D_INPUTS=0,C_REG_DPRA_INPUT=0,C_SYNC_ENABLE=1,C_WIDTH=32,C_PARSER_TYPE=1}";
  attribute downgradeipidentifiedwarnings : string;
  attribute downgradeipidentifiedwarnings of rom : entity is "yes";
  attribute x_core_info : string;
  attribute x_core_info of rom : entity is "dist_mem_gen_v8_0_9,Vivado 2015.4";
end rom;

architecture STRUCTURE of rom is
  signal NLW_U0_dpo_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_U0_qdpo_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_U0_qspo_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  attribute C_FAMILY : string;
  attribute C_FAMILY of U0 : label is "zynq";
  attribute C_HAS_D : integer;
  attribute C_HAS_D of U0 : label is 0;
  attribute C_HAS_DPO : integer;
  attribute C_HAS_DPO of U0 : label is 0;
  attribute C_HAS_DPRA : integer;
  attribute C_HAS_DPRA of U0 : label is 0;
  attribute C_HAS_I_CE : integer;
  attribute C_HAS_I_CE of U0 : label is 0;
  attribute C_HAS_QDPO : integer;
  attribute C_HAS_QDPO of U0 : label is 0;
  attribute C_HAS_QDPO_CE : integer;
  attribute C_HAS_QDPO_CE of U0 : label is 0;
  attribute C_HAS_QDPO_CLK : integer;
  attribute C_HAS_QDPO_CLK of U0 : label is 0;
  attribute C_HAS_QDPO_RST : integer;
  attribute C_HAS_QDPO_RST of U0 : label is 0;
  attribute C_HAS_QDPO_SRST : integer;
  attribute C_HAS_QDPO_SRST of U0 : label is 0;
  attribute C_HAS_WE : integer;
  attribute C_HAS_WE of U0 : label is 0;
  attribute C_MEM_TYPE : integer;
  attribute C_MEM_TYPE of U0 : label is 0;
  attribute C_PIPELINE_STAGES : integer;
  attribute C_PIPELINE_STAGES of U0 : label is 0;
  attribute C_QCE_JOINED : integer;
  attribute C_QCE_JOINED of U0 : label is 0;
  attribute C_QUALIFY_WE : integer;
  attribute C_QUALIFY_WE of U0 : label is 0;
  attribute C_REG_DPRA_INPUT : integer;
  attribute C_REG_DPRA_INPUT of U0 : label is 0;
  attribute c_addr_width : integer;
  attribute c_addr_width of U0 : label is 6;
  attribute c_default_data : string;
  attribute c_default_data of U0 : label is "0";
  attribute c_depth : integer;
  attribute c_depth of U0 : label is 64;
  attribute c_elaboration_dir : string;
  attribute c_elaboration_dir of U0 : label is "./";
  attribute c_has_clk : integer;
  attribute c_has_clk of U0 : label is 0;
  attribute c_has_qspo : integer;
  attribute c_has_qspo of U0 : label is 0;
  attribute c_has_qspo_ce : integer;
  attribute c_has_qspo_ce of U0 : label is 0;
  attribute c_has_qspo_rst : integer;
  attribute c_has_qspo_rst of U0 : label is 0;
  attribute c_has_qspo_srst : integer;
  attribute c_has_qspo_srst of U0 : label is 0;
  attribute c_has_spo : integer;
  attribute c_has_spo of U0 : label is 1;
  attribute c_mem_init_file : string;
  attribute c_mem_init_file of U0 : label is "rom.mif";
  attribute c_parser_type : integer;
  attribute c_parser_type of U0 : label is 1;
  attribute c_read_mif : integer;
  attribute c_read_mif of U0 : label is 1;
  attribute c_reg_a_d_inputs : integer;
  attribute c_reg_a_d_inputs of U0 : label is 0;
  attribute c_sync_enable : integer;
  attribute c_sync_enable of U0 : label is 1;
  attribute c_width : integer;
  attribute c_width of U0 : label is 32;
begin
U0: entity work.rom_dist_mem_gen_v8_0_9
     port map (
      a(5 downto 0) => a(5 downto 0),
      clk => '0',
      d(31 downto 0) => B"00000000000000000000000000000000",
      dpo(31 downto 0) => NLW_U0_dpo_UNCONNECTED(31 downto 0),
      dpra(5 downto 0) => B"000000",
      i_ce => '1',
      qdpo(31 downto 0) => NLW_U0_qdpo_UNCONNECTED(31 downto 0),
      qdpo_ce => '1',
      qdpo_clk => '0',
      qdpo_rst => '0',
      qdpo_srst => '0',
      qspo(31 downto 0) => NLW_U0_qspo_UNCONNECTED(31 downto 0),
      qspo_ce => '1',
      qspo_rst => '0',
      qspo_srst => '0',
      spo(31 downto 0) => spo(31 downto 0),
      we => '0'
    );
end STRUCTURE;
