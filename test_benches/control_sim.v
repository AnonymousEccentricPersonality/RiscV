`timescale 1ns / 1ps

module tb_controller;

    // Parameters matching the UUT
    parameter OPCODE_WIDTH = 4;
    parameter ALU_OP_WIDTH = 2;

    // Inputs
    reg [OPCODE_WIDTH-1:0] opcode;
    reg rst;
    reg clk;

    // Outputs
    wire [ALU_OP_WIDTH-1:0] alu_op;
    wire ir_write;
    wire mem_read;
    wire mem_write;
    wire halt_en;
    wire reg_we;
    wire reg_re;
    wire wb_mux;
    wire [1:0] exec_mux;

    // Instantiate the Unit Under Test (UUT)
    controller #(
        .OPCODE_WIDTH(OPCODE_WIDTH),
        .ALU_OP_WIDTH(ALU_OP_WIDTH)
    ) uut (
        .alu_op(alu_op),
        .opcode(opcode),
        .rst(rst),
        .clk(clk),
        .ir_write(ir_write),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .halt_en(halt_en),
        .reg_we(reg_we),
        .reg_re(reg_re),
        .wb_mux(wb_mux),
        .exec_mux(exec_mux)
    );

    // Clock generation: 10ns period (5ns high, 5ns low)
    always #5 clk = ~clk;

    // --- Task to cleanly test instructions ---
    // This task feeds an opcode, waits for the FSM to reach PC_INC (where halt_en=0),
    // and then waits one more clock to ensure the FSM returns to S0.
    task run_instruction;
        input [3:0] test_opcode;
        input [47:0] instr_name; // 6-character string for display
        begin
            $display("\n--- Starting %0s (Opcode: %h) ---", instr_name, test_opcode);
            opcode = test_opcode;
            
            // Wait for the instruction to complete (halt_en drops to 0 at PC_INC)
            wait(halt_en == 0);
            
            // Wait one more clock edge to transition back to S0
            @(posedge clk);
            #1; // Slight delay to separate prints
        end
    endtask

    initial begin
        // Monitor outputs. Note: uut.ps allows us to peek into the internal state of the FSM
        $monitor("Time=%0t | ps=%d | Op=%h | halt=%b ir_w=%b reg_r=%b reg_w=%b alu_op=%d exec_mux=%d mem_r=%b mem_w=%b wb_mux=%b", 
                 $time, uut.ps, opcode, halt_en, ir_write, reg_re, reg_we, alu_op, exec_mux, mem_read, mem_write, wb_mux);

        // Initialize Inputs
        clk = 0;
        rst = 1;
        opcode = 4'h0;

        // Hold reset for 20 ns
        #20; 
        rst = 0;

        // Give it a cycle to settle into S0
        @(posedge clk);

        // --- Run through various instruction flows ---
        
        // 1. Test ADD (Path: S0 -> S1 -> DCode -> REG_FETCH -> EXECUTE -> WB -> PC_INC -> S0)
        run_instruction(4'h1, "ADD   ");

        // 2. Test CMP (Path: S0 -> S1 -> DCode -> REG_FETCH -> EXECUTE -> PC_INC -> S0)
        run_instruction(4'h4, "CMP   ");

        // 3. Test LOAD (Path: S0 -> S1 -> DCode -> MEM_R -> WB -> PC_INC -> S0)
        run_instruction(4'h6, "LOAD  ");

        // 4. Test STORE (Path: S0 -> S1 -> DCode -> EXECUTE -> MEM_W -> PC_INC -> S0)
        run_instruction(4'h7, "STORE ");

        // 5. Test NOP (Path: S0 -> S1 -> DCode -> PC_INC -> S0)
        run_instruction(4'h0, "NOP   ");

        // 6. Test HALT
        // Note: In your current next-state logic, HALT (0xF) is missing from the 
        // DCode state transition case, so it will fall to the default (ns=S0). 
        // We simulate a few cycles to observe this behavior.
        $display("\n--- Starting HALT (Opcode: F) ---");
        opcode = 4'hF;
        #50;

        $display("\nSimulation Complete.");
        $finish;
    end

endmodule