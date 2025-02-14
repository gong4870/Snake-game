`default_nettype none

module LED(
    input wire [2:0] length,
    output reg [5:0] led
    );        
            
    always@*begin
        case(length)
            3'd0: led = 6'b111111;
            3'd1: led = 6'b011111;
            3'd2: led = 6'b001111;
            3'd3: led = 6'b000111;
            3'd4: led = 6'b000011;
            3'd5: led = 6'b000001;
            default:led = 6'b000000;
        endcase
    end 
endmodule
