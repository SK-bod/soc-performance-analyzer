library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity SK_module is
	port(
				--avalon memory-mapped slave
				clk		 : in 		std_logic;
				reset_n	 : in 		std_logic;
				--zakladam 32 bit szerokosci adresu, potrzebujemy 3 rejestry, 2xtimestamp 32bit, 1xrejestr na zapisywanie flag z HPS 
				address	 : in			std_logic_vector(2  downto 0);
				readdata	 : out		std_logic_vector(31 downto 0);
				read		 : in			std_logic;
				writedata : in			std_logic_vector(31 downto 0);
				write		 : in			std_logic;
				
				--systemid
				sysid		 : out		std_logic_vector(15 downto 0);
				data_valid: out		std_logic
		 );
end SK_module;