# funcao para ler o keyboard mips

.text

.globl read_command

read_command:

	la 		$t1, input_cont
	addi 	$t2, $zero, 0
	sw      $t2, 0($t1)

loop1:            
	# esperamos um caracter no terminal
	la		$t0, 0xFFFF0000   # endereço do RCR
loop2:
	lw		$t1, 0($t0)       # $t1 <- conteúdo do RCR
	andi	$t1, $t1, 0x0001  # isolamos o bit menos significativo
	beqz	$t1, loop2

	# lemos o carcater
	la		$t0, 0xFFFF0004   # endereço do RDR
	lw		$t2, 0($t0)       # $t2 <- caracter do terminal

check_enter:
	beq		$t2, 0x0000000a, return_string
	
saveInput:
	la    $t0, input_cont			# carrega endereço do contador
	lw    $t1, 0($t0)       # carrega valor do contador
	la    $t3, input		# carrega endereço da string para salvar o input
	add   $t0, $t3, $t1     # incrementa o endereco do input conforme o contador
	sb    $t2, 0($t0)       # armazena valor do teclado no input
	sb    $zero, 1($t0)     # armazena fim de linha no proximo byte
	# incrementa contador usado para salvar string
contador:                        
	la    $t0, input_cont			# endereco do contador
	lw    $t1, 0($t0)		# $t1 <- valor do contador
   	addiu $t1, $t1, 1		# incrementa $t1
	sw    $t1, 0($t0)		# salva valor do contador na memoria

	# escrevemos o caracter no display

	# esperamos o display estar livre
	la		$t0, 0xFFFF0008   # endereço do TCR
 
loop3:
	lw    	$t1, 0($t0)       # $t1 <- conteúdo do TCR
	andi  	$t1, $t1, 0x0001  # isolamos o bit menos significativo
	beqz  	$t1, loop3

	# escrevemos o carcatere no display
	la    	$t0, 0xFFFF000C   # endereço do TDR
	sw    	$t2, 0($t0)

	j     	loop1
            
return_string:
	li $t0, 0x0a
	li $t1, 0xffff000c
	sb $t0, 0($t1)
	jr $ra
		            
