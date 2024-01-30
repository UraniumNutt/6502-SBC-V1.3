

add:
    pha
    clc
    lda math1
    adc math2
    sta math3
    lda math1+1
    adc math3+1
    sta math3+1
    clc
    pla
    rts

sub:
    pha
    sec
    lda math1
    sbc math2
    sta math3
    lda math1+1
    sbc math3+1
    sta math3+1
    clc
    pla
    rts

convert_bcd:

    save_stack
    lda #0
    sta bcd
    sta bcd+1
    sta bcd+2
    ldx #16
@loop:
    clc
    ldy #0
    lda (ptr),y
    asl
    ldy #1
    lda (ptr),y
    asl
    lda bcd
    asl
    lda bcd+1
    asl
    lda bcd+2
    asl
    clc

    lda bcd
    and %00001111
    cmp #5
    bmi :+
    lda bcd
    adc #3
:
    lda bcd
    and %11110000
    cmp #5 << 4
    bmi :+
    lda bcd
    adc #3 << 4
:
    lda bcd+1
    and %00001111
    cmp #5
    bmi :+
    lda bcd+1
    adc #3
:
    lda bcd+1
    and %11110000
    cmp #5 << 4
    bmi :+
    lda bcd+1
    adc #3 << 4
:
    lda bcd+2
    and %00001111
    cmp #5
    bmi :+
    lda bcd+2
    adc #3
:
    lda bcd+2
    and %11110000
    cmp #5 << 4
    bmi :+
    lda bcd+2
    adc #3 << 4
:

    dex
    bne @loop

    restore_stack
    rts

