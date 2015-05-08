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

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;

Entity hash_fi is

   Port (
           i : in std_logic_vector(511 downto 0);
         rst : in std_logic;
         clk : in std_logic;
           o : out std_logic_vector(511 downto 0)
         );

End hash_fi;

Architecture beh of hash_fi is

Component hash

  Port (
           i_n : in std_logic_vector(511 downto 0);
           rst : in std_logic;
             s : in std_logic;
           clk : in std_logic;
           o_n : out std_logic_vector(511 downto 0)
         );

End component;

Signal x0,x1,x2,x3,x4,x5,x6,x7,x8 : std_logic_vector(511 downto 0);
Signal s : std_logic;

Begin 

      s <= '0';
     
      
     m0 : hash port map(i(511 downto 0),rst,s,clk,x0(511 downto 0));
     m1 : hash port map(x0(511 downto 0),rst,s,clk,x1(511 downto 0));
     m2 : hash port map(x1(511 downto 0),rst,s,clk,x2(511 downto 0));
     m3 : hash port map(x2(511 downto 0),rst,s,clk,x3(511 downto 0));
     m4 : hash port map(x3(511 downto 0),rst,s,clk,x4(511 downto 0));
     m5 : hash port map(x4(511 downto 0),rst,s,clk,x5(511 downto 0));
     m6 : hash port map(x5(511 downto 0),rst,s,clk,x6(511 downto 0));
     m7 : hash port map(x6(511 downto 0),rst,s,clk,x7(511 downto 0));
     m8 : hash port map(x7(511 downto 0),rst,s,clk,x8(511 downto 0));
     m9 : hash port map(x8(511 downto 0),rst,s,clk,o(511 downto 0));

End beh;