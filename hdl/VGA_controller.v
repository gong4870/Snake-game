`default_nettype none

module snake(
    input wire CLK100MHZ, reset, update_clk, update_clk_fast,
    input wire [9:0] randX, 
    input wire [8:0] randY, 
    input wire [3:0] direction,
    input wire [2:0] length,
    input wire over, level,
    input wire i_speaker,
    
    output wire VGA_HS, VGA_VS,
    output wire [11:0] vga,
    output reg border, 
    output reg head,
    output reg apple, gameOver
    );

    localparam COLOR_WHITE  = 12'b1111_1111_1111;
    localparam COLOR_RED    = 12'b0000_0000_1111;
    localparam COLOR_border = 12'b1111_0000_1111;
    localparam COLOR_BLACK  = 12'b0000_0000_0000;
    localparam COLOR_BROWN  = 12'b0010_0101_1010;
    localparam COLOR_GREEN  = 12'b0000_1111_0000;

    localparam GRID_SIZE = 32; 
    localparam NUM_CELLS_X = 16; 
    localparam NUM_CELLS_Y = 12; 

    localparam X_OFFSET = (640 - (NUM_CELLS_X * GRID_SIZE)) / 2; 
    localparam Y_OFFSET = (480 - (NUM_CELLS_Y * GRID_SIZE)) / 2; 

    localparam A_X_OFFSET = (640 - ((NUM_CELLS_X-2) * GRID_SIZE)) / 2; 
    localparam A_Y_OFFSET = (480 - ((NUM_CELLS_Y-2) * GRID_SIZE)) / 2; 

    wire video_on, block_on;
    wire pixel_clk;
    reg inX, inY;
    reg [9:0] appleX, appleY;

    wire [9:0] xCount, yCount;
    reg [3:0] snake_x_grid, snake_y_grid;  // snake position in grid
    reg [3:0] body_x_grid[7:0], body_y_grid[7:0]; // Snake body positions
    reg [11:0] vga_next, vga_reg;
    reg body0, body1, body2, body3, body4, body5;
    reg giftbox, ribbon;

    controller VGA_controller_1(
        .clk(CLK100MHZ), .reset(reset),
        .hsync(VGA_HS), .vsync(VGA_VS),
        .video_on(video_on), .pixel_clk(pixel_clk),
        .pixel_x(xCount), .pixel_y(yCount)
    );

    always @(posedge CLK100MHZ, posedge reset)
    begin
        if (reset)
            vga_reg <= 12'd0;
        else if (pixel_clk)
            vga_reg <= vga_next;
    end

    always @* begin
    vga_next = COLOR_BLACK; 
    if (~video_on)
        vga_next = COLOR_BLACK;
    else if(over)begin
        vga_next = border ? COLOR_border : COLOR_BLACK;
    end
    else if(i_speaker)begin
        if (giftbox && !(ribbon && giftbox))vga_next = COLOR_RED;
        else if (ribbon && giftbox)vga_next = COLOR_GREEN;
        else if (ribbon)vga_next = COLOR_GREEN;
        else vga_next = COLOR_border;
    end
    else begin
        case (length)
            3'd0: if (border)vga_next = COLOR_border;
            else if (apple)vga_next = COLOR_RED;
            else if (head)vga_next = COLOR_BROWN;
            else vga_next = COLOR_WHITE;
            3'd1: if (border)vga_next = COLOR_border;
            else if (apple)vga_next = COLOR_GREEN;
            else if (head)vga_next = COLOR_BROWN;
            else if (body0)vga_next = COLOR_RED;
            else vga_next = COLOR_WHITE;
            3'd2: if (border)vga_next = COLOR_border;
            else if (apple||body0)vga_next = COLOR_RED;
            else if (head)vga_next = COLOR_BROWN;
            else if (body1)vga_next = COLOR_GREEN;
            else vga_next = COLOR_WHITE;
            3'd3:if (border)vga_next = COLOR_border;
            else if (apple||body1)vga_next = COLOR_GREEN;
            else if (head)vga_next = COLOR_BROWN;
            else if (body0||body2)vga_next = COLOR_RED;
            else vga_next = COLOR_WHITE;
            3'd4:if (border)vga_next = COLOR_border;
            else if (apple||body0)vga_next = COLOR_RED;
            else if (head)vga_next = COLOR_BROWN;
            else if (body1||body3)vga_next = COLOR_GREEN;
            else if (body2)vga_next = COLOR_RED;
            else vga_next = COLOR_WHITE;
            3'd5:if (border)vga_next = COLOR_border;
            else if (apple||body1||body3)vga_next = COLOR_GREEN;
            else if (head)vga_next = COLOR_BROWN;
            else if (body0||body2||body4)vga_next = COLOR_RED;
            else vga_next = COLOR_WHITE; 
            3'd6:if (border)vga_next = COLOR_border;
            else if (apple||body0||body2||body4)vga_next = COLOR_RED;
            else if (head)vga_next = COLOR_BROWN;
            else if (body1||body3||body5)vga_next = COLOR_GREEN;
            else vga_next = COLOR_WHITE;
            default: vga_next = COLOR_WHITE; // Default color
        endcase
        end
    end

    localparam APPLE_SIZE = GRID_SIZE - 4; // 사과를 28x28로 줄임
    
    always @(posedge pixel_clk) begin
        inX <= (xCount >= (appleX * GRID_SIZE + A_Y_OFFSET + 2) && xCount < (appleX * GRID_SIZE + A_X_OFFSET + APPLE_SIZE + 2));
        inY <= (yCount >= (appleY * GRID_SIZE + A_Y_OFFSET + 2) && yCount < (appleY * GRID_SIZE + A_Y_OFFSET + APPLE_SIZE + 2));
        apple <= inX && inY;
    end

    always @(posedge pixel_clk) begin
        border <= (
            ((xCount >= X_OFFSET) && (xCount < NUM_CELLS_X * GRID_SIZE + X_OFFSET) && (yCount >= Y_OFFSET) && (yCount < GRID_SIZE + Y_OFFSET)) ||
            ((xCount >= X_OFFSET) && (xCount < NUM_CELLS_X * GRID_SIZE + X_OFFSET) && (yCount >= (NUM_CELLS_Y - 1) * GRID_SIZE + (2*Y_OFFSET+16)) && (yCount < NUM_CELLS_Y * GRID_SIZE + (2*Y_OFFSET+16))) ||
            ((xCount >= X_OFFSET) && (xCount < GRID_SIZE + X_OFFSET) && (yCount >= Y_OFFSET) && (yCount < NUM_CELLS_Y * GRID_SIZE + (2*Y_OFFSET+16))) ||
            ((xCount >= (NUM_CELLS_X - 1) * GRID_SIZE + X_OFFSET) && (xCount < NUM_CELLS_X * GRID_SIZE + X_OFFSET) && (yCount >= Y_OFFSET) && (yCount < NUM_CELLS_Y * GRID_SIZE + (2*Y_OFFSET+16)))
        );
        giftbox <= (
            ((xCount >= 160) && (xCount < 480) && (yCount >= 120) && (yCount < 360))
        );
        ribbon <= ( 
            ((xCount >= 160) && (xCount < 480) && (yCount >= 220) && (yCount < 260)) ||
            ((xCount >= 300) && (xCount < 340) && (yCount >= 120) && (yCount < 360)) ||
            ((xCount >= 240) && (xCount < 400) && (yCount >= 110) && (yCount < 120)) ||
            ((xCount >= 240) && (xCount < 280) && (yCount >= 100) && (yCount < 110)) ||            
            ((xCount >= 360) && (xCount < 400) && (yCount >= 100) && (yCount < 110))
        );
    end

    always @(posedge pixel_clk) begin
        if (reset || gameOver) begin
            appleX <= randX / GRID_SIZE; 
            appleY <= randY / GRID_SIZE; 
        end else if (apple && head) begin
            appleX <= randX / GRID_SIZE;
            appleY <= randY / GRID_SIZE;
        end
    end

    always @(posedge CLK100MHZ or posedge reset) begin
        if (reset) begin
            snake_x_grid <= 4'd8;
            snake_y_grid <= 4'd6;
    
            body_x_grid[0] <= 4'd7;
            body_y_grid[0] <= 4'd6;
            body_x_grid[1] <= 4'd6;
            body_y_grid[1] <= 4'd6;
            body_x_grid[2] <= 4'd5;
            body_y_grid[2] <= 4'd6;
            body_x_grid[3] <= 4'd4;
            body_y_grid[3] <= 4'd6;
            body_x_grid[4] <= 4'd3;
            body_y_grid[4] <= 4'd6;
            body_x_grid[5] <= 4'd2;
            body_y_grid[5] <= 4'd6;
        end else if (level == 1) begin
            if(update_clk)begin
            case (direction)
                4'b0000: begin snake_x_grid <= snake_x_grid; snake_y_grid <= snake_y_grid; end // stop
                4'b0001: snake_x_grid <= snake_x_grid - 1; // Left
                4'b0010: snake_x_grid <= snake_x_grid + 1; // Right
                4'b0100: snake_y_grid <= snake_y_grid - 1; // Up
                4'b1000: snake_y_grid <= snake_y_grid + 1; // Down
                default: begin snake_x_grid <= snake_x_grid; snake_y_grid <= snake_y_grid; end// 유지
            endcase
    
            body_x_grid[5] <= body_x_grid[4];
            body_y_grid[5] <= body_y_grid[4];
            body_x_grid[4] <= body_x_grid[3];
            body_y_grid[4] <= body_y_grid[3];
            body_x_grid[3] <= body_x_grid[2];
            body_y_grid[3] <= body_y_grid[2];
            body_x_grid[2] <= body_x_grid[1];
            body_y_grid[2] <= body_y_grid[1];
            body_x_grid[1] <= body_x_grid[0];
            body_y_grid[1] <= body_y_grid[0];
            body_x_grid[0] <= snake_x_grid;
            body_y_grid[0] <= snake_y_grid;
        end end
        else if (level == 0) begin
            if(update_clk_fast)begin
            case (direction)
                4'b0000: begin snake_x_grid <= snake_x_grid; snake_y_grid <= snake_y_grid; end // stop
                4'b0001: snake_x_grid <= snake_x_grid - 1; // Left
                4'b0010: snake_x_grid <= snake_x_grid + 1; // Right
                4'b0100: snake_y_grid <= snake_y_grid - 1; // Up
                4'b1000: snake_y_grid <= snake_y_grid + 1; // Down
                default: begin snake_x_grid <= snake_x_grid; snake_y_grid <= snake_y_grid; end// 유지
            endcase

            body_x_grid[5] <= body_x_grid[4];
            body_y_grid[5] <= body_y_grid[4];
            body_x_grid[4] <= body_x_grid[3];
            body_y_grid[4] <= body_y_grid[3];
            body_x_grid[3] <= body_x_grid[2];
            body_y_grid[3] <= body_y_grid[2];
            body_x_grid[2] <= body_x_grid[1];
            body_y_grid[2] <= body_y_grid[1];
            body_x_grid[1] <= body_x_grid[0];
            body_y_grid[1] <= body_y_grid[0];
            body_x_grid[0] <= snake_x_grid;
            body_y_grid[0] <= snake_y_grid;
            end
        end
    end

    always @(posedge pixel_clk) begin
        head <= (xCount >= (snake_x_grid * GRID_SIZE + X_OFFSET) && xCount < ((snake_x_grid + 1) * GRID_SIZE + X_OFFSET)) &&
                (yCount >= (snake_y_grid * GRID_SIZE + Y_OFFSET) && yCount < ((snake_y_grid + 1) * GRID_SIZE + Y_OFFSET));

        // Snake body parts (each body part is drawn as a 32x32 square)
        body0 <= (xCount >= (body_x_grid[0] * GRID_SIZE + X_OFFSET) && xCount < ((body_x_grid[0] + 1) * GRID_SIZE + X_OFFSET)) &&
                 (yCount >= (body_y_grid[0] * GRID_SIZE + Y_OFFSET) && yCount < ((body_y_grid[0] + 1) * GRID_SIZE + Y_OFFSET));
        body1 <= (xCount >= (body_x_grid[1] * GRID_SIZE + X_OFFSET) && xCount < ((body_x_grid[1] + 1) * GRID_SIZE + X_OFFSET)) &&
                 (yCount >= (body_y_grid[1] * GRID_SIZE + Y_OFFSET) && yCount < ((body_y_grid[1] + 1) * GRID_SIZE + Y_OFFSET));
        body2 <= (xCount >= (body_x_grid[2] * GRID_SIZE + X_OFFSET) && xCount < ((body_x_grid[2] + 1) * GRID_SIZE + X_OFFSET)) &&
                 (yCount >= (body_y_grid[2] * GRID_SIZE + Y_OFFSET) && yCount < ((body_y_grid[2] + 1) * GRID_SIZE + Y_OFFSET));
        body3 <= (xCount >= (body_x_grid[3] * GRID_SIZE + X_OFFSET) && xCount < ((body_x_grid[3] + 1) * GRID_SIZE + X_OFFSET)) &&
                 (yCount >= (body_y_grid[3] * GRID_SIZE + Y_OFFSET) && yCount < ((body_y_grid[3] + 1) * GRID_SIZE + Y_OFFSET));
        body4 <= (xCount >= (body_x_grid[4] * GRID_SIZE + X_OFFSET) && xCount < ((body_x_grid[4] + 1) * GRID_SIZE + X_OFFSET)) &&
                 (yCount >= (body_y_grid[4] * GRID_SIZE + Y_OFFSET) && yCount < ((body_y_grid[4] + 1) * GRID_SIZE + Y_OFFSET));
        body5 <= (xCount >= (body_x_grid[5] * GRID_SIZE + X_OFFSET) && xCount < ((body_x_grid[5] + 1) * GRID_SIZE + X_OFFSET)) &&
                 (yCount >= (body_y_grid[5] * GRID_SIZE + Y_OFFSET) && yCount < ((body_y_grid[5] + 1) * GRID_SIZE + Y_OFFSET));
    end

    always @(posedge pixel_clk) begin
        case (length)
            3'd0: gameOver <= (border && head);
            3'd1: gameOver <= (border && head) || (head && body0);
            3'd2: gameOver <= (border && head) || (head && body0) || (head && body1);
            3'd3: gameOver <= (border && head) || (head && body0) || (head && body1) || (head && body2);
            3'd4: gameOver <= (border && head) || (head && body0) || (head && body1) || (head && body2) || (head && body3);
            3'd5: gameOver <= (border && head) || (head && body0) || (head && body1) || (head && body2) || (head && body3) || (head && body4);
            3'd6: gameOver <= (border && head) || (head && body0) || (head && body1) || (head && body2) || (head && body3) || (head && body4) || (head && body5);
        default: gameOver <= 0; // 기본 값
        endcase
    end
    // Output VGA signal
    assign vga = vga_reg;

endmodule
