# �򻯵��ڴ���ʲ��Գ���
# ����lw��swָ��ĺ��Ĺ���
# ���ս����x1�Ĵ�����0x12345678��ʾ�ɹ���0xFFFFFFFF��ʾʧ��

.text
.global _start
_start:
add x10, x11, x12
    # ����1: �����洢�ͼ���
    li a0, 0xA5A5A5A5
    sw a0, 0(zero)      # �洢����ַ0
    lw a1, 0(zero)      # �ӵ�ַ0����
    bne a0, a1, mem_fail  # ��֤����һ����
    
    # ����2: ��ͬ��ַ�Ĵ洢�ͼ���
    li a0, 0x11223344
    sw a0, 4(zero)      # �洢����ַ4
    lw a1, 4(zero)      # �ӵ�ַ4����
    bne a0, a1, mem_fail  # ��֤����һ����
    
    # ����3: ���ݶ�������֤
    lw a0, 0(zero)      # ���¼��ص�ַ0
    li a1, 0xA5A5A5A5   # ����ֵ
    bne a0, a1, mem_fail  # ��֤����δ��Ӱ��
    
    # ����4: ʹ�ü��ص�ֵ���м���
    li a0, 15           # ʮ����15
    sw a0, 8(zero)      # �洢����ַ8
    
    li a1, 10           # ʮ����10
    sw a1, 12(zero)     # �洢����ַ12
    
    lw a2, 8(zero)      # ���ص�һ��ֵ
    lw a3, 12(zero)     # ���صڶ���ֵ
    
    add a4, a2, a3      # �����
    li a5, 25           # �����ĺ�
    bne a4, a5, mem_fail  # ��֤������
    
    # ���в���ͨ��
    li x1, 0x001F1E33   # ���óɹ���־
    j end_test

mem_fail:
    # �ڴ����ʧ��
    li x1, 0xFFFFFFFF   # ����ʧ�ܱ�־

end_test:
    # ���Խ���������ѭ��
    j end_test