`default_nettype none

module top_module(
    input wire clk, reset, 
    input wire ps2clk,ps2data,
    input wire SW,
    output wire [11:0] vga,
    output wire h_sync, v_sync,
    output wire CA,CB,CC,CD,CE,CF,CG,
    output wire [7:0]AN,
    output wire green,red,blue,
    output wire speaker,
    output wire [5:0] led
    );
    wire VGA_clk_250, update_clk, update_clk_fast, clk_50, clk_25;
    wire level;
    wire [9:0] xCount, yCount;
    wire [3:0] direction;
    wire [9:0] randX;
    wire [8:0] randY;
    wire left,right,up,down;
    
    wire apple, border;
    wire gameOver, head;
    wire score, ld, over;
    wire o_speaker,i_speaker;
    wire [3:0] D0;
    wire [2:0] length;
    wire clk_100;
    
    control_unit U0(.clk(clk_100), .reset(reset), .apple(apple), .border(border), .gameOver(gameOver), .head(head),
                  .score(score), .ld(ld), .over(over), .i_speaker(i_speaker), .length(length));
    clk_wiz_0    U1(.clk_out1(clk_100),.clk_out2(VGA_clk_250),.clk_out3(clk_50),.clk_out4(clk_25),.reset(reset),.locked(),.clk_in1(clk));        
    btn_clk      U2(.clk(clk_100), .reset(reset), .update_clk(update_clk));
    btn_clk_fast U3(.clk(clk_100), .reset(reset), .update_clk(update_clk_fast));
 
    snake        U4(.CLK100MHZ(clk_100), .reset(reset), .update_clk(update_clk), .update_clk_fast(update_clk_fast), .VGA_HS(h_sync), 
                    .VGA_VS(v_sync), .vga(vga), .randX(randX), .randY(randY), .direction(direction), .level(level), .i_speaker(i_speaker), 
                    .apple(apple), .border(border), .gameOver(gameOver), .over(over), .head(head), .length(length));    
   
    Random       U5(.clk(clk_100), .reset(reset), .randX(randX), .randY(randY));
    Direction    U6(.clk(clk_100), .reset(reset), .l(left), .r(right), .u(up), .d(down), .direction(direction)); 
    Score        U7(.clk(clk_100), .reset(reset), .D0(D0), .A(CA),.B(CB),.C(CC),.D(CD),.E(CE),.F(CF),.G(CG),.AN(AN), .score(score), .ld(ld));

    LED          U8(.length(length),.led(led));
    RGB          U9(.gameOver(over),.i_speaker(i_speaker), .green(green),.red(red),.blue(blue));
    level        U10(.clk(clk_100), .reset(reset), .SW(SW), .level(level));
    
    ps2_kbd_top  U11 (.clk(clk_50), .rst(reset), .ps2clk(ps2clk), .ps2data(ps2data), .right(right),.left(left),.up(up),.down(down));                         
    music_i      U12(.clk(clk_25),.i_speaker(i_speaker),.speaker(speaker));    
    
endmodule
