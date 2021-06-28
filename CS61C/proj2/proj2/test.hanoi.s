#
# test.hanoi.s - testing code for Tower of Hanoi implementation in MIPS
#

        .data

__result:
        .space 4096

__chrs:
	.byte 'A', 'B', 'C'
        
        .text

main:
	addi  $sp, $sp, -4
	sw    $ra, 0($sp)
	la    $a0, __result	# result buffer
	la    $t0, __chrs
	lbu   $a1, 0($t0)    # peg1 = 'A'
	lbu   $a2, 1($t0)	# peg2 = 'B'
	lbu   $a3, 2($t0)	# peg3 = 'C'
        
	addi  $sp, $sp, -4
	addi  $t0, $0, 5
	sw    $t0, 0($sp)	# discs = 3
        
	jal   hanoi          # call hanoi()
	addi  $sp, $sp, 4
	la    $a0, __result
	jal   puts     	# display result
	lw    $ra, 0($sp)
	addi  $sp, $sp, 4
	jr    $ra
