.MEMORYMAP
DEFAULTSLOT 0
SLOT 0 $4000 $0400
.ENDME

.ROMBANKSIZE $400
.ROMBANKS 1

.INCLUDE "../include/msx.asm"

.db "AB"     ; ID for auto-executable ROM
.dw main     ; Main program execution address.
.dw 0        ; STATEMENT
.dw 0        ; DEVICE
.dw 0        ; TEXT
.dw 0,0,0    ; Reserved

pergunta:
.db "Digite seu nome: \0"

cumprimento:
.db "Muito prazer \0"

main:
    ; Inicializa o video
    ld a, 32
    ld (LINL32), a ; 32 columns
    call INIT32     ; SCREEN 1

    ld hl, pergunta
    call puts

    call INLIN
    ex de, hl

    ld hl, cumprimento
    call puts

    ex de, hl
    inc hl
    call puts

    di
    halt

puts:
    ld a, (hl)
    or a
    ret z
    call CHPUT
    inc hl
    jr puts
    