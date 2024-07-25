`timescale 1ns / 1ps

module freq_divider(
    input clk,                           //clock signal
    output reg sclk                      //divided clock signal
);
    reg [27:0] counter = 28'd0;          //counter register, initialize with 0
    parameter DIVISOR = 28'd100_000_000; // assuming a 100 MHz clock for a 1Hz output
    //parameter DIVISOR = 28'd2; 
    
    always @(posedge clk) begin           //at always change of clock signal
        counter <= counter + 28'd1;       //increments the counter
        if (counter >= (DIVISOR - 1))     //greater than constant value DIVISOR
            counter <= 28'd0;             //reset counter to 0
        sclk <= (counter < DIVISOR/2) ? 1'b1 : 1'b0; //set output signal
    end
endmodule


// Complex Divider Module
module freq_divider_MUX(
    input clk,                           // clock signal
    input [2:0] select,                  // 2-bit select divisor
    
    output reg sclk                      // divided clock signal
);
    reg [27:0] counter = 28'd0;          // counter register, initialize with 0
    reg [27:0] divisor;                  // register to hold the selected divisor

    always @(*) begin
        case (select)
            3'b000: divisor = 28'd2;               // select DIVISOR = 2
            3'b001: divisor = 28'd4;               // select DIVISOR = 4
            3'b010: divisor = 28'd8;               // select DIVISOR = 8
            3'b011: divisor = 28'd16;              // select DIVISOR = 16
            3'b100: divisor = 28'd64;              // select DIVISOR = 64
            3'b101: divisor = 28'd128;             // select DIVISOR = 128
            3'b110: divisor = 28'd256;             // select DIVISOR = 256
            3'b111: divisor = 28'd100_000_000;     // select DIVISOR = 100_000_000
            default: divisor = 28'd100_000_000;    // default case
        endcase
    end

    always @(posedge clk) begin           // at every positive edge of clock signal
        counter <= counter + 28'd1;       // increment the counter
        
        if (counter >= (divisor - 1)) begin     // if counter reaches the divisor value
            counter <= 28'd0;             // reset counter to 0
        end
        sclk <= (counter < divisor/2) ? 1'b1 : 1'b0; // set output signal
    end
endmodule

 
// Counter Module
module counter(
    input enable,                          //enabled the counting
    input clk,                             //clock signal
    input reset,
    output reg [2:0] bit_cnt               //3-bit register
);
    
    always @(posedge clk) begin            //at always change of clock signal
        if (enable) begin                  //if enable is high
          //  if (bit_cnt == 3'b111)         //checks if heas reached the max value, 7
          //      bit_cnt <= 0;              //reset to 0 
          //  else
                bit_cnt <= bit_cnt + 1;    //otherwise  increments
        end
        
        if(reset) begin
            bit_cnt <= 3'b000;
        end
    end
endmodule


// Shift Register Module
module shift_register(
    input clk,                              //clock signal
    input enable_shift,                     //
    input shift_in,
    output reg [7:0] data_out
);

    reg [7:0] shift_reg;
    initial begin
        shift_reg = 8'b0;
    end
    
    always @(posedge clk) begin
        if (enable_shift) 
            shift_reg <= {shift_reg[6:0], shift_in};
    data_out <= shift_reg;
    end
endmodule


// Buffer Module
module buffer(
    input wire data_in,
    output wire data_out
);
    assign data_out = data_in;
endmodule


module fsm_master(
    input clk,
    input reset,
    input ready_state,
    input [2:0] bit_cnt,       // Input from the counter
    
    output reg enable_cnt,
    output reg enable_shift,
    output reg [7:0] data_out
);
    // State definitions
    parameter IDLE = 2'b00, 
              START = 2'b01, 
              TRANSFER = 2'b10, 
              DONE = 2'b11;
              
    reg [1:0] state;
    reg [1:0] next_state;

    always @(posedge clk or posedge reset) begin
        if (reset) 
            state <= IDLE;
        else 
            state <= next_state;
    end

    always @(*) begin
        // Default values
        enable_cnt = 0;
        enable_shift = 0;
       // data_out = 8'b0;
        
        case (state)
            IDLE: begin
                enable_cnt = 0;
                enable_shift = 0;
                data_out = 8'b0;
                if (ready_state)
                    next_state = START;
                else
                    next_state = IDLE;
            end
            START: begin
                enable_cnt = 1;
                enable_shift = 1; 
                next_state = TRANSFER;
            end
            TRANSFER: begin
                enable_cnt = 1; 
                enable_shift = 1;
                if (bit_cnt == 3'b111) 
                    next_state = DONE;
                else
                    next_state = TRANSFER;
            end
            DONE: begin
                enable_cnt = 0;
                enable_shift = 0;
                next_state = DONE;
            end
            default: next_state = IDLE;
        endcase
    end
endmodule


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
        //data_out = 8'b0;

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
                next_state = DONE;
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
        if (enable_shift) begin
            if (pl) begin
                shift_reg <= data_in;          
            end else begin
                shift_reg <= {shift_reg[6:0], shift_in}; 
            end
        end
        
    data_out <= shift_reg;
    
    end
endmodule