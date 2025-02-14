# Snake-game
Snake game written in verilog

사용 보드 - Nexy-A7

본 프로젝트의 목적은 크리스마스 특집 SNACK GAME을 응용하여 미니 게임을 개
발하는 것이다. 게임은 플레이어가 갈색 네모 루돌프를 조작하여 빨간색과 초록색
선물을 모으는 과정에서 재미와 성취감을 느낄 수 있게 설계하였다.
특히, 선물을 모으는 과정에서 갈색 네모에 선물들이 연결되어 길이가 점차 늘어나고
이를 통해 플레이어는 게임의 진행 상황을 시각적으로 확인할 수 있다. 최대 6
개의 선물을 모으면 성공하는 게임이다.

![image](https://github.com/user-attachments/assets/dc5b8dc0-2881-468f-982f-a33f4d181622)

I. Control_unit
게임 상태를 관리하며, ”사과를 먹었는지”, “게임이 끝났는지”, ”게임 승리 조건을
달성했는지”등을 다룬다.

II. clk_wiz_0
음악의 재생을 위한 25MHZ clock과 키보드 인식을 위한 50MHZ cloclk를
clocking wiz에서 생성한다.

III. btn_clk
이 모듈은 snacke의 움직이는 속도를 늦추기 위해 사용되며, 100MHz 입력 클
럭을 기준으로 50,000,000클럭 주기 마다 update_clk 신호를 생성한다. 이 신
호는 약 0.5초의 주기로 작동하여, 0.5Hz의 클럭 신호를 출력한다.

IV. btn_clk_fast
이 모듈은 snack의 움직임을 기존의 움직임보다 빠르게 하여 Hard Mode를 구
현하기 위한 clkgenerator이다. 100MHz 입력 클럭을 기준으로 25,000,000클럭
주기마다 update_clk_faster 신호를 생성한다. 이 신호는 0.25초의 주기로 작동
하며 최종적으로 4Hz의 클럭 신호를 출력한다.

V. VGA_controller
i. VGA 디스플레이로 게임을 구현하여 화면에 출력한다.
ii. 루돌프의 움직임과 충돌 감지, 선물(giftbox) 및 경계(Border) 논리 구현.
iii. update_clk 과 update_clk_fast을 이용해 게임 레벨에 따라 루돌프의 속도
를 조절
iv. 선물의 길이 증가와 게임 종료(Game Over) 조건 처리.

VI. Random
이 모듈은 gift(선물)의 랜덤한 위치를 생성하기 위한 모듈이다. Linear
Feadback Shift Register(LFSR)를 사용하여 X좌표와 Y좌표를 생성하는 랜덤 좌표
생성기이다.

VII. Direction
이 모듈은 키보드에서 입력된 방향 신호(right, left, up, down)를 하나의 신호로
변환하여 VGA_controller에 전달하기 위한 멀티플렉서(MUX) 역할을 한다.

VIII. Score
이 모듈은 controller에서 출력된 length의 신호를 사용하여 게임에서 획득한
선물의 개수를 7-Segmet Display를 통해 표시하는 역할을 한다. 입력신호
score, ld를 기반으로 점수를 증가시키고 이를 7-segement에 출력하는 역할을
한다.

IX. LED
이 모듈은 획득해야 할 남은 선물의 개수를 LED로 표시하는 역할을 한다. 입
력된 length 신호(현재 획득한 선물의 개수)를 기준으로, 총 6개의 선물 중 남
은 선물을 LED로 표현한다.

X. RGB
이 모듈은 controller에서 출력된 gameOver(게임 오버) 신호와 i_speaker(승리)
신호를 사용하여 RGB LED의 색상을 제어한다.
i. 게임 중에는 초록 불이 켜진다.
ii. 게임 오버 일 때는 파란색 불이 켜진다.
iii. 승리 시에는 빨간색 불이켜진다.

XI. Level
이 모듈은 게임이 Hard Mode인지 일반 모드인지를 결정하는 역할을 한다. 입
력 신호 SW(스위치)를 기분으로 level 값을 설정하며, 이를 VGA_controller 등
에 전달하여 게임의 난이도를 제어한다.

XII. ps2_example
이 모듈은 키보드 입력을 통해 루돌프의 이동방향(right, left, up,down)을 결정
하는 신호로 변환하는 역할을 한다. PS/2 키보드로부터 스캔 코드를 읽어 해당
키의 방향 상태(up,down,right,left)로 변환하고 이를 VGA로 전달한다.

XIII. music_i
이 모듈은 게임에서 이겼을 때 ‘루돌프 사슴코’ 멜로디를 연주하는 역할을 한
다. FPGA에서 사운드를 생성하는 모듈로 주어진 음악 데이터(note와 옥타브)를
기반으로 PWM 방식의 스피커 출력을 생성한다.

![image](https://github.com/user-attachments/assets/f996f239-0171-4bea-a015-c12f1bb1dfe9)

<사용법 설명 및 데모 화면 캡쳐>

I. 게임 시작 초기 화면
![image](https://github.com/user-attachments/assets/c3e3103f-91da-402f-8d6f-b72462ebc2ee)

게임이 시작되면 화면에 루돌프가 처음 위치에 있고 선물이 랜덤으로 배정되
어 있는 것을 확인할 수 있다. FPGA보드를 보면 아무 상자를 얻지 못해서
segment에는 0, led는 6개 모두 켜져 있는 것을 확인할 수 있다. 또한 초록빛
을 통해 게임이 끝나지 않았음을 시각적으로 확인할 수 있다. 여기서 SW0가 0
이면 hard mode, 1이면 easy mode로 게임 난이도를 정할 수 있다. Mode를 정
했다면 키보드의 방향키를 눌러 테두리를 피해 루돌프를 움직이면 된다.

II. 게임 진행 중
![image](https://github.com/user-attachments/assets/ba56a2fb-dc9c-4541-b445-f16999b42c9c)

루돌프가 랜덤으로 배치된 선물을 얻으면 뒤에 선물이 따라온다. (=snake 몸
길이 증가) 얻은 선물의 색깔 대로 뒤에 똑같은 색깔로 따라오는 것을 확인할
수 있다. FPGA 보드를 보면 선물을 네 개 먹었기 때문에 segment에 4가 나타
나고 남은 선물 숫자인 2개의 led와 게임이 진행중이라는 초록 빛을 확인할
수 있다. 

III. 게임 종료 (gameover이 되었을 때)
![image](https://github.com/user-attachments/assets/46b934fb-4e48-4245-9d8b-528ae08aa3c7)

루돌프가 뒤에 따라오던 선물이나 테두리에 부딪혔을 때는 gameover이다. 화
면에 보이듯이 테두리는 남아있고 검은 화면이 뜬다. FPGA보드에는 이전까지
얻었던 점수와 못 먹은 선물의 개수(led) 그리고 빨간색 불빛으로 gameover가
되었음을 시각적으로 확인할 수 있다.

IV. 게암 종료 (win일 때)
![image](https://github.com/user-attachments/assets/b4d65d0b-7229-45a6-a84b-6a872212677c)

루돌프가 선물을 6개 모두 모았을 때는 화면에 선물 그림이 나타나는 것을 확
인할 수 있다. FPGA보드를 보면 선물 6개를 모두 모았기 때문에 segment에는
6이 떠있고 남은 선물의 개수는 없기 때문에 led는 모두 꺼져 있다. 마지막으
로 빨간 불빛으로 게임을 이겼다는 것을 시각적으로 확인할 수 있다.














































