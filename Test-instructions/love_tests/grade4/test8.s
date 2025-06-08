    lui x8, 0x80000	# x8 = -2147483648			pc: 0
    addi x8, x8, 0x000	# x8 = -2147483648			4

    lui x9, 0xffff	# 					8
    c.li x9, 15		# x9 = 15				12

loop:
    addi x9, x9, -1	# x9 = 14, 13 ...			14
    c.srai x8, 1	# x8 = x8/2, x8/2 ...			18
    nop			                                    #20
    c.bnez x9, loop	# taken * 14, untaken * 1		24

    nop                                         # 26
    nop                                         # 30

# Hang loop
hang:
    jal x0, hang                                #34