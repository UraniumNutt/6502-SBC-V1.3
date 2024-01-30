.macro ldptr    data, ptr
		lda #<data
		sta ptr
		lda #>data
		sta ptr + 1
.endmacro

.macro save_stack 

    php
    pha
    phx
    phy

.endmacro

.macro restore_stack

    ply
    plx
    pla
    plp

.endmacro