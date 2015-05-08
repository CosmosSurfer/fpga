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

Entity sbox_fi is

  Port  (
          sin : in std_logic_vector(511 downto 0);
      sbox_out : out std_logic_vector(511 downto 0)
          );

End sbox_fi;

Architecture beh of sbox_fi is

Component sbox

 Port (
        ei : in std_logic_vector(3 downto 0);
         e : in std_logic_vector(3 downto 0);
       eoi : out std_logic_vector(3 downto 0);
        eo : out std_logic_vector(3 downto 0)
        );
End component;

signal s,si,e,ei : std_logic_vector(255 downto 0);
Begin 
--         s(125 downto 0) <= (others=>'1');
--         s(255 downto 126) <= (others=>'0');
           s(255 downto 0) <= sin(255 downto 0);
           si(255 downto 0) <= sin(511 downto 256);


         m0 : sbox port map(s(3 downto 0),s(7 downto 4),e(3 downto 0),e(7 downto 4));
         m1 : sbox port map(s(11 downto 8),s(15 downto 12),e(11 downto 8),e(15 downto 12));
         m2 : sbox port map(s(19 downto 16),s(23 downto 20),e(19 downto 16),e(23 downto 20));
         m3 : sbox port map(s(27 downto 24),s(31 downto 28),e(27 downto 24),e(31 downto 28));
         m4 : sbox port map(s(35 downto 32),s(39 downto 36),e(35 downto 32),e(39 downto 36));
         m5 : sbox port map(s(43 downto 40),s(47 downto 44),e(43 downto 40),e(47 downto 44));
         m6 : sbox port map(s(51 downto 48),s(55 downto 52),e(51 downto 48),e(55 downto 52));
         m7 : sbox port map(s(59 downto 56),s(63 downto 60),e(59 downto 56),e(63 downto 60));
         m8 : sbox port map(s(67 downto 64),s(71 downto 68),e(67 downto 64),e(71 downto 68));        
         m9 : sbox port map(s(75 downto 72),s(79 downto 76),e(75 downto 72),e(79 downto 76));
        m10 : sbox port map(s(83 downto 80),s(87 downto 84),e(83 downto 80),e(87 downto 84));
        m11 : sbox port map(s(91 downto 88),s(95 downto 92),e(91 downto 88),e(95 downto 92));
        m12 : sbox port map(s(99 downto 96),s(103 downto 100),e(99 downto 96),e(103 downto 100));
        m13 : sbox port map(s(107 downto 104),s(111 downto 108),e(107 downto 104),e(111 downto 108));
        m14 : sbox port map(s(115 downto 112),s(119 downto 116),e(115 downto 112),e(119 downto 116));
        m15 : sbox port map(s(123 downto 120),s(127 downto 124),e(123 downto 120),e(127 downto 124));
        m16 : sbox port map(s(131 downto 128),s(135 downto 132),e(131 downto 128),e(135 downto 132));
        m17 : sbox port map(s(139 downto 136),s(143 downto 140),e(139 downto 136),e(143 downto 140));
        m18 : sbox port map(s(147 downto 144),s(151 downto 148),e(147 downto 144),e(151 downto 148));
        m19 : sbox port map(s(155 downto 152),s(159 downto 156),e(155 downto 152),e(159 downto 156)); 
        m20 : sbox port map(s(163 downto 160),s(167 downto 164),e(163 downto 160),e(167 downto 164));
        m21 : sbox port map(s(171 downto 168),s(175 downto 172),e(171 downto 168),e(175 downto 172));
        m22 : sbox port map(s(179 downto 176),s(183 downto 180),e(179 downto 176),e(183 downto 180));
        m23 : sbox port map(s(187 downto 184),s(191 downto 188),e(187 downto 184),e(191 downto 188));
        m24 : sbox port map(s(195 downto 192),s(199 downto 196),e(195 downto 192),e(199 downto 196));
        m25 : sbox port map(s(203 downto 200),s(207 downto 204),e(203 downto 200),e(207 downto 204));
        m26 : sbox port map(s(211 downto 208),s(215 downto 212),e(211 downto 208),e(215 downto 212));
        m27 : sbox port map(s(219 downto 216),s(223 downto 220),e(219 downto 216),e(223 downto 220));
        m28 : sbox port map(s(227 downto 224),s(231 downto 228),e(227 downto 224),e(231 downto 228));
        m29 : sbox port map(s(235 downto 232),s(239 downto 236),e(235 downto 232),e(239 downto 236));
        m30 : sbox port map(s(243 downto 240),s(247 downto 244),e(243 downto 240),e(247 downto 244));
        m31 : sbox port map(s(251 downto 248),s(255 downto 252),e(251 downto 248),e(255 downto 252));


        m32 : sbox port map(si(3 downto 0),si(7 downto 4),ei(3 downto 0),ei(7 downto 4));
        m33 : sbox port map(si(11 downto 8),si(15 downto 12),ei(11 downto 8),ei(15 downto 12));
        m34 : sbox port map(si(19 downto 16),si(23 downto 20),ei(19 downto 16),ei(23 downto 20));
        m35 : sbox port map(si(27 downto 24),si(31 downto 28),ei(27 downto 24),ei(31 downto 28));
        m36 : sbox port map(si(35 downto 32),si(39 downto 36),ei(35 downto 32),ei(39 downto 36));
        m37 : sbox port map(si(43 downto 40),si(47 downto 44),ei(43 downto 40),ei(47 downto 44));
        m38 : sbox port map(si(51 downto 48),si(55 downto 52),ei(51 downto 48),ei(55 downto 52));
        m39 : sbox port map(si(59 downto 56),si(63 downto 60),ei(59 downto 56),ei(63 downto 60));
        m40 : sbox port map(si(67 downto 64),si(71 downto 68),ei(67 downto 64),ei(71 downto 68));        
        m41 : sbox port map(si(75 downto 72),si(79 downto 76),ei(75 downto 72),ei(79 downto 76));
        m42 : sbox port map(si(83 downto 80),si(87 downto 84),ei(83 downto 80),ei(87 downto 84));
        m43 : sbox port map(si(91 downto 88),si(95 downto 92),ei(91 downto 88),ei(95 downto 92));
        m44 : sbox port map(si(99 downto 96),si(103 downto 100),ei(99 downto 96),ei(103 downto 100));
        m45 : sbox port map(si(107 downto 104),si(111 downto 108),ei(107 downto 104),ei(111 downto 108));
        m46 : sbox port map(si(115 downto 112),si(119 downto 116),ei(115 downto 112),ei(119 downto 116));
        m47 : sbox port map(si(123 downto 120),si(127 downto 124),ei(123 downto 120),ei(127 downto 124));
        m48 : sbox port map(si(131 downto 128),si(135 downto 132),ei(131 downto 128),ei(135 downto 132));
        m49 : sbox port map(si(139 downto 136),si(143 downto 140),ei(139 downto 136),ei(143 downto 140));
        m50 : sbox port map(si(147 downto 144),si(151 downto 148),ei(147 downto 144),ei(151 downto 148));
        m51 : sbox port map(si(155 downto 152),si(159 downto 156),ei(155 downto 152),ei(159 downto 156)); 
        m52 : sbox port map(si(163 downto 160),si(167 downto 164),ei(163 downto 160),ei(167 downto 164));
        m53 : sbox port map(si(171 downto 168),si(175 downto 172),ei(171 downto 168),ei(175 downto 172));
        m54 : sbox port map(si(179 downto 176),si(183 downto 180),ei(179 downto 176),ei(183 downto 180));
        m55 : sbox port map(si(187 downto 184),si(191 downto 188),ei(187 downto 184),ei(191 downto 188));
        m56 : sbox port map(si(195 downto 192),si(199 downto 196),ei(195 downto 192),ei(199 downto 196));
        m57 : sbox port map(si(203 downto 200),si(207 downto 204),ei(203 downto 200),ei(207 downto 204));
        m58 : sbox port map(si(211 downto 208),si(215 downto 212),ei(211 downto 208),ei(215 downto 212));
        m59 : sbox port map(si(219 downto 216),si(223 downto 220),ei(219 downto 216),ei(223 downto 220));
        m60 : sbox port map(si(227 downto 224),si(231 downto 228),ei(227 downto 224),ei(231 downto 228));
        m61 : sbox port map(si(235 downto 232),si(239 downto 236),ei(235 downto 232),ei(239 downto 236));
        m62 : sbox port map(si(243 downto 240),si(247 downto 244),ei(243 downto 240),ei(247 downto 244));
        m63 : sbox port map(si(251 downto 248),si(255 downto 252),ei(251 downto 248),ei(255 downto 252));

       sbox_out(511 downto 0) <= ei(255 downto 0) & e(255 downto 0);

End beh;