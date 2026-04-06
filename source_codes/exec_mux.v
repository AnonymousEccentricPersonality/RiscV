`timescale 1ns / 1ps


module exec_mux (
    input  [7:0] alu_result,
    input  [7:0] mul_result,
    input  [7:0] rs1_data,
    input  [1:0] sel,
    output reg [7:0] out
);
    localparam ALU = 2'b00,
               MUL = 2'b01,
               MOV = 2'b10;//store too

    always @(*) begin
        case(sel)
            ALU:  out = alu_result;
            MUL:  out = mul_result;
            MOV:  out = rs1_data;//store too
            default: out=0;
        endcase
    end
endmodule