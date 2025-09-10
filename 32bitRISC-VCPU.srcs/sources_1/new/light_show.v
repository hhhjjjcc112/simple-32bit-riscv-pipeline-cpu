`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/09/10 13:26:28
// Design Name: 
// Module Name: light_show
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module light_show(                  //������������˿�
    input wire clk,              //����ʱ��
    input wire rst_n,           //��λ�źţ��͵�ƽ��Ч
    input wire [31:0] numbers,   //����8������,ÿ4-bit��ʾһ������
    output reg [7:0] disp_low,        //�߶������LED�ź�+С����
    output reg [7:0] disp_high,       //�߶������LED�ź�+С����
    output reg [3:0] digit_low,         //�߶�����ܶ�ѡ�ź�, ��4������
    output reg [7:0] digit_high         //�߶�����ܶ�ѡ�ź�, ��4������
);
    
    reg  [3:0]  number_low, number_high;             //��ǰ��ʾ��4-bit���ݼĴ��� 
    reg  [3:0]  segment_low, segment_high;          //��ѡ�źżĴ���

    reg [31:0] count; //������
    parameter MAX_COUNT = 100000; //���������ֵ��50MHzʱ���£�50000��Ӧ1ms

    parameter ZERO = 8'b11111100; //0
    parameter ONE  = 8'b01100000; //1
    parameter TWO  = 8'b11011010; //2
    parameter THREE= 8'b11110010; //3
    parameter FOUR = 8'b01100110; //4
    parameter FIVE = 8'b10110110; //5
    parameter SIX  = 8'b10111110; //6
    parameter SEVEN= 8'b11100000; //7
    parameter EIGHT= 8'b11111110; //8
    parameter NINE = 8'b11110110; //9
    parameter A    = 8'b11101110; //A
    parameter B    = 8'b00111110; //B
    parameter C    = 8'b10011100; //C
    parameter D    = 8'b01111010; //D
    parameter E    = 8'b10011110; //E
    parameter F    = 8'b10001110; //F

    parameter DOT = 8'b00000001; //С����
    
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            number_low <= 4'b0000;
            number_high <= 4'b0000;
            segment_low <= 4'b1000;
            segment_high <= 4'b1000;

            disp_low <= ZERO;
            disp_high <= ZERO;
            digit_low <= 4'b0001;
            digit_high <= 4'b0001;

            count <= 32'd0;

        end
        else begin
            //������
            if(count == MAX_COUNT) begin
                count <= 32'd0;
                case(segment_low)
                    4'b1000: begin
                        number_low <= numbers[3:0];
                        segment_low <= 4'b0001;
                    end
                    4'b0001: begin
                        number_low <= numbers[7:4];
                        segment_low <= 4'b0010;
                    end
                    4'b0010: begin
                        number_low <= numbers[11:8];
                        segment_low <= 4'b0100;
                    end
                    4'b0100: begin
                        number_low <= numbers[15:12];
                        segment_low <= 4'b1000;
                    end
                    default: segment_low <= 4'b0001;
                endcase

                case (segment_high)
                    4'b1000: begin
                        number_high <= numbers[19:16];
                        segment_high <= 4'b0001;
                    end
                    4'b0001: begin
                        number_high <= numbers[23:20];
                        segment_high <= 4'b0010;
                    end
                    4'b0010: begin
                        number_high <= numbers[27:24];
                        segment_high <= 4'b0100;
                    end
                    4'b0100: begin
                        number_high <= numbers[31:28];
                        segment_high <= 4'b1000;
                    end
                    default: segment_high <= 4'b0001;
                endcase

                case (number_low)          //led���ź�
                    4'b0000: disp_low <= ZERO;
                    4'b0001: disp_low <= ONE;
                    4'b0010: disp_low <= TWO;
                    4'b0011: disp_low <= THREE;
                    4'b0100: disp_low <= FOUR;
                    4'b0101: disp_low <= FIVE;
                    4'b0110: disp_low <= SIX;
                    4'b0111: disp_low <= SEVEN;
                    4'b1000: disp_low <= EIGHT;
                    4'b1001: disp_low <= NINE;
                    4'b1010: disp_low <= A;
                    4'b1011: disp_low <= B;
                    4'b1100: disp_low <= C;
                    4'b1101: disp_low <= D;
                    4'b1110: disp_low <= E;
                    4'b1111: disp_low <= F;
                    default: disp_low <= ZERO;
                endcase

                case (number_high)
                    4'b0000: disp_high <= ZERO;
                    4'b0001: disp_high <= ONE;
                    4'b0010: disp_high <= TWO;
                    4'b0011: disp_high <= THREE;
                    4'b0100: disp_high <= FOUR;
                    4'b0101: disp_high <= FIVE;
                    4'b0110: disp_high <= SIX;
                    4'b0111: disp_high <= SEVEN;
                    4'b1000: disp_high <= EIGHT;
                    4'b1001: disp_high <= NINE;
                    4'b1010: disp_high <= A;
                    4'b1011: disp_high <= B;
                    4'b1100: disp_high <= C;
                    4'b1101: disp_high <= D;
                    4'b1110: disp_high <= E;
                    4'b1111: disp_high <= F;
                    default: disp_high <= ZERO;
                endcase
                //��ѡ�ź�
                digit_low <= segment_low;
                digit_high <= segment_high;

            end
            else begin
                count <= count + 1'b1;
            end
        end
    end
     
endmodule
