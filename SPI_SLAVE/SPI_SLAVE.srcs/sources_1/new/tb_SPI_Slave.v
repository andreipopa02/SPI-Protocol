

`timescale 1ns / 1ps

module tb_SPI_Slave;
    reg sclk;
    wire miso;
    reg mosi;
    reg cs;
    
    wire [7:0] slave_data_out;


    SPI_Slave slave (
        .sclk(sclk),
        .miso(miso),
        .mosi(mosi),
        .cs(cs),
        
        .slave_data_out(slave_data_out)
    );
    
    initial begin
        #0  // Default values
            sclk = 1;
            cs = 0;
        
        #10 cs = 1;
        // Test no 1: -> 8'b0101_0101 (8'h3_3) received from MASTER 
        #80 mosi = 0;
        
        #20 mosi = 1;
        #20 mosi = 0;
        #20 mosi = 1;
        #20 mosi = 0;
        #20 mosi = 1;
        #20 mosi = 0;
        #20 mosi = 1;
            cs = 0;
      
      
        
        // Test no 2: -> 8'b0100_1111 (8'h4_F) received from MASTER 
        #80 mosi = 0;
        #40 mosi = 1;
        #40 mosi = 0;
        #40 mosi = 0;
        #40 mosi = 1;
        #40 mosi = 1;
        #40 mosi = 1;
        #40 mosi = 1;
       
       
        // Test no3 : -> 8'b0110_0111 (8'h6_7) received from MASTER 
        #160 mosi = 0;
        #80 mosi = 1;
        #80 mosi = 1;
        #80 mosi = 0;
        #80 mosi = 0;
        #80 mosi = 1;
        #80 mosi = 1;
        #80 mosi = 1;
       
        
        
    end
    
   always #10 sclk = ~sclk;
     
    initial begin
        #500 $finish;
    end
    

endmodule

