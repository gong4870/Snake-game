`default_nettype none
`timescale 1ns/1ps

module top_module_tb;

    // Inputs
    reg clk;             // 기본 시스템 클럭
    reg reset;           // 리셋 신호
    reg ps2clk;          // PS/2 키보드 클럭
    reg ps2data;         // PS/2 키보드 데이터
    reg SW;              // 스위치 신호 (난이도 선택용)

    // Outputs
    wire [11:0] vga;     // VGA 신호
    wire h_sync, v_sync; // VGA 수평/수직 동기 신호
    wire CA, CB, CC, CD, CE, CF, CG; // 7-세그먼트 출력
    wire [7:0] AN;       // 7-세그먼트 선택 신호
    wire green, red, blue; // RGB LED 출력
    wire speaker;        // 스피커 출력
    wire [5:0] led;      // LED 출력
    
    // Instantiate the DUT (Device Under Test)
    top_module DUT (
        .clk(clk),
        .reset(reset),
        .ps2clk(ps2clk),
        .ps2data(ps2data),
        .SW(SW),
        .vga(vga),
        .h_sync(h_sync),
        .v_sync(v_sync),
        .CA(CA), .CB(CB), .CC(CC), .CD(CD), .CE(CE), .CF(CF), .CG(CG),
        .AN(AN),
        .green(green),
        .red(red),
        .blue(blue),
        .speaker(speaker),
        .led(led)
    );

    // Clock Generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz clock (10ns 주기)
    end
    
    // PS2 Clock Generation (임의의 신호 생성)
    initial begin
        ps2clk = 0;
        forever #50 ps2clk = ~ps2clk; // 50ns 주기 (20MHz)
    end

    // Simulation inputs
    initial begin
        // 초기화
        reset = 1; SW = 0; ps2data = 1;
        #50;
        reset = 0; // 리셋 해제
        
        // 테스트 시나리오 1: 기본 동작 확인
        #100;
        SW = 1; // 난이도 변경
        #100;


        // 테스트 시나리오 3: 게임 오버 조건
        reset = 1;
        #50 reset = 0;
        #500000;

        // 시뮬레이션 종료
        $finish;
    end
    


endmodule
