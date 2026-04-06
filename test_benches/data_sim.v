`timescale 1ns / 1ps

module tb_data_memory;

    // Inputs
    reg clk;
    reg mem_read;
    reg mem_write;
    reg [8:0] address;
    reg [7:0] write_data;

    // Outputs
    wire [7:0] read_data;

    // Instantiate the Unit Under Test (UUT)
    data_memory uut (
        .clk(clk),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .address(address),
        .write_data(write_data),
        .read_data(read_data)
    );

    // Clock generation: 10ns period (5ns high, 5ns low)
    always #5 clk = ~clk;

    initial begin
        // Monitor key signals
        $monitor("Time=%0t | WE=%b RE=%b | Addr=%d | WData=%d | RData=%d", 
                 $time, mem_write, mem_read, address, write_data, read_data);

        // Initialize Inputs
        clk = 0;
        mem_read = 0;
        mem_write = 0;
        address = 9'd0;
        write_data = 8'd0;

        // Wait a bit before starting
        #10;

        // --- Test 1: Verify Pre-loaded Data ---
        $display("\n--- Testing Pre-loaded Data ---");
        mem_read = 1;
        address = 9'd10; 
        // Clock edge happens at 15ns, read_data updates shortly after
        #10; 
        
        address = 9'd11; 
        // Clock edge happens at 25ns
        #10; 
        mem_read = 0;

        // --- Test 2: Write New Data ---
        $display("\n--- Writing New Data to Memory ---");
        mem_write = 1;
        
        address = 9'd100;
        write_data = 8'd42;
        #10;
        
        address = 9'd255;
        write_data = 8'd99;
        #10;
        
        mem_write = 0;

        // --- Test 3: Read Back New Data ---
        $display("\n--- Reading Back New Data ---");
        mem_read = 1;
        
        address = 9'd100; 
        #10;
        
        address = 9'd255; 
        #10;
        
        mem_read = 0;

        // --- Test 4: Verify read_data holds value when RE=0 ---
        $display("\n--- Testing Disabled Controls ---");
        address = 9'd10; // Change address but keep mem_read = 0
        #10; // RData should still be 99 from the last successful read

        $display("\nSimulation Complete.");
        $finish;
    end

endmodule