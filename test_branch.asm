# 分支测试程序
# 在不同分支路径中为x1赋予不同的值
# 最终验证x1是否为预期值0x12345678

.text
.global _start
_start:
    # 初始化测试条件
    li a0, 42          # 测试值1
    li a1, 42          # 测试值2（与a0相等）
    li a2, 100         # 测试值3
    li a3, 200         # 测试值4
    
    # 测试1: beq (相等分支)
    beq a0, a1, branch_equal
    
    # 如果不相等，设置错误值并跳转到结束
    li x1, 0xDEADBEEF
    j end_test

branch_equal:
    # 测试2: bne (不相等分支)
    bne a0, a2, branch_not_equal
    
    # 如果相等，设置错误值并跳转到结束
    li x1, 0xBADBAD00
    j end_test

branch_not_equal:
    # 测试3: blt (有符号小于分支)
    li t0, -10         # 负数
    li t1, 10          # 正数
    blt t0, t1, branch_less_than
    
    # 如果不小于，设置错误值并跳转到结束
    li x1, 0xFEEDFACE
    j end_test

branch_less_than:
    # 测试4: bge (有符号大于等于分支)
    li t2, 50
    li t3, 50
    bge t2, t3, branch_greater_equal
    
    # 如果不大于等于，设置错误值并跳转到结束
    li x1, 0xCAFEBABE
    j end_test

branch_greater_equal:
    # 测试5: bltu (无符号小于分支)
    li t4, 0x0000FFFF  # 小无符号数
    li t5, 0xFFFFFFFF  # 大无符号数
    bltu t4, t5, branch_unsigned_less
    
    # 如果不小于，设置错误值并跳转到结束
    li x1, 0xABCD1234
    j end_test

branch_unsigned_less:
    # 测试6: bgeu (无符号大于等于分支)
    li t6, 0xFFFFFFFF  # 大无符号数
    li s0, 0x0000FFFF  # 小无符号数
    bgeu t6, s0, branch_unsigned_greater
    
    # 如果不大于等于，设置错误值并跳转到结束
    li x1, 0x1234ABCD
    j end_test

branch_unsigned_greater:
    # 所有分支测试通过，设置正确值
    li x1, 0x12345678
    
    # 验证最终结果
    li s1, 0x12345678
    bne x1, s1, test_failed
    
    # 测试成功
    j end_test

test_failed:
    # 测试失败处理
    li x1, 0xFFFFFFFF  # 设置失败标志
    j end_test

end_test:
    # 测试结束，无限循环
    # 此时x1的值表示测试结果:
    # 0x12345678 - 所有分支测试通过
    # 其他值 - 测试失败，值表示失败的位置
    j end_test