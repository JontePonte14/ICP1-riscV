    addi x1, x0, 0 	# x1 = 0

    c.li x8, 5  	# x8 = 5
    c.li x9, 3		# x9 = 3
    c.add x9, x8	# x9 = 8
    c.addi x9, -2	# x9 = 6

    c.li x10, 15	# x10 = 15
    c.sub x9, x10	# x9 = -9

    c.slli x10, 1	# x10 = 30
    c.srli x9, 1	# x9 = 2147483643

    c.li x15, 0		
    c.sw x10, x15, 0
    c.sw x9, x15, 4

    c.addi x15, 4	# x15 = 4
    c.lw x11, x15, 0	# x11 = 2147483643
    lw x12, -4(x15)	# x12 = 30
    c.mv x13, x10	# x13 = 30
    c.sub x13, x12	# x13 = 0
    c.beqz x13, l	# taken
    addi x1, x1, 1
    addi x1, x1, 1
    addi x1, x1, 1

l:
    addi x1, x1, 0x123	# x1 = 291

    nop
    nop

# Hang loop
hang:
    jal x0, hang