module decoder (
    input  wire [31:0] instruction,

    output reg  [4:0] rs1_addr,
    output reg  [4:0] rs2_addr,
    output reg  [4:0] rd_addr,

    output reg  [11:0] imm_i,   // I-type, load, JALR
    output reg  [11:0] imm_s,   // S-type 
    output reg  [12:0] imm_b,   // B-type 
    output reg  [20:0] imm_j    // J-type
);

always @(*) begin
    rs1_addr = 5'd0;
    rs2_addr = 5'd0;
    rd_addr  = 5'd0;

    imm_i = 12'd0;
    imm_s = 12'd0;
    imm_b = 13'd0;
    imm_j = 21'd0;

    case (instruction[6:0])

        // -------- R-TYPE --------
        7'b0110011: begin
            rs1_addr = instruction[19:15];
            rs2_addr = instruction[24:20];
            rd_addr  = instruction[11:7];
        end

        // -------- I-TYPE / LOAD / --------
        7'b0010011,
        7'b0000011: begin
            rs1_addr = instruction[19:15];
            rd_addr  = instruction[11:7];
            imm_i    = instruction[31:20];
        end

        // -------- STORE --------
        7'b0100011: begin
            rs1_addr = instruction[19:15];
            rs2_addr = instruction[24:20];
            imm_s    = {instruction[31:25], instruction[11:7]};
        end

        // -------- BRANCH --------
        7'b1100011:begin
            rs1_addr = instruction[19:15];
            rs2_addr = instruction[24:20];
            imm_b    = {
                instruction[31],   
                instruction[7],     
                instruction[30:25], 
                instruction[11:8],  
                1'b0                
            };
        end

        // -------- JAL --------
        7'b1101111:begin
            rd_addr = instruction[11:7];
            imm_j   = {
                instruction[31],   
                instruction[19:12], 
                instruction[20],    
                instruction[30:21], 
                1'b0                
            };
        end
//////////jalr
         7'b1100111: begin
            rs1_addr = instruction[19:15];
            rd_addr  = instruction[11:7];
            imm_i    = instruction[31:20];
        end

    endcase
end
endmodule
