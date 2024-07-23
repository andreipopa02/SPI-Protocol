/*
`timescale 1ns / 1ps

module tb_spi_master;
    reg clk;
    reg reset;
    reg ready_state;
    reg [2:0] select;
    
    reg [7:0] slave_data_in;
    
    wire [7:0] master_data_out;
    wire bit_cnt;

  
    SPI spi (
        .clk(clk),
        .reset(reset),
        .ready_state(ready_state),
        .select(select),
    
        .slave_data_in(slave_data_in),
    
        .master_data_out(master_data_out), 
        .bit_cnt(bit_cnt) 
    );
    
    initial begin
        clk = 0;
        reset = 1;
        ready_state = 0;
        
        #10 reset = 0; ready_state = 1;
        
        #50 slave_data_in = 8'hAA; 
        #10 reset = 1; ready_state = 0;
        
        #10 reset = 0; ready_state = 1;
        #50 slave_data_in = 8'h2B;
        
    end

    always #5 clk = ~clk;

    initial begin
       // $monitor("Time = %0t , data_out = %b, miso = %b, mosi = b%", $time, data_out, miso, mosi);
        #2000 $finish;
    end
endmodule
*/