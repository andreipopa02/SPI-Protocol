/*
`timescale 1ns / 1ps


module tb_spi_master;
    reg clk;
    reg reset;
    reg ready_state;
    reg [7:0] switch_data;
    wire [7:0] data_out;
    reg miso;
    wire sclk;
    wire mosi;
    wire cs;

    SPI_master uut (
        .clk(clk),
        .reset(reset),
        .ready_state(ready_state),
        .switch_data(switch_data),
        .data_out(data_out),
        .miso(miso),
        .sclk(sclk),
        .mosi(mosi),
        .cs(cs)
    );

    initial begin
        clk = 0;
        reset = 1;
        ready_state = 0;
       
        miso = 0;
        
        #100 reset = 0;
        #20 ready_state = 1;
        #20 switch_data = 8'h55;
    end

    always #5 clk = ~clk;

    initial begin
        $monitor("Time = %0t, sclk = %b, mosi = %b, cs = %b", $time, sclk, mosi, cs);
        #1000 $finish;
    end
endmodule

*/