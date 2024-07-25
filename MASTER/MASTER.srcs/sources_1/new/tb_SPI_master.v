

`timescale 1ns / 1ps

module tb_SPI_master;
    reg clk;
    reg reset;
    reg ready_state;
    reg [2:0] select;
    
    wire sclk;
    reg miso;
    wire mosi;
    wire cs;
    
    wire [7:0] master_data_out;


    SPI_master master (
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
        
        
        // Test no 1: -> 8'b0011_0011 (8'h3_3) received from SLAVE 
        #25 miso = 0;
        #20 miso = 0;
        #20 miso = 1;
        #20 miso = 1;
        #20 miso = 0;
        #20 miso = 0;
        #20 miso = 1;
        #20 miso = 1;
        
        // Re-initialize
        #20 ready_state = 0;
            reset = 1;
        #20 reset = 0; 
            select = 3'b001;        // divisor = 4  
            ready_state = 1;
       
        
        // Test no 2: -> 8'b0100_1111 (8'h4_F) received from SLAVE 
        #80 miso = 0;
        #40 miso = 1;
        #40 miso = 0;
        #40 miso = 0;
        #40 miso = 1;
        #40 miso = 1;
        #40 miso = 1;
        #40 miso = 1;
       
       // Re-initialize
        #20 ready_state = 0;
            reset = 1;
        #20 reset = 0; 
            select = 3'b010;        // divisor = 8  
            ready_state = 1;
        
       
        // Test no3 : -> 8'b0110_0111 (8'h6_7) received from SLAVE 
        #160 miso = 0;
        #80 miso = 1;
        #80 miso = 1;
        #80 miso = 0;
        #80 miso = 0;
        #80 miso = 1;
        #80 miso = 1;
        #80 miso = 1;
        
    end
    
    always #5 clk = ~clk;
     
    initial begin
        #1550 $finish;
    end
    

endmodule

