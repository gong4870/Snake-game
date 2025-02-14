`default_nettype none

module RGB(
    input wire gameOver,i_speaker,
    output reg green,
    output reg red,blue);
       
    always@* begin
        if(gameOver)begin
            red = 0;
            green = 0;
            blue =1;
            end
        else if(i_speaker)begin
            red = 1;
            green = 0;
            blue =0;
    end
    else begin
    red = 0;
    green = 1;
    blue = 0;
    end
    end
                
endmodule

