# funcao que recebe o endereco e tamanho da memoria a ser impressa
# retorna o endereco inicial da memoria a ser impressa em $v0
# se for invalida retorna 0

# mapa da pilha:
# 0($sp) = $ra
# 4($sp) = $a0(endereco inicial)
# 8($sp) = $a1(tamanho da memoria)
is_valid:
#ajusta a pilha:
		addi $sp, $sp, -12
		sw	 $ra, 0($sp)
		sw	 $a0, 4($sp)
		sw	 $a1, 8($sp)
		
check_text:
		li	 $t0, 4096	 		# $t0 <- tamanho dos segmentos de memoria
		lw	 $a0, 4($sp)		# $a0 <- endereco inicial da memoria a ser lida
		li	 $a1, 0x00400000	# $a1 <- endereco inicial do segmento de texto
		addu $a2, $a1, $t0		# $a2 <- endereco final do segmento de texto
		jal	 pertence_segmento_memoria
		beqz $v0, check_data	# if (!end texto) check data

		li	 $t0, 4096	 		# $t0 <- tamanho dos segmentos de memoria
		lw	 $t1, 8($sp)		# $t0 <- tamanho da memoria a ser lida
		lw	 $a0, 4($sp)		# $a0 <- endereco inicial da memoria a ser lida
		addu $a0, $a0, $t1		# $a0 <- endereco final da memoria a ser lida
		la	 $a1, 0x00400000	# $a1 <- endereco inicial do segmento de texto
		addu $a2, $a1, $t0		# $a2 <- endereco final do segmento de texto
		jal	 pertence_segmento_memoria
		beqz $v0, end_invalid_address		# se memoria nao estiver no endereco retorna 0
#se memoria for valida retorna endereco inicial para a impressao
		la 	 $t0, text_segment	# converte endereco digitado em endereco no vetor global e encerra procedimento
		lw	 $v0, 4($sp)
		addi $v0, $v0, -0x00400000
		add	 $v0, $v0, $t0
		lw	 $ra, 0($sp)
		addi $sp, $sp, 12
		jr	 $ra
		
print_text_mem:		
		lw	 $t0, 4($sp)
		addi $t0, $t0, -0x00400000	# subtrai endereco padrao de memoria
		la	 $t1, text_segment		
		addu $t0, $t0, $t1			# adiciona endereco local do array
		move $a0, $t0				# $a0 <- endereco inicial da memoria
		lw	 $a1, 8($sp)			# $a1 <- quantidade de memorias
		jal print_mem_segment
		lw	 $ra, 0($sp)
		addi $sp, $sp, 12
		jr $ra

		
check_data:
		li	 $t0, 4096	 		# $t0 <- tamanho dos segmentos de memoria
		lw	 $a0, 4($sp)		# $a0 <- endereco inicial da memoria a ser lida
		la	 $a1, 0x10010000	# $a1 <- endereco inicial do segmento de data
		addu $a2, $a1, $t0		# $a2 <- endereco final do segmento de data
		jal	 pertence_segmento_memoria
		beqz $v0, check_stack	# if (end data) check second, else check stack

		
check_stack:
		li	 $t0, 4096	 		# $t0 <- tamanho dos segmentos de memoria
		lw	 $a0, 4($sp)		# $a0 <- endereco inicial da memoria a ser lida
		la	 $a1, 0x7fffeffc	# $a1 <- endereco inicial do segmento de stack
		addu $a2, $a1, $t0		# $a2 <- endereco final do segmento de stack
		jal	 pertence_segmento_memoria
		beqz $v0, end_invalid_address		# if (end stack) check second, else end_false

		
end_invalid_address:
		li $v0, 0
		lw $ra, 0($sp)
		addi $sp, $sp, 12
		jr $ra
		



		
################################################################################
# procedimento que verifica se um endereço pertence a um segmento de memória
#
# argumentos
# $a0: endereço
# $a1: endereço inicial do segmento de memória
# $a2: endereço final do segmento de memória
#
# valor de retorno
# $v0: 1 se pertence ao segmento, 0 se não pertende
pertence_segmento_memoria:
################################################################################
# prólogo do procedimento
# corpo do procedimento
# verificamos se $a0 >= $a1
            sgeu    $v0, $a0, $a1
            beq     $v0, $zero, epilogo_pertence_segmento # se 0, não pertence ao segmento
# verificamos se $a0 <= $a2
            sleu    $v0, $a0, $a2
epilogo_pertence_segmento:
# epílogo do procedimento
            jr      $ra             # retorna ao procedimento chamador
#-------------------------------------------------------------------------------
