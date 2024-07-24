`timescale 1ns / 1ps

module SPI_Slave(
    input wire sclk,
    input wire mosi,
    input wire cs,
    output wire miso,
    
    input wire [7:0] data_in,
    input wire load_data,
    output wire [7:0] data_out
);

    wire enable_cnt;
    wire enable_shift;
    wire shift_in;
    wire [2:0] bit_cnt;
    wire [7:0] shift_reg_in;
    wire [7:0] shift_reg_out;

    fsm_slave fsm_slave_instance (
        .sclk(sclk),
        .cs(cs),
        .bit_cnt(bit_cnt),
        .data_in(data_in),
        .enable_cnt(enable_cnt),
        .enable_shift(enable_shift),
        .pl(load_data),
        .data_out(shift_reg_in)
    );

    counter cnt_instance (
        .enable(enable_cnt),
        .clk(sclk),
        .bit_cnt(bit_cnt)
    );

    buffer rx_buff_instance (
        .data_in(mosi),
        .data_out(shift_in)
    );

    shift_register_pl shift_reg_instance (
        .clk(sclk),
        .enable_shift(enable_shift),
        .shift_in(shift_in),
        .data_in(shift_reg_in),
        .pl(load_data),
        .data_out(shift_reg_out)
    );

    assign miso = shift_reg_out[7];
    assign data_out = shift_reg_out;

endmodule
