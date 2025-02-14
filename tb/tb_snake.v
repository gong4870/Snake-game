`default_nettype none

module tb_snake;

    // 테스트를 위한 신호 선언
    reg CLK100MHZ;          // 입력 클럭
    reg reset;              // 리셋 신호
    reg update_clk;         // Snake 업데이트 클럭 (느린 속도)
    reg update_clk_fast;    // Snake 업데이트 클럭 (빠른 속도)
    reg [9:0] randX;        // 랜덤 X 좌표 입력
    reg [8:0] randY;        // 랜덤 Y 좌표 입력
    reg [3:0] direction;    // 방향 입력
    reg [2:0] length;       // Snake 길이
    reg over;               // 게임 오버 신호
    reg level;              // 레벨 (0: 빠른 속도, 1: 느린 속도)
    reg i_speaker;          // 스피커 제어 입력
    
    wire VGA_HS, VGA_VS;    // VGA 신호
    wire [11:0] vga;        // VGA 데이터 (컬러)
    wire border, head, apple, gameOver; // 게임 상태 출력
    
    // DUT (Design Under Test) 인스턴스화
    snake DUT (
        .CLK100MHZ(CLK100MHZ),
        .reset(reset),
        .update_clk(update_clk),
        .update_clk_fast(update_clk_fast),
        .randX(randX),
        .randY(randY),
        .direction(direction),
        .length(length),
        .over(over),
        .level(level),
        .i_speaker(i_speaker),
        .VGA_HS(VGA_HS),
        .VGA_VS(VGA_VS),
        .vga(vga),
        .border(border),
        .head(head),
        .apple(apple),
        .gameOver(gameOver)
    );

    // 클럭 생성 (100 MHz)
    initial begin
        CLK100MHZ = 0;
        forever #5 CLK100MHZ = ~CLK100MHZ; // 10ns 주기 (100MHz)
    end

    // 테스트 시나리오
    initial begin
        // 초기화
        reset = 1; update_clk = 0; update_clk_fast = 0;
        randX = 10'd160; randY = 9'd120;
        direction = 4'b0000; // 초기 방향: 멈춤
        length = 3'd0;
        over = 0; level = 1; i_speaker = 0;

        // 리셋 해제
        #20 reset = 0;

        // Snake가 오른쪽으로 이동 시작
        #50 direction = 4'b0010; // Right
        update_clk = 1;
        #100 update_clk = 0; 

        // Snake가 아래로 이동
        #200 direction = 4'b1000; // Down
        update_clk = 1;
        #100 update_clk = 0;

        // Snake가 사과를 먹음
        randX = 10'd192; randY = 9'd152; // 새로운 사과 위치
        #200 direction = 4'b0010; // Right

        // 게임 오버 테스트 (벽에 충돌)
        #500 direction = 4'b0001; // Left (벽으로 이동)
        #300 update_clk = 1;
        #100 update_clk = 0;

        // 게임 오버 시나리오
        over = 1;

        // 시뮬레이션 종료
        #1000 $finish;
    end

endmodule
