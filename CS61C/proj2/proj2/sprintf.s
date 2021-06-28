#
# sprintf.s - sprintf Implementation in MIPS
#
# CS61C, Project 2, Summer 2006
# Student Name: Sami Eljabali
# Student ID: by
# Section: 
# TA: Chris Portka
#
        .data
        .text		
sprintf:  # 
	#This function will partially emulate the C sprintf function. By printing type of variables like
	#integers, floats, characters, strings, and octals.
	#

	#Prologue    
	move	$s7, $sp		#let $s7 point to the 1st spilled arg
	add	$v0,$0,$0		#initialize return register
  	addi	$sp, $sp, -20	#Move the pointer 4 words down
          sw	$s0, 0($sp)	# Store $s0 onto the stack
          sw	$s1, 4($sp)	# Store $s1 onto the stack
          sw	$s2, 8($sp)	# Store $s2 onto the stack
          sw	$s3, 12($sp)	# Store $s3 onto the stack
	sw	$s7, 16($sp)	
	addi	$s2, $0, 0
	#Body
	#Here we read from the string we received from the caller and we
	#check for variables that need to be inserted into the string
	#and finally put into the return buffer
	add	$s0, $0, $0	# let $s0 be our agrcounter
Main_Loop:
	lb	$s1, 0($a1)	#Load character from string
	beq	$s1, $0, Exit	#if it is NULL then exit, we're done
	beq	$s1, '%', percent	# if char==% then go to percent label
	sb	$s1, 0($a0)	#  else store it onto the buffer
	addi	$a1, $a1, 1	#   point to the next char in string and
	addi	$a0, $a0, 1	#    next element in buffer
	addi	$v0, $v0, 1          #   add one to the num of charaters 
	j	Main_Loop		#    then loop
	#Here is where we check if we have vaild variable types that need to be inserted
	#If the user enters a % followed by an invalid type we simply print that letter
percent:
	addi	$a1, $a1, 1	#Point to the char next to %
	lb	$s1, 0($a1)	# If it is a
	beq	$s1, 'd', digit	#  integer call,
	beq	$s1, 'o', octal	#  octal call,
	beq	$s1, 'c', char	#  char call, 
	beq	$s1, 's', string	#  string call,
	beq	$s1, 'f', float	#  float call, or
	sb	$s1, 0($a0)	# Else,store the value after % only &
	addi	$a1, $a1, 1	# point to the next char in string
	addi	$a0, $a0, 1	# and the next element in the buffer
	addi	$v0, $v0, 1          #   add one to the num of charaters 
	j	Main_Loop
	

	#This is where we get an integer that the caller has sent us and
	#convert it to character type inorder to store it back into the buffer
digit:	
	addi	$s0, $s0, 1	#Add to the argcounter
	beq	$s0, 1,digi_A2	#if (argcounter==2) then jump A2
	beq	$s0, 2, digi_A3	#if (argcounter==3) then jump A3
	addi	$t3, $s0, -3	# else if (argcounter >2) then point
	addi	$t5, $0, 4
	mult	$t3, $t5		#  to the spilled argument
	add	$s7, $s7, $t3	#  ((argcounter-3)*4)$fp
	lw	$s1, 0($s7)	#  then load the word to s1 since its an integer
	j	digi_loaded

	digi_A2:	move	$s1, $a2	#Our argument is in $a2
		j	digi_loaded	
	digi_A3:	move	$s1, $a3	#Arguement is in $a3

	digi_loaded:	
		bgez	$s1, digi_conv	#If our integer > 0 then jump to conv
	
	          addi	$t2, $0, '-'	#Put - in buffer 
		sb	$t2, 0($a0)	# since integer is an neg num
		addi	$a0, $a0, 1	#Point to the next element 
		addi	$v0, $v0, 1	#Increase the # of characters in buffer
		negu	$s1, $s1		#Get the magnitude of the number
	digi_conv:
		remu	$t2, $s1, 10	#Store the remainder of num/10
	          addi	$t2, $t2, '0'	#Get its character representation
	          addi	$sp, $sp, -1	#Get the stack pointer ready for storing
	          addi	$s2, $s2, -1	# Store
	          sb	$t2, 0($sp)	#      it	
	          divu	$s1, $s1, 10	# divide it by 10 to get rid of converted digit
	          bne	$s1, $0, digi_conv	# if it isn't done then loop until it is

	 digi_integer_output:
	          beqz	$s2, digi_done	# if everything is converted then jump to digi_done
	          lb	$t2, 0($sp)	# else load from the stack the stored digit and
		sb	$t2, 0($a0)	# store it into the buffer
	          addi	$sp, $sp, 1	# increment the stack since we are done with our stored
	          addi	$s2, $s2, 1	# digit and increment num of characters
	          addi	$a0, $a0, 1	# in buffer and also point to the next character
	          addi	$v0, $v0, 1	# from the input string
	          j	digi_integer_output  # loop if not completed
		
	digi_done:	
		addi	$a1, $a1, 1	# point to the next char in string
		j	Main_Loop		#Loop
	
