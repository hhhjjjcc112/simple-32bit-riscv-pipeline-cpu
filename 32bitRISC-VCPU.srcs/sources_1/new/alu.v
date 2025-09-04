`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/27 18:23:43
// Design Name: 
// Module Name: alu
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


module alu(
    input wire [31:0] a,      // 操作数1
    input wire [31:0] b,      // 操作数2
    input wire [3:0]  alu_op, // ALU操作码
    output reg [31:0] result, // 结果
    output reg        zero     // 零标志位
);

// ALU操作码定义
localparam ALU_ADD  = 4'b0000; // 加法
localparam ALU_SUB  = 4'b0001; // 减法
localparam ALU_AND  = 4'b0010; // 逻辑与
localparam ALU_OR   = 4'b0011; // 逻辑或
localparam ALU_XOR  = 4'b0100; // 逻辑异或
localparam ALU_SLT  = 4'b0101; // 有符号小于
localparam ALU_SLTU = 4'b0110; // 无符号小于
localparam ALU_SLL  = 4'b0111; // 逻辑左移
localparam ALU_SRL  = 4'b1000; // 逻辑右移
localparam ALU_SRA  = 4'b1001; // 算术右移

always @(*) begin
    case (alu_op)
        ALU_ADD:  result = a + b;
        ALU_SUB:  result = a - b;
        ALU_AND:  result = a & b;
        ALU_OR:   result = a | b;
        ALU_XOR:  result = a ^ b;
        ALU_SLT:  result = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
        ALU_SLTU: result = (a < b) ? 32'd1 : 32'd0;
        ALU_SLL:  result = a << b[4:0];
        ALU_SRL:  result = a >> b[4:0];
        ALU_SRA:  result = $signed(a) >>> b[4:0];
        default:  result = 32'd0;
    endcase
    
    zero = (result == 32'd0);
end

endmodule

