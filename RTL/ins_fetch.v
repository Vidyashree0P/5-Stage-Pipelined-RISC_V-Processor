module if_stage(
    input clk,
    input reset,
    input pc_src,
    input [31:0] pc_target,
    output [31:0] instruction,
    output [31:0] pc,
    output [31:0] pc4
);

wire [31:0] pc_next;

assign pc_next = (pc_src) ? pc_target : pc4;

program_counter PC(
    .clk(clk),
    .reset(reset),
    .en(1'b1),
    .pc_next(pc_next),
    .pc(pc)
);

pc_plus4 PC4(
    .pc_current(pc),
    .pc4(pc4)
);

inst_mem IM(
    .addr(pc[6:2]),
    .inst_en(1'b1),
    .instruction(instruction)
);

endmodule
