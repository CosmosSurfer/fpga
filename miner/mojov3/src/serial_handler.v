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

module serial_handler(
    input clk,
    input rst,
    output reg [7:0] tx_data,
    output reg new_tx_data,
    input tx_busy,
    input [7:0] rx_data,
    input new_rx_data,
	output reg new_work,
	output reg [639:0] work_data,
	input new_result,
    input [31:0] result_data
    );

   /**
	 * The states.
	 */
	localparam
		STATE_READ = 1,
		STATE_WRITE_BEGIN = 2,
		STATE_WRITE_CONTINUE = 3,
		STATE_SEND_ACK = 4,
		STATE_SEND_NACK = 5,
		STATE_SEND_INFO = 6,
		STATE_READ_VALUE = 7,
		STATE_RESTART = 8,
		STATE_SEND_RESULT_DATA_COPY = 9,
		STATE_SEND_ERROR = 254
	;
 
  /**
   * The message types.
	*/
  localparam
		MESSAGE_TYPE_NONE = 0,
		MESSAGE_TYPE_ACK = 2,
		MESSAGE_TYPE_NACK = 4,
		MESSAGE_TYPE_PING = 8,
		MESSAGE_TYPE_INFO = 18,
		MESSAGE_TYPE_NEW_WORK = 19,
		MESSAGE_TYPE_RESTART = 20,
		MESSAGE_TYPE_TEST_WORK = 21,
		MESSAGE_TYPE_RESULT = 32,
		MESSAGE_TYPE_ERROR = 254
  ;

  /**
   * The maximum number of bytes to receive in a single
	* message.
	*/
  localparam MAX_DATA_LENGTH = 254;

  /**
   * The receive data (buffer).
	*/
  reg[7:0] data_rx_d[0:MAX_DATA_LENGTH];
 
   /**
   * The transmit data (buffer).
	*/
  reg[7:0] data_tx_d[0:MAX_DATA_LENGTH];
  
  /**
   * The state (of the communications state machine).
	*/
  integer state_d;

  /**
   * The offset (in the read stream).
	*/
  integer offset_read_d;
  
   /**
   * The current read buffer length.
	*/
  integer length_read_d; 
  
  /**
   * The offset (in the write stream (not including
	* type and length)).
	*/
  integer offset_write_d;
  
  /**
   * The current write buffer length.
	*/
  integer length_write_d; 
  
  /**
   * The result data copy.
	*/
  reg [31:0] result_data_copy;
  
  /**
   * If true we need to send the copy
	* of the result data.
	*/
  reg [1:0] result_data_copy_send;
	 
  initial begin
	state_d = STATE_READ;
	offset_read_d = 0;
	length_read_d = 0;
	offset_write_d = 0;
	length_write_d = 0;
	new_work = 1'b0;
	result_data_copy_send = 1'b0;
  end
  
  always @(posedge clk) begin
  
    if (rst) begin
		state_d = STATE_READ;
		offset_read_d = 0;
		length_read_d = 0;
		offset_write_d = 0;
		length_write_d = 0;
	   new_work = 1'b0;
	   result_data_copy_send = 1'b0;
	 end
	 
	 /**
	  * If the work_manager has a new result make a copy of it
	  * to be sent later when serial is not busy.
	  */
	 if (new_result)
	 begin
		/**
		 * Copy the result_data into the result_data_copy
		 * for sending later.
		 */
		for (integer i = 0; i < 4 * 8; i = i + 1)
			result_data_copy[i] = result_data[i];

		/**
		 * Set that we need to send the copy of the result
		 * data.
		 */
		result_data_copy_send = 1'b1;
	 end
	 
	 if (
		result_data_copy_send && state_d == STATE_READ &&
		!tx_busy && !new_rx_data
		)
	 begin
		/**
		 * Set that we do not need to send the copy of the
		 * result data.
		 */
		result_data_copy_send = 1'b0;
		
		/**
		 * Send the result.
		 */
		state_d = STATE_SEND_RESULT_DATA_COPY;
	 end

	 /**
	  * Set that we do not have new work. This should
	  * be moved to a better location.
	  */
	 new_work = 1'b0;

    case (state_d)
      STATE_READ:
		begin
			if (new_rx_data)
			begin
			
				data_rx_d[offset_read_d] = rx_data;
				
				/**
				 * Check if we have read the length, otherwise
				 * keep reading.
				 */
				if (offset_read_d == 1)
				begin
					if (data_rx_d[0] == MESSAGE_TYPE_PING)
					begin
						state_d = STATE_SEND_ACK;
					end
					else if (data_rx_d[0] == MESSAGE_TYPE_INFO)
						state_d = STATE_SEND_INFO;
					else if (
						data_rx_d[0] == MESSAGE_TYPE_NEW_WORK ||
						data_rx_d[0] == MESSAGE_TYPE_TEST_WORK
						)
					begin
					
						/**
						 * Increment the read offset.
						 */
						offset_read_d = offset_read_d + 1;
						
						/**
						 * Read the value.
						 */
						state_d = STATE_READ_VALUE;
					end
					else if (data_rx_d[0] == MESSAGE_TYPE_RESTART)
					begin
						state_d = STATE_RESTART;
					end
					else
					begin
						state_d = STATE_SEND_ERROR;
					end
				end
				else
				begin
					offset_read_d = offset_read_d + 1;
				end
			end
      end
      STATE_SEND_ACK:
		begin
			data_tx_d[0]= MESSAGE_TYPE_ACK;
			data_tx_d[1] = 0;
			length_write_d = 2 + data_tx_d[1];
			offset_read_d = 0;
			state_d = STATE_WRITE_BEGIN;
      end
		STATE_SEND_NACK:
		begin
			data_tx_d[0] = MESSAGE_TYPE_NACK;
			data_tx_d[1] = 0;
			length_write_d = 2 + data_tx_d[1];
			offset_read_d = 0;
			state_d = STATE_WRITE_BEGIN;
      end
		STATE_SEND_INFO:
		begin
			data_tx_d[0] = MESSAGE_TYPE_INFO;
			data_tx_d[1] = 4;
			data_tx_d[2] = "M";
			data_tx_d[3] = "o";
			data_tx_d[4] = "V";
			data_tx_d[5] = "3";
			length_write_d = 2 + data_tx_d[1];
			offset_read_d = 0;
			state_d = STATE_WRITE_BEGIN;
		end
		STATE_RESTART:
		begin
			/**
			 * Set that we have new work.
			 */
			new_work = 1'b1;

		  /**
			* Send ACK.
			*/
			state_d = STATE_SEND_ACK;
		end
		STATE_SEND_RESULT_DATA_COPY:
		begin
			data_tx_d[0] = MESSAGE_TYPE_RESULT;
			data_tx_d[1] = 4;
			data_tx_d[2] = result_data_copy[7:0];
			data_tx_d[3] = result_data_copy[15:8];
			data_tx_d[4] = result_data_copy[23:16];
			data_tx_d[5] = result_data_copy[31:24];
			length_write_d = 2 + data_tx_d[1];
			offset_read_d = 0;
			state_d = STATE_WRITE_BEGIN;
		end
		STATE_SEND_ERROR:
		begin
			data_tx_d[0] = MESSAGE_TYPE_ERROR;
			data_tx_d[1] = 0;
			length_write_d = 2 + data_tx_d[1];
			offset_read_d = 0;
			state_d = STATE_WRITE_BEGIN;
      end
		STATE_READ_VALUE:
		begin
				/**
				 * Check if we are done reading the value.
				 */
				if (data_rx_d[1] == length_read_d)
				begin
					offset_read_d = 0;
					length_read_d = 0;
						
					/**
					 * Check if we got MESSAGE_TYPE_NEW_WORK.
					 */
					if (data_rx_d[0] == MESSAGE_TYPE_NEW_WORK)
					begin
						if (data_rx_d[1] == 0)
						begin
							/**
							 * No value, send ERROR.
							 */
							state_d = STATE_SEND_ERROR;
						end
						else if (data_rx_d[1] == 80)
						begin
								
							/**
							 * The work_handler will start to process the
							 * 80 bytes of work from a copy of data_rx_d.
							 */
							
							/**
							 * Set that we have new work.
							 */
							new_work = 1'b1;
							
						  /**
							* Send ACK.
							*/
							state_d = STATE_SEND_ACK;
						end
						else
						begin
							/**
							 * We got an unsupported work length, send error.
							 */
							state_d = STATE_SEND_ERROR;
						end
					end
					else if (data_rx_d[0] == MESSAGE_TYPE_TEST_WORK)
					begin
						if (data_rx_d[1] == 0)
						begin
							/**
							 * No value, send ERROR.
							 */
							state_d = STATE_SEND_ERROR;
						end
						else if (data_rx_d[1] == 80)
						begin
							if (
								data_rx_d[7] == 7 && data_rx_d[11] == 11 &&
								data_rx_d[13] == 13 && data_rx_d[17] == 17 &&
								data_rx_d[19] == 19 && data_rx_d[23] == 23 &&
								data_rx_d[29] == 29 && data_rx_d[31] == 31 &&
								data_rx_d[37] == 37 && data_rx_d[41] == 41 &&
								data_rx_d[43] == 43 && data_rx_d[47] == 47 &&
								data_rx_d[53] == 53 && data_rx_d[59] == 59 &&
								data_rx_d[61] == 61 && data_rx_d[67] == 67 &&
								data_rx_d[71] == 71 && data_rx_d[73] == 73 &&
								data_rx_d[79] == 79
							)
							begin
								/**
								 * The work_handler will start to process the
								 * 80 bytes of work from a copy of data_rx_d.
								 */
							 
								/**
								 * Set that we have new work.
								 */
								new_work = 1'b1;
							
							  /**
								* Send ACK.
								*/
								state_d = STATE_SEND_ACK;
							end
							else
							begin
								state_d = STATE_SEND_NACK;
							end
						end
						else
						begin
							/**
							 * We got an unsupported work length, send the
							 * length as the message type.
							 */
							state_d = STATE_SEND_ERROR;
						end
					end
					else
					begin
					/**
					 * Check if we got other message types.
					 */
					end
				end
				else if (new_rx_data)
					begin
						data_rx_d[offset_read_d] = rx_data;
						offset_read_d = offset_read_d + 1;
						length_read_d = length_read_d + 1;
				end
		end
		STATE_WRITE_BEGIN:
		begin
			if (!tx_busy)
			begin
				tx_data = data_tx_d[offset_write_d];
				new_tx_data = 1'b1;
				state_d = STATE_WRITE_CONTINUE;
				offset_write_d = offset_write_d + 1;
				length_write_d = length_write_d - 1;
			end
		end
		STATE_WRITE_CONTINUE:
		begin
			new_tx_data = 1'b0;
			
			if (length_write_d == 0)
			begin
				offset_write_d = 0;
				length_write_d = 0;
				state_d = STATE_READ;
			end
			else
			begin
				state_d = STATE_WRITE_BEGIN;
			end
		end
      default:
			state_d = STATE_READ;
    endcase
  end
  
endmodule
