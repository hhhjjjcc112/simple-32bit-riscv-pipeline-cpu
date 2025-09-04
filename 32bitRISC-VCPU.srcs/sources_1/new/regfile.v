`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/27 18:23:43
// Design Name: 
// Module Name: regfile
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


module regfile(
    input wire        clk,
    input wire        rst_n,
    input wire [4:0]  rs1_addr,    // 源寄存器1地址
    input wire [4:0]  rs2_addr,    // 源寄存器2地址
    input wire [4:0]  rd_addr,     // 目标寄存器地址
    input wire [31:0] rd_data,     // 写回数据
    input wire        reg_write,   // 寄存器写使能
    output wire [31:0] rs1_data,   // 源寄存器1数据
    output wire [31:0] rs2_data    // 源寄存器2数据
);

reg [31:0] registers [31:0]; // 32个32位寄存器

integer i;

// 读操作（组合逻辑）
assign rs1_data = (rs1_addr == 5'd0) ? 32'd0 : registers[rs1_addr];
assign rs2_data = (rs2_addr == 5'd0) ? 32'd0 : registers[rs2_addr];

// 写操作（时序逻辑）
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // 复位时所有寄存器清零
        for (i = 0; i < 32; i = i + 1) begin
            registers[i] <= 32'd0;
        end
    end else if (reg_write && rd_addr != 5'd0) begin
        // 写寄存器（x0寄存器始终为0）
        registers[rd_addr] <= rd_data;
    end
end

endmodule

