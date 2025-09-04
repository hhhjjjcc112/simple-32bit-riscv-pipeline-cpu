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
    input wire        load_use_hazard,      // 加载使用冒险信号
    input wire        control_hazard,       // 控制冒险信号
    input wire [4:0]  rd_addr,   // 目标寄存器地址
    input wire [31:0] immediate, // 立即数
    input wire [31:0] pc,        // PC值
    input wire [6:0]  opcode,    // 操作码
    input wire        reg_write, // 寄存器写使能
    input wire        mem_read,  // 内存读使能
    input wire        mem_write, // 内存写使能
    input wire        branch,    // 分支指令
    input wire        branch_cond_ne, // 分支条件
    input wire        jump,      // 跳转指令
    input wire        alu_src,   // ALU源操作数选择
    input wire [3:0]  alu_op,   // ALU操作码
    input wire        mem_to_reg,// 写回数据选择
    // 前递输入
    input wire [31:0] rs1_data_forwarded, // 前递后的源寄存器1数据
    input wire [31:0] rs2_data_forwarded, // 前递后的源寄存器2数据
    // 输出
    output reg [4:0]  rd_addr_out,   // 目标寄存器地址输出
    output reg [31:0] alu_result,    // ALU结果
    output reg [31:0] rs2_data_out,  // 源寄存器2数据输出
    output reg        reg_write_out, // 寄存器写使能输出
    output reg        mem_read_out,  // 内存读使能输出
    output reg        mem_write_out, // 内存写使能输出
    output reg        mem_to_reg_out,// 写回数据选择输出
    output reg        control,       // 是否为控制指令
    output reg [31:0] correct_pc     // 正确的PC值（用于分支预测）
);

// 指令类型定义
localparam R_TYPE = 7'b0110011; // R型指令
localparam I_TYPE = 7'b0010011; // I型指令（立即数运算）
localparam I_LOAD = 7'b0000011; // I型指令（加载）
localparam S_TYPE = 7'b0100011; // S型指令（存储）
localparam B_TYPE = 7'b1100011; // B型指令（分支）
localparam J_JAL  = 7'b1101111; // J型指令（JAL）
localparam I_JALR = 7'b1100111; // I型指令（JALR）
localparam U_LUI  = 7'b0110111; // U型指令（LUI）
localparam U_AUIPC= 7'b0010111; // U型指令（AUIPC）

// ALU输入选择
wire [31:0] alu_a = rs1_data_forwarded;
wire [31:0] alu_b = alu_src ? immediate : rs2_data_forwarded;

// ALU实例化
wire [31:0] alu_result_wire;
wire zero_wire;

alu alu_inst(
    .a(alu_a),
    .b(alu_b),
    .alu_op(alu_op),
    .result(alu_result_wire),
    .zero(zero_wire)
);

// 分支目标地址计算
wire [31:0] branch_target_wire = pc + immediate;
// 跳转目标地址计算
wire [31:0] jump_target_wire = (opcode == I_JALR) ? // JALR
                               (rs1_data_forwarded + immediate) & 32'hFFFFFFFE :
                               pc + immediate; // JAL

// 分支和跳转信号
wire branch_taken_wire = branch && (branch_cond_ne ^ zero_wire);
wire jump_taken_wire = jump;
wire control_instruction = branch || jump;

// 正确的PC值计算
wire [31:0] correct_pc_wire = branch_taken_wire ? branch_target_wire :
                             jump_taken_wire ? jump_target_wire :
                             pc + 4;

// ALU结果选择
wire [31:0] alu_result_select = (opcode == I_JALR || opcode == J_JAL) ? jump_target_wire :
                                (opcode == U_AUIPC) ? pc + immediate :
                                (opcode == U_LUI) ? immediate :
                                alu_result_wire;

// 流水线寄存器更新
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
        // 清空流水线, 保证流入下一阶段的是NOP
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
        // 清空流水线
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
        // 正常更新
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
