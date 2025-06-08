#!/bin/sh
cd /home/sofia/Projects/AssembleRisc/
source penv/bin/activate
cd /home/sofia/Projects/AssembleRisc/src

for k in $(seq 1 5);
do
    python main.py -i /home/sofia/Projects/riscv/Test-instructions/love_tests/grade3/test${k}.s
    cp ../output/out_binary.txt /home/sofia/Projects/riscv/Test-instructions/love_tests/grade3/out_binary_test${k}.txt
done

for j in $(seq 6 8);
do
    python main.py -i /home/sofia/Projects/riscv/Test-instructions/love_tests/grade4/test${j}.s
    cp ../output/out_binary.txt /home/sofia/Projects/riscv/Test-instructions/love_tests/grade4/out_binary_test${j}.txt
done

python main.py -i /home/sofia/Projects/riscv/Test-instructions/love_tests/grade4/test7_fix.s
cp ../output/out_binary.txt /home/sofia/Projects/riscv/Test-instructions/love_tests/grade4/out_binary_test_fix7.txt

cd /home/sofia/Projects/riscv/scriptsForSim
