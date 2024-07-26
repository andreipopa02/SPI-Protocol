
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
    
    output wire [7:0] master_data_out 
);
    wire enable;
    wire done_flag;
    wire shift_in;
    
    // Frequency divider: 
    // Divides the input clock based on the select value to generate sclk
    freq_divider divider_instance (
        .clk(clk), 
        .select(select),
        .sclk(sclk)
    );
    
    // FSM: 
    // Controls the SPI transaction states and generates 
    // enable signal for the counter and shift register
    fsm_master fsm_master_instance (
        .clk(sclk),     
        .reset(reset), 
        .ready_state(ready_state), 
        .done(done_flag), 
        .enable(enable)
    );
    
    // Counter: 
    // Counts the number of bits transmitted/received 
    // and generates done signal when complete
    counter cnt_instance (
        .clk(sclk), 
        .enable(enable),
        .done(done_flag)
    );
    
    // Receive buffer: 
    // Buffers the incoming data from the MISO line
    buffer rx_buff_instance (
        .data_in(miso), 
        .data_out(shift_in)
    );
    
    // Shift register: 
    // Shifts in the received data and outputs 
    // the full byte once all bits are received
    shift_register shift_reg_instance (
        .clk(sclk), 
        .enable(enable), 
        .shift_in(shift_in), 
        .data_out(master_data_out)
    );
    
    // Transmit buffer: 
    // Buffers the outgoing data from the 
    // shift register to the MOSI line
    buffer tx_buff_instance (
        .data_in(master_data_out[7]), 
        .data_out(mosi)
    );
    
    // Chip select: 
    // Active low signal to enable the SPI device
    assign cs = ~ready_state;               
   
endmodule
