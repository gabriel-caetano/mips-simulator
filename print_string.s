################################################################################            
print_string:
# Este procedimento imprime na ferramenta display uma string. Para marcar o final
# da string, usamos o caracatere nul=0x00.
#
# Argumentos do procedimento:
# $a0: endereço da string (buffer) que guarda os caracteres que serão apresentados no display
#
# Mapa da pilha
# $sp + 8: endereço de retorno $ra 
# $sp + 4: registrador $s1 -
# $sp + 0: registrador $s0 - 
#
# Mapa dos registradores
# $s1: caractere lido do buffer
# $s0: ponteiro para o caracter atual da string buffer
#
# Retorno do procedimento
# $v0: número de caracteres lido
################################################################################
# prólogo do procedimento
            addiu $sp, $sp,-8          # ajustamos a pilha para receber 2 itens
            sw    $ra, 4($sp)           # armazenamos os registradores que devem ser salvos
            sw    $s0, 0($sp)           #
# corpo do procedimento
            move  $s0, $a0              # inicializamos o apontador com o endereço inicial do buffer
while_next_char:   
            # lemos o caractere do buffer
            lbu   $a0, 0($s0)           # $a0 <- caractere do buffer
            # verificamos se existe pelo menos um caracter para ser impresso, senão, termina o procedimento
            beqz  $a0, epilogue_print_string # se não existem caracteres termine o procedimento      
            # imprime o caractere
            jal   write_char     # escreve o caractere do buffer
            addiu $s0, $s0, 1           # apontamos para o próximo caractere do buffer
            j     while_next_char # imprimimos o próximo carcatere
# epílogo do procedimento
epilogue_print_string:
            lw    $s0, 0($sp)           # restauramos os registradores salvos com os valores originais
            lw    $ra, 4($sp)           # 
            addiu $sp, $sp, 8           # restauramos a pilha
            jr    $ra                   # retornamos ao procedimento chamador
#-------------------------------------------------------------------------------

