
`timescale 1ns / 1ps

module SPI(
    input wire clk,
    input wire reset,
    input wire ready_state,
    input wire [2:0] select,
    
    output wire [7:0] master_data_out,
    output wire [7:0] slave_data_out,
    
    input wire [7:0] master_data_in,
    input wire [7:0] slave_data_in,
    
    input wire load_data
    
    );
    
    // Semnale pentru conexiunile interne
    wire sclk;
    wire mosi;
    wire cs;
    wire miso;
    
    // SPI-slave
    SPI_Slave slave (
        .sclk(sclk),
        .mosi(mosi),
        .cs(cs),
        .miso(miso),
        
        .data_in(slave_data_in),
        .load_data(load_data),
        .data_out(slave_data_out)
    );
    
    
    // SPI-master
    SPI_Master master (
        .clk(clk),
        .reset(reset),
        .ready_state(ready_state),
        .select(select),
        
        .sclk(sclk),
        .miso(miso),
        .mosi(mosi),
        .cs(cs),
        
        .data_in(master_data_in),
        .load_data(load_data),
        .data_out(master_data_out)
    );
   
    
    
    
endmodule
