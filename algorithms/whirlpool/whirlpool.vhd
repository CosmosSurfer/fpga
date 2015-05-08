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

Entity whirlpool is 

    Port  (
             a : in std_logic_vector(7 downto 0);
           clk : in std_logic;
           rst : in std_logic;
          cout : out std_logic_vector(7 downto 0)
          );

End whirlpool;

Architecture beh of whirlpool is

Component hash_fi
  Port (
           i : in std_logic_vector(511 downto 0);
         rst : in std_logic;
         clk : in std_logic;
           o : out std_logic_vector(511 downto 0)
         );
End component;

Component cntr 

Port  (
           a : in std_logic_vector(7 downto 0);
         clk : in std_logic;
         rst : in std_logic;
       count : out std_logic_vector(4 downto 0);
           b : out std_logic_vector(255 downto 0)
         );

End component;

Signal h1,h2,b,b1 : std_logic_vector(255 downto 0);
Signal z,h : std_logic_vector(511 downto 0);
--Signal cnt,cnt1,ct : std_logic_vector(4 downto 0);
Signal cnt : std_logic_vector(5 downto 0);  --- just now added
Signal ct : std_logic_vector(4 downto 0); --- just now added
signal c : std_logic_vector(7 downto 0);
--Signal s,s1,en : std_logic;
Signal s,en : std_logic;

Begin 
        b1(255 downto 0) <= (others=>'0');

        m0 : cntr port map(a(7 downto 0),clk,rst,ct,b(255 downto 0));
        z(511 downto 0) <= b(255 downto 0) & b1(255 downto 0);
        m1 : hash_fi port map(z(511 downto 0),rst,clk,h(511 downto 0));

        h1(255 downto 0) <= h(255 downto 0);
        h2(255 downto 0) <= h(511 downto 256);
       
       s <= ct(0) and ct(1) and ct(2) and ct(3) and ct(4);

--process(clk,rst,h1(255 downto 0),h2(255 downto 0),cnt,cnt1,c,s,s1)
process(clk,rst,h1(255 downto 0),h2(255 downto 0),cnt)

 begin 
  
----- just now added to reduce the delay-------------

       if rst = '1' then 
       c(7 downto 0) <= (others=>'0');
             en <= '1';
      elsif clk'event and clk ='1' then 
           if s = '1' then 
           if en = '1' then
             cnt <="000000";
           
        if cnt <= "000000" then 
           c(7 downto 0)<=h1(7 downto 0);
            cnt <= cnt +'1';

         elsif cnt <= "000001" then 
           c(7 downto 0)<=h1(15 downto 8);
            cnt <= cnt +'1';

         elsif cnt <= "000010" then 
           c(7 downto 0)<= h1(23 downto 16);
            cnt <= cnt +'1';

         elsif cnt <= "000011" then 
           c(7 downto 0)<= h1(31 downto 24);
            cnt <= cnt +'1';

         elsif cnt <= "000100" then 
          c(7 downto 0)<= h1(39 downto 32);
            cnt <= cnt +'1';

         elsif cnt <= "000101" then 
           c(7 downto 0) <=h1(47 downto 40);
            cnt <= cnt +'1';

         elsif cnt <= "000110" then 
           c(7 downto 0)<= h1(55 downto 48);
            cnt <= cnt +'1';

         elsif cnt <= "000111" then 
           c(7 downto 0) <= h1(63 downto 56);
            cnt <= cnt +'1';

         elsif cnt <= "001000" then 
          c(7 downto 0)<= h1(71 downto 64);
            cnt <= cnt +'1';

         elsif cnt <= "001001" then 
           c(7 downto 0) <= h1(79 downto 72);
            cnt <= cnt +'1';

         elsif cnt <= "001010" then 
           c(7 downto 0) <= h1(87 downto 80);
            cnt <= cnt +'1';

         elsif cnt <= "001011" then 
           c(7 downto 0) <= h1(95 downto 88);
            cnt <= cnt +'1';

         elsif cnt <= "001100" then 
           c(7 downto 0) <= h1(103 downto 96);
            cnt <= cnt +'1';


         elsif cnt <= "001101" then 
           c(7 downto 0) <= h1(111 downto 104);
            cnt <= cnt +'1';

         elsif cnt <= "001110" then 
           c(7 downto 0) <= h1(119 downto 112);
            cnt <= cnt +'1';

         elsif cnt <= "001111" then 
           c(7 downto 0) <= h1(127 downto 120);
            cnt <= cnt +'1';

         elsif cnt <= "010000" then 
           c(7 downto 0) <= h1(135 downto 128);
            cnt <= cnt +'1';

         elsif cnt <= "010001" then 
            c(7 downto 0) <=h1(143 downto 136);
            cnt <= cnt +'1';
        elsif cnt <= "010010" then 
           c(7 downto 0) <= h1(151 downto 144);
            cnt <= cnt +'1';

         elsif cnt <= "010011" then 
           c(7 downto 0) <= h1(159 downto 152);
            cnt <= cnt +'1';

         elsif cnt <= "010100" then 
           c(7 downto 0) <= h1(167 downto 160);
            cnt <= cnt +'1';

         elsif cnt <= "010101" then 
            c(7 downto 0) <= h1(175 downto 168);
            cnt <= cnt +'1';

         elsif cnt <= "010110" then 
          c(7 downto 0)<= h1(183 downto 176);
            cnt <= cnt +'1';

         elsif cnt <= "010111" then 
            c(7 downto 0) <= h1(191 downto 184);
            cnt <= cnt +'1';

         elsif cnt <= "011000" then 
            c(7 downto 0) <= h1(199 downto 192);
            cnt <= cnt +'1';

         elsif cnt <= "011001" then 
           c(7 downto 0)<= h1(207 downto 200);
            cnt <= cnt +'1';

         elsif cnt <= "011010" then 
           c(7 downto 0) <= h1(215 downto 208);
            cnt <= cnt +'1';

         elsif cnt <= "011011" then 
            c(7 downto 0) <=h1(223 downto 216);
            cnt <= cnt +'1';

         elsif cnt <= "011100" then 
           c(7 downto 0) <= h1(231 downto 224);
            cnt <= cnt +'1';


         elsif cnt <= "011101" then 
           c(7 downto 0) <= h1(239 downto 232);
            cnt <= cnt +'1';

         elsif cnt <= "011110" then 
            c(7 downto 0) <= h1(247 downto 240);
            cnt <= cnt +'1';

         elsif cnt <= "011111" then 
           c(7 downto 0) <= h1(255 downto 248);
            cnt <= cnt +'1';
