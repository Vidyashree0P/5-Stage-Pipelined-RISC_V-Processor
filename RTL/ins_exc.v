module ex_stage(
    input  [31:0] pc,

    // Register values from ID/EX
    input  [31:0] rs1,
    input  [31:0] rs2,

    // Immediate values
    input  [31:0] imm_i,
    input  [31:0] imm_s,
    input  [31:0] imm_b,
    input  [31:0] imm_j,

    // Control
    input  [4:0]  opcode_alu,
    input  [1:0]  alu_b_sel,
    input         is_branch,
    input  [2:0]  branch_type,
    input  [1:0]  pcmux_sel,

    // Forwarding inputs
    input  [31:0] EX_MEM_alu,
    input  [31:0] MEM_WB_data,
    input  [1:0]  forwardA,
    input  [1:0]  forwardB,

    // Outputs
    output [31:0] alu_result,
    output reg    branch_taken,
    output reg [31:0] pc_target
);

//////////////////////////////////////////////////////////
// FORWARDING MUX FOR OPERAND A
//////////////////////////////////////////////////////////

wire [31:0] opA;

assign opA =
    (forwardA == 2'b10) ? EX_MEM_alu :
    (forwardA == 2'b01) ? MEM_WB_data :
                          rs1;

//////////////////////////////////////////////////////////
// FORWARDING MUX FOR OPERAND B (RAW)
//////////////////////////////////////////////////////////

wire [31:0] opB_raw;

assign opB_raw =
    (forwardB == 2'b10) ? EX_MEM_alu :
    (forwardB == 2'b01) ? MEM_WB_data :
                          rs2;

//////////////////////////////////////////////////////////
// ALU OPERAND B SELECT (IMM OR REGISTER)
//////////////////////////////////////////////////////////

wire [31:0] opB;

alu_operand_mux operand_mux (
    .rs2_data(opB_raw),
    .imm_i_ext(imm_i),
    .imm_s_ext(imm_s),
    .alu_b_sel(alu_b_sel),
    .alu_b(opB)
);

//////////////////////////////////////////////////////////
// ALU
//////////////////////////////////////////////////////////

wire zero, lt, ltu;

ALU alu_core (
    .A(opA),
    .B(opB),
    .opcode_alu(opcode_alu),
    .result(alu_result),
    .zero(zero),
    .lt(lt),
    .ltu(ltu)
);

//////////////////////////////////////////////////////////
// BRANCH + JUMP LOGIC
//////////////////////////////////////////////////////////

always @(*) begin
    branch_taken = 1'b0;
    pc_target    = 32'b0;

    // -------- BRANCH --------
    if (is_branch) begin
        case (branch_type)
            3'b000: branch_taken = zero;       // BEQ
            3'b001: branch_taken = !zero;      // BNE
            3'b100: branch_taken = lt;         // BLT
            3'b101: branch_taken = !lt;        // BGE
            3'b110: branch_taken = ltu;        // BLTU
            3'b111: branch_taken = !ltu;       // BGEU
            default: branch_taken = 1'b0;
        endcase

        pc_target = pc + imm_b;
    end

    // -------- JAL --------
    else if (pcmux_sel == 2'b10) begin
        branch_taken = 1'b1;
        pc_target    = pc + imm_j;
    end

    // -------- JALR --------
    else if (pcmux_sel == 2'b11) begin
        branch_taken = 1'b1;
        pc_target    = {alu_result[31:1], 1'b0};
    end
end

endmodule
