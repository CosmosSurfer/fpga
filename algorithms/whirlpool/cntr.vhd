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
USE IEEE.STD_LOGIC_ARITH.all;

Entity cntr is

  Port  (
           a : in std_logic_vector(7 downto 0);
         clk : in std_logic;
         rst : in std_logic;
       count : out std_logic_vector(4 downto 0);
           b : out std_logic_vector(255 downto 0)
         );

End cntr;

Architecture beh of cntr is

Signal cnt :std_logic_vector(4 downto 0);
Signal bi :std_logic_vector(255 downto 0);
Signal en : std_logic;

Begin  

process(clk,rst,cnt)

   begin 

	   if rst = '1' then 
		   cnt <="00000";
                     en <= '1';   ---- just now added
	     elsif clk'event and clk = '1' then 
	     
	            if en = '1' then  ---- just now added
		    cnt <= cnt + '1';
		      
                 --------- just noe added to stop the continuous increment----------
                 
                 if cnt = "11111" then    ---- just noiw added
                      en <= '0';   ---- just now added
                      cnt <= "11111";  ---- just now added
                   end if;     ---- just now added
                   end if;
--   end if;
-- end process;

   case cnt is 

        when "00000" => bi(7 downto 0) <= a(7 downto 0);
		  when "00001" => bi(15 downto 8) <= a(7 downto 0);
		  when "00010" => bi(23 downto 16) <= a(7 downto 0);
		  when "00011" => bi(31 downto 24) <= a(7 downto 0);
		  when "00100" => bi(39 downto 32) <= a(7 downto 0);
		  when "00101" => bi(47 downto 40) <= a(7 downto 0);
		  when "00110" => bi(55 downto 48) <= a(7 downto 0);
		  when "00111" => bi(63 downto 56) <= a(7 downto 0);
		  when "01000" => bi(71 downto 64) <= a(7 downto 0);
		  when "01001" => bi(79 downto 72) <= a(7 downto 0);
		  when "01010" => bi(87 downto 80) <= a(7 downto 0);
		  when "01011" => bi(95 downto 88) <= a(7 downto 0);
		  when "01100" => bi(103 downto 96) <= a(7 downto 0);
		  when "01101" => bi(111 downto 104) <= a(7 downto 0);
		  when "01110" => bi(119 downto 112) <= a(7 downto 0);
		  when "01111" => bi(127 downto 120) <= a(7 downto 0);
		  when "10000" => bi(135 downto 128) <= a(7 downto 0);
		  when "10001" => bi(143 downto 136) <= a(7 downto 0);
		  when "10010" => bi(151 downto 144) <= a(7 downto 0);
		  when "10011" => bi(159 downto 152) <= a(7 downto 0);
		  when "10100" => bi(167 downto 160) <= a(7 downto 0);
		  when "10101" => bi(175 downto 168) <= a(7 downto 0);
		  when "10110" => bi(183 downto 176) <= a(7 downto 0);
		  when "10111" => bi(191 downto 184) <= a(7 downto 0);
		  when "11000" => bi(199 downto 192) <= a(7 downto 0);
		  when "11001" => bi(207 downto 200) <= a(7 downto 0);
		  when "11010" => bi(215 downto 208) <= a(7 downto 0);
		  when "11011" => bi(223 downto 216) <= a(7 downto 0);
		  when "11100" => bi(231 downto 224) <= a(7 downto 0);
		  when "11101" => bi(239 downto 232) <= a(7 downto 0);
		  when "11110" => bi(247 downto 240) <= a(7 downto 0);
	 --  when "11111" => b(255 downto 248) := a(7 downto 0);
		  when others => bi(255 downto 248) <= a(7 downto 0);

	 end case;
 end if;
end process;
	   
		   b(255 downto 0)<= bi (255 downto 0);
     count <= cnt;
end beh;