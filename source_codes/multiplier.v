`timescale 1ns / 1ps

module multiplier (
    input  wire [7:0] a,          // 8-bit operand A
    input  wire [7:0] b,          // 8-bit operand B
    output wire [7:0] product_out // Lower 8 bits of the product
);

    // Internal wire to hold the full 16-bit product
    wire [15:0] full_product;

    // Combinational multiplication
    assign full_product = a * b;

    // Output only the lower 8 bits to the write-back bus
    assign product_out = full_product[7:0];

endmodule