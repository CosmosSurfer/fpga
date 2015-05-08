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

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

Entity mux is

port 
      (
           a : in std_logic_vector(511 downto 0);
           b : in std_logic_vector(511 downto 0);
           s : in std_logic; 
           c : out std_logic_vector(511 downto 0)
        );
End mux;

Architecture beh of mux is



begin 
   
process(s,a,b)

begin 
   if s='0' then 
      c <= a;
   elsif s='1' then
      c <= b;

end if;
end process;
   
end beh;