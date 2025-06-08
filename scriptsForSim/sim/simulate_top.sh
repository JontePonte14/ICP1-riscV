#!/bin/bash

# This script shoukd be run in terminal in: "..."/RISCV_x/scriptsForSim/
echo "Hello! You are now starting Vivado and simulating top_tb"

# -mode batch -source <your_Tcl_script>
#cd ../../TestForRiscV
vivado -mode tcl -source top_tb.tcl