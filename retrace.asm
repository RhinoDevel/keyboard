
; rhinodevel, marcel timm, 2020sep25

; --------------
; --- macros ---
; --------------

; ****************************
; *** wait for retrace irq ***
; ****************************

defm wait_for_retrace$
@wait_ri lda via_b$
         and #$20 ; bit 5 is retrace-in.
         beq @wait_ri ; wait for bit 5 being 1.
         endm

; *******************************
; *** wait for no retrace irq ***
; *******************************

defm wait_for_no_retrace$
@waitnri lda via_b$
         and #$20 ; bit 5 is retrace-in.
         bne @waitnri ; wait for bit 5 being 0.
         endm
