module data_memory (
    input  wire        clk,
    input  wire        data_read,
    input  wire        mem_write,
    input  wire [31:0] data_write,
    input  wire [31:0] ef_add,
    output wire [31:0] load_data
);

    reg [31:0] regfile [0:31];

    initial begin
        $readmemh("data.hex", regfile);
    end

    // Synchronous write
    always @(posedge clk) begin
        if (mem_write)
            regfile[ef_add] <= data_write;
    end

    // Combinational read (IMPORTANT FIX)
    assign load_data = (data_read) ? regfile[ef_add] : 32'b0;

endmodule
