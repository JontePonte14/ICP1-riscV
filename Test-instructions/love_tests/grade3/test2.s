    lui x8, 0x80000   # x8 = 0x80000000
    addi x8, x8, 0x000  # x8 = 0x80000000

    lui x9, 0xffff   #x9 = 0xffff  # för få bitar?
    addi x9, x0, 15  #x9 = 15

loop:
    addi x9, x9, -1  #x9 = 14
    srai x8, x8, 1  #
    nop
    bne x9, x0, loop

    nop
    nop

    # Hang loop
hang:
    jal x0, hang

# Kommenterar:
# x8 ska skiftas så det blir 0xFFFF0000 men är 0x00010000
# x9 är noll och det är korrekt
# Det är kanske problem med srai instruktionen?
# srai skiftar inte in något, utan den skiftar bara allting till höger
# Annars ok

# Svar:
# Testet fungerar nu! problemet var att den inte tolkade ena talet som signed: la till sign conversion i denna raden:
#  ALU_SRA: result = $signed(left_operand) >>> right_operand[4:0];