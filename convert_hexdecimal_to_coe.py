def main():
    input_filename = 'test_program.hex'  # 输入文件名，请根据实际文件修改
    output_filename = 'test_program.coe'  # 输出文件名，请根据实际需要修改

    with open(input_filename, 'r') as f_in:
        lines = f_in.readlines()

    data_list = []
    for line in lines:
        line = line.strip()
        if line == '':
            continue
        # 去除可能的0x或0X前缀
        if line.startswith('0x') or line.startswith('0X'):
            line = line[2:]
        # 检查是否为有效十六进制字符串
        if not all(c in '0123456789abcdefABCDEF' for c in line):
            print(f"跳过无效行: {line}")
            continue
        # 处理长度：32位对应8个十六进制字符
        if len(line) > 8:
            print(f"警告: 行 '{line}' 超过8个字符，将被截断")
            line = line[:8]  # 截断到8个字符
        else:
            line = line.zfill(8)  # 填充前导零到8个字符
        data_list.append(line)

    # 写入COE文件
    with open(output_filename, 'w') as f_out:
        f_out.write("MEMORY_INITIALIZATION_RADIX=16;\n")
        f_out.write("MEMORY_INITIALIZATION_VECTOR=\n")
        for i, data in enumerate(data_list):
            if i == len(data_list) - 1:
                f_out.write(f"{data};\n")
            else:
                f_out.write(f"{data},\n")

if __name__ == '__main__':
    main()