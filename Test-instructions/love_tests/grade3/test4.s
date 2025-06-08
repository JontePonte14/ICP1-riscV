# Finds sum of the first N numbers recursively.

# x1: Return Address
# x30: Stack Pointer
# x10 : n but also sum function's return value
# expected program flow w/perfect bp: 
# 0,4|12,16,20,24,28,32,36|56,60|12,16,20,24,28,32,36|56,60|12,16,20,24,28,32,36|
# x10=3   n=2                         n=1                         n=0
main:
    addi x10, x0, 3        #0 n
    jal x1, SUM             #4 Sum(n)
    jal x1, END             #8

SUM:
    sw x1, 0(x30)           #12 Save return address on stack
    sw x10, 4(x30)          #16 Save argument n
    addi x30, x30, 8        #20 Adjust stack pointer

    addi x11, x10, -1       #24 x11 = n - 1
    nop                     #28
    nop                     #32
    bge x11, x0, RECUR      #36 if (n - 1) >= 0 then do a recursive call
    addi x10, x0, 0         #40 Return 0 (base case)
    addi x30, x30, -8       #44 Pop 2 items
    ret                     #48 jalr x0, 0(x1)
RECUR:
    addi x10, x10, -1       #52 n - 1
    jal x1, SUM             #56 Sum(n-1)
    addi x20, x10, 0        #60 x20 = rsult of sum. i.e. x20 = Sum(n - 1)
    addi x30, x30, -8       #64 Adjust the stack
    lw x10, 4(x30)          #68 Restore n
    lw x1, 0(x30)           #72 Restore return address
    add x10, x10, x20       #76 x10 = n + sum(n - 1)
    nop                     #80
    nop                     #84
    ret                     #88 return x10

END:
nop                         #92
nop                         #96

    # Hang loop
hang:
    jal x0, hang            #100


# Kommentar:
# ret = jalr x0, 0(x1)
# I ripes loopar den oändligt
# x1 blir 0x0000000c
# x10 blir 0, ska vara 1
# x11 blir 0xffffffff (-1 antar jag)
# x30 blir 0xfffffd78, x30 ska vara 0
# Den verkar köra loopen in gång för mycket,
    # -> x11 blir -1 och x10 blir 0 därmed, istället för de värdena i borde få