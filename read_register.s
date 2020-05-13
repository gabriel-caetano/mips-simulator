################################################################################
# procedimento para ler um registrador. Lembre que os registradores no simulador
# são representados pelas variável registradores. 
#
# Argumentos
#   $a0: número i do registrador, para a leitura
#
# Retorno:
#   $v0: conteúdo do registrador
#
# Uso:
# ex.: leitura do registrador $t0 = $8
#           li      $a0, 0
#           jal     leia_registrador
#           -- o conteúdo do registrador está no registrador $v0
read_register:
################################################################################
# prólogo do procedimento
# corpo do procedimento
# Se o registrador é o 0 ou $zero, seu valor será sempre 0
            bne     $a0, $zero, read_register_not_zero # se o registrado não é $zero, leia o registrador
            li      $v0, 0 # se for $zero, retorne 0
            j       epilogue_read_register
read_register_not_zero:
            la      $t0, registers # $t0 <- endereço base da variável registradores
            sll     $a0, $a0, 2        # $a0 <- 4 * i, i é número do registrador
            addu    $t0, $t0, $a0      # $t0 <- endereço efetivo do registrador i
            lw      $v0, 0($t0)        # $v0 <- valor do registrador i
epilogue_read_register:            
# epílogo do procedimento
            jr      $ra             # retorna ao procedimento chamador
#-------------------------------------------------------------------------------