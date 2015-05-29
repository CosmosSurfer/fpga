
`timescale 1ns / 1ps

module serial_handler(
    input clk,
    input rst,
    output reg [7:0] tx_data,
    output reg new_tx_data,
    input tx_busy,
    input [7:0] rx_data,
    input new_rx_data,
	 output reg work_restart,
	 output reg new_work,
	 output reg new_work_92,
	 output reg [639:0] work_data,
	 output reg [511:0] work_midstate_64,
	 output reg [159:0] work_data_20,
	 output reg [31:0] work_target_d,
	 output reg [31:0] nonce_end_d,
	 input got_work,
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
		MESSAGE_TYPE_PING = 9,
		MESSAGE_TYPE_INFO = 21,
		MESSAGE_TYPE_NEW_WORK = 23,
		MESSAGE_TYPE_TEST_WORK = 25,
		MESSAGE_TYPE_RESTART = 27,
		MESSAGE_TYPE_RESULT = 48,
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
	work_restart = 1'b0;
	new_work = 1'b0;
	new_work_92 = 1'b0;
	result_data_copy_send = 1'b0;
  end
  
  always @(posedge clk) begin
  
    if (rst) begin
		state_d = STATE_READ;
		offset_read_d = 0;
		length_read_d = 0;
		offset_write_d = 0;
		length_write_d = 0;
		work_restart = 1'b0;
	   new_work = 1'b0;
		new_work_92 = 1'b0;
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
	 else
	 
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
	  * If the work was picked up then set that there
	  * is no new work.
	  */
	 if (got_work)
	 begin
		new_work = 1'b0;
		new_work_92 = 1'b0;
	 end
	 
	 work_restart = 1'b0;

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
			 * Set that we need to restart our work.
			 */
			work_restart = 1'b1;

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
							 * Copy 32-bits of the work.
							 */
							work_data[7:0] = data_rx_d[2 + 0];
							work_data[15:8] = data_rx_d[2 + 1];
							work_data[23:16] = data_rx_d[2 + 2];
							work_data[31:24] = data_rx_d[2 + 3];
							
							/**
							 * Copy 32-bits of the work.
							 */
							work_data[39:32] = data_rx_d[2 + 4];
							work_data[47:40] = data_rx_d[2 + 5];
							work_data[55:48] = data_rx_d[2 + 6];
							work_data[63:56] = data_rx_d[2 + 7];

							/**
							 * Copy 32-bits of the work.
							 */
							work_data[71:64] = data_rx_d[2 + 8];
							work_data[79:72] = data_rx_d[2 + 9];
							work_data[87:80] = data_rx_d[2 + 10];
							work_data[95:88] = data_rx_d[2 + 11];
							
							/**
							 * Copy 32-bits of the work.
							 */
							work_data[103:96] = data_rx_d[2 + 12];
							work_data[111:104] = data_rx_d[2 + 13];
							work_data[119:112] = data_rx_d[2 + 14];
							work_data[127:120] = data_rx_d[2 + 15];
							
							/**
							 * Copy 32-bits of the work.
							 */
							work_data[135:128] = data_rx_d[2 + 16];
							work_data[143:136] = data_rx_d[2 + 17];
							work_data[151:144] = data_rx_d[2 + 18];
							work_data[159:152] = data_rx_d[2 + 19];
							
							/**
							 * Copy 32-bits of the work.
							 */
							work_data[167:160] = data_rx_d[2 + 20];
							work_data[175:168] = data_rx_d[2 + 21];
							work_data[183:176] = data_rx_d[2 + 22];
							work_data[191:184] = data_rx_d[2 + 23];
							
							/**
							 * Copy 32-bits of the work.
							 */
							work_data[199:192] = data_rx_d[2 + 24];
							work_data[207:200] = data_rx_d[2 + 25];
							work_data[215:208] = data_rx_d[2 + 26];
							work_data[223:216] = data_rx_d[2 + 27];
							
							/**
							 * Copy 32-bits of the work.
							 */
							work_data[231:224] = data_rx_d[2 + 28];
							work_data[239:232] = data_rx_d[2 + 29];
							work_data[247:240] = data_rx_d[2 + 30];
							work_data[255:248] = data_rx_d[2 + 31];
							
							/**
							 * Copy 32-bits of the work.
							 */
							work_data[263:256] = data_rx_d[2 + 32];
							work_data[271:264] = data_rx_d[2 + 33];
							work_data[279:272] = data_rx_d[2 + 34];
							work_data[287:280] = data_rx_d[2 + 35];
							
							/**
							 * Copy 32-bits of the work.
							 */
							work_data[295:288] = data_rx_d[2 + 36];
							work_data[303:296] = data_rx_d[2 + 37];
							work_data[311:304] = data_rx_d[2 + 38];
							work_data[319:312] = data_rx_d[2 + 39];
							
							/**
							 * Copy 32-bits of the work.
							 */
							work_data[327:320] = data_rx_d[2 + 40];
							work_data[335:328] = data_rx_d[2 + 41];
							work_data[343:336] = data_rx_d[2 + 42];
							work_data[351:344] = data_rx_d[2 + 43];
							
							/**
							 * Copy 32-bits of the work.
							 */
							work_data[359:352] = data_rx_d[2 + 44];
							work_data[367:360] = data_rx_d[2 + 45];
							work_data[375:368] = data_rx_d[2 + 46];
							work_data[383:376] = data_rx_d[2 + 47];
							
							/**
							 * Copy 32-bits of the work.
							 */
							work_data[391:384] = data_rx_d[2 + 48];
							work_data[399:392] = data_rx_d[2 + 49];
							work_data[407:400] = data_rx_d[2 + 50];
							work_data[415:408] = data_rx_d[2 + 51];
							
							/**
							 * Copy 32-bits of the work.
							 */
							work_data[423:416] = data_rx_d[2 + 52];
							work_data[431:424] = data_rx_d[2 + 53];
							work_data[439:432] = data_rx_d[2 + 54];
							work_data[447:440] = data_rx_d[2 + 55];
							
							/**
							 * Copy 32-bits of the work.
							 */
							work_data[455:448] = data_rx_d[2 + 56];
							work_data[463:456] = data_rx_d[2 + 57];
							work_data[471:464] = data_rx_d[2 + 58];
							work_data[479:472] = data_rx_d[2 + 59];
							
							/**
							 * Copy 32-bits of the work.
							 */
							work_data[487:480] = data_rx_d[2 + 60];
							work_data[495:488] = data_rx_d[2 + 61];
							work_data[503:496] = data_rx_d[2 + 62];
							work_data[511:504] = data_rx_d[2 + 63];
							
							/**
							 * Copy 32-bits of the work.
							 */
							work_data[519:512] = data_rx_d[2 + 64];
							work_data[527:520] = data_rx_d[2 + 65];
							work_data[535:528] = data_rx_d[2 + 66];
							work_data[543:536] = data_rx_d[2 + 67];
							
							/**
							 * Copy 32-bits of the work.
							 */
							work_data[551:544] = data_rx_d[2 + 68];
							work_data[559:552] = data_rx_d[2 + 69];
							work_data[567:560] = data_rx_d[2 + 70];
							work_data[575:568] = data_rx_d[2 + 71];
							
							/**
							 * Copy 32-bits of the work.
							 */
							work_data[583:576] = data_rx_d[2 + 72];
							work_data[591:584] = data_rx_d[2 + 73];
							work_data[599:592] = data_rx_d[2 + 74];
							work_data[607:600] = data_rx_d[2 + 75];
							
							/**
							 * Copy 32-bits of the work.
							 */
							work_data[615:608] = data_rx_d[2 + 76];
							work_data[623:616] = data_rx_d[2 + 77];
							work_data[631:624] = data_rx_d[2 + 78];
							work_data[639:632] = data_rx_d[2 + 79];
							
							/**
							 * Set that we have new work.
							 */
							new_work = 1'b1;
							
						  /**
							* Send ACK.
							*/
							state_d = STATE_SEND_ACK;
						end
						else if (data_rx_d[1] == 92)
						begin

							/**
							 * The work_handler will start to process the
							 * 92 bytes of work from a copy of data_rx_d.
							 */

							/**
							 * Copy midstate to work_midstate_64.
							 */
							 
							/**
							 * Copy 32-bits of the work.
							 */
							work_midstate_64[7:0] = data_rx_d[2 + 0];
							work_midstate_64[15:8] = data_rx_d[2 + 1];
							work_midstate_64[23:16] = data_rx_d[2 + 2];
							work_midstate_64[31:24] = data_rx_d[2 + 3];
							
							/**
							 * Copy 32-bits of the work.
							 */
							work_midstate_64[39:32] = data_rx_d[2 + 4];
							work_midstate_64[47:40] = data_rx_d[2 + 5];
							work_midstate_64[55:48] = data_rx_d[2 + 6];
							work_midstate_64[63:56] = data_rx_d[2 + 7];

							/**
							 * Copy 32-bits of the work.
							 */
							work_midstate_64[71:64] = data_rx_d[2 + 8];
							work_midstate_64[79:72] = data_rx_d[2 + 9];
							work_midstate_64[87:80] = data_rx_d[2 + 10];
							work_midstate_64[95:88] = data_rx_d[2 + 11];
							
							/**
							 * Copy 32-bits of the work.
							 */
							work_midstate_64[103:96] = data_rx_d[2 + 12];
							work_midstate_64[111:104] = data_rx_d[2 + 13];
							work_midstate_64[119:112] = data_rx_d[2 + 14];
							work_midstate_64[127:120] = data_rx_d[2 + 15];
							
							/**
							 * Copy 32-bits of the work.
							 */
							work_midstate_64[135:128] = data_rx_d[2 + 16];
							work_midstate_64[143:136] = data_rx_d[2 + 17];
							work_midstate_64[151:144] = data_rx_d[2 + 18];
							work_midstate_64[159:152] = data_rx_d[2 + 19];
							
							/**
							 * Copy 32-bits of the work.
							 */
							work_midstate_64[167:160] = data_rx_d[2 + 20];
							work_midstate_64[175:168] = data_rx_d[2 + 21];
							work_midstate_64[183:176] = data_rx_d[2 + 22];
							work_midstate_64[191:184] = data_rx_d[2 + 23];
							
							/**
							 * Copy 32-bits of the work.
							 */
							work_midstate_64[199:192] = data_rx_d[2 + 24];
							work_midstate_64[207:200] = data_rx_d[2 + 25];
							work_midstate_64[215:208] = data_rx_d[2 + 26];
							work_midstate_64[223:216] = data_rx_d[2 + 27];
							
							/**
							 * Copy 32-bits of the work.
							 */
							work_midstate_64[231:224] = data_rx_d[2 + 28];
							work_midstate_64[239:232] = data_rx_d[2 + 29];
							work_midstate_64[247:240] = data_rx_d[2 + 30];
							work_midstate_64[255:248] = data_rx_d[2 + 31];
							
							/**
							 * Copy 32-bits of the work.
							 */
							work_midstate_64[263:256] = data_rx_d[2 + 32];
							work_midstate_64[271:264] = data_rx_d[2 + 33];
							work_midstate_64[279:272] = data_rx_d[2 + 34];
							work_midstate_64[287:280] = data_rx_d[2 + 35];
							
							/**
							 * Copy 32-bits of the work.
							 */
							work_midstate_64[295:288] = data_rx_d[2 + 36];
							work_midstate_64[303:296] = data_rx_d[2 + 37];
							work_midstate_64[311:304] = data_rx_d[2 + 38];
							work_midstate_64[319:312] = data_rx_d[2 + 39];
							
							/**
							 * Copy 32-bits of the work.
							 */
							work_midstate_64[327:320] = data_rx_d[2 + 40];
							work_midstate_64[335:328] = data_rx_d[2 + 41];
							work_midstate_64[343:336] = data_rx_d[2 + 42];
							work_midstate_64[351:344] = data_rx_d[2 + 43];
							
							/**
							 * Copy 32-bits of the work.
							 */
							work_midstate_64[359:352] = data_rx_d[2 + 44];
							work_midstate_64[367:360] = data_rx_d[2 + 45];
							work_midstate_64[375:368] = data_rx_d[2 + 46];
							work_midstate_64[383:376] = data_rx_d[2 + 47];
							
							/**
							 * Copy 32-bits of the work.
							 */
							work_midstate_64[391:384] = data_rx_d[2 + 48];
							work_midstate_64[399:392] = data_rx_d[2 + 49];
							work_midstate_64[407:400] = data_rx_d[2 + 50];
							work_midstate_64[415:408] = data_rx_d[2 + 51];
							
							/**
							 * Copy 32-bits of the work.
							 */
							work_midstate_64[423:416] = data_rx_d[2 + 52];
							work_midstate_64[431:424] = data_rx_d[2 + 53];
							work_midstate_64[439:432] = data_rx_d[2 + 54];
							work_midstate_64[447:440] = data_rx_d[2 + 55];
							
							/**
							 * Copy 32-bits of the work.
							 */
							work_midstate_64[455:448] = data_rx_d[2 + 56];
							work_midstate_64[463:456] = data_rx_d[2 + 57];
							work_midstate_64[471:464] = data_rx_d[2 + 58];
							work_midstate_64[479:472] = data_rx_d[2 + 59];
							
							/**
							 * Copy 32-bits of the work.
							 */
							work_midstate_64[487:480] = data_rx_d[2 + 60];
							work_midstate_64[495:488] = data_rx_d[2 + 61];
							work_midstate_64[503:496] = data_rx_d[2 + 62];
							work_midstate_64[511:504] = data_rx_d[2 + 63];

							/**
							 * Copy 20 bytes of work to work_data_20.
							 */
						 
							/**
							 * Copy 32-bits of the work.
							 */
							work_data_20[7:0] = data_rx_d[2 + 64];
							work_data_20[15:8] = data_rx_d[2 + 65];
							work_data_20[23:16] = data_rx_d[2 + 66];
							work_data_20[31:24] = data_rx_d[2 + 67];
							
							/**
							 * Copy 32-bits of the work.
							 */
							work_data_20[39:32] = data_rx_d[2 + 68];
							work_data_20[47:40] = data_rx_d[2 + 69];
							work_data_20[55:48] = data_rx_d[2 + 70];
							work_data_20[63:56] = data_rx_d[2 + 71];

							/**
							 * Copy 32-bits of the work.
							 */
							work_data_20[71:64] = data_rx_d[2 + 72];
							work_data_20[79:72] = data_rx_d[2 + 73];
							work_data_20[87:80] = data_rx_d[2 + 74];
							work_data_20[95:88] = data_rx_d[2 + 75];
							
							/**
							 * Copy 32-bits of the work.
							 */
							work_data_20[103:96] = data_rx_d[2 + 76];
							work_data_20[111:104] = data_rx_d[2 + 77];
							work_data_20[119:112] = data_rx_d[2 + 78];
							work_data_20[127:120] = data_rx_d[2 + 79];
							
							/**
							 * Copy 32-bits of the work.
							 */
							work_data_20[135:128] = data_rx_d[2 + 80];
							work_data_20[143:136] = data_rx_d[2 + 81];
							work_data_20[151:144] = data_rx_d[2 + 82];
							work_data_20[159:152] = data_rx_d[2 + 83];
							
							/**
							 * Copy 32-bit target to work_target_d.
							 */
							work_target_d[7:0] = data_rx_d[2 + 84];
							work_target_d[15:8] = data_rx_d[2 + 85];
							work_target_d[23:16] = data_rx_d[2 + 86];
							work_target_d[31:24] = data_rx_d[2 + 87];
							
							/**
							 * Copy 32-bit target to nonce_end_d.
							 */
							nonce_end_d[7:0] = data_rx_d[2 + 91];
							nonce_end_d[15:8] = data_rx_d[2 + 95];
							nonce_end_d[23:16] = data_rx_d[2 + 99];
							nonce_end_d[31:24] = data_rx_d[2 + 103];
							
							/**
							 * Set that we have new work (92 bytes).
							 */
							new_work_92 = 1'b1;
						
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
							/**
							 * Check for prime numbers in prime indexes.
							 */
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
								 * Copy 32-bits of the work.
								 */
								work_data[7:0] = data_rx_d[2 + 0];
								work_data[15:8] = data_rx_d[2 + 1];
								work_data[23:16] = data_rx_d[2 + 2];
								work_data[31:24] = data_rx_d[2 + 3];
								
								/**
								 * Copy 32-bits of the work.
								 */
								work_data[39:32] = data_rx_d[2 + 4];
								work_data[47:40] = data_rx_d[2 + 5];
								work_data[55:48] = data_rx_d[2 + 6];
								work_data[63:56] = data_rx_d[2 + 7];

								/**
								 * Copy 32-bits of the work.
								 */
								work_data[71:64] = data_rx_d[2 + 8];
								work_data[79:72] = data_rx_d[2 + 9];
								work_data[87:80] = data_rx_d[2 + 10];
								work_data[95:88] = data_rx_d[2 + 11];
								
								/**
								 * Copy 32-bits of the work.
								 */
								work_data[103:96] = data_rx_d[2 + 12];
								work_data[111:104] = data_rx_d[2 + 13];
								work_data[119:112] = data_rx_d[2 + 14];
								work_data[127:120] = data_rx_d[2 + 15];
								
								/**
								 * Copy 32-bits of the work.
								 */
								work_data[135:128] = data_rx_d[2 + 16];
								work_data[143:136] = data_rx_d[2 + 17];
								work_data[151:144] = data_rx_d[2 + 18];
								work_data[159:152] = data_rx_d[2 + 19];
								
								/**
								 * Copy 32-bits of the work.
								 */
								work_data[167:160] = data_rx_d[2 + 20];
								work_data[175:168] = data_rx_d[2 + 21];
								work_data[183:176] = data_rx_d[2 + 22];
								work_data[191:184] = data_rx_d[2 + 23];
								
								/**
								 * Copy 32-bits of the work.
								 */
								work_data[199:192] = data_rx_d[2 + 24];
								work_data[207:200] = data_rx_d[2 + 25];
								work_data[215:208] = data_rx_d[2 + 26];
								work_data[223:216] = data_rx_d[2 + 27];
								
								/**
								 * Copy 32-bits of the work.
								 */
								work_data[231:224] = data_rx_d[2 + 28];
								work_data[239:232] = data_rx_d[2 + 29];
								work_data[247:240] = data_rx_d[2 + 30];
								work_data[255:248] = data_rx_d[2 + 31];
								
								/**
								 * Copy 32-bits of the work.
								 */
								work_data[263:256] = data_rx_d[2 + 32];
								work_data[271:264] = data_rx_d[2 + 33];
								work_data[279:272] = data_rx_d[2 + 34];
								work_data[287:280] = data_rx_d[2 + 35];
								
								/**
								 * Copy 32-bits of the work.
								 */
								work_data[295:288] = data_rx_d[2 + 36];
								work_data[303:296] = data_rx_d[2 + 37];
								work_data[311:304] = data_rx_d[2 + 38];
								work_data[319:312] = data_rx_d[2 + 39];
								
								/**
								 * Copy 32-bits of the work.
								 */
								work_data[327:320] = data_rx_d[2 + 40];
								work_data[335:328] = data_rx_d[2 + 41];
								work_data[343:336] = data_rx_d[2 + 42];
								work_data[351:344] = data_rx_d[2 + 43];
								
								/**
								 * Copy 32-bits of the work.
								 */
								work_data[359:352] = data_rx_d[2 + 44];
								work_data[367:360] = data_rx_d[2 + 45];
								work_data[375:368] = data_rx_d[2 + 46];
								work_data[383:376] = data_rx_d[2 + 47];
								
								/**
								 * Copy 32-bits of the work.
								 */
								work_data[391:384] = data_rx_d[2 + 48];
								work_data[399:392] = data_rx_d[2 + 49];
								work_data[407:400] = data_rx_d[2 + 50];
								work_data[415:408] = data_rx_d[2 + 51];
								
								/**
								 * Copy 32-bits of the work.
								 */
								work_data[423:416] = data_rx_d[2 + 52];
								work_data[431:424] = data_rx_d[2 + 53];
								work_data[439:432] = data_rx_d[2 + 54];
								work_data[447:440] = data_rx_d[2 + 55];
								
								/**
								 * Copy 32-bits of the work.
								 */
								work_data[455:448] = data_rx_d[2 + 56];
								work_data[463:456] = data_rx_d[2 + 57];
								work_data[471:464] = data_rx_d[2 + 58];
								work_data[479:472] = data_rx_d[2 + 59];
								
								/**
								 * Copy 32-bits of the work.
								 */
								work_data[487:480] = data_rx_d[2 + 60];
								work_data[495:488] = data_rx_d[2 + 61];
								work_data[503:496] = data_rx_d[2 + 62];
								work_data[511:504] = data_rx_d[2 + 63];
								
								/**
								 * Copy 32-bits of the work.
								 */
								work_data[519:512] = data_rx_d[2 + 64];
								work_data[527:520] = data_rx_d[2 + 65];
								work_data[535:528] = data_rx_d[2 + 66];
								work_data[543:536] = data_rx_d[2 + 67];
								
								/**
								 * Copy 32-bits of the work.
								 */
								work_data[551:544] = data_rx_d[2 + 68];
								work_data[559:552] = data_rx_d[2 + 69];
								work_data[567:560] = data_rx_d[2 + 70];
								work_data[575:568] = data_rx_d[2 + 71];
								
								/**
								 * Copy 32-bits of the work.
								 */
								work_data[583:576] = data_rx_d[2 + 72];
								work_data[591:584] = data_rx_d[2 + 73];
								work_data[599:592] = data_rx_d[2 + 74];
								work_data[607:600] = data_rx_d[2 + 75];
								
								/**
								 * Copy 32-bits of the work.
								 */
								work_data[615:608] = data_rx_d[2 + 76];
								work_data[623:616] = data_rx_d[2 + 77];
								work_data[631:624] = data_rx_d[2 + 78];
								work_data[639:632] = data_rx_d[2 + 79];
								
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
						else if (data_rx_d[1] == 92)
						begin
						
							/**
							 * The work_handler will start to process the
							 * 92 bytes of work from a copy of data_rx_d.
							 */
							 
							/**
							 * Check the 20 bytes of work.
							 */
							if (
								data_rx_d[2 + 64] == 207 && data_rx_d[2 + 65] == 203 &&
								data_rx_d[2 + 66] == 255 && data_rx_d[2 + 67] == 204 &&
								data_rx_d[2 + 68] == 230 && data_rx_d[2 + 69] == 220 &&
								data_rx_d[2 + 70] == 34 && data_rx_d[2 + 71] == 253 &&
								data_rx_d[2 + 72] == 84 && data_rx_d[2 + 73] == 152 &&
								data_rx_d[2 + 74] == 246 && data_rx_d[2 + 75] == 208 &&
								data_rx_d[2 + 76] == 30 && data_rx_d[2 + 77] == 15 &&
								data_rx_d[2 + 78] == 255 && data_rx_d[2 + 79] == 255 &&
								data_rx_d[2 + 80] == 84 && data_rx_d[2 + 81] == 152 &&
								data_rx_d[2 + 82] == 207 && data_rx_d[2 + 83] == 192
							)
							begin
								/**
								 * Copy midstate to work_midstate_64.
								 */
								 
								/**
								 * Copy 32-bits of the work.
								 */
								work_midstate_64[7:0] = data_rx_d[2 + 0];
								work_midstate_64[15:8] = data_rx_d[2 + 1];
								work_midstate_64[23:16] = data_rx_d[2 + 2];
								work_midstate_64[31:24] = data_rx_d[2 + 3];
								
								/**
								 * Copy 32-bits of the work.
								 */
								work_midstate_64[39:32] = data_rx_d[2 + 4];
								work_midstate_64[47:40] = data_rx_d[2 + 5];
								work_midstate_64[55:48] = data_rx_d[2 + 6];
								work_midstate_64[63:56] = data_rx_d[2 + 7];

								/**
								 * Copy 32-bits of the work.
								 */
								work_midstate_64[71:64] = data_rx_d[2 + 8];
								work_midstate_64[79:72] = data_rx_d[2 + 9];
								work_midstate_64[87:80] = data_rx_d[2 + 10];
								work_midstate_64[95:88] = data_rx_d[2 + 11];
								
								/**
								 * Copy 32-bits of the work.
								 */
								work_midstate_64[103:96] = data_rx_d[2 + 12];
								work_midstate_64[111:104] = data_rx_d[2 + 13];
								work_midstate_64[119:112] = data_rx_d[2 + 14];
								work_midstate_64[127:120] = data_rx_d[2 + 15];
								
								/**
								 * Copy 32-bits of the work.
								 */
								work_midstate_64[135:128] = data_rx_d[2 + 16];
								work_midstate_64[143:136] = data_rx_d[2 + 17];
								work_midstate_64[151:144] = data_rx_d[2 + 18];
								work_midstate_64[159:152] = data_rx_d[2 + 19];
								
								/**
								 * Copy 32-bits of the work.
								 */
								work_midstate_64[167:160] = data_rx_d[2 + 20];
								work_midstate_64[175:168] = data_rx_d[2 + 21];
								work_midstate_64[183:176] = data_rx_d[2 + 22];
								work_midstate_64[191:184] = data_rx_d[2 + 23];
								
								/**
								 * Copy 32-bits of the work.
								 */
								work_midstate_64[199:192] = data_rx_d[2 + 24];
								work_midstate_64[207:200] = data_rx_d[2 + 25];
								work_midstate_64[215:208] = data_rx_d[2 + 26];
								work_midstate_64[223:216] = data_rx_d[2 + 27];
								
								/**
								 * Copy 32-bits of the work.
								 */
								work_midstate_64[231:224] = data_rx_d[2 + 28];
								work_midstate_64[239:232] = data_rx_d[2 + 29];
								work_midstate_64[247:240] = data_rx_d[2 + 30];
								work_midstate_64[255:248] = data_rx_d[2 + 31];
								
								/**
								 * Copy 32-bits of the work.
								 */
								work_midstate_64[263:256] = data_rx_d[2 + 32];
								work_midstate_64[271:264] = data_rx_d[2 + 33];
								work_midstate_64[279:272] = data_rx_d[2 + 34];
								work_midstate_64[287:280] = data_rx_d[2 + 35];
								
								/**
								 * Copy 32-bits of the work.
								 */
								work_midstate_64[295:288] = data_rx_d[2 + 36];
								work_midstate_64[303:296] = data_rx_d[2 + 37];
								work_midstate_64[311:304] = data_rx_d[2 + 38];
								work_midstate_64[319:312] = data_rx_d[2 + 39];
								
								/**
								 * Copy 32-bits of the work.
								 */
								work_midstate_64[327:320] = data_rx_d[2 + 40];
								work_midstate_64[335:328] = data_rx_d[2 + 41];
								work_midstate_64[343:336] = data_rx_d[2 + 42];
								work_midstate_64[351:344] = data_rx_d[2 + 43];
								
								/**
								 * Copy 32-bits of the work.
								 */
								work_midstate_64[359:352] = data_rx_d[2 + 44];
								work_midstate_64[367:360] = data_rx_d[2 + 45];
								work_midstate_64[375:368] = data_rx_d[2 + 46];
								work_midstate_64[383:376] = data_rx_d[2 + 47];
								
								/**
								 * Copy 32-bits of the work.
								 */
								work_midstate_64[391:384] = data_rx_d[2 + 48];
								work_midstate_64[399:392] = data_rx_d[2 + 49];
								work_midstate_64[407:400] = data_rx_d[2 + 50];
								work_midstate_64[415:408] = data_rx_d[2 + 51];
								
								/**
								 * Copy 32-bits of the work.
								 */
								work_midstate_64[423:416] = data_rx_d[2 + 52];
								work_midstate_64[431:424] = data_rx_d[2 + 53];
								work_midstate_64[439:432] = data_rx_d[2 + 54];
								work_midstate_64[447:440] = data_rx_d[2 + 55];
								
								/**
								 * Copy 32-bits of the work.
								 */
								work_midstate_64[455:448] = data_rx_d[2 + 56];
								work_midstate_64[463:456] = data_rx_d[2 + 57];
								work_midstate_64[471:464] = data_rx_d[2 + 58];
								work_midstate_64[479:472] = data_rx_d[2 + 59];
								
								/**
								 * Copy 32-bits of the work.
								 */
								work_midstate_64[487:480] = data_rx_d[2 + 60];
								work_midstate_64[495:488] = data_rx_d[2 + 61];
								work_midstate_64[503:496] = data_rx_d[2 + 62];
								work_midstate_64[511:504] = data_rx_d[2 + 63];
								
								/**
								 * Copy 20 bytes of work to work_data_20.
								 */
							 
								/**
								 * Copy 32-bits of the work.
								 */
								work_data_20[7:0] = data_rx_d[2 + 64];
								work_data_20[15:8] = data_rx_d[2 + 65];
								work_data_20[23:16] = data_rx_d[2 + 66];
								work_data_20[31:24] = data_rx_d[2 + 67];
								
								/**
								 * Copy 32-bits of the work.
								 */
								work_data_20[39:32] = data_rx_d[2 + 68];
								work_data_20[47:40] = data_rx_d[2 + 69];
								work_data_20[55:48] = data_rx_d[2 + 70];
								work_data_20[63:56] = data_rx_d[2 + 71];

								/**
								 * Copy 32-bits of the work.
								 */
								work_data_20[71:64] = data_rx_d[2 + 72];
								work_data_20[79:72] = data_rx_d[2 + 73];
								work_data_20[87:80] = data_rx_d[2 + 74];
								work_data_20[95:88] = data_rx_d[2 + 75];
								
								/**
								 * Copy 32-bits of the work.
								 */
								work_data_20[103:96] = data_rx_d[2 + 76];
								work_data_20[111:104] = data_rx_d[2 + 77];
								work_data_20[119:112] = data_rx_d[2 + 78];
								work_data_20[127:120] = data_rx_d[2 + 79];
								
								/**
								 * Copy 32-bits of the work.
								 */
								work_data_20[135:128] = data_rx_d[2 + 80];
								work_data_20[143:136] = data_rx_d[2 + 81];
								work_data_20[151:144] = data_rx_d[2 + 82];
								work_data_20[159:152] = data_rx_d[2 + 83];
								
								/**
								 * Copy 32-bit target to work_target_d.
								 */
								work_target_d[7:0] = data_rx_d[2 + 84];
								work_target_d[15:8] = data_rx_d[2 + 85];
								work_target_d[23:16] = data_rx_d[2 + 86];
								work_target_d[31:24] = data_rx_d[2 + 87];
								
								/**
								 * Copy 32-bit target to nonce_end_d.
								 */
								nonce_end_d[7:0] = data_rx_d[2 + 91];
								nonce_end_d[15:8] = data_rx_d[2 + 95];
								nonce_end_d[23:16] = data_rx_d[2 + 99];
								nonce_end_d[31:24] = data_rx_d[2 + 103];
								
								/**
								 * Set that we have new work (92 bytes).
								 */
								new_work_92 = 1'b1;
							
							  /**
								* Send ACK.
								*/
								state_d = STATE_SEND_ACK;
							end
							else
							begin
							  /**
								* Send NACK.
								*/
								state_d = STATE_SEND_NACK;
							end
						end
						else
						begin
							/**
							 * We got an unsupported work length, send
							 * error.
							 */
							state_d = STATE_SEND_ERROR;
						end
					end
					else
					begin
					/**
					 * :TODO: Check if we got other message types.
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
