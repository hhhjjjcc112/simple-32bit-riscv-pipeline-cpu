`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/27 18:23:43
// Design Name: 
// Module Name: riscv_pipeline
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


module riscv_pipeline(
    input wire        clk_in,
    input wire        rst_n,
    output reg [31:0] pc            // 程序计数器
);

// 内部信号声明
wire [31:0] pc_if, pc_predict_if, pc_p4_if, instruction_if; // IF级信号, PC, PC+4, 指令, 输出

wire [4:0]  rs1_addr_id, rs2_addr_id, rd_addr_id; // ID级寄存器地址, 在译码阶段从指令中获取
wire [31:0] immediate_id, rs1_data_id, rs2_data_id; // ID级立即数和寄存器数据
wire [31:0] pc_id, pc_p4_id;                // ID级PC和PC+4
wire [6:0]  opcode_id, funct7_id;               // ID级操作码和功能码7
wire [2:0]  funct3_id;             // ID级功能码3
wire reg_write_id, mem_read_id, mem_write_id, branch_id, branch_cond_ne_id, jump_id, alu_src_id, mem_to_reg_id;
wire [3:0] alu_op_id;

wire [4:0]  rd_addr_ex, rs1_addr_ex, rs2_addr_ex; // EX级寄存器地址
wire [31:0] alu_result_ex, rs2_data_ex; // EX级信号, ALU结果, 源寄存器2数据
wire        reg_write_ex, mem_read_ex, mem_write_ex, mem_to_reg_ex; // EX级控制信号, 寄存器写使能, 内存读使能, 内存写使能, 写回数据选择
wire        control_ex; // EX级是否为控制指令
wire [31:0] correct_pc_ex; // EX级正确的PC值

wire [4:0]  rd_addr_mem, rd_addr_inner_mem;               // MEM级目标寄存器地址
wire [31:0] alu_result_mem, mem_data_mem;
wire        reg_write_mem, mem_to_reg_mem;

wire [4:0]  rd_addr_wb; // WB级目标寄存器地址
wire [31:0] rd_data_wb; // WB级写回数据
wire        reg_write_wb; // WB级寄存器写使能

// 冒险检测信号
wire load_use_hazard, control_hazard;

// 前递信号
wire [1:0] forward_a, forward_b;
wire [31:0] rs1_data_forwarded, rs2_data_forwarded; // 前递后的寄存器数据

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pc <= 32'd0;
    end else begin
        pc <= pc_if; // 更新PC为IF级的PC输出
    end
end

// clock clock_inst(
//     .clk_in1(clk_in),
//     .resetn(rst_n),
//     .locked(),
//     .clk_out1(clk)
// );

assign clk = clk_in; // 直接使用输入时钟

// 取指级实例化
if_stage if_stage_inst(
    .clk(clk),
    .rst_n(rst_n),
    .load_use_hazard(load_use_hazard),
    .control_hazard(control_hazard),
    .correct_pc(correct_pc_ex),
    .pc_predict(pc_predict_if), // 预测的PC值
    .pc_out(pc_if), // 当前PC输出
    .pc_p4_out(pc_p4_if), // 当前PC+4输出
    .instruction(instruction_if)
);

// 寄存器堆实例化
regfile regfile_inst(
    .clk(clk),
    .rst_n(rst_n),
    .rs1_addr(rs1_addr_id), 
    .rs2_addr(rs2_addr_id), 
    .rd_addr(rd_addr_wb),   
    .rd_data(rd_data_wb),   
    .reg_write(reg_write_wb),  
    .rs1_data(rs1_data_id),
    .rs2_data(rs2_data_id)  
);

// 译码级实例化
id_stage id_stage_inst(
    .clk(clk),
    .rst_n(rst_n),
    .load_use_hazard(load_use_hazard),
    .control_hazard(control_hazard),
    .instruction(instruction_if),
    .pc(pc_if),
    .pc_p4(pc_p4_if),
    .rs1_addr(rs1_addr_id),
    .rs2_addr(rs2_addr_id),
    .rd_addr(rd_addr_id),
    .immediate(immediate_id),
    .pc_out(pc_id),
    .pc_p4_out(pc_p4_id),
    .opcode(opcode_id),
    .reg_write(reg_write_id),
    .mem_read(mem_read_id),
    .mem_write(mem_write_id),
    .branch(branch_id),
    .branch_cond_ne(branch_cond_ne_id),
    .jump(jump_id),
    .alu_src(alu_src_id),
    .alu_op(alu_op_id),
    .mem_to_reg(mem_to_reg_id)
);

// 执行级实例化
ex_stage ex_stage_inst(
    .clk(clk),
    .rst_n(rst_n),
    .load_use_hazard(load_use_hazard),
    .control_hazard(control_hazard),
    .rd_addr(rd_addr_id),
    .immediate(immediate_id),
    .pc(pc_id),
    .pc_p4(pc_p4_id),
    .opcode(opcode_id),
    .reg_write(reg_write_id),
    .mem_read(mem_read_id),
    .mem_write(mem_write_id),
    .branch(branch_id),
    .branch_cond_ne(branch_cond_ne_id),
    .jump(jump_id),
    .alu_src(alu_src_id),
    .alu_op(alu_op_id),
    .mem_to_reg(mem_to_reg_id),
    .rs1_data_forwarded(rs1_data_forwarded),
    .rs2_data_forwarded(rs2_data_forwarded),
    .rd_addr_out(rd_addr_ex),
    .alu_result(alu_result_ex),
    .rs2_data_out(rs2_data_ex),
    .reg_write_out(reg_write_ex),
    .mem_read_out(mem_read_ex),
    .mem_write_out(mem_write_ex),
    .mem_to_reg_out(mem_to_reg_ex),
    .control(control_ex),
    .correct_pc(correct_pc_ex)
);

// 访存级实例化
mem_stage mem_stage_inst(
    .clk(clk),
    .rst_n(rst_n),
    .rd_addr(rd_addr_ex),
    .alu_result(alu_result_ex),
    .rs2_data(rs2_data_ex),
    .reg_write(reg_write_ex),
    .mem_read(mem_read_ex),
    .mem_write(mem_write_ex),
    .mem_to_reg(mem_to_reg_ex),
    .rd_addr_out(rd_addr_mem),
    .alu_result_out(alu_result_mem),
    .mem_data(mem_data_mem),
    .reg_write_out(reg_write_mem),
    .mem_to_reg_out(mem_to_reg_mem)
);

// 写回级实例化
wb_stage wb_stage_inst(
    .clk(clk),
    .rst_n(rst_n),
    .rd_addr(rd_addr_mem),
    .alu_result(alu_result_mem),
    .mem_data(mem_data_mem),
    .reg_write(reg_write_mem),
    .mem_to_reg(mem_to_reg_mem),
    .rd_addr_out(rd_addr_wb),
    .rd_data(rd_data_wb),
    .reg_write_out(reg_write_wb)
);

// 冒险检测单元实例化
hazard_unit hazard_unit_inst(
    .rs1_id(rs1_addr_id),
    .rs2_id(rs2_addr_id),
    .rd_ex(rd_addr_ex),
    .mem_to_reg_ex(mem_to_reg_ex),
    .control_ex(control_ex),
    .correct_pc_ex(correct_pc_ex),
    .pc_id(pc_id),
    .load_use_hazard(load_use_hazard),
    .control_hazard(control_hazard)
);

// 前递单元实例化
forwarding_unit forwarding_unit_inst(
    .rs1_id(rs1_addr_id),
    .rs2_id(rs2_addr_id),
    .rd_ex(rd_addr_ex),
    .rd_mem(rd_addr_mem),
    .rd_wb(rd_addr_wb),
    .reg_write_ex(reg_write_ex),
    .reg_write_mem(reg_write_mem),
    .reg_write_wb(reg_write_wb),
    .rs1_data(rs1_data_id),
    .rs2_data(rs2_data_id),
    .alu_result_ex(alu_result_ex),
    .alu_result_mem(alu_result_mem),
    .alu_result_wb(rd_data_wb),
    .mem_data_mem(mem_data_mem),
    .mem_to_reg_mem(mem_to_reg_mem),
    .rs1_data_forwarded(rs1_data_forwarded),
    .rs2_data_forwarded(rs2_data_forwarded),
    .forward_a(forward_a),
    .forward_b(forward_b)
);

endmodule
