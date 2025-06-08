import serial

def send_data(lines):
    #uart = serial.Serial(port, baudrate)
    for line in lines:
        # Each line should be assembled instructions. In this simple program, only 32bits are supported.
        # Convert to bytes, and send over the port
        packet = bytearray(int(line,2).to_bytes(len(line)//8,byteorder='little'))
        #uart.write(packet)
        print(f'Sent packet: {packet}')
    #uart.close()
    print('Done!')

def main():
    # Assembled program, i.e. in binary format
    filepath = '/home/jonathan/Documents/Vivado_files/IC_project/riscv/Test-instructions/3Bytes.txt'
    # The port will depend on your OS:
    # Linux: depends on exact flavour, but probably something like /dev/ttyUSBX
    # Windows: COMX
    # On Linux (and maybe MacOS as well) you can use `dmesg` or `lsusb` to find the exact port
    # Denna port är på Jonathans dator (högra USB port)
    #port = '/dev/ttyUSB1'
    # Make sure this is the same as on your UART controller
    baudrate = 115200
    with open(filepath, 'r') as f:
        text = f.readlines()
    send_data(text)

if __name__ == '__main__':
    main()