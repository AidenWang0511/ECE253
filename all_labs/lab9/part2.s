.data
msg_1: .asciz "Please take a deep breath "
msg_2: .asciz "Please drink some water "
msg_3: .asciz "Please give your eyes a break "

timeNow: .word 0xffff0018
cmp: .word 0xffff0020
flag: .word 0

.text
.eqv OUT_CTRL 0xffff0008
.eqv OUT 0xffff000C
main:
li s0, 5000
la s1, cmp
lw s1, 0(s1)
sw s0, 0(s1)
li s2, 0xffff000c # Initializing Display bit address
li s3, 0xffff0008 # Display Ready
la t5, timer_handler
csrrw zero, utvec, t5
csrrsi zero, uie, 0x10
csrrsi zero, ustatus, 0x1
MSG1:
	# load address of message 1 into whatever reg, 
	# If flag, jal PRINT, else j msg1
	la t0, flag
	lw t1, 0(t0)
	beqz t1, MSG1
	la s0, msg_1
	jal PRINT
	sw, zero, 0(t0)

MSG2:
	# load address of message 1 into whatever reg, 
	# If flag, jal PRINT, else j msg2
	la t0, flag
	lw t1, 0(t0)
	beqz t1, MSG2
	la s0, msg_2
	jal PRINT
	sw, zero, 0(t0)
MSG3:
	# load address of message 1 into whatever reg, 
	# If flag, jal PRINT, else j msg3
	# j MSG1    
	la t0, flag
	lw t1, 0(t0)
	beqz t1, MSG3
	la s0, msg_3
	jal PRINT
	sw, zero, 0(t0)
	j MSG1
PRINT:
	# loop through the msgs until the ascii value of 0
	# Poll to do this... and upload to the display register

	MSG_LOOP:
	lw s5, 0(s0) # Loading letter
	
	beqz s5, AFTER # END condition
	
	POLL:
	lw s4, 0(s3) # Polling ready bit
	beqz s4, POLL
	
	sw s5, 0(s2) # Storing to thing
	addi s0, s0, 1 # incrementing counter, check length of ascii
	
	j MSG_LOOP
	
	AFTER:
	jr ra

timer_handler: 
	addi sp, sp, -12
	sw t0, 0(sp)
	sw t1, 4(sp)
	sw t2, 8(sp)
	
	la t0, cmp
	lw t0, 0(t0)
	li t1, 5000
	lw t2, 0(t0)
	add t2, t1, t2
	sw t2, 0(t0)

	la t0, flag
	li t1, 1
	sw t1, 0(t0)
	
	lw t0, 0(sp)
	lw t1, 4(sp)
	lw t2, 8(sp)
	addi sp, sp, 12	
	uret





