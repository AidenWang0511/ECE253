# Program that counts consecutive 1�s.

.global _start
.text

_start:
    addi s10, zero, 0
    la s2, LIST # Load the memory address into s2
    addi s4, zero, 0
    
    LOOP1:
    	lw s3, 0(s2)
   	blt s3, zero, END
    	jal ONES
    	bgt a0, s10, ELSE
    	
    THEN:
        j AFTER
    ELSE:
        addi s10, a0, 0
    AFTER:
        addi s2, s2, 4
    	b LOOP1


ONES:
    addi sp, sp, -12
    sw s2, 8(sp)
    sw s3, 4(sp)
    sw s4, 0(sp)
LOOP:
    beqz s3, ONES_2 # Loop until data contains no more 1�s
    srli s2, s3, 1 # Perform SHIFT, followed by AND
    and s3, s3, s2
    addi s4, s4, 1 # Count the string lengths so far
    b LOOP
ONES_2:
    addi a0, s4, 0
    lw s4, 0(sp)
    lw s3, 4(sp)
    lw s2, 8(sp)
    addi sp, sp, 12
    jr ra

END: ebreak
.global LIST

.data

LIST:

.word 0x1fffffff, 0x12345678, -1, 0x7fffffff



#0x103fe00f, 0x12345678, 0x87654321, 0x89abcdef, 0xffffffff, 0x00000000,0x00000003,0x352901bb,0xbacd7378,0x9387feda