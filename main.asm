
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
flag_pre_stop = 8
flag_pre_stop_neg  = 255 - flag_pre_stop
;
flag_upd_pat = 16
flag_upd_pat_neg  = 255 - flag_upd_pat

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
         byte " "
         byte "(", "c", ")", " ", "2", "0", "2", "0"
         byte ",", " "
         byte "r", "h" ,"i", "n", "o", "d", "e", "v", "e", "l"
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

         ldx #0 ; reset current note to none. 
         stx cur_note$

@keyloop ; loop through all buttons.

         lda keyposx$,x ; skip (currently) unsupported/unused buttons.
         cmp #$ff
         bne @supported
         jmp @next
@supported

         jsr but_pre$ ; check, if supported button is pressed or not.
         beq @teston
         jmp @testoff ; jump to code for not-pressed supported button.

         ; supported button is pressed.

@teston  cpx #31 ; <left arrow> ; does the user want to exit?
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
         sta flags$ ; remember current key press to be already processed.
         ; (nothing to do, here)
         jmp @draw_on
@no_rec
         cpx #'-' ; stop button pressed?
         bne @no_stop
         lda flags$
         and #flag_pre_stop
         bne @draw_on ; skips, if press already is processed.
         lda flags$
         ora #flag_pre_stop
         sta flags$ ; remember current key press to be already processed.
         ; (nothing to do, here)
         jmp @draw_on
@no_stop

         ldy cur_note$
         beq @notechk ; cur_note$ is 0. no pressed note key found in loop, yet.
         
         ; another pressed note key was already found in loop.

         cpy old_note$ ; use currently found pressed note key, if already found
         bne @draw_on  ; other pressed key is the currently playing note.

@notechk ldy keynote$,x ; (0 = supported button has no associated note)
         beq @draw_on
         sty cur_note$

@draw_on ldy keyposx$,x ; draw key as pressed and go on.
         sty zero_word_buf1$
         ldy keyposy$,x
         txa
         pha
         jsr rev_on$
         pla
         tax
         jmp @next

@testoff ; supported button is not pressed.
 
         cpx #59 ; ';' ; increase-pattern-high-nibble key?
         bne @no_pat_h_2
         lda flags$ ; disable is-pressed flag.
         and #flag_pre_pat_h_neg
         sta flags$
@no_pat_h_2 

         cpx #'?' ; increase-pattern-low-nibble key?
         bne @no_pat_l_2
         lda flags$
         and #flag_pre_pat_l_neg
         sta flags$
@no_pat_l_2

         cpx '+' ; record key?
         bne @no_rec_2
         lda flags$ ; disable is-pressed flag.
         and #flag_pre_rec_neg
         sta flags$
@no_rec_2

         cpx '-' ; stop key?
         bne @no_stop_2
         lda flags$ ; disable is-pressed flag.
         and #flag_pre_stop_neg
         sta flags$
@no_stop_2

         ldy keyposx$,x ; draw key as not pressed and go on
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
         beq @upd_note_chk
         lda flags$
         and #flag_upd_pat_neg
         sta flags$
         lda pattern$
         sta via_shift$
         jsr patdraw$ ; draws shift pattern.

@upd_note_chk ; update note to play, if changed (pattern may alter octave, too).
         lda cur_note$
         cmp old_note$
         beq @to_infloop ; don't update register and redraw note, if no need.
         sta timer2_low$ ; update register
         sta old_note$ ; remember this note as playing.
         jsr drawnote ; draws currently playing note.

@to_infloop
         jmp @infloop ; restart key processing loop.

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
; cur_note$
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
         lda cur_note$ ; (zero, if none)
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

         sta old_note$
         sta cur_note$

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
