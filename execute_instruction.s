# Inicio do switch para reconhecer instrucao a ser executada

execute_instruction:
# Ajustando a pilha
		addi	$sp, $sp, -4
		sw		$ra, 0($sp)
#carregando valor do op_code para comparar com cada instrucao aceita (switch case)
		lw		$t0, op_code
		li		$t1, 0x09 	# op code da instrucao "addiu"
		beq		$t0, $t1, e_addiu
		li		$t1, 0x2b	# op code da instrucao "lw"
		beq		$t0, $t1, e_sw
		li		$t1, 0x00	# op code das instrucoes tipo R
		beq		$t0, $t1, tipo_r
		li		$t1, 0x03	# op code da instrucao "jal"
		beq		$t0, $t1, e_jal
		li		$t1, 0x05	# op code da instrucao "bne"
		beq		$t0, $t1, e_bne
		li		$t1, 0x08	# op code da instrucao "addi"
		beq		$t0, $t1, e_addi
		li		$t1, 0x02	# op code da instrucao "j"
		beq		$t0, $t1, e_j
		li		$t1, 0x23	# op code da instrucao "lw"
		beq		$t0, $t1, e_lw
		li		$t1, 0x1c	# op code da instrucao "mul"
		beq		$t0, $t1, e_mul
		li		$t1, 0x0f	# op code da instrucao "lui"
		beq		$t0, $t1, e_lui
		li		$t1, 0x0d	# op code da instrucao "ori"
		beq		$t0, $t1, e_ori
###############################################################################

end_instruction:
		lw		$ra, 0($sp)
		addiu	$sp, $sp, 4
		jr		$ra
###############################################################################
		
# instrucoes executadas pelo simulador
# tipo R:
tipo_r:
# carrega valor do campo funct para identificar instrucao
		lw		$t0, funct
		li		$t1, 0x20	# funct da instrucao "add"
		beq		$t0, $t1, e_add
		li		$t1, 0x08	# funct da instrucao "jr"
		beq		$t0, $t1, e_jr
		li		$t1, 0x21	# funct da instrucao "addu"
		beq		$t0, $t1, e_addu
		li		$t1, 0x0c	# funct da instrucao "syscall"
		beq		$t0, $t1, e_syscall
###############################################################################

# syscall:
e_syscall:
		li		$a0, 2
		jal		read_register
		li		$t0, 4		# valor do syscall "print string"
		beq		$v0, $t0, syscall_print_string
		li		$t0, 1		# valor do syscall "print int"
		beq		$v0, $t0, syscall_print_int
		li		$t0, 11		# valor do syscall "print char"
		beq		$v0, $t0, syscall_print_char
		li		$t0, 10		# valor do syscall "end_program"
		beq		$v0, $t0, syscall_end_program
				
###############################################################################

# syscall 10:
syscall_end_program:
		li		$t0, 0x00400000
		sw		$t0, pc
		j		start
	
###############################################################################

# syscall 11:
syscall_print_char:
		li		$a0, 4			# carrega conteudo de $a0
		jal		read_register
		li		$t0, 0xffff000c
		sw		$v0, 0($t0)		# salva o conteudo de $a0 no end do display
		j		end_instruction
###############################################################################

# syscall 1:
syscall_print_int:
		li		$a0, 4		# carrega registrador $a0
		jal		read_register
		move	$a0, $v0	# $a0 <- int para converter
		la		$a1, word	# $a1 <- end para salvar a string convertida
		jal		ItoA
		la		$a0, word
		jal		print_string
		j		end_instruction
###############################################################################

# syscall 4:
syscall_print_string:
		li		$a0, 4				# le registrador $a0
		jal		read_register
		move	$a0, $v0			# imprime string iniciada no endereco de $a0
		jal		converte_endereco
		move	$a0, $v0
		jal		print_string
		j		end_instruction		
###############################################################################

# addu:
e_addu:
		lw		$a0, rs		# le valor em rs
		jal		read_register
		move	$s0, $v0
		lw		$a0, rt		# le valor em rt
		jal		read_register
		addu	$s0, $s0, $v0	# salva soma de rs e rt em $s0
		lw		$a0, rd
		move	$a1, $s0
		jal		write_register	# salva $s0 no registrador de rd
		j 		end_instruction
###############################################################################
	
