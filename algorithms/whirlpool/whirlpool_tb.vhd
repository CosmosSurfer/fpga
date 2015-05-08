-- 
-- Copyright (c) 2013-2015 John Connor (BM-NC49AxAjcqVcF5jNPu85Rb8MJ2d9JqZt)
-- 
-- This is free software: you can redistribute it and/or modify
-- it under the terms of the GNU Affero General Public License with
-- additional permissions to the one published by the Free Software
-- Foundation, either version 3 of the License, or (at your option)
-- any later version. For more information see LICENSE.
-- 
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU Affero General Public License for more details.
-- 
-- You should have received a copy of the GNU Affero General Public License
-- along with this program. If not, see <http://www.gnu.org/licenses/>.
--

LIBRARY ieee;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_1164.all;
ENTITY whirlpool_tb IS
END;

ARCHITECTURE whirlpool_tb_arch OF whirlpool_tb IS
  SIGNAL rst : std_logic;
  SIGNAL a : std_logic_vector (7 downto 0);
  SIGNAL clk : std_logic;
  SIGNAL cout : std_logic_vector (7 downto 0);
  COMPONENT whirlpool
    PORT (
      rst : in std_logic;
      a : in std_logic_vector (7 downto 0);
      clk : in std_logic;
      cout : out std_logic_vector (7 downto 0));
  END COMPONENT;
BEGIN
  DUT: whirlpool PORT MAP (rst => rst,a => a,clk => clk,cout => cout);
      
      rst <= '1','0' after 20 ns;
      
     a <= "01010110","01010100" after 60 ns,"01101001" after 100 ns, "01010000" after 140 ns,"01011011" after 180 ns,"01101000" after 280 ns,"00000111" after 360 ns,"01110111" after 440 ns,"00000000" after 520 ns,"01001010" after 640 ns;
      
      process
          begin
            
              clk <= '1';
                wait for 20 ns;
              clk <= '0';
                 wait for 20 ns;
              end process;
              
END;

