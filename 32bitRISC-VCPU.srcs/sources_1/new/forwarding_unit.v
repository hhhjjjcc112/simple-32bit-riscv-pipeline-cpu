`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/27 18:23:43
// Design Name: 
// Module Name: hazard_unit
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


module forwarding_unit(
    input wire [4:0] rs1_id,      // ID��Դ�Ĵ���1��ַ
    input wire [4:0] rs2_id,      // ID��Դ�Ĵ���2��ַ
    input wire [4:0] rd_ex,      // EX��Ŀ��Ĵ�����ַ
    input wire [4:0] rd_mem,       // MEM��Ŀ��Ĵ�����ַ
    input wire [4:0] rd_wb,        // WB��Ŀ��Ĵ�����ַ
    input wire       reg_write_ex,// EX���Ĵ���дʹ��
    input wire       reg_write_mem, // MEM���Ĵ���дʹ��
    input wire       reg_write_wb,  // WB���Ĵ���дʹ��
    input wire [31:0] rs1_data,      // ID��Դ�Ĵ���1����
    input wire [31:0] rs2_data,      // ID��Դ�Ĵ���2����
    input wire [31:0] alu_result_ex, // EX��ALU���
    input wire [31:0] alu_result_mem, // MEM��ALU���
    input wire [31:0] alu_result_wb,  // WB��ALU���
    input wire [31:0] mem_data_mem,   // MEM���ڴ�����
    input wire       mem_to_reg_mem,  // MEM��д������ѡ��
    output reg [31:0] rs1_data_forwarded, // ǰ�ݺ��Դ�Ĵ���1����
    output reg [31:0] rs2_data_forwarded,  // ǰ�ݺ��Դ�Ĵ���2����
    output reg [1:0] forward_a,      // ǰ��Aѡ��
    output reg [1:0] forward_b       // ǰ��Bѡ��
);

parameter FORWARD_NONE = 2'b00;
parameter FORWARD_EX   = 2'b01;
parameter FORWARD_MEM  = 2'b10;
parameter FORWARD_WB   = 2'b11;

always @(*) begin
    // Ĭ�ϲ�ǰ��
    rs1_data_forwarded = rs1_data;
    rs2_data_forwarded = rs2_data;
    forward_a = FORWARD_NONE;
    forward_b = FORWARD_NONE;
    
    // ���a��ǰ��
    if (reg_write_ex && (rd_ex != 5'd0) && (rd_ex == rs1_id)) begin
        rs1_data_forwarded = alu_result_ex;
        forward_a = FORWARD_EX;
    end else if (reg_write_mem && (rd_mem != 5'd0) && (rd_mem == rs1_id)) begin
        rs1_data_forwarded = mem_to_reg_mem ? mem_data_mem : alu_result_mem;
        forward_a = FORWARD_MEM;
    end else if (reg_write_wb && (rd_wb != 5'd0) && (rd_wb == rs1_id)) begin
        rs1_data_forwarded = alu_result_wb;
        forward_a = FORWARD_WB;
    end

    // ���b��ǰ��
    if (reg_write_ex && (rd_ex != 5'd0) && (rd_ex == rs2_id)) begin
        rs2_data_forwarded = alu_result_ex;
        forward_b = FORWARD_EX;
    end else if (reg_write_mem && (rd_mem != 5'd0) && (rd_mem == rs2_id)) begin
        rs2_data_forwarded = mem_to_reg_mem ? mem_data_mem : alu_result_mem;
        forward_b = FORWARD_MEM;
    end else if (reg_write_wb && (rd_wb != 5'd0) && (rd_wb == rs2_id)) begin
        rs2_data_forwarded = alu_result_wb;
        forward_b = FORWARD_WB;
    end
end

endmodule
