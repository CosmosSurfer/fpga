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


Entity hash is

   Port (
           i_n : in std_logic_vector(511 downto 0);
           rst : in std_logic;
             s : in std_logic;
           clk : in std_logic;
           o_n : out std_logic_vector(511 downto 0)
         );

End hash;

Architecture beh of hash is
  
Component sbox_fi
 
Port  (
          sin : in std_logic_vector(511 downto 0);
      sbox_out : out std_logic_vector(511 downto 0)
          );

End component;

Component pi

Port  (
          a : in std_logic_vector(511 downto 0);
          b : out std_logic_vector(511 downto 0)
        );


End component;

Component theta_fi

    Port  (
           a : in std_logic_vector(511 downto 0);
           b : out std_logic_vector(511 downto 0)
          );

End component;

Component mux 

port 
      (
           a : in std_logic_vector(511 downto 0);
           b : in std_logic_vector(511 downto 0);
           s : in std_logic; 
           c : out std_logic_vector(511 downto 0)
        );

End component;


Signal hi,ai,ai1 : std_logic_vector(511 downto 0):=(others=>'0');
signal ki,i3i,i2i : std_logic_vector(511 downto 0):=(others=>'0');
Signal i1,i3,x,y,z,i : std_logic_vector(511 downto 0):=(others=>'0');
Signal x1,y1,z1,z2 : std_logic_vector(511 downto 0):=(others=>'0');
Signal s1 : std_logic;


Begin 


      s1 <= '1';

    
	  m0 : mux port map (i_n(511 downto 0),i3i(511 downto 0),s,i(511 downto 0));
     i1(511 downto 0) <= i(511 downto 0) xor ki(511 downto 0);
     
    m1 : pi port map(i1(511 downto 0),hi(511 downto 0));
    m2 : mux port map(i1(511 downto 0),i3i(511 downto 0),s1,ai(511 downto 0));
    m3 : pi port map(ai(511 downto 0),x(511 downto 0));
    m4 : sbox_fi port map(x(511 downto 0),y(511 downto 0));
    m5 : theta_fi port map(y(511 downto 0),z(511 downto 0));
 
    m6 : mux port map(hi(511 downto 0),i2i(511 downto 0),s1,ai1(511 downto 0));
    m7 : pi port map(ai1(511 downto 0),x1(511 downto 0));
    m8 : sbox_fi port map(x1(511 downto 0),y1(511 downto 0));
    m9 : theta_fi port map(y1(511 downto 0),z1(511 downto 0));

	 i3(511 downto 0) <= z1(511 downto 0) xor z(511 downto 0);
    
        o_n <= hi;
    
End beh;