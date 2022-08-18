.MEMORYMAP
DEFAULTSLOT 0
SLOT 0 $4000 $0400
.ENDME

.ROMBANKSIZE $400
.ROMBANKS 1

.INCLUDE "../include/msx.asm"

; Variáveis
.ENUM $c000
    num1: dw
    num2: dw
.ENDE

.db "AB"     ; ID for auto-executable ROM
.dw main     ; Main program execution address.
.dw 0        ; STATEMENT
.dw 0        ; DEVICE
.dw 0        ; TEXT
.dw 0,0,0    ; Reserved

main:
    ; Inicializa o video
    ld a, 32
    ld (LINL32), a ; 32 columns
    call INIT32     ; SCREEN 1

    ld hl, pergunta1
    call puts

    call INLIN
    inc hl
    ex de, hl
    call atoi
    ld (num1), hl

    ld hl, pergunta2
    call puts

    call INLIN
    inc hl
    ex de, hl
    call atoi
    
    ld bc, (num1)

    add hl, bc

    ld (num2), hl

    ld a, l
    daa
    ld l, a

    ld a, h
    adc a, 0
    ld h, a

    ld a, h
    rrca
    rrca
    rrca
    rrca
    and 0x0f
    add a, '0'
    push hl
    call CHPUT
    pop hl

    ld a, h
    and 0x0f
    add a, '0'
    call CHPUT

    ld a, l
    rrca
    rrca
    rrca
    rrca
    and 0x0f
    add a, '0'
    push hl
    call CHPUT
    pop hl

    ld a, l
    and 0x0f
    add a, '0'
    call CHPUT

    ; ld a, (hl)
    ; sub '0'
    ; ld (num1), a

    ; ld hl, pergunta2
    ; call puts

    ; call INLIN
    ; inc hl
    ; ld a, (hl)
    ; sub '0'
    ; ld hl, num1
    ; add a, (hl)

    ; daa
    ; push af
    ; rrca
    ; rrca
    ; rrca
    ; rrca
    ; and 0x0f
    ; add a, '0'
    ; call CHPUT

    ; pop af
    ; and 0x0f
    ; add a, '0'
    ; call CHPUT

    di
    halt

puts:
    ld a, (hl)
    or a
    ret z
    call CHPUT
    inc hl
    jr puts

; DE: input string
; HL: result
atoi:
    ld hl, 0

    -:
        ld a, (de)
        or a
        ret z

        ld b, h
        ld c, l
        push de
        ld de, $0A
        call multiply
        pop de

        sub '0'
        ld b, 0
        ld c, a
        add hl, bc
        inc de
    jr -

; Multiply DE and BC, result in HL
multiply:
    push af

    ld a, 16
    ld hl, 0

    -:
        srl b
        rr c
        jr nc, +
            add hl, de
        +:

        ex de, hl
        add hl, hl
        ex de, hl
        
        dec a
    jr nz,-

    pop af
    ret


pergunta1:
.db "Digite um numero: \0"

pergunta2:
.db "Digite outro: \0"