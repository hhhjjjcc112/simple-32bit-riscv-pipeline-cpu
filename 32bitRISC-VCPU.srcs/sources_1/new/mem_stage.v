`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/27 18:23:43
// Design Name: 
// Module Name: mem_stage
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


module mem_stage(
    input wire        clk,
    input wire        rst_n,
    input wire [4:0]  rd_addr,   // Ŀ��Ĵ�����ַ
    input wire [31:0] alu_result, // ALU���
    input wire [31:0] rs2_data,   // Դ�Ĵ���2����
    input wire        reg_write,  // �Ĵ���дʹ��
    input wire        mem_read,   // �ڴ��ʹ��
    input wire        mem_write,  // �ڴ�дʹ��
    input wire        mem_to_reg, // д������ѡ��
    output reg [4:0]  rd_addr_out,   // Ŀ��Ĵ�����ַ���
    output reg [31:0] alu_result_out, // ALU������
    output reg [31:0] mem_data,      // �ڴ�����
    output reg        reg_write_out, // �Ĵ���дʹ�����
    output reg        mem_to_reg_out,// д������ѡ�����
    output reg [31:0] rs2_data_out  // Դ�Ĵ���2�������
);

// ���ݴ洢������ʵ�֣�
reg [31:0] data_memory [255:0]; // 256����

// �ڴ����
wire [31:0] mem_data_wire;
assign mem_data_wire = mem_read ? data_memory[alu_result[9:2]] : 32'd0;

// �ڴ�д����
always @(posedge clk) begin
    if (mem_write) begin
        data_memory[alu_result[9:2]] <= rs2_data;
    end
end

// ��ˮ�߼Ĵ�������
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        rd_addr_out <= 5'd0;
        alu_result_out <= 32'd0;
        mem_data <= 32'd0;
        reg_write_out <= 1'b0;
        mem_to_reg_out <= 1'b0;
        rs2_data_out <= 32'd0;
    end else begin
        // ��������
        rd_addr_out <= rd_addr;
        alu_result_out <= alu_result;
        mem_data <= mem_data_wire;
        reg_write_out <= reg_write;
        mem_to_reg_out <= mem_to_reg;
        rs2_data_out <= (mem_write) ? rs2_data : 32'd0;
    end
end

endmodule
