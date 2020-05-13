# $a0 = indice do registrador a ser impresso



print_register:
		addi $sp, $sp, -8
		sw   $ra, 0($sp)
		sw   $a0, 4($sp) 
		move $t2, $a0

		la  $t0, registers
		sll $t1, $t2, 2
		add $s1, $t0, $t1
		
		lb  $a0, 3($s1)
		jal print_byte
		
		lb  $a0, 2($s1)
		jal print_byte
		lb  $a0, 1($s1)
		jal print_byte
		lb  $a0, 0($s1)
		jal print_byte
		
		li $t0, 0x0a
		li $t1, 0xffff000c
		sb $t0, 0($t1)
		
		lw $ra, 0($sp)
		lw $a0, 4($sp)
		addi $sp, $sp, 8
		jr $ra
