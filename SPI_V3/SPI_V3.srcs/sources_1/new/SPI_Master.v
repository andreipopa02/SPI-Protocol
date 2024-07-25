`timescale 1ns / 1ps

module SPI_Master(
    input wire clk,
    input wire reset,
    input wire ready_state,
    input wire [2:0] select,
    
    output wire sclk,
    input  wire miso,
    output wire mosi,
    output wire cs,
    
    input wire [7:0] data_in,
    input wire load_data,
    output wire [7:0] data_out
);
    wire enable_cnt, enable_shift;
    wire [2:0] bit_cnt;
    wire [7:0] shift_reg_in;
    wire shift_in;
    wire load_pl;
    
    assign load_pl = load_data;
    
    /*
    freq_divider_MUX divider_instance (
        .clk(clk), 
        .select(select),
        
        .sclk(sclk)
    );
    */
    
    freq_divider divider_instance (
        .clk(clk), 
        
        .sclk(sclk)
    );
    
    
    fsm_master fsm_master_instance (
        .clk(sclk), 
        .reset(reset), 
        .ready_state(ready_state), 
        .bit_cnt(bit_cnt), 

        .enable_cnt(enable_cnt), 
        .enable_shift(enable_shift), 
        .data_out(shift_reg_in)
    );
    
    counter cnt_instance (
        .enable(enable_cnt),
        .clk(sclk), 
        .reset(reset),
        .bit_cnt(bit_cnt)
    );
    
    buffer rx_buff_instance (
        .data_in(miso), 
        .data_out(shift_in)
    );
    
    shift_register_pl shift_reg_instance (
        .clk(sclk), 
        .enable_shift(enable_shift), 
        .shift_in(shift_in), 
        .pl(load_pl),
        .data_in(data_in),
        
        .data_out(data_out)
    );
    
    buffer tx_buff_instance (
        .data_in(data_out[7]), 
        .data_out(mosi)
    );
    
    assign cs = ~ready_state;  // Chip select active low
   
endmodule

