
; marcel timm, rhinodevel, 2020mar21

; - needs tables keyposx$ and keyposy$.
; - calls pos_draw$() and uses zero_word_buf$.

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
; *** zero_word_buf$ =  garbage.
; ***
;
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

; ***
;
defm keydrawstat$ ; hard-coded
         ldx #0 ; x stores index in keystat$ byte array.
@line    ldy keystat$,x ; loads line nr.
         inx
         lda keystat$,x ; loads start position in line.
         inx
         sta zero_word_buf$
         txa ; saves array index.
         pha
         jsr get_mem_addr$ ; puts start address into zero_word_buf$.
         pla ; restores array index.
         tax
         ldy keystat$,x ; loads char count into y.
         inx

@next    tya ; saves char counter.
         pha         
         lda keystat$,x ; loads current screen code.
         inx
         ldy #0
         sta (zero_word_buf$),y ; write current char to screen.
         inc zero_word_buf$ ; increment screen address.
         bne @y_resto
         inc zero_word_buf$ + 1
@y_resto pla ; restore char counter.
         tay
         dey
         bne @next

         lda keystat$,x ; tries to load next line data.
         ; (don't increment x)
         cmp #$ff ; hard-coded
         bne @line ; fills next line.       
         endm
