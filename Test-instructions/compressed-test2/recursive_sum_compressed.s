# Addresses:
# 0x0000: addi x10, x0, 1
# 0x0004: c.jal SUM      => offset = 0x0008 - 0x0004 = +0x0004
# 0x0006: c.j END        => offset = 0x0038 - 0x0006 = +0x0032
# 0x0028: RECUR's `jal x1, SUM` => offset = 0x0008 - 0x0028 = -0x0020

# OBS! The functionality of the program depends on what register is used for linking
# In the program, x1 is the register for keeping return addresses, but in the instruction specification, x0 is used.

main:
    addi x10, x0, 1           # 0x0000
    c.jal 4                   # 0x0004 → jump to SUM (PC+4 = 0x0008)
    c.j 50                   # 0x0006 → jump to END (PC+50 = 0x0038)

# SUM starts at 0x0008
    sw x1, 0(x30)
    sw x10, 4(x30)
    addi x30, x30, 8

    addi x11, x10, -1
    nop
    nop
    bge x11, x0, 32          # 32 bytes forward to RECUR label (offset depends on actual layout)

    addi x10, x0, 0
    addi x30, x30, -8
    c.jalr x1                # compressed return with link

# RECUR starts 32 bytes from bge (compute correctly in actual use)
RECUR:
    c.addi x10, -1
    jal x1, -32              # PC-relative offset to SUM (0x0008 - 0x0028 = -32)
    addi x20, x10, 0
    addi x30, x30, -8
    lw x10, 4(x30)
    lw x1, 0(x30)
    add x10, x10, x20
    nop
    c.addi x0, 1
    c.jr x1

# END at 0x0038
    nop
    nop

hang:
    jal x0, hang
