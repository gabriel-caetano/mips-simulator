# $a0 <- string 1
# $a1 <- string 2

compare_string:
		move $s0, $a0
		move $s1, $a1
compare_char:
		lb   $t0, 0($s0)
		lb   $t1, 0($s1)
		bne  $t0, $t1, end_false
		beqz $t0, end_true
		addi $s0, $s0, 1
		addi $s1, $s1, 1
		j compare_char
								
end_false:
		li $v0, 0
		jr $ra
		
end_true:
		li $v0, 1
		jr $ra