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
    input wire [4:0] rs1_id,      // ID��Դ�Ĵ���1��ַ
    input wire [4:0] rs2_id,      // ID��Դ�Ĵ���2��ַ
    input wire [4:0] rd_ex,       // EX��Ŀ��Ĵ�����ַ
    input wire [4:0] rd_mem_inner,      // MEM��Ŀ��Ĵ�����ַ1
    input wire       mem_to_reg_ex,  // EX���ڴ��ʹ��
    input wire       mem_to_reg_inner_mem,  // MEM���ڴ��ʹ��1
    input wire       control_ex,      // EX���Ƿ�Ϊ����ָ��
    input wire [31:0] correct_pc_ex,  // EX����ȷ��PCֵ
    input wire [31:0] pc_id,        // ID��PCֵ
    output reg       load_use_hazard,        // ��ˮ��ͣ���ź�
    output reg       control_hazard      // ����ð���ź�
);

always @(*) begin
    
    // ����ʹ��ð��, ���mem�׶���Ҫ���ڴ�, ex�׶ζ��ļĴ�����Ҫд�ļĴ���
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
    
    // ����ð��, ��֧����תָ����Ԥ�����
    control_hazard = control_ex && (correct_pc_ex != pc_id);
end

endmodule

