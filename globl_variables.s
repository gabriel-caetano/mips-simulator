.data

# Variaveis usadas para o reconhecimento dos comandos dados pelo usuario
.align 2
input_cont:     .word    	0	# Contador de caracteres da string digitada pelo usuario
input:      	.space   	256 # Armazena a string digitada pelo usuario
word:			.space		128	# Armazena a palavra lida da string digitada pelo usuario
next_word:		.word		0	# Endereco do fim da primeira palavra (para leitura da proxima)
delim: 			.asciiz 	" \t\n,"
lt:				.asciiz		"lt"
lda:			.asciiz		"ld"
r:				.asciiz		"r"
d:				.asciiz		"d"
m:				.asciiz		"m"
q:				.asciiz		"q" #comando para encerrar




# Variaveis usadas para o funcionamento do processador mips
.align 2
text_segment:	.space 65536    # segmento de memória para instruções (.text)
data_segment:   .space 65536    # segmento de memória para os dados (.data)
stack_segment:  .space 65536    # segmento de memoria da pilha
registers:		.space		128
buffer:			.space		2
pc:				.word		0x00400000
ir:				.word		0x00000000
op_code_mask:	.word		0xfc000000
op_code:		.word		0
rs_mask:		.word		0x03e00000
rs:				.word		0
rt_mask:		.word		0x001f0000
rt:				.word		0
rd_mask:		.word		0x0000f800
rd:				.word		0
shamt_mask:		.word		0x000007c0
shamt:			.word		0
funct_mask:		.word		0x0000003f
funct:			.word		0
imm_16_mask:	.word		0x0000ffff
imm_16:			.word		0
imm_26_mask:	.word		0x03ffffff
imm_26:			.word		0
end_data:       .word       0x10010000
text_bin: 		.asciiz		"text.bin"


# Strings usadas para tornar o uso mais acessivel
welcome_msg1:		.asciiz		"Bem vindo ao simulador do processador mips!\n"
welcome_msg2:		.asciiz		"Para operar o programa execute os seguintes comandos:\n"
welcome_msg3:		.asciiz		"\"lt <nome do arquivo>\" (carrega um arquivo binario de instrucoes mips.\n"
welcome_msg4:		.asciiz		"\"ld <nome do arquivo>\" (carrega um arquivo binario de dados.\n"
welcome_msg5:		.asciiz		"\"r <numero de instrucoes>\" (executa instrucoes carregadas na memoria).\n"
welcome_msg6: 		.asciiz		"\"d\" (mostra na tela o conteudo atual dos registradores\n"
welcome_msg7:		.asciiz		"\"m\" <endereco inicial> <numero de enderecos> (mostra na tela o conteudo dos enderecos de memoria solicitados.\n"
welcome_msg8:		.asciiz		"\"q\" (encerra o programa)\n\n"
err:				.asciiz		"Comando invalido.\n"
err_end:			.asciiz		"Endereco de memoria invalido.\n"
msg_erro_escreve_memoria: .asciiz "Erro na escrita na memória\n"
msg_erro_le_memoria:.asciiz 	"Erro na leitura da memória\n"
msg_print_register1:.asciiz		"$"
space:				.asciiz		": "
msg_enter:      	.asciiz		"\n"
msg_header_mem:		.asciiz		"Endereco  | Conteudo"
zero_x:				.asciiz		"\n0x"
msg_print_pc:		.asciiz		"$pc: "
