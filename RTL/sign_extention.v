//SIGN_I
module sign_ext_alu (
    input  wire [11:0] imm_in,
    output wire [31:0] imm_out
);
    assign imm_out = {{20{imm_in[11]}}, imm_in};
endmodule

//SIGN_J
module sign_ext_jal (
    input  wire [20:0] imm_j,
    output wire [31:0] imm_out
);
    assign imm_out = {{11{imm_j[20]}}, imm_j};
endmodule

//SIGN_B
module sign_ext_branch (
    input  wire [12:0] imm_b,
    output wire [31:0] imm_out
);
    assign imm_out = {{19{imm_b[12]}}, imm_b};
endmodule
