library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sha256_control is
    port (  
        -- inputs
        clk_i : in std_logic;                                    -- system clock
        ce_i : in std_logic;                                     -- core clock enable
        start_i : in std_logic;                                  -- reset the processor and start a new hash
        end_i : in std_logic;                                    -- marks end of last block data input
        ack_i : in std_logic;                                    -- input word hold control
        bytes_i : in std_logic_vector (1 downto 0);  -- valid bytes in input word
        error_i : in std_logic ;  
        bytes_error_reg : in std_logic;		  -- datapath error input from other modules
        st_cnt_reg : in unsigned(6 downto 0);
        sha_last_blk_reg : in std_logic;
        padding_reg : in std_logic;
        one_insert : in std_logic;
		  --sha_last_blk_next : in std_logic;
		  wait_run_ce : in std_logic;
        -- output control signals
      bitlen_o : out std_logic_vector (63 downto 0);                  -- message bit length
       words_sel_o : out std_logic_vector (1 downto 0);                -- bitlen insertion control
       Kt_addr_o : out std_logic_vector (5 downto 0);                  -- address for the Kt coefficients ROM
       sch_ld_o : out std_logic;                                       -- load/recirculate words for message scheduler
       core_ld_o : out std_logic;                                      -- load all registers for hash core
        oregs_ld_o : out std_logic;                                     -- load output registers
        sch_ce_o : out std_logic;                                       -- clock enable for message scheduler logic block
        core_ce_o : out std_logic;                                      -- clock enable for hash core logic block
        oregs_ce_o : out std_logic;                                     -- clock enable for output regs logic block
        bytes_ena_o : out std_logic_vector (3 downto 0);                -- byte lane selectors for padding logic block
        one_insert_o : out std_logic;                                   -- insert leading '1' in the padding
        di_req_o : out std_logic;                                       -- external data request by the 'di_i' port
        data_valid_o : out std_logic;                                   -- operation finished. output data is valid
        error_o : out std_logic                                         -- operation aborted. output data is not valid
    );                      
end sha256_control;

architecture rtl of sha256_control is
    --=============================================================================================
    -- Type definitions
    --=============================================================================================
    -- controller states
	signal hash_control_st_reg  : STD_LOGIC_VECTOR(2 DOWNTO 0);
	signal hash_control_st_next : STD_LOGIC_VECTOR(2 DOWNTO 0);
	 
		 --state encodings
	CONSTANT st_reset : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
	CONSTANT st_sha_data_input : STD_LOGIC_VECTOR(2 DOWNTO 0) := "001";
	CONSTANT st_sha_blk_process : STD_LOGIC_VECTOR(2 DOWNTO 0) := "010";
	CONSTANT st_sha_blk_nxt : STD_LOGIC_VECTOR(2 DOWNTO 0) := "011";
	CONSTANT st_sha_padding : STD_LOGIC_VECTOR(2 DOWNTO 0) := "100";
	CONSTANT st_sha_data_valid : STD_LOGIC_VECTOR(2 DOWNTO 0) := "101";
	CONSTANT st_error : STD_LOGIC_VECTOR(2 DOWNTO 0) := "110";


--	CONSTANT st_reset : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0000000";
--	CONSTANT st_sha_data_input : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0000001";
--	CONSTANT st_sha_blk_process : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0000010";
--	CONSTANT st_sha_blk_nxt : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0000100";
--	CONSTANT st_sha_padding : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0001000";
--
--	CONSTANT st_sha_data_valid : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0010000";
--	CONSTANT st_error : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0100000";

--	signal hash_control_st_reg  : STD_LOGIC_VECTOR(6 DOWNTO 0);
--	signal hash_control_st_next : STD_LOGIC_VECTOR(6 DOWNTO 0);

	 
	 
 --=============================================================================================
    -- Signals for internal operation
    --=============================================================================================
    -- combinational flags: message data input / padding control / block internal process selection
    signal reset : std_logic;
    signal sha_reset : std_logic;
    signal sha_init : std_logic;
   -- signal wait_run_ce : std_logic;
    -- registered flags: last block, padding control and hmac processing
    --signal sha_last_blk_reg : std_logic;
    signal sha_last_blk_next : std_logic;
    --signal padding_reg : std_logic;
    signal padding_next : std_logic;
    signal pad_one_reg : std_logic;
    signal pad_one_next : std_logic;
   -- signal bytes_error_reg : std_logic;
  --  signal bytes_error_next : std_logic;
    -- 64 bit message bit counter
    signal msg_bit_cnt_reg : unsigned (63 downto 0);
    signal msg_bit_cnt_next : unsigned (63 downto 0);
    signal bits_to_add : unsigned (5 downto 0);
    signal msg_bit_cnt_ce : std_logic;
    -- sequencer state counter
    --signal st_cnt_reg : unsigned (6 downto 0);
    signal st_cnt_next : unsigned (6 downto 0);
    signal st_cnt_ce : std_logic;
    signal st_cnt_clr : std_logic;
    
    --=============================================================================================
    -- Output Control Signals
    --=============================================================================================
    -- unregistered control signals
    signal words_sel : std_logic_vector (1 downto 0);   -- bitlen insertion control
    signal sch_ld : std_logic;                          -- input data load into message scheduler control
    signal core_ld : std_logic;                         -- hash core load data registers control
    signal oregs_ld : std_logic;                        -- load initial value into output regs control
    signal sch_ce : std_logic;                          -- clock enable for message scheduler logic block
    signal core_ce : std_logic;                         -- clock enable for hash core logic block
    signal oregs_ce : std_logic;                        -- clock enable for output regs logic block
    signal bytes_ena : std_logic_vector (3 downto 0);   -- byte lane selectors for padding logic block
    --signal one_insert : std_logic;                      -- insert leading one in the padding
    signal di_req : std_logic;                          -- data request
    signal data_valid : std_logic;                      -- operation finished. output data is valid
    signal core_error : std_logic;                      -- operation aborted. output data is not valid
    signal out_error : std_logic;                       -- operation aborted. output data is not valid

begin 
--process (clk_i, start_i) 
--    begin
--        -- FSM state register: sync RESET on 'reset', and sync PRESET on error_i
--        --if clk_i'event and clk_i = '1' then
--            if start_i = '1' or error_i='1' then
--                -- all registered values are reset on master clear
--                hash_control_st_reg <= st_reset;
--            elsif (clk_i'event and clk_i = '1') then
--                -- all registered values are held on master clock enable
--                hash_control_st_reg <= hash_control_st_next;
--            end if;
--       -- end if;
--    end process;

	 
	 process (clk_i, start_i) 
    begin
        -- FSM state register: sync RESET on 'reset', and sync PRESET on error_i
        --if clk_i'event and clk_i = '1' then
            if start_i = '1' then
                -- all registered values are reset on master clear
                hash_control_st_reg <= st_reset;
            elsif (clk_i'event and clk_i = '1') then
                -- all registered values are held on master clock enable
                hash_control_st_reg <= hash_control_st_next;
            end if;
				
    end process;
	 
	 
--=============================================================================================
    --  COMBINATIONAL NEXT-STATE LOGIC
    --=============================================================================================
    -- State and control path combinational logic
    -- The hash_control_st_reg state register controls the SHA256 algorithm.
    control_combi_proc : process (  hash_control_st_reg, sha_last_blk_reg, padding_reg, wait_run_ce, 
                                    end_i, st_cnt_reg, sha_last_blk_next, one_insert, sha_reset ) is
    begin
        -- default logic that applies to all states at each fsm clock --

        -- assign default values to all unchanging combinational outputs (avoid latches)
        hash_control_st_next <= hash_control_st_reg;
        --sha_last_blk_next <= sha_last_blk_reg;
        --padding_next <= padding_reg;
        -- handshaking
        sha_init <= '0';
        core_error <= '0';
        words_sel <= b"00";
        data_valid <= '0';
        di_req <= '0';              -- data request only during data input
        -- state counter
        st_cnt_clr <= '0';          -- only clear the state counter at the beginning of each block
        st_cnt_ce <= '0';
        -- message scheduler
        sch_ld <= '1';              -- enable pass-thru input through message schedule
        sch_ce <= '0';              -- stop message schedule clock
        -- hash core
        core_ld <= '0';             -- enable internal hash core logic
        core_ce <= '0';             -- core computation enabled only for data input and processing
        -- output registers
        oregs_ld <= '0';            -- defaults for accumulate blk hash
        oregs_ce <= '0';            -- only register init values and end of computation
        case hash_control_st_reg is
        
            when st_reset =>                -- master reset: starts a new hash/hmac processing
                -- moore outputs
                sha_init <= '1';            -- reset SHA256 engine
                oregs_ld <= '1';            -- load initial hash values
                oregs_ce <= '1';            -- latch initial hash values into output registers
                core_ld <= '1';             -- load initial value into core registers
                core_ce <= '1';             -- latch initial value into core registers
                st_cnt_clr <= '1';          -- reset state counter
                -- next state
                
					 if (((bytes_error_reg='0') and (error_i='1') and (start_i='0')) or ((bytes_error_reg='1') and (start_i='0'))) then
					 hash_control_st_next <= st_error;
					 else
					 hash_control_st_next <= st_sha_data_input;
					 end if;

            when st_sha_data_input =>       -- message data words are clocked into the processor
                -- moore outputs
                di_req <= '1';              -- request message data
                sch_ce <= wait_run_ce;      -- hold the message scheduler with data hold
                st_cnt_ce <= wait_run_ce;   -- hold state count with data hold
                core_ce <= wait_run_ce;     -- hold processing clock with data hold
                -- next state
                if wait_run_ce = '1' then
                    if end_i = '1' then 
                        hash_control_st_next <= st_sha_padding;     -- pad incomplete blocks
                    elsif st_cnt_reg = 15 then
                        hash_control_st_next <= st_sha_blk_process; -- process one more block
                    end if;
                end if;

            when st_sha_blk_process =>      -- internal block hash processing
                -- moore outputs
                st_cnt_ce <= '1';           -- enable state counter
                sch_ld <= '0';              -- recirculate scheduler data
                sch_ce <= '1';              -- enable message scheduler clock
                core_ce <= '1';             -- enable processing clock
                -- next state
                if st_cnt_reg = 63 then
                    hash_control_st_next <= st_sha_blk_nxt;
                end if;

            when st_sha_blk_nxt =>          -- prepare for next block
                -- moore outputs
                st_cnt_clr <= '1';          -- reset state counter at the beginning of each block
                sch_ld <= '0';
                sch_ce <= '0';              -- stop the message schedule
                core_ld <= '1';             -- load previous result value into core registers
                core_ce <= '1';             -- latch result value into core registers
                oregs_ce <= '1';            -- latch core result into regs accumulator
                -- next state
                -- _LLMHWS_SECTION_2_BEGIN
                if sha_last_blk_reg = '1' then
                    -- _LLMHWS_SECTION_3_BEGIN
                    hash_control_st_next <= st_sha_data_valid;  -- no hmac operation: publish data valid
                    -- _LLMHWS_SECTION_3_END
                elsif padding_reg = '1' then
                    hash_control_st_next <= st_sha_padding;     -- additional padding block
                else
                    hash_control_st_next <= st_sha_data_input;  -- continue requesting input data
                end if;
                -- _LLMHWS_SECTION_2_END
            
            when st_sha_padding =>          -- padding of bits on the last message block
                -- moore outputs                
                padding_next <= '1';
                if st_cnt_reg = 16 then     -- if word 16, data block was full: proceed to process this block
                    -- pause processing for this cycle
                    sch_ld <= '0';
                    sch_ce <= '0';
                    core_ce <= '0';
                    st_cnt_ce <= '0';
                    -- next state
                    hash_control_st_next <= st_sha_blk_process;
                else                        -- incomplete block: pad words until data block completes
                    sch_ld <= '1';          -- load padded data into scheduler
                    sch_ce <= '1';          -- enable message scheduler clock
                    core_ce <= '1';         -- enable processing clock
                    st_cnt_ce <= '1';       -- enable state counter
                    if st_cnt_reg = 15 then -- pad up to word 15
                        if sha_last_blk_next = '1' then
                            words_sel <= b"10";  -- insert bitlen lo
                        end if;
                        -- next state
                        hash_control_st_next <= st_sha_blk_process;
                    elsif (one_insert = '0') and (st_cnt_reg = 14) then
                        words_sel <= b"01";     -- insert bitlen hi
                        sha_last_blk_next <= '1';   -- mark this as the last block
                    elsif st_cnt_reg = 13 then
                        sha_last_blk_next <= '1';   -- mark this as the last block
                    end if;
                end if;

            when st_sha_data_valid =>       -- process is finished, waiting for begin command
                -- moore outputs
                data_valid <= '1';          -- output results are valid
                -- wait for core reset with 'reset'               

            when st_error =>                -- processing or input error: reset with 'reset' = 1
                -- moore outputs
                core_error <= '1';
                st_cnt_clr <= '1';          -- clear state counter
                -- wait for core reset with 'reset'               

            when others =>                  -- internal state machine error
                -- next state
                hash_control_st_next <= st_error;

        end case; 

if start_i = '1' then
        hash_control_st_next <= st_reset;
        end if;
    end process control_combi_proc;
	 
--=============================================================================================
    --  OUTPUT LOGIC PROCESSES
    --=============================================================================================
    
    bitlen_o_proc :         bitlen_o        <= std_logic_vector(msg_bit_cnt_reg);
    bytes_ena_o_proc :      bytes_ena_o     <= bytes_ena;
    one_insert_o_proc :     one_insert_o    <= one_insert;
    words_sel_o_proc :      words_sel_o     <= words_sel;
    sch_ce_o_proc :         sch_ce_o        <= sch_ce;
    sch_ld_o_proc :         sch_ld_o        <= sch_ld;
    core_ce_o_proc :        core_ce_o       <= core_ce;
    core_ld_o_proc :        core_ld_o       <= core_ld;
    oregs_ce_o_proc :       oregs_ce_o      <= oregs_ce;
    oregs_ld_o_proc :       oregs_ld_o      <= oregs_ld;
    Kt_addr_o_proc :        Kt_addr_o       <= std_logic_vector(st_cnt_reg(5 downto 0));
    di_req_o_proc :         di_req_o        <= di_req;
    -- _LLMHWS_SECTION_1_BEGIN
    data_valid_o_proc :     data_valid_o    <= data_valid;
    -- _LLMHWS_SECTION_1_END
    error_o_proc :          error_o         <= out_error;
	 
	 end rtl;
