`timescale 1ns / 1ps

module tb_alu;

    // Inputs
    reg [7:0] A;
    reg [7:0] B;
    reg [1:0] ALUOp;

    // Outputs
    wire [7:0] Result;
    wire Z;
    wire G;
    wire L;

    // Instantiate the Unit Under Test (UUT)
    alu uut (
        .A(A),
        .B(B),
        .ALUOp(ALUOp),
        .Result(Result),
        .Z(Z),
        .G(G),
        .L(L)
    );

    initial begin
        // Monitor outputs to the console
        $monitor("Time=%0t | ALUOp=%b | A=%d B=%d | Result=%d | Z=%b G=%b L=%b", 
                 $time, ALUOp, A, B, Result, Z, G, L);

        // Initialize Inputs
        A = 0;
        B = 0;
        ALUOp = 0;
        #10;

        // --- Test ADD ---
        $display("\n--- Testing ADD ---");
        ALUOp = 2'b00; 
        A = 8'd10; B = 8'd15; // 10 + 15 = 25
        #10;
        
        A = 8'd100; B = 8'd50; // 100 + 50 = 150
        #10;

        // --- Test SUB ---
        $display("\n--- Testing SUB ---");
        ALUOp = 2'b01; 
        A = 8'd50; B = 8'd20; // 50 - 20 = 30
        #10;

        A = 8'd20; B = 8'd50; // 20 - 50 = Underflow (226 in 8-bit unsigned)
        #10;

        // --- Test CMP ---
        $display("\n--- Testing CMP ---");
        ALUOp = 2'b10; 
        
        // Greater Than (G should be 1)
        A = 8'd45; B = 8'd20; 
        #10;

        // Less Than (L should be 1)
        A = 8'd10; B = 8'd55; 
        #10;

        // Equal (Z should be 1)
        A = 8'd33; B = 8'd33; 
        #10;

        $display("\nSimulation Complete.");
        $finish;
    end

endmodule