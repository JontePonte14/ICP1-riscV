# ila namn and number of ports
set ilaName ila_btb
set nbrPort 32

# Creates ip
create_ip -name ila -vendor xilinx.com -library ip -version 6.2 -module_name ${ilaName}

# Creates all port
set_property -dict [list CONFIG.C_NUM_OF_PROBES {32}] [get_ips ${ilaName}]

# Sets the witdh and probe type
for {set i 0} {$i < 32} {incr i} {
    set_property -dict [list CONFIG.C_PROBE${i}_WIDTH {32} CONFIG.C_PROBE${i}_TYPE {DATA}] [get_ips ${ilaName}]
}