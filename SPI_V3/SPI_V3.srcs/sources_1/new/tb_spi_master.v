/*
`t8imescale 1ns / 1ps



module tb_spi_master;
    reg clk;
    reg reset;
    reg ready_state;
    reg [2:0] select;
    
    wire [7:0] master_data_out;
    wire [7:0] slave_data_out;
    
    reg [7:0] master_data_in;
    reg [7:0] slave_data_in;
    
    reg load_data;

    SPI spi (
        .clk(clk),
        .reset(reset),
        .ready_state(ready_state),
        .select(select),
        
        .master_data_in(master_data_in),
        .slave_data_in(slave_data_in),
        
        .master_data_out(master_data_out),
        .slave_data_out(slave_data_out),
        
        .load_data(load_data)
    );

    initial begin
        //$dumpfile("spi_waveform.vcd");
        //$dumpvars(0, tb_spi_master);
        
        #0 
            clk = 0;
            reset = 0;
            ready_state = 0;
            select = 3'b000;
            slave_data_in = 8'h00;
            master_data_in = 8'h00;
            load_data = 0;
        
        // Reset the master and slave
        #5 
            reset = 1;
        #10 
            reset = 0;
        
        // Load data into master and slave
        #20 
            load_data = 1;
            slave_data_in = 8'h03;
            master_data_in = 8'h03;
            ready_state = 1;
        
        #50 
            load_data = 0;
            ready_state = 0;
        
        // Start SPI transaction
        
        
        #500 
            $finish;
    end
    
    always #5 clk = ~clk;
    
endmodule
*/