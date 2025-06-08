    addi x12, x0, 0	# x12 = 0
    addi x13, x0, 20	# x13 = 20
    addi x14, x0, 0	# x14 = 0
    c.li x15, 1		# x15 = 1
    addi x16, x0, 1	# x16 = 1

stroe_loop:
    addi x12, x12, 1	# x12 = 1, 2, 3, 4 ... 20
    sw x15, 0(x14)	# add = 0, 4, 8, 12 ... 80
    sll x15, x15, x16	# x15 = 2, 4, 8, 16 ... 1048576
    addi x14, x14, 4	# x14 = 4, 8, 12, 16 ... 84
    blt x12, x13, stroe_loop	# taken * 19, untaken * 1


    addi x12, x0, 0	# x12 = 0
    addi x14, x0, 0	# x14 = 0
    addi x8, x0, 0	# x8 = 0
    addi x13, x13, -1	# x13 = 19

load_loop:
    c.addi x12, 1	# 1, 2, 3, 4 ... 20
    lw x15, 0(x14)	# x15 = 1, 2, 4, 8 ... 524288
    addi x14, x14, 4	# x14 = 4
    c.xor x8, x15	# 
    bge x13, x12, load_loop	# taken * 19, untaken * 1

    nop
    nop
# Hang loop
hang:
    jal x0, hang                                #34
