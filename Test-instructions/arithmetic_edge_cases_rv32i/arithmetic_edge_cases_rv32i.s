_start:
    # INT_MAX = 0x7FFFFFFF = 0x7FFFF000 | 0xFFF
    lui x1, 0x7FFFF          # x1 = 0x7FFFF000
    ori x1, x1, 0xFFF        # x1 = 0x7FFFFFFF

    # INT_MIN = 0x80000000
    lui x2, 0x80000          # x2 = 0x80000000

    # INT_MAX + 1
    addi x3, x1, 1           # x3 = 0x80000000

    # INT_MIN - 1
    addi x4, x2, -1          # x4 = 0x7FFFFFFF

    # 0 - 0
    addi x5, x0, 0           # x5 = 0
    sub x6, x5, x5           # x6 = 0 - 0 = 0

    # -1 + 1
    addi x7, x0, -1          # x7 = 0xFFFFFFFF
    addi x8, x7, 1           # x8 = 0

    # Load base address 0x100 into x9
    lui x9, 0x0
    addi x9, x9, 0x100       # x9 = 0x100

    # Store results in memory
    sw x1, 0(x9)             # 0x100 = INT_MAX
    sw x2, 4(x9)             # 0x104 = INT_MIN
    sw x3, 8(x9)             # 0x108 = INT_MAX + 1
    sw x4, 12(x9)            # 0x10C = INT_MIN - 1
    sw x6, 16(x9)            # 0x110 = 0 - 0
    sw x8, 20(x9)            # 0x114 = -1 + 1
    sw x7, 24(x9)            # 0x118 = -1

    # Infinite loop
loop:
    jal x0, loop