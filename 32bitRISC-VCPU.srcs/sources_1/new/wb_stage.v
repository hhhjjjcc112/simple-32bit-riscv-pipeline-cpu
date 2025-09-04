`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/27 18:23:43
// Design Name: 
// Module Name: wb_stage
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

module wb_stage(
    input wire        clk,
    input wire        rst_n,
    input wire [4:0]  rd_addr,   // Ŀ��Ĵ�����ַ
    input wire [31:0] alu_result, // ALU���
    input wire [31:0] mem_data,   // �ڴ�����
    input wire        reg_write,  // �Ĵ���дʹ��
    input wire        mem_to_reg, // д������ѡ��
    output reg [4:0]  rd_addr_out,   // Ŀ��Ĵ�����ַ���
    output reg [31:0] rd_data,       // д������
    output reg        reg_write_out   // �Ĵ���дʹ�����
);

// д������ѡ��
wire [31:0] rd_data_wire;
assign rd_data_wire = mem_to_reg ? mem_data : alu_result;

// ��ˮ�߼Ĵ�������
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        rd_addr_out <= 5'd0;
        rd_data <= 32'd0;
        reg_write_out <= 1'b0;
    end else begin
        // ��������
        rd_addr_out <= rd_addr;
        rd_data <= rd_data_wire;
        reg_write_out <= reg_write;
    end
end

endmodule
