# imprime um endereco de memoria de 4 bytes
# $a0 = endereco

print_single_mem:
#ajusta a pilha
		addi $sp, $sp, -8
		sw   $ra, 0($sp)
		sw   $a0, 4($sp) 
		move $t2, $a0

		lw  $s1, 4($sp)
		
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