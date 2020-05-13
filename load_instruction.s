# Carrega a instrucao contina no endereco de pc e incrementa o pc
# $v0 <- instrucao
# $v0 <- 0 se programa encerrar
# 0($sp) <- instrucao a ser retornada
# 4($sp) <- $ra


load_instruction:
		addi $sp, $sp, -8
		sw	$ra,   4($sp)
		sw	$zero, 0($sp)
		
		lw  $t0, pc
		addi $a0, $t0, 3
		jal leia_memoria
		sll $v0, $v0, 24
		sw	$v0, 0($sp)
		lw  $t0, pc
		addi $a0, $t0, 2
		jal leia_memoria
		sll $v0, $v0, 16
		lw	$t0, 0($sp)
		add $t0, $t0, $v0
		sw	$t0, 0($sp)
		lw  $t0, pc
		addi $a0, $t0, 1
		jal leia_memoria
		sll $v0, $v0, 8
		lw	$t0, 0($sp)
		add $t0, $t0, $v0
		sw	$t0, 0($sp)
		lw  $a0, pc
		jal leia_memoria
		lw	$t0, 0($sp)
		add $t0, $t0, $v0
		sw	$t0, 0($sp)
		move $v0, $t0
		lw  $ra, 4($sp)
		addi $sp, $sp, 8
		jr $ra
		