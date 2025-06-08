.globl main
# Finds sum of the first N numbers recursively.

# x1: Return Address
# x30: Stack Pointer
# x10 : n but also sum function's return value

main:
    lui x1, 0x414e1
    addi x1, x1, 0x47b # 12.88
    lui x2, 0x40490
    addi x2, x2, 0x625 # 3.141

    fmv.w.x f1, x1
    fmv.w.x f2, x2

    fmul.s f10, f1, f2
    fmul.s f11, f1, f2

    fsqrt.s f12, f1
    fsqrt.s f13, f2

    fsw f13, 0(x0)
    flt.s x4, f1, f2
    lw x3, 0(x0)

    nop
    nop

