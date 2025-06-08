    .text
    .globl _start

_start:

# --- Setup ---
    lui x8, 0x1            # x8 = 0x1000 (use x8 instead of x2) 
    addi x8, x8, 0x000     # complete li x8, 0x1000            

    addi x9, x0, 42        # x9 = 42                            
    addi x10, x0, 0        # x10 = 0                            

# -------------------------
# Memory: C.LW, C.SW
# -------------------------
    c.sw x9, 0(x8)         # store x9 at [x8]                   
    c.lw x11, 0(x8)        # load it back into x11              
    c.add x12, x11         # x12 = x12 + x11 (x12 initially 0)  

# -------------------------
# Arithmetic: C.ADDI, C.SUB, C.AND, C.OR, C.XOR
# -------------------------
    c.li x13, 7            # x13 = 7                            
    c.addi x13, 5          # x13 = 12                           
    c.lui x14, 0x1         # x14 = 0x1000                       
    c.andi x13, 0xF        # x13 &= 0xF = 12                    
    c.and x14, x13         # x14 &= x13                         
    c.or x15, x13          # x15 |= x13                         
    c.xor x8, x13          # x8 ^= x13                          
    c.sub x9, x13          # x9 -= x13                          

# -------------------------
# Shifts: C.SLLI, C.SRAI, C.SRLI
# -------------------------
    addi x10, x0, 4        # x10 = 4                            
    c.slli x10, 2          # x10 <<= 2 = 16                     
    c.srai x10, 1          # x10 >>= 1 = 8 (arith)              
    c.srli x10, 1          # x10 >>= 1 = 4 (logic)              

# -------------------------
# Moves and jumps: C.MV, C.J, C.JR, C.JAL, C.JALR
# -------------------------
    c.mv x11, x10          # x11 = x10                                  
    jal x1, label_jmp      # jump and link to label_jmp     
    addi x0, x0, 0         # original nop                   
    addi x2, x2, 1         # filler to avoid jump looping  

label_jmp:
    c.jr x1                # return                         

# -------------------------
# Branches: C.BEQZ, C.BNEZ
# -------------------------
    c.li x15, 0                                                
    c.bnez x15, skip1      # not taken                          
    c.li x15, 1
    c.beqz x15, skip1      # not taken
    jal x0, skip2          # unconditional jump

skip1:
    lui x12, 0             # emulate li x12, 999
    addi x12, x12, 999

skip2:
    lui x13, 0
    addi x13, x13, 123     # x13 = 123

# Hang loop
hang:
    jal x0, hang