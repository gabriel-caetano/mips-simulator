################################################################################            
converte_string_decimal:
# Converte uma string em um valor decimal sem sinal.
#
# Converte uma string, com o endereço em $a0, em um valor decimal sem sinal. 
# Strings com números negativos não são aceitos, retorna um 0 e erro de conversão.
# as strings podem ter valores de "0" a "4294967295" (2^32-1)
# 
# Argumentos:
#   $a0: endereço da string
#   $a1: endereco da variável inteira para indicar que a conversão foi realizada
#        corretamente.
#   
# Valores de retorno:
#   $v0: valor da string decimal, 0 se a string não pode ser convertida
#
# Uso
# Ex.: converter a string teste, definida como uma variável estática
#           teste: .space 100 # uma string com 100 caracteres (bytes)
#      Vamos supo que em um momento possui o valor teste="123"
#      para realizar a conversão utilize também uma variável para indicar o estado
#      da conversão, por exemplo, definimos a variável ok:
#      .data
#           ok: .space 4
#      Para realizar a conversão usamos o seguinte código
#           la      $a0, teste      # endereço da string
#           la      $a1, ok         # endereço da variável com o estado da conversão
#           jal converte_string_decimal
#           ---  no registrador $v0 temos o valor 123 e o valor da variável ok 
#                será 1, indicando que a conversão foi realizada sem problemas.
#                Se a conversão da string para um valor numérico não pode ser 
#                realizada, o valor desta variável será 0.
################################################################################
# prólogo do procedimento
# corpo do procedimento
            li      $t0, 10         # base decimal
            li      $v0, 0          # usamos para calcular o valor da número decimal 
            li      $t3, 0          # a conversão não foi realizada
converte_string_decimal_laco:
            # verificamos se existem dígitos (como caracteres) na string 
            lbu     $t1, 0($a0)     # carregamos um  caracter 
            beq     $t1, 0, converte_string_decimal_fim # se fim string, termina o procedimento.
            # se o caractere for diferende de '0' a '9', ocorre um erro
            bltu    $t1, '0', converte_string_decimal_erro
            bgtu    $t1, '9', converte_string_decimal_erro
            li      $t3, 1          # caractere está entre '0' e '9'
            mul     $t2, $v0, $t0   # multiplicamos pela base
            addiu   $t1, $t1, -48   # convertemos o caractere ascii para valor
            add     $v0, $t2, $t1   # adicionamos o valor do próximo dígito da string
            addiu   $a0, $a0, 1     # apontamos para o próximo caractere da string
            j       converte_string_decimal_laco
converte_string_decimal_erro:
            li      $v0, 0          # retornamos 0
            li      $t3, 0          # indicamos que houve erro na conversão
converte_string_decimal_fim:    
            sw      $t3, 0($a1)     # armazenamos o estado da conversão: 1 sucesso
# epílogo do procedimento
            jr      $ra             # retorna ao procedimento chamador
#-------------------------------------------------------------------------------