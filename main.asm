
; marcel timm, rhinodevel, 2020mar17

; --------------
; --- macros ---
; --------------

; ********************
; *** clear screen ***
; ********************
;
defm clrscr lda #chr_clr$
            jsr chrout$
            endm

; -----------------
; --- functions ---
; -----------------

; ************
; *** main ***
; ************

dec_addr1 = 1;main/1000
dec_addr2 = 0;(main/100) MOD $a
dec_addr3 = 3;(main/10) MOD $a
dec_addr4 = 7;main MOD $a

* = sob$

         word next
         word 7581
         byte $9e ; sys token
         byte chr_0$ + dec_addr1
         byte chr_0$ + dec_addr2
         byte chr_0$ + dec_addr3
         byte chr_0$ + dec_addr4
         byte 0
next     word 0

main     sei
         clrscr
         keydraw$
 
         lindraw$

         lda #%10100101
         sta pattern$
         jsr patdraw$

@go      ldx #0
@loop    lda keyposx$,x
         cmp #$ff
         beq @next
         jsr but_pre$
         bne @testoff
         ldy keyposx$,x
         sty zero_word_buf$
         ldy keyposy$,x
         txa
         pha
         jsr rev_on$
         pla
         tax
         jmp @next
@testoff ldy keyposx$,x
         sty zero_word_buf$
         ldy keyposy$,x
         txa
         pha
         jsr rev_off$
         pla
         tax
@next    inx
         cpx #64 ; TODO: hard-coded (for screen codes 0 - 63)!
         bne @loop
         jmp @go

;@halt    jmp @halt
