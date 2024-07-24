`timescale 1ns / 1ps

module SPI(
    input wire clk,
    input wire reset,
    input wire ready_state,
    input wire [2:0] select,
    
    input wire [7:0] slave_data_in,
    input wire load_data,   ///
    
    output wire [7:0] master_data_out, ///momentan il afisam pt debug
    output wire [2:0] bit_cnt /// ar trebui sa fie semnal intern, momentan il afisam pt debug
    );
    
    // Semnale pentru conexiunile interne
    wire sclk;
    wire mosi;
    wire cs;
    wire miso;
    
    // SPI-master
    SPI_master master(
        .clk(clk),
        .reset(reset),
        .ready_state(ready_state),
        .select(select),
        
        .sclk(sclk),
        .miso(miso),
        .mosi(mosi),
        .cs(cs),
        
        .data_out(master_data_out),
        .bit_cnt(bit_cnt)
    );
   
    // SPI-slave
    SPI_slave slave(
        .sclk(sclk),
        .mosi(mosi),
        .cs(cs),
        .miso(miso),
        
        .data_in(slave_data_in),
        .load_data(load_data)
    );
    
endmodule