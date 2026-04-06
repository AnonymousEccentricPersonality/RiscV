`timescale 1ns / 1ps

module Register_file (
    input  wire       clk,        // Clock signal
    input  wire       we,
    input wire re,         // Write Enable
    input  wire [2:0] read_reg1,  // 3-bit address for source register 1
    input  wire [2:0] read_reg2,  // 3-bit address for source register 2
    input  wire [2:0] write_reg,  // 3-bit address for destination register
    input  wire [7:0] write_data, // 8-bit data to write
    output wire [7:0] read_data1, // 8-bit data from source register 1
    output wire [7:0] read_data2,  // 8-bit data from source register 2
    input wire [2:0]reg_no,
    output  reg [7:0] reg_val
);

    // 8 x 8-bit register array (R0-R7)
    reg [7:0] registers [0:7];
    
    integer i;
    always @(*) begin
        reg_val=registers[reg_no];
    end
    // Initialize all registers to 0 (useful for simulation)
    initial begin
        for (i = 0; i < 8; i = i + 1) begin
            registers[i] = 8'd0;
        end
    end

    // Synchronous Write
    always @(posedge clk) begin
        if (we) begin
            // Enforce R0 hardwired to zero: only write if destination is not R0
            if (write_reg != 3'b000) begin
                registers[write_reg] <= write_data;
            end
        end
    end

    // Simultaneous Combinational Read
    // If reading R0, explicitly output 0. Otherwise, output register contents.
   assign read_data1 = (re && read_reg1 != 3'b000) ? registers[read_reg1] : 8'd0;
    assign read_data2 = (re && read_reg2 != 3'b000) ? registers[read_reg2] : 8'd0;
endmodule