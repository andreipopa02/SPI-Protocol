`timescale 1ns / 1ps


// Counter Module
module counter(
    input clk,                                      // clock signal
    input enable,                                   // enabled the counting
    
    output reg done                                 // flag 
);
    reg [2:0] bit_cnt;
    
    always @(posedge clk) begin                     // at every positive edge of clock signal
        if (enable) begin                           // if enable is high
            if (bit_cnt == 3'b111) begin            // if counter reached the max value, 7
                done <= 1;
                bit_cnt <= 0;                       // reset to 0 
            end else begin 
                done <= 0;
                bit_cnt <= bit_cnt + 1;             // otherwise increments
            end
        end else begin
            done <= 0;
            bit_cnt <= 0;                           // reset bit counter if not enabled
        end
    end
endmodule



// Shift Register Module
module shift_register(
    input clk,                              
    input enable,                     
    input shift_in,
    
    output reg [7:0] data_out                       // output data after all bits are shifted in
);

    reg [7:0] shift_reg;                            // 8-bit shift register
    initial begin
        shift_reg = 8'b1010_1010;                   // initial data from master is 1010_1010 (AA hex)
    end
    
    always @(posedge clk) begin
        if (enable) begin
            shift_reg <= {shift_reg[6:0], shift_in};// shift in the new bit
        end   
        
    data_out <= shift_reg;                          // output the current register value
    end
endmodule


// Buffer Module
module buffer(
    input wire data_in,
    output wire data_out
);
    assign data_out = data_in;                      // simple pass-through buffer
endmodule





// FSM Slave Module
module fsm_slave(
    input wire sclk,                // Serial clock from master
    input wire cs,                  // Chip select from master
    input wire done,
    
    output reg enable
    
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
            state <= TRANSFER;
        else
            state <= next_state;
    end

    always @(*) begin
        case (state)
            
            IDLE: begin
                enable = 0;
                if (!cs)
                    next_state = START;             // move to START state if ready
                else
                    next_state = IDLE;              // remain in IDLE state
            end
            
            START: begin
                enable = 1;
                next_state = TRANSFER;              // move to TRANSFER state
            end
            
            TRANSFER: begin
                enable = 1;
                if (done) 
                    next_state = DONE;              // move to DONE state if done
                else
                    next_state = TRANSFER;          // remain in TRANSFER state
            end
            
            DONE: begin
                enable = 0;
                next_state = DONE;                  // remain in DONE state
            end
            
            default: next_state = IDLE;
            
        endcase
    end
endmodule



/*
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
*/

