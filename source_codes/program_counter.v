`timescale 1ns / 1ps

module program_counter (
    input  wire       clk,      // Clock signal
    input  wire       rst,      // Asynchronous reset (active-high)
    input  wire       halt_en,  // Halt enable (freezes PC when high)
    output reg  [7:0] pc_out    // 8-bit Program Counter output
);

    // Sequential logic triggered on rising edge of clock or reset
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset to 0
            pc_out <= 8'd0;
        end else if (!halt_en) begin
            // Increment by 1 during normal execution
            pc_out <= pc_out + 1'b1;
        end
        // Implicit else: if (halt_en) pc_out <= pc_out; (freezes)
    end

endmodule