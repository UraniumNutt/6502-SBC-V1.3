ACIA_base_address = $7e00
ACIADATA    = ACIA_base_address
ACIASTATUS  = ACIA_base_address + 1
ACIACOMMAND = ACIA_base_address + 2
ACIACONTROL = ACIA_base_address + 3

ACIAInit:
    LDA #%00001011                  ; init the 6551
    STA ACIACOMMAND
    LDA #%00000000
    STA ACIACONTROL
    RTS

ACIAWaitRx:                          ; polls until byte has be recived, then returns

    lda ACIASTATUS
    and #%00001000                  ; reciver full bit 
    beq ACIAWaitRx                  ; if not full, loop
    rts

ACIAWaitTx:                          ; polls until byte has been trasmited, then returns

    lda ACIASTATUS
    and #%00010000                  ; transmit empty bit
    beq ACIAWaitTx                  ; if not empty, loop
    rts

ACIAByteIn:                          ; takes in one byte from the ACIA

    jsr ACIAWaitRx                  ; wait until there is a byte ready
    lda ACIADATA                    ; reads the byte
    rts

ACIAByteOut:                         ; sends one byte from the ACIA

    pha                             ; save a
    jsr ACIAWaitTx                  ; wait until acia ready to transmit 
    pla                             ; restores a
    sta ACIADATA                    ; sends a out
    rts



