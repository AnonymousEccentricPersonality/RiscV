`timescale 1ns / 1ps

module controller
#(parameter OPCODE_WIDTH=4,
            ALU_OP_WIDTH=2
)
(output reg [ALU_OP_WIDTH-1:0]alu_op,
input [OPCODE_WIDTH-1:0]opcode,
input rst,
clk,
output reg ir_write,
 mem_read,
 mem_write, 
 
 halt_en,
 reg_we,
 reg_re,
 wb_mux,
 output reg [1:0] exec_mux,
 output reg phase_out // FIX 1: Changed from wire to reg
    );
    localparam S0=0,S1=1,DCode=2,PC_INC=3,REG_FETCH=4,EXECUTE=5,MEM_W=6,WB=7,MEM_R=8,HALT=9;
    
    reg [3:0] ps,ns;
    wire [3:0] op = opcode; 
    reg phase; 
    
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            ps<=S0;
            phase<=0;
        end
        else begin
         ps<=ns;
         if (ps == EXECUTE && (op == 4'hA || op == 4'hB || op == 4'hC)) begin
                phase <= ~phase; 
            end else begin
                phase <= 0; // Keep at 0 for normal 1-cycle instructions
            end
         end
    end
    
    always @(*) begin
        // 1. Default Defaults
        halt_en  = 1;   
        ir_write = 0;
        mem_read = 0;
        mem_write = 0;
        reg_we   = 0;
        reg_re   = 0;
        wb_mux   = 0;
        exec_mux = 0;
        phase_out = 0; // Default to phase 0 routing

        // 2. Decode ALU OP and MUX globally
        if(op==1) begin//add
           alu_op=0; exec_mux=0;
        end
        else if(op==2) begin//sub
           alu_op=1; exec_mux=0;
        end
        else if(op==4) begin//cmp
           alu_op=2; exec_mux=0;
        end
        else if(op==4'h3) begin//mul
             alu_op=3; exec_mux=1;
        end
        else if(op==4'h5 || op==4'h7) begin//mov & store
             alu_op=3; exec_mux=2;
        end
        else if (ps == EXECUTE || ps == WB) begin
            if (op == 4'hA || op == 4'hB) begin // MAC1 and MAC2
                // FIX 2: Safely lock MUX, ALU, and exec_mux based on exact phase/state
                if ((ps == EXECUTE && phase == 1) || ps == WB) begin
                    phase_out = 1; 
                    alu_op = 0;    // Standard Add
                    exec_mux = 0;  // Match ADD settings
                end else begin
                    phase_out = 0; 
                    alu_op = 3;    // Standard Multiply
                    exec_mux = 1;  // Match MUL settings!
                end
            end
            else if (op == 4'hC) begin // ADD3
                if ((ps == EXECUTE && phase == 1) || ps == WB) begin
                    phase_out = 1;
                end else begin
                    phase_out = 0;
                end
                alu_op = 0; 
                exec_mux = 0;
            end
        end
        else begin
            alu_op=3; exec_mux=3;
        end

        // 3. FSM Outputs
        case(ps)
            S0: begin 
            end
            S1: begin
                ir_write=1;
            end
            DCode: begin
            end
            HALT: begin
            end
            REG_FETCH:begin
                reg_re=1;
            end
            EXECUTE: begin
                reg_re=1; // Keep read high
            if ((op == 4'hA || op == 4'hB || op == 4'hC) && phase == 0) begin
            reg_we = 1; 
             end
            end
            WB: begin
                reg_we=1;
                reg_re=1; // Keep read high so ALU out is stable
                wb_mux = (op == 4'h6) ? 1'b1 : 1'b0;
            end
            MEM_R: begin
                mem_read=1;
            end
            MEM_W: begin
                mem_write=1;
                reg_re=1;
            end
            PC_INC: begin
                halt_en=0;
            end
        endcase
    end
    
    always @(*) begin
        case(ps) 
            S0: ns=S1;
            S1: ns=DCode;
            DCode: begin
                if(op==4'h0) ns=PC_INC;//nop
                else if(op==4'h1)  begin ns=REG_FETCH; end //add
                else if(op==4'h2) begin ns=REG_FETCH; end //sub
                else if(op==4'h3) begin ns=REG_FETCH; end //mul
                else if(op==4'h4) begin ns=REG_FETCH; end //cmp
                else if(op==4'h5) begin ns=REG_FETCH; end //mov
                else if(op==4'hA || op==4'hB || op==4'hC) ns=REG_FETCH;//mac,add3,mac2
                else if(op==4'h6) ns=MEM_R;//load
                else if(op==4'h7) ns=REG_FETCH;//store
                else if(op==4'hF) ns=HALT;
                else ns=S0;    
            end
            
            REG_FETCH: begin
                ns=EXECUTE;
              end
            EXECUTE: begin
            
            if (op == 4'hA || op == 4'hB || op == 4'hC) begin // MAC1, MAC2, ADD3
            if (phase == 0) begin
                ns = EXECUTE; // Stay here for cycle 2
            end else begin
                ns = WB;      // Move to Write-Back after cycle 2
            end
            end
             else if(op==4'h1 | op==4'h2 ) begin//add,sub
                    ns=WB;
                end
                else if( op==4'h4) begin//cmp
                     ns=PC_INC;
                end
                else if(op==4'h3) begin//mul
                    ns=WB;
                end
                else if(op==4'h5) begin//mov
                    ns=WB;
                end
                else if(op==4'h7) begin//store
                    ns=MEM_W;
                end
                else ns=PC_INC;
            end
            MEM_R: begin//load
                ns=WB;
            end
            MEM_W: begin//store
                ns=PC_INC;
            end
            WB: begin
                ns=PC_INC;
            end
            PC_INC: ns=S0;
            HALT: ns=HALT;
            default: ns=S0;
        endcase
    end
    
endmodule