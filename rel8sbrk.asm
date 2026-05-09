.data
prompt_numeros: .asciiz "Entre com uma quantidade de números."
numeros_vetor: .asciiz "Números não ordenados:"
vetor: .byte {}
.text
#------ n = int(input(Digite a quantidade de numeros))
la $a0, prompt_numeros
li $v0, 4
syscall

li $v0, 5
syscall
move $s0, $v0 #$s0 = n

#------ criando o array de númeross
mul $a0, $v0, 4
li $v0, 9 #sbrk($s0*4)
syscall
move $s1, $v0 #$s1 = endereço base do aray

li $t0, 0 #for i = 0
#primeiro for
input_valor:
beq $t0, $s0, sort

la $a0, numeros_vetor
li $v0, 4
syscall

li $v0, 5
syscall

mul $t1, $t0, 4 #offset de 4
add $t2, $s1, $t1 #endereço = base + offset
sw $v0, 0($t2)

addi $t0, $t0, 1 $i++
j input_valor

sort:
li $t0, 0
loop_exterior:
addi $t1, $s0, -1    # n - 1
    beq $t0, $t1, print_setup # se i == n-1, terminou
    
    li $t2, 0            # j = 0 (inner loop)
inner_loop:
    sub $t3, $t1, $t0    # n - 1 - i
    beq $t2, $t3, next_outer
    
    # Carregar nums[j] e nums[j+1]
    mul $t4, $t2, 4
    add $t4, $t4, $s1    # Endereço de nums[j]
    lw $t5, 0($t4)       # Valor nums[j]
    lw $t6, 4($t4)       # Valor nums[j+1]
    
    ble $t5, $t6, no_swap # se nums[j] <= nums[j+1], não troca
    
    # Swap
    sw $t6, 0($t4)
    sw $t5, 4($t4)

no_swap:
    addi $t2, $t2, 1     # j++
    j inner_loop

next_outer:
    addi $t0, $t0, 1     # i++
    j outer_loop

    # 5. Mostrar resultados
print_setup:
    la $a0, msg_ordenada
    li $v0, 4
    syscall
    li $t0, 0
print_loop:
    beq $t0, $s0, exit
    
    mul $t1, $t0, 4
    add $t1, $t1, $s1
    lw $a0, 0($t1)       # Carrega valor para imprimir
    li $v0, 1
    syscall
    
    la $a0, espaco
    li $v0, 4
    syscall
    
    addi $t0, $t0, 1
    j print_loop

exit:
    li $v0, 10
    syscall