# jr:
e_jr:
		lw		$a0, rs			# carrega conteudo do registrador (que deve ser um endereco da memoria de texto
		jal 	read_register
		sw		$v0, pc			# salva o conteudo do reg em PC
		j		end_instruction
###############################################################################

# add:
e_add:
		lw		$a0, rs		# le valor em rs
		jal		read_register
		move	$s0, $v0
		lw		$a0, rt		# le valor em rt
		jal		read_register
		add		$s0, $s0, $v0	# salva soma de rs e rt em $s0
		lw		$a0, rd
		move	$a1, $s0
		jal		write_register	# salva $s0 no registrador de rd
		j 		end_instruction
###############################################################################

# tipo I:
# ori:
e_ori:
		lw		$a0, rs		# carrega valor do rs
		jal		read_register
		lw		$t0, imm_16	# carrega valor imediato
		or		$a1, $t0, $v0
		lw		$a0, rt
		jal		write_register	#grava novo valor no registrador rt
		j		end_instruction
###############################################################################

# lui:
e_lui:
		lw		$a1, imm_16		# carrega valor imediado
		sll		$a1, $a1, 16
		lw		$a0, rt			# carrega numero do registrador
		jal		write_register	# grava valor imediado no registrador
		j		end_instruction
###############################################################################

# mul:
e_mul:
		# todo: entender como o comando funciona
		lw		$a0, rs		# carrega conteudo do rs
		jal		read_register
		move	$s0, $v0	# salva o conteudo do rs em $s0
		lw		$a0, rt		# carrega connteudo do rt
		jal		read_register
		mul		$a1, $s0, $v0	#carrega valor para salvar em rd
		lw		$a0, rd		# carrega endereco do rd
		jal		write_register
		j 		end_instruction
###############################################################################

# lw:
e_lw:
		lw		$a0, rs
		jal		read_register
		move	$t0, $v0
		lw		$t1, imm_16		
		addu	$a0, $t1, $t0 	# endereco salvo em rs + imm_16
		jal		leia_memoria
		move	$s4, $v0
		
		lw		$a0, rs
		jal		read_register
		move	$t0, $v0
		lw		$t1, imm_16		
		addu	$a0, $t1, $t0 	# endereco salvo em rs + imm_16
		addi	$a0, $a0, 1
		jal		leia_memoria
		sll		$v0, $v0, 8
		addu	$s4, $s4, $v0

		lw		$a0, rs
		jal		read_register
		move	$t0, $v0
		lw		$t1, imm_16		
		addu	$a0, $t1, $t0 	# endereco salvo em rs + imm_16
		addi	$a0, $a0, 2
		jal		leia_memoria
		sll		$v0, $v0, 16
		addu	$s4, $s4, $v0
		
		lw		$a0, rs
		jal		read_register
		move	$t0, $v0
		lw		$t1, imm_16		
		addu	$a0, $t1, $t0 	# endereco salvo em rs + imm_16
		addi	$a0, $a0, 3
		jal		leia_memoria
		sll		$v0, $v0, 24
		addu	$s4, $s4, $v0
		
		move	$a1, $s4
		lw		$a0, rt
		jal		write_register	
		j		end_instruction
###############################################################################		
		
# addi:
e_addi:
		lw		$s0, imm_16	# carrega valor imediato
extende_sinal_addi:
		srl		$t1, $s0, 15	# desloca até o ultimo bit para direita (para extender o sinal)
		beq		$t1, $zero, fim_extende_sinal_addi	# se for positivo nao faz nada
		addi 	$s0, $s0, 0xffff0000	# se for negativo soma ffff no inicio
fim_extende_sinal_addi:
		lw		$a0, rs		# carrega rs
		jal		read_register
		move 	$s1, $v0
		addu	$s0, $s0, $s1	# soma rs+imm_16
		lw		$a0, rt
		move	$a1, $s0
		jal  	write_register
		j 		end_instruction
###############################################################################

# addiu:
e_addiu:
		lw		$a0, rs			# carrega valor do rs no argumento para leitura do registrador
		jal 	read_register 	# le o registrador que sera somado
		lw		$t0, imm_16		# carrega o valor imediato 16 bits da instrucao
	
extende_sinal_16:
		srl		$t1, $t0, 15	# desloca até o ultimo bit para direita (para extender o sinal)
		beq		$t1, $zero, fim_extende_sinal_16	# se for positivo nao faz nada
		addi 	$t0, $t0, 0xffff0000	# se for negativo soma ffff no inicio
