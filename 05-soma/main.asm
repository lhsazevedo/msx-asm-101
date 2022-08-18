.MEMORYMAP
DEFAULTSLOT 0
SLOT 0 $4000 $0400
.ENDME

.ROMBANKSIZE $400
.ROMBANKS 1

.INCLUDE "../include/msx.asm"

.DEFINE BCD_SIZE 4

; Variáveis
.ENUM $c000
    num1: dsb BCD_SIZE
    num2: dsb BCD_SIZE
.ENDE

.db "AB"     ; ID for auto-executable ROM
.dw init     ; Main program execution address.
.dw 0        ; STATEMENT
.dw 0        ; DEVICE
.dw 0        ; TEXT
.dw 0,0,0    ; Reserved

init:
    ; Inicializa o video
    ld a, 32
    ld (LINL32), a ; 32 columns
    call INIT32    ; SCREEN 1

main:
    ld hl, pergunta1
    call puts

    call INLIN
    inc hl
    ex de, hl
    ld hl, num1
    call atobcd

    ld hl, pergunta2
    call puts

    call INLIN
    inc hl
    ex de, hl
    ld hl, num2
    call atobcd

    ld hl, num1
    ld de, num2

    call sumbcd

    ld hl, result
    call puts

    ld hl, num1
    call printbcd

    jr main

puts:
    ld a, (hl)
    or a
    ret z
    call CHPUT
    inc hl
    jr puts

; @param de pointer to input string
; @paran hl pointer to result
atobcd:
    push hl
    ld b, 0

    -:
        ld a, (de)
        or a
        jr z, +
        inc de
        inc b
    jr -

+:
    ; ld a, b
    ; srl a
    ; adc a, 0
    ; ld b, a

    push bc

    dec de
    -:
        ; Low nibble
        ld a, (de)
        sub '0'
        ld c, a
        dec de
        dec b

        ; High nibble
        jr z, +
            ld a, (de)
            sub '0'
            sla a
            sla a
            sla a
            sla a
            or c
            dec b
        +:

        ld (hl), a
        inc hl
        dec de
        ld a, b
        or a
    jr nz, -

    ; Maybe read and clear destination at the same time?

    ; Pushed from BC
    pop af

    bit 0, a
    jr z, +
        add $01
    +:
    srl a
    sub BCD_SIZE
    -:
        ld (hl), $00
        inc hl
        inc a
    jr nz, -

    pop hl

    ret

; Sum hl with de and store the result in hl
;
; @param hl Pointer to first BCD and result
; @param de Pointer to second BCD
sumbcd:
    ; Clear carry flag
    or a

    ld b, BCD_SIZE
    -:
        ld a, (de)
        adc a, (hl)
        daa
        ld (hl), a
        inc hl
        inc de
    djnz -
    

    ret

; @param hl Pointer to BCD
printbcd:
    ld b, 0
    ld c, 3
    add hl, bc

    ld b, BCD_SIZE
    sla b

    ; Skip leading zeroes
    -:
        ld a, (hl)
        and $f0
        jr nz, +

        dec b
        ld a, (hl)
        or a
        jr nz, +

        ld a, b
        cp $01
        jr z, +

        dec hl
    djnz -
    +:

    ; Print digits
    -:
        ld a, (hl)

        bit 0, b
        jr nz, +
            srl a
            srl a
            srl a
            srl a
            jr ++
        +:
            and 0x0f
            dec hl
        ++:

        add a, '0'
        call CHPUT
    djnz -

    ret

pergunta1:
.db "Digite um numero: \0"

pergunta2:
.db "Digite outro: \0"

result:
.db "Resultado: \0"
