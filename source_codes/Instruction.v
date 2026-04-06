`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.04.2026 10:29:18
// Design Name: 
// Module Name: Instruction
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module InstructionMemory #(
    parameter ADDR_WIDTH = 8,  // Example: 8-bit PC (256 instructions)
    parameter DATA_WIDTH = 16  // 16-bit instruction word as specified
)(
    input  wire [ADDR_WIDTH-1:0] pc,    // Program Counter
    output wire [DATA_WIDTH-1:0] instr  // Fetched Instruction
);

    // 1. Declare the memory array (ROM)
    // 2^ADDR_WIDTH elements, each DATA_WIDTH bits wide
    reg [DATA_WIDTH-1:0] rom_array [0:(1<<ADDR_WIDTH)-1];

    // 2. Initialize the memory at the start of simulation
    initial begin
        // Loads binary strings from a file into the array.
        // Use $readmemh if your file contains hexadecimal values instead.
        $readmemh("inst2.mem", rom_array); 
    end

    // 3. Asynchronous read: output the instruction at the PC address
    // Note: If your PC counts by bytes (pc=0, 2, 4...), you would need 
    // to shift it: assign instr = rom_array[pc >> 1];
    assign instr = rom_array[pc];

endmodule