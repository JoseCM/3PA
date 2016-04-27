-- Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2015.4 (win64) Build 1412921 Wed Nov 18 09:43:45 MST 2015
-- Date        : Tue Apr 19 11:05:17 2016
-- Host        : Regd running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               c:/Users/rafael/Documents/VivadoProjects/soc_3pa/soc_3pa.srcs/sources_1/ip/RAM_DM/RAM_DM_stub.vhdl
-- Design      : RAM_DM
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z010clg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RAM_DM is
  Port ( 
    a : in STD_LOGIC_VECTOR ( 15 downto 0 );
    d : in STD_LOGIC_VECTOR ( 31 downto 0 );
    clk : in STD_LOGIC;
    we : in STD_LOGIC;
    spo : out STD_LOGIC_VECTOR ( 31 downto 0 )
  );

end RAM_DM;

architecture stub of RAM_DM is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "a[15:0],d[31:0],clk,we,spo[31:0]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "dist_mem_gen_v8_0_9,Vivado 2015.4";
begin
end;
