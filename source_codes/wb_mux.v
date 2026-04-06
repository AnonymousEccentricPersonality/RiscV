`timescale 1ns / 1ps

module wb_mux (
    input  [7:0] exec_result,  // from exec_mux
    input  [7:0] mem_data,     // from data memory
    input        sel,          // 0=exec, 1=mem(LOAD)
    output reg [7:0] wb_data
);
    always @(*) begin
        case(sel)
            1'b0: wb_data = exec_result;
            1'b1: wb_data = mem_data;
        endcase
    end
endmodule