################################################################################
escreve_memoria:
# 
# Este procedimento escreve um dado na memoria, se o endereço estiver em um
# dos 3 segmentos definidos no simulador. Se o endereço não estiver em um dos
# endereços, apresenta uma mensagem de erro no terminal do simulador.
#
# observação: A escrita de uma palavra (sw) de um endereço requer 4 chamadas a 
# este procedimento, usando endereço, endereço + 1, endereço + 2 e endereco + 3, 
# pois cada chamada escreve apenas um byte. Use o formato litte endian, escrevendo
# o byte menos significativo (mais a direita) para o byte mais significativo 
# (mais a esquerda) da palavra.
#
#
# Argumentos:
#   $a0: endereço de memória
#   $a1: dado para escrever na memória (1 byte)
# 
# Mapa da pilha:
#   $sp + 8: $ra - este procedimento chama outro procedimento.
#   $sp + 4: $s1 - usamos estes registradores e estes devem ser salvos
#   $sp + 0: $s0 -
#
# Uso:
# Ex.: desejamos escrever o byte 0x55 no endereço 0x10010000
#           li      $a0, 0x10010000
#           li      $a1, 0x55
#           jal     escreve_memoria
#           --      no endereço 0x1001000 (segmento de dados) está armazenado o 
#                   valor 0x55
#
################################################################################
.eqv ei_memoria_instrucoes 0x00400000   # endereço inicial da memória de instruções
.eqv ef_memoria_instrucoes 0x0040FFFF   # endereço final da memória de instruções
.eqv ei_memoria_dados      0x10010000   # endereço inicial da memória de dados
.eqv ef_memoria_dados      0x1001FFFF   # endereço final da memória de dados
.eqv ei_memoria_pilha      0x7FFF0000   # endereço inicial da memória da pilha
.eqv ef_memoria_pilha      0x7FFFFFFF   # endereço final da memória da pilha
# prólogo do procedimento
            addiu   $sp, $sp, -12    # vamos armazenar 3 itens na pilha
            sw      $ra, 8($sp)
            sw      $s1, 4($sp)
            sw      $s0, 0($sp)
# corpo do procedimento
            # armazenamos os arrgumentos nos registradores $s0 e $s1 porque chamaremos
            # um procedimento 
            move    $s0, $a0 # $s0 <- endereço de memória
            move    $s1, $a1 # $s1 <- dado para escrita no endereço de memoria
            # verificamos se o endereço pertence ao segmento de instruções
escreve_memoria_instrucoes:            
            #       $a0 já possui o endereço de memória
            li      $a1, ei_memoria_instrucoes
            li      $a2, ef_memoria_instrucoes
            jal     pertence_segmento_memoria # endereço pertence ao segmento de instruções?
            # se não pertence, verifica o segmento de dados
            beq     $v0, $zero, escreve_memoria_dados
            # se pertence, escreve na variável memoria_instrucoes
            # verificamos o índice: indice = endereco - endereco_inicial
            li      $t0, ei_memoria_instrucoes
            sub     $t1, $s0, $t0 # $t1 -> índice associado ao endereço de memória
            # calculamos o endereço efetivo do índice na memoria_instrucoes
            # como o vetor da memória de instruções é organizada em bytes, o endereço efetivo
            # será: EF(i) = EB + i* tam, tam = 1, EF(i) = EB + i
            la      $t0, text_segment # $t0 -> endereço base da memoria de instruções
            addu    $t2, $t0, $t1 # $t2 -> endereço efetivo do elemento na memória de instruções
            sb      $s1, 0($t2) # escreve na variável memoria_instrucoes
            j       epilogo_escreve_memoria # termina o procedimento
escreve_memoria_dados:   
            move    $a0, $s0 # endereço de memória
            li      $a1, ei_memoria_dados
            li      $a2, ef_memoria_dados
            jal     pertence_segmento_memoria # endereço pertence ao segmento de dados?
            # se não pertence, verifica o segmento da pilha
            beq     $v0, $zero, escreve_memoria_pilha            
            # se pertence, escreve na variável memoria_dados
            # verificamos o índice: indice = endereco - endereco_inicial
            li      $t0, ei_memoria_dados
            sub     $t1, $s0, $t0 # $t1 -> índice associado ao endereço de memória
            # calculamos o endereço efetivo do índice na memoria_dados
            # como o vetor da memória de dados é organizada em bytes, o endereço efetivo
            # será: EF(i) = EB + i* tam, tam = 1, EF(i) = EB + i
            la      $t0, data_segment # $t0 -> endereço base da memoria de dados
            addu    $t2, $t0, $t1 # $t2 -> endereço efetivo do elemento na memória de dados
            sb      $s1, 0($t2) # escreve na variável memoria_dados
            j       epilogo_escreve_memoria # termina o procedimento            
escreve_memoria_pilha:    
            move    $a0, $s0
            li      $a1, ei_memoria_pilha
            li      $a2, ef_memoria_pilha
            jal     pertence_segmento_memoria # endereço pertence ao segmento da pilha?
            # se não pertence, temos um erro, o endereço não pertence a nenhum endereço
            beq     $v0, $zero, escreve_mensagem_erro           
            # se pertence, escreve na variável memoria_pilha
            # verificamos o índice: indice = endereco - endereco_inicial
            li      $t0, ei_memoria_pilha
            sub     $t1, $s0, $t0 # $t1 -> índice associado ao endereço da pilha
            # calculamos o endereço efetivo do índice na memoria_pilha
            # como o vetor da memória de dados é organizada em bytes, o endereço efetivo
            # será: EF(i) = EB + i* tam, tam = 1, EF(i) = EB + i
            la      $t0, stack_segment # $t0 -> endereço base da memoria da pilha
            addu    $t2, $t0, $t1 # $t2 -> endereço efetivo do elemento na memória da pilha
            sb      $s1, 0($t2) # escreve na variável memoria_pilha
            j       epilogo_escreve_memoria # termina o procedimento            
escreve_mensagem_erro:
            la      $a0, msg_erro_escreve_memoria
            li      $v0, 4
            syscall
epilogo_escreve_memoria:
# epílogo do procedimento
            # restauramos os valores originais dos registradores
            lw      $s0, 0($sp)
            lw      $s1, 4($sp)
            lw      $ra, 8($sp)
            # restauramos a pilha
            addiu   $sp, $sp, 12
            jr      $ra             # retorna ao procedimento chamador
#-------------------------------------------------------------------------------
