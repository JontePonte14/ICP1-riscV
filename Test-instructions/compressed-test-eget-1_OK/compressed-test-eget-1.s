    c.addi x8, 15     # x8 = 15 
    c.addi x9, 16     # x9 = 16 

    c.addi x9, 15     # x9 = x9 + 15 = 31
    c.andi x8, 7      # x8 = x8 & 7 = 1111 & 0111 = 0111 = 7 

    c.addi x13, 5     # x13 = 5
    c.add x8, x13     # x8 = x8 + x13 = 7 + 5 = 12 
    
    c.addi x12, 20    # x12 = 20
    c.sub x9, x12      # x9 = 31 - 20 = 11 # Blir 20 och inte 11, kör addi x12 istället för sub?
    
    c.addi x11, 1   # x11 = 1 = 001
    c.addi x10, 6    # x10 = 6 = 110
    c.addi x14, 1    # x14 = 1 = 001
    c.and x11, x10  # x11 = x11 && x10 = 001 && 110 = 001 = 0
    c.or x14, x10   # x10 = x14 || x10 = 001 || 110 = 111 = 7, blir 6 (110 varför?)

    nop
    nop

# Hang loop
hang:
    jal x0, hang

# Detta program testar följande instruktioner
# addi
# andi
# add
# sub
# add
# or
