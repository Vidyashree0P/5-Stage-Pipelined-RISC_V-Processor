module id_stage(
    input clk,
    input reset,
    input [31:0] instruction,
    input [31:0] wb_data,
    input [4:0]  wb_rd,
    input        wb_reg_write,

    output [31:0] rs1_data,
    output [31:0] rs2_data,
    output [31:0] imm_i_ext,
    output [31:0] imm_s_ext,
    output [31:0] imm_b_ext,
    output [31:0] imm_j_ext,
    output [4:0]  rs1_addr,
    output [4:0]  rs2_addr,
    output [4:0]  rd,
    output [4:0]  opcode_alu,
    output [1:0]  alu_b_sel,
    output        reg_write,
    output        mem_read,
    output        mem_write,
    output [1:0]  mem_to_reg,
    output        is_branch,
    output [2:0]  branch_type,
    output [1:0]  pcmux_sel
);

wire [11:0] imm_i, imm_s;
wire [12:0] imm_b;
wire [20:0] imm_j;

decoder DEC(
    .instruction(instruction),
    .rs1_addr(rs1_addr),
    .rs2_addr(rs2_addr),
    .rd_addr(rd),
    .imm_i(imm_i),
    .imm_s(imm_s),
    .imm_b(imm_b),
    .imm_j(imm_j)
);

control CTRL(
    .instruction(instruction),
    .reg_write(reg_write),
    .opcode_alu(opcode_alu),
    .alu_b_sel(alu_b_sel),
    .data_read(mem_read),
    .mem_to_reg(mem_to_reg),
    .mem_write(mem_write),
    .is_branch(is_branch),
    .branch_type(branch_type),
    .pcmux_sel(pcmux_sel)
);

gpr RF(
    .clk(clk),
    .reset(reset),
    .rs1_addr(rs1_addr),
    .rs2_addr(rs2_addr),
    .rd_addr(wb_rd),
    .reg_write(wb_reg_write),
    .write_data(wb_data),
    .rs1_data_out(rs1_data),
    .rs2_data_out(rs2_data)
);

sign_ext_alu    SEI(.imm_in(imm_i), .imm_out(imm_i_ext));
sign_ext_alu    SES(.imm_in(imm_s), .imm_out(imm_s_ext));
sign_ext_branch SEB(.imm_b(imm_b), .imm_out(imm_b_ext));
sign_ext_jal    SEJ(.imm_j(imm_j), .imm_out(imm_j_ext));

endmodule
