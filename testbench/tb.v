module top_tb;

    reg clk;
    reg reset;

    top_mod DUT (
        .clk(clk),
        .reset(reset)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
      
        reset = 1;  
        #10;

     
        reset = 0;

        repeat (50) @(posedge clk);
        $finish;
    end
initial begin
$shm_open("wave.shm");
$shm_probe("ACTMF");
end
endmodule
