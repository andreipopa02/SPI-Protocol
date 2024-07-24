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
    wire [7:0] data_out;
   // wire [2:0] bit_cnt;

    SPI_master master (
        .clk(clk),
        .reset(reset),
        .ready_state(ready_state),
        .select(select),
        .sclk(sclk),
        .miso(miso),
        .mosi(mosi),
        .cs(cs),
        .data_out(data_out)
       // .bit_cnt(bit_cnt)
    );
    
    initial begin
        clk = 0;
        reset = 0;
        ready_state = 0;
        select = 3'b000;
        miso = 0;
        
        // Reset the master
        #5 reset = 1;
        #10 reset = 0;
        
        
        
        // Start SPI transaction
        #20 ready_state = 1;
        
        
        // Simulate incoming data on MISO line
        #50 miso = 1;
        #10 miso = 1;
        #10 miso = 1;
        #10 miso = 1;
        #10 miso = 1;
        #10 miso = 1;
        #10 miso = 1;
        #10 miso = 1;
        #200 ready_state = 0;
        #200 ready_state = 1;
    end
    
    always #5 clk = ~clk;

    initial begin
        $monitor("Time = %0t, mosi = %b, miso = %b, cs = %b, data_out = %b",
                $time, mosi, miso, cs, data_out);
        #700 $finish;
    end
endmodule

