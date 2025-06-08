start_gui

#open_project $WORK_DIRECTORY/risc-v.xpr
open_project ../risc-v.xpr

# Set design source top to "top_module"
set_property top top_module [current_fileset]

# Set testbench top to "top_tb"
set_property top top_tb [get_filesets sim_1]
set_property top_lib xil_defaultlib [get_filesets sim_1]

# Launching sim
launch_simulation

#run 900 us
# Adding signals examples
add_wave {{/top_tb/top/cpu_unit/id_instruction}} {{/top_tb/top/cpu_unit/ex_instruction}} {{/top_tb/top/cpu_unit/mem_instruction}} {{/top_tb/top/cpu_unit/wb_instruction}} 
# PC counter
add_wave {{/top_tb/top/cpu_unit/inst_fetch_stage/pc_reg}} 
#word_valid
add_wave {{/top_tb/top/cpu_unit/inst_uart_decoder/word_valid}} 
#io_data_valid
add_wave {{/top_tb/top/uart_controller/io_data_valid}} 
#io_data_packet
add_wave {{/top_tb/top/io_data_packet}} 
# instrution ram
add_wave {{/top_tb/top/cpu_unit/inst_mem/ram}} 
# ram_valid
add_wave {{/top_tb/top/cpu_unit/inst_mem/ram_valid}} 
# ram_needs_clear
add_wave {{/top_tb/top/cpu_unit/inst_mem/ram_needs_clear}} 
# Registers
add_wave {{/top_tb/top/cpu_unit/inst_decode_stage/rf_inst/registers}} -radix unsigned
# memory 
add_wave {{/top_tb/top/cpu_unit/inst_mem_stage/inst_datamem_interface/inst_mem/ram}}  -radix unsigned




# RAM
#add_wave {{/testbench/cpu_inst/inst_mem_stage/inst_mem/ram}} -radix unsigned

relaunch_sim
run 1200 us