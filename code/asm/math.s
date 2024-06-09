

add:
    pha
    clc
    lda math1
    adc math2
    sta math3
    lda math1+1
    adc math2+1
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
    sbc math2+1
    sta math3+1
    clc
    pla
    rts

convert_bcd:

    cld
    ; clear the bcd
    stz bcd
    stz bcd+1
    stz bcd+2
    ldy #16

@loop:

    ldx #2   
    clc
@dabble:

    lda bcd,x
    and #$0f ; mask bottom bits
    cmp #5 ; compare bottom bits to 5
    bmi :+ ; if it is not 5 or greater
    clc
    lda bcd,x
    adc #3
    sta bcd,x
:
    cpx #2 ; since there can only be 5 digits, skip computing the 6th
    beq :+
    lda bcd,x
    cmp #$50 ; compare the top bits to 5
    bmi :+ ; if it is not 5 or greater
    clc
    adc #$30 
    sta bcd,x
    
:
    dex
    bpl @dabble

@double:
        
    asl math3
    rol math3+1
    rol bcd
    rol bcd+1
    rol bcd+2
    dey
    bne @loop

    rts

