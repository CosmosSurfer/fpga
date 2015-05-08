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

Entity pi is
    
  Port  (
          a : in std_logic_vector(511 downto 0);
          b : out std_logic_vector(511 downto 0)
        );
End pi;

Architecture beh of pi is

Begin 

        b(15 downto 0) <= a(0)&a(497)&a(482)&a(467)&a(452)&a(437)&a(422)&a(407)&a(392)&a(377)&a(362)&a(347)&a(332)&a(317)&a(302)&a(287);
       b(31 downto 16) <= a(16)&a(1)&a(498)&a(483)&a(468)&a(453)&a(438)&a(423)&a(408)&a(393)&a(378)&a(363)&a(348)&a(333)&a(318)&a(303);
       b(47 downto 32) <= a(32)&a(17)&a(2)&a(499)&a(484)&a(469)&a(454)&a(439)&a(424)&a(409)&a(394)&a(379)&a(364)&a(349)&a(334)&a(319);
       b(63 downto 48) <= a(48)&a(33)&a(18)&a(3)&a(500)&a(485)&a(470)&a(455)&a(440)&a(425)&a(410)&a(395)&a(380)&a(365)&a(350)&a(335);
       b(79 downto 64) <= a(64)&a(49)&a(34)&a(19)&a(4)&a(501)&a(486)&a(471)&a(456)&a(441)&a(426)&a(411)&a(396)&a(381)&a(366)&a(351);
       b(95 downto 80) <= a(80)&a(65)&a(50)&a(35)&a(20)&a(5)&a(502)&a(487)&a(472)&a(457)&a(442)&a(427)&a(412)&a(397)&a(382)&a(367);
      b(111 downto 96) <= a(96)&a(81)&a(66)&a(51)&a(36)&a(21)&a(6)&a(503)&a(488)&a(473)&a(458)&a(443)&a(428)&a(413)&a(398)&a(383);
     b(127 downto 112) <= a(112)&a(97)&a(82)&a(67)&a(52)&a(37)&a(22)&a(7)&a(504)&a(489)&a(474)&a(459)&a(444)&a(429)&a(414)&a(399);
     b(143 downto 128) <= a(128)&a(113)&a(98)&a(83)&a(68)&a(53)&a(38)&a(23)&a(8)&a(505)&a(490)&a(475)&a(460)&a(445)&a(430)&a(415);
     b(159 downto 144) <= a(144)&a(129)&a(114)&a(99)&a(84)&a(69)&a(54)&a(39)&a(24)&a(9)&a(506)&a(491)&a(476)&a(461)&a(446)&a(431);
     b(175 downto 160) <= a(160)&a(145)&a(130)&a(115)&a(100)&a(85)&a(70)&a(55)&a(40)&a(25)&a(10)&a(507)&a(492)&a(477)&a(462)&a(447);
     b(191 downto 176) <= a(176)&a(161)&a(146)&a(131)&a(116)&a(101)&a(86)&a(71)&a(56)&a(41)&a(26)&a(11)&a(508)&a(493)&a(478)&a(463);
     b(207 downto 192) <= a(192)&a(177)&a(162)&a(147)&a(132)&a(117)&a(102)&a(87)&a(72)&a(57)&a(42)&a(27)&a(12)&a(509)&a(494)&a(479);
     b(223 downto 208) <= a(208)&a(193)&a(178)&a(163)&a(148)&a(133)&a(118)&a(103)&a(88)&a(73)&a(58)&a(43)&a(28)&a(13)&a(510)&a(495);
     b(239 downto 224) <= a(224)&a(209)&a(194)&a(179)&a(164)&a(149)&a(134)&a(119)&a(104)&a(89)&a(74)&a(59)&a(44)&a(29)&a(14)&a(511);
     b(255 downto 240) <= a(240)&a(225)&a(210)&a(195)&a(180)&a(165)&a(150)&a(135)&a(120)&a(105)&a(90)&a(75)&a(60)&a(45)&a(30)&a(15);
     b(271 downto 256) <= a(256)&a(241)&a(226)&a(211)&a(196)&a(181)&a(166)&a(151)&a(136)&a(121)&a(106)&a(91)&a(76)&a(61)&a(46)&a(31);
     b(287 downto 272) <= a(272)&a(257)&a(242)&a(227)&a(212)&a(197)&a(182)&a(167)&a(152)&a(137)&a(122)&a(107)&a(92)&a(77)&a(62)&a(47);
     b(303 downto 288) <= a(288)&a(273)&a(258)&a(243)&a(228)&a(213)&a(198)&a(183)&a(168)&a(153)&a(138)&a(123)&a(108)&a(93)&a(78)&a(63);
     b(319 downto 304) <= a(304)&a(289)&a(274)&a(259)&a(244)&a(229)&a(214)&a(199)&a(184)&a(169)&a(154)&a(139)&a(124)&a(109)&a(94)&a(79);
     b(335 downto 320) <= a(320)&a(305)&a(290)&a(275)&a(260)&a(245)&a(230)&a(215)&a(200)&a(185)&a(170)&a(155)&a(140)&a(125)&a(110)&a(95);
     b(351 downto 336) <= a(336)&a(321)&a(306)&a(291)&a(276)&a(261)&a(246)&a(231)&a(216)&a(201)&a(186)&a(171)&a(156)&a(141)&a(126)&a(111);
     b(367 downto 352) <= a(352)&a(337)&a(322)&a(307)&a(292)&a(277)&a(262)&a(247)&a(232)&a(217)&a(202)&a(187)&a(172)&a(157)&a(142)&a(127);
     b(383 downto 368) <= a(368)&a(353)&a(338)&a(323)&a(308)&a(293)&a(278)&a(263)&a(248)&a(233)&a(218)&a(203)&a(188)&a(173)&a(158)&a(143);
     b(399 downto 384) <= a(384)&a(369)&a(354)&a(339)&a(324)&a(309)&a(294)&a(279)&a(264)&a(249)&a(234)&a(219)&a(204)&a(189)&a(174)&a(159);
     b(415 downto 400) <= a(400)&a(385)&a(370)&a(355)&a(340)&a(325)&a(310)&a(295)&a(280)&a(265)&a(250)&a(235)&a(220)&a(205)&a(190)&a(175);
     b(431 downto 416) <= a(416)&a(401)&a(386)&a(371)&a(356)&a(341)&a(326)&a(311)&a(296)&a(281)&a(266)&a(251)&a(236)&a(221)&a(206)&a(191);
     b(447 downto 432) <= a(432)&a(417)&a(402)&a(387)&a(372)&a(357)&a(342)&a(327)&a(312)&a(297)&a(282)&a(267)&a(252)&a(237)&a(222)&a(207);
     b(463 downto 448) <= a(448)&a(433)&a(418)&a(403)&a(388)&a(373)&a(358)&a(343)&a(328)&a(313)&a(298)&a(283)&a(268)&a(253)&a(238)&a(223);
     b(479 downto 464) <= a(464)&a(449)&a(434)&a(419)&a(404)&a(389)&a(374)&a(359)&a(344)&a(329)&a(314)&a(299)&a(284)&a(269)&a(254)&a(239);
     b(495 downto 480) <= a(480)&a(465)&a(450)&a(435)&a(420)&a(405)&a(390)&a(375)&a(360)&a(345)&a(330)&a(315)&a(300)&a(285)&a(270)&a(255);
     b(511 downto 496) <= a(496)&a(481)&a(466)&a(451)&a(436)&a(421)&a(406)&a(391)&a(376)&a(361)&a(346)&a(331)&a(316)&a(301)&a(286)&a(271);

End beh;
