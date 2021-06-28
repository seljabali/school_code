	.file	1 "lab4b.c"
	.section .mdebug.abi32
	.previous
	.abicalls
	.globl	source
	.data
	.align	2
	.type	source, @object
	.size	source, 28
source:
	.word	3
	.word	1
	.word	4
	.word	1
	.word	5
	.word	9
	.word	0
	.section	.rodata.str1.4,"aMS",@progbits,1
	.align	2
$LC0:
	.ascii	"%d values copied\n\000"
	.text
	.align	2
	.globl	main
	.ent	main
	.type	main, @function
main:
	.frame	$sp,32,$31		# vars= 0, regs= 1/0, args= 16, gp= 8
	.mask	0x80000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	.set	nomacro
	
	addiu	$sp,$sp,-32
	sw	$31,24($sp)
	.cprestore	16
	lw	$9,%got(source)($28)
	move	$8,$0
	lw	$2,0($9)
	nop
	beq	$2,$0,$L7
	nop

	lw	$11,%got(dest)($28)
	move	$7,$0
	move	$10,$9
$L5:
	addiu	$8,$8,1
	addu	$5,$7,$9
	addu	$6,$7,$11
	sll	$7,$8,2
	addu	$2,$7,$10
	lw	$3,0($5)
	lw	$4,0($2)
	sw	$3,0($6)
	bne	$4,$0,$L5
	nop

$L7:
	lw	$4,%got($LC0)($28)
	lw	$25,%call16(printf)($28)
	addiu	$4,$4,%lo($LC0)
	move	$5,$8
	jalr	$25
	nop

	lw	$28,16($sp)
	lw	$31,24($sp)
	move	$2,$0
	addiu	$sp,$sp,32
	j	$31
	nop

	.set	macro
	.set	reorder
	.end	main

	.comm	dest,40,4
	.ident	"GCC: (GNU) 3.4.4"
