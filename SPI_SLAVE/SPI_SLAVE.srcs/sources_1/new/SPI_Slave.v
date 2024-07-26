`timescale 1ns / 1ps


module SPI_Slave(
    input wire sclk,
    input wire mosi,
    input wire cs,
    output wire miso,
    
    output wire [7:0] slave_data_out 
);

    wire enable;
    wire done_flag;
    wire shift_in;
    wire sclk_div;
    
    //////////////////////////////////
    freq_divider divider_instance (
        .clk(sclk), 
        .select(3'b111),
        .sclk(sclk_div)
    );
    ////////////////////////////////
    // FSM: 
    // Controls the SPI transaction states and generates 
    // enable signal for the counter and shift register
    fsm_slave fsm_slave_instance (
        .sclk(sclk_div), 
        .cs(cs),    
        .done(done_flag), 
        
        .enable(enable)
    );
    
    // Counter: 
    // Counts the number of bits transmitted/received 
    // and generates done signal when complete
    counter cnt_instance (
        .clk(sclk_div), 
        .enable(enable),
        .done(done_flag)
    );
    
    // Receive buffer: 
    // Buffers the incoming data from the MISO line
    buffer rx_buff_instance (
        .data_in(mosi), 
        .data_out(shift_in)
    );
    
    // Shift register: 
    // Shifts in the received data and outputs 
    // the full byte once all bits are received
    shift_register shift_reg_instance (
        .clk(sclk_div), 
        .enable(enable), 
        .shift_in(shift_in), 
        .data_out(slave_data_out)
    );
    
    // Transmit buffer: 
    // Buffers the outgoing data from the 
    // shift register to the MOSI line
    buffer tx_buff_instance (
        .data_in(slave_data_out[7]), 
        .data_out(miso)
    );
                 
   
endmodule
