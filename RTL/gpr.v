module gpr (
    input  wire        clk,
    input  wire        reset,

    input  wire [4:0]  rs1_addr,
    input  wire [4:0]  rs2_addr,

  
    input  wire [4:0]  rd_addr,
    input  wire        reg_write,
    input  wire [31:0] write_data,

    output wire [31:0] rs1_data_out,
    output wire [31:0] rs2_data_out
);

    
    reg [31:0] regfile [0:31];

    integer i;

        initial begin
        $readmemh("gpr.hex", regfile);
        regfile[0] = 32'b0;
    end

    // Synchronous write
    always @(posedge clk) begin
        if (reset) begin
            regfile[0] <= 32'b0;
        end
        else begin
            if (reg_write && (rd_addr != 5'd0)) begin
                regfile[rd_addr] <= write_data;
            end
            regfile[0] <= 32'b0; 
        end
    end

        assign rs1_data_out =
        (reg_write && (rd_addr == rs1_addr) && (rd_addr != 5'd0)) ?
            write_data :
            regfile[rs1_addr];

    assign rs2_data_out =
        (reg_write && (rd_addr == rs2_addr) && (rd_addr != 5'd0)) ?
            write_data :
            regfile[rs2_addr];

endmodule
