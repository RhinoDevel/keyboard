
; marcel timm, rhinodevel, 2020mar22

; - calls pos_draw$() and uses pattern$

; ---------------
; --- defines ---
; ---------------

row    = 6
column = 21

; --------------
; --- macros ---
; --------------

defm lindraw$
         ldx #8
@loop    ldy #row + 1 ; char row / line nr. (0 - 24).
         pha
         txa
         pha
         txa ; char column / pos. in line offset.
         clc
         adc #column ; add pattern start column to offset.
         sta zero_word_buf$
         lda #$77
         jsr pos_draw$
         pla
         tax
         pla
         dex
         bne @loop
         endm

; -----------------
; --- functions ---
; -----------------

patdraw$ ldx #8
         lda pattern$
@loop    ror a
         bcc @zero
         
         pha
         txa
         pha
         ldy #row ; char row / line nr. (0 - 24).
         txa ; char column / pos. in line offset.
         clc
         adc #column ; add pattern start column to offset.
         sta zero_word_buf$
         lda #%10100000 ; inverted space.
         jsr pos_draw$
         pla
         tax
         pla

         jmp @next

@zero    pha
         txa
         pha
         ldy #6 ; char row / line nr. (0 - 24).
         txa ; char column / pos. in line offset.
         clc
         adc #21 ; add pattern start column to offset.
         sta zero_word_buf$
         lda #%00100000 ; space.
         jsr pos_draw$
         pla
         tax
         pla

@next    dex
         bne @loop
         rts
