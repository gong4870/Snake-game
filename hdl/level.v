`default_nettype none

module level(
    input wire clk, reset,
    input wire SW,
    output reg level
    );

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            level <= 0; // Reset 신호가 들어오면 level을 초기화
        end else begin
            if (SW == 1)
                level <= 1;
            else 
                level <= 0;
        end
    end

endmodule
