# Sets the settings for program memory ilas make sure to have the same name as below when adding the ips
#create_ip -name ila -vendor xilinx.com -library ip -version 6.2 -module_name ila_data_mem_0
# Allmän sätt kanske?

# ila namn and number of ports
set ilaName_0 ila_data_mem_0
set ilaName_1 ila_data_mem_1
set ilaName_2 ila_data_mem_2
set ilaName_3 ila_data_mem_3

# Creates ilas
create_ip -name ila -vendor xilinx.com -library ip -version 6.2 -module_name ${ilaName_0}
create_ip -name ila -vendor xilinx.com -library ip -version 6.2 -module_name ${ilaName_1}
create_ip -name ila -vendor xilinx.com -library ip -version 6.2 -module_name ${ilaName_2}
create_ip -name ila -vendor xilinx.com -library ip -version 6.2 -module_name ${ilaName_3}


# Creates all port
set_property -dict [list CONFIG.C_NUM_OF_PROBES {64}] [get_ips ${ilaName_0}]
set_property -dict [list CONFIG.C_NUM_OF_PROBES {64}] [get_ips ${ilaName_1}]
set_property -dict [list CONFIG.C_NUM_OF_PROBES {64}] [get_ips ${ilaName_2}]
set_property -dict [list CONFIG.C_NUM_OF_PROBES {64}] [get_ips ${ilaName_3}]


# Sets the witdh and probe type
for {set i 0} {$i < 64} {incr i} {
    set_property -dict [list CONFIG.C_PROBE${i}_WIDTH {32} CONFIG.C_PROBE${i}_TYPE {DATA}] [get_ips ${ilaName_0}]
}
for {set i 0} {$i < 64} {incr i} {
    set_property -dict [list CONFIG.C_PROBE${i}_WIDTH {32} CONFIG.C_PROBE${i}_TYPE {DATA}] [get_ips ${ilaName_1}]
}
for {set i 0} {$i < 64} {incr i} {
    set_property -dict [list CONFIG.C_PROBE${i}_WIDTH {32} CONFIG.C_PROBE${i}_TYPE {DATA}] [get_ips ${ilaName_2}]
}
for {set i 0} {$i < 64} {incr i} {
    set_property -dict [list CONFIG.C_PROBE${i}_WIDTH {32} CONFIG.C_PROBE${i}_TYPE {DATA}] [get_ips ${ilaName_3}]
}



# # ila namn and number of ports
# set ilaName_0 ila_program_mem_0

# set nbrPort 64
# #set_property -dict [list CONFIG.C_PROBE0_WIDTH {32} CONFIG.C_PROBE0_TYPE {DATA}] [get_ips ${ilaName}]

# # Creates all port
# set_property -dict [list CONFIG.C_NUM_OF_PROBES {64}] [get_ips ${ilaName}]
# for {set i 0} {$i < 64} {incr i} {
#     set_property -dict [list CONFIG.C_PROBE${i}_WIDTH {32} CONFIG.C_PROBE${i}_TYPE {DATA}] [get_ips ${ilaName_}]
# }