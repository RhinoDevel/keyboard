
; marcel timm, rhinodevel, 2020mar18 

; -----------------
; --- functions ---
; -----------------

; *** input:
; *** ------
; *** zero_word_buf$ = char column / pos. in line (0 - 24).
; *** y = char row / line nr. (0 - 39 or 0 - 79).
; ***
; *** output:
; *** -------
; *** x = high byte of screen mem. addr.
; *** a = low byte of screen mem. addr.
; *** y = 0
; ***
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

; ****************
; *** pos_draw ***
; ****************
; ***
; *** input:
; *** ------
; *** zero_word_buf$ = char column / pos. in line (0 - 39 or 0 - 79).
; *** a = screen mem. code char.  
; *** y = char row / line nr. (0 - 24).
; ***
pos_draw$ pha
          jsr get_mem_addr
          pla
          sta (zero_word_buf$),y
          rts
