
; marcel timm, rhinodevel, 2020mar21

; - needs pointers keyposx$ and keyposy$.
; - calls pos_draw$() and uses zero_word_buf1$.

; --------------
; --- macros ---
; --------------

; *** draw all keys at their designated positions on screen.
; ***
; *** input:
; *** ------
; *** (none)
; ***
; *** output:
; *** -------
; *** a = garbage.
; *** x = garbage.
; *** y = garbage.
; *** zero_word_buf1$ =  garbage.
; ***
;
defm keydraw$
         ldx #0
@loop    txa ; copy index to y register for indirect addressing.
         tay ;
         lda (keyposx$),y
         cmp #$ff
         beq @next
         sta zero_word_buf1$
         lda (keyposy$),y
         tay
         txa
         jsr pos_draw$ ; (keeps content of a)
         tax ; restore index to x.
@next    inx
         cpx #64 ; hard-coded (for screen codes 0 - 63)!
         bne @loop
         endm 

; -----------------
; --- functions ---
; -----------------

; ***
;
keydrawstat$ ; hard-coded
         ldy #0 ; y stores index in keystat$ byte array.
@line    lda (zero_word_buf2$),y ; loads line nr.
         tax
         iny
         lda (zero_word_buf2$),y ; loads start position in line.
         iny
         sta zero_word_buf1$
         tya ; saves array index.
         pha
         txa
         tay
         jsr get_mem_addr$ ; puts start address into zero_word_buf1$.
         pla ; restores array index.
         tay
         lda (zero_word_buf2$),y ; loads char count into x.
         tax
         iny

@next    txa ; saves char counter.
         pha
         tya
         pha         
         lda (zero_word_buf2$),y ; loads current screen code.
         ldy #0
         sta (zero_word_buf1$),y ; write current char to screen.
         pla
         tay
         iny ; (for current screen code load, above)
         bne @incscr
         inc zero_word_buf2$ + 1
@incscr  inc zero_word_buf1$ ; increment screen address.
         bne @x_resto
         inc zero_word_buf1$ + 1
@x_resto pla ; restore char counter.
         tax
         dex
         bne @next

         lda (zero_word_buf2$),y ; tries to load next line data.
         ; (don't increment y)
         cmp #$ff ; hard-coded
         bne @line ; fills next line.       
         rts
