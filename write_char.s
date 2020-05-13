################################################################################            
write_char:
# Este procedimento escreve um caractere na ferramenta display
#
# Argumentos do procedimento:
# $a0: caractere a ser apresentado no display.
#
# Mapa da pilha
# não usamos a pilha neste procedimento
#
# Mapa dos registradores
# $t0: endereço do TDR ou TCR
# $t1: TCR
#
# Retorno do procedimento
# Este procedimento não retorna nenhum dado
################################################################################
# prólogo do procedimento

# corpo do procedimento 
           # esperamos o display estar livre
            la    $t0, 0xFFFF0008   # endereço do TCR
write_char_loop:
            lw    $t1, 0($t0)       # $t1 <- conteúdo do TCR
            andi  $t1, $t1, 0x0001  # isolamos o bit menos significativo
            beqz  $t1, write_char_loop
            
            # escrevemos o carcatere no display
            la    $t0, 0xFFFF000C   # endereço do TDR
            sw    $a0, 0($t0)
# epílogo do procedimento
            jr    $ra

#-------------------------------------------------------------------------------