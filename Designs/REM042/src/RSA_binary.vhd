-------------------------------------------------------------------------------
-- This file is part of the project  avs_aes
-- see: http://opencores.org/project,avs_aes
--
-- description:
-- Statemachine controlling the encryption datapath within aes_core.vhd does no
-- dataprocessing itself but only set enables and multiplexer selector ports
--
-- Author(s):
--	   Thomas Ruschival -- ruschi@opencores.org (www.ruschival.de)
--
--------------------------------------------------------------------------------
-- Copyright (c) 2009, Thomas Ruschival
-- All rights reserved.
--
-- Redistribution and use in source and binary forms, with or without modification,
-- are permitted provided that the following conditions are met:
--    * Redistributions of source code must retain the above copyright notice,
--    this list of conditions and the following disclaimer.
--    * Redistributions in binary form must reproduce the above copyright notice,
--    this list of conditions and the following disclaimer in the documentation
--    and/or other materials provided with the distribution.
--    * Neither the name of the  nor the names of its contributors
--    may be used to endorse or promote products derived from this software without
--    specific prior written permission.
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
-- AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
-- IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
-- ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
-- LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY,
-- OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
-- SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
-- INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
-- CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
-- ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
-- THE POSSIBILITY OF SUCH DAMAGE
-------------------------------------------------------------------------------
-- version management:
-- $Author::                                         $
-- $Date::                                           $
-- $Revision::                                       $
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity RSA_binary is
	port (
		clk				: in  STD_LOGIC;  -- System clock
		start		: in  STD_LOGIC;  -- flag valid data/activate the process 
		-- interface for keygenerator
		--key_ready		: in  STD_LOGIC;  -- flag valid roundkeys
		--round_index_out : out NIBBLE;	-- address for roundkeys memory
		-- Result of Process
		finished		: out STD_LOGIC 
		);
end entity RSA_binary;

--
architecture Arch1 of RSA_binary is

	-- FSM signals
	signal FSM		: std_logic_vector(2 downto 0);		-- current state
	signal next_FSM : std_logic_vector(2 downto 0);		-- combinational next state

        CONSTANT RESULT : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
        CONSTANT IDLE : STD_LOGIC_VECTOR(2 DOWNTO 0) := "001";
	CONSTANT INIT : STD_LOGIC_VECTOR(2 DOWNTO 0) := "010";
	CONSTANT LOAD1 : STD_LOGIC_VECTOR(2 DOWNTO 0) := "011";
	CONSTANT LOAD2 : STD_LOGIC_VECTOR(2 DOWNTO 0) := "100";
	CONSTANT MULT : STD_LOGIC_VECTOR(2 DOWNTO 0) := "101";
	CONSTANT SQR : STD_LOGIC_VECTOR(2 DOWNTO 0) := "110";

	-- Round Counter & address for keygenerate
	signal round_index		: STD_LOGIC_VECTOR(3 downto 0);	-- currently processed round
	signal next_round_index : STD_LOGIC_VECTOR(3 downto 0);	-- next round, index for keygenerate
	
begin
	---------------------------------------------------------------------------
	-- assign internal values to interface ports
	---------------------------------------------------------------------------
	--round_index_out <= next_round_index;  -- roundkey address

	-- purpose: combinational generation of next state for encrytion FSM
	-- type	  : sequential
	-- inputs : FSM, data_stable, key_ready, round_index
	-- outputs: next_FSM



gen_next_fsm : process (FSM, start, round_index) is
	begin  
		case FSM is
			when IDLE =>
				if start = '1' then
					next_FSM <= INIT;
				else
					next_FSM <= IDLE;
				end if;
			when INIT =>
				next_FSM <= LOAD1;
			when LOAD1 =>
				next_FSM <= LOAD2;
			when LOAD2 =>
				next_FSM <= MULT;
			when MULT =>
				next_FSM <= SQR;
			when SQR =>
				if round_index = "10" then
					next_FSM <= RESULT;
				else
					next_FSM <= MULT;
				end if;
			when RESULT =>
				next_FSM <= IDLE;
			when others =>
				next_FSM <= IDLE;
		end case;
	end process gen_next_fsm;

	-- purpose: assign outputs for encryption
	-- type	  : combinational
	-- inputs : FSM
	com_output_assign : process (FSM, round_index) is
	begin  -- process com_output_assign
		-- save defaults for encrypt_FSM
		--round_type_sel	 <= "00";		-- signal initial_round
		next_round_index <= round_index;
		finished		 <= '0';

		case FSM is
			when IDLE =>
				next_round_index <= X"0";
			when INIT =>
				next_round_index <= X"0";
			when LOAD1 =>
				next_round_index <= X"0";
			when LOAD2 =>
				next_round_index <= X"0";
--			when WAIT_DATA =>
--				next_round_index <= X"0";
--			when INITIAL_ROUND =>
--				round_type_sel	 <= "00";  -- data_in as input to AddKey
--				-- data is stable, FSM will switch to DO_ROUND in next cycle
--				next_round_index <= X"1";  -- start DO_ROUND with 1st expanded key
			when SQR =>
				next_round_index <= round_index+1;
			when RESULT =>
				next_round_index <= X"0";
				finished		 <= '1';
			when others =>
				null;
		end case;
	end process com_output_assign;

	-- purpose: clocked FSM for encryption
	-- type	  : sequential
	-- inputs : clk, res_n
	clocked_FSM : process (clk) is
	begin  -- process clocked_FSM
		if rising_edge(clk) then		-- rising clock edge
			FSM			<= next_FSM;
			round_index <= next_round_index;
		end if;
	end process clocked_FSM;

end architecture Arch1;

