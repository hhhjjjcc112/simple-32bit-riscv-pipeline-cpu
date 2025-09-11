# ��֧���Գ���
# �ڲ�ͬ��֧·����Ϊx1���費ͬ��ֵ
# ������֤x1�Ƿ�ΪԤ��ֵ0x12345678

.text
.global _start
_start:
    # ��ʼ����������
    li a0, 42          # ����ֵ1
    li a1, 42          # ����ֵ2����a0��ȣ�
    li a2, 100         # ����ֵ3
    li a3, 200         # ����ֵ4
    
    # ����1: beq (��ȷ�֧)
    beq a0, a1, branch_equal
    
    # �������ȣ����ô���ֵ����ת������
    li x1, 0xDEADBEEF
    j end_test

branch_equal:
    # ����2: bne (����ȷ�֧)
    bne a0, a2, branch_not_equal
    
    # �����ȣ����ô���ֵ����ת������
    li x1, 0xBADBAD00
    j end_test

branch_not_equal:
    # ����3: blt (�з���С�ڷ�֧)
    li t0, -10         # ����
    li t1, 10          # ����
    blt t0, t1, branch_less_than
    
    # �����С�ڣ����ô���ֵ����ת������
    li x1, 0xFEEDFACE
    j end_test

branch_less_than:
    # ����4: bge (�з��Ŵ��ڵ��ڷ�֧)
    li t2, 50
    li t3, 50
    bge t2, t3, branch_greater_equal
    
    # ��������ڵ��ڣ����ô���ֵ����ת������
    li x1, 0xCAFEBABE
    j end_test

branch_greater_equal:
    # ����5: bltu (�޷���С�ڷ�֧)
    li t4, 0x0000FFFF  # С�޷�����
    li t5, 0xFFFFFFFF  # ���޷�����
    bltu t4, t5, branch_unsigned_less
    
    # �����С�ڣ����ô���ֵ����ת������
    li x1, 0xABCD1234
    j end_test

branch_unsigned_less:
    # ����6: bgeu (�޷��Ŵ��ڵ��ڷ�֧)
    li t6, 0xFFFFFFFF  # ���޷�����
    li s0, 0x0000FFFF  # С�޷�����
    bgeu t6, s0, branch_unsigned_greater
    
    # ��������ڵ��ڣ����ô���ֵ����ת������
    li x1, 0x1234ABCD
    j end_test

branch_unsigned_greater:
    # ���з�֧����ͨ����������ȷֵ
    li x1, 0x12345678
    
    # ��֤���ս��
    li s1, 0x12345678
    bne x1, s1, test_failed
    
    # ���Գɹ�
    j end_test

test_failed:
    # ����ʧ�ܴ���
    li x1, 0xFFFFFFFF  # ����ʧ�ܱ�־
    j end_test

end_test:
    # ���Խ���������ѭ��
    # ��ʱx1��ֵ��ʾ���Խ��:
    # 0x12345678 - ���з�֧����ͨ��
    # ����ֵ - ����ʧ�ܣ�ֵ��ʾʧ�ܵ�λ��
    j end_test