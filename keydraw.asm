
; marcel timm, rhinodevel, 2020mar21

; - needs tables keyposx$ and keyposy$.
; - calls pos_draw$() and uses zero_word_buf$.

; --------------
; --- macros ---
; --------------

defm keydraw$
         ldx #0
@loop    lda keyposx$,x
         cmp #$ff
         beq @next
         sta zero_word_buf$
         ldy keyposy$,x
         txa
         jsr pos_draw$
         tax
@next    inx
         cpx #64 ; TODO: hard-coded (for screen codes 0 - 63)!
         bne @loop
         endm 
