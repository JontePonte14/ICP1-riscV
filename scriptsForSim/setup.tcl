start_gui

#open_project $WORK_DIRECTORY/risc-v.xpr
open_project ../risc-v.xpr

# Set design source top to "cpu"
set_property top cpu [current_fileset]

# Set testbench top to "testbench"
set_property top testbench [get_filesets sim_1]
set_property top_lib xil_defaultlib [get_filesets sim_1]

# Launching sim
launch_simulation

# Adding signals examples
# Instrucion going through the pipeline
add_wave {{/testbench/cpu_inst/id_instruction}} 
add_wave {{/testbench/cpu_inst/ex_instruction}}
add_wave {{/testbench/cpu_inst/mem_instruction}}
add_wave {{/testbench/cpu_inst/wb_instruction}}
# PC counter
add_wave {{/testbench/cpu_inst/inst_fetch_stage/pc_reg}} -radix unsigned
# Registers
add_wave {{/testbench/cpu_inst/inst_decode_stage/rf_inst/registers}} -radix unsigned
# RAM
add_wave {{/testbench/cpu_inst/inst_mem_stage/inst_mem/ram}} -radix unsigned


relaunch_sim