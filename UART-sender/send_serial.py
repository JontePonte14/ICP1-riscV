import serial

def send_data(port, baudrate, lines):
    uart = serial.Serial(port, baudrate)
    for line in lines:
        # Each line should be assembled instructions. In this simple program, only 32bits are supported.
        # Convert to bytes, and send over the port
        packet = bytearray(int(line,2).to_bytes(len(line)//8,byteorder='little'))
        uart.write(packet)
        print(f'Sent packet: {packet}')
    uart.close()
    print('Done!')

def main():
    # Assembled program, i.e. in binary format
    #filepath = '/home/jonathan/Documents/Vivado_files/IC_project/riscv/Test-instructions/general-instruction/out_binary.txt'
    #filepath = '/home/jonathan/Documents/Vivado_files/IC_project/riscv/Test-instructions/sum-first-10-numbers/out_binary.txt'
    #filepath = '/home/jonathan/Documents/Vivado_files/IC_project/riscv/Test-instructions/branching-example-beq-bne/out_binary.txt'
   
    # ----------- LOVES TEST -------------
    # Grade 3
    #filepath = '/home/jonathan/Documents/Vivado_files/IC_project/riscv/Test-instructions/love_tests/grade3/out_binary_test1.txt'
    #filepath = '/home/jonathan/Documents/Vivado_files/IC_project/riscv/Test-instructions/love_tests/grade3/out_binary_test2.txt'
    #filepath = '/home/jonathan/Documents/Vivado_files/IC_project/riscv/Test-instructions/love_tests/grade3/out_binary_test3.txt'
    #filepath = '/home/jonathan/Documents/Vivado_files/IC_project/riscv/Test-instructions/love_tests/grade3/out_binary_test4.txt'
    #filepath = '/home/jonathan/Documents/Vivado_files/IC_project/riscv/Test-instructions/love_tests/grade3/out_binary_test5.txt'
    
    # Grade 4
    #filepath = '/home/jonathan/Documents/Vivado_files/IC_project/riscv/Test-instructions/love_tests/grade4/out_binary_test6.txt'
    #filepath = '/home/jonathan/Documents/Vivado_files/IC_project/riscv/Test-instructions/love_tests/grade4/out_binary_test_fix7.txt'
    #filepath = '/home/jonathan/Documents/Vivado_files/IC_project/riscv/Test-instructions/love_tests/grade4/out_binary_test_fix7_FOR_SIM.txt'
    filepath = '/home/jonathan/Documents/Vivado_files/IC_project/riscv/Test-instructions/love_tests/grade4/out_binary_test8.txt'
    # -------------------------------------

    # Eget test compressed-test-eget-2
    #filepath = '/home/jonathan/Documents/Vivado_files/IC_project/riscv/Test-instructions/compressed-test-eget-2_OK/out_binary.txt'
    
    # The port will depend on your OS:
    # Linux: depends on exact flavour, but probably something like /dev/ttyUSBX
    # Windows: COMX
    # On Linux (and maybe MacOS as well) you can use `dmesg` or `lsusb` to find the exact port
    # Denna port är på Jonathans dator (högra USB port)
    port = '/dev/ttyUSB1'
    # Make sure this is the same as on your UART controller
    baudrate = 19200
    with open(filepath, 'r') as f:
        text = f.readlines()
    send_data(port,baudrate,text)

if __name__ == '__main__':
    main()  