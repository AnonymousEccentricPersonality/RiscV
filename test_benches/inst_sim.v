`timescale 1ns / 1ps

module tb_InstructionMemory;

    // Parameters (matching the UUT)
    parameter ADDR_WIDTH = 8;
    parameter DATA_WIDTH = 16;

    // Inputs
    reg [ADDR_WIDTH-1:0] pc;

    // Outputs
    wire [DATA_WIDTH-1:0] instr;

    // Instantiate the Unit Under Test (UUT)
    InstructionMemory #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) uut (
        .pc(pc),
        .instr(instr)
    );

    initial begin
        // Monitor changes to pc and instr
        // Outputting in both decimal/binary and hex for easy reading
        $monitor("Time=%0t | PC=%d | Instruction (Bin)=%b | Instruction (Hex)=%h", 
                 $time, pc, instr, instr);

        // Initialize PC
        pc = 8'd0;
        
        // Wait 10ns between each address fetch
        #10; 

        // Read sequential addresses corresponding to the .mem file
        pc = 8'd1; #10;
        pc = 8'd2; #10;
        pc = 8'd3; #10;
        pc = 8'd4; #10;
        
        // Read an uninitialized address (will output xxxx if not in .mem file)
        $display("\n--- Reading an uninitialized address ---");
        pc = 8'd10; #10;
        
        // Test boundary condition (maximum address for 8-bit PC)
        $display("\n--- Reading maximum address limit ---");
        pc = 8'd255; #10;

        $display("\nSimulation Complete.");
        $finish;
    end

endmodule