c.addi x8, 5    # x8 = 5 = 0101
c.addi x9, 7    # x9 = 7 = 0111
c.addi x10, 4   # x10 = 4
c.xor x9, x8    # x9 = x9 ^ x8 = 0010 = 2 (Ska bli 2 men blir 5 i nuläget)

c.sw x9, 0(x10) # MEM[4] = 2 (Den lyckas sparar men sparar 5 istället för 2 pga följdfel)
c.mv x13, x8    # x13 = x8 = 5 (Verkar inte göra något, x13 förändras icke)

c.li x11, 30    # x11 = 30
c.lui x12, -1   # x12 = -1 << 12 = -4096 (Blir -33554432 men det är kanske rätt ändå? chat säger nej det är fel iallafall)

c.slli x8, 1    # x8 = x8 << 1 = 1010 = 10 (Funkar ej? Blir 0 istället för 10)
c.srai x12, 2   # x12 = -4096 >> 2 = -1024 (Följdfel: Den får rätt utifrån vad x12 är innan, blev -8388608)
c.srli x11, 2   # x11 = 30 >> 2 = 00111 = 7 (Blir 0, vilket den inte borde vara)

c.lw x14, 0(x10)# x14 = MEM[4] = 2 (Verkar inte göra något, x14 blir 0)

 
    nop
    nop

# Hang loop
hang:
    jal x0, hang


# Detta program testar följande instruktioner
# addi
# xor
# mv
# lui
# slli
# srai
# srli
# lw
# sw