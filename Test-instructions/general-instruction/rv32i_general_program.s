_start:
    # Initialize some constants
    addi x1, x0, 12          # x1 = 12
    addi x2, x0, 34          # x2 = 34
    addi x3, x0, 56          # x3 = 56

    # Perform arithmetic operations
    add x4, x1, x2           # x4 = x1 + x2 = 46
    sub x5, x3, x1           # x5 = x3 - x1 = 44
    xor x6, x4, x5           # x6 = x4 ^ x5

    # Prepare a memory address (within 1 kB data range, e.g., 0x00000080)
    lui x7, 0x0              # upper 20 bits = 0
    addi x7, x7, 0x80        # x7 = 0x80 (memory address within data range)

    # Store x6 to memory
    sw x6, 0(x7)             # MEM[0x80] = x6

    # Load back the stored value
    lw x8, 0(x7)             # x8 = MEM[0x80]

    # Shift operations
    slli x9, x8, 2           # x9 = x8 << 2
    srli x10, x9, 1          # x10 = x9 >> 1

    # Final OR operation
    or x11, x10, x1          # x11 = x10 | x1

    # Hang loop
hang:
    jal x0, hang
