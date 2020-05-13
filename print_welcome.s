print_welcome:
		addi $sp, $sp, -4
		sw   $ra, 0($sp)
		la $a0, welcome_msg1
		jal print_string
		la $a0, welcome_msg2
		jal print_string
		la $a0, welcome_msg3
		jal print_string
		la $a0, welcome_msg4
		jal print_string
		la $a0, welcome_msg5
		jal print_string
		la $a0, welcome_msg6
		jal print_string
		la $a0, welcome_msg7
		jal print_string
		la $a0, welcome_msg8
		jal print_string
		
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		jr $ra
