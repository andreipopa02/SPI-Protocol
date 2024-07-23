
module freq_divider(
    input clk,                           //clock signal
    output reg sclk                      //divided clock signal
);
    reg [27:0] counter = 28'd0;          //counter register, initialize with 0
    parameter DIVISOR = 28'd100_000_000; // assuming a 100 MHz clock for a 1Hz output
    //parameter DIVISOR = 28'd2; 
    
    always @(posedge clk) begin           //at always change of clock signal
        counter <= counter + 28'd1;       //
        if (counter >= (DIVISOR - 1))
            counter <= 28'd0;
        sclk <= (counter < DIVISOR/2) ? 1'b1 : 1'b0;
    end
endmodule


// Counter Module
module counter(
    input enable,
    input clk,
    output reg [2:0] bit_cnt
);
    
    always @(posedge clk) begin
        if (enable) begin
            if (bit_cnt == 3'b111)
                bit_cnt <= 0;
            else
                bit_cnt <= bit_cnt + 1;
        end
    end
endmodule


// Shift Register Module
module shift_register(
    input clk,
    input enable_shift,
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


module fsm(
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
        data_out = 8'b0;
        
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
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end
endmodule










