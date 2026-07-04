; Printa um char
PUTC    MACRO   char
        PUSH    AX
        MOV     AL, char
        MOV     AH, 0Eh
        INT     10h     
        POP     AX
ENDM

IMPRIME_STRING MACRO msg
        PUSH DX
        PUSH AX
        mov dx, offset msg
        mov ah, 9
        int 21h
        POP AX
        POP DX
ENDM

PULA_LINHA MACRO
        putc 0Dh
        putc 0Ah
ENDM

org 100h

IMPRIME_STRING msg_a
CALL scan_num
MOV AX, CX

PULA_LINHA

IMPRIME_STRING msg_b
CALL scan_num
MOV BX, CX

PULA_LINHA

IMPRIME_STRING msg_c
CALL scan_num

PULA_LINHA

; Validacao: A, B e C devem ser positivos (maiores que zero)
CMP AX, 0
JLE invalido_positivo
CMP BX, 0
JLE invalido_positivo
CMP CX, 0
JLE invalido_positivo
JMP positivo_ok

invalido_positivo:
    IMPRIME_STRING msg_inv_positivo
    ret

positivo_ok:

CALL EH_PITAGORICO
CMP DX, 2
JE print_overflow
CMP DX, 1
JNE print_nao
IMPRIME_STRING msg_pitagorico
jmp fim

print_nao:
    IMPRIME_STRING msg_nao_pitagorico
    JMP fim

print_overflow:
    IMPRIME_STRING msg_overflow
    JMP fim

fim:
    ret

msg_inv_positivo db "Invalido! Os numeros devem ser positivos. $"
msg_a    db "A: $"
msg_b    db "B: $"
msg_c    db "C: $"
msg_overflow db "Deu overflow! $"
msg_pitagorico db "Os numeros formam um Trio Pitagorico $"
msg_nao_pitagorico db "Os numeros nao formam um Trio Pitagorico $"

; Usa AX, BX e CX para os catetos e a hipotenusa; retorna em DX
EH_PITAGORICO PROC
MUL AX
JO overflow
PUSH AX

MOV AX, BX
MUL AX
JO overflow
PUSH AX

MOV AX, CX
MUL AX
JO overflow
PUSH AX

POP CX
POP BX
POP AX

ADD AX, BX
JC overflow ; Testa a flag CF
CMP AX, CX
JNE nao_pitagorico
MOV DX, 1
ret 
EH_PITAGORICO ENDP


overflow:
        MOV DX, 2
        ret

nao_pitagorico:
    MOV DX, 0
    ret

; Procedimentos do arquivo emu8086.inc

; Proc para scanear valor da tela
SCAN_NUM        PROC    NEAR
        PUSH    DX
        PUSH    AX
        PUSH    SI
        
        MOV     CX, 0

        ; reset flag:
        MOV     CS:make_minus, 0

next_digit:

        ; get char from keyboard
        ; into AL:
        MOV     AH, 00h
        INT     16h
        ; and print it:
        MOV     AH, 0Eh
        INT     10h

        ; check for MINUS:
        CMP     AL, '-'
        JE      set_minus

        ; check for ENTER key:
        CMP     AL, 0Dh  ; carriage return?
        JNE     not_cr
        JMP     stop_input
not_cr:


        CMP     AL, 8                   ; 'BACKSPACE' pressed?
        JNE     backspace_checked
        MOV     DX, 0                   ; remove last digit by
        MOV     AX, CX                  ; division:
        DIV     CS:ten                  ; AX = DX:AX / 10 (DX-rem).
        MOV     CX, AX
        PUTC    ' '                     ; clear position.
        PUTC    8                       ; backspace again.
        JMP     next_digit
backspace_checked:


        ; allow only digits:
        CMP     AL, '0'
        JAE     ok_AE_0
        JMP     remove_not_digit
ok_AE_0:        
        CMP     AL, '9'
        JBE     ok_digit
