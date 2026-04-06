`timescale 1ns / 1ps

module tb_CPU;

    // Top-level Inputs
    reg clk_0;
    reg rst_0;
    reg [2:0] reg_no_0; // Register select input

    // Top-level Outputs
    wire G_0;
    wire L_0;
    wire Z_0;
    wire [7:0] reg_val_0; // Register value output

    // Tracking variable to detect PC changes
    reg [7:0] current_pc;

    // Instantiate the Top-Level CPU Wrapper
    CPU_wrapper uut (
        .clk_0(clk_0),
        .rst_0(rst_0),
        .G_0(G_0),
        .L_0(L_0),
        .Z_0(Z_0),
        .reg_no_0(reg_no_0),
        .reg_val_0(reg_val_0)
    );

    // Clock Generation: 10ns period (100 MHz)
    always #5 clk_0 = ~clk_0;

    // ---------------------------------------------------------
    // TASK: Dump all 8 registers to the console on one line
    // ---------------------------------------------------------
    task dump_registers;
        input [7:0] pc_val;
        integer j;
        begin
            $display("\n[Time=%0t] --- Registers updated (New PC = %0d) ---", $time, pc_val);
            for (j = 0; j < 8; j = j + 1) begin
                reg_no_0 = j; 
                #1; // Wait 1ns for combinational read logic to settle
                // Use $write to print on the same line
                $write("R%0d:%0d  ", reg_no_0, reg_val_0); 
            end
            $display(""); // Print a newline at the end of the row
            
            // Return address to 0 to prevent floating/unintended behavior
            reg_no_0 = 3'b000; 
        end
    endtask

    initial begin
        // Monitor the overall system state
        $monitor("Time=%0t | PC=%d | FSM State=%d | Z=%b G=%b L=%b", 
                 $time, 
                 uut.CPU_i.program_counter_0.pc_out,   
                 uut.CPU_i.controller_0.inst.ps,       
                 Z_0, G_0, L_0);

        // Initialize Inputs
        clk_0 = 0;
        reg_no_0 = 3'b000; 
        
        // Assert Reset 
        rst_0 = 1;
        #20; 
        
        // De-assert Reset and start execution
        $display("\n--- CPU Out of Reset, Beginning Execution ---");
        rst_0 = 0;
        
        // Capture the initial PC value
        current_pc = uut.CPU_i.program_counter_0.pc_out;

        // ---------------------------------------------------------
        // NEW: Cycle-by-cycle execution loop
        // ---------------------------------------------------------
        // Loop until we hit the HALT state (9) or timeout
        while (uut.CPU_i.controller_0.inst.ps != 4'd9 && $time < 2000) begin
            
            // Wait for the next positive clock edge
            @(posedge clk_0);
            
            // Wait 1ns after the clock edge to allow PC and FSM state 
            // to update from their non-blocking (<=) assignments
            #1; 

            // If the PC has changed, the previous instruction has finished
            if (uut.CPU_i.program_counter_0.pc_out != current_pc) begin
                
                // Call the task to print the registers
                dump_registers(uut.CPU_i.program_counter_0.pc_out);
                
                // Update our tracking variable
                current_pc = uut.CPU_i.program_counter_0.pc_out;
            end
        end

        // Check why the loop exited
        if (uut.CPU_i.controller_0.inst.ps == 4'd9) begin
            $display("\n--- CPU HALTED SUCCESSFULLY ---");
            // Do one final dump for the HALT instruction
            dump_registers(uut.CPU_i.program_counter_0.pc_out);
        end else begin
            $display("\n--- SIMULATION TIMEOUT: CPU did not reach HALT state ---");
        end

        $finish;
    end

endmodule