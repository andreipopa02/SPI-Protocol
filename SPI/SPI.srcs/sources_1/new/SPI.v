`timescale 1ns / 1ps


module SPI(
    input wire clk,
    input wire reset,
    input wire ready_state,
    input wire [2:0] select,
    
    output wire [7:0] master_data_out, 
    output wire [7:0] slave_data_out 
    );
    
    wire sclk;
    wire miso;
    wire mosi;
    wire cs;
    
    
    SPI_Master master (
        .clk(clk),
        .reset(reset),
        .ready_state(ready_state),
        .select(select),
        
        .sclk(sclk),
        .miso(miso),
        .mosi(mosi),
        .cs(cs),
        
        .master_data_out(master_data_out)
    );
    
    
    SPI_Slave slave (
        .sclk(sclk),
        .miso(miso),
        .mosi(mosi),
        .cs(cs),
        
        .slave_data_out(slave_data_out)
    );
    
    
    
endmodule
