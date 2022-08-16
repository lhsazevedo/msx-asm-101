.MEMORYMAP
DEFAULTSLOT 0
SLOT 0 $4000 $0400
.ENDME

.ROMBANKSIZE $400
.ROMBANKS 1

.INCLUDE "../include/msx.asm"

; Variáveis
.ENUM $c000
    num1: db
.ENDE

.db "AB"     ; ID for auto-executable ROM
.dw main     ; Main program execution address.
.dw 0        ; STATEMENT
.dw 0        ; DEVICE
.dw 0        ; TEXT
.dw 0,0,0    ; Reserved

pergunta1:
.db "Digite um numero: \0"

pergunta2:
.db "Digite outro: \0"

main:
    ; Inicializa o video
    ld a, 32
    ld (LINL32), a ; 32 columns
    call INIT32     ; SCREEN 1

    ld hl, pergunta1
    call puts

    call INLIN
    inc hl
    ld a, (hl)
    sub '0'
    ld (num1), a

    ld hl, pergunta2
    call puts

    call INLIN
    inc hl
    ld a, (hl)
    sub '0'
    ld hl, num1
    add a, (hl)

    add a, '0'

    call CHPUT

    di
    halt

puts:
    ld a, (hl)
    or a
    ret z
    call CHPUT
    inc hl
    jr puts
