# set the working dir, where all compiled verilog goes
vlib work

# compile all system verilog modules in mux.sv to working dir
# could also have multiple verilog files
vlog mux.sv

#load simulation using mux as the top level simulation module
vsim mux

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}

# first test case
#set input values using the force command, signal names need to be in {} brackets
force {SW[0]} 0
force {SW[1]} 0
force {SW[9]} 0
#run simulation for a few ns
run 10ns

# second test case, change input values and run for another 10ns
# SW[0] should control LED[0]
force {SW[0]} 0
force {SW[1]} 1
force {SW[9]} 0
run 10ns

# 3rd test case
force {SW[0]} 0
force {SW[1]} 0
force {SW[9]} 1
#run simulation for a few ns
run 10ns

# 4th test case
force {SW[0]} 0
force {SW[1]} 1
force {SW[9]} 1
run 10ns

# 5th test case
force {SW[0]} 1
force {SW[1]} 0
force {SW[9]} 0
#run simulation for a few ns
run 10ns

# 6th test case
force {SW[0]} 1
force {SW[1]} 0
force {SW[9]} 1
run 10ns

# 7th test case
force {SW[0]} 1
force {SW[1]} 1
force {SW[9]} 0
#run simulation for a few ns
run 10ns

# 8th test case
force {SW[0]} 1
force {SW[1]} 1
force {SW[9]} 1
run 10ns

