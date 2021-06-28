#
# test.sprintf.s - testing code for sprintf implementation in MIPS
#


  	.data
__buffer:
	.space	200
__format0:
	.asciiz "%d%%\n"
__format1:
	.asciiz "F1: %d%% of all %ss like the %c letter\n"
__format2:
	.asciiz "F2: %d signed = %o octal\n"
__format3:
	.asciiz "F3: %o octal = %d = %f\n"
__format4:
	.asciiz "%f\n"
__str:
	.asciiz "American"
__chrs:
	.byte 'A', 'B'
__int:
	.word -28
__float:
        .float -0.75         # -1.1b 2^(-1)
      	.float 1.2e25        # 1.00111101101000110010101b 2^(83)
  	.float 1048576.125   # 1.00000000000000000000001b 2^(20)
        .float -0.75         # -1.1b 2^(-1)
	.float 1048576.0625  # 1.0b 2^(20)
	.float 1048576.5     # 1.000000000000000000001b 2^(20)
	.float 0.5078125     # 1.000001b 2^(-1)
	.float -0.03125      # -1.0b 2^(-5)
	.float +1.125        # 1.001b 2^(0)
	.float -1.25         # -1.01b 2^(0)
	.float -1.5          # -1.1b 2^(0)
	.float -1.0          # -1.0b 2^(0)
    	.word 0x7f800000     # inf
    	.word 0xfff00000     # -NaN
        .word 0x00000000     # -0
  	.word 0x80100000     # -denorm


	.text

main:
	# backup $ra
	addi $sp, $sp, -4
	sw   $ra, 0($sp)

       # b third
  
        # 1st sprintf call
	# build sprintf()'s parameters in the stack
	la   $a0, __buffer          # outbuf arg
	la   $a1, __format1         # format arg
	addi $a2, $0, 87            # %d
	la   $a3, __str             # %s
	la   $t0, __chrs          
	lbu  $t0, 1($t0)
        addi $sp, $sp, -4           # make space for spilled args          
	sw   $t0, 0($sp)            # 0($sp): __chrs[1] (%c)

    	# sprintf (char *str, const char *format, ...);
	jal  sprintf
        addi $sp, $sp, 4            # pop the spilled args

  	# print the new string
	la   $a0, __buffer
	jal  puts

    # 2nd sprintf call
	la   $a0, __buffer          # outbuf
	la   $a1, __format2         # format
	la   $t0, __int
	lw   $a2, 0($t0)            # %d   
	move $a3, $a2               # %o

  	# sprintf (char *str, const char *format, ...);
	jal  sprintf
  
	# print the new string
	la   $a0, __buffer
	jal  puts

third:	
    # 3rd sprintf call
	la   $a0, __buffer          # outbuf arg
	la   $a1, __format4         # format arg
	la   $t0, __float
	lw   $a2, 0($t0)            # %o
	move $a3, $a2               # %d
  
        addi $sp, $sp, -4           # make space for spilled args
        move $t0, $a2
  	sw   $t0, 0($sp)            # 0($sp): __float   (%f)

    	# sprintf (char *str, const char *format, ...);
	jal  sprintf
        addi $sp, $sp, 4            # pop the spilled args

  	addi $s0, $v0, 0            # must save $v0 because puts
                                    # will clobber $v0
    
  	# print the new string
	la   $a0, __buffer
        jal  puts
  
	# print the number of characters in the last string
	add  $a0, $s0, $0
	jal   __putint

	addi $a0, $0, 0xa
	jal  putc

	lw   $ra, 0($sp)
	jr   $ra


__putint: 
# displays an integer passed in via $a0
	# prolog
	addi $sp, $sp, -8
	sw   $ra, 0($sp)

	# body
	rem  $t0, $a0, 10
	addi $t0, $t0, '0'
	div  $a0, $a0, 10
	beqz $a0, __onedig

        # epilogue
	sw   $t0, 4($sp)
	jal   __putint
	lw   $t0, 4($sp)
  
__onedig:
# displays one digit passed via $t0
	add  $a0, $t0, 0
	jal  putc

	# epilog
	lw   $ra, 0($sp)
	addi $sp, $sp, 8
	jr   $ra
