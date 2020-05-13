# Switch do commando
switch_command:
# $a0 <- primeita palavra lida no comando
		la $a0, word

# $a1 <- "d", se $a0 = $a1 executa d		
		la $a1, d
		jal compare_string
		bne $v0, $zero, execute_d
# $a1 <- "m", se $a0 = $a1 executa m		
		la $a1, m
		jal compare_string
		bne $v0, $zero, execute_m
# $a1 <- "lt", se $a0 = $a1 executa lt
		la $a1, lt
		jal compare_string
		bne $v0, $zero, execute_lt
# $a1 <- "ld", se $a0 = $a1 executa ld		
		la $a1, lda
		jal compare_string
		bne $v0, $zero, execute_ld
# $a1 <- "r", se $a0 = $a1 executa r		
		la $a1, r
		jal compare_string
		bne $v0, $zero, execute_r
# $a1 <- "q", se $a0 = $a1 executa q	
		la $a1, q
		jal compare_string
		bne $v0, $zero, execute_q

erro_de_comando:		
		la $a0, err
		jal print_string
		j	start	

execute_q:
		li $v0, 17
		li $a0, 0
		syscall
