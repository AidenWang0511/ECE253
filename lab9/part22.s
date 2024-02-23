.data
# Messages
	msg_1: .asciz "Please take a deep breath      "
	msg_2: .asciz "Please drink some water        "
	msg_3: .asciz "Please give your eyes a break  "
# Timer Related
	timeNow: .word 0xFFFF0018 # current time
	cmp: .word 0xFFFF0020 # time for new interrupt
.text
# Display Related
	.eqv OUT_CTRL 0xffff0008
	.eqv OUT 0xffff000C
main:
# Set time to trigger interrupt to be 5000 milliseconds (5 seconds)
# Set the handler address and enable interrupts
# Loop over the messages
# Print message to ASCII display
	la t0, timer_handler
	csrrw x0, utvec, t0
	csrrwi x0, uie, 16
	csrrwi x0, ustatus, 1
	addi s0, s0, 2
	lw t0, timeNow # stores the current time, write time + 5000 to the cmp
	lw s1, 0(t0)
	li s2, 5000
	add s2, s2, s1
	lw t1, cmp
	sw s2, 0(t1)
	
	# infinite loop (funny)
	j LOOP

LOOP:
	beqz x0, LOOP
	

.DISPLAY:
	beqz a0, .END_DISPLAY
	# check the ready bit
	lw t0, OUT_CTRL
	beqz t0, .DISPLAY # keep looping if not ready to display
	lb t0, 0(a1)
	sb t0, OUT, t1
	addi a1, a1, 1 # increment to next byte from address
	addi a0, a0, -1 # decrement
	j .DISPLAY

.END_DISPLAY:
	lw t0, OUT_CTRL
	beqz t0, .END_DISPLAY
	addi t0, x0, 10
	sb t0, OUT, t1
	jr ra

.CHOOSE_MSG:
	beqz a0, .MSG1
	addi a0, a0, -1
	beqz a0, .MSG2
	addi a0, a0, -1
	beqz a0, .MSG3

.MSG1:
	la a1, msg_1
	jr ra

.MSG2:
	la a1, msg_2
	jr ra

.MSG3:
	la a1, msg_3
	jr ra

.FIXI:
	li s0, 3
	j timer_handler

timer_handler:
# Push registers to the stack
# Indicate that 5 seconds have passed
# Pop registers from the stack
	beqz s0, .FIXI
	addi s0, s0, -1
	mv a0, s0
	jal .CHOOSE_MSG
	
	li a0, 32
	# a1 will have the address of the message needed
	jal .DISPLAY
	# reset the timer
	
	# reset timer
	lw t0, timeNow # stores the current time, write time + 5000 to the cmp
	lw s1, 0(t0)
	li s2, 5000
	add s2, s2, s1
	lw t1, cmp
	sw s2, 0(t1)
	
	uret

