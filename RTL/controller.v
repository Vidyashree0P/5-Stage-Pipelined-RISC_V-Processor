module control (

    input  wire [31:0] instruction,

    output reg         reg_write,
    output reg  [4:0]  opcode_alu,
    output reg  [1:0]  alu_b_sel,
    output reg         data_read,
    output reg  [1:0]  mem_to_reg,
    output reg         mem_write,

    // NEW for pipeline
    output reg         is_branch,
    output reg  [2:0]  branch_type,
    output reg  [1:0]  pcmux_sel
);

    always @(*) begin

        // ================= DEFAULTS =================
        reg_write   = 1'b0;
        opcode_alu  = 5'b00000;
        alu_b_sel   = 2'b00;
        data_read   = 1'b0;
        mem_to_reg  = 2'b00;
        mem_write   = 1'b0;
        is_branch   = 1'b0;
        branch_type = 3'b000;
        pcmux_sel   = 2'b00;   // default PC+4

        case (instruction[6:0])

        // ================= R-TYPE =================
        7'b0110011: begin
            reg_write = 1'b1;
            alu_b_sel = 2'b00;

            case ({instruction[31:25], instruction[14:12]})
                10'b0000000_000: opcode_alu = 5'b00001; // ADD
                10'b0100000_000: opcode_alu = 5'b00010; // SUB
                10'b0000000_100: opcode_alu = 5'b00011; // XOR
                10'b0000000_110: opcode_alu = 5'b00100; // OR
                10'b0000000_111: opcode_alu = 5'b00101; // AND
                10'b0000000_001: opcode_alu = 5'b00110; // SLL
                10'b0000000_101: opcode_alu = 5'b00111; // SRL
                10'b0100000_101: opcode_alu = 5'b01000; // SRA
                10'b0000000_010: opcode_alu = 5'b01001; // SLT
                10'b0000000_011: opcode_alu = 5'b01010; // SLTU
                default: opcode_alu = 5'b00000;
            endcase
        end


        // ================= I-TYPE =================
        7'b0010011: begin
            reg_write = 1'b1;
            alu_b_sel = 2'b01;

            case (instruction[14:12])
                3'b000: opcode_alu = 5'b00001; // ADDI
                3'b100: opcode_alu = 5'b00011; // XORI
                3'b110: opcode_alu = 5'b00100; // ORI
                3'b111: opcode_alu = 5'b00101; // ANDI
                3'b001: opcode_alu = 5'b00110; // SLLI
                3'b010: opcode_alu = 5'b01001; // SLTI
                3'b011: opcode_alu = 5'b01010; // SLTIU
                3'b101: opcode_alu =
                    (instruction[31:25] == 7'b0000000) ?
                     5'b00111 : 5'b01000;       // SRLI / SRAI
                default: opcode_alu = 5'b00000;
            endcase
        end


        // ================= LOAD =================
        7'b0000011: begin
            reg_write  = 1'b1;
            data_read  = 1'b1;
            alu_b_sel  = 2'b01;
            mem_to_reg = 2'b01;  // from memory
            opcode_alu = 5'b00001; // ADD for address
        end


        // ================= STORE =================
        7'b0100011: begin
            mem_write  = 1'b1;
            alu_b_sel  = 2'b10;  // use S-type imm
            opcode_alu = 5'b00001; // ADD for address
        end


        // ================= BRANCH =================
        7'b1100011: begin
            is_branch   = 1'b1;
            branch_type = instruction[14:12];  // BEQ, BNE, etc.
            opcode_alu  = 5'b00010;  // SUB for comparison
        end


        // ================= JAL =================
        7'b1101111: begin
            reg_write  = 1'b1;
            mem_to_reg = 2'b10;  // write PC+4
            pcmux_sel  = 2'b10;  // select JAL target
        end


        // ================= JALR =================
        7'b1100111: begin
            reg_write  = 1'b1;
            mem_to_reg = 2'b10;  // write PC+4
            alu_b_sel  = 2'b01;  // use I-type imm
            opcode_alu = 5'b00001; // ADD for rs1+imm
            pcmux_sel  = 2'b11;  // select JALR target
        end

        default: begin
            // keep defaults
        end

        endcase
    end

endmodule
