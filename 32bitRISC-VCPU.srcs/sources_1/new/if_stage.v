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
    input wire        load_use_hazard,      // ����ʹ��ð���ź�
    input wire        control_hazard,       // ����ð���ź�
    input wire [31:0] correct_pc,        // ��ȷ��PCֵ
    output reg [31:0] pc_predict,    // Ԥ���PCֵ
    output reg [31:0] pc_out,            // ���������
    output reg [31:0] instruction    // ��ǰָ��
);

reg boot;

reg [31:0] pc_current1, pc_predict1, pc_current2, pc_predict2;
wire [31:0] douta;
wire rsta_busy;



// PC�����߼�
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pc_predict1 <= 32'd4;
        pc_current1 <= 32'd0;

        pc_current2 <= 32'd0;
        pc_predict2 <= 32'd0;

        pc_out <= 32'd0;
        pc_predict <= 32'd0;
        instruction <= 32'd0;

        boot <= 1'b0;
    end else if (load_use_hazard) begin
        // ���ֵ�ǰ״̬��������
    end else if (control_hazard) begin
        // ��������ð�գ���ת����ȷ��PC
        pc_predict1 <= correct_pc + 32'd4; // Ԥ����һ��PC
        pc_current1 <= correct_pc;

        pc_current2 <= 32'd0;
        pc_predict2 <= 32'd0;

        pc_out <= 32'd0;
        pc_predict <= 32'd0;
        instruction <= 32'd0;

        boot <= 1'b0;
    end else begin
        pc_predict1 <= pc_predict1 + 32'd4; // Ԥ����һ��PC
        pc_current1 <= pc_predict1;

        pc_current2 <= pc_current1;
        pc_predict2 <= pc_predict1;
        boot <= 1'b1;
        
        if (boot) begin
            pc_out <= pc_current2;
            pc_predict <= pc_predict2;
            instruction <= douta;
        end else begin
            pc_out <= 32'd0;
            pc_predict <= 32'd0;
            instruction <= 32'd0;
        end
    end
end

instruction_memory instm (
  .clka(clk),
//   .rsta(!rst_n),
  .ena(!load_use_hazard),
  .addra(pc_current1[12:2]), // [10:0]
  .douta(douta)  // [31:0]
//   .rsta_busy(rsta_busy)
);

endmodule

