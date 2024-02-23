.data
# Messages
msg_1: .asciz "Please take a deep breath "
msg_2: .asciz "Please drink some water "
msg_3: .asciz "Please give your eyes a break "


# Timer Related
timeNow: .word 0xFFFF0018 # current time
cmp: .word 0xFFFF0020 # time for new interrupt  # should be 1387
counter: .word 0

.text
# Display Related
.eqv OUT_CTRL 0xffff0008
.eqv OUT 0xffff000C

main:
# Set time to trigger interrupt to be 5000 milliseconds (5 seconds)
li s0, 5
la s1, cmp
lw s1, 0(s1)
sw s0, 0(s1)
li s2, 0xffff000c
# Set the handler address and enable interrupts
la t0, timer_handler
csrrw zero, utvec, t0 # Interrupt handler address
csrrsi zero, uie, 0x10  # # Enable Timer Interrupt
csrrsi zero, ustatus, 0x1 # Interrupt enable bit
LOOP: 
# Loop over the messages
la s3, msg_1
lw s3, 0(s3)
sw s3, 0(s2)
la s3, msg_2
lw s3, 0(s3)
sw s3, 0(s2)
la s3, msg_3
lw s3, 0(s3)
sw s3, 0(s2)
j LOOP

timer_handler: 
	addi sp, sp, -12
	sw t0, 0(sp)
	sw t1, 4(sp)
	sw t2, 8(sp)
	
	la t1, counter
	lw t2, 0(t1)
	addi t2, t2, 1 # Incrementing counter
	sw t2, 0(t1)
	# Set Interrupt time???
	
	
	
	# After
	lw t0, 0(sp)
	lw t1, 4(sp)
	lw t2, 8(sp)
	addi sp, sp, 12
	
	uret

# Indicate that 5 seconds have passed
# Pop registers from the stack






