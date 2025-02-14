`timescale 1ns/1ps
`default_nettype none

module tb_control_unit;
    reg clk;
    reg reset;
    reg apple;
    reg border;
    reg gameOver;
    reg head;

    wire [2:0] length;
    wire score;
    wire ld;
    wire i_speaker;
    wire over;

    control_unit uut (
        .clk(clk),
        .reset(reset),
        .apple(apple),
        .border(border),
        .gameOver(gameOver),
        .head(head),
        .length(length),
        .score(score),
        .ld(ld),
        .i_speaker(i_speaker),
        .over(over)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        reset = 1; apple = 0; border = 0; gameOver = 0; head = 0;
 
        #20;
        reset = 0;

        #20;
        head = 1;
        apple = 1;
        
        #10; 
        apple = 0; 
        head = 0;

        #20;
        head = 0;
        apple = 0;
        gameOver = 0;

        // Test: Game Over (S1 -> S3)
        head = 1; border = 1; gameOver = 1; // Trigger game over
        #10;

        // Test: Reset after Game Over (S3 -> S0)
        reset = 1;
        #20;
        reset = 0;

        // Test: Victory Condition (S1 -> S4)
        gameOver = 0;
        head = 1;
        apple = 1;
        #10;
        apple = 0;
        head = 0;
        #20;
        repeat (6) begin // Simulate eating 6 apples
            head = 1;
            apple = 1;
            #10;
            apple = 0;
            head = 0;
            #40;
        end

        $finish;
    end
endmodule
