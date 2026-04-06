`timescale 1ns / 1ps

module tb_program_counter;

    // Inputs
    reg clk;
    reg rst;
    reg halt_en;

    // Outputs
    wire [7:0] pc_out;

    // Instantiate the Unit Under Test (UUT)
    program_counter uut (
        .clk(clk),
        .rst(rst),
        .halt_en(halt_en),
        .pc_out(pc_out)
    );

    // Clock generation: 10ns period (5ns high, 5ns low)
    always #5 clk = ~clk;

    initial begin
        // Monitor output to the console
        $monitor("Time=%0t | rst=%b | halt_en=%b | pc_out=%d", 
                 $time, rst, halt_en, pc_out);

        // Initialize Inputs
        clk = 0;
        rst = 1;        // Start in reset state
        halt_en = 0;

        // Hold reset for 20 ns
        #20;
        
        $display("\n--- Starting Normal Execution ---");
        rst = 0;
        
        // Let the counter run for 40 ns (4 clock cycles)
        // Expected PC: 0 -> 1 -> 2 -> 3 -> 4
        #40; 

        $display("\n--- Asserting HALT ---");
        halt_en = 1;
        
        // Hold halt for 30 ns (3 clock cycles)
        // Expected PC: Stays at 4
        #30; 

        $display("\n--- De-asserting HALT ---");
        halt_en = 0;
        
        // Let it run for 30 ns (3 clock cycles)
        // Expected PC: 4 -> 5 -> 6 -> 7
        #30; 

        $display("\n--- Testing Reset While Running ---");
        rst = 1;
        #15; // Hold reset
        rst = 0;
        
        // Let it count a bit from 0
        #20; 

        $display("\nSimulation Complete.");
        $finish;
    end

endmodule