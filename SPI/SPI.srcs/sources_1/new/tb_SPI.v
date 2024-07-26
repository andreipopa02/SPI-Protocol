/*
`timescale 1ns / 1ps

module tb_SPI;
    reg clk;
    reg reset;
    reg ready_state;
    reg [2:0] select;
    
    wire [7:0] master_data_out;
    wire [7:0] slave_data_out;


    SPI spi (
        .clk(clk),
        .reset(reset),
        .ready_state(ready_state),
        .select(select),
        
        .master_data_out(master_data_out),
        .slave_data_out(slave_data_out)
    );
    
    
    initial begin
        #0 // Default values
            clk = 0;
            reset = 0;
            ready_state = 0;
            select = 3'b000;    // divisor = 2
        
        // Reset the MASTER
        #10 reset = 1;
        #10 reset = 0;
        
        // Start SPI transaction
        #20 ready_state = 1;
        
        
        
       
       
    end
    
    always #5 clk = ~clk;
     
    initial begin
        #500 $finish;
    end
    
endmodule
*/