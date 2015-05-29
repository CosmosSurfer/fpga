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

	/**
	 * If set we need to restart work.
	 */
	wire work_restart;
	
	/**
	 * If set we have new work.
	 */
   wire new_work;
	
	/**
	 * If set we have new (92 byte) work.
	 */
	wire new_work_92;
	
	/**
	 * The (80 byte) work (if new_work is set).
	 */
	wire [639:0] work_data;
	
	/**
	 * Thw work midstate (64 byte).
	 */
	wire [511:0] work_midstate_64;
	
	/**
	 * The work data (20 byte).
	 */
	wire [159:0] work_data_20;
	
	/**
	 * The (4 byte) work target.
	 */
	wire [31:0] work_target_d;
	
		/**
	 * The (4 byte) nonce end.
	 */
	wire [31:0] nonce_end_d;
	
	/**
	 * If true we got the work from the work_data.
	 */
	wire got_work;
	
	/**
	 * If set we have a new result.
	 */
	wire new_result;
	
	/**
	 * The (4 byte) result (if new_result is set).
	 */
	wire [31:0] result_data;

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
 
	serial_handler serial_handler(
	 .clk(clk),
	 .rst(rst),
	 .tx_data(tx_data),
	 .new_tx_data(new_tx_data),
	 .tx_busy(tx_busy),
	 .rx_data(rx_data),
	 .new_rx_data(new_rx_data),
	 .work_restart(work_restart),
	 .new_work(new_work),
	 .new_work_92(new_work_92),
	 .work_data(work_data),
	 .work_midstate_64(work_midstate_64),
	 .work_data_20(work_data_20),
	 .work_target_d(work_target_d),
	 .nonce_end_d(nonce_end_d),
	 .got_work(got_work),
	 .new_result(new_result),
	 .result_data(result_data)
	);
	
	led_handler led_handler(
	 .clk(clk),
	 .led(led),
	 .rst(rst),
	 .new_work(new_work),
	 .new_work_92(new_work_92),
	 .new_result(new_result)
	);
	
	work_handler work_handler(
		.clk(clk),
		.rst(rst),
		.work_restart(work_restart),
		.new_work(new_work),
		.new_work_92(new_work_92),
		.work_data(work_data),
	   .work_midstate_64(work_midstate_64),
	   .work_data_20(work_data_20),
	   .work_target_d(work_target_d),
		.got_work(got_work),
		.new_result(new_result),
		.result_data(result_data)
	);

	wire [159:0] block;
	wire [511:0] state;
	wire [31:0] hash;
	
	whirlpool whirlpool(
		.clk(clk),
		.state(state),
		.hash(hash)
	);

endmodule