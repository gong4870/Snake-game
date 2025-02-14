`default_nettype none

module Score(
    input wire clk,reset,
    
    input wire score, ld,
    output wire [3:0]D0,
    output reg A,B,C,D,E,F,G,
    output wire [7:0] AN
    );
    wire [3:0] Y;
    wire [2:0]sel;
    wire en_cnt3;
    wire score_en;
    
    mux81 seg_u0 (.D0(D0), .D1(), .D2(), .D3(), .D4(), .D5(), .D6(), .D7(), .sel(sel), .Y(Y)); //cnt3에 때라 D0에 들어가는 숫자가 바뀜
    cnt3 seg_u1(.clk(clk), .reset(reset), .en(en_cnt3), .Q(sel)); 
    decoder seg_u3(.sel(sel), .enable(AN));
    cnt_100M seg_u4 (.clk(clk), .rstn(reset), .eo_100K(en_cnt3), .eo_1K(), .eo_100M());
    
    always @(*)
    begin
        case(Y)
            4'b0000 : {A,B,C,D,E,F,G} = 7'b0000001;  //0
            4'b0001 : {A,B,C,D,E,F,G} = 7'b1001111;  //1
            4'b0010 : {A,B,C,D,E,F,G} = 7'b0010010;  //2
            4'b0011 : {A,B,C,D,E,F,G} = 7'b0000110;  //3
            4'b0100 : {A,B,C,D,E,F,G} = 7'b1001100;  //4
            4'b0101 : {A,B,C,D,E,F,G} = 7'b0100100;  //5
            4'b0110 : {A,B,C,D,E,F,G} = 7'b0100000;  //6
            4'b0111 : {A,B,C,D,E,F,G} = 7'b0001111;  //7
            4'b1000 : {A,B,C,D,E,F,G} = 7'b0000000;  //8
            4'b1001 : {A,B,C,D,E,F,G} = 7'b0000100;  //9
            4'b1010 : {A,B,C,D,E,F,G} = 7'b0001000;  //A
            4'b1011 : {A,B,C,D,E,F,G} = 7'b1100000;  //B
            4'b1100 : {A,B,C,D,E,F,G} = 7'b0110001;  //C
            4'b1101 : {A,B,C,D,E,F,G} = 7'b1000010;  //D
            4'b1110 : {A,B,C,D,E,F,G} = 7'b0110000;  //E
            4'b1111 : {A,B,C,D,E,F,G} = 7'b0111000;  //F
            
            default : {A,B,C,D,E,F,G} = 7'b1111111;
        endcase
    end
    
    bcd_count U11(.clk(clk), .rstn(reset), .inc(score&ld), .TC(score_en), .Q(D0));
 
endmodule
