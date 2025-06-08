_start:
    # Initial values
    addi x1, x0, 10         # x1 = 10
    addi x2, x0, 20         # x2 = 20

    # First chain of dependent instructions (x3 depends on x1 and x2)
    add x3, x1, x2          # x3 = 30
    sub x4, x3, x1          # x4 = 20
    xor x5, x4, x2          # x5 = 0

    # Load/store with dependency
    addi x6, x0, 0x80       # x6 = 0x80 (memory address) (32 in ram)
    sw x5, 0(x6)            # store x5 to MEM[0x80]
    lw x7, 0(x6)            # load into x7 → data hazard with x5

    # Immediate use of loaded value
    or x8, x7, x1           # x8 = x7 | x1

    # More arithmetic dependencies
    add x9, x8, x2          # x9 = x8 + x2
    and x10, x9, x3         # x10 = x9 & x3

    # Final hazard: use x10 in next operation
    sub x11, x10, x1        # x11 = x10 - x1
