# mapa da pilha
# 0($sp) = $ra
# 4($sp) = espaco para flag da conversao de string para int e valor do endereco inicial da memoria
# 8($sp) = espaco para flag da conversao de string para int e valor da quantidade de enderecos a serem lidos
# 12($sp) = contador = 0

execute_m:
# ajusta a stack

# todo: retirar enderecos de memoria do 0($sp), 4($sp) e 8($sp) e corrigir pilha
		addi $sp, $sp, -16
		sw	 $ra, 0($sp)
		sw	 $zero, 12($sp)
		
start_print_mem:
# Busca informacoes de endereco de memoria e quantidade
# le a proxima palavra
		lw	 $a0, next_word			# carrega argumentos
		la	 $a1, word
		la	 $a2, delim
		jal  leia_palavra			# le a proxima palavra para identificar o endereco inicial para ser lido
		la	 $t0, next_word
		sw	 $v0, 0($t0)			# armazena o end da proxima palavra na variavel global next_word
# converte para um valor inteiro se possivel
		la	 $a0, word				# carrega argumentos
		la	 $a1, 4($sp)	
		jal	 converte_string_hex	# converte se possivel
		beqz $a1, execute_m_erro
		sw	 $v0, 4($sp)			# salva o valor da conversao em inteiro na pilha
# le a proxima palavra
		lw	 $a0, next_word			# carrega parametros
		la	 $a1, word
		la	 $a2, delim
		jal	 leia_palavra			# le a proxima palavra para encontrar a quantidade de enderecos
# converte para um valor inteiro se possivel
		la	 $a0, word				# carrega argumentos
		la	 $a1, 8($sp)
		jal	 converte_string_decimal# converte se possivel
		beqz $a1, execute_m_erro
		sw	 $v0, 8($sp)			# salva o valor da conversao na pilha
		
		la	 $a0, msg_header_mem
		jal  print_string
print_mem_loop:
		lw	 $t0, 12($sp)
		lw	 $t1, 8($sp)
		slt	 $t2, $t0, $t1
		beqz $t2, end_print_mem_loop# if (cont >= quantidade) break;
# imprime endereco da memoria
		la	 $a0, zero_x
		jal  print_string
		lb	 $a0, 7($sp)
		jal	 print_byte
		lb	 $a0, 6($sp)
		jal	 print_byte
		lb	 $a0, 5($sp)
		jal	 print_byte
		lb	 $a0, 4($sp)
		jal	 print_byte
		la	 $a0, space
		jal  print_string
# Imprime valor salvo na memoria
		lw	 $a0, 4($sp)			# carrega argumentos
		jal leia_memoria			# $v0 <- valor da memoria
		move $a0, $v0
		jal print_byte				# print valor da memoria
# incrementa o contador e a posicao da memoria		
		lw	 $t0, 12($sp)
		addi $t0, $t0, 1
		sw	 $t0, 12($sp)
		lw	 $t0, 4($sp)
		addi $t0, $t0, 1
		sw	 $t0, 4($sp)
		j print_mem_loop
		
		
end_print_mem_loop:
		la $a0, msg_enter
		jal print_string
		lw $ra, 0($sp)
		addi $sp, $sp, 16
		j start


execute_m_erro:
		la $a0, err_end
		jal print_string
		lw $ra, 0($sp)
		addi $sp, $sp, 16
		j start



