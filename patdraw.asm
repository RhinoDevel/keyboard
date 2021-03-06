
; marcel timm, rhinodevel, 2020mar22

; - calls pos_draw$() and uses pattern$.

; ---------------
; --- defines ---
; ---------------

row    = 6
column = 21

; --------------
; --- macros ---
; --------------

defm patstaticdraw$
         ; draw line under bit pattern:
         ;
         ldx #8
@loop    ldy #row + 1 ; char row / line nr. (0 - 24).
         pha
         txa
         pha
         txa ; char column / pos. in line offset.
         clc
         adc #column - 1; add pattern start column to offset.
         sta zero_word_buf1$
         lda #$77
         jsr pos_draw$
         pla
         tax
         pla
         dex
         bne @loop

         ; draw dollar sign (indicating hexadecimal number) below line:
         ;
         ldy #row + 2; char row / line nr. (0 - 24).
         lda #column
         sta zero_word_buf1$
         lda #'$'
         jsr pos_draw$
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
         adc #column - 1; add pattern start column to offset.
         sta zero_word_buf1$
         lda #chr_rev_spc$
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
         adc #column - 1 ; add pattern start column to offset.
         sta zero_word_buf1$
         lda #chr_spc$
         jsr pos_draw$
         pla
         tax
         pla

@next    dex
         bne @loop

         ; print as hexadecimal value:
         ;
         ldy #row + 2; char row / line nr. (0 - 24).
         lda #column + 1
         sta zero_word_buf1$
         lda pattern$
         jsr printby$

         rts
