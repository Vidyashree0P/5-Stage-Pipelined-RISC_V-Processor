module ALU (
    input  wire [31:0] A,
    input  wire [31:0] B,
    input  wire [4:0]  opcode_alu,

    output reg  [31:0] result,
    output wire        zero,
    output wire        lt,
    output wire        ltu
);

    
    assign zero = (A == B);
    assign lt   = ($signed(A) < $signed(B));
    assign ltu  = ($unsigned(A) < $unsigned(B));

    always @(*) begin
        case (opcode_alu)
            5'b00001: result = A + B;                 // ADD
            5'b00010: result = A - B;                 // SUB
            5'b00011: result = A ^ B;                 // XOR
            5'b00100: result = A | B;                 // OR
            5'b00101: result = A & B;                 // AND
            5'b00110: result = A << B[4:0];           // SLL
            5'b00111: result = A >> B[4:0];           // SRL
            5'b01000: result = $signed(A) >>> B[4:0]; // SRA
            5'b01001: result = lt ? 32'd1 : 32'd0;    // SLT
            5'b01010: result = ltu ? 32'd1 : 32'd0;   // SLTU
            default : result = 32'd0;
        endcase
    end
endmodule
