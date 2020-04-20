
; marcel timm, rhinodevel, 2020mar17

; ---------------
; --- defines ---
; ---------------

dec_addr1 = 1;main/1000
dec_addr2 = 0;(main/100) MOD $a
dec_addr3 = 6;(main/10) MOD $a
dec_addr4 = 0;main MOD $a

def_pat_index = 0 ; default pattern index (for timbre and sometimes octave).

; to be used with flags$ variable:
;
flag_pre_pat_n = 1
flag_pre_pat_n_neg = 255 - flag_pre_pat_n
flag_pre_pat_l = 2
flag_pre_pat_l_neg = 255 - flag_pre_pat_l
flag_pre_rec = 4
flag_pre_rec_neg = 255 - flag_pre_rec
flag_pre_play = 8
flag_pre_play_neg = 255 - flag_pre_play
;
flag_upd_pat = 16
flag_upd_pat_neg = 255 - flag_upd_pat
;
flag_upd_rec = 32
flag_upd_rec_neg = 255 - flag_upd_rec
;
flag_upd_play = 64
flag_upd_play_neg = 255 - flag_upd_play

; to be used with variable named mode:
;
mode_normal = 0
mode_rec = 1
mode_play = 2

rec_freq = 50000 ; microseconds (not really the frequency, but the reciprocal..)

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

         cpx #59 ; ';' ; next-pattern key pressed?
         bne @no_pat_n ; skips, if next-pattern key not pressed.
         lda flags$
         and #flag_pre_pat_n
         bne @jmp_draw_on ; skips, if press already is processed.
         lda flags$
         ora #flag_pre_pat_n
         ora #flag_upd_pat
         sta flags$ ; rem. cur. key press to be alr. processed and request upd.
         inc pat_index$
         lda #pattern_count$
         cmp pat_index$
         bne @set_pattern
         lda #0
         sta pat_index$
@set_pattern ; (also used by other pattern key handling..)
         ldy pat_index$
         lda patterns$,y
         sta pattern$
@jmp_draw_on
         jmp @draw_on
@no_pat_n

         cpx #'?' ; last-pattern key pressed?
         bne @no_pat_l
         lda flags$
         and #flag_pre_pat_l
         bne @draw_on
         lda flags$
         ora #flag_pre_pat_l
         ora #flag_upd_pat
         sta flags$
         dec pat_index$
         lda #$ff
         cmp pat_index$
         bne @set_pattern
         lda #pattern_count$ - 1
         sta pat_index$
         bne @set_pattern ; (always branches)
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

         cpx #'=' ; play button pressed?
         bne @no_play
         lda flags$
         and #flag_pre_play
         bne @draw_on ; skips, if press already is processed.
         lda flags$
         ora #flag_pre_play
         ora #flag_upd_play
         sta flags$
         ; (nothing to do, here)
         jmp @draw_on
@no_play

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
 
         cpx #59 ; ';' ; next-pattern key?
         bne @no_pat_n_2
         lda flags$ ; disable is-pressed flag.
         and #flag_pre_pat_n_neg
         sta flags$
         jmp @drawnotpre
@no_pat_n_2 

         cpx #'?' ; last-pattern key?
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

         cpx #'=' ; play key?
         bne @no_play_2
         lda flags$ ; disable is-pressed flag.
         and #flag_pre_play_neg
         sta flags$
         jmp @drawnotpre
@no_play_2

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

         ; change/update mode, if necessary:
         ;
         lda flags$
         and #flag_upd_play
         beq @mode_chk_rec ; no update because of play button necessary.
         ;
         ; update because of play button:
         ;
         lda flags$
         and #flag_upd_play_neg ; play button is handled.
         and #flag_upd_rec_neg ; record but. is handled (play button overrules).
         sta flags$
         ;
         lda mode$
         beq @play_enable ; switch from normal to play mode (normal mode = 0).
         cmp #mode_rec
         beq @mode_no_upd ; must be in record mode, do nothing.
         ;
         ; disable play mode:
         ;
         bne @normal_enable ; (always branches, as play mode value is not 0)
         ;
         ; enable play mode (must be in normal mode):
         ;
