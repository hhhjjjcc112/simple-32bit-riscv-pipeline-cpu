`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/27 18:23:43
// Design Name: 
// Module Name: if_stage
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


module if_stage(
    input wire        clk,
    input wire        rst_n,
    input wire        load_use_hazard,      // 加载使用冒险信号
    input wire        control_hazard,       // 控制冒险信号
    input wire [31:0] correct_pc,        // 正确的PC值
    output reg [31:0] pc_predict,    // 预测的PC值
    output reg [31:0] pc_out,            // 程序计数器
    output reg [31:0] instruction    // 当前指令
);

// 指令存储器（简化实现）
reg [31:0] instruction_memory [255:0]; // 256条指令

// 初始化指令存储器（测试程序）
initial begin
    // 加载测试程序到指令存储器
    $readmemh("../../../../test_program.hex", instruction_memory);
end

// PC更新逻辑
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pc_predict <= 32'd0;
        pc_out <= 32'd0;
        instruction <= 32'd0;
    end else if (load_use_hazard) begin
        // 保持当前状态，不更新
    end else if (control_hazard) begin
        // 发生控制冒险，跳转到正确的PC
        pc_predict <= correct_pc + 32'd4; // 预测下一个PC
        pc_out <= correct_pc;
        instruction <= instruction_memory[correct_pc[9:2]];
    end else begin
        // 正常顺序执行
        pc_predict <= pc_predict + 32'd4; // 预测下一个PC
        pc_out <= pc_predict;
        instruction <= instruction_memory[pc_predict[9:2]];
    end
end

endmodule