------------------------------------------------------------------------
         
            elsif cnt ="100000" then 
           c(7 downto 0)<=h2(7 downto 0);
           cnt <= cnt +'1';

         elsif cnt <= "100001" then 
           c(7 downto 0)<=h2(15 downto 8);
             cnt <= cnt +'1';

         elsif cnt <= "100010" then 
           c(7 downto 0)<= h2(23 downto 16);
            cnt <= cnt +'1';

         elsif cnt <= "100011" then 
           c(7 downto 0)<= h2(31 downto 24);
           cnt <= cnt +'1';

         elsif cnt <= "100100" then 
          c(7 downto 0)<= h2(39 downto 32);
            cnt <= cnt +'1';

         elsif cnt <= "100101" then 
           c(7 downto 0) <=h2(47 downto 40);
            cnt <= cnt +'1';

         elsif cnt <= "100110" then 
           c(7 downto 0)<= h2(55 downto 48);
            cnt <= cnt +'1';

         elsif cnt <= "100111" then 
           c(7 downto 0) <= h2(63 downto 56);
            cnt <= cnt +'1';

         elsif cnt <= "101000" then 
          c(7 downto 0)<= h2(71 downto 64);
            cnt <= cnt +'1';

         elsif cnt <= "101001" then 
           c(7 downto 0) <= h2(79 downto 72);
            cnt <= cnt +'1';
         elsif cnt <= "101010" then 
           c(7 downto 0) <= h2(87 downto 80);
            cnt <= cnt +'1';
         elsif cnt <= "101011" then 
           c(7 downto 0) <= h2(95 downto 88);
           cnt <= cnt +'1';

         elsif cnt <= "101100" then 
           c(7 downto 0) <= h2(103 downto 96);
           cnt <= cnt +'1';

         elsif cnt <= "101101" then 
           c(7 downto 0) <= h2(111 downto 104);
           cnt <= cnt +'1';

         elsif cnt <= "101110" then 
           c(7 downto 0) <= h2(119 downto 112);
           cnt <= cnt +'1';

         elsif cnt <= "101111" then 
           c(7 downto 0) <= h2(127 downto 120);
           cnt <= cnt +'1';

         elsif cnt <= "110000" then 
           c(7 downto 0) <= h2(135 downto 128);
           cnt <= cnt +'1';

         elsif cnt <= "110001" then 
            c(7 downto 0) <=h2(143 downto 136);
           cnt <= cnt +'1';
           
        elsif cnt <= "110010" then 
           c(7 downto 0) <= h2(151 downto 144);
           cnt <= cnt +'1';

         elsif cnt <= "110011" then 
           c(7 downto 0) <= h2(159 downto 152);
            cnt <= cnt +'1';

         elsif cnt <= "110100" then 
           c(7 downto 0) <= h2(167 downto 160);
            cnt <= cnt +'1';

         elsif cnt <= "110101" then 
            c(7 downto 0) <= h2(175 downto 168);
            cnt <= cnt +'1';

         elsif cnt <= "110110" then 
          c(7 downto 0)<= h2(183 downto 176);
            cnt <= cnt +'1';

         elsif cnt <= "110111" then 
            c(7 downto 0) <= h2(191 downto 184);
           cnt <= cnt +'1';

         elsif cnt <= "111000" then 
            c(7 downto 0) <= h2(199 downto 192);
           cnt <= cnt +'1';

         elsif cnt <= "111001" then 
           c(7 downto 0)<= h2(207 downto 200);
           cnt <= cnt +'1';

         elsif cnt <= "111010" then 
           c(7 downto 0) <= h2(215 downto 208);
            cnt <= cnt +'1';

         elsif cnt <= "111011" then 
            c(7 downto 0) <=h2(223 downto 216);
           cnt <= cnt +'1';

         elsif cnt <= "111100" then 
           c(7 downto 0) <= h2(231 downto 224);
            cnt <= cnt +'1';


         elsif cnt <= "111101" then 
           c(7 downto 0) <= h2(239 downto 232);
           cnt <= cnt +'1';

         elsif cnt <= "111110" then 
            c(7 downto 0) <= h2(247 downto 240);
            cnt <= cnt +'1';

         elsif cnt <= "111111" then 
           c(7 downto 0) <= h2(255 downto 248);
              if cnt ="111111" then
                  en <= '0';
               end if;
   end if;
 end if;
 end if;
end if;
end process;         

cout <= c;

End beh;         
