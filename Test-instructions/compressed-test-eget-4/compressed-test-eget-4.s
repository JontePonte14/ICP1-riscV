_start:
    c.li x12, 12         # x12 = address of func (PC = 12)
    c.jalr x12           # jump to func, return address saved in x1

    c.li x8, 123         # executed after return from func

hang:
    jal x0, hang         # uncompressed infinite loop (standard hang)

func:
    c.li x9, 99          # dummy work in function
    c.jalr x1            # return to caller


# Orkar fan inte skriva fler testprogram - blev nu ett generat av chatgpt
# Detta program testar
# jal kunde inte heller kompileras så den finns ej med
# li
# jalr
