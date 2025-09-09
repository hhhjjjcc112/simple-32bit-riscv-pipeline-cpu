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
    input wire        load_use_hazard,      // 加载使用冒险信号
    input wire        control_hazard,       // 控制冒险信号
    input wire [31:0] instruction, // 指令
    input wire [31:0] pc,         // PC值
    input wire [31:0] pc_p4,      // PC + 4
    output reg [4:0]  rs1_addr,   // 源寄存器1地址
    output reg [4:0]  rs2_addr,   // 源寄存器2地址
    output reg [4:0]  rd_addr,    // 目标寄存器地址
    output reg [31:0] immediate,  // 立即数
    output reg [31:0] pc_out,     // PC输出
    output reg [31:0] pc_p4_out,  // PC + 4输出
    output reg [6:0]  opcode,     // 操作码
    output reg        reg_write,  // 寄存器写使能
    output reg        mem_read,   // 内存读使能
    output reg        mem_write,  // 内存写使能
    output reg        branch,     // 分支指令
    output reg        branch_cond_ne, // 分支条件
    output reg        jump,       // 跳转指令
    output reg        alu_src,    // ALU源操作数选择
    output reg [3:0]  alu_op,     // ALU操作码
    output reg        mem_to_reg // 写回数据选择
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

// 指令字段解析
wire [6:0] opcode_in = instruction[6:0];
wire [2:0] funct3_in = instruction[14:12];
wire [6:0] funct7_in = instruction[31:25];
wire [4:0] rs1_in = instruction[19:15];
wire [4:0] rs2_in = instruction[24:20];
wire [4:0] rd_in = instruction[11:7];

// 立即数生成
wire [31:0] imm_i = {{20{instruction[31]}}, instruction[31:20]}; // I型指令
wire [31:0] imm_s = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]}; // S型指令
wire [31:0] imm_b = {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0}; // B型指令
wire [31:0] imm_u = {instruction[31:12], 12'b0}; // U型指令
wire [31:0] imm_j = {{12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0}; // J型指令

// 根据指令类型选择立即数
wire [31:0] immediate_in;
assign immediate_in = (opcode_in == I_TYPE || opcode_in == I_LOAD || opcode_in == I_JALR) ? imm_i : // I型
                      (opcode_in == S_TYPE) ? imm_s : // S型
                      (opcode_in == B_TYPE) ? imm_b : // B型
                      (opcode_in == U_LUI || opcode_in == U_AUIPC) ? imm_u : // U型
                      (opcode_in == J_JAL) ? imm_j : // J型
                      32'd0;

wire reg_write_out, mem_read_out, mem_write_out, branch_out, branch_cond_ne_out, jump_out, alu_src_out, mem_to_reg_out;
wire [3:0] alu_op_out;

// 控制单元实例化
control_unit control_unit_inst(
    .opcode(opcode_in),
    .funct3(funct3_in),
    .funct7(funct7_in),
    .reg_write(reg_write_out),
    .mem_read(mem_read_out),
    .mem_write(mem_write_out),
    .branch(branch_out),
    .branch_cond_ne(branch_cond_ne_out),
    .jump(jump_out),
    .alu_src(alu_src_out),
    .alu_op(alu_op_out),
    .mem_to_reg(mem_to_reg_out)
);

// 流水线寄存器更新
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        rs1_addr <= 5'd0;
        rs2_addr <= 5'd0;
        rd_addr <= 5'd0;
        immediate <= 32'd0;
        pc_out <= 32'd0;
        pc_p4_out <= 32'd0;
        opcode <= 7'd0;
        reg_write <= 1'b0;
        mem_read <= 1'b0;
        mem_write <= 1'b0;
        branch <= 1'b0;
        branch_cond_ne <= 1'b0;
        jump <= 1'b0;
        alu_src <= 1'b0;
        alu_op <= 4'd0;
        mem_to_reg <= 1'b0;
    end else if (load_use_hazard) begin
        // 保持当前状态，不更新
    end else if(control_hazard) begin
        // 清空流水线
        rs1_addr <= 5'd0;
        rs2_addr <= 5'd0;
        rd_addr <= 5'd0;
        immediate <= 32'd0;
        pc_out <= 32'd0;
        pc_p4_out <= 32'd0;
        opcode <= 7'd0;
        reg_write <= 1'b0;
        mem_read <= 1'b0;
        mem_write <= 1'b0;
        branch <= 1'b0;
        branch_cond_ne <= 1'b0;
        jump <= 1'b0;
        alu_src <= 1'b0;
        alu_op <= 4'd0;
        mem_to_reg <= 1'b0;
    end else begin
        // 正常更新
        rs1_addr <= rs1_in;
        rs2_addr <= rs2_in;
        rd_addr <= rd_in;
        immediate <= immediate_in;
        pc_out <= pc;
        pc_p4_out <= pc_p4;
        opcode <= opcode_in;
        reg_write <= reg_write_out;
        mem_read <= mem_read_out;
        mem_write <= mem_write_out;
        branch <= branch_out;
        branch_cond_ne <= branch_cond_ne_out;
        jump <= jump_out;
        alu_src <= alu_src_out;
        alu_op <= alu_op_out;
        mem_to_reg <= mem_to_reg_out;
    end
end

endmodule

