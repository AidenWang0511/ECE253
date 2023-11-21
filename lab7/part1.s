.global _start
.text
_start:
la s2, LIST
addi s10, zero, 0
addi s11, zero, 0
# Write your code here
LOOP:
	lw t1, 0(s2)
	blt t1, zero, END
	add s10, s10, t1
	addi s11, s11, 1
	addi s2, s2, 4
	j LOOP
END:
ebreak
.global LIST
.data
LIST:
.word 1, 2, 3, 5, 0xA, -1