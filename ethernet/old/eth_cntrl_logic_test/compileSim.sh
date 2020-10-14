#!/bin/bash
echo "Compiling $1"
ghdl -a $1
f=$1
fs=${f:0:(-4)}
echo "filename string: $fs"
ghdl -e $fs
fstb=${fs}_tb.vhd
echo "Compiling testbench: $fstb"
ghdl -a $fstb
fstbs=${fstb:0:(-4)}
ghdl -e $fstbs
ghdl -r $fstbs --vcd=${fs}.vcd --stop-time=1000ns
echo "Done"
gtkwave ${fs}.vcd
