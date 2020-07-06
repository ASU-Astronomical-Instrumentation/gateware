#!/bin/bash
echo "Compiling $1"
ghdl -a $1
f=$1
fs=${f:0:(-5)}
echo "filename string: $fs"
ghdl -e $fs
