`default_nettype none

module mux81(
    input wire [3:0] D0,D1,D2,D3,D4,D5,D6,D7, 
    input wire [2:0] sel,
    output reg[3:0] Y
);

    always@* begin
        case(sel)
        3'd0: Y = D0;
        3'd1: Y = D1;
        3'd2: Y = D2;
        3'd3: Y = D3;
        3'd4: Y = D4;
        3'd5: Y = D5;
        3'd6: Y = D6;
        default: Y = D7;
    endcase
end
    
endmodule

module cnt3 (
    input wire clk, reset,en, 
    output reg [2:0]Q
    );
    
always @(posedge clk, posedge reset)
   if(reset)
      Q <= 0;
   else if(en) begin
      if(Q == 3'd7)
        Q <= 0;
      else
        Q <= Q+1;
   end
   
endmodule

module decoder(
    input wire [2:0] sel, 
    output reg [7:0] enable
    );

always@*
begin
    case (sel)
        3'b000:  enable = ~8'b0000_0001;
        3'b001:  enable = ~8'b0000_0010;
        3'b010:  enable = ~8'b0000_0100;
        3'b011:  enable = ~8'b0000_1000;
        3'b100:  enable = ~8'b0001_0000;
        3'b101:  enable = ~8'b0010_0000;
        3'b110:  enable = ~8'b0100_0000;
        default: enable = ~8'b1000_0000;
    endcase
end

endmodule

module cnt_100M(
    input wire clk, 
    input wire rstn,
    output wire eo_100M, eo_100K, eo_1K
    );
    
    wire tc0, tc1, tc2, tc3, tc4, tc5, tc6, tc7;
    wire [3:0] Q100M;
    
    bcd_count u0(.TC(tc0), .inc(1'b1), .rstn(rstn), .clk(clk), .Q());
    bcd_count u1(.TC(tc1), .inc(tc0), .rstn(rstn), .clk(clk), .Q());
    bcd_count u2(.TC(tc2), .inc(tc1), .rstn(rstn), .clk(clk), .Q());
    bcd_count u3(.TC(tc3), .inc(tc2), .rstn(rstn), .clk(clk), .Q());
    bcd_count u4(.TC(tc4), .inc(tc3), .rstn(rstn), .clk(clk), .Q());
    bcd_count u5(.TC(tc5), .inc(tc4), .rstn(rstn), .clk(clk), .Q());
    bcd_count u6(.TC(tc6), .inc(tc5), .rstn(rstn), .clk(clk), .Q());
    bcd_count u7(.Q(Q100M), .TC(tc7), .inc(tc6), .rstn(rstn), .clk(clk));
    
    assign eo_100M = tc6;
    assign eo_100K = tc4;
    assign eo_1K = tc2;
    
    
endmodule


module bcd_count(
    input wire clk, rstn, inc, 
    output wire TC,
    output reg [3:0] Q 
    );
               
always @(posedge clk, posedge rstn)
   if(rstn)
      Q <= 0;
   else if(inc) begin
      if(Q == 'd9)
        Q <= 0;
      else
        Q <= Q+1;
   end
   
assign TC = (Q == 'd9 && inc)?1:0;
   
endmodule
