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
