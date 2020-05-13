 # 0($sp) <- quantidade de instrucoes para executar (deve ser lida)
# 4($sp) <- iterador = 0

execute_r:
		addi $sp, $sp, -12		# corrige a pilha
		sw	 $zero, 4($sp)		# i = 0
		lw	 $a0, next_word		# argumentos para ler palavra
		la	 $a1, word
		la	 $a2, delim
		jal  leia_palavra		# le prox palavra
		la	 $a0, word			# argumentos para converter string para decimal
		la	 $a1, 0($sp)
		jal	 converte_string_decimal
		beqz $a1, execute_r_all	# se nao converteu executa tudo
		beqz $v0, execute_r_all
		sw	 $v0, 0($sp)		# salva quantidade na pilha
		
# executa n instrucoes
execute_r_loop:
		jal load_instruction		# carrega instrucao no endereco de pc
		beqz $v0, end_execute_r		# se instrucao = 0 acabou programa
		lw	 $t1, 0($sp)			# i < quantidade: executa, se nao: break;
		lw	 $t2, 4($sp)
		slt	 $t3, $t2, $t1
		beqz $t3, end_execute_r
		addi $t2, $t2, 1
		sw	 $t2, 4($sp)
		sw	 $v0, ir				# ir <- instrucao carregada
		lw	 $t0, pc				# pc += 4
		addi $t0, $t0, 4
		sw	 $t0, pc
		lw	 $a0, ir
		jal decode_instruction
		jal execute_instruction		
		j execute_r_loop
		
# executa todas as instrucoes
execute_r_all:
		jal load_instruction		# carrega instrucao no endereco de pc
		beqz $v0, end_execute_r		# se instrucao = 0 acabou programa
		sw	 $v0, ir				# ir <- instrucao carregada
		lw	 $t0, pc				# pc += 4
		addi $t0, $t0, 4
		sw	 $t0, pc
		lw	 $a0, ir
		jal decode_instruction
		jal execute_instruction		
		j execute_r_all

# encerra execucao do programa:
# pc <- 0x00400000
# volta para o inicio		
end_execute_r:
		addi $sp, $sp, 12
		#li $t1, 0x00400000
		#sw $t1, pc
		j start
