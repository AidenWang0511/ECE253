# set the working dir, where all compiled verilog goes
vlib work

# compile all system verilog modules in mux.sv to working dir
# could also have multiple verilog files
vlog part2.sv

#load simulation using mux as the top level simulation module
vsim part2

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}

add wave -position insertpoint  \
sim:/part2/u0/Enable \
sim:/part2/u0/N \
sim:/part2/u0/count

force {ClockIn} 0, 1 {1 ns} -r {2 ns}

force {Reset} 1
force {Speed} 00
run 10ns

force {Reset} 0
force {Speed} 01 
run 1000 ns

force {Speed} 10 
run 2000 ns

force {Speed} 11 
run 4000 ns
