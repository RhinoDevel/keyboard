
; marcel timm, rhinodevel, 2020mar17

; ---------------
; --- defines ---
; ---------------

dec_addr1 = 1;main/1000
dec_addr2 = 0;(main/100) MOD $a
dec_addr3 = 6;(main/10) MOD $a
dec_addr4 = 0;main MOD $a

def_pattern = #$0f ; default pattern (for timbre and sometimes octave).

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

         ldx #$ff ; reset found notes to none. 
         stx found_note1$
         stx found_note2$

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

         ldy found_note1$
         cpy #$ff
         bne @found_note1_already_set
         ldy keynote$,x ; gets note's index in array (must never be $ff, here).
         sty found_note1$
         jmp @draw_on
@found_note1_already_set
         ldy found_note2$
         cpy #$ff
         bne @draw_on
         ldy keynote$,x ; gets note's index in array (must never be $ff, here).
         sty found_note2$

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

         ; update note to play, if necessary (pattern may alter octave, too):
         ;
;         ldy found_note$
;         cpy playing_note$
;         beq @no_upd_note ; don't update register and redraw note, if no need.
;         sty playing_note$ ; remembers this note as playing (the index).
;         lda #0 ; (for no note to play)
;         cpy #$ff
;         beq @do_upd_note ; skip loading, because index $ff does not work..
;         lda notes$,y ; loads notes' timer 2 low byte value.
         ;
         ldy playing_note$
         cpy #$ff
         bne @a_note_is_playing
         ldy found_note1$

@a_note_is_playing
         ldy found_note1$
         cpy #$ff
         beq @do_upd_note ; no note (key) found. disable currently playing note.
         
         ; one note (key) was found.
         
         ldy found_note2$
         cpy #$ff
         bne @did_find_two_notes
         ldy found_note1$ ; just the one note found.
         cpy playing_note$
         beq @no_upd_note ; the note is already playing (nothing to do).
         jmp @do_upd_note ; it is not the same as the note playing. update!
@did_find_two_notes
         cpy playing_note$ ; (expects found_note2 to be in y register).
         beq @other_and_playing_found
         ldy found_note1$
         cpy playing_note$
         bne @do_upd_note ; two note (keys) found, where both are not the
                          ; playing note. this will always use found_note1$.

         ; playing note (key) and other note (key) found (in this order).

         ldy found_note2$ ; reorder.
         sty found_note1$

         ldy playing_note$ ; this is not necessary,
         sty found_note2$  ; if found_note2$ will not be used from here on.

@other_and_playing_found
         ldy found_note1$ ; just use this for toggling between both notes.
         ;
         ; TODO: implement mode 

@do_upd_note
         sty playing_note$
         lda #0
         cpy #$ff
         beq @set_timer2_low
         lda notes$,y ; loads notes' timer 2 low byte value.
@set_timer2_low         
         sta timer2_low$ ; updates register.
         jsr drawnotea ; draws currently playing note.
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
         sta timer2_low$ ; disables sound by timer reset.
         sta keybufnum$ ; (sometimes, the <left arrow> will still be printed..)
         clrscr$
         lda #<goodbye$
         sta zero_word_buf2$
         lda #>goodbye$
         sta zero_word_buf2$ + 1
         jsr keydrawstat$
         cli
         rts

; *****************
; *** drawnotea ***
; *****************
;
; print note (value must be in register a) as hexadecimal value.
;
; input:
; ------
; a
;
; output:
; -------
; a = garbage.
; x = garbage.
; y = garbage.
; zero_word_buf1$ = garbage.
;
drawnotea
         ldy #17 ; hard-coded
         sty zero_word_buf1$
         ldy #3 ; hard-coded         
         jsr printby$
         rts

; ************
; *** init ***
; ************
;
init     ; *** initialize internal variables ***

         lda #0

         sta flags$ ; disables all flags.

         lda #$ff
         sta playing_note$
         sta found_note1$
         sta found_note2$

         lda #def_pattern
         sta pattern$ 

         ; *** setup system registers ***

         lda #0
         sta timer2_low$ ; disables sound by timer reset.

         lda #16 ; hard-coded. enable free running mode.
         sta via_acr$

         lda pattern$
         sta via_shift$

         lda #12; hard-coded. enable graphics mode (character set to use).
         sta via_pcr$

         ; *** draw initial screen ***

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
         lda #0
         jsr drawnotea

         rts

         ; delay:
         ;
;         lda #$ff
;         sta timer1_low$ ; (reading would also clear interrupt flag)
;         lda #$07
;         sta timer1_high$ ; clears interrupt flag and starts timer.
;@timeout bit via_ifr$ ; did timer one time out?
;         bvc @timeout
