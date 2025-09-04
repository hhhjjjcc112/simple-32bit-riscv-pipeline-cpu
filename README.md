小学期的课程设计, 被迫营业.jpg

运行程序: riscv1.asm / test_program.hex

实现指令:
- R型指令: add, sub, and, or, xor, sll, srl, sra, slt, sltu
- I型指令: addi, andi, ori, xori, slli, srli, srai, slti, sltiu, lw, jalr
- S型指令: sw
- B型指令: beq, bne, blt, bge, bltu, bgeu
- U型指令: lui, auipc
- J型指令: jal

流水线设计:
- 取指(IF)
- 译码(ID)
- 执行(EX)
- 访存(MEM)
- 写回(WB)

数据前递:
- EX/MEM/WB -> ID

数据冒险处理:
- load-use hazard: IF和ID阶段暂停一周期, EX阶段插入nop

控制冒险处理:
- 分支预测: 静态预测为不跳转
- 预测失败处理: IF强制更新pc, ID和EX阶段插入nop

下一步计划:
- 将指令存储器替换为ROM, 数据存储器替换为RAM
- 优化控制冒险处理, 采用动态分支预测
- 添加lb, lh, sb, sh指令支持(lhu, lbu?)