`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/27 18:23:43
// Design Name: 
// Module Name: id_stage
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


module id_stage(
    input wire        clk,
    input wire        rst_n,
    input wire        load_use_hazard,      // ����ʹ��ð���ź�
    input wire        control_hazard,       // ����ð���ź�
    input wire [31:0] instruction, // ָ��
    input wire [31:0] pc,         // PCֵ
    output reg [4:0]  rs1_addr,   // Դ�Ĵ���1��ַ
    output reg [4:0]  rs2_addr,   // Դ�Ĵ���2��ַ
    output reg [4:0]  rd_addr,    // Ŀ��Ĵ�����ַ
    output reg [31:0] immediate,  // ������
    output reg [31:0] pc_out,     // PC���
    output reg [6:0]  opcode,     // ������
    output reg [2:0]  funct3,     // ������3
    output reg [6:0]  funct7      // ������7
);

// ָ�����Ͷ���
localparam R_TYPE = 7'b0110011; // R��ָ��
localparam I_TYPE = 7'b0010011; // I��ָ����������㣩
localparam I_LOAD = 7'b0000011; // I��ָ����أ�
localparam S_TYPE = 7'b0100011; // S��ָ��洢��
localparam B_TYPE = 7'b1100011; // B��ָ���֧��
localparam J_JAL  = 7'b1101111; // J��ָ�JAL��
localparam I_JALR = 7'b1100111; // I��ָ�JALR��
localparam U_LUI  = 7'b0110111; // U��ָ�LUI��
localparam U_AUIPC= 7'b0010111; // U��ָ�AUIPC��

// ָ���ֶν���
wire [6:0] opcode_in = instruction[6:0];
wire [2:0] funct3_in = instruction[14:12];
wire [6:0] funct7_in = instruction[31:25];
wire [4:0] rs1_in = instruction[19:15];
wire [4:0] rs2_in = instruction[24:20];
wire [4:0] rd_in = instruction[11:7];

// ����������
wire [31:0] imm_i = {{20{instruction[31]}}, instruction[31:20]}; // I��ָ��
wire [31:0] imm_s = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]}; // S��ָ��
wire [31:0] imm_b = {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0}; // B��ָ��
wire [31:0] imm_u = {instruction[31:12], 12'b0}; // U��ָ��
wire [31:0] imm_j = {{12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0}; // J��ָ��

// ����ָ������ѡ��������
wire [31:0] immediate_in;
assign immediate_in = (opcode_in == I_TYPE || opcode_in == I_LOAD || opcode_in == I_JALR) ? imm_i : // I��
                      (opcode_in == S_TYPE) ? imm_s : // S��
                      (opcode_in == B_TYPE) ? imm_b : // B��
                      (opcode_in == U_LUI || opcode_in == U_AUIPC) ? imm_u : // U��
                      (opcode_in == J_JAL) ? imm_j : // J��
                      32'd0;

// ��ˮ�߼Ĵ�������
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        rs1_addr <= 5'd0;
        rs2_addr <= 5'd0;
        rd_addr <= 5'd0;
        immediate <= 32'd0;
        pc_out <= 32'd0;
        opcode <= 7'd0;
        funct3 <= 3'd0;
        funct7 <= 7'd0;
    end else if (load_use_hazard) begin
        // ���ֵ�ǰ״̬��������
    end else if(control_hazard) begin
        // �����ˮ��
        rs1_addr <= 5'd0;
        rs2_addr <= 5'd0;
        rd_addr <= 5'd0;
        immediate <= 32'd0;
        pc_out <= 32'd0;
        opcode <= 7'd0;
        funct3 <= 3'd0;
        funct7 <= 7'd0;
    end else begin
        // ��������
        rs1_addr <= rs1_in;
        rs2_addr <= rs2_in;
        rd_addr <= rd_in;
        immediate <= immediate_in;
        pc_out <= pc;
        opcode <= opcode_in;
        funct3 <= funct3_in;
        funct7 <= funct7_in;
    end
end

endmodule

