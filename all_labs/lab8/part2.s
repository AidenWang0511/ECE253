.global _start
.text

_start:
    la s1, LIST
    lw s2, 0(s1)
    
LOOPi:
    addi s2, s2, -1
    addi s3, s2, 0
    beq s2, zero, END
    addi s4, s1, 4
    LOOPj: # s3 is the how many things to do (9, 8 , 7, 6...) (a0 = address to start from)
    	addi a0, s4, 0
    	jal SWAP
    	addi s4, s4, 4
    	addi s3, s3, -1
    	beqz s3, LOOPi
    	j LOOPj
    
SWAP: # Given address, swaps with next if greater than, returns 1 if so, takes in address in a0 and returns in a0... a0 = address
    lw a1, 0(a0)
    lw a2, 4(a0)
    bgt a1, a2, THEN
    ELSE:
    	li a0, 0
    	j AFTER	
    THEN:
	sw a2, 0(a0)
	sw a1, 4(a0)
	li a0, 1
    AFTER:
    jr ra

END: 
    ebreak

.global LIST
.data

LIST:
.word 4, 4, 3, 2, 1# 10 numbers to be started