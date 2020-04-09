
; marcel timm, rhinodevel, 2020mar18 

; --------------
; --- macros ---
; --------------

; *************************
; *** clear the screen. ***
; *************************
; ***
; *** output:
; *** -------
; *** a = garbage.
; ***
;
defm clrscr$
            lda #chr_clr$
            jsr chrout$
            endm

; -----------------
; --- functions ---
; -----------------

; *** input:
; *** ------
; *** y = char row / line nr. (0 - 24).
; *** zero_word_buf1$ = char column / pos. in line (0 - 39 or 0 - 79).
; ***
; *** output:
; *** -------
; *** a = low byte of screen mem. addr.
; *** x = high byte of screen mem. addr.
; *** y = 0.
; *** zero_word_buf1$ = screen mem. addr.
; ***
;
get_mem_addr$
         ; init. to screen ram start addr.:
         ;
         lda #<screen_ram$
         ldx #>screen_ram$

         ; calculate address:
         ;
@loop    cpy #0
         beq @add_col
         dey
         clc
         adc #line_len$
         bcc @loop
         inx
         bcs @loop ; (always loops)
@add_col clc
         adc zero_word_buf1$
         bcc @copy
         inx

         ; copy addr. to output buffer:
         ;
@copy    sta zero_word_buf1$
         stx zero_word_buf1$ + 1
         rts

; ***
; *** input:
; *** ------
; *** y = char row / line nr. (0 - 24).
; *** zero_word_buf1$ = char column / pos. in line (0 - 39 or 0 - 79).  
; ***
; *** output:
; *** -------
; *** x = high byte of screen mem. addr.
; *** y = 0
; *** zero_word_buf1$ = screen mem. addr.
; ***
;
rev_on$  pha
         jsr get_mem_addr$
         lda (zero_word_buf1$),y
         ora #%10000000 ; sets reverse bit of screen code.
         sta (zero_word_buf1$),y
         pla
         rts

; ***
; *** input:
; *** ------
; *** y = char row / line nr. (0 - 24).
; *** zero_word_buf1$ = char column / pos. in line (0 - 39 or 0 - 79).  
; ***
; *** output:
; *** -------
; *** x = high byte of screen mem. addr.
; *** y = 0
; *** zero_word_buf1$ = screen mem. addr.
; ***
;
rev_off$ pha
         jsr get_mem_addr$
         lda (zero_word_buf1$),y
         and #%01111111 ; disables reverse bit of screen code.
         sta (zero_word_buf1$),y
         pla
         rts

; ****************
; *** pos_draw ***
; ****************
; ***
; *** input:
; *** ------
; *** a = screen mem. code char.  
; *** y = char row / line nr. (0 - 24).
; *** zero_word_buf1$ = char column / pos. in line (0 - 39 or 0 - 79).
; ***
; *** output:
; *** -------
; *** x = high byte of screen mem. addr.
; *** y = 0
; *** zero_word_buf1$ = screen mem. addr.
; ***
;
pos_draw$
         pha
         jsr get_mem_addr$
         pla
         sta (zero_word_buf1$),y ; (y is 0)
         rts

; ***
;
conv_hd  and #$0f ; ignore left 4 bits.
         cmp #$0a
         bcc @digit
         sec ; more or equal $0a - a to f.
         sbc #$0a
         clc
         adc #'a' 
         rts
@digit   ;clc ; less than $0a - 0 to 9
         adc #'0'
         rts

; ******************************************************
; *** print byte in accumulator as hexadecimal value ***
; ******************************************************
;
printby$ pha
         lsr a
         lsr a
         lsr a
         lsr a
         jsr conv_hd
         jsr pos_draw$
         pla
         jsr conv_hd
         inc zero_word_buf1$     ; hard-coded, does not support line break.
         sta (zero_word_buf1$),y ; (y is 0).
         rts
