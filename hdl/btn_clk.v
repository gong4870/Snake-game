module btn_clk (
    input wire clk, reset, 
    output reg update_clk
);

    reg [26:0] check;  

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            update_clk <= 0;
            check <= 0;
        end else if (check < 100000000) begin // 100 MHz / 1 Hz = 100,000,000
            check <= check + 1;
            update_clk <= 0; 
        end else begin
            check <= 0; 
            update_clk <= 1;
        end
    end

endmodule
