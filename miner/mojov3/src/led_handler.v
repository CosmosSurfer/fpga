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

module led_handler(
    input clk,
	 output [7:0] led,
    input rst,
    input new_work,
	 input new_work_88,
	 input new_result,
	 input hashing
    );

	integer loops_d;
	integer is_working, has_new_work;

	/**
	 * Assign LED 0 to the reset button.
	 */
	assign led[0] = rst;
	
	/**
	 * Assign the remaining LED's to has_new_work and
	 * is_working.
	 */
	assign led[1] = has_new_work;
	assign led[2] = hashing;//is_working;
	assign led[3] = has_new_work;
	assign led[4] = hashing;//is_working;
	assign led[5] = has_new_work;
	assign led[6] = hashing;//is_working;
	assign led[7] = has_new_work;
	
initial
begin
	loops_d = 0;
	is_working = 0;
	has_new_work = 0;
end

always @(posedge clk) begin
    if (rst) begin
		loops_d <= 0;
		has_new_work <= 0;
		is_working <= 0;
	 end
	 
	if (new_result)
	begin
		has_new_work <= 1;
		is_working <= 1;
	end
	else
	begin
		if (loops_d == 100000000)
		begin
			loops_d <= 0;
			has_new_work <= 0;
			is_working <= 1;
		end
		else
		begin
			if (new_work || new_work_88)
				begin
					loops_d <= 0;
					has_new_work <= 1;
					is_working <= 0;
				end
			else
			begin
				if (has_new_work)
				begin
					loops_d <= loops_d + 1;
				end
			end
		end
	end

end

endmodule