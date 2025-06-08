start_gui

#open_project $WORK_DIRECTORY/risc-v.xpr
open_project ../risc-v.xpr

# Set design source top to "uart"
set_property top uart [current_fileset]

# Set testbench top to "uart_ctrl_tb"
set_property top uart_ctrl_tb [get_filesets sim_1]
set_property top_lib xil_defaultlib [get_filesets sim_1]

# Launching sim
launch_simulation

run 1200 us
# Adding signals examples
# RAM
#add_wave {{/testbench/cpu_inst/inst_mem_stage/inst_mem/ram}} -radix unsigned

#
#relaunch_sim