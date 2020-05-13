# Programa para simular o processador MIPS (em desenvolvimento)
# Nome dos desenvolvedores:
# Gabriel Di Domenico
# Gabriel Vinicius Schmitt Caetano

# Duvidas:
# -hi lo precisam ser impressos junto com os registradores?
# -foi utilizada uma funcao auxiliar pronta encontrada na internet (ItoA)
# tem problema?

.text
.globl main
main:
# Printa legenda inicial
	jal print_welcome
# seta registradores $gp e $sp com valores iniciais
	li	$a0, 29
	li  $a1, 0x7fffeffc
	jal write_register
	li  $a0, 28
	li  $a1, 0x10008000
	jal write_register

# inicio da execução do programa
start:
# Le inputs recebidos pelo simulador do teclado
	jal read_command

# Processa a string recebida pelo simulador do teclado e separa a primeira palavra
	la	$a0, input
	la	$a1, word
	la	$a2, delim
	jal	leia_palavra
	la  $t0, next_word
	sw  $v0, 0($t0)
# Identifica qual comando foi digitado
	j switch_command
	
.include	"ItoA.s"
.include	"converte_endereco.s"
.include	"execute_instruction.s"
.include 	"execute_r.s"
.include	"load_instruction.s"
.include 	"decode_instruction.s"
.include	"read_memory.s"
.include	"write_memory.s"	
.include	"compare_string.s"	
.include	"switch_command.s"
.include	"welcome/print_welcome.s"
.include	"read_word.s"
.include	"print_byte.s"
.include	"print_register.s"
.include 	"globl_variables.s"
.include  	"read_command.s"
.include	"read_register.s"
.include	"write_register.s"
.include	"print_string.s"
.include 	"write_char.s"
.include	"execute_d.s"
.include	"execute_m.s"
.include	"converte_string_decimal.s"
.include	"converte_string_hex.s"
.include 	"is_valid.s"
.include	"print_mem_segment.s"
.include	"print_single_mem.s"
.include 	"execute_lt.s"
.include 	"execute_ld.s"
