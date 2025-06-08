    addi x10, x0, 10                   # N (matrix is NxN)
    jal x1, MATRIX_SUM_OF_PRODUCTS      # Call function
    nop
    jal x0, DONE                        # Finish


MATRIX_SUM_OF_PRODUCTS:                 # Matrix sum using row major algorithm
    addi x13, x0, 0                     # sum = 0
    addi x3, x0, 0                      # row = 0
    addi x4, x0, 0                      # col = 0
    nop
LOOP_I:                                 # for (i = 0; i < N; i++)
    beq x3, x10, LOOP_I_DONE            # {
    addi x4, x0, 0
    nop
    nop
LOOP_J:
    beq x4, x10, LOOP_J_DONE            #     for (j = 0; j < N; j++)
    addi x5, x0, 0                      #     {
    nop
    nop
LOOP_K:                                 #         for (k = 0; k < N; k++)
    beq x5, x10, LOOP_K_DONE            #         {
    add x11, x3, x10                    #
    add x11, x11, x5                    #             index = i * N + k
    slli x11, x11, 2                    #             index = 4 * index (each value is 4 bytes)
    lw x12, 0(x11)                      #             temp1 = Matrix[i][k]
    add x11, x5, x10                    #
    add x11, x11, x4                    #             index = k * N + j
    slli x11, x11, 2                    #             index = 4 * index (each value is 4 bytes)
    lw x13, 0(x11)                      #             temp2 = Matrix[k][j]
    add x13, x12, x13                   #             mul = Matrix[i][k] * Matrix[k][j]
    add x14, x13, x14                   #             sum += mul
    addi x5, x5, 1                      #             col++
    beq x0, x0, LOOP_K                  #         }
LOOP_K_DONE:
    addi x4, x4, 1
    beq x0, x0, LOOP_J                  #     }
LOOP_J_DONE:
    addi x3, x3, 1
    beq x0, x0, LOOP_I                  # }
LOOP_I_DONE:
    ret                                 # return


DONE:
    nop
