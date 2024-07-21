`timescale 1ns / 1ps

module tb_spi_state;
    // Inputs
    reg clk;
    reg reset; 
    reg [7:0] data_in;  // Updated to 8 bits

    // Outputs
    wire spi_cs_l;
    wire spi_sclk;
    wire spi_data;
    wire [3:0] counter;  // Updated to 4 bits
    wire [7:0] complete_data;  // Added complete data output

    // Instantiate the Unit Under Test (UUT)
    spi_state state (
        .clk(clk),
        .reset(reset),
        .data_in(data_in),
        .spi_cs_l(spi_cs_l),
        .spi_sclk(spi_sclk),
        .spi_data(spi_data),
        .counter(counter),
        .complete_data(complete_data)  // Connect complete data
    );
   
    // Initial block to set initial values
    initial begin 
        clk = 0;
        reset = 1;
        data_in = 0;
    end
   
    // Generate clock signal
    always #5 clk = ~clk;
   
    // Stimulus block to provide input signals
    initial begin 
        #10 reset = 1'b0;
        #10 data_in = 8'hA5;  // 8-bit data example
        #180 data_in = 8'h25;
        #180 data_in = 8'h9B;
        #180 data_in = 8'h6A;
        #180 data_in = 8'hA2;
        #180 data_in = 8'h75;
        #180 ;
    end

    // Monitor complete data output
    initial begin
        $monitor("Time = %0d, complete_data = %h", $time, complete_data);
    end
endmodule
