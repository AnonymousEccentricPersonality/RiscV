`timescale 1ns / 1ps

module data_memory (
    input  wire       clk,         // Clock signal
    input  wire       mem_read,    // Read enable (LOAD)
    input  wire       mem_write,   // Write enable (STORE)
    input  wire [8:0] address,     // 9-bit address for 512 memory locations
    input  wire [7:0] write_data,  // 8-bit data to write
    output reg  [7:0] read_data    // 8-bit data read from memory
);

    // 512 x 8-bit memory array
    reg [7:0] memory [0:511];
    
    integer i;

    // Initialize memory and pre-load test data
    initial begin
        // Initialize all locations to 0 to prevent 'x' states in simulation
        for (i = 0; i < 512; i = i + 1) begin
            memory[i] = 8'd0;
        end
        
        // Pre-load specific addresses as requested
        memory[9'd10] = 8'd6;
        memory[9'd11] = 8'd4;
    end

    // Synchronous Read and Write operations
    always @(posedge clk) begin
        if (mem_write) begin
            memory[address] <= write_data;
        end
        
        if (mem_read) begin
            read_data <= memory[address];
        end
    end

endmodule