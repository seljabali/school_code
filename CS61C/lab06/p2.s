	.data
	# This shows you can use a .word and directly encode the value in hex
	# if you so choose
num1:	.word 0x3F800000
num2:	.float 1.0
result:	.word 0
string: .asciiz "\n"

	.text
main:
	la $t0, num1
	lwc1 $f2, 0($t0)
	lwc1 $f4, 4($t0)

	# Print out the values of the summands

	li $v0, 2
	mov.s $f12, $f2
	syscall

	li $v0, 4
	la $a0, string
	syscall

	li $v0, 2
	mov.s $f12, $f4
	syscall

	li $v0, 4
	la $a0, string
	syscall
	li $v0, 4
	la $a0, string
	syscall

	# Do the actual addition

	add.s $f12, $f2, $f4

	# Transfer the value from the floating point reg to the integer reg

	swc1 $f12, 8($t0)
	lw $s0, 8($t0)

	# At this point, $f12 holds the sum, and $s0 holds the sum which can
	# be read in hexadecimal

	li $v0, 2
	syscall
	li $v0, 4
	la $a0, string
	syscall

	jr $ra
