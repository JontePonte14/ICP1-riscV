#!/bin/bash

echo "Are you sure you want to remove all .log, .jou, .str files and .Xil folder? (y/n)"
read answer

if [ "$answer" = "y" ]; then
    rm *.log *.jou *str
    rm -r .Xil
    echo "The files has been removed."
else 
    echo "Command cancelled."
fi
