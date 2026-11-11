module inst_mem (
  input  [4:0] addr,        
  input        inst_en,    
  output reg [31:0] instruction
);

reg [31:0] instruction_mem [0:31];
initial begin

                                        ///////// R - TYPE ////////////////
    instruction_mem[0]  = 32'b0000000_00010_00001_000_00011_0110011; // add  x3,  x1, x2
    instruction_mem[1]  = 32'b0100000_00010_00001_000_00100_0110011; // sub  x4,  x1, x2
    instruction_mem[2]  = 32'b0000000_00010_00001_100_00101_0110011; // xor x5, x1, x2
    instruction_mem[3]  = 32'b0000000_00010_00001_110_00110_0110011; // or   x6,  x1, x2
    instruction_mem[4]  = 32'b0000000_00010_00001_111_00111_0110011; // and  x7,  x1, x2
    instruction_mem[5]  = 32'b0000000_00010_00001_001_01000_0110011; // sll  x8,  x1, x2
    instruction_mem[6]  = 32'b0000000_00010_00001_101_01001_0110011; // srl  x9,  x1, x2
    instruction_mem[7]  = 32'b0100000_00010_00001_101_01010_0110011; // sra  x10, x1, x2
    instruction_mem[8]  = 32'b0000000_00010_00001_010_01011_0110011; // slt  x11, x1, x2
    instruction_mem[9]  = 32'b0000000_00010_00001_011_01100_0110011; // sltu x12, x1, x2

                                      //////////////I - TYPE (imm_value is 2)////////////
    instruction_mem[10] = 32'b000000000010_00001_000_01101_0010011; // addi  x13, x1, 2
    instruction_mem[11] = 32'b000000000010_00001_100_01110_0010011; // xori  x14, x1, 2
    instruction_mem[12] = 32'b000000000010_00001_110_01111_0010011; // ori   x15, x1, 2
    instruction_mem[13] = 32'b000000000010_00001_111_10000_0010011; // andi  x16, x1, 2
    instruction_mem[14] = 32'b000000000010_00001_010_10001_0010011; // slti  x17, x1, 2
    instruction_mem[15] = 32'b000000000010_00001_011_10010_0010011; // sltiu x18, x1, 2
    instruction_mem[16] = 32'b0000000_00010_00001_001_10011_0010011; // slli  x19, x1, 2
    instruction_mem[17] = 32'b0000000_00010_00001_101_10100_0010011; // srli  x20, x1, 2


                                      ///////I - TYPE (imm_value is 4)/////////////
    instruction_mem[18] = 32'b000000000100_00000_010_11011_0000011; // lw x20, 4(x0)
    instruction_mem[19] = 32'd0;
    instruction_mem[20] = 32'd0;
    instruction_mem[21] = 32'b0000000_01001_00000_010_00100_0100011;  // sw x27, 4(x0)
    instruction_mem[22] = 32'd0;
                                       ///////////////////BRANCH////////////////////
   instruction_mem[23] = 32'b0_000000_01011_01011_000_1000_0_1100011;
   instruction_mem[24] = 32'b0_000000_01011_01010_001_0100_0_1100011; // BNE x10, x11, +12
   instruction_mem[25] = 32'b0_000000_01111_01110_100_0100_0_1100011; // BLT x14, x15, +12
   instruction_mem[26] = 32'b0_000000_01111_01110_101_0100_0_1100011; // BGE x14, x15, +12
   instruction_mem[27] = 32'b0_000000_01111_01110_110_0100_0_1100011; // BLTU x14, x15, +12
   instruction_mem[28] = 32'b0_000000_01111_01110_111_0100_0_1100011; // BGEU x14, x15, +12

    instruction_mem[29] = 32'b0_0000001000_0_00000000_00001_1101111;   // JAL x1, +16
    instruction_mem[30] = 32'b000000001000_00001_000_00101_1100111;    // JALR x5, 16(x1)

    instruction_mem[31] = 32'd0;
  end

always @(*) begin
  if (inst_en)
    instruction = instruction_mem[addr];
  else
    instruction = 32'h0;
end

endmodule
