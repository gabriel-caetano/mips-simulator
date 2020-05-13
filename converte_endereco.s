# Converte um endereco de memoria para o endereco virtual
# $a0 <- endereco de memoria efetivo

converte_endereco:
.eqv ei_memoria_instrucoes 0x00400000   # endereço inicial da memória de instruções
.eqv ef_memoria_instrucoes 0x0040FFFF   # endereço final da memória de instruções
.eqv ei_memoria_dados      0x10010000   # endereço inicial da memória de dados
.eqv ef_memoria_dados      0x1001FFFF   # endereço final da memória de dados
.eqv ei_memoria_pilha      0x7FFF0000   # endereço inicial da memória da pilha
.eqv ef_memoria_pilha      0x7FFFFFFF   # endereço final da memória da pilha

			
			addiu   $sp, $sp, -8    # vamos armazenar 3 itens na pilha
            sw      $ra, 4($sp)
            sw      $a0, 0($sp)
# corpo do procedimento
            # armazenamos os argumentos nos registradores $s0 e $s1 porque chamaremos
            # um procedimento 
            move    $s0, $a0 # $s0 <- endereço de memória
	
converte_memoria_instrucoes:            
            #       $a0 já possui o endereço de memória
            li      $a1, ei_memoria_instrucoes
            li      $a2, ef_memoria_instrucoes
            jal     pertence_segmento_memoria # endereço pertence ao segmento de instruções?
            # se não pertence, verifica o segmento de dados
            beq     $v0, $zero, converte_memoria_dados
            li      $t0, ei_memoria_instrucoes
            sub     $t1, $s0, $t0 # $t1 -> índice associado ao endereço de memória
            # calculamos o endereço efetivo do índice na memoria_instrucoes
            # como o vetor da memória de instruções é organizada em bytes, o endereço efetivo
            # será: EF(i) = EB + i* tam, tam = 1, EF(i) = EB + i
            la      $t0, text_segment # $t0 -> endereço base da memoria de instruções
            addu    $v0, $t0, $t1		# guarda endereco virtual em $v0
            j		fim_converte
            
            
            
            
converte_memoria_dados:    
            move    $a0, $s0
            li      $a1, ei_memoria_dados
            li      $a2, ef_memoria_dados
            jal     pertence_segmento_memoria # endereço pertence ao segmento de dados?
            # se não pertence, verifica o segmento da pilha
            beq     $v0, $zero, converte_memoria_pilha
            li      $t0, ei_memoria_dados
            sub     $t1, $s0, $t0 # $t1 -> índice associado ao endereço de memória
            # calculamos o endereço efetivo do índice na memoria_dados
            # como o vetor da memória de dados é organizada em bytes, o endereço efetivo
            # será: EF(i) = EB + i* tam, tam = 1, EF(i) = EB + i
            la      $t0, data_segment # $t0 -> endereço base da memoria de dados
            addu    $v0, $t0, $t1 # $t2 -> endereço efetivo do elemento na memória de dados
            j		fim_converte
            
converte_memoria_pilha:    
            move    $a0, $s0
            li      $a1, ei_memoria_pilha
            li      $a2, ef_memoria_pilha
            jal     pertence_segmento_memoria # endereço pertence ao segmento da pilha?
            # se não pertence, temos um erro, o endereço não pertence a nenhum endereço
            beq     $v0, $zero, converte_memoria_mensagem_erro
            li      $t0, ei_memoria_pilha
            sub     $t1, $s0, $t0 # $t1 -> índice associado ao endereço da pilha
            # calculamos o endereço efetivo do índice na memoria_pilha
            # como o vetor da memória de dados é organizada em bytes, o endereço efetivo
            # será: EF(i) = EB + i* tam, tam = 1, EF(i) = EB + i
            la      $t0, stack_segment # $t0 -> endereço base da memoria da pilha
            addu    $t2, $t0, $t1 # $t2 -> endereço efetivo do elemento na memória da pilha
            j		fim_converte
            
converte_memoria_mensagem_erro:
            la      $a0, msg_erro_le_memoria
            li      $v0, 4
            syscall
            li      $v0, 0 # retornamos o valor 0
            
fim_converte:
			lw		$ra, 4($sp)
			addi	$sp, $sp, 8
			jr		$ra