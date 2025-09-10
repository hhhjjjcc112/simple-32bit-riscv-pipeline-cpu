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
    output wire [31:0] mem_data,      // �ڴ�����
    output reg        reg_write_out, // �Ĵ���дʹ�����
    output reg        mem_to_reg_out// д������ѡ�����
);

// // ���ݴ洢������ʵ�֣�
// reg [31:0] data_memory [255:0]; // 256����

// // �ڴ����
// wire [31:0] mem_data_wire;
// assign mem_data_wire = mem_read ? data_memory[alu_result[9:2]] : 32'd0;

// // �ڴ�д����
// always @(posedge clk) begin
//     if (mem_write) begin
//         data_memory[alu_result[9:2]] <= rs2_data;
//     end
// end


data_memory dm_inst (
  .clka(clk),    // input wire clka
  .ena(mem_write),      // input wire ena
  .wea(mem_write),      // input wire [0 : 0] wea
  .addra(alu_result[17:2]),  // input wire [15 : 0] addra
  .dina(rs2_data),    // input wire [31 : 0] dina
  .clkb(clk),    // input wire clkb
  .enb(mem_read),      // input wire enb
  .addrb(alu_result[17:2]),  // input wire [15 : 0] addrb
  .doutb(mem_data)  // output wire [31 : 0] doutb
);

// ��ˮ�߼Ĵ�������
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        rd_addr_out <= 5'd0;
        alu_result_out <= 32'd0;
        reg_write_out <= 1'b0;
        mem_to_reg_out <= 1'b0;

    end else begin
        // ��������
        rd_addr_out <= rd_addr;
        alu_result_out <= alu_result;
        reg_write_out <= reg_write;
        mem_to_reg_out <= mem_to_reg;
    end
end

endmodule
