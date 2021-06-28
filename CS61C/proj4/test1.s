# Basic test for updating memory on a store.
	
main:
	addiu	$t0 $0 256
	sw	$t0 0($sp)
	sll	$31 $31 31
	jr	$ra
