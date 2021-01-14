
# FPGA Gateware Repo
This repo contains gateware/firmware that was developed for FPGA readout at ASU. VHDL is predominantly used for the synthesizable RTL and testbenches (using GHDL).


---
---

# In progress... 🚧👷🚧

__TODO__ *before* hardware testing and merging branch to dev

## FPGA_GigabitTx VHDL
* test bench for data_buffer.vhd in vhdl
* ~~look at byte_data.vhd really hard~~
  * we are going to have to think about how we want to  
    handle framing and data transfers with large data sets.  
    Not necessary for initial tests and POC
* instantiate data_buffer.vhd in byte_data.vhd
* update data/control signals with spectrum data in byte_data.vhd
* look at byte_data.vhd really hard a little more

## Data Pipeline HDL
* ~~test bench for pre_data_buffer.vhd in vhdl~~ (kinda)
* test bench for n_bin_avg_wrapper.sv
* ~~look where to smush IQ~~ and make it so
  * data concat, pack order by bins? |I0Q0|I1Q1|I2Q2|...|INQN| 