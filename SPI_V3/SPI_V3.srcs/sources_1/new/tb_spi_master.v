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

    SPI_master master (
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
        
        miso = 1;
        
        #10 reset = 0; ready_state = 1;
        #10 switch_data = 8'h55;
        
        #10 miso = 0;
        #10 miso = 1;
        #10 miso = 0;
        #10 miso = 1;
        #10 miso = 0;
        #10 miso = 1;
        #10 miso = 0;
        
        
        #10 reset = 0; ready_state = 0;
        #10 reset = 1; ready_state = 1;
        #10 switch_data = 8'hA3;
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
        $monitor("Time = %0t, switch_data = %b, data_out = %b, miso = %b, mosi = b%", $time, switch_data, data_out, miso, mosi);
        #2000 $finish;
    end
endmodule
*/