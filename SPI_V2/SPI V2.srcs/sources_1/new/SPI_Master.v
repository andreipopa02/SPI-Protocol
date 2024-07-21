`timescale 1ns / 1ps

module spi_state(
    input wire clk,
    input wire reset,
    input wire [7:0] data_in,
    output wire spi_cs_l, // spi active low chip select
    output wire spi_sclk,
    output wire spi_data, // MOSI line
    output [3:0] counter,
    output reg [7:0] complete_data  // Added output for complete data
);

    // Internal registers
    reg [7:0] MOSI;
    reg [3:0] count;
    reg cs_l; 
    reg sclk;
    reg [2:0] state;

    always @(posedge clk or posedge reset)
    if (reset) begin 
        MOSI <= 8'b0;
        count <= 4'd8;
        cs_l  <= 1'b1;
        sclk <= 1'b0;
        complete_data <= 8'b0;  // Reset complete data
    end else begin
        case (state)
            0: begin 
                sclk <= 1'b0;
                cs_l <= 1'b1;
                state <= 1;
            end

            1: begin
                sclk <= 1'b0;
                cs_l <= 1'b0;
                MOSI <= data_in[count-1];
                complete_data[count-1] <= data_in[count-1];  // Store the bit in complete_data
                count <= count - 1;
                state <= 2;
            end

            2: begin
                sclk <= 1'b1;
                if (count > 0)
                    state <= 1;
                else begin 
                    count <= 8;  // Reset counter for 8-bit data
                    state <= 0;
                end
            end

            default: state <= 0;
        endcase
    end

    assign spi_cs_l = cs_l;
    assign spi_sclk = sclk;
    assign spi_data = MOSI;  
    assign counter = count;

endmodule

module SPI_Master();
endmodule
