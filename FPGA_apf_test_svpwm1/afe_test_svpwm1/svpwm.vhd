-- Copyright (C) 1991-2011 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- PROGRAM		"Quartus II"
-- VERSION		"Version 11.0 Build 157 04/27/2011 SJ Full Version"
-- CREATED		"Fri Jun 24 10:45:41 2011"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY svpwm IS 
	PORT
	(
		clkin :  IN  STD_LOGIC;
		u1 :  OUT  STD_LOGIC;
		v1 :  OUT  STD_LOGIC;
		w1 :  OUT  STD_LOGIC
	);
END svpwm;

ARCHITECTURE bdf_type OF svpwm IS 

COMPONENT genh
	PORT(clk : IN STD_LOGIC;
		 datain : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 dataout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT judge_section
	PORT(clk : IN STD_LOGIC;
		 genh3ua : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 ub : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 section : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END COMPONENT;

COMPONENT pwm
	PORT(clk : IN STD_LOGIC;
		 clk_cnt : IN STD_LOGIC;
		 tcm1i : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 tcm2i : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 tcm3i : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 u1 : OUT STD_LOGIC;
		 v1 : OUT STD_LOGIC;
		 w1 : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT sinb
	PORT(CLK : IN STD_LOGIC;
		 dout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT divide1
	PORT(denom : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 numer : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 quotient : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 remain : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT jisuan_t
GENERIC (t : STD_LOGIC_VECTOR(15 DOWNTO 0);
			udc : INTEGER
			);
	PORT(clk : IN STD_LOGIC;
		 n : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 ua : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 ub : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 t1 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 t2 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 t_he : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT mult1
	PORT(dataa : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT jisuan_abc
GENERIC (t : STD_LOGIC_VECTOR(15 DOWNTO 0)
			);
	PORT(clk : IN STD_LOGIC;
		 fi1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 fi3 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 n : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 t1x : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 t2x : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 tcm1 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 tcm2 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 tcm3 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT sina
	PORT(CLK : IN STD_LOGIC;
		 dout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT altpll0
	PORT(inclk0 : IN STD_LOGIC;
		 c0 : OUT STD_LOGIC;
		 c1 : OUT STD_LOGIC;
		 c2 : OUT STD_LOGIC
	);
END COMPONENT;

SIGNAL	clk :  STD_LOGIC;
SIGNAL	clk1 :  STD_LOGIC;
SIGNAL	clk2 :  STD_LOGIC;
SIGNAL	f1 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	f2 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	n :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	t1 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	t2 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	ua :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	ub :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_0 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_1 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_2 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_3 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_8 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_5 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_7 :  STD_LOGIC_VECTOR(31 DOWNTO 0);


BEGIN 



b2v_inst : genh
PORT MAP(clk => clk,
		 datain => ua,
		 dataout => SYNTHESIZED_WIRE_0);


b2v_inst1 : judge_section
PORT MAP(clk => clk,
		 genh3ua => SYNTHESIZED_WIRE_0,
		 ub => ub,
		 section => n);


b2v_inst10 : pwm
PORT MAP(clk => clk,
		 clk_cnt => clk1,
		 tcm1i => SYNTHESIZED_WIRE_1,
		 tcm2i => SYNTHESIZED_WIRE_2,
		 tcm3i => SYNTHESIZED_WIRE_3,
		 u1 => u1,
		 v1 => v1,
		 w1 => w1);


b2v_inst11 : sinb
PORT MAP(CLK => clk2,
		 dout => ub);


b2v_inst2 : divide1
PORT MAP(denom => SYNTHESIZED_WIRE_8,
		 numer => SYNTHESIZED_WIRE_5,
		 quotient => f1);


b2v_inst3 : jisuan_t
GENERIC MAP(t => "0000001111101000",
			udc => 540
			)
PORT MAP(clk => clk,
		 n => n,
		 ua => ua,
		 ub => ub,
		 t1 => t1,
		 t2 => t2,
		 t_he => SYNTHESIZED_WIRE_8);


b2v_inst4 : mult1
PORT MAP(dataa => t1,
		 result => SYNTHESIZED_WIRE_5);


b2v_inst5 : mult1
PORT MAP(dataa => t2,
		 result => SYNTHESIZED_WIRE_7);


b2v_inst6 : divide1
PORT MAP(denom => SYNTHESIZED_WIRE_8,
		 numer => SYNTHESIZED_WIRE_7,
		 quotient => f2);


b2v_inst7 : jisuan_abc
GENERIC MAP(t => "0000001111101000"
			)
PORT MAP(clk => clk,
		 fi1 => f1,
		 fi3 => f2,
		 n => n,
		 t1x => t1,
		 t2x => t2,
		 tcm1 => SYNTHESIZED_WIRE_1,
		 tcm2 => SYNTHESIZED_WIRE_2,
		 tcm3 => SYNTHESIZED_WIRE_3);


b2v_inst8 : sina
PORT MAP(CLK => clk2,
		 dout => ua);


b2v_inst9 : altpll0
PORT MAP(inclk0 => clkin,
		 c0 => clk,
		 c1 => clk1,
		 c2 => clk2);


END bdf_type;