octal:	#Here we implement the octal the type by doing to exact same as we did with the
	# the digit implementation except that we divide by 8 rather than 10
	
	addi	$s0, $s0, 1	#Add to the argcounter
	beq	$s0, 1, oct_A2	#if (argcounter==2) then jump A2
	beq	$s0, 2, oct_A3	#if (argcounter==3) then jump A3
	addi	$t3, $s0, -3	# else if (argcounter >2) then point
	sll	$t3, $t3, 2	#  to the spilled argument
	add	$s7, $s7, $t3	#  ((argcounter-3)*4)$fp
	lw	$s1, 0($s7)	#  then load the byte to s1 since its an integer
	sub	$s7, $s7, $t3	# Make $s7 always point to the first spilled arg	
	j	oct_conv

	oct_A2:	move	$s1, $a2	#Our argument is in $a2
		j	oct_conv	
	oct_A3:	move	$s1, $a3	#Arguement is in $a3

	oct_conv:
		remu	$t2, $s1, 8	#Store the remainder of num/10
	          addi	$t2, $t2, '0'	#Get its character representation
	          addi	$sp, $sp, -1	
	          addi	$s2, $s2, -1
	          sb	$t2, 0($sp)
	          divu	$s1, $s1, 8
	          bne	$s1, $0, oct_conv

	 octal_output:
	          beqz	$s2, octal_done
	          lb	$t2, 0($sp)
		sb	$t2, 0($a0)
	          addi	$sp, $sp, 1
	          addi	$s2, $s2, 1  
	          addi	$a0, $a0, 1
	          addi	$v0, $v0, 1
	          j	octal_output
		
	octal_done:	
	addi	$a1,$a1,1		#Point to the next char in string
	#addi	$v0, $v0, 1          #   add one to the num of charaters 
	j	Main_Loop		#Loop	
	
char:	#Here we are implementing the char type
	#this type is simple for we immedaitely copy from the variable into the bufer
	addi	$s0, $s0, 1	#Add to the argcounter
	beq	$s0, 1, char_A2	#if (argcounter==2) then jump A2
	beq	$s0, 2, char_A3	#if (argcounter==3) then jump A3
	addi	$t3, $s0, -3	# else if (argcounter >2) then point
	sll	$t3, $t3, 2	#  to the spilled argument
	add	$s7, $s7, $t3	#  ((argcounter-3)*4)$fp
	lw	$s1, 0($s7)	#  then load the byte to s1 since its an character
	sub	$s7, $s7, $t3	# Make $s7 always point to the first spilled arg
	j	char_loaded

	char_A2:	move	$s1, $a2	#Our argument is in $a2
		j	char_loaded	
	char_A3:	move	$s1, $a3	#Arguement is in $a3

	char_loaded: sb	$s1,0($a0)

	addi	$a0,$a0,1
	addi	$a1,$a1,1		#Point to the next char in string
	addi	$v0, $v0, 1          #   add one to the num of charaters 
	j	Main_Loop		#Loop

string:	#This is the string function, here we go through the
	#list of character array given by the user and we store
	#character by character into the buffer
	addi	$s0, $s0, 1	#Add to the argcounter
	beq	$s0, 1, string_A2	#if (argcounter==2) then jump A2
	beq	$s0, 2, string_A3	#if (argcounter==3) then jump A3 else
	move	$s1, $s7		#s1 will have the address of the char array
	addi	$t3, $s0, -3	# else if (argcounter >2) then point
	sll	$t3, $t3, 2	#  to the spilled argument
	add	$s1, $s1, $t3	#  ((argcounter-3)*4)$fp
	j	string_loaded

	string_A2:	
		move	$s1,$a2	#Our argument is in $a2
		j	string_loaded	
	string_A3:	
		move	$s1,$a3	#Arguement is in $a3
	
	string_loaded:
	lb	$t4, 0($s1)	#Load the first character in character array	
	beqz	$t4, string_Done	#If null character reached, then we r done
	sb	$t4, 0($a0)	#Else store it in the buffer
	addi	$a0, $a0, 1	# point to the next element in buffer
	addi	$s1, $s1, 1	# also point to the next element in string
	addi	$v0, $v0, 1	# increment the num of characters	
	j	string_loaded
	
	string_Done:		
	addi	$a1,$a1,1		#Point to the next char in string
	j	Main_Loop		#Loop

