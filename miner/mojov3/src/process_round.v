/*
 * Copyright (c) 2013-2015 John Connor (BM-NC49AxAjcqVcF5jNPu85Rb8MJ2d9JqZt)
 *
 * This is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License with
 * additional permissions to the one published by the Free Software
 * Foundation, either version 3 of the License, or (at your option)
 * any later version. For more information see LICENSE.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

`timescale 1ns / 1ps

module process_round (
	input [511:0] block,
	input [511:0] key,
	output [511:0] block_out
);

	wire [63:0] b1,b2,b3,b4,b5,b6,b7,b8;
	wire [63:0] b1_out,b2_out,b3_out,b4_out,b5_out,b6_out,b7_out,b8_out;

	// Cyclical Permutations - Pi
	assign b1 = {block[504 +: 8],block[ 48 +: 8],block[104 +: 8],block[160 +: 8],block[216 +: 8],block[272 +: 8],block[328 +: 8],block[384 +: 8]};
	assign b2 = {block[440 +: 8],block[496 +: 8],block[ 40 +: 8],block[ 96 +: 8],block[152 +: 8],block[208 +: 8],block[264 +: 8],block[320 +: 8]};
	assign b3 = {block[376 +: 8],block[432 +: 8],block[488 +: 8],block[ 32 +: 8],block[ 88 +: 8],block[144 +: 8],block[200 +: 8],block[256 +: 8]};
	assign b4 = {block[312 +: 8],block[368 +: 8],block[424 +: 8],block[480 +: 8],block[ 24 +: 8],block[ 80 +: 8],block[136 +: 8],block[192 +: 8]};
	assign b5 = {block[248 +: 8],block[304 +: 8],block[360 +: 8],block[416 +: 8],block[472 +: 8],block[ 16 +: 8],block[ 72 +: 8],block[128 +: 8]};
	assign b6 = {block[184 +: 8],block[240 +: 8],block[296 +: 8],block[352 +: 8],block[408 +: 8],block[464 +: 8],block[  8 +: 8],block[ 64 +: 8]};
	assign b7 = {block[120 +: 8],block[176 +: 8],block[232 +: 8],block[288 +: 8],block[344 +: 8],block[400 +: 8],block[456 +: 8],block[  0 +: 8]};
	assign b8 = {block[ 56 +: 8],block[112 +: 8],block[168 +: 8],block[224 +: 8],block[280 +: 8],block[336 +: 8],block[392 +: 8],block[448 +: 8]};

	// Process Difussion Layer (SBOX) & Gamma One Row At A Time
	process_row row1 (b1, b1_out);
	process_row row2 (b2, b2_out);
	process_row row3 (b3, b3_out);
	process_row row4 (b4, b4_out);
	process_row row5 (b5, b5_out);
	process_row row6 (b6, b6_out);
	process_row row7 (b7, b7_out);
	process_row row8 (b8, b8_out);

	// Add Key To Block
	assign block_out = {b1_out,b2_out,b3_out,b4_out,b5_out,b6_out,b7_out,b8_out} ^ key;

endmodule
