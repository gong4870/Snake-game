`timescale 1ns/1ps
`default_nettype none

module tb_Random;
    reg clk;
    reg reset;

    wire [9:0] randX;
    wire [8:0] randY;

    Random uut (
        .clk(clk),
        .reset(reset),
        .randX(randX),
        .randY(randY)
    );

    initial clk = 1;
    always #5 clk = ~clk; 

    initial begin
        reset = 1;

        #20;
        reset = 0;

        repeat (20) begin
            @(posedge clk); 
            #1; 
        end

        reset = 1;
        #20;
        reset = 0;

        repeat (20) begin
            @(posedge clk); 
            #1; 
        end

        $finish;
    end
endmodule
