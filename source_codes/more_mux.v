`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.04.2026 11:54:20
// Design Name: 
// Module Name: more_mux
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module more_mux(
    input [2:0] r1,r2,r3,r4,
    input  oper,
    output reg [2:0] rout1,rout2
    );
    always @(*) begin
        if(!oper) begin
            rout1=r1;
            rout2=r2;
        end
        else begin
            rout1=r3;
            rout2=r4;
        end
    end
endmodule
