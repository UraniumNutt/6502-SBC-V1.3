

.segment "CODE"                                          

    .include "macros.s"
    .include "VIA.s"
    .include "ACIA.s"
    .include "math.s"
    .include "IO.s"
    
    
    .feature string_escapes 

ptr = $0000
math1 = $0002
math2 = math1 + 2
math3 = math2 + 2
bcd = math3 + 2
stringbuffer = $300
 ; 0000 0110 0101 0101 0011 0110
reset:     
     
    ldx #$ff                             ; set up the stack
    txs         
    sei     
    jsr ACIAInit                         ; init the UART
    lda #%11110111                       ; set the VIA pins to output, except for bit3, which is for miso
    sta DDRA     
    
    jsr ACIAByteIn
    lda #$d3
    sta math1
    lda #$1e
    sta math1+1
    ldptr math1, ptr
main:
    jsr convert_bcd
    jsr bcd_to_string
    ldptr stringbuffer, ptr
    jsr print_string
done:
    bra done
message:
    .asciiz "Hello, World! This is so based"

    nmi:
exitnmi:
    rti
     
irq:
exitirq:

    rti

.segment "VECTORS"

    .word nmi
    .word reset
    .word irq
