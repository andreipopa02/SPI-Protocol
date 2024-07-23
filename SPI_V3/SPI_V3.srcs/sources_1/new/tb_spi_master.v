/*
`timescale 1ns / 1ps

module tb_spi_master;
    reg clk;
    reg reset;
    reg ready_state;
    wire [7:0] data_out;
    reg miso;
    wire sclk;
    wire mosi;
    wire cs;
    wire bit_cnt;

    SPI_master master (
        .clk(clk),
        .reset(reset),
        .ready_state(ready_state),
        .data_out(data_out),
        .miso(miso),
        .sclk(sclk),
        .mosi(mosi),
        .cs(cs),
        .bit_cnt(bit_cnt)
    );

    initial begin
        clk = 0;
        reset = 1;
        ready_state = 0;
        
        miso = 1;
        
        #10 reset = 0; ready_state = 1;
        
        #10 miso = 0;
        #10 miso = 1;
        #10 miso = 0;
        #10 miso = 1;
        #10 miso = 0;
        #10 miso = 1;
        #10 miso = 0;
        
        
        #10 reset = 0; ready_state = 0;
        #10 reset = 1; ready_state = 1;

        #10 miso = 0;
        #10 miso = 1;
        #10 miso = 0;
        #10 miso = 1;
        #10 miso = 0;
        #10 miso = 1;
        #10 miso = 0;
        #10 miso = 1;
        
    end

    always #5 clk = ~clk;

    initial begin
       // $monitor("Time = %0t , data_out = %b, miso = %b, mosi = b%", $time, data_out, miso, mosi);
        #2000 $finish;
    end
endmodule
*/