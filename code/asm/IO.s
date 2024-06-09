

print_string:
    pha
    phy
    ldy #0
@loop:
    lda (ptr),y
    beq @exit
    jsr ACIAByteOut
    iny
    bra @loop
@exit:
    ply
    pla
    rts

input_string:                ; Allows the user to enter a string, loading it into the Stringptr
    ldy #$00                ; use y as an index
@loop:       
    jsr ACIAByteIn          ; get the byte from the user
    cmp #$7f                ; if they pressed backspace, jump to @backspace
    beq @backspace      
    cmp #$0d                ; if they pressed enter, jump to @enter
    beq @enter
    cpy #$ff                ; if y is 255, dont admit any more bytes,
    beq @loop       
    sta stringbuffer,y       ; otherwise, put the byte in the buffer
    jsr ACIAByteOut         ; print the byte so the user can see what they type
    iny                     ; and increment the y index
    jmp @loop               ; go back to the start of the loop
@backspace:                  ; if backspace was pressed @@@
    cpy #$00                ; if the index is 0, then no chars have been typed, so go back to the loop
    beq @loop           
    dey                     ; otherwise, decrement the index 
    lda #$08               ; move back one char
    jsr ACIAByteOut     
    lda #' '                ; write a space over the old char
    jsr ACIAByteOut     
    lda #$08               ; go back to the old chars position on the sceen
    jsr ACIAByteOut     
    jmp @loop               ; go back to the loop
@enter:                      ; if enter was pressed @@@
    lda #$0D              ; return the carriage to the begining of the line
    jsr ACIAByteOut
    lda #$0A               ; and go to the next line
    jsr ACIAByteOut
    lda #$00               ; make sure the string is null terminated
    sta stringbuffer,y
    rts

hex_digit_converter:

    clc
    and #$f                 ; mask out the upper nibble
    cmp #10                 ; if it is 10 or greater it is a .letter
    bmi @letter              
    adc #6                  ; add 6 to the nibble
@letter:
    adc #48                 ; if it is a letter, add 48          
    clc
    rts

bcd_to_string:
    save_stack
    ldy #0
    ldx #3
@loop:
    dex
    cpx #2 ; since there can only be 5 digits, dont generate the character for the 6th one
    beq :+
    lda bcd,x
    and #%11110000
    lsr
    lsr
    lsr
    lsr
    clc
    adc #'0'
    sta (ptr),y
    iny
:
    lda bcd,x
    and #%00001111
    clc
    adc #'0'
    sta (ptr),y
    iny
    cpx #0
    beq @end
    bra @loop
@end:
    lda #0
    sta (ptr),y

    restore_stack
    rts
