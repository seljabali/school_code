#Verify that lui clears the lower bits of the reegister.
	
main:
	addu	$v0 $0 255
	lui	$v0 0x8000
	sll	$31 $31 31
	jr	$ra
