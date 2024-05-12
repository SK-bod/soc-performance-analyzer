library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library vunit_lib;
context vunit_lib.vunit_context;

library design_lib;

entity sk_module_tb is
 
  generic(runner_cfg : string := runner_cfg_default);
 
end entity sk_module_tb;


architecture tb of sk_module_tb is
  --------------------------------------------------------------------------
  -- types, records, internal signals, fsm, constants declaration.
  --------------------------------------------------------------------------
  -- constants declaration --
  -- simulation constants
  constant c_clk_period : time := 10 ns;
  signal read_address_temp	: std_logic_vector (8 downto 0) := B"000000001";
  -- signals from sk module
  --avalon-mm s1 (read only)
  signal read_data : std_logic_vector (31 downto 0);
  signal read_address	: std_logic_vector (8 downto 0);
  signal read			: std_logic;
  --avalon-mm s2 (write only)
  signal write_data		: std_logic_vector (31 downto 0);
  signal write			: std_logic;

  -- internal signals declaration --
  -- dut interface
  signal clk             : std_logic := '0';
  signal reset_n           : std_logic := '0';

  begin
  ---------------------------------------------------------
  -- dut instation
  ---------------------------------------------------------
  dut : entity design_lib.sk_module
    port map 
    (
      read_data => read_data,
      read_address => read_address,
      read => read,
      write_data => write_data,
      write => write,
      clk => clk,
      reset_n => reset_n
    );
  --------------------------------------------------------------------------
  -- clock and reset.
  --------------------------------------------------------------------------
  clk   <= not clk after c_clk_period / 2;
  reset_n <= '1' after 5 * (c_clk_period / 2);
  -----------------------test run------------------------

    main : process
    begin
    -- setup vunit
    test_runner_setup(runner, runner_cfg);
    test_cases_loop : while test_suite loop
    
      -- your testbench test cases here
      if run("test_case_check_write_signal") then
        info("--------------------------------------------------------------------------------");
        info("TEST CASE: write signal check");
        info("--------------------------------------------------------------------------------");
        read <= '0';
        write <= '0';
        write_data <= x"AAAAAAAA";
        read_address <= B"000000000";
        --piszemy do pamieci RAM
        -- for i in 1 to 4 loop
          wait for 40 ns;
          wait until falling_edge(clk);
          write <= '1';
          wait until falling_edge(clk);
          write <= '0';
        -- end loop;
        -- sczytujemy wartosci z pamieci RAM
        -- read_address <= B"000000001";
        -- for i in 1 to 4 loop
          wait for 40 ns;
          wait until falling_edge(clk);
          read <= '1';
          wait until falling_edge(clk);
          read <= '0';
        -- end loop;

        write_data <= x"BBBBBBBB";
        --piszemy do pamieci RAM
        -- for i in 1 to 4 loop
          wait for 40 ns;
          wait until falling_edge(clk);
          write <= '1';
          wait until falling_edge(clk);
          write <= '0';
        
        write_data <= x"CCCCCCCC";
        --piszemy do pamieci RAM
        -- for i in 1 to 4 loop
          wait for 40 ns;
          wait until falling_edge(clk);
          write <= '1';
          wait until falling_edge(clk);
          write <= '0';
        -- end loop;
        --sczytujemy wartosci z pamieci RAM
        for i in 1 to 6 loop
          read_address <= std_logic_vector(to_unsigned((i), 9));
          wait for 40 ns;
          wait until falling_edge(clk);
          read <= '1';
          wait until falling_edge(clk);
          read <= '0';
        end loop;
        -- wait for 40 ns;
        -- read_address <= std_logic_vector(to_unsigned((0), 9));
        -- wait until falling_edge(clk);
        -- read <= '1';
        -- wait until falling_edge(clk);
        -- read <= '0';
      -- end loop;
        wait for 40 ns;
        
        info("===== TEST CASE FINISHED =====");
      
      elsif run("test_case_name_2") then
      -- test case code here
      
      end if;

    end loop test_cases_loop;
    
    test_runner_cleanup(runner); -- end of simulation
    wait;
    end process;
end architecture tb;