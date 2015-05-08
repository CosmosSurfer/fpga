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

Entity theta is

    Port (  
            a : in std_logic_vector(7 downto 0);
            b : out std_logic_vector(7 downto 0)
           );
End theta;

Architecture beh of theta is

signal s,x : std_logic_vector(15 downto 0);

Begin

       s(0) <= a(3) xor a(6);
       s(1) <= a(1) xor a(4);
       x(0) <= s(0) and s(0);
       x(1) <= s(1) and s(1) and s(1);

       s(2) <= a(4) xor a(7);
       s(3) <= a(2) xor a(5);
       x(2) <= s(2) and s(2);
       x(3) <= s(3) and s(3) and s(3);

       s(4) <= a(5) xor a(0);
       s(5) <= a(3) xor a(6);
       x(4) <= s(4) and s(4);
       x(5) <= s(5) and s(5) and s(5);

       s(6) <= a(6) xor a(1);
       s(7) <= a(4) xor a(7);
       x(6) <= s(6) and s(6);
       x(7) <= s(7) and s(7) and s(7);

       s(8) <= a(7) xor a(2);
       s(9) <= a(5) xor a(0);
       x(8) <= s(8) and s(8);
       x(9) <= s(9) and s(9) and s(9);

       s(10) <= a(0) xor a(3);
       s(11) <= a(6) xor a(1);
       x(10) <= s(10) and s(10);
       x(11) <= s(11) and s(11) and s(11);

       s(12) <= a(1) xor a(4);
       s(13) <= a(7) xor a(2);
       x(12) <= s(12) and s(12);
       x(13) <= s(13) and s(13) and s(13);

       s(14) <= a(2) xor a(5);
       s(15) <= a(0) xor a(3);
       x(14) <= s(14) and s(14);
       x(15) <= s(15)and s(15) and s(15);

   b(0) <= a(0) xor a(1) xor a(3) xor a(5) xor a(7) xor a(2) xor x(0) xor x(1);
   b(1) <= a(0) xor a(1) xor a(2) xor a(4) xor a(6) xor a(3) xor x(2) xor x(3);
   b(2) <= a(1) xor a(2) xor a(3) xor a(5) xor a(7) xor a(4) xor x(4) xor x(5);
   b(3) <= a(0) xor a(2) xor a(3) xor a(4) xor a(6) xor a(5) xor x(6) xor x(7);
   b(4) <= a(1) xor a(3) xor a(4) xor a(5) xor a(7) xor a(6) xor x(8) xor x(9);
   b(5) <= a(0) xor a(2) xor a(4) xor a(5) xor a(6) xor a(7) xor x(10) xor x(11);
   b(6) <= a(1) xor a(3) xor a(5) xor a(6) xor a(7) xor a(0) xor x(12) xor x(13);
   b(7) <= a(0) xor a(2) xor a(4) xor a(6) xor a(7) xor a(1) xor x(14) xor x(15);

End beh;