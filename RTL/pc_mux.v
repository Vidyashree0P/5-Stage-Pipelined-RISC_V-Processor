module pc_mux (

    input  wire [31:0] pc4,        // PC + 4
    input  wire [31:0] pc_branch,  // PC + B immediate
    input  wire [31:0] pc_jal,     // PC + J immediate
    input  wire [31:0] pc_jalr,    // (rs1 + imm) & ~1
    input  wire [1:0]  pc_sel,

    output reg  [31:0] pc_next

);

    always @(*) begin
        case (pc_sel)
            2'b00: pc_next = pc4;        // Normal 
            2'b01: pc_next = pc_branch;  // Branch taken
            2'b10: pc_next = pc_jal;     // JAL
            2'b11: pc_next = pc_jalr;    // JALR
            default: pc_next = pc4;
        endcase
    end

endmodule
