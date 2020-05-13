###############################################################
# int ItoA(int, char*)
# arguments:
#    $a0 - integer to convert
#    $a1 - character buffer to write to
# return:  number of characters in converted string
#
ItoA:
  bnez $a0, ItoA.non_zero  # first, handle the special case of a value of zero
  nop
  li   $t0, '0'
  sb   $t0, 0($a1)
  sb   $zero, 1($a1)
  li   $v0, 1
  jr   $ra
ItoA.non_zero:
  addi $t0, $zero, 10     # now check for a negative value
  li $v0, 0
    
  bgtz $a0, ItoA.recurse
  nop
  li   $t1, '-'
  sb   $t1, 0($a1)
  addi $v0, $v0, 1
  neg  $a0, $a0
ItoA.recurse:
  addi $sp, $sp, -24
  sw   $fp, 8($sp)
  addi $fp, $sp, 8
  sw   $a0, 4($fp)
  sw   $a1, 8($fp)
  sw   $ra, -4($fp)
  sw   $s0, -8($fp)
  sw   $s1, -12($fp)
   
  div  $a0, $t0       # $a0/10
  mflo $s0            # $s0 = quotient
  mfhi $s1            # s1 = remainder  
  beqz $s0, ItoA.write
ItoA.continue:
  move $a0, $s0  
  jal ItoA.recurse
  nop
ItoA.write:
  add  $t1, $a1, $v0
  addi $v0, $v0, 1    
  addi $t2, $s1, 0x30 # convert to ASCII
  sb   $t2, 0($t1)    # store in the buffer
  sb   $zero, 1($t1)
  
ItoA.exit:
  lw   $a1, 8($fp)
  lw   $a0, 4($fp)
  lw   $ra, -4($fp)
  lw   $s0, -8($fp)
  lw   $s1, -12($fp)
  lw   $fp, 8($sp)    
  addi $sp, $sp, 24
  jr $ra
  nop