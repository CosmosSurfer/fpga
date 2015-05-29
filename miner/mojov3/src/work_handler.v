
`timescale 1ns / 1ps

module work_handler(
    input clk,
    input rst,
	 input work_restart,
	 input new_work,
	 input new_work_92,
	 input [639:0] work_data,
	 input [511:0] work_midstate_64,
	 input [159:0] work_data_20,
	 input [31:0] work_target_d,
	 output reg got_work,
	 output reg new_result,
	 output reg [31:0] result_data
    );

integer loop_d;
integer nonce_d;
	
initial
begin
	got_work = 1'b0;
	new_result = 1'b0;
	loop_d = 0;
	nonce_d = 0;
end

always @(posedge clk)
begin

	if (rst)
	begin
		got_work <= 1'b0;
		new_result <= 1'b0;
		loop_d <= 0;
		nonce_d <= 0;
	end

	/**
	 * :TODO: This may need synchronisation, use a
	 * got_new_result perhaps.
	 */
	new_result <= 1'b0;
	 
	/**
	 * Restart using the existing work.
	 */
	if (work_restart)
	begin
		got_work <= 1'b0;
		new_result <= 1'b0;
		loop_d <= 0;
		nonce_d <= 0;
	end
	 
	if (new_work)
	begin
		
		/**
		 * Echo back the nonce portion of the work for
		 * testing serial roundtrip.
		 */
		nonce_d <= work_data[639:608];
		
		// :TODO: hash
		
		/**
		 * Set that we got the work.
		 */
		got_work <= 1'b1;
		
		/**
		 * Set the result.
		 */
		result_data <= nonce_d;
		
		loop_d <= 1;
	end
	else if (new_work_92)
	begin
	
		/**
		 * Echo back the nonce portion of the work for
		 * testing serial roundtrip.
		 */
		nonce_d <= work_data_20[159:128];
		
		// :TODO: hash
		
		/**
		 * Set that we got the work.
		 */
		got_work <= 1'b1;
		
		/**
		 * Set the result.
		 */
		result_data <= nonce_d;
		
		loop_d <= 1;
	end
	else
	begin
		got_work <= 1'b0;
	end
	
	/**
	 * Fake some work.
	 */
	if (loop_d > 1000000)
	begin
		loop_d <= 0;
		new_result <= 1'b1;
	end
	else if (loop_d > 0)
	begin
		loop_d <= loop_d + 1;
	end

end

endmodule
