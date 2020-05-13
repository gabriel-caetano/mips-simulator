################################################################################            
converte_string_hex:
#
# Converte uma string hexadecimal para um número inteiro sem sinal. A string tem 
# o formato "0xM..M": começam com "0x" e em seguida caracteres M = '0' a 'F'.
# A string deve estar entre "0x0" a "0xFFFFFFFF", ou seja, o maior valor que pode
# ser convertido tem o valor 2^32-1 = 4294967295 = 0xFFFFFFFF.
#
# Argumentos
#   $a0: o endereço da string hexadecimal que será convertida
#   $a1: o endereço da variável inteira que recebe o estado da conversão. O valor desta
#        variável é 0 se a conversão não pode ser realizada.
#
# Valor de retorno:
#   $v0: o valor da string hexadecimal. Se a conversão não pode ser realizada, $v0 
#        será igual a 0.
#
# Uso
# Ex.: converter a string teste, definida como uma variável estática
#           teste: .space 100 # uma string com 100 caracteres (bytes)
#      Vamos supo que em um momento possui o valor teste="0x123"
#      para realizar a conversão utilize também uma variável para indicar o estado
#      da conversão, por exemplo, definimos a variável ok:
#      .data
#           ok: .space 4
#      Para realizar a conversão usamos o seguinte código
#           la      $a0, teste      # endereço da string hexadecimal
#           la      $a1, ok         # endereço da variável com o estado da conversão
#           jal converte_string_decimal
#           ---  no registrador $v0 temos o valor 291 (valor decimal) e o valor da 
#                variável ok será 1, indicando que a conversão foi realizada sem problemas.
#                Se a conversão da string para um valor numérico não pode ser 
#                realizada, o valor desta variável será 0.
################################################################################
# prólogo do procedimento
# corpo do procedimento
            li      $t0, 16         # base hexadecimal
            li      $v0, 0          # usamos para calcular o valor da string hexadecimal 
            li      $t3, 0          # a conversão não foi realizada
            # verificamos se os dois caracteres iniciais são "0x"
            lbu     $t1, 0($a0)     # carregamos o primeiro caractere
            li      $t4, '0'        # o primeiro caracatere deve ser '0'
            bne     $t1, $t4, converte_string_hexadecimal_fim # se não for, termina o procedimento
            addiu   $a0, $a0, 1     # apontamos para o próximo carcatere
            lbu     $t1, 0($a0)     # carregamos o próximo caractere
            li      $t4, 'x'        # o proximo caractere deve ser 'x'
            bne     $t1, $t4, converte_string_hexadecimal_fim # se não for, termina o procedimento
            addiu   $a0, $a0, 1     # avançamos para o próximo carcatere
converte_string_hexadecimal_laco:
            # verificamos se existem dígitos (como caracteres) na string 
            lbu     $t1, 0($a0)     # carregamos um  caracter 
            beq     $t1, 0, converte_string_hexadecimal_fim # se fim string, termina o procedimento.
            # se o caractere for diferende de '0' a '9' ou 'a' a 'f' ou 'A' a 'F', ocorre um erro
testa_caractere_0_a_9:            
            sgeu    $t4, $t1, '0'   # verifica se o caractere $t1 está entre '0' e '9' 
            sleu    $t5, $t1, '9'   #
            and     $t6, $t4, $t5   # $t6 = 1 se '0' <= $t1 <= '9'
            beq     $t6, $zero, testa_caractere_a_a_f # $t6 = 0, testa se 'a' <= $t1 <= 'f'
            addiu   $t1, $t1, -48   # ajusta o valor do caractere para 0 a 9
            j       converte_string_hexadecimal_realiza_conversao # adiciona no processo de conversão
testa_caractere_a_a_f:            
            sgeu    $t4, $t1, 'a'   # verifica se o caractere está entre 'a' e 'f'
            sleu    $t5, $t1, 'f'   #
            and     $t6, $t4, $t5   # $t6 = 1 se 'a' <= $t1 <= 'f'
            beq     $t6, $zero, testa_caractere_A_a_F # se $t6 = 0, verifica se 'A' <= $t1 <= 'F'
            addiu   $t1, $t1, -87   # ajusta o caracatere para valores entre 10 e 15
            j       converte_string_hexadecimal_realiza_conversao
testa_caractere_A_a_F:            
            sgeu    $t4, $t1, 'A'   # verifica se o caractere está entre 'A' e 'F'
            sleu    $t5, $t1, 'F'   #
            and     $t6, $t4, $t5   # $t6 = 1 se 'A' <= $t1 <= 'F'
            beq     $t6, $zero, converte_string_hexadecimal_erro # $t6 = 0, o caracatere não está entre '0' a '9' ou 'a' a 'f' (ou 'A' a 'F')
            addiu   $t1, $t1, -55   # ajusta o caractere para valores entre 10 e 15
converte_string_hexadecimal_realiza_conversao:            
            li      $t3, 1          # caractere representa dígito hexadecimal
            mul     $t2, $v0, $t0   # multiplicamos pela base
            add     $v0, $t2, $t1   # adicionamos o valor do próximo dígito da string
            addiu   $a0, $a0, 1     # apontamos para o próximo caractere da string
            j       converte_string_hexadecimal_laco # repetimos para o próximo caractere da string
converte_string_hexadecimal_erro:
            li      $v0, 0          # retornamos 0
            li      $t3, 0          # indicamos que houve erro na conversão
converte_string_hexadecimal_fim:    
            sw      $t3, 0($a1)     # armazenamos o estado da conversão: 1 sucesso
# epílogo do procedimento
            jr      $ra             # retorna ao procedimento chamador
#-------------------------------------------------------------------------------