//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2025.2 (win64) Build 6299465 Fri Nov 14 19:35:11 GMT 2025
//Date        : Mon Apr  6 23:19:06 2026
//Host        : DESKTOP-SQPJDFQ running 64-bit major release  (build 9200)
//Command     : generate_target CPU.bd
//Design      : CPU
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "CPU,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=CPU,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=12,numReposBlks=12,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=12,numPkgbdBlks=0,bdsource=USER,synth_mode=None}" *) (* HW_HANDOFF = "CPU.hwdef" *) 
module CPU
   (G_0,
    L_0,
    Z_0,
    clk_0,
    reg_no_0,
    reg_val_0,
    rst_0);
  output G_0;
  output L_0;
  output Z_0;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK_0 CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK_0, ASSOCIATED_RESET rst_0, CLK_DOMAIN CPU_clk_0, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0" *) input clk_0;
  input [2:0]reg_no_0;
  output [7:0]reg_val_0;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.RST_0 RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.RST_0, INSERT_VIP 0, POLARITY ACTIVE_HIGH" *) input rst_0;

  wire G_0;
  wire [15:0]InstructionMemory_0_instr;
  wire L_0;
  wire [7:0]Register_file_0_read_data1;
  wire [7:0]Register_file_0_read_data2;
  wire Z_0;
  wire [7:0]alu_0_Result;
  wire clk_0;
  wire [1:0]controller_0_alu_op;
  wire [1:0]controller_0_exec_mux;
  wire controller_0_halt_en;
  wire controller_0_ir_write;
  wire controller_0_mem_read;
  wire controller_0_mem_write;
  wire controller_0_phase_out;
  wire controller_0_reg_re;
  wire controller_0_reg_we;
  wire controller_0_wb_mux;
  wire [7:0]data_memory_0_read_data;
  wire [7:0]exec_mux_0_out;
  wire [8:0]instr_decoder_0_mem_addr;
  wire [3:0]instr_decoder_0_opcode;
  wire [2:0]instr_decoder_0_r3;
  wire [2:0]instr_decoder_0_rd;
  wire [2:0]instr_decoder_0_rs1;
  wire [2:0]instr_decoder_0_rs2;
  wire [15:0]instr_reg_0_ir_out;
  wire [2:0]more_mux_0_rout1;
  wire [2:0]more_mux_0_rout2;
  wire [7:0]multiplier_0_product_out;
  wire [7:0]program_counter_0_pc_out;
  wire [2:0]reg_no_0;
  wire [7:0]reg_val_0;
  wire rst_0;
  wire [7:0]wb_mux_0_wb_data;

  CPU_InstructionMemory_0_0 InstructionMemory_0
       (.instr(InstructionMemory_0_instr),
        .pc(program_counter_0_pc_out));
  CPU_Register_file_0_0 Register_file_0
       (.clk(clk_0),
        .re(controller_0_reg_re),
        .read_data1(Register_file_0_read_data1),
        .read_data2(Register_file_0_read_data2),
        .read_reg1(more_mux_0_rout1),
        .read_reg2(more_mux_0_rout2),
        .reg_no(reg_no_0),
        .reg_val(reg_val_0),
        .we(controller_0_reg_we),
        .write_data(wb_mux_0_wb_data),
        .write_reg(instr_decoder_0_rd));
  CPU_alu_0_0 alu_0
       (.A(Register_file_0_read_data1),
        .ALUOp(controller_0_alu_op),
        .B(Register_file_0_read_data2),
        .G(G_0),
        .L(L_0),
        .Result(alu_0_Result),
        .Z(Z_0));
  CPU_controller_0_0 controller_0
       (.alu_op(controller_0_alu_op),
        .clk(clk_0),
        .exec_mux(controller_0_exec_mux),
        .halt_en(controller_0_halt_en),
        .ir_write(controller_0_ir_write),
        .mem_read(controller_0_mem_read),
        .mem_write(controller_0_mem_write),
        .opcode(instr_decoder_0_opcode),
        .phase_out(controller_0_phase_out),
        .reg_re(controller_0_reg_re),
        .reg_we(controller_0_reg_we),
        .rst(rst_0),
        .wb_mux(controller_0_wb_mux));
  CPU_data_memory_0_0 data_memory_0
       (.address(instr_decoder_0_mem_addr),
        .clk(clk_0),
        .mem_read(controller_0_mem_read),
        .mem_write(controller_0_mem_write),
        .read_data(data_memory_0_read_data),
        .write_data(exec_mux_0_out));
  CPU_exec_mux_0_0 exec_mux_0
       (.alu_result(alu_0_Result),
        .mul_result(multiplier_0_product_out),
        .out(exec_mux_0_out),
        .rs1_data(Register_file_0_read_data1),
        .sel(controller_0_exec_mux));
  CPU_instr_decoder_0_0 instr_decoder_0
       (.instr(instr_reg_0_ir_out),
        .mem_addr(instr_decoder_0_mem_addr),
        .opcode(instr_decoder_0_opcode),
        .r3(instr_decoder_0_r3),
        .rd(instr_decoder_0_rd),
        .rs1(instr_decoder_0_rs1),
        .rs2(instr_decoder_0_rs2));
  CPU_instr_reg_0_0 instr_reg_0
       (.clk(clk_0),
        .ir_in(InstructionMemory_0_instr),
        .ir_out(instr_reg_0_ir_out),
        .ir_write(controller_0_ir_write),
        .rst(rst_0));
  CPU_more_mux_0_0 more_mux_0
       (.oper(controller_0_phase_out),
        .r1(instr_decoder_0_rs1),
        .r2(instr_decoder_0_rs2),
        .r3(instr_decoder_0_r3),
        .r4(instr_decoder_0_rd),
        .rout1(more_mux_0_rout1),
        .rout2(more_mux_0_rout2));
  CPU_multiplier_0_0 multiplier_0
       (.a(Register_file_0_read_data1),
        .b(Register_file_0_read_data2),
        .product_out(multiplier_0_product_out));
  CPU_program_counter_0_0 program_counter_0
       (.clk(clk_0),
        .halt_en(controller_0_halt_en),
        .pc_out(program_counter_0_pc_out),
        .rst(rst_0));
  CPU_wb_mux_0_0 wb_mux_0
       (.exec_result(exec_mux_0_out),
        .mem_data(data_memory_0_read_data),
        .sel(controller_0_wb_mux),
        .wb_data(wb_mux_0_wb_data));
endmodule
