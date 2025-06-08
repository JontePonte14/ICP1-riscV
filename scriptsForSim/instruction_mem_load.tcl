start_gui

#open_project $WORK_DIRECTORY/risc-v.xpr
open_project ../risc-v.xpr

# Set design source top to "program_memory"
set_property top program_memory [current_fileset]

# Set testbench top to "instruction_mem_load_tb"
set_property top instruction_mem_load_tb [get_filesets sim_1]
set_property top_lib xil_defaultlib [get_filesets sim_1]

# Launching sim
launch_simulation