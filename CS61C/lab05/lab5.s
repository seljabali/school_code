	.data
table:	
	# your table from part a of exercise 1 goes here
	.byte	1:1
	.byte	3:8
	.byte	0:2
	.byte	3:2
	.byte	0:1
	.byte	3:18
	.byte	0:1
	.byte	3:15
	.byte	2:10
	.byte	3:7
	.byte	2:26
	.byte	3:4
	.byte	2:1
	.byte	3:1
	.byte	2:26
	.byte	3:5
		

line:	.byte	0:80	# up to an 80-character input line
prompt:	.asciiz	"Please type a line with fewer than 80 characters."
not_found_msg:
	.asciiz	"Line was all whitespace."
alphnum_msg:
	.asciiz	"First nonwhitespace character is alphanumeric: "
other_msg:
	.asciiz	"First nonwhitespace character is not alphanumeric: "

	.text
main:
	move	$s0,$ra		# Store our return address

	la	$a0,prompt	# Print the prompt
	jal	puts
	li	$a0,0x0A	# And a newline
	jal	putc

	la	$a0,line	# read a line
	li	$a1,80
	jal	gets

	la	$s1,line
	la	$s2,table

# The scan code takes a pointer to a character in $s1
# and the address of a translation table in $s2.  It increments $s1
# to point to the first subsequent character whose table entry is nonzero,
# and stores the corresponding table value in $v0.

scan:
	
Loop:	lbu	$t0,0($s1)
	add	$t1,$t0,$s2   #Lookup
	lbu	$t0,0($t1)   #load corresponding element
	move	$v0,$t0
	bnez	$t0,scan_done
	addi	$s1,$s1,1     #Point to next element
	j	Loop


scan_done:
	li	$t0,1
	bne	$t0,$v0,nws_found

	la	$a0,not_found_msg # Print not found message
	jal	puts
	li	$a0,0x0A	  # And newline
	jal	putc

	jr	$s0		# Return from main


nws_found:			# scan hit a nonwhitespace character
	li	$t0,2
	bne	$t0,$v0,other_found

	la	$a0,alphnum_msg	# scan hit an alphanumeric character
	jal	puts
	lbu	$a0,0($s1)	# Mention which one
	jal	putc
	li	$a0,0x0A	# And newline
	jal	putc

	jr	$s0		# Return from main


other_found:			# scan hit a nonalphanumeric character
	la	$a0,other_msg	# Print message
	jal	puts
	lbu	$a0,0($s1)	# Mention which one
	jal	putc
	li	$a0,0x0A	# And newline
	jal	putc

	jr	$s0		# Return from main

