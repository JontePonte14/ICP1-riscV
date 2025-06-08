#!/bin/sh
cd /home/jonathan/Documents/AssembleRisc/AssembleRisc/src
for k in $(seq 1 5);
do
    python3 main.py -i /home/jonathan/Documents/Vivado_files/IC_project/riscv/Test-instructions/love_tests/grade3/test${k}.s
    echo Test $k done!
    cp ../output/out_binary.txt /home/jonathan/Documents/Vivado_files/IC_project/riscv/Test-instructions/love_tests/grade3/out_binary_test${k}.txt
done
echo Grade 3 compiled!

for j in $(seq 6 8);
do
    python3 main.py -i /home/jonathan/Documents/Vivado_files/IC_project/riscv/Test-instructions/love_tests/grade4/test${j}.s
    echo test $j done!
    cp ../output/out_binary.txt /home/jonathan/Documents/Vivado_files/IC_project/riscv/Test-instructions/love_tests/grade4/out_binary_test${j}.txt
done
echo Grade 4 compiled!


python3 main.py -i /home/jonathan/Documents/Vivado_files/IC_project/riscv/Test-instructions/love_tests/grade4/test7_fix.s
echo test fix 7 done!
cp ../output/out_binary.txt /home/jonathan/Documents/Vivado_files/IC_project/riscv/Test-instructions/love_tests/grade4/out_binary_fix7.txt

cd /home/jonathan/Documents/Vivado_files/IC_project/riscv/scriptsForSim

