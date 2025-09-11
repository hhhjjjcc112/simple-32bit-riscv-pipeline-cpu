# 简化的内存访问测试程序
# 测试lw和sw指令的核心功能
# 最终结果在x1寄存器：0x12345678表示成功，0xFFFFFFFF表示失败

.text
.global _start
_start:
add x10, x11, x12
    # 测试1: 基本存储和加载
    li a0, 0xA5A5A5A5
    sw a0, 0(zero)      # 存储到地址0
    lw a1, 0(zero)      # 从地址0加载
    bne a0, a1, mem_fail  # 验证数据一致性
    
    # 测试2: 不同地址的存储和加载
    li a0, 0x11223344
    sw a0, 4(zero)      # 存储到地址4
    lw a1, 4(zero)      # 从地址4加载
    bne a0, a1, mem_fail  # 验证数据一致性
    
    # 测试3: 数据独立性验证
    lw a0, 0(zero)      # 重新加载地址0
    li a1, 0xA5A5A5A5   # 期望值
    bne a0, a1, mem_fail  # 验证数据未受影响
    
    # 测试4: 使用加载的值进行计算
    li a0, 15           # 十进制15
    sw a0, 8(zero)      # 存储到地址8
    
    li a1, 10           # 十进制10
    sw a1, 12(zero)     # 存储到地址12
    
    lw a2, 8(zero)      # 加载第一个值
    lw a3, 12(zero)     # 加载第二个值
    
    add a4, a2, a3      # 计算和
    li a5, 25           # 期望的和
    bne a4, a5, mem_fail  # 验证计算结果
    
    # 所有测试通过
    li x1, 0x001F1E33   # 设置成功标志
    j end_test

mem_fail:
    # 内存测试失败
    li x1, 0xFFFFFFFF   # 设置失败标志

end_test:
    # 测试结束，无限循环
    j end_test