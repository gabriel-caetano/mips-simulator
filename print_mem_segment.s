# imprime enderecos de memoria (apos conferir se sao validos)
# $a0 <- end inicial
# $a1 <- quant
print_mem_segment:

# ajusta a pilha
		addi $sp, $sp, -16
		sw	 $ra, 0($sp)	# 0($s0) = $ra
		sw	 $a0, 4($sp)	# 4($sp) = end inicial
		sw	 $a1, 8($sp)	# 8($sp) = quantidade
		li	 $t0, 0
		sw	 $t1, 12($sp)	# 12($sp) = i = 0
		
print_mem_start:
		lw	 $t0, 8($sp)
		lw	 $t1, 12($sp)
		slt	 $t2, $t0, $t1
		beqz $t2, end_print_mem
		lw	 $a0, 4($sp)
		addu $a0, $a0, $t1
		jal  print_single_mem
		
end_print_mem:
		