fim_extende_sinal_16:
		addu	$a1, $v0, $t0	# soma o valor do registrador com o valor imediato e salva no argumento para escrita do registrador
		lw		$a0, rt			# carrega o numero do registrador no argumento para escrita do mesmo
		jal		write_register	# escreve valor no registrador
		j 		end_instruction
###############################################################################

# sw:
e_sw:
		lw		$a0, rs			# carrega indice do registrador rs
		jal 	read_register	# le o endereco salvo no registrador rs
		lw		$t0, imm_16		# carrega valor imediato
		addu	$s0, $t0, $v0	# soma endereco lido de rs com o valor imediato
		lw		$a0, rt
		jal		read_register
		andi	$t1, $v0, 0x000000ff		
		move 	$a1, $t1
		move	$a0, $s0
		jal		escreve_memoria
		lw		$a0, rs			# carrega indice do registrador rs
		jal 	read_register	# le o endereco salvo no registrador rs
		lw		$t0, imm_16		# carrega valor imediato
		addu	$s0, $t0, $v0	# soma endereco lido de rs com o valor imediato
		lw		$a0, rt
		jal		read_register
		andi	$t1, $v0, 0x0000ff00
		srl		$t1, $t1, 8
		move 	$a1, $t1
		move	$a0, $s0
		addiu	$a0, $a0, 1
		jal		escreve_memoria
		lw		$a0, rs			# carrega indice do registrador rs
		jal 	read_register	# le o endereco salvo no registrador rs
		lw		$t0, imm_16		# carrega valor imediato
		addu	$s0, $t0, $v0	# soma endereco lido de rs com o valor imediato
		lw		$a0, rt
		jal		read_register
		andi	$t1, $v0, 0x00ff0000
		srl		$t1, $t1, 16
		move 	$a1, $t1
		move	$a0, $s0
		addiu	$a0, $a0, 2
		jal		escreve_memoria
		lw		$a0, rs			# carrega indice do registrador rs
		jal 	read_register	# le o endereco salvo no registrador rs
		lw		$t0, imm_16		# carrega valor imediato
		addu	$s0, $t0, $v0	# soma endereco lido de rs com o valor imediato
		lw		$a0, rt
		jal		read_register
		andi	$t1, $v0, 0xff000000
		srl		$t1, $t1, 24
		move 	$a1, $t1
		move	$a0, $s0
		addiu	$a0, $a0, 3
		jal		escreve_memoria
		j 		end_instruction
###############################################################################

# bne
e_bne:
		lw		$a0, rs
		jal 	read_register
		move	$s0, $v0		# $s0 = conteudo de rs
		lw		$a0, rt
		jal		read_register
		move	$s1, $v0		# $s1 = conteudo de rt
		beq		$s0, $s1, end_instruction # se rt=rd nao faz nada
		lw		$t0, pc			# carrega pc+4
		lw		$t1, imm_16
		sll		$t1, $t1, 2		# imm_16 * 4
		addu	$t0, $t0, $t1	# (pc+4) + (4*imm_16)
		sw		$t0, pc
		j		end_instruction
###############################################################################

# j:
e_j:
		lw		$t0, imm_26		# carrega valor imediato
		sll 	$t0, $t0, 2		# multiplica por 4
		lw		$t1, pc			# carrega valor do pc e isolo 4 msb
		andi	$t1, $t1, 0xf0000000
		add		$t0, $t0, $t1	# somo pc+4 com imm_26
		la		$t1, pc			# carrega endereco do pc
		sw		$t0, 0($t1)		# salva novo endereco no pc
		j		end_instruction
###############################################################################

# jal:
e_jal:
		lw		$a1, pc			# carrega valor do pc+4
		li		$a0, 31			# indice do $ra
		jal 	write_register	# escreve pc+4 em $ra
		lw		$t0, imm_26		# carrega valor imediato
		sll 	$t0, $t0, 2		# multiplica por 4
		lw		$t1, pc			# carrega valor do pc e isolo 4 msb
		andi	$t1, $t1, 0xf0000000
		add		$t0, $t0, $t1	# somo pc+4 com imm_26
		la		$t1, pc			# carrega endereco do pc
		sw		$t0, 0($t1)		# salva novo endereco no pc		
		j 		end_instruction
###############################################################################