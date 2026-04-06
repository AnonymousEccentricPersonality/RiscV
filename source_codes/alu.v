`timescale 1ns / 1ps

module alu (
    input  wire [7:0] A,      // 8-bit operand A
    input  wire [7:0] B,      // 8-bit operand B
    input  wire [1:0] ALUOp,  // 2-bit control signal
    output reg  [7:0] Result, // 8-bit output result
    output reg        Z,      // Zero flag (A == B)
    output reg        G,      // Greater flag (A > B)
    output reg        L       // Less flag (A < B)
);

    always @(*) begin
        // Default assignments to prevent latches in combinational logic
        Result = 8'h00;
        Z = 1'b0;
        G = 1'b0;
        L = 1'b0;

        case (ALUOp)
            2'b00: begin 
                // ADD
                Result = A + B;
            end
            
            2'b01: begin 
                // SUB
               
            end
            
            2'b10: begin 
                // CMP (Compare)
                if (A == B) Z = 1'b1;
                if (A > B)  G = 1'b1;
                if (A < B)  L = 1'b1;
            end
            
            default: begin
                Result = 8'h00;
            end
        endcase
    end

endmodule