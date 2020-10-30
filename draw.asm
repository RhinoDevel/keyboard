
; marcel timm, rhinodevel, 2020mar18 

; --------------
; --- macros ---
; --------------

; *************************
; *** clear the screen. ***
; *************************
; ***
; *** don't use this, if interrupt service routine is disabled (etc.).
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

; *************************
; *** clear the screen. ***
; *************************
; ***
; *** to be used, if interrupt service routine is already disabled.
; ***
;
clrscr_own$
         lda #<screen_ram$
         sta zero_word_buf1$
         lda #>screen_ram$
         sta zero_word_buf1$ + 1

         lda #chr_spc$
         
         ; ok, because screen ram starts at $??00 (in fact always at $8000):
         ;
         ldx #8 ; ok (because of mirroring in 40 column machines),
                ; but overdone, if 40 column machine.
@nextx   ldy #0
@nexty   sta (zero_word_buf1$),y ; from $??00 to $??ff.
         iny
         bne @nexty
         inc zero_word_buf1$ + 1 ; increment high byte.
         dex
         bne @nextx

         rts

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
get_mem_addr_loop   
         cpy #0
         beq get_mem_addr_add_col
         dey
         clc
linelen$ adc #0 ; value to-be-set in-place during initialization!
         bcc get_mem_addr_loop
         inx
         bcs get_mem_addr_loop ; (always loops)
get_mem_addr_add_col
         clc
         adc zero_word_buf1$
         bcc @copy
         inx

         ; copy addr. to output buffer:
         ;
@copy    sta zero_word_buf1$
         stx zero_word_buf1$ + 1
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
