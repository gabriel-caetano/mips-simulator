# Procedimento para impressao de 1 byte em formato de string hexadecimal
# $a0 < byte
#

print_byte:
		move $t4, $a0

		andi $t0, $t4, 0x000000f0
		srl	 $t0, $t0, 4
		li 	 $t2, 10
		slt  $t1, $t0, $t2 # $t1 <- 1 se $t0 < 10
		beqz $t1, sum_letter1
sum_number1:
		addi $t0, $t0, 48
		li	 $t1, 0xffff000c
		sb	 $t0, 0($t1)
		j print_next
		
sum_letter1:
		addi $t0, $t0, 55
		li	 $t1, 0xffff000c
		sb	 $t0, 0($t1)

print_next:
		andi $t0, $t4, 0x0000000f
		li 	 $t2, 10
		slt  $t1, $t0, $t2 # $t1 <- 1 se $t0 < 10
		beqz $t1, sum_letter2
				
sum_number2:
		addi $t0, $t0, 48
		li	 $t1, 0xffff000c
		sb	 $t0, 0($t1)
		j end_print_byte
		
sum_letter2:
		addi $t0, $t0, 55
		li	 $t1, 0xffff000c
		sb	 $t0, 0($t1)

end_print_byte:
		jr $ra