@play_enable
         lda #<tune$
         sta tune_ptr$
         lda #>tune$
         sta tune_ptr$ + 1
         lda #1
         sta tune_countdown$
         lda #<rec_freq
         sta timer1_low$ ; (n.b.: reading would also clear interrupt flag)
         lda #>rec_freq
         sta timer1_high$ ; clears interrupt flag and starts timer.
         lda #mode_play
         bne @mode_upd ; (always branches, because play mode value is not zero)
         ;
         ; check, if record mode is enabled (play update must not be necessary):
         ;
@mode_chk_rec
         lda flags$
         and #flag_upd_rec
         beq @mode_no_upd ; no update because of record button necessary.
         ;
         ; update because of record button:
         ;
         lda flags$
         and #flag_upd_rec_neg ; record button is handled.
         sta flags$
         ;
         lda mode$
         beq @rec_enable ; switch from normal to record mode (normal = 0).
         cmp #mode_play
         beq @mode_no_upd ; must be in play mode, do nothing.
         ;
         ; disable record mode (also play mode, if branched from above):
         ;
@normal_enable
         lda #mode_normal ; (always branches, because normal mode value is zero)
         beq @mode_upd
         ;
         ; enable record mode (must be in normal mode):
         ;
@rec_enable
         lda #mode_rec
@mode_upd
         sta mode$
         jsr drawmodea
@mode_no_upd

         lda mode$
         beq @no_mode_stuff ; normal mode, do nothing.
         cmp #mode_rec
         bne @play_stuff ; play mode.
         ;
         ; record mode:
         ;
         jmp @no_mode_stuff ; TODO: implement!
         ;
         ; play mode:
         ;
@play_stuff
         lda playing_note$
         sta found_note1$
         lda #$ff
         sta found_note2$
         ;
         bit via_ifr$ ; did timer one time out?
         bvc @no_mode_stuff ; no, it did not time out.
         ;
         dec tune_countdown$
         bne @play_timer_restart
         ;
         ; next note of tune (if there is one), please:
         ;
         ldy #0
         lda (tune_ptr$),y
         bne @play_next_note
         ;
         ; reached end of tune.
         ;
         lda #mode_normal
         sta mode$
         jsr drawmodea
         jmp @no_mode_stuff
         ;
         ; play next note:
         ;
@play_next_note
         sta tune_countdown$
         ;
         inc tune_ptr$
         bne @play_tune_ptr_inc_done1
         inc tune_ptr$ + 1
@play_tune_ptr_inc_done1
         ;
         ldy #0
         lda (tune_ptr$),y
         sta found_note1$
         ;
         inc tune_ptr$
         bne @play_tune_ptr_inc_done2
         inc tune_ptr$ + 1
@play_tune_ptr_inc_done2
         ;
         ; restart timer:
         ;
@play_timer_restart
         lda #<rec_freq
         sta timer1_low$ ; (n.b.: reading would also clear interrupt flag)
         lda #>rec_freq
         sta timer1_high$ ; clears interrupt flag and starts timer.
@no_mode_stuff

@upd_pat_chk
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
         sty last_note$
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
         ;ldy found_note1$ ; just use this for toggling between both notes.
         ;
         ldy found_note1$
         cpy last_note$
         beq @no_upd_note

@do_upd_note
         lda playing_note$
         sta last_note$
         sty playing_note$
         lda #0
         cpy #$ff
         beq @set_timer2_low
         lda notes$,y ; loads notes' timer 2 low byte value.
@set_timer2_low         
         sta timer2_low$ ; updates register.
         jsr drawnotea ; draws currently playing note.
@no_upd_note
         
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
; *** drawmodea ***
; *****************
;
; print mode (value must be in register a) as hexadecimal value.
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
drawmodea
         ldy #21 ; hard-coded
         sty zero_word_buf1$
         ldy #3 ; hard-coded         
         jsr printby$
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

         sta mode$ ; set to normal mode (equals 0).

         lda #$ff
         sta playing_note$
         sta found_note1$
         sta found_note2$
         sta last_note$

         ldy #def_pat_index
         sty pat_index$
         lda patterns$,y
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

         lda mode$
         jsr drawmodea

         rts

         ; delay:
         ;
;         lda #$ff
;         sta timer1_low$ ; (reading would also clear interrupt flag)
;         lda #$07
;         sta timer1_high$ ; clears interrupt flag and starts timer.
;@timeout bit via_ifr$ ; did timer one time out?
;         bvc @timeout
