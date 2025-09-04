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
    input wire       mem_read_ex,  // EX���ڴ��ʹ��
    input wire       control_ex,      // EX���Ƿ�Ϊ����ָ��
    input wire [31:0] correct_pc_ex,  // EX����ȷ��PCֵ
    input wire [31:0] pc_id,        // ID��PCֵ
    output reg       load_use_hazard,        // ��ˮ��ͣ���ź�
    output reg       control_hazard      // ����ð���ź�
);

always @(*) begin
    
    // ����ʹ��ð��, ���mem�׶���Ҫ���ڴ�, ex�׶ζ��ļĴ�����Ҫд�ļĴ���
    load_use_hazard = mem_read_ex && 
                       ((rs1_id != 5'd0 && rs1_id == rd_ex) || 
                        (rs2_id != 5'd0 && rs2_id == rd_ex));
    
    // ����ð��, ��֧����תָ����Ԥ�����
    control_hazard = control_ex && (correct_pc_ex != pc_id);
end

endmodule

