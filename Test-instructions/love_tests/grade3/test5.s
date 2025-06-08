main:
    lui x1, 0xa9876      # x1 = 0xa9876000
    addi x1, x1, 0x543   # x1 = 0xa9876543

    sw x1, 0(x0)

    lb x2, 0(x0)	# x2 = 67
    lb x3, 1(x0)	# x3 = 101	
    lb x4, 2(x0)	# x4 = -121
    lb x5, 3(x0)	# x5 = -87

    lbu x6, 2(x0)

    lh x7, 0(x0)
    lh x8, 2(x0)

    lhu x9, 2(x0)

    lw x10, 0(x0)

    sb x2, 4(x0)
    sb x3, 5(x0)
    sh x8, 6(x0)

    lw x11, 4(x0)

    nop
    nop
    nop
    # Hang loop
hang:
    jal x0, hang


# Kommentar:
# Vi missar nog sign extendeing på x4, x5, x8
# Vi saknas sign extention på lb instruktioner
# Sign extenda beroende på vad första biten är
# Annars ok!

# Svar:
# Funkar nu. Slarvigt fel så att sign extension skrevs över