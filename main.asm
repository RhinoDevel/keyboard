
; marcel timm, rhinodevel, 2020mar17

; ---------------
; --- defines ---
; ---------------

dec_addr1 = 1;main/1000
dec_addr2 = 0;(main/100) MOD $a
dec_addr3 = 6;(main/10) MOD $a
dec_addr4 = 0;main MOD $a

; to be used with flags$ variable:
;
flag_pre_pat_h = 1
flag_pre_pat_h_neg = 255 - flag_pre_pat_h
flag_pre_pat_l = 2
flag_pre_pat_l_neg = 255 - flag_pre_pat_l
flag_pre_rec = 4
flag_pre_rec_neg = 255 - flag_pre_rec
;
flag_upd_pat = 8
flag_upd_pat_neg = 255 - flag_upd_pat
;
flag_upd_rec = 16
flag_upd_rec_neg = 255 - flag_upd_rec
;
flag_mode_rec = 32
flag_mode_rec_neg = 255 - flag_mode_rec

; ----------------------
; --- basic "loader" ---
; ----------------------

* = sob$

         word next
         word 7581
         byte $9e ; sys token
         byte chr_0$ + dec_addr1
         byte chr_0$ + dec_addr2
         byte chr_0$ + dec_addr3
         byte chr_0$ + dec_addr4
         byte ":"
         byte $8f; rem token
         text " (c) 2020, rhinodevel"
         byte 0
next     word 0

; -----------------
; --- functions ---
; -----------------

; ************
; *** main ***
; ************

main     sei
   
         jsr init

@infloop ; infinite loop.

         ldx #0 ; reset found note to none. 
         stx found_note$

@keyloop ; loop through all buttons.

         lda keyposx$,x ; skip (currently) unsupported/unused buttons.
         cmp #$ff
         bne @supported
         jmp @next
@supported ; the button to check is supported.

         jsr but_pre$ ; check, if supported button is pressed or not pressed.
         beq @sup_but_is_pressed
         jmp @sup_but_is_not_pressed

@sup_but_is_pressed ; supported button is pressed.

         cpx #31 ; <left arrow> ; does the user want to exit?
         bne @no_exit
         jmp @exit
@no_exit

         cpx #59 ; ';' ; increase-pattern-high-nibble key pressed?
         bne @no_pat_h ; skips, if increase-pattern-high-nibble key not pressed.
         lda flags$
         and #flag_pre_pat_h
         bne @draw_on ; skips, if press already is processed.
         lda flags$
         ora #flag_pre_pat_h
         ora #flag_upd_pat
         sta flags$ ; rem. cur. key press to be alr. processed and request upd.
         lda pattern$ ; increase high nibble of pattern.
         clc
         adc #$10
         sta pattern$
         jmp @draw_on
@no_pat_h

         cpx #'?' ; increase-pattern-low-nibble key pressed?
         bne @no_pat_l
         lda flags$
         and #flag_pre_pat_l
         bne @draw_on
         lda flags$
         ora #flag_pre_pat_l
         ora #flag_upd_pat
         sta flags$
         lda pattern$
         and #$0f
         cmp #$0f
         bne @pat_l_add
         lda pattern$
         and #$f0
         sta pattern$
         jmp @draw_on
@pat_l_add
         inc pattern$
         jmp @draw_on
@no_pat_l

         cpx #'+' ; record button pressed?
         bne @no_rec
         lda flags$
         and #flag_pre_rec
         bne @draw_on ; skips, if press already is processed.
         lda flags$
         ora #flag_pre_rec
         ora #flag_upd_rec
         sta flags$
         ; (nothing to do, here)
         jmp @draw_on
@no_rec

         ; pressed key must be a note key at this point.

         ldy found_note$
         beq @set_found ; branch, if no other pressed note key found, yet.
         
         ; another pressed note key was already found in loop.

         cpy playing_note$ ; use currently found pressed note key, if already
         bne @draw_on      ; found other pressed key is the playing note.

@set_found
         ldy keynote$,x ; (must never be 0, here)
         sty found_note$

@draw_on ldy keyposx$,x ; draw key as pressed and go on.
         sty zero_word_buf1$
         ldy keyposy$,x
         txa
         pha
         jsr rev_on$
         pla
         tax
         jmp @next

@sup_but_is_not_pressed ; supported button is not pressed.
 
         cpx #59 ; ';' ; increase-pattern-high-nibble key?
         bne @no_pat_h_2
         lda flags$ ; disable is-pressed flag.
         and #flag_pre_pat_h_neg
         sta flags$
         jmp @drawnotpre
@no_pat_h_2 

         cpx #'?' ; increase-pattern-low-nibble key?
         bne @no_pat_l_2
         lda flags$
         and #flag_pre_pat_l_neg
         sta flags$
         jmp @drawnotpre
@no_pat_l_2

         cpx #'+' ; record key?
         bne @no_rec_2
         lda flags$ ; disable is-pressed flag.
         and #flag_pre_rec_neg
         sta flags$
         jmp @drawnotpre
@no_rec_2

@drawnotpre ; draw key as not pressed and go on
         ldy keyposx$,x
         sty zero_word_buf1$
         ldy keyposy$,x
         txa
         pha
         jsr rev_off$
         pla
         tax

@next    inx
         cpx #64 ; TODO: hard-coded (for screen codes 0 - 63)!
         beq @keyloopdone ; no more keys to check.
         jmp @keyloop ; still more keys to check.

@keyloopdone ; all keys got processed in loop.

         lda flags$ ; upd. shift pattern on change (for timbre & maybe octave).
         and #flag_upd_pat
         beq @no_upd_pat
         lda flags$
         and #flag_upd_pat_neg
         sta flags$
         lda pattern$
         sta via_shift$
         jsr patdraw$ ; draws shift pattern.
@no_upd_pat

         ; update note to play, if changed (pattern may alter octave, too):
         ;
         lda found_note$
         cmp playing_note$
         beq @no_upd_note ; don't update register and redraw note, if no need.
         sta timer2_low$ ; update register.
         sta playing_note$ ; remember this note as playing.
         jsr drawnote ; draws currently playing note.
@no_upd_note
         
         ; update record mode (etc.), if necessary:
         ;
         lda flags$
         and #flag_upd_rec
         beq @no_upd_rec
         lda flags$
         and #flag_upd_rec_neg
         sta flags$
         and #flag_mode_rec
         beq @rec_enable
         lda flags$ ; disable recording mode.
         and #flag_mode_rec_neg
         sta flags$
         ; TODO: add functionality!
         jmp @no_upd_rec ; (misleading label name, here..)
@rec_enable ; enable recording mode:
         lda flags$
         ora #flag_mode_rec
         sta flags$
         ; TODO: add functionality!
@no_upd_rec

         jmp @infloop ; restart infinite key processing loop.

         ; exit application (show "goodbye"):
         ;
@exit    lda #0
         sta keybufnum$ ; (sometimes, the <left arrow> will still be printed..)
         clrscr$
         lda #<goodbye$
         sta zero_word_buf2$
         lda #>goodbye$
         sta zero_word_buf2$ + 1
         jsr keydrawstat$
         cli
         rts

; ****************
; *** drawnote ***
; ****************
;
; print note's timer value as hexadecimal value.
;
; input:
; ------
; playing_note$
;
; output:
; -------
; a = garbage.
; x = garbage.
; y = garbage.
; zero_word_buf1$ = garbage.
;
drawnote ldy #3 ; hard-coded
         lda #17 ; hard-coded
         sta zero_word_buf1$
         lda playing_note$ ; (zero, if none)
         jsr printby$
         rts

; ************
; *** init ***
; ************
;
init     lda #12; hard-coded. enable graphics mode.
         sta via_pcr$

         lda #0

         sta flags$ ; disables all flags.

         sta playing_note$
         sta found_note$

         lda #22
         sta pattern$ 

         lda #0

         sta timer2_low$ ; disables sound by timer reset.

         lda #16 ; hard-coded. enable free running mode.
         sta via_acr$

         lda pattern$
         sta via_shift$

         clrscr$

         lda #<keystat$
         sta zero_word_buf2$
         lda #>keystat$
         sta zero_word_buf2$ + 1
         jsr keydrawstat$

         keydraw$
         patstaticdraw$

         ; draw dollar sign (indicating hexadecimal number) before cur. "note":
         ;
         ldy #3 ; hard-coded
         lda #16 ; hard-coded
         sta zero_word_buf1$
         lda #'$'
         jsr pos_draw$

         jsr patdraw$
         jsr drawnote
         rts

         ; delay:
         ;
;         lda #$ff
;         sta timer1_low$ ; (reading would also clear interrupt flag)
;         lda #$07
;         sta timer1_high$ ; clears interrupt flag and starts timer.
;@timeout bit via_ifr$ ; did timer one time out?
;         bvc @timeout
