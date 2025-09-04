`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/27 18:23:43
// Design Name: 
// Module Name: if_stage
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


module if_stage(
    input wire        clk,
    input wire        rst_n,
    input wire        load_use_hazard,      // ����ʹ��ð���ź�
    input wire        control_hazard,       // ����ð���ź�
    input wire [31:0] correct_pc,        // ��ȷ��PCֵ
    output reg [31:0] pc_predict,    // Ԥ���PCֵ
    output reg [31:0] pc_out,            // ���������
    output reg [31:0] instruction    // ��ǰָ��
);

// ָ��洢������ʵ�֣�
reg [31:0] instruction_memory [255:0]; // 256��ָ��

// ��ʼ��ָ��洢�������Գ���
initial begin
    // ���ز��Գ���ָ��洢��
    $readmemh("../../../../test_program.hex", instruction_memory);
end

// PC�����߼�
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pc_predict <= 32'd0;
        pc_out <= 32'd0;
        instruction <= 32'd0;
    end else if (load_use_hazard) begin
        // ���ֵ�ǰ״̬��������
    end else if (control_hazard) begin
        // ��������ð�գ���ת����ȷ��PC
        pc_predict <= correct_pc + 32'd4; // Ԥ����һ��PC
        pc_out <= correct_pc;
        instruction <= instruction_memory[correct_pc[9:2]];
    end else begin
        // ����˳��ִ��
        pc_predict <= pc_predict + 32'd4; // Ԥ����һ��PC
        pc_out <= pc_predict;
        instruction <= instruction_memory[pc_predict[9:2]];
    end
end

endmodule

