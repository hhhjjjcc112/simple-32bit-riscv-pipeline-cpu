`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/27 18:23:43
// Design Name: 
// Module Name: alu
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


module alu(
    input wire [31:0] a,      // ������1
    input wire [31:0] b,      // ������2
    input wire [3:0]  alu_op, // ALU������
    output reg [31:0] result, // ���
    output reg        zero     // ���־λ
);

// ALU�����붨��
localparam ALU_ADD  = 4'b0000; // �ӷ�
localparam ALU_SUB  = 4'b0001; // ����
localparam ALU_AND  = 4'b0010; // �߼���
localparam ALU_OR   = 4'b0011; // �߼���
localparam ALU_XOR  = 4'b0100; // �߼����
localparam ALU_SLT  = 4'b0101; // �з���С��
localparam ALU_SLTU = 4'b0110; // �޷���С��
localparam ALU_SLL  = 4'b0111; // �߼�����
localparam ALU_SRL  = 4'b1000; // �߼�����
localparam ALU_SRA  = 4'b1001; // ��������

always @(*) begin
    case (alu_op)
        ALU_ADD:  result = a + b;
        ALU_SUB:  result = a - b;
        ALU_AND:  result = a & b;
        ALU_OR:   result = a | b;
        ALU_XOR:  result = a ^ b;
        ALU_SLT:  result = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
        ALU_SLTU: result = (a < b) ? 32'd1 : 32'd0;
        ALU_SLL:  result = a << b[4:0];
        ALU_SRL:  result = a >> b[4:0];
        ALU_SRA:  result = $signed(a) >>> b[4:0];
        default:  result = 32'd0;
    endcase
    
    zero = (result == 32'd0);
end

endmodule

