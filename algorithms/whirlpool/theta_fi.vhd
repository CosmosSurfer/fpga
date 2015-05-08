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

Entity theta_fi is

  Port  (
           a : in std_logic_vector(511 downto 0);
           b : out std_logic_vector(511 downto 0)
          );
End theta_fi;

Architecture beh of theta_fi is


Component theta 
Port (  
         a : in std_logic_vector(7 downto 0);
         b : out std_logic_vector(7 downto 0)
     );
End component;

signal s,si,e,ei : std_logic_vector(255 downto 0);

Begin
        
          s(255 downto 0) <= a(255 downto 0);
         si(255 downto 0) <= a(511 downto 256);

         m0 : theta port map(s(7 downto 0),e(7 downto 0));
         m1 : theta port map(s(15 downto 8),e(15 downto 8));
         m2 : theta port map(s(23 downto 16),e(23 downto 16));
         m3 : theta port map(s(31 downto 24),e(31 downto 24));
         m4 : theta port map(s(39 downto 32),e(39 downto 32));
         m5 : theta port map(s(47 downto 40),e(47 downto 40));
         m6 : theta port map(s(55 downto 48),e(55 downto 48));
         m7 : theta port map(s(63 downto 56),e(63 downto 56));
         m8 : theta port map(s(71 downto 64),e(71 downto 64));        
         m9 : theta port map(s(79 downto 72),e(79 downto 72));
        m10 : theta port map(s(87 downto 80),e(87 downto 80));
        m11 : theta port map(s(95 downto 88),e(95 downto 88));
        m12 : theta port map(s(103 downto 96),e(103 downto 96));
        m13 : theta port map(s(111 downto 104),e(111 downto 104));
        m14 : theta port map(s(119 downto 112),e(119 downto 112));
        m15 : theta port map(s(127 downto 120),e(127 downto 120));
        m16 : theta port map(s(135 downto 128),e(135 downto 128));
        m17 : theta port map(s(143 downto 136),e(143 downto 136));
        m18 : theta port map(s(151 downto 144),e(151 downto 144));
        m19 : theta port map(s(159 downto 152),e(159 downto 152)); 
        m20 : theta port map(s(167 downto 160),e(167 downto 160));
        m21 : theta port map(s(175 downto 168),e(175 downto 168));
        m22 : theta port map(s(183 downto 176),e(183 downto 176));
        m23 : theta port map(s(191 downto 184),e(191 downto 184));
        m24 : theta port map(s(199 downto 192),e(199 downto 192));
        m25 : theta port map(s(207 downto 200),e(207 downto 200));
        m26 : theta port map(s(215 downto 208),e(215 downto 208));
        m27 : theta port map(s(223 downto 216),e(223 downto 216));
        m28 : theta port map(s(231 downto 224),e(231 downto 224));
        m29 : theta port map(s(239 downto 232),e(239 downto 232));
        m30 : theta port map(s(247 downto 240),e(247 downto 240));
        m31 : theta port map(s(255 downto 248),e(255 downto 248));


        m32 : theta port map(si(7 downto 0),ei(7 downto 0));
        m33 : theta port map(si(15 downto 8),ei(15 downto 8));
        m34 : theta port map(si(23 downto 16),ei(23 downto 16));
        m35 : theta port map(si(31 downto 24),ei(31 downto 24));
        m36 : theta port map(si(39 downto 32),ei(39 downto 32));
        m37 : theta port map(si(47 downto 40),ei(47 downto 40));
        m38 : theta port map(si(55 downto 48),ei(55 downto 48));
        m39 : theta port map(si(63 downto 56),ei(63 downto 56));
        m40 : theta port map(si(71 downto 64),ei(71 downto 64));        
        m41 : theta port map(si(79 downto 72),ei(79 downto 72));
        m42 : theta port map(si(87 downto 80),ei(87 downto 80));
        m43 : theta port map(si(95 downto 88),ei(95 downto 88));
        m44 : theta port map(si(103 downto 96),ei(103 downto 96));
        m45 : theta port map(si(111 downto 104),ei(111 downto 104));
        m46 : theta port map(si(119 downto 112),ei(119 downto 112));
        m47 : theta port map(si(127 downto 120),ei(127 downto 120));
        m48 : theta port map(si(135 downto 128),ei(135 downto 128));
        m49 : theta port map(si(143 downto 136),ei(143 downto 136));
        m50 : theta port map(si(151 downto 144),ei(151 downto 144));
        m51 : theta port map(si(159 downto 152),ei(159 downto 152)); 
        m52 : theta port map(si(167 downto 160),ei(167 downto 160));
        m53 : theta port map(si(175 downto 168),ei(175 downto 168));
        m54 : theta port map(si(183 downto 176),ei(183 downto 176));
        m55 : theta port map(si(191 downto 184),ei(191 downto 184));
        m56 : theta port map(si(199 downto 192),ei(199 downto 192));
        m57 : theta port map(si(207 downto 200),ei(207 downto 200));
        m58 : theta port map(si(215 downto 208),ei(215 downto 208));
        m59 : theta port map(si(223 downto 216),ei(223 downto 216));
        m60 : theta port map(si(231 downto 224),ei(231 downto 224));
        m61 : theta port map(si(239 downto 232),ei(239 downto 232));
        m62 : theta port map(si(247 downto 240),ei(247 downto 240));
        m63 : theta port map(si(255 downto 248),ei(255 downto 248));

          b(511 downto 0) <= ei(255 downto 0) & e(255 downto 0);

End beh;