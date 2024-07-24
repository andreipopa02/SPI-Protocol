`timescale 1ns / 1ps

module tb_SPI_slave;
    reg clk;
    reg mosi;
    reg cs;
    wire miso;
    
    reg [7:0] data_in;
    reg load_data;
    wire [7:0] data_out;
  
    SPI_Slave slave (
        .sclk(clk),
        .mosi(mosi),
        .cs(cs),
        .miso(miso),
        .data_in(data_in),
        .load_data(load_data),
        .data_out(data_out)
    );
    
    initial begin
        clk = 0;
        cs = 1;
        load_data = 0;
        mosi = 0;
        data_in = 0;
        
        // Wait for some time before starting the simulation
        #10;
        
        // Load data and start SPI transaction
        load_data = 1;
        data_in = 8'h00;
        cs = 0;
        #10;
        load_data = 0;

        // Simulate MOSI data transmission
        #10 mosi = 1; // Transmit bit 7
        #10 mosi = 1; // Transmit bit 6
        #10 mosi = 1; // Transmit bit 5
        #10 mosi = 1; // Transmit bit 4
        #10 mosi = 1; // Transmit bit 3
        #10 mosi = 1; // Transmit bit 2
        #10 mosi = 1; // Transmit bit 1
        #10 mosi = 1; // Transmit bit 0

        #10 cs = 1; // Deactivate chip select
    end

    always #5 clk = ~clk;

    initial begin
        $monitor("Time = %0t , data_in = %b, data_out = %b, mosi = %b, miso = %b", $time, data_in, data_out, mosi, miso);
        #130 $finish;
    end
endmodule
