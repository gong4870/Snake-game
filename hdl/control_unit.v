`default_nettype none

module control_unit(
    input wire clk, reset,
    input wire apple, border,
    input wire gameOver, head,
    output reg [2:0] length,
    output reg score, ld,i_speaker, over
    );
    reg [3:0] cst, nst;
    reg apple_eaten; 

    parameter S0 = 4'b0000,
              S1 = 4'b0001,
              S2 = 4'b0010,
              S3 = 4'b0011,
              S4 = 4'b0100;
    
    always@(posedge clk, posedge reset) begin
        if (reset) begin
            cst <= S0;
            length <= 0;
            apple_eaten <= 1'b0;
        end 
        else begin
            if (cst == S2) begin
                length <= length + 3'd1; 
                apple_eaten <= 1'b1; 
            end
            if (cst == S1 && ~head && ~apple) begin
                apple_eaten <= 1'b0; 
            end
            cst <= nst;
        end
    end
    
    always@(*) begin
        case(cst)
            S0: if (reset) nst = S0; else nst = S1;
            S1: if (head && apple && ~apple_eaten) nst = S2; 
                else if(length == 3'd6) nst = S4;
                else if (gameOver) nst = S3;
                else nst = S1;
            S2: nst = S1;
            S3: if (reset) nst = S0; else nst = S3; 
            S4: if (reset) nst = S0; else nst = S4;
            default: nst = S0;
        endcase
    end
    
    always @(*) begin
        ld = 1'b0;
        score = 1'b0;
        i_speaker =1'b0;
        over = 1'b0;
        
        case (cst)
            S0: {ld, score, i_speaker, over} = 4'b0000;
            S1: {ld, score, i_speaker, over} = 4'b1000;
            S2: {ld, score, i_speaker, over} = 4'b1100;
            S3: {ld, score, i_speaker, over} = 4'b0001;
            S4: {ld, score, i_speaker, over} = 4'b0010;
            default: {ld, score, i_speaker, over} = 4'b0000;
        endcase
    end
endmodule
