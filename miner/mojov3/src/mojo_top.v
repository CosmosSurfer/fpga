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

module mojo_top(
    // 50MHz clock input
    input clk,
    // Input from reset button (active low)
    input rst_n,
    // cclk input from AVR, high when AVR is ready
    input cclk,
    // Outputs to the 8 onboard LEDs
    output [7:0]led,
    // AVR SPI connections
    output spi_miso,
    input spi_ss,
    input spi_mosi,
    input spi_sck,
    // AVR ADC channel select
    output [3:0] spi_channel,
    // Serial connections
    input avr_tx, // AVR Tx => FPGA Rx
    output avr_rx, // AVR Rx => FPGA Tx
    input avr_rx_busy // AVR Rx buffer full
    );

	/**
	 * Make reset active high.
	 */
	wire rst = ~rst_n;
	
	wire [7:0] leds = led;
	
	wire [7:0] tx_data;
	wire new_tx_data;
	wire tx_busy;
	wire [7:0] rx_data;
	wire new_rx_data;

	// Wires Used For Miner Work / Results
	wire new_work;						// Indicates When New Work Has Been Received
	wire [511:0] midstate;			// Stores The Midstate For The Current Work Item
	wire [95:0] block_header;		// Stores The Remaining Block Header Data For The Current Work Item
	wire [31:0] nonce_start;		// Nonce To Use When Hashing First Begins
	wire [31:0] nonce_end;			// Continue Hashing Until This Nonce Is Reached
	wire [31:0] target;				// A Valid Nonce Is Found When The Resulting Hash Is Less Than The Target
	wire new_result;					// Indicates When A Valid Nonce Has Been Found Or Hashing Is Complete
	wire [31:0] result_data;		// Stores The Nonce That Was Found
	wire hashing;						// Indicates The FPGA Is Hashing

	avr_interface avr_interface(
	 .clk(clk),
	 .rst(rst),
	 .cclk(cclk),
	 .spi_miso(spi_miso),
	 .spi_mosi(spi_mosi),
	 .spi_sck(spi_sck),
	 .spi_ss(spi_ss),
	 .spi_channel(spi_channel),
	 .tx(avr_rx),
	 .rx(avr_tx),
	 .channel(4'd15),
	 .new_sample(),
	 .sample(),
	 .sample_channel(),
	 .tx_data(tx_data),
	 .new_tx_data(new_tx_data),
	 .tx_busy(tx_busy),
	 .tx_block(avr_rx_busy),
	 .rx_data(rx_data),
	 .new_rx_data(new_rx_data)
	);
	/*
	// Define Serial Interface Settings
	parameter CLK_RATE = 50000000;
	parameter SERIAL_BAUD_RATE = 115200;
	parameter CLK_PER_BIT = $rtoi($ceil(CLK_RATE/SERIAL_BAUD_RATE));

	// Instantiate The Object For Serial Data Receive (Rx)
	serial_rx #(.CLK_PER_BIT(CLK_PER_BIT)) serial_rx (
		.clk(clk),
//		.rst(1'b0),
		.rx(avr_tx),
		.data(rx_data),
		.new_data(new_rx_data)
	);

	// Instantiate The Object For Serial Data Transmit (Tx)
	serial_tx #(.CLK_PER_BIT(CLK_PER_BIT)) serial_tx (
		.clk(clk),
//		.rst(1'b0),
		.tx(avr_rx),
		.busy(tx_busy),
		.data(tx_data),
		.new_data(new_tx_data)
	);
	*/
 
	serial_handler serial_handler(
	 .clk(clk),
	 //.rst(rst),
		.tx_data(tx_data),
		.new_tx_data(new_tx_data),
		.tx_busy(tx_busy),
		.rx_data(rx_data),
		.new_rx_data(new_rx_data),
		.new_work(new_work),
		.midstate(midstate),
		.block_header(block_header),
		.nonce_start(nonce_start),
		.nonce_end(nonce_end),
		.target(target),
		.new_result(new_result),
		.result_data(result_data)
	);
	
	led_handler led_handler(
	 .clk(clk),
	 .led(led),
	 .rst(rst),
	 .new_work(new_work),
	 .new_work_88(new_work),
	 .new_result(new_result),
	 .hashing(hashing)
	);
	
	work_handler work_handler(
		.clk(clk),
		//.rst(rst),
		.new_work(new_work),
		.midstate(midstate),
		.header(block_header),
		.nonce_start(nonce_start),
		.nonce_end(nonce_end),
		.target(target),
		.hashing(hashing),
		.new_result(new_result),
		.result_data(result_data)
	);

endmodule