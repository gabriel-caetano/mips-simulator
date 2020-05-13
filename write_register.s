################################################################################            
write_register:
# procedimento para escrever um registrador. Lembre que os registradores no simulador
# são representados pelas variável registradores. 
#
# Argumentos
#   $a0: número i do registrador, para a escrita
#   $a1: dado armazenado no registrador
#
# Uso:
# ex.: escrita do valor 0x55 no registrador $t0 = $8
#           li      $a0, 8
#           li      $a1, 0x55
#           jal     escreve_registrador
#           -- o registrador $t0 possui agora o valor 0x55
#           
################################################################################
# prólogo do procedimento
# corpo do procedimento
# se o registrador é o $zero, não podemos escrever
            bne     $a0, $zero, write_register_not_zero
            j       epilogue_write_register
write_register_not_zero:
            la      $t0, registers # $t0 <- endereço base da variável registradores
            sll     $a0, $a0, 2        # $a0 <- 4 * i, i é número do registrador
            addu    $t0, $t0, $a0      # $t0 <- endereço efetivo do registrador i
            sw      $a1, 0($t0)        # escrevemos no registrador
epilogue_write_register:
# epílogo do procedimento
            jr      $ra             # retorna ao procedimento chamador
#-------------------------------------------------------------------------------