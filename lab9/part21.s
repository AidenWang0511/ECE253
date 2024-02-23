# The good version: Do the timer entirely in the interrupt handler, not relying on the main function to do stuff.
# The bad version is to make the interrupt set a flag for the main function to poll, which defeats the purpose of interrupts.
.data
	# Messages: Note the spaces needed to make sure they are not read together (Alternatively, stop at null char)
	msg_1: .asciz "Please take a deep breath                        "
	msg_2: .asciz "Please drink some water                          "
	msg_3: .asciz "Please give your eyes a break                    "
	# Timer Related
	timeNow: .word 0xFFFF0018 # current time
	cmp: .word 0xFFFF0020 # time for new interrupt
	# String counter
	COUNTER: .word 0

.global _start
.text
# Display Related
.eqv OUT_CTRL 0xffff0008
.eqv OUT 0xffff000C
_start: 
	la s1, timer_handler # set handler address
	csrrw zero, utvec, s1 
	csrrwi zero, uie, 16 # Enable timer interrupt
	csrrwi zero, ustatus, 1 # Enable user interrupt
	jal RESET_TIMER # Subroutine to reset the timer
	addi s0, zero, 0xC4 
	j USEFUL_LOOP # random loop
	
RESET_TIMER: # Increment the current time by 5000ms (allows for delayled display to still work, but now
# no longer stops on even multiples of 5000ms (good or bad? your choice!) )
	li t0, 5000 # 5s
	la t2, cmp # t2 = adddress of pointer to new interrupt time
	lw t2, 0(t2) # t2 = pointer to new interrupt time
	la t1, timeNow # t1 = address of pointer to timer value
	lw t1, 0(t1) # t1 = pointer to timer value
	lw t3, 4(t1) # t3 = upper 32 bits of timer
	lw t1, 0(t1) # t1 = value of timer
	add t0, t1, t0 # t0 = t1 + 5000ms for the next set time	
	sw t0, 0(t2) # Set time to trigger interrupt to be 5000 milliseconds plus whatever was there earlier
	sltu t0, t0, t1 # If new value less than old value, set t0 = 1
	add t3, t3, t0 # Increment upper 32 bits as necessary
	sw t3, 4(t2) # Store upper 32 bits
	jr ra
	
timer_handler: # Interrupt vector: Print message, reset timer
	# Push registers to the stack
	addi sp, sp, -32
	# s0, s1, a0, t0, t1, t2, t3, ra --> 8 registers in use in this routine
	sw s0, 28(sp)
	sw s1, 24(sp)
	sw a0, 20(sp)
	sw t0, 16(sp)
	sw t1, 12(sp)
	sw t2, 8(sp)
	sw t3, 4(sp)
	sw ra, 0(sp)
	
	la s0, COUNTER # s0 = address to counter 
	lw s1, 0(s0) # s1 = value of counter (0 -> 1 -> 2 -> 0 -> ... for string number)
	addi t0, zero, 0 # t0 is our temporary comparison number
	
	# Now, we set a0 to be the address of our desired string using this if statement
STR_1:
	bne s1, t0, STR_2 # if s1 != 0, then check for STR_2
	la a0, msg_1
	j FINALLY
STR_2:
	addi t0, zero, 1 # Now check if s1 == 1
	bne s1, t0, STR_3
	la a0, msg_2
	j FINALLY
STR_3:
	# Assume s1 == 2 here
	addi s1, zero, -1 # Allows for easy increment, since if s1 == 2, then the stored value should now be 0
	la a0, msg_3
FINALLY:
	jal DISP_MSG # print subroutine
	# Increment s1 and store that value back into memory
	addi s1, s1, 1
	sw s1, 0(s0)
	
	# Reset timer
	jal RESET_TIMER
	
	# Pop registers back
	lw s0, 28(sp)
	lw s1, 24(sp)
	lw a0, 20(sp)
	lw t0, 16(sp)
	lw t1, 12(sp)
	lw t2, 8(sp)
	lw t3, 4(sp)
	lw ra, 0(sp)
	addi sp, sp, 32
	uret

DISP_MSG: # prints 32 characters starting from location a0
# Note the use of calling convention in the nested subroutine calls
	# permanently store ra in the stack for this subroutine
	addi sp, sp, -4
	sw ra, 0(sp)
	addi t0, zero, 32 # t0 = loop counter
	mv t1, a0 # t1 = address of current word
DISP_LOOP:
	# Note: We could have written WAIT_DISPLAY using t5 and t6 to not need to push registers to the stack
	# But, since we follow convention, WAIT_DISPLAY has access to all the a and t registers. It's the job
	# of the caller to save any a and t registers it cares about (here, we need loop counter t0 and
	# string address t1 after the subroutine call, so they're saved here)
	addi sp, sp, -8 # only need to save t0 and t1, not t2 nor t3
	sw t0, 4(sp)
	sw t1, 0(sp)
	jal WAIT_DISPLAY # Wait for display to be ready
	lw t1, 0(sp)
	lw t0, 4(sp)
	addi sp, sp, 8
	
	lbu t2, 0(t1) # t2 = character to display (ASCII characters are singular bytes
	li t3, OUT 
	sw t2, 0(t3) # display character
	addi t1, t1, 1 # move to next byte
	addi t0, t0, -1 # decrement counter
	bnez t0, DISP_LOOP # if t0 != 0, then continue loop
DISP_LOOP_DONE:
	jal WAIT_DISPLAY # display newline character (Note no need to save t3 or t2 here)
	li t3, OUT
	li t2, 10
	sw t2, 0(t3)
	lw ra, 0(sp) # pop return address back from stack
	addi sp, sp, 4 
	jr ra

WAIT_DISPLAY: # Wait for 0(OUT_CTRL) to be 1 to signal that the display is ready to display
	li t1, OUT_CTRL
	lw t2, 0(t1)
	beqz t2, WAIT_DISPLAY
	jr ra

USEFUL_LOOP:
	j USEFUL_LOOP

THERE_IS_NO_END:
	ebreak
