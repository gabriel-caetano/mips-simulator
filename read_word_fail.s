#Mapa do codigo:

#$a0 <- str, ponteiro para a string onde ser?o procurada as palavras
#$a1 <- buffer, ponteiro para um buffer, onde guardamos uma palavra da string
#$a2 <- delim, ponteiro para uma string com os caracteres delimitadores

#$t0 <- char carregado do endere?o da string
#$t1 <- valor da diferen?a entre o delim e o char comparado, se 0, o char ? igual o delim, sen?o, o char n esta no delim
#$t2 <- char do delim
#$t3 <- *delim

#=============================================================================//================================================================================================

.text
.globl read_word

read_word:
      

# Inicia leitura            

read_word_while_1:
            # Carrega caractere da string do input
            lbu     $t0, 0($a0)


# Compara se char é delimitador
caractere_eh_delimitador_while1:
            lbu     $t2, 0($a2)     # $t2 <-caractere da string delim (0 se chegou ao fim)
            subu    $t1, $t0, $t2   # $t1 <- 0 se caractere do input for igual ao caractere do delim
            beqz    $t2, caractere_eh_delimitador_while_false1	# delim chegou no final sai do laco paraincrementar char do input
            beqz    $t1, caractere_eh_delimitador_while_false1	# delim = input sai do laco para incrementar o char do input
            addiu   $a2, $a2, 1     # delim++
            j       caractere_eh_delimitador_while1	#reinicia o laco

caractere_eh_delimitador_while_false1:
            la      $a2, delim		# reseta o endereco

# $t2 = 0 char nao é delimitador
# while ( delim == char input && input != 0)

            beqz    $t1, read_word_while_1_false
            beqz    $t0, read_word_while_1_false
            addiu   $a0, $a0, 1 
            j       read_word_while_1
read_word_while_1_false:
#     // lemos a palavra at? um delimitador ou o fim da string
#     while(*str && (!caractere_eh_delimitador(*str, delim))) *buffer++ = *str++;
read_word_while_2:
            # executamos o procedimento caractere_eh_delimitador
            lbu     $t0, 0($a0)

            # se uma das condi?oes da opera??o and em while for zero, sa?mos deste la?o while
            # retorno de (caractere_eh_delimitador(*str, delim) est? em $v0

# pr?logo do procedimento
# corpo do procedimento
# {
#     while(*delim && (*delim != ch)) delim++;
caractere_eh_delimitador_while2:
            lbu     $t2, 0($a2)     # $t2 <-*delim, 0 se chegamos no final da string com os caracteres delimitadores
            subu    $t1, $t0, $t2   # $t1 <- valor diferente de 0 se *delim != ch
            # se uma das condi??es for falsa, a opera??o and ? falsa: sa?mos do la?o while
            beqz    $t2, caractere_eh_delimitador_while_false2
            beqz    $t1, caractere_eh_delimitador_while_false2
            addiu   $a2, $a2, 1     # delim++
            j       caractere_eh_delimitador_while2 
caractere_eh_delimitador_while_false2:            
# ep?logo do procedimento
#     return *delim;
            la      $a2, delim
# }
            
            
            lbu     $t0, 0($a0)     # $t0 <- *str
     
            bnez    $t2, read_word_while_2_false
            beqz    $t0, read_word_while_2_false
            lb      $t4, 0($a0)
            sb      $t4, 0($a1)     # *buffer = *str 
            addiu   $a0, $a0, 1     # str++
            addiu   $a1, $a1, 1     # buffer++
            
            j       read_word_while_2
read_word_while_2_false:
#     *buffer = 0; 
            sb      $zero, 1($a1)
#            la $a0, word
 #           move $v0, $a0
# ep?logo do procedimento
            jr      $ra
