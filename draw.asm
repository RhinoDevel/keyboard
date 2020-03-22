
; marcel timm, rhinodevel, 2020mar18 

; -----------------
; --- functions ---
; -----------------

; *** input:
; *** ------
; *** y = char row / line nr. (0 - 39 or 0 - 79).
; *** zero_word_buf$ = char column / pos. in line (0 - 24).
; ***
; *** output:
; *** -------
; *** a = low byte of screen mem. addr.
; *** x = high byte of screen mem. addr.
; *** y = 0
; *** zero_word_buf$ = screen mem. addr.
; ***
;
get_mem_addr
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
         adc zero_word_buf$
         bcc @copy
         inx

         ; copy addr. to output buffer:
         ;
@copy    sta zero_word_buf$
         stx zero_word_buf$ + 1
         rts

; ***
; *** input:
; *** ------
; *** y = char row / line nr. (0 - 24).
; *** zero_word_buf$ = char column / pos. in line (0 - 39 or 0 - 79).  
; ***
; *** output:
; *** -------
; *** x = high byte of screen mem. addr.
; *** y = 0
; *** zero_word_buf$ = screen mem. addr.
; ***
;
rev_on$  pha
         jsr get_mem_addr
         lda (zero_word_buf$),y
         ora #%10000000 ; sets reverse bit of screen code.
         sta (zero_word_buf$),y
         pla
         rts

; ***
; *** input:
; *** ------
; *** y = char row / line nr. (0 - 24).
; *** zero_word_buf$ = char column / pos. in line (0 - 39 or 0 - 79).  
; ***
; *** output:
; *** -------
; *** x = high byte of screen mem. addr.
; *** y = 0
; *** zero_word_buf$ = screen mem. addr.
; ***
;
rev_off$ pha
         jsr get_mem_addr
         lda (zero_word_buf$),y
         and #%01111111 ; disables reverse bit of screen code.
         sta (zero_word_buf$),y
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
; *** zero_word_buf$ = char column / pos. in line (0 - 39 or 0 - 79).
; ***
; *** output:
; *** -------
; *** x = high byte of screen mem. addr.
; *** y = 0
; *** zero_word_buf$ = screen mem. addr.
; ***
;
pos_draw$ pha
          jsr get_mem_addr
          pla
          sta (zero_word_buf$),y ; (y is 0)
          rts
