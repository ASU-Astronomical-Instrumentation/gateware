#! /bin/bash
ghdl -a growing_avg.vhd
ghdl -a avg_tb.vhd
ghdl -e avg_tb
ghdl -r avg_tb --vcd=test1.vcd
