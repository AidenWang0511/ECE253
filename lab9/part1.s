### Read characters from keyoboard into ASCII Display...
 ## Code in lowest 8-bits of memory 0xffff0004, ready when ready, 0 when registered
 
# Program that counts consecutive 1’s.
.global _start
.text

_start:
li s0, 0xffff0004 # KEYCODE Lowest 8-bits
li s1, 0xffff0000 # KEYREADY Least Significant bit
li s2, 0xffff000c # DISPLAYCODE Lowest 8-bits
li s3, 0xffff0008 # DISPLAYREADY Least Significant bit
POLL_KEY: 
	lw s4, 0(s1)
	beqz s4, POLL_KEY
	lw s5, 0(s0)
WAIT:
	lw s4, 0(s1)
	bnez s4, WAIT
POLL_DISP:
	lw s6, 0(s3)
	beqz s6, POLL_DISP
STORE_WORD:
	sw s5, 0(s2)
	j POLL_KEY

ebreak


