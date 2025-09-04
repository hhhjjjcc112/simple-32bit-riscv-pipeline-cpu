`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/27 18:23:43
// Design Name: 
// Module Name: control_unit
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


module control_unit(
    input wire [6:0] opcode,      // 操作码
    input wire [2:0] funct3,      // 功能码3
    input wire [6:0] funct7,      // 功能码7
    output reg        reg_write,  // 寄存器写使能
    output reg        mem_read,   // 内存读使能
    output reg        mem_write,  // 内存写使能
    output reg        branch,     // 分支指令
    output reg        branch_cond_ne, // 分支条件
    output reg        jump,       // 跳转指令
    output reg        alu_src,    // ALU源操作数选择
    output reg [3:0]  alu_op,    // ALU操作码
    output reg        mem_to_reg  // 写回数据选择
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

always @(*) begin
    // 默认值
    reg_write = 1'b0;
    mem_read = 1'b0;
    mem_write = 1'b0;
    branch = 1'b0;
    jump = 1'b0;
    alu_src = 1'b0;
    alu_op = 4'b0000;
    mem_to_reg = 1'b0;
    branch_cond_ne = 1'b0;
    
    case (opcode)
        R_TYPE: begin // R型指令
            reg_write = 1'b1;
            case (funct3)
                3'b000: alu_op = (funct7[5]) ? 4'b0001 : 4'b0000; // SUB/ADD
                3'b001: alu_op = 4'b0111; // SLL
                3'b010: alu_op = 4'b0101; // SLT
                3'b011: alu_op = 4'b0110; // SLTU
                3'b100: alu_op = 4'b0100; // XOR
                3'b101: alu_op = (funct7[5]) ? 4'b1001 : 4'b1000; // SRA/SRL
                3'b110: alu_op = 4'b0011; // OR
                3'b111: alu_op = 4'b0010; // AND
            endcase
        end
        
        I_TYPE: begin // I型指令（立即数运算）
            reg_write = 1'b1;
            alu_src = 1'b1;
            case (funct3)
                3'b000: alu_op = 4'b0000; // ADDI
                3'b001: alu_op = 4'b0111; // SLLI
                3'b010: alu_op = 4'b0101; // SLTI
                3'b011: alu_op = 4'b0110; // SLTIU
                3'b100: alu_op = 4'b0100; // XORI
                3'b101: alu_op = (funct7[5]) ? 4'b1001 : 4'b1000; // SRAI/SRLI
                3'b110: alu_op = 4'b0011; // ORI
                3'b111: alu_op = 4'b0010; // ANDI
            endcase
        end
        
        I_LOAD: begin // 加载指令
            reg_write = 1'b1;
            mem_read = 1'b1;
            mem_to_reg = 1'b1;
            alu_src = 1'b1;
            alu_op = 4'b0000; // 加法计算地址
        end
        
        S_TYPE: begin // 存储指令
            mem_write = 1'b1;
            alu_src = 1'b1;
            alu_op = 4'b0000; // 加法计算地址
        end
        
        B_TYPE: begin // 分支指令
            branch = 1'b1;
            case (funct3)
                3'b000: alu_op = 4'b0001; // BEQ
                3'b001: alu_op = 4'b0001; // BNE
                3'b100: alu_op = 4'b0101; // BLT
                3'b101: alu_op = 4'b0101; // BGE
                3'b110: alu_op = 4'b0110; // BLTU
                3'b111: alu_op = 4'b0110; // BGEU
            endcase

            if (funct3 == 3'b001 || funct3 == 3'b100 || funct3 == 3'b110) begin
                branch_cond_ne = 1'b1; // BNE, BLT, BLTU
            end else begin
                branch_cond_ne = 1'b0; // BEQ, BGE, BGEU
            end
        end
        
        J_JAL: begin // JAL指令
            reg_write = 1'b1;
            jump = 1'b1;
            alu_op = 4'b0000;
        end
        
        I_JALR: begin // JALR指令
            reg_write = 1'b1;
            jump = 1'b1;
            alu_src = 1'b1;
            alu_op = 4'b0000;
        end
        
        U_LUI: begin // LUI指令
            reg_write = 1'b1;
            alu_src = 1'b1;
            alu_op = 4'b0000;
        end
        
        U_AUIPC: begin // AUIPC指令
            reg_write = 1'b1;
            alu_src = 1'b1;
            alu_op = 4'b0000;
        end
        
        default: begin
            // 默认情况，所有控制信号为0
        end
    endcase
end

endmodule

