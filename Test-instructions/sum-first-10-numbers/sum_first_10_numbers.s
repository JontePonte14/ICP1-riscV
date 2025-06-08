_start:
    addi x1, x0, 0        # x1 = 0 (sum)
    addi x2, x0, 1        # x2 = 1 (current number)
    addi x3, x0, 10       # x3 = 10 (limit)

loop:
    add x1, x1, x2        # x1 = x1 + x2
    addi x2, x2, 1        # x2 = x2 + 1
    slt x5, x3, x2        # x5 = (x3 < x2) = (x2 > x3)
    bne x5, x0, end       # if x5 != 0 (i.e., x2 > x3), branch to end
    #beq x0, x0, loop          # jump to loop
    jal x0, loop          # jump to loop

end:
    lui x4, 0x0           # upper 20 bits = 0
    addi x4, x4, 0x80     # x4 = 0x80 (memory address)
    sw x1, 0(x4)          # MEM[0x80] = x1 (final sum)

hang:
    jal x0, hang          # infinite loop