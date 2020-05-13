# $a0 <- instrucao


decode_instruction:
# separa op code
		lw	$t0, op_code_mask
		and	$t1, $a0, $t0
		srl $t1, $t1, 26
		la	$t2, op_code
		sw	$t1, 0($t2)
# separa rs
		lw	$t0, rs_mask
		and	$t1, $a0, $t0
		srl $t1, $t1, 21
		la	$t2, rs
		sw	$t1, 0($t2)
# separa rd
		lw	$t0, rd_mask
		and	$t1, $a0, $t0
		srl $t1, $t1, 11
		la	$t2, rd
		sw	$t1, 0($t2)
# separa rt
		lw	$t0, rt_mask
		and	$t1, $a0, $t0
		srl $t1, $t1, 16
		la	$t2, rt
		sw	$t1, 0($t2)
# separa shamt
		lw	$t0, shamt_mask
		and	$t1, $a0, $t0
		srl $t1, $t1, 6
		la	$t2, shamt
		sw	$t1, 0($t2)
# separa funct
		lw	$t0, funct_mask
		and	$t1, $a0, $t0
		la	$t2, funct
		sw	$t1, 0($t2)
# separa imm_16
		lw	$t0, imm_16_mask
		and	$t1, $a0, $t0
		la	$t2, imm_16
		sw	$t1, 0($t2)
# separa imm_26
		lw	$t0, imm_26_mask
		and	$t1, $a0, $t0
		la	$t2, imm_26
		sw	$t1, 0($t2)
		
		jr $ra
