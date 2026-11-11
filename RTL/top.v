module top_mod(
    input clk,
    input reset
);

//////////////////////////////////////////////////////////
// IF STAGE
//////////////////////////////////////////////////////////

wire [31:0] instruction;
wire [31:0] pc, pc4;
wire branch_taken;
wire [31:0] pc_target;

if_stage IF(
    .clk(clk),
    .reset(reset),
    .pc_src(branch_taken),
    .pc_target(pc_target),
    .instruction(instruction),
    .pc(pc),
    .pc4(pc4)
);

//////////////////////////////////////////////////////////
// IF/ID REGISTER
//////////////////////////////////////////////////////////

reg [31:0] IF_ID_instr, IF_ID_pc;

always @(posedge clk or posedge reset) begin
    if (reset || branch_taken) begin
        IF_ID_instr <= 0;
        IF_ID_pc    <= 0;
    end else begin
        IF_ID_instr <= instruction;
        IF_ID_pc    <= pc;
    end
end

//////////////////////////////////////////////////////////
// ID STAGE
//////////////////////////////////////////////////////////

wire [31:0] rs1_data, rs2_data;
wire [31:0] imm_i_ext, imm_s_ext, imm_b_ext, imm_j_ext;
wire [4:0] rs1_addr, rs2_addr, rd;
wire [4:0] opcode_alu;
wire [1:0] alu_b_sel;
wire reg_write, mem_read, mem_write;
wire [1:0] mem_to_reg;
wire is_branch;
wire [2:0] branch_type;
wire [1:0] pcmux_sel;

//////////////////////////////////////////////////////////
// MEM/WB REGISTER (DECLARE FIRST)
//////////////////////////////////////////////////////////

reg  [31:0] MEM_WB_data;
reg  [4:0]  MEM_WB_rd;
reg         MEM_WB_reg_write;

id_stage ID(
    .clk(clk),
    .reset(reset),
    .instruction(IF_ID_instr),
    .wb_data(MEM_WB_data),
    .wb_rd(MEM_WB_rd),
    .wb_reg_write(MEM_WB_reg_write),
    .rs1_data(rs1_data),
    .rs2_data(rs2_data),
    .imm_i_ext(imm_i_ext),
    .imm_s_ext(imm_s_ext),
    .imm_b_ext(imm_b_ext),
    .imm_j_ext(imm_j_ext),
    .rs1_addr(rs1_addr),
    .rs2_addr(rs2_addr),
    .rd(rd),
    .opcode_alu(opcode_alu),
    .alu_b_sel(alu_b_sel),
    .reg_write(reg_write),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .mem_to_reg(mem_to_reg),
    .is_branch(is_branch),
    .branch_type(branch_type),
    .pcmux_sel(pcmux_sel)
);

//////////////////////////////////////////////////////////
// ID/EX REGISTER
//////////////////////////////////////////////////////////

reg [31:0] ID_EX_pc;
reg [31:0] ID_EX_rs1, ID_EX_rs2;
reg [31:0] ID_EX_imm_i, ID_EX_imm_s, ID_EX_imm_b, ID_EX_imm_j;
reg [4:0]  ID_EX_rs1_addr, ID_EX_rs2_addr, ID_EX_rd;
reg [4:0]  ID_EX_opcode;
reg [1:0]  ID_EX_alu_b_sel, ID_EX_mem_to_reg;
reg        ID_EX_reg_write, ID_EX_mem_read, ID_EX_mem_write;
reg        ID_EX_is_branch;
reg [2:0]  ID_EX_branch_type;
reg [1:0]  ID_EX_pcmux_sel;

always @(posedge clk or posedge reset) begin
    if (reset || branch_taken) begin
        ID_EX_reg_write <= 0;
        ID_EX_mem_read  <= 0;
        ID_EX_mem_write <= 0;
        ID_EX_is_branch <= 0;
        ID_EX_pcmux_sel <= 0;
    end else begin
        ID_EX_pc        <= IF_ID_pc;
        ID_EX_rs1       <= rs1_data;
        ID_EX_rs2       <= rs2_data;
        ID_EX_rs1_addr  <= rs1_addr;
        ID_EX_rs2_addr  <= rs2_addr;
        ID_EX_rd        <= rd;
        ID_EX_opcode    <= opcode_alu;
        ID_EX_alu_b_sel <= alu_b_sel;
        ID_EX_mem_to_reg<= mem_to_reg;
        ID_EX_reg_write <= reg_write;
        ID_EX_mem_read  <= mem_read;
        ID_EX_mem_write <= mem_write;
        ID_EX_is_branch <= is_branch;
        ID_EX_branch_type <= branch_type;
        ID_EX_pcmux_sel <= pcmux_sel;
        ID_EX_imm_i     <= imm_i_ext;
        ID_EX_imm_s     <= imm_s_ext;
        ID_EX_imm_b     <= imm_b_ext;
        ID_EX_imm_j     <= imm_j_ext;
    end
