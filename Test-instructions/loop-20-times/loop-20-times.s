    .section .text
    .globl _start

_start:
    li t0, 0         # Loop counter (t0 = 0)
    li t1, 20        # Loop limit (t1 = 20)

loop:
    # Your loop body goes here
    # For example: increment a register
    # addi t2, t2, 1  # Uncomment if you want to do something inside loop

    addi t0, t0, 1   # Increment loop counter
    blt t0, t1, loop # If t0 < 20, repeat loop

end:
    # Exit loop, do nothing (in a real program, you'd terminate or jump to another function)
    j end            # Infinite loop to prevent falling off the end
