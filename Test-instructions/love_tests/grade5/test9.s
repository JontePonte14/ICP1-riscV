.globl main

main:
    lui x1, 0x12345
    addi x1, x1, 0x543

    lui x2, 0x54321
    addi x2, x2, 0x678

    mul x3, x1, x2
    mulh x4, x1, x2

    lui x4, 0
    addi x4, x4, 156

    div x5, x1, x4
    rem x6, x1, x4

    addi x7, x0, -15

    addi x8, x0, 4

    mul x9, x8, x7
    div x10, x7, x8
    divu x10, x7, x8
    rem x11, x7, x8
    remu x12, x7, x8

    nop
    nop
    nop