remove_not_digit:       
        PUTC    8       ; backspace.
        PUTC    ' '     ; clear last entered not digit.
        PUTC    8       ; backspace again.        
        JMP     next_digit ; wait for next input.       
ok_digit:


        ; multiply CX by 10 (first time the result is zero)
        PUSH    AX
        MOV     AX, CX
        MUL     CS:ten                  ; DX:AX = AX*10
        MOV     CX, AX
        POP     AX

        ; check if the number is too big
        ; (result should be 16 bits)
        CMP     DX, 0
        JNE     too_big

        ; convert from ASCII code:
        SUB     AL, 30h

        ; add AL to CX:
        MOV     AH, 0
        MOV     DX, CX      ; backup, in case the result will be too big.
        ADD     CX, AX
        JC      too_big2    ; jump if the number is too big.

        JMP     next_digit

set_minus:
        MOV     CS:make_minus, 1
        JMP     next_digit

too_big2:
        MOV     CX, DX      ; restore the backuped value before add.
        MOV     DX, 0       ; DX was zero before backup!
too_big:
        MOV     AX, CX
        DIV     CS:ten  ; reverse last DX:AX = AX*10, make AX = DX:AX / 10
        MOV     CX, AX
        PUTC    8       ; backspace.
        PUTC    ' '     ; clear last entered digit.
        PUTC    8       ; backspace again.        
        JMP     next_digit ; wait for Enter/Backspace.
        
        
stop_input:
        ; check flag:
        CMP     CS:make_minus, 0
        JE      not_minus
        NEG     CX
not_minus:

        POP     SI
        POP     AX
        POP     DX
        RET
make_minus      DB      ?       ; used as a flag.
SCAN_NUM        ENDP

; Proc para 'printar' na tela
PRINT_NUM       PROC    NEAR
        PUSH    DX
        PUSH    AX

        CMP     AX, 0
        JNZ     not_zero

        PUTC    '0'
        JMP     printed

not_zero:
        ; the check SIGN of AX,
        ; make absolute if it's negative:
        CMP     AX, 0
        JNS     positive
        NEG     AX

        PUTC    '-'

positive:
        CALL    PRINT_NUM_UNS
printed:
        POP     AX
        POP     DX
        RET
PRINT_NUM       ENDP

; Printa vários números de AX
PRINT_NUM_UNS   PROC    NEAR
        PUSH    AX
        PUSH    BX
        PUSH    CX
        PUSH    DX

        ; flag to prevent printing zeros before number:
        MOV     CX, 1

        ; (result of "/ 10000" is always less or equal to 9).
        MOV     BX, 10000       ; 2710h - divider.

        ; AX is zero?
        CMP     AX, 0
        JZ      print_zero

begin_print:

        ; check divider (if zero go to end_print):
        CMP     BX,0
        JZ      end_print

        ; avoid printing zeros before number:
        CMP     CX, 0
        JE      calc
        ; if AX<BX then result of DIV will be zero:
        CMP     AX, BX
        JB      skip
calc:
        MOV     CX, 0   ; set flag.

        MOV     DX, 0
        DIV     BX      ; AX = DX:AX / BX   (DX=remainder).

        ; print last digit
        ; AH is always ZERO, so it's ignored
        ADD     AL, 30h    ; convert to ASCII code.
        PUTC    AL


        MOV     AX, DX  ; get remainder from last div.

skip:
        ; calculate BX=BX/10
        PUSH    AX
        MOV     DX, 0
        MOV     AX, BX
        DIV     CS:ten  ; AX = DX:AX / 10   (DX=remainder).
        MOV     BX, AX
        POP     AX

        JMP     begin_print
        
print_zero:
        PUTC    '0'
        
end_print:

        POP     DX
        POP     CX
        POP     BX
        POP     AX
        RET
PRINT_NUM_UNS   ENDP

ten             DW      10      ; used as multiplier/divider by SCAN_NUM & PRINT_NUM_UNS.