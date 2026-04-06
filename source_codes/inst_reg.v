`timescale 1ns / 1ps

module instr_reg (
    input  wire        clk,       // Clock signal
    input  wire        rst,       // Asynchronous reset (active-high)
    input  wire        ir_write,  // Write enable control signal
    input  wire [15:0] ir_in,     // 16-bit instruction input
    output reg  [15:0] ir_out     // 16-bit instruction output
);

    // Update the register on the rising edge of the clock or async reset
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Clear the register on reset
            ir_out <= 16'd0;
        end else if (ir_write) begin
            // Latch the new instruction when write enable is high
            ir_out <= ir_in;
        end
        // If ir_write is low, ir_out implicitly holds its current value
    end

endmodule