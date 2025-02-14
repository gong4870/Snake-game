`default_nettype none

module Random(
    input wire clk,
    input wire reset,
    output reg [9:0] randX,
    output reg [8:0] randY
    );
    reg [15:0] lfsrX = 16'hACE1; 
    reg [15:0] lfsrY = 16'hC0DE;  

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsrX <= 16'hACE1; 
        end else begin
            lfsrX <= {lfsrX[14:0], lfsrX[16] ^ lfsrX[14] ^ lfsrX[13] ^ lfsrX[11]}; // LFSR
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsrY <= 16'hC0DE; 
        end else begin
            lfsrY <= {lfsrY[14:0], lfsrY[16] ^ lfsrY[14] ^ lfsrY[13] ^ lfsrY[11]}; // LFSR
        end
    end

    always @(posedge clk) begin
        randX <= (lfsrX[9:0] % 261) + 90;  // X 범위: 90~350
        randY <= (lfsrY[8:0] % 261) + 90;  // Y 범위: 90~350
    end
endmodule
