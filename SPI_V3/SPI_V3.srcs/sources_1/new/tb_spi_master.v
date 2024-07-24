
`timescale 1ns / 1ps

module tb_spi_master;
    reg clk;
    reg reset;
    reg ready_state;
    reg [2:0] select;
    
    reg [7:0] slave_data_in;
    reg load_data;
    
    wire [7:0] master_data_out;
    wire bit_cnt;

  
    SPI spi (
        .clk(clk),
        .reset(reset),
        .ready_state(ready_state),
        .select(select),
    
        .slave_data_in(slave_data_in),
        .load_data(load_data),
        
        .master_data_out(master_data_out), 
        .bit_cnt(bit_cnt) 
    );
    
    initial begin
        clk = 0;
        reset = 1;
        ready_state = 0;
        load_data = 0;
        select = 7;
        
        #10 reset = 0; ready_state = 1; load_data = 1;
        
        #50 slave_data_in = 8'hAA; 
        #10 reset = 1; ready_state = 0;
        
        #10 reset = 0; ready_state = 1;
        #50 slave_data_in = 8'h2B;
        
    end

    always #5 clk = ~clk;

    initial begin
        $monitor("Time = %0t , slave_data_in = %b, master_data_out = %b, bit_cnt = b%", $time, slave_data_in, master_data_out, bit_cnt);
        #2000 $finish;
    end
endmodule
