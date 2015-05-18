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

module work_handler(
    input clk,
    input rst,
	 input new_work,
	 input [639:0] work_data,
	 output reg new_result,
	 output reg [31:0] result_data
    );

integer nonce_d;

initial
begin
	new_result = 1'b0;
	nonce_d = 0;
end

always @(posedge clk)
begin

	if (rst)
	begin
		new_result <= 1'b0;
		loop_d <= 0;
	end

	new_result <= 1'b0;
		
	if (new_work)
	begin
		result_data <= nonce_d;
	end

end

endmodule
