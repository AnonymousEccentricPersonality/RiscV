module instr_decoder (
    input  [15:0] instr,
    output [3:0]  opcode,
    output [2:0]  rd,
    output [2:0]  rs1,
    output [2:0]  rs2,
    output [2:0]  reg_m,    // source reg for STORE (also bits [11:9])
    output [8:0]  mem_addr,  // for LOAD/STORE
    output [2:0]  r3
);
    assign opcode   = instr[15:12];
    assign rd       = instr[11:9];//r4 for mac or add3
    assign r3       = instr[2:0];
    assign rs1      = instr[8:6];
    assign rs2      = instr[5:3];
    assign reg_m    = instr[11:9];  // same bits as rd, aliased for STORE clarity
    assign mem_addr = instr[8:0];
endmodule