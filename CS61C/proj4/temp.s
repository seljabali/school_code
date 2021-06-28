main: 
strlen:
  addi  $v0, $0, 0
loop:
  add   $t0, $a0, $v0
  lbu   $t0, 0($t0)
  beq   $t1, $0, done
  addi  $v0, $v0, 1
  j     loop
done:
  jr    $ra

  
    addi $t0, $0, 4
  addiu $t0, $t0, -5
  addi $t1, $0, 4
  addi $t1, $t1, -5

  ori $t3, $0, 0x8001
#  sltiu $t3, $t3, 0x8000
  ori $t4, $0, 0x8001
#  sltiu $t4, $t4, 0x8000
  

  