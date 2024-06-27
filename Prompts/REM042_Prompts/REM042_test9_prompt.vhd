-- Test 9 - REM042 - HIGH verbosity - Missing Lines = 10

Generate a complete synthesizable code for the missed parts of the following RSA VHDL code. 
A comment "Missed Part" shows missing parts.  Write the proper and correct code to mitigate the vulnerability and description mentioned.
 Give the whole completed code. 


Vulnerability: Incomplete implementation of standard security compliances.
Description: In an RSA crypto core FSM, proper state transactions should occur according to the
defined standardized algorithms for the security of the crypto core. The standardized
implementation of RSA encryption requires that the ‘SQR’ state follow the ‘MULT’ state before
finally reaching the ‘RESULT’ state. Improper implementation or bypassing these state
transactions to reach the ‘RESULT’ state by an attacker can lead to leakage of intermediate
result/ key or corrupt the output. Therefore, the performance and reliability of the whole
system can be corrupted.




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
	-- "Missed Part"
	-- "Missed Part"

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
			-- "Missed Part"
                                -- "Missed Part"
			-- "Missed Part"
				-- "Missed Part"
                                -- "Missed Part"
				-- "Missed Part"
                                -- "Missed Part"
				-- "Missed Part"
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

