`timescale 1ns / 1ps

// SPI Slave Module
module SPI_slave(
    input wire sclk,          // Serial Clock from master
    input wire mosi,          // Master Output Slave Input
    input wire cs,            // Chip Select from master
    output wire miso,         // Master Input Slave Output
    
    input wire [7:0] data_in,    // Data to be sent to masterz
    input wire load_data
);
    
    wire enable_cnt;
    wire enable_shift; 
    wire shift_in; 
  //  wire load_data;
    wire [2:0] bit_cnt;
    wire [7:0] shift_reg_in; 
    wire [7:0] shift_reg_out;
    
    fsm_slave fsm_slave_instance (
        .sclk(sclk), 
        .cs(cs), 
        .bit_cnt(bit_cnt), 
        .data_in(data_in),   // Data to be sent to master
        
        .enable_cnt(enable_cnt), 
        .enable_shift(enable_shift),
        .pl(load_data), 
        .data_out(shift_reg_in) // Received data to be sent back
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
        .data_out(shift_reg_out)
    );
    
    buffer tx_buff_instance (
        .data_in(shift_reg_out[7]), 
        .data_out(miso)
    );
   
endmodule