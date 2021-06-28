# hanoi.s - Tower of Hanoi Implementation in MIPS
#
# CS61C, Project 2, Summer 2006
# Student Name: Sami Eljabali
# Student ID: by
# Section: 
# TA: The lovely Chris Portka
#
        .data
format:
	.asciiz "(%c . %c)"	
	.text
#This is the main function which calls the recursive function. Here I store the received buffer into s0 and I from now on store
#discs into a0 this helps ease recursive calls. 	     
hanoi:
	addi	$sp, $sp, -8	#Store s0
	sw	$ra, 0($sp)	# ra
	sw	$s0, 4($sp)	# and store
	addi	$v1, $a0, 0
		
	move	$s0, $a0		#Move buffer into $s0
	
	lw	$t0, 8($sp)	#Load discs
	move	$a0, $t0		# and move em to $a0
	
	jal	recursive_guy	# a function
	
	lw	$ra, 0($sp)	#Load the register after the
	lw	$s0, 4($sp)
	addi	$sp, $sp, 8	# call to the function
	jr	$ra		#Finished..

#This where all of the recursive calls happen.
recursive_guy:		
	addi	$sp, $sp, -20
	sw	$ra, 0($sp)	#load discs
	sw	$a0, 4($sp)	#discs
	sw	$a1, 8($sp)	#peg1
	sw	$a2, 12($sp)	#peg2
	sw	$a3, 16($sp)	#peg3

	#if disc==1 then jump
	beq	$a0, 1, disc_eq1	

	#hanoi(peg1, peg3, peg2, discs - 1);
	lw	$a1, 8($sp)	#Load the variables in the proper order
	lw	$a2, 16($sp)
	lw	$a3, 12($sp)
	lw	$a0, 4($sp)
	addi	$a0, $a0, -1	#load Discs-1
	jal	recursive_guy	#call hanoi again

	# hanoi(peg1, peg2, peg3, 1);				 
	lw	$a1, 8($sp)	#Load the variables in the proper order
	lw	$a2, 12($sp)
	lw	$a3, 16($sp)
	addi	$a0, $0, 1	#Pass 1 as the disc value
	jal	recursive_guy

	#hanoi(peg2, peg1, peg3, discs - 1);
	lw	$a1, 12($sp)	#Load the variables in the proper order	
	lw	$a2, 8($sp)
	lw	$a3, 16($sp)
	lw	$a0, 4($sp)
	addi	$a0, $a0, -1	#load Discs-1
	jal	recursive_guy	
	
	j	done		#Once you call the function three times then u are done
	
disc_eq1:	#sprintf("(%c . %c)", peg1, peg3);
	move	$t1, $a1		#Save peg1
	move	$t2, $a3		#Save peg3
	add	$a0, $0, $v1	#Store buffer
	la	$a1, format	#Load the string format
	move	$a2, $t1		#Load peg1
	move	$a3, $t2		#Load peg3
	addi	$sp, $sp, -4	#Make space for 
	sw	$v1, 0($sp)	# storing v1 since we are making a call
	jal	sprintf		#Call sprintf
	lw	$v1, 0($sp)	#Load v1
	addi	$sp, $sp, 4	#Restore register
	addi	$v1, $v1, 7	#Add 7 to the buffer coz of format
	
done:	
	lw	$ra, 0($sp)	#Load stored variables
	lw	$a0, 4($sp)
	lw	$a1, 8($sp)
	lw	$a2, 12($sp)
	lw	$a3, 16($sp)
	addi	$sp, $sp, 20	#Restore sp
	jr	$ra		#Return


	
