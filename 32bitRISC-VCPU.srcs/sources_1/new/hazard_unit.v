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


module hazard_unit(
    input wire [4:0] rs1_id,      // ID级源寄存器1地址
    input wire [4:0] rs2_id,      // ID级源寄存器2地址
    input wire [4:0] rd_ex,       // EX级目标寄存器地址
    input wire [4:0] rd_mem_inner,      // MEM级目标寄存器地址1
    input wire       mem_to_reg_ex,  // EX级内存读使能
    input wire       mem_to_reg_inner_mem,  // MEM级内存读使能1
    input wire       control_ex,      // EX级是否为控制指令
    input wire [31:0] correct_pc_ex,  // EX级正确的PC值
    input wire [31:0] pc_id,        // ID级PC值
    output reg       load_use_hazard,        // 流水线停顿信号
    output reg       control_hazard      // 控制冒险信号
);

always @(*) begin
    
    // 加载使用冒险, 如果mem阶段需要读内存, ex阶段读的寄存器是要写的寄存器
    if (rs1_id != 5'd0) begin
        if (mem_to_reg_ex && (rd_ex == rs1_id)) begin
            load_use_hazard = 1'b1;
        end else if (mem_to_reg_inner_mem && (rd_mem_inner == rs1_id)) begin
            load_use_hazard = 1'b1;
        end else begin
            load_use_hazard = 1'b0;
        end
    end else if (rs2_id != 5'd0) begin
        if (mem_to_reg_ex && (rd_ex == rs2_id)) begin
            load_use_hazard = 1'b1;
        end else if (mem_to_reg_inner_mem && (rd_mem_inner == rs2_id)) begin
            load_use_hazard = 1'b1;
        end else begin
            load_use_hazard = 1'b0;
        end
    end else begin
        load_use_hazard = 1'b0;
    end
    
    // 控制冒险, 分支或跳转指令且预测错误
    control_hazard = control_ex && (correct_pc_ex != pc_id);
end

endmodule

