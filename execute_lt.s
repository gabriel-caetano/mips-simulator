#Programa para ler um arquivo e escrever na memoria (izi)

execute_lt:
#================================================================
	li		$s7, 0x00400000
	addi 	$sp, $sp, -4
	sw  	$ra, 0($sp)
	# le a proxima palavra
		lw	 $a0, next_word			# carrega argumentos
		la	 $a1, word
		la	 $a2, delim
		jal  leia_palavra			# le a proxima palavra para identificar o endereco inicial para ser lido
		la	 $t0, next_word
		sw	 $v0, 0($t0)			# armazena o end da proxima palavra na variavel global next_word


		li		$v0, 13 #chama o open file
		la		$a0, word #manda o nome do arquivo
		li		$a1, 0 #flag para ler o arquivo (1 para escrever)
		add 	$a2, $zero, $zero #Ignora o modo
		syscall
		move $s6, $v0 #salva o file descriptor
#================================================================

#================================================================
	#while(tem_string_arquivo){
	while:
		#le do arquivo
		li		$v0, 14 #chamada de leitura
		move	$a0, $s6 #file descriptor
		la		$a1, buffer #local onde ira salvar o valor lido
		li		$a2, 1 #tamanho maximo de caracteres a serem lidos
		syscall
		move	$s2, $v0
		
		move 	$a0, $s7
		lw 		$a1, buffer
		jal escreve_memoria
		addi	$s7, $s7, 1
		
	checa_while:
		li		$t0, 1
		beqz	$s2, fim_while
		beq		$s2, $t0, while
		bltz	$s2, erro
		j		fim_while
	erro:
		la 		$a0, word
		jal 	print_string
		
	fim_while:
		
#================================================================

#================================================================
	#fecha o arquivo
	li		$v0, 16
	move	$a0, $s6
	syscall
#================================================================

	lw  $ra, 0($sp)
	addi $sp, $sp, 4
	j	start
