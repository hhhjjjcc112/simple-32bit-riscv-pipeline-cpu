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


module forwarding_unit(
    input wire [4:0] rs1_id,      // ID级源寄存器1地址
    input wire [4:0] rs2_id,      // ID级源寄存器2地址
    input wire [4:0] rd_ex,      // EX级目标寄存器地址
    input wire [4:0] rd_mem,       // MEM级目标寄存器地址
    input wire [4:0] rd_wb,        // WB级目标寄存器地址
    input wire       reg_write_ex,// EX级寄存器写使能
    input wire       reg_write_mem, // MEM级寄存器写使能
    input wire       reg_write_wb,  // WB级寄存器写使能
    input wire [31:0] rs1_data,      // ID级源寄存器1数据
    input wire [31:0] rs2_data,      // ID级源寄存器2数据
    input wire [31:0] alu_result_ex, // EX级ALU结果
    input wire [31:0] alu_result_mem, // MEM级ALU结果
    input wire [31:0] alu_result_wb,  // WB级ALU结果
    input wire [31:0] mem_data_mem,   // MEM级内存数据
    input wire       mem_to_reg_mem,  // MEM级写回数据选择
    output reg [31:0] rs1_data_forwarded, // 前递后的源寄存器1数据
    output reg [31:0] rs2_data_forwarded,  // 前递后的源寄存器2数据
    output reg [1:0] forward_a,      // 前递A选择
    output reg [1:0] forward_b       // 前递B选择
);

parameter FORWARD_NONE = 2'b00;
parameter FORWARD_EX   = 2'b01;
parameter FORWARD_MEM  = 2'b10;
parameter FORWARD_WB   = 2'b11;

always @(*) begin
    // 默认不前递
    rs1_data_forwarded = rs1_data;
    rs2_data_forwarded = rs2_data;
    forward_a = FORWARD_NONE;
    forward_b = FORWARD_NONE;
    
    // 检测a的前递
    if (reg_write_ex && (rd_ex != 5'd0) && (rd_ex == rs1_id)) begin
        rs1_data_forwarded = alu_result_ex;
        forward_a = FORWARD_EX;
    end else if (reg_write_mem && (rd_mem != 5'd0) && (rd_mem == rs1_id)) begin
        rs1_data_forwarded = mem_to_reg_mem ? mem_data_mem : alu_result_mem;
        forward_a = FORWARD_MEM;
    end else if (reg_write_wb && (rd_wb != 5'd0) && (rd_wb == rs1_id)) begin
        rs1_data_forwarded = alu_result_wb;
        forward_a = FORWARD_WB;
    end

    // 检测b的前递
    if (reg_write_ex && (rd_ex != 5'd0) && (rd_ex == rs2_id)) begin
        rs2_data_forwarded = alu_result_ex;
        forward_b = FORWARD_EX;
    end else if (reg_write_mem && (rd_mem != 5'd0) && (rd_mem == rs2_id)) begin
        rs2_data_forwarded = mem_to_reg_mem ? mem_data_mem : alu_result_mem;
        forward_b = FORWARD_MEM;
    end else if (reg_write_wb && (rd_wb != 5'd0) && (rd_wb == rs2_id)) begin
        rs2_data_forwarded = alu_result_wb;
        forward_b = FORWARD_WB;
    end
end

endmodule
