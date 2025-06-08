_start:
    # Setup registers
    addi x1, x0, 5          # x1 = 5
    addi x2, x0, 5          # x2 = 5
    addi x3, x0, 0          # x3 = 0 (result)

    # Test BEQ: should branch since x1 == x2
    beq x1, x2, equal_case

    # If branch not taken, this will run (should not run)
    addi x3, x0, 99         # x3 = 99 (should be skipped)

equal_case:
    addi x4, x0, 10         # x4 = 10

    # Test BNE: should not branch since x1 == x2
    bne x1, x2, not_equal_case

    # This should run (branch not taken)
    addi x5, x0, 20         # x5 = 20

not_equal_case:
    # Test BLT: x1 < x6? (x6 = 10)
    addi x6, x0, 10         # x6 = 10
    blt x1, x6, less_than   # x1 = 5 < 10 → branch

    # Should be skipped
    addi x7, x0, 77

less_than:
    addi x8, x0, 42         # x8 = 42 (should execute)
