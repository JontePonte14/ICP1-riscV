#!/bin/bash

# This script shoukd be run in terminal in: "..."/RISCV_x/scriptsForSim/
echo "Hello! You are now starting Vivado and simulating instruction_mem_load_tb"

# -mode batch -source <your_Tcl_script>
#cd ../../TestForRiscV
vivado -mode tcl -source instruction_mem_load.tcl