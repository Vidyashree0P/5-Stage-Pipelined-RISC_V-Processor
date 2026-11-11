module alu_operand_mux (
    input  wire [31:0] rs2_data,
    input  wire [31:0] imm_i_ext,
    input  wire [31:0] imm_s_ext,
    input  wire [1:0]  alu_b_sel,
    output reg  [31:0] alu_b
);
    always @(*) begin
        case (alu_b_sel)
            2'b00: alu_b = rs2_data;
            2'b01: alu_b = imm_i_ext;
            2'b10: alu_b = imm_s_ext;
            default: alu_b = rs2_data;
        endcase
    end
endmodule
