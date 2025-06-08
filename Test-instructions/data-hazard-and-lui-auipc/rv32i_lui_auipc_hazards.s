_start:
    # Use address safely within 1 kB RAM range
    lui x1, 0x0               # x1 = 0x00000000
    addi x2, x1, 0x80         # x2 = 0x00000080 (valid address within 1 kB)

    # Store a value to that address
    addi x3, x0, 123          # x3 = 123
    sw x3, 0(x2)              # MEM[0x80] = 123

    # Load from that address
    lw x4, 0(x2)              # x4 = 123

    # AUIPC example: compute PC-relative address
    auipc x5, 0x0             # x5 = PC
    addi x6, x5, 12           # x6 = PC + 12 (data hazard on x5)

    # Use the loaded value (x4) in a calculation
    add x7, x4, x6            # x7 = 123 + (PC + 12)

    # Use the result again immediately
    xor x8, x7, x3            # x8 = x7 ^ 123

    # Hang
hang:
    jal x0, hang