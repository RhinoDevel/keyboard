
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

@test    jsr chrin$
         beq @test
         jsr chrout$
         jmp @test

@go      ldy #0 ; char row / line nr. (0 - 24).
         
@loopy   ldx #0 ; char column / pos. in line (0 - 39 or 0 - 79).
         
@loopx   tya
         pha
         txa
         pha

         stx zero_word_buf$
@scrmem  lda #$4d ; screen mem. code char.
         jsr pos_draw$

         pla
         tax
         pla
         tay

         inx
         cpx #line_len$
         bne @loopx
         
         iny
         cpy #25
         bne @loopy

         lda @scrmem + 1
         cmp #$4d
         bne @b
         lda #$4e
         jmp @c
@b       lda #$4d
@c       sta @scrmem + 1
         jmp @go

;@halt    jmp @halt
