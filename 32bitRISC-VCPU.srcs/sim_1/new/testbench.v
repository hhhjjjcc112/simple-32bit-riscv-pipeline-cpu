`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/27 18:29:51
// Design Name: 
// Module Name: testbench
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


module testbench();

// 时钟和复位信号
reg clk_in;
reg rst_n;
wire [31:0] pc;

// 实例化流水线处理器
riscv_pipeline processor(
    .clk_in(clk_in),
    .rst_n(rst_n),
    .pc(pc)
);

// 时钟生成
initial begin
    clk_in = 0;
    forever #5 clk_in = ~clk_in; // 100MHz时钟
end

// 测试序列
initial begin
    // 初始化
    rst_n = 0;
    
    // 等待几个时钟周期后释放复位
    #20;
    rst_n = 1;
    
    // 运行足够长的时间来执行所有指令
    #10000;
    
    // 显示最终结果
    $display("=== 仿真完成 ===");
    $display("时间: %0t", $time);
    
    // 结束仿真
    $finish;
end

// 监控关键信号
// initial begin
//     $monitor("时间: %0t, PC: %h, 指令: %h", $time, processor.pc_if, processor.instruction_if);
// end

// 在每个时钟上升沿显示流水线状态
always @(posedge clk_in) begin
    if (rst_n) begin
        $display("=== 时钟周期 %0d ===", $time/10);
        $display("IF级: PC=%h, predict_pc=%h, 指令=%h", processor.pc_if, processor.pc_predict_if, processor.instruction_if);
        $display("ID级: rs1=%d, rs2=%d, rd=%d, 立即数=%h, rs1_data=%h, rs2_data=%h, PC=%h, opcode=%b, funct3=%b, funct7=%b, reg_write=%b, mem_read=%b, mem_write=%b, branch=%b, jump=%b, alu_src=%b, mem_to_reg=%b, alu_op=%b",
            processor.rs1_addr_id, processor.rs2_addr_id, processor.rd_addr_id,
            processor.immediate_id, processor.rs1_data_id, processor.rs2_data_id,
            processor.pc_id,
            processor.opcode_id, processor.funct3_id, processor.funct7_id,
            processor.reg_write_id, processor.mem_read_id, processor.mem_write_id,
            processor.branch_id, processor.jump_id, processor.alu_src_id, processor.mem_to_reg_id,
            processor.alu_op_id);
        $display("EX级: rd=%d, ALU结果=%h, rs2_data=%h, reg_write=%b, mem_read=%h, mem_write=%h, mem_to_reg=%h, control=%b, correct_pc=%h",
            processor.rd_addr_ex, processor.alu_result_ex,
            processor.rs2_data_ex,
            processor.reg_write_ex, processor.mem_read_ex, processor.mem_write_ex, processor.mem_to_reg_ex,
            processor.control_ex, processor.correct_pc_ex);
        $display("MEM级: rd=%d, 内存读取数据=%h, reg_write=%b, mem_to_reg=%b",
            processor.rd_addr_mem, processor.mem_data_mem, 
            processor.reg_write_mem, processor.mem_to_reg_mem);
        $display("WB级: rd=%d, 写回数据=%h, reg_write=%b",
            processor.rd_addr_wb, processor.rd_data_wb,
            processor.reg_write_wb);
        $display("冒险检测: load_use_hazard=%b, control_hazard=%b", 
                 processor.load_use_hazard, processor.control_hazard);
        $display("前递: forward_a=%b, forward_b=%b, rs1_data_forwarded=%h, rs2_data_forwarded=%h", 
                 processor.forward_a, processor.forward_b,
                 processor.rs1_data_forwarded, processor.rs2_data_forwarded);
        $display("分支/跳转: control=%b, branch_taken=%b, branch_target=%h, jump_taken=%b, jump_target=%h, correct_pc=%h", 
                 processor.control_ex,
                 processor.ex_stage_inst.branch_taken_wire, processor.ex_stage_inst.branch_target_wire,
                 processor.ex_stage_inst.jump_taken_wire, processor.ex_stage_inst.jump_target_wire,
                 processor.ex_stage_inst.correct_pc_wire);
        $display("---");
    end
end

// 生成波形文件
initial begin
    $dumpfile("riscv_pipeline.vcd");
    $dumpvars(0, testbench);
end

endmodule
