

module load_mux (
    input  wire [31:0] alu_out,
    input  wire [31:0] load_data,
    input  wire [31:0] pc_plus4,
    input  wire [1:0]  mem_to_reg,
    output reg  [31:0] wb_data
);
    always @(*) begin
        case (mem_to_reg)
            2'b00: wb_data = alu_out;    
            2'b01: wb_data = load_data;  
            2'b10: wb_data = pc_plus4;   // JAL / JALR
            default: wb_data = alu_out;
        endcase
    end
endmodule
