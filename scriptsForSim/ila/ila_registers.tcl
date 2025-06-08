# Sets the settings for the registers ilas make sure to have the same name as below when adding the ips

# ila namn and number of ports
set ilaName ila_registers

create_ip -name ila -vendor xilinx.com -library ip -version 6.2 -module_name ${ilaName}

set nbrPort 64
#set_property -dict [list CONFIG.C_PROBE0_WIDTH {32} CONFIG.C_PROBE0_TYPE {DATA}] [get_ips ${ilaName}]

# Creates all port
set_property -dict [list CONFIG.C_NUM_OF_PROBES {32}] [get_ips ${ilaName}]
for {set i 0} {$i < 32} {incr i} {
    set_property -dict [list CONFIG.C_PROBE${i}_WIDTH {32} CONFIG.C_PROBE${i}_TYPE {DATA}] [get_ips ${ilaName}]
}