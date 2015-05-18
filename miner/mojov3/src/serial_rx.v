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

module serial_rx #(
        parameter CLK_PER_BIT = 50
    )(
        input clk,
        input rst,
        input rx,
        output [7:0] data,
        output new_data
    );

    // clog2 is 'ceiling of log base 2' which gives you the number of bits needed to store a value
    parameter CTR_SIZE = $clog2(CLK_PER_BIT);

    localparam STATE_SIZE = 2;
    localparam IDLE = 2'd0,
    WAIT_HALF = 2'd1,
    WAIT_FULL = 2'd2,
    WAIT_HIGH = 2'd3;

    reg [CTR_SIZE-1:0] ctr_d, ctr_q;
    reg [2:0] bit_ctr_d, bit_ctr_q;
    reg [7:0] data_d, data_q;
    reg new_data_d, new_data_q;
    reg [STATE_SIZE-1:0] state_d, state_q = IDLE;
    reg rx_d, rx_q;

    assign new_data = new_data_q;
    assign data = data_q;

    always @(*) begin
        rx_d = rx;
        state_d = state_q;
        ctr_d = ctr_q;
        bit_ctr_d = bit_ctr_q;
        data_d = data_q;
        new_data_d = 1'b0;

        case (state_q)
            IDLE: begin
                bit_ctr_d = 3'b0;
                ctr_d = 1'b0;
                if (rx_q == 1'b0) begin
                    state_d = WAIT_HALF;
                end
            end
            WAIT_HALF: begin
                ctr_d = ctr_q + 1'b1;
                if (ctr_q == (CLK_PER_BIT >> 1)) begin
                    ctr_d = 1'b0;
                    state_d = WAIT_FULL;
                end
            end
            WAIT_FULL: begin
                ctr_d = ctr_q + 1'b1;
                if (ctr_q == CLK_PER_BIT - 1) begin
                    data_d = {rx_q, data_q[7:1]};
                    bit_ctr_d = bit_ctr_q + 1'b1;
                    ctr_d = 1'b0;
                    if (bit_ctr_q == 3'd7) begin
                        state_d = WAIT_HIGH;
                        new_data_d = 1'b1;
                    end
                end
            end
            WAIT_HIGH: begin
                if (rx_q == 1'b1) begin
                    state_d = IDLE;
                end
            end
            default: begin
                state_d = IDLE;
            end
        endcase

    end

    always @(posedge clk) begin
        if (rst) begin
            ctr_q <= 1'b0;
            bit_ctr_q <= 3'b0;
            new_data_q <= 1'b0;
            state_q <= IDLE;
        end else begin
            ctr_q <= ctr_d;
            bit_ctr_q <= bit_ctr_d;
            new_data_q <= new_data_d;
            state_q <= state_d;
        end

        rx_q <= rx_d;
        data_q <= data_d;
    end

endmodule