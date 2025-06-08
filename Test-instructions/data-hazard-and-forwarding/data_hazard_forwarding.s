_start:
    # Setup values
    addi x1, x0, 4          # x1 = 4
    addi x2, x0, 8          # x2 = 8

    # Use result of x1 in next instruction (forwarding)
    add x3, x1, x2          # x3 = 4 + 8 = 12
    sub x4, x3, x1          # x4 = 12 - 4 = 8 (needs x3 right after)

    # Load value from memory
    addi x5, x0, 0x40       # x5 = 0x40 (memory address)
    sw x3, 0(x5)            # MEM[0x40] = 12
    lw x6, 0(x5)            # x6 = MEM[0x40] = 12

    # Load-use hazard: x6 used immediately
    add x7, x6, x2          # x7 = x6 + 8 = 20 (must stall if no bypass)

    # Forward from x7 to x8
    and x8, x7, x1          # x8 = 20 & 4 = 4
