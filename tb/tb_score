`timescale 1ns / 1ps
`default_nettype none

module tb_Score;

    reg clk;
    reg reset;
    reg score;
    reg ld;

    wire [3:0] D0;
    wire A, B, C, D, E, F, G;
    wire [7:0] AN;

    Score uut (
        .clk(clk),
        .reset(reset),
        .score(score),
        .ld(ld),
        .D0(D0),
        .A(A), .B(B), .C(C), .D(D), .E(E), .F(F), .G(G),
        .AN(AN)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        reset = 1;
        score = 0;
        ld = 0;

        #20;
        reset = 0;

        #10;
        score = 1;
        ld = 1; 
        #10;
        score = 0;
        ld = 0; 

        #50;
        score = 1;
        ld = 1; 
        #10;
        score = 0;
        ld = 0;

        #10;
        score = 1;
        ld = 1; 
        #10;
        score = 0;
        ld = 0;

        #50;
        repeat (12) begin
            #20;
            score = 1;
            ld = 1; // Increment and load
            #10;
            score = 0;
            ld = 0;
        end

        #50;
        reset = 1;
        #20;
        reset = 0;

        #100;
        $stop;
    end



endmodule
