`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/27 18:23:43
// Design Name: 
// Module Name: regfile
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


module regfile(
    input wire        clk,
    input wire        rst_n,
    input wire [4:0]  rs1_addr,    // Դ�Ĵ���1��ַ
    input wire [4:0]  rs2_addr,    // Դ�Ĵ���2��ַ
    input wire [4:0]  rd_addr,     // Ŀ��Ĵ�����ַ
    input wire [31:0] rd_data,     // д������
    input wire        reg_write,   // �Ĵ���дʹ��
    output wire [31:0] rs1_data,   // Դ�Ĵ���1����
    output wire [31:0] rs2_data    // Դ�Ĵ���2����
);

reg [31:0] registers [31:0]; // 32��32λ�Ĵ���

integer i;

// ������������߼���
assign rs1_data = (rs1_addr == 5'd0) ? 32'd0 : registers[rs1_addr];
assign rs2_data = (rs2_addr == 5'd0) ? 32'd0 : registers[rs2_addr];

// д������ʱ���߼���
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // ��λʱ���мĴ�������
        for (i = 0; i < 32; i = i + 1) begin
            registers[i] <= 32'd0;
        end
    end else if (reg_write && rd_addr != 5'd0) begin
        // д�Ĵ�����x0�Ĵ���ʼ��Ϊ0��
        registers[rd_addr] <= rd_data;
    end
end

endmodule

