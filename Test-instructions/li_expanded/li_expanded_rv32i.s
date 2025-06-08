_start:
    # Load various constants into x10–x19 using lui + addi

    # x10 = 0x00000001
    lui x10, 0x0
    addi x10, x10, 1

    # x11 = 0x00000FFF (corrected)
    lui x11, 0x1
    addi x11, x11, -1    # 0x1000 - 1 = 0xFFF

    # x12 = 0x00001000
    lui x12, 0x1
    addi x12, x12, 0x0

    # x13 = 0x12345678
    lui x13, 0x12345
    addi x13, x13, 0x678

    # x14 = 0xFFFFF800 (negative value: -2048)
    lui x14, 0xFFFFF
    addi x14, x14, -2048     # F800

    # x15 = 0x7FFFFFFF (INT_MAX)
    lui x15, 0x7FFFF
    addi x15, x15, -1

    # x16 = 0x80000000 (INT_MIN)
    lui x16, 0x80000
    addi x16, x16, 0

    # x17 = 0xDEADBEEF
    lui x17, 0xDEADB
    addi x17, x17, -273  # 0xEEF = -273 in 12-bit signed

    # x18 = 0x000007FF
    lui x18, 0x0
    addi x18, x18, 0x7FF  # max positive 12-bit signed

    # x19 = 0xFFFFFFFF (-1)
    lui x19, 0xFFFFF
    addi x19, x19, -1

    # Infinite loop
loop:
    jal x0, loop