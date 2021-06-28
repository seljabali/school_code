#Stress test for saving to stack.

main:
	addiu	$t1 $0 3070
	addu	$t0 $0 $0
loop:	sw	$t0 0($sp)
	addiu	$sp $sp -4
	addiu	$t0 $t0 1
	bne	$t0 $t1 loop
	srl	$t1 $t1 2
	addu	$sp $sp $t1
	sll	$31 $31 31
	jr	$ra
