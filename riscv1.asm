.text

_start:
    # 初始化数组（数组从地址0开始）
    li t0, 500        # array[0] = 500
    sw t0, 0(x0)    
    li t0, 73556        # array[1] = 73556
    sw t0, 4(x0)
    li t0, -8134       # array[2] = -8134
    sw t0, 8(x0)
    li t0, 1213        # array[3] = 1213
    sw t0, 12(x0)
    li t0, -12345323        # array[4] = -12345323
    sw t0, 16(x0)

    # 冒泡排序实现
    li a0, 0        # 数组基地址（0x000）
    li a1, 5        # 加载数组长度
    addi a1, a1, -1 # 外层循环次数 = n-1

    li s0, 0        # 外层循环计数器i=0
outer_loop:
    bge s0, a1, exit_sort
    sub t4, a1, s0  # 正确计算内层循环次数：n-1-i
    li s1, 0        # 内层循环计数器j=0
inner_loop:
    # 计算元素地址：base + j*4
    slli t0, s1, 2
    add t1, a0, t0
    lw t2, 0(t1)    # 加载array[j]
    lw t3, 4(t1)    # 加载array[j+1]
    
    ble t2, t3, no_swap
    # 执行交换操作
    sw t3, 0(t1)
    sw t2, 4(t1)
no_swap:
    addi s1, s1, 1
    blt s1, t4, inner_loop  # 使用动态计算的t4

    addi s0, s0, 1
    j outer_loop

exit_sort:
.end _start
