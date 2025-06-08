start_gui

#open_project $WORK_DIRECTORY/risc-v.xpr
open_project ../risc-v.xpr

# Set design source top to "top_module"
set_property top top_module [current_fileset]

# Set testbench top to "testbench"
set_property top testbench [get_filesets sim_1]
set_property top_lib xil_defaultlib [get_filesets sim_1]