# Mapa da pilha:
# 0($sp) = $ra

execute_d:
# inicializa a pilha		
		addi $sp, $sp, -8
		sw   $ra, 0($sp)
		li	 $t0, 1
		sw   $t0, 4($sp)	# i = 1 (iterador do laco inicia em 1)
# for(i=1;i<32;i++)
print_register_loop:
		la	 $a0, msg_print_register1
		jal  print_string
		lw 	 $a0, 4($sp)	# $t0 <- i
		la	 $a1, word		
		jal	 ItoA
		la	 $a0, word
		jal	 print_string
		la	 $a0, space
		jal  print_string
		lw	 $a0, 4($sp)	# $a0 <- i
		jal	 print_register	# imprime registrador de indice i
		lw 	 $t0, 4($sp)	# $t0 <- i
		addi $t0, $t0, 1	# i++
		sw	 $t0, 4($sp)	# armazena novo valor de i na pilha
		slti $t1, $t0, 32	# $t1 = (i < 32)
		bne	 $t1, $zero, print_register_loop	# if (i < 32) repete

end_execute_d:
# print pc
		la	$a0, msg_print_pc
		jal print_string
		la	$t0, pc
		lb	$a0, 3($t0)
		jal print_byte
		la	$t0, pc
		lb	$a0, 2($t0)
		jal print_byte
		la	$t0, pc
		lb	$a0, 1($t0)
		jal print_byte
		la	$t0, pc
		lb	$a0, 0($t0)
		jal print_byte
		
		li $t0, 0x0a	# print `\n`
		li $t1, 0xffff000c
		sb $t0, 0($t1)
		
		lw  $ra, 0($sp)
		addi $sp, $sp, 8
		j	start