end

//////////////////////////////////////////////////////////
// EX/MEM REGISTER DECLARATION
//////////////////////////////////////////////////////////

reg [31:0] EX_MEM_alu, EX_MEM_rs2, EX_MEM_pc4;
reg [4:0]  EX_MEM_rd;
reg [1:0]  EX_MEM_mem_to_reg;
reg        EX_MEM_mem_read, EX_MEM_mem_write;
reg        EX_MEM_reg_write;

//////////////////////////////////////////////////////////
// FORWARDING
//////////////////////////////////////////////////////////

wire [1:0] forwardA, forwardB;

forwarding_unit FU(
    .ID_EX_rs1(ID_EX_rs1_addr),
    .ID_EX_rs2(ID_EX_rs2_addr),
    .EX_MEM_rd(EX_MEM_rd),
    .EX_MEM_reg_write(EX_MEM_reg_write),
    .MEM_WB_rd(MEM_WB_rd),
    .MEM_WB_reg_write(MEM_WB_reg_write),
    .forwardA(forwardA),
    .forwardB(forwardB)
);

//////////////////////////////////////////////////////////
// EX STAGE
//////////////////////////////////////////////////////////

wire [31:0] alu_result;

ex_stage EX(
    .pc(ID_EX_pc),
    .rs1(ID_EX_rs1),
    .rs2(ID_EX_rs2),
    .imm_i(ID_EX_imm_i),
    .imm_s(ID_EX_imm_s),
    .imm_b(ID_EX_imm_b),
    .imm_j(ID_EX_imm_j),
    .opcode_alu(ID_EX_opcode),
    .alu_b_sel(ID_EX_alu_b_sel),
    .is_branch(ID_EX_is_branch),
    .branch_type(ID_EX_branch_type),
    .pcmux_sel(ID_EX_pcmux_sel),
    .EX_MEM_alu(EX_MEM_alu),
    .MEM_WB_data(MEM_WB_data),
    .forwardA(forwardA),
    .forwardB(forwardB),
    .alu_result(alu_result),
    .branch_taken(branch_taken),
    .pc_target(pc_target)
);

//////////////////////////////////////////////////////////
// EX/MEM REGISTER UPDATE
//////////////////////////////////////////////////////////

always @(posedge clk or posedge reset) begin
    if (reset) begin
        EX_MEM_reg_write <= 0;
    end else begin
        EX_MEM_alu        <= alu_result;
        EX_MEM_rs2        <= ID_EX_rs2;
        EX_MEM_rd         <= ID_EX_rd;
        EX_MEM_reg_write  <= ID_EX_reg_write;
        EX_MEM_mem_read   <= ID_EX_mem_read;
        EX_MEM_mem_write  <= ID_EX_mem_write;
        EX_MEM_mem_to_reg <= ID_EX_mem_to_reg;
        EX_MEM_pc4        <= ID_EX_pc + 4;
    end
end

//////////////////////////////////////////////////////////
// MEMORY + WRITEBACK
//////////////////////////////////////////////////////////

wire [31:0] load_data;
wire [31:0] wb_data_comb;

data_memory DM(
    .clk(clk),
    .data_read(EX_MEM_mem_read),
    .mem_write(EX_MEM_mem_write),
    .ef_add(EX_MEM_alu),
    .data_write(EX_MEM_rs2),
    .load_data(load_data)
);

load_mux WB_MUX(
    .alu_out(EX_MEM_alu),
    .load_data(load_data),
    .pc_plus4(EX_MEM_pc4),
    .mem_to_reg(EX_MEM_mem_to_reg),
    .wb_data(wb_data_comb)
);

//////////////////////////////////////////////////////////
// MEM/WB REGISTER UPDATE
//////////////////////////////////////////////////////////

always @(posedge clk or posedge reset) begin
    if (reset) begin
        MEM_WB_reg_write <= 0;
    end else begin
        MEM_WB_data      <= wb_data_comb;
        MEM_WB_rd        <= EX_MEM_rd;
        MEM_WB_reg_write <= EX_MEM_reg_write;
    end
end

endmodule
