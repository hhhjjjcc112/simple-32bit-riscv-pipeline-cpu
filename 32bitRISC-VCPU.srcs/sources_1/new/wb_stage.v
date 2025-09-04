`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/27 18:23:43
// Design Name: 
// Module Name: wb_stage
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

module wb_stage(
    input wire        clk,
    input wire        rst_n,
    input wire [4:0]  rd_addr,   // 目标寄存器地址
    input wire [31:0] alu_result, // ALU结果
    input wire [31:0] mem_data,   // 内存数据
    input wire        reg_write,  // 寄存器写使能
    input wire        mem_to_reg, // 写回数据选择
    output reg [4:0]  rd_addr_out,   // 目标寄存器地址输出
    output reg [31:0] rd_data,       // 写回数据
    output reg        reg_write_out   // 寄存器写使能输出
);

// 写回数据选择
wire [31:0] rd_data_wire;
assign rd_data_wire = mem_to_reg ? mem_data : alu_result;

// 流水线寄存器更新
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        rd_addr_out <= 5'd0;
        rd_data <= 32'd0;
        reg_write_out <= 1'b0;
    end else begin
        // 正常更新
        rd_addr_out <= rd_addr;
        rd_data <= rd_data_wire;
        reg_write_out <= reg_write;
    end
end

endmodule