float:	#This is the float section, here we have mulitple results
	#Exponent	Mantissa		#Object Represented  	#What you must write into the buffer
	#################################################################################################
	#0	0		zero			[-]0
	#0	nonzero		? denormalized number  	[-]denorm
	#1-254	anything  	? normalized number*	[-]mantissa_in_binary_2 x 2^([-]exponent_in_decimal)
	#255	0		? infinity		[-]inf
	#255	nonzero		NaN (Not a Number)  	[-]NaN
	#################################################################################################
	
	addi	$s0, $s0, 1	#Add to the argcounter
	beq	$s0, 1, float_A2	#if (argcounter==2) then jump A2
	beq	$s0, 2, float_A3	#if (argcounter==3) then jump A3 else
	move	$s1, $s7		#s1 will have the address of the char array
	addi	$t3, $s0, -3	# else if (argcounter >2) then point
	sll	$t3, $t3, 2	#  to the spilled argument
	add	$s1, $s1, $t3	#  ((argcounter-3)*4)$fp
	
	float_A2:	
		move	$s1, $a2	#Our argument is in $a2
		j	float_loaded	
	float_A3:	
		move	$s1, $a3	#Arguement is in $a3

	float_loaded:
		bgez	$s1, positive
		addi	$t2, $0, '-'	#Put - in buffer 
		sb	$t2, 0($a0)	# since integer is an neg num
		addi	$a0, $a0, 1	#Point to the next element 
		addi	$v0, $v0, 1	#Increase the # of characters in buffer
		sll	$s1, $s1, 1
		srl	$s1, $s1, 1	
	positive:
		beqz	$s1, zero
		srl	$t1, $s1, 23
		beq	$t1, 255, inf_or_nan
		beqz	$t1, denorm

	#Printing out the "1." in the buffer before the normalized number
	norm:	addi	$t2, $0, '1'	#Put - in buffer 
		sb	$t2, 0($a0)	# since integer is an neg num
		addi	$a0, $a0, 1	#Point to the next element
		addi	$t2, $0, '.'	#Put - in buffer 
		sb	$t2, 0($a0)	# since integer is an neg num
		addi	$a0, $a0, 1	#Point to the next element
		addi	$v0, $v0, 2	#Increase the # of characters in buffer
		sll	$t1, $s1, 9	#If mantissa is zero then 
		beqz	$t1, sig_zero	# print a single 0 after the "1."

	dear_mama:beqz	$t1, exp_time
		srl	$t3, $t1, 31
	
		addi	$t3, $t3, '0'
		sb	$t3, 0($a0)	# since integer is an neg num
		addi	$a0, $a0, 1	#Point to the next element
		addi	$v0, $v0, 1	#Increase the # of characters in buffer
	
		sll	$t1, $t1, 1
		move	$t3, $t1
		j	dear_mama
	exp_time:
		addi	$t2, $0, '_'	#Put - in buffer 
		sb	$t2, 0($a0)	# since integer is an neg num
		addi	$a0, $a0, 1	#Point to the next element
		addi	$t2, $0, '2'	#Put - in buffer 
		sb	$t2, 0($a0)	# since integer is an neg num
		addi	$a0, $a0, 1	#Point to the next element
		addi	$t2, $0, ' '	#Put - in buffer 
		sb	$t2, 0($a0)	# since integer is an neg num
		addi	$a0, $a0, 1	#Point to the next element

		addi	$t2, $0, 'x'	#Put - in buffer 
		sb	$t2, 0($a0)	# since integer is an neg num
		addi	$a0, $a0, 1	#Point to the next element	
		addi	$t2, $0, ' '	#Put - in buffer 
		sb	$t2, 0($a0)	# since integer is an neg num
		addi	$a0, $a0, 1	#Point to the next element

		addi	$t2, $0, '2'	#Put - in buffer 
		sb	$t2, 0($a0)	# since integer is an neg num
		addi	$a0, $a0, 1	#Point to the next element
		addi	$t2, $0, '^'	#Put - in buffer 
		sb	$t2, 0($a0)	# since integer is an neg num
		addi	$a0, $a0, 1	#Point to the next element
		addi	$t2, $0, '('	#Put - in buffer 
		sb	$t2, 0($a0)	# since integer is an neg num
		addi	$a0, $a0, 1
		addi	$v0, $v0, 6	#Increase the # of characters in buffer
	
		srl	$t7, $s1, 23
		addi	$t7, $t7, -127
		bgez	$t7, exp_conv
		
		addi	$t2, $0, '-'	#Put - in buffer 
		sb	$t2, 0($a0)	# since integer is an neg num
		addi	$a0, $a0, 1	#Point to the next element 
		addi	$v0, $v0, 1	#Increase the # of characters in buffer
		negu	$t7, $t7		#Get the magnitude of the number

	exp_conv:
		remu	$t2, $t7, 10	#Store the remainder of num/10
	          addiu	$t2, $t2, '0'	#Get its character representation
	          addi	$sp, $sp, -1	
	          addi	$s2, $s2, -1
	          sb	$t2, 0($sp)
	          divu	$t7, $t7, 10
	          bne	$t7, $0, exp_conv

	 exp_integer_output:
	          beqz	$s2, last_bracket	
	          lbu	$t2, 0($sp)
		sb	$t2, 0($a0)
	          addi	$sp, $sp, 1
	          addi	$s2, $s2, 1  
	          addi	$a0, $a0, 1
	          addi	$v0, $v0, 1
	          j	exp_integer_output
	last_bracket:
		addi	$t2, $0, ')'	#Put - in buffer 
		sb	$t2, 0($a0)	# since integer is an neg num
		j	string_done
	
	sig_zero:	addi	$t2, $0, '0'	#Put - in buffer 
		sb	$t2, 0($a0)	# since integer is an neg num
		addi	$a0, $a0, 1	#Point to the next element
		addi	$v0, $v0, 1	#Increase the # of characters in buffer
		j	exp_time
	
	denorm:	sll	$t1, $s1, 9
		beqz	$t1, norm
		addi	$t2, $0, 'd'	#Put - in buffer 
		sb	$t2, 0($a0)	# since integer is an neg num
		addi	$a0, $a0, 1	#Point to the next element
		addi	$t2, $0, 'e'	#Put - in buffer 
		sb	$t2, 0($a0)	# since integer is an neg num
		addi	$a0, $a0, 1	#Point to the next element
		addi	$t2, $0, 'n'	#Put - in buffer 
		sb	$t2, 0($a0)	# since integer is an neg num
		addi	$a0, $a0, 1	#Point to the next element
		addi	$t2, $0, 'o'	#Put - in buffer 
		sb	$t2, 0($a0)	# since integer is an neg num
		addi	$a0, $a0, 1	#Point to the next element
		addi	$t2, $0, 'r'	#Put - in buffer 
		sb	$t2, 0($a0)	# since integer is an neg num
		addi	$a0, $a0, 1	#Point to the next element
		addi	$t2, $0, 'm'	#Put - in buffer 
		sb	$t2, 0($a0)	# since integer is an neg num
		addi	$v0, $v0, 6	#Increase the # of characters in buffer
		j	string_done			
	inf_or_nan:	
		sll	$t1, $s1, 9	
		beqz	$t1, inf
		addi	$t2, $0, 'N'	#Put - in buffer 
		sb	$t2, 0($a0)	# since integer is an neg num
		addi	$a0, $a0, 1	#Point to the next element
		addi	$t2, $0, 'a'	#Put - in buffer 
		sb	$t2, 0($a0)	# since integer is an neg num
		addi	$a0, $a0, 1	#Point to the next element
		addi	$t2, $0, 'N'	#Put - in buffer 
		sb	$t2, 0($a0)	# since integer is an neg num
		addi	$v0, $v0, 3	#Increase the # of characters in buffer
		j	string_done
	inf:
		addi	$t2, $0, 'i'	#Put - in buffer 
		sb	$t2, 0($a0)	# since integer is an neg num
		addi	$a0, $a0, 1	#Point to the next element
		addi	$t2, $0, 'n'	#Put - in buffer 
		sb	$t2, 0($a0)	# since integer is an neg num
		addi	$a0, $a0, 1	#Point to the next element
		addi	$t2, $0, 'f'	#Put - in buffer 
		sb	$t2, 0($a0)	# since integer is an neg num	
		addi	$v0, $v0, 3	#Increase the # of characters in buffer
		j	string_done
	
	#This is when the float number is +/- 0
	zero:	addi	$t7, $0, '0'
		sb	$t7, 0($a0)	
		addi	$v0, $v0, 1	#Increase the # of characters in buffer
	
	string_done:		
		addi	$a1, $a1, 1	#Point to the next char in string
		addi	$a0, $a0, 1	#Point to the next element in the buffer
		j	Main_Loop		#Loop
		
	#Epilogue
Exit:	#This is the end of the function, here were load all of the values in stack
	#and we also put a NULL character at the end of the buffer
	addi	$t3, $t3, 0	#Store NULL into
	sb	$t3, 0($a0)	# the buffer
	lw	$s7, 16($sp)	#Load the saved
          lw	$s3, 12($sp)	# variab
          lw	$s2, 8($sp)	#       l	
          lw	$s1, 4($sp)	#        e
          lw	$s0, 0($sp)	#         s	
          addi	$sp, $sp, 20	#Restore stack pointer to original location
	jr	$ra		#Retrun to caller
