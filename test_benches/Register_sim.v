`timescale 1ns / 1ps

module tb_register_file;

    // Inputs
    reg clk;
    reg we;
    reg [2:0] read_reg1;
    reg [2:0] read_reg2;
    reg [2:0] write_reg;
    reg [7:0] write_data;

    // Outputs
    wire [7:0] read_data1;
    wire [7:0] read_data2;

    // Instantiate the Unit Under Test (UUT)
    Register_file uut (
        .clk(clk),
        .we(we),
        .read_reg1(read_reg1),
        .read_reg2(read_reg2),
        .write_reg(write_reg),
        .write_data(write_data),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    // Clock generation: 10ns period
    always #5 clk = ~clk;

    initial begin
        // Monitor outputs
        $monitor("Time=%0t | WE=%b | W_Reg=R%0d W_Data=%h | R_Reg1=R%0d R_Data1=%h | R_Reg2=R%0d R_Data2=%h", 
                 $time, we, write_reg, write_data, read_reg1, read_data1, read_reg2, read_data2);

        // Initialize Inputs
        clk = 0;
        we = 0;
        read_reg1 = 3'd0;
        read_reg2 = 3'd0;
        write_reg = 3'd0;
        write_data = 8'd0;

        #10;

        // --- Test 1: Write to R1 and R2 ---
        $display("\n--- Writing to R1 and R2 ---");
        we = 1;
        write_reg = 3'd1;     // Target R1
        write_data = 8'hAA;   // Write 0xAA
        #10;
        
        write_reg = 3'd2;     // Target R2
        write_data = 8'hBB;   // Write 0xBB
        #10;
        we = 0;

        // --- Test 2: Simultaneous Read ---
        $display("\n--- Reading R1 and R2 simultaneously ---");
        read_reg1 = 3'd1;     // Read R1
        read_reg2 = 3'd2;     // Read R2
        #10;

        // --- Test 3: Test R0 Hardwired to Zero ---
        $display("\n--- Attempting to write to R0 ---");
        we = 1;
        write_reg = 3'd0;     // Target R0
        write_data = 8'hFF;   // Attempt to write 0xFF
        #10;
        we = 0;

        // Read R0 back to verify it is still 0x00
        read_reg1 = 3'd0;
        #10;
        
        // --- Test 4: Read and Write same cycle ---
        $display("\n--- Write to R3 while reading R3 (Read-old-data behavior) ---");
        we = 1;
        write_reg = 3'd3;
        write_data = 8'hCC;
        read_reg1 = 3'd3;     // Should see old data (0x00) before clock edge
        #10;
        we = 0;               // Now should see new data (0xCC)
        #10;

        $display("\nSimulation Complete.");
        $finish;
    end

endmodule