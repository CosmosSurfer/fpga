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

Entity sbox is

  Port (
        ei : in std_logic_vector(3 downto 0);
         e : in std_logic_vector(3 downto 0);
       eoi : out std_logic_vector(3 downto 0);
        eo : out std_logic_vector(3 downto 0)
        );
End sbox;

Architecture beh of sbox is

Signal r : std_logic_vector(3 downto 0);
Begin

     r(0) <= e(0) xor ei(0);
     r(1) <= e(1) xor ei(1);
     r(2) <= e(2) xor ei(2);
     r(3) <= e(3) xor ei(3);

    eo(0) <= e(0) xor r(0);
    eo(1) <= e(1) xor r(1);
    eo(2) <= e(2) xor r(2);
    eo(3) <= e(3) xor r(3);

   eoi(0) <= ei(0) xor r(0);
   eoi(1) <= ei(1) xor r(1);
   eoi(2) <= ei(2) xor r(2);
   eoi(3) <= ei(3) xor r(3);

End beh;