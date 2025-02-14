`default_nettype none

module Direction(
    input wire clk, l, r, u, d, reset,
    output reg [3:0] direction
    );
    always @(posedge clk, posedge reset) begin
        if(reset)
            direction <= 4'b0000;
        else if (l == 1) begin
            direction <= 4'b0001; // left
        end else if (r == 1) begin
            direction <= 4'b0010; // right
        end else if (u == 1) begin
            direction <= 4'b0100; // up
        end else if (d == 1) begin
            direction <= 4'b1000; // down
        end else begin
            direction <= direction; // keep last input
        end
    end
endmodule