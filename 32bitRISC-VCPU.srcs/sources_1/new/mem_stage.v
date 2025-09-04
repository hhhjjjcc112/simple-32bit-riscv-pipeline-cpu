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
    input wire [4:0]  rd_addr,   // 目标寄存器地址
    input wire [31:0] alu_result, // ALU结果
    input wire [31:0] rs2_data,   // 源寄存器2数据
    input wire        reg_write,  // 寄存器写使能
    input wire        mem_read,   // 内存读使能
    input wire        mem_write,  // 内存写使能
    input wire        mem_to_reg, // 写回数据选择
    output reg [4:0]  rd_addr_out,   // 目标寄存器地址输出
    output reg [31:0] alu_result_out, // ALU结果输出
    output reg [31:0] mem_data,      // 内存数据
    output reg        reg_write_out, // 寄存器写使能输出
    output reg        mem_to_reg_out,// 写回数据选择输出
    output reg [31:0] rs2_data_out  // 源寄存器2数据输出
);

// 数据存储器（简化实现）
reg [31:0] data_memory [255:0]; // 256个字

// 内存访问
wire [31:0] mem_data_wire;
assign mem_data_wire = mem_read ? data_memory[alu_result[9:2]] : 32'd0;

// 内存写操作
always @(posedge clk) begin
    if (mem_write) begin
        data_memory[alu_result[9:2]] <= rs2_data;
    end
end

// 流水线寄存器更新
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        rd_addr_out <= 5'd0;
        alu_result_out <= 32'd0;
        mem_data <= 32'd0;
        reg_write_out <= 1'b0;
        mem_to_reg_out <= 1'b0;
        rs2_data_out <= 32'd0;
    end else begin
        // 正常更新
        rd_addr_out <= rd_addr;
        alu_result_out <= alu_result;
        mem_data <= mem_data_wire;
        reg_write_out <= reg_write;
        mem_to_reg_out <= mem_to_reg;
        rs2_data_out <= (mem_write) ? rs2_data : 32'd0;
    end
end

endmodule
