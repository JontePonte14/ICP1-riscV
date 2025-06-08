set ilaName_0 ila_data_mem
create_ip -name ila -vendor xilinx.com -library ip -version 6.2 -module_name ${ilaName_0}


set_property -dict [list CONFIG.C_NUM_OF_PROBES {8}] [get_ips ${ilaName_0}]

for {set i 0} {$i < 8} {incr i} {
    set_property -dict [list CONFIG.C_PROBE${i}_WIDTH {32} CONFIG.C_PROBE${i}_TYPE {DATA}] [get_ips ${ilaName_0}]
}
