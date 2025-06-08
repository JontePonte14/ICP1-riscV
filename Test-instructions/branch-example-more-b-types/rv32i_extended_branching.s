_start:
    # Initial register setup
    addi x1, x0, 5          # x1 = 5
    addi x2, x0, 5          # x2 = 5
    addi x3, x0, 0          # x3 = 0

    # BEQ test: should branch
    beq x1, x2, beq_taken
    addi x3, x0, 99         # skipped if beq taken

beq_taken:
    addi x4, x0, 10         # x4 = 10

    # BNE test: should not branch
    bne x1, x2, bne_taken
    addi x5, x0, 20         # runs because bne not taken

bne_taken:
    addi x6, x0, 15         # x6 = 15

    # BLT test: x1 < x6 → true
    blt x1, x6, blt_taken
    addi x7, x0, 77         # skipped

blt_taken:
    addi x8, x0, 42         # x8 = 42

    # BGE test: x6 >= x1 → true
    bge x6, x1, bge_taken
    addi x9, x0, 88         # skipped

bge_taken:
    addi x10, x0, 100       # x10 = 100

    # BLTU test: x1 < x6 unsigned → true (same as signed here)
    bltu x1, x6, bltu_taken
    addi x11, x0, 200       # skipped

bltu_taken:
    addi x12, x0, 222       # x12 = 222

    # BGEU test: x6 >= x1 unsigned → true
    bgeu x6, x1, bgeu_taken
    addi x13, x0, 255       # skipped

bgeu_taken:
    addi x14, x0, 123       # x14 = 123

    # Unconditional jump using jal
    jal x0, skip_this
    addi x15, x0, 111       # should be skipped

skip_this:
    addi x16, x0, 66        # x16 = 66
