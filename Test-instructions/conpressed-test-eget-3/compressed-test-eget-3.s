    c.li x9, 10         #0 x9 = 10
    c.li x10, 27        #2 x10 = 27

    c.beqz x8, skip1    #4 Hoppar till skip1 om x8 = 0 (x8 = 0 default)
    c.li x8, 30         #6 x8 = 15, detta ska inte ske

skip1:
    c.addi x8, 11       #8 x8 = 11 + 0 = 11 - Om x8 blir 26 så något blivit fel
    c.beqz x8, skip1    #10 Hoppar om x8 = 0, vilket inte ska ske.

    c.bnez x9, skip2    #12 Hoppar till skip2, pga x9 != 0
    c.addi x9, 10       #14 x9 = 10, detta ska inte ske

skip2:
    c.li x11, 10        #16 x11 = 10
    c.sub x9, x11       #18 x9 = x9 - x11 = 10 - 10 = 0
    c.bnez x9, skip2    #20 Hoppar om x9 != 0, vilket inte ska ske
    c.beqz x15, skip3   #22 Hoppar om x15 = 0, vilket den ska
    
    c.li x11, 15        #24 x11 = 15, ska inte ske, ska ske efter c.jr x14
    c.li x9, 50         #26 x9 = 50, ska inte ske, ska ske efter c.jr x14
    c.li x13, 38        #28 x13 = 38
    c.jr x13            #30 Hoppar till address PC = 40, rad 30 här

skip3:
    c.li x12, 50        #32 x12 = 50. Ska ske efter hoppet
    c.li x14, 24        #34 x14 = 24
    c.jr x14            #36 Hoppar till adress PC=24, rad 21 här.

    c.addi x14, 10      #38 x14 = 10

    nop
    nop

# Hang loop
hang:
    jal x0, hang

# Detta program testar följande instruktioner
# c.j kunde ej kompileras för någon anledning
# li 
# addi
# sub
# beqz
# bnez
# c.jr