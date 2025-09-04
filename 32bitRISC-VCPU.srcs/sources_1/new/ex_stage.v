`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/27 18:23:43
// Design Name: 
// Module Name: ex_stage
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


module ex_stage(
    input wire        clk,
    input wire        rst_n,
    input wire        load_use_hazard,      // ����ʹ��ð���ź�
    input wire        control_hazard,       // ����ð���ź�
    input wire [4:0]  rd_addr,   // Ŀ��Ĵ�����ַ
    input wire [31:0] immediate, // ������
    input wire [31:0] pc,        // PCֵ
    input wire [6:0]  opcode,    // ������
    input wire        reg_write, // �Ĵ���дʹ��
    input wire        mem_read,  // �ڴ��ʹ��
    input wire        mem_write, // �ڴ�дʹ��
    input wire        branch,    // ��ָ֧��
    input wire        branch_cond_ne, // ��֧����
    input wire        jump,      // ��תָ��
    input wire        alu_src,   // ALUԴ������ѡ��
    input wire [3:0]  alu_op,   // ALU������
    input wire        mem_to_reg,// д������ѡ��
    // ǰ������
    input wire [31:0] rs1_data_forwarded, // ǰ�ݺ��Դ�Ĵ���1����
    input wire [31:0] rs2_data_forwarded, // ǰ�ݺ��Դ�Ĵ���2����
    // ���
    output reg [4:0]  rd_addr_out,   // Ŀ��Ĵ�����ַ���
    output reg [31:0] alu_result,    // ALU���
    output reg [31:0] rs2_data_out,  // Դ�Ĵ���2�������
    output reg        reg_write_out, // �Ĵ���дʹ�����
    output reg        mem_read_out,  // �ڴ��ʹ�����
    output reg        mem_write_out, // �ڴ�дʹ�����
    output reg        mem_to_reg_out,// д������ѡ�����
    output reg        control,       // �Ƿ�Ϊ����ָ��
    output reg [31:0] correct_pc     // ��ȷ��PCֵ�����ڷ�֧Ԥ�⣩
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

// ALU����ѡ��
wire [31:0] alu_a = rs1_data_forwarded;
wire [31:0] alu_b = alu_src ? immediate : rs2_data_forwarded;

// ALUʵ����
wire [31:0] alu_result_wire;
wire zero_wire;

alu alu_inst(
    .a(alu_a),
    .b(alu_b),
    .alu_op(alu_op),
    .result(alu_result_wire),
    .zero(zero_wire)
);

// ��֧Ŀ���ַ����
wire [31:0] branch_target_wire = pc + immediate;
// ��תĿ���ַ����
wire [31:0] jump_target_wire = (opcode == I_JALR) ? // JALR
                               (rs1_data_forwarded + immediate) & 32'hFFFFFFFE :
                               pc + immediate; // JAL

// ��֧����ת�ź�
wire branch_taken_wire = branch && (branch_cond_ne ^ zero_wire);
wire jump_taken_wire = jump;
wire control_instruction = branch || jump;

// ��ȷ��PCֵ����
wire [31:0] correct_pc_wire = branch_taken_wire ? branch_target_wire :
                             jump_taken_wire ? jump_target_wire :
                             pc + 4;

// ALU���ѡ��
wire [31:0] alu_result_select = (opcode == I_JALR || opcode == J_JAL) ? jump_target_wire :
                                (opcode == U_AUIPC) ? pc + immediate :
                                (opcode == U_LUI) ? immediate :
                                alu_result_wire;

// ��ˮ�߼Ĵ�������
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        rd_addr_out <= 5'd0;
        alu_result <= 32'd0;
        rs2_data_out <= 32'd0;
        reg_write_out <= 1'b0;
        mem_read_out <= 1'b0;
        mem_write_out <= 1'b0;
        mem_to_reg_out <= 1'b0;
        control <= 1'b0;
        correct_pc <= 32'b0;
    end else if (load_use_hazard) begin
        // �����ˮ��, ��֤������һ�׶ε���NOP
        rd_addr_out <= 5'd0;
        alu_result <= 32'd0;
        rs2_data_out <= 32'd0;
        reg_write_out <= 1'b0;
        mem_read_out <= 1'b0;
        mem_write_out <= 1'b0;
        mem_to_reg_out <= 1'b0;
        control <= 1'b0;
        correct_pc <= 32'b0;
    end else if (control_hazard) begin
        // �����ˮ��
        rd_addr_out <= 5'd0;
        alu_result <= 32'd0;
        rs2_data_out <= 32'd0;
        reg_write_out <= 1'b0;
        mem_read_out <= 1'b0;
        mem_write_out <= 1'b0;
        mem_to_reg_out <= 1'b0;
        control <= 1'b0;
        correct_pc <= 32'b0;
    end else begin
        // ��������
        rd_addr_out <= rd_addr;
        alu_result <= alu_result_select;
        rs2_data_out <= rs2_data_forwarded;
        reg_write_out <= reg_write;
        mem_read_out <= mem_read;
        mem_write_out <= mem_write;
        mem_to_reg_out <= mem_to_reg;
        control <= control_instruction;
        correct_pc <= correct_pc_wire;
    end
end

endmodule
