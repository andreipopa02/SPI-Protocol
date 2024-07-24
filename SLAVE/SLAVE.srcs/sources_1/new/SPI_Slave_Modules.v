`timescale 1ns / 1ps


// Counter Module
module counter(
    input enable,                          //enabled the counting
    input clk,                             //clock signal
    output reg [2:0] bit_cnt               //3-bit register
);
    
    always @(posedge clk) begin            //at always change of clock signal
        if (enable) begin                  //if enable is high
            if (bit_cnt == 3'b111)         //checks if heas reached the max value, 7
                bit_cnt <= 0;              //reset to 0 
            else
                bit_cnt <= bit_cnt + 1;    //otherwise  increments
        end
    end
endmodule

// Buffer Module
module buffer(
    input wire data_in,
    output wire data_out
);
    assign data_out = data_in;
endmodule

// FSM Slave Module
module fsm_slave(
    input wire sclk,                // Serial clock from master
    input wire cs,                  // Chip select from master
    input wire [2:0] bit_cnt,       // Input from the counter
    input wire [7:0] data_in,
    
    output reg enable_cnt,
    output reg enable_shift,
    output reg pl,
    output reg [7:0] data_out
    
);
    // State definitions
    parameter IDLE = 2'b00, 
              START = 2'b01, 
              TRANSFER = 2'b10, 
              DONE = 2'b11;

    reg [1:0] state;
    reg [1:0] next_state;

    always @(posedge sclk or negedge cs) begin
        if (!cs)  // Chip select active low
            state <= START;
        else
            state <= next_state;
    end

    always @(*) begin
        // Default values
        enable_cnt = 0;
        enable_shift = 0;
        pl = 0;
        data_out = 8'b0;

        case (state)
        
            IDLE: begin
                enable_cnt = 0;
                enable_shift = 0;
                pl = 0;
                data_out = 8'b0;
                
                if (!cs)  // If chip select is active (low)
                    next_state = START;
                else
                    next_state = IDLE;
            end
            
            START: begin
                enable_cnt = 1;
                enable_shift = 1;
                pl = 1;
                data_out = data_in;  // Load data to be sent to master
                next_state = TRANSFER;
            end
            
            TRANSFER: begin
                enable_cnt = 1;
                enable_shift = 1;
                pl = 0;
                
                if (bit_cnt == 3'b111) 
                    next_state = DONE;
                else
                    next_state = TRANSFER;
            end
            
            DONE: begin
                enable_cnt = 0;
                enable_shift = 0;
                pl = 0;
                next_state = IDLE;
            end
            
            default: begin
                next_state = IDLE;
            end
            
        endcase
    end
endmodule


module shift_register_pl(
    input wire clk,                              //clock signal
    input wire enable_shift,                     //
    input wire shift_in,
    input wire pl,
    input wire [7:0] data_in,
    
    output reg [7:0] data_out
);

    reg [7:0] shift_reg;
    initial begin
        shift_reg = 8'b0;
    end
    
    always @(posedge clk) begin
        if(pl) begin
            shift_reg <= data_in;
        end 
        
        else if (enable_shift) begin
            shift_reg <= {shift_reg[6:0], shift_in};
        end
        
    data_out <= shift_reg;
    
    end
endmodule
