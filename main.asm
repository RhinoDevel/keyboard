
; marcel timm, rhinodevel, 2020mar17

; ---------------
; --- defines ---
; ---------------

dec_addr1 = 1;main/1000
dec_addr2 = 0;(main/100) MOD $a
dec_addr3 = 3;(main/10) MOD $a
dec_addr4 = 7;main MOD $a

; to be used with flags$ variable:
;
flag_pre_pat_h =     %00000001
flag_pre_pat_h_neg = %11111110 ; complement of flag_pre_pat_h.
flag_pre_pat_l =     %00000010
flag_pre_pat_l_neg = %11111101 ; complement of flag_pre_pat_l.

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
   
         lda #$00
         sta flags$       

         clrscr
         keydraw$
 
         patstaticdraw$

         lda #%00001111
         sta pattern$
         jsr patdraw$

@go      ldx #0
@loop    lda keyposx$,x
         cmp #$ff
         beq @next
         jsr but_pre$
         bne @testoff

         cpx #59 ; ';', hard-coded.
         bne @no_pat_h
         lda flags$
         and #flag_pre_pat_h
         bne @no_pat_h
         lda flags$
         ora #flag_pre_pat_h
         sta flags$
         lda pattern$
         clc
         adc #$10
         sta pattern$
@no_pat_h

         cpx #'?'
         bne @no_pat_l
         lda flags$
         and #flag_pre_pat_l
         bne @no_pat_l
         lda flags$
         ora #flag_pre_pat_l
         sta flags$
         lda pattern$
         and #$0f
         cmp #$0f
         bne @pat_l_add
         lda pattern$
         and #$f0
         sta pattern$
         jmp @no_pat_l
@pat_l_add
         inc pattern$
@no_pat_l

         ldy keyposx$,x
         sty zero_word_buf$
         ldy keyposy$,x
         txa
         pha
         jsr rev_on$
         pla
         tax
         jmp @next
@testoff 
         cpx #59 ; ';', hard-coded.
         bne @no_pat_h_2
         lda flags$
         and #flag_pre_pat_h_neg
         sta flags$
@no_pat_h_2 

         cpx #'?'
         bne @no_pat_l_2
         lda flags$
         and #flag_pre_pat_l_neg
         sta flags$
@no_pat_l_2

         ldy keyposx$,x
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
         jsr patdraw$
         jmp @go

;@halt    jmp @halt
