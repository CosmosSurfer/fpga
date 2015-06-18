
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