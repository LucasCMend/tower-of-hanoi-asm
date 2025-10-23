section .data
    
    msg_introducao1     db "Algoritmo de Torre de Hanoi com ", 0
    msg_introducao2     db " discos", 10, 0
    msg_mover_disco     db "Mova o disco ", 0
    msg_da_torre        db " da torre ", 0
    msg_para_torre      db " para a torre ", 0
    msg_concluido       db "Concluido!", 10, 0
    quebra_linha     db 10

section .bss
    
    entrada_usuario   resb 16     ; Para ler a entrada do usuário 
    num_temp resb 20     ; Para converter números para texto antes de imprimir
    numero_de_discos    resq 1      ; Para guardar o número de discos 

section .text
    global _start ;

; Função para imprimir um texto (string terminada com nulo) 
; Entrada: RDI = endereço do texto
adicionar_string:
    push    rdi
    mov     rdx, 0
.tamanhoString: ; loop para calcular tamanho da string
    cmp     byte [rdi + rdx], 0
    je      .print_string
    inc     rdx
    jmp     .tamanhoString
.print_string: ; imprimir string
    mov     rax, 1              
    mov     rsi, rdi            
    mov     rdi, 1              
    syscall
    pop     rdi
    ret

; Função para imprimir um único caractere 
; Entrada: RDI = caractere a ser impresso
print_caractere:
    push    rdi
    mov     [num_temp], dil ; Usa a variavel como um espaço temporário
    mov     rax, 1                     
    mov     rdi, 1                     
    mov     rsi, num_temp
    mov     rdx, 1
    syscall
    pop     rdi
    ret
   
; Função para imprimir uma nova linha
print_quebra_linha:
    mov     rax, 1
    mov     rdi, 1
    mov     rsi, quebra_linha
    mov     rdx, 1
    syscall
    ret
   
; Função para converter um número inteiro para texto
; Entrada: RDI = inteiro a ser convertido
; Saída:   RSI = endereço do texto, RDX = tamanho do texto
int_para_string:
    mov     rcx, num_temp + 19     ; Aponta o registrador para o último byte
    mov     byte [rcx], 0          ; Adiciona o terminador nulo no final da variavel
    dec     rcx                    ; Decrementa o registrador, para passar por todos os bytes
    mov     rbx, 10                ; Dividir por 10
    mov     rax, rdi               
.loop_conversao_int:
    xor     rdx, rdx               
    div     rbx                    ; rax = rax / 10, rdx = rax % 10
    add     rdx, '0'               ; Converte o resto para seu caractere ASCII
    mov     [rcx], dl              ; Guarda o dígito na variavel
    dec     rcx
    test    rax, rax               ; Testa se o resultado é 0
    jnz     .loop_conversao_int    ; Se não for, continua o loop

    inc     rcx                    ; Aponta para o início do texto do número
    mov     rsi, rcx
    mov     rdx, num_temp + 20
    sub     rdx, rcx               ; Calcula o tamanho do texto
    ret

; Função para converter um texto (da entrada) para um inteiro
; Entrada: RSI = endereço do texto
; Saída:   RAX = valor inteiro
string_para_int:
    xor     rax, rax
.loop_conversao_string:
    movzx   rbx, byte [rsi]
    cmp     rbx, '0'
    jl      .fim_conversao_string     ; Se for menor que '0' termina
    cmp     rbx, '9'
    jg      .fim_conversao_string     ; Se for maior que '9' termina
   
    sub     rbx, '0'               ; Converte caractere ASCII para valor numérico
    imul    rax, 10                ; Multiplica o resultado atual por 10
    add     rax, rbx               ; Adiciona o novo dígito
   
    inc     rsi                    ; Próximo caractere
    jmp     .loop_conversao_string
.fim_conversao_string:
    ret

; A função recursiva de Torre de Hanoi 
; Argumentos: RDI=n (discos), RSI=torre_origem, RDX=torre_auxiliar, RCX=torre_destino
hanoi:
    ; Salva o estado da pilha
    push    rbp                     ; Salva o valor atual do registrador rbp no topo da pilha
    mov     rbp, rsp                ; Copia o valor atual do rsp para o rbp
    sub     rsp, 32                 ; Aloca 32 bytes na pilha para salvar os 4 argumentos
    mov     [rbp-8], rdi            ; Salva n (discos)
    mov     [rbp-16], rsi           ; Salva torre_origem
    mov     [rbp-24], rdx           ; Salva torre_auxiliar
    mov     [rbp-32], rcx           ; Salva torre_destino

    ; Caso Base: se (n == 0) então retorna (fim da recursão)
    cmp     rdi, 0
    je      .fim_hanoi

    ; Chamada Recursiva 1: hanoi(n-1, origem, destino, auxiliar)
    mov     rdi, [rbp-8]            ; n
    dec     rdi                     ; n-1
    mov     rsi, [rbp-16]           ; origem
    mov     rdx, [rbp-32]           ; destino
    mov     rcx, [rbp-24]           ; auxiliar
    call    hanoi

    ; Ação: Imprime a mensagem de movimento do disco
    mov     rdi, msg_mover_disco
    call    adicionar_string
   
    mov     rdi, [rbp-8]            ; n
    call    int_para_string      ; Converte n para texto
    mov     rax, 1                  ; Prepara para imprimir n
    mov     rdi, 1
    syscall                         ; Imprime n

    mov     rdi, msg_da_torre
    call    adicionar_string
   
    mov     rdi, [rbp-16]           ; origem
    call    print_caractere
   
    mov     rdi, msg_para_torre
    call    adicionar_string

    mov     rdi, [rbp-32]           ; destino
    call    print_caractere
   
    call    print_quebra_linha

    ; Chamada Recursiva 2: hanoi(n-1, auxiliar, origem, destino)
    mov     rdi, [rbp-8]            ; n
    dec     rdi                     ; n-1
    mov     rsi, [rbp-24]           ; auxiliar
    mov     rdx, [rbp-16]           ; origem
    mov     rcx, [rbp-32]           ; destino
    call    hanoi

.fim_hanoi:
    ; Restaura a pilha para o estado anterior
    add     rsp, 32                 ; Desaloca o espaço da pilha usado pela função
    pop     rbp
    ret

; Ponto de entrada principal do programa 
_start: 
    ; Lê o número de discos informado pelo usuário
    mov     rax, 0                  ; sys_read 
    mov     rdi, 0                  ; stdin
    mov     rsi, entrada_usuario
    mov     rdx, 16                 ; máximo de bytes para ler
    syscall

    ; Converte o texto de entrada para um número inteiro
    mov     rsi, entrada_usuario
    call    string_para_int
    mov     [numero_de_discos], rax ; Guarda o número na variável

    ; Imprime a mensagem inicial
    mov     rdi, msg_introducao1
    call    adicionar_string

    mov     rdi, [numero_de_discos]
    call    int_para_string
    mov     rax, 1
    mov     rdi, 1
    syscall

    mov     rdi, msg_introducao2
    call    adicionar_string

    ; Chama a função principal do algoritmo: hanoi(discos, 'A', 'B', 'C')
    mov     rdi, [numero_de_discos]
    mov     rsi, 'A'
    mov     rdx, 'B'
    mov     rcx, 'C'
    call    hanoi

    ; Imprime a mensagem final de conclusão
    mov     rdi, msg_concluido
    call    adicionar_string

    ; Finaliza o programa de forma limpa
    mov     rax, 60                 ; sys_exit 
    mov     rdi, 0                  ; código de saída 0 (sucesso)
    syscall