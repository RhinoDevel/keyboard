
; marcel timm, rhinodevel, 2020mar17

; ---------------
; --- defines ---
; ---------------

dec_addr1 = 1;main/1000
dec_addr2 = 0;(main/100) MOD $a
dec_addr3 = 6;(main/10) MOD $a
dec_addr4 = 0;main MOD $a

def_pat_index = 0 ; default pattern index (for timbre and sometimes octave).

; to be used with flag_pre variable:
;
flag_pre_pat_n = 1
flag_pre_pat_n_neg = 255 - flag_pre_pat_n
flag_pre_pat_l = 2
flag_pre_pat_l_neg = 255 - flag_pre_pat_l
flag_pre_rec = 4
flag_pre_rec_neg = 255 - flag_pre_rec
flag_pre_play = 8
flag_pre_play_neg = 255 - flag_pre_play
flag_pre_speed = 16
flag_pre_speed_neg = 255 - flag_pre_speed
flag_pre_loop = 32
flag_pre_loop_neg = 255 - flag_pre_loop

; to be used with flag_upd variable:
;
flag_upd_pat = 1
flag_upd_pat_neg = 255 - flag_upd_pat
;
flag_upd_rec = 4
flag_upd_rec_neg = 255 - flag_upd_rec
;
flag_upd_play = 8
flag_upd_play_neg = 255 - flag_upd_play
;
flag_upd_speed = 16
flag_upd_speed_neg = 255 - flag_upd_speed
;
flag_upd_loop = 32
flag_upd_loop_neg = 255 - flag_upd_loop

; to be used with variable named mode:
;
mode_normal = 0
mode_rec = 1
mode_play = 2

rec_freq = 5000 ; microseconds (not really the frequency, but the reciprocal..)
rec_is_waiting = $ee ; value indicates rec. mode waiting for first note.

note_none = $ff ; represents a pause "note" / no note.

; ----------------------
; --- basic "loader" ---
; ----------------------

* = sob$

         word bas_next
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
bas_next word 0

; -----------------
; --- functions ---
; -----------------

; ************
; *** main ***
; ************

main     sei
   
         jsr init

infloop ; infinite loop.

         ldx #note_none ; reset found notes to none. 
         stx fndnote1
         stx fndnote2

keyloop ; loop through all buttons.

         txa ; for indirect addressing here and in but_pre$(), below.
         tay ;
         lda (keyposx$),y ; skip (currently) unsupported/unused buttons.
         cmp #$ff
         bne supported
         jmp next_key
supported ; the button to check is supported.

         jsr but_pre$ ; check, if supported button is pressed or not pressed.
         beq sup_but_is_pressed
         jmp sup_but_is_not_pressed

sup_but_is_pressed ; supported button is pressed.

         ; does the user want to exit?
         ;
         txa
         ldy #but_i_exit$
         cmp (but$),y
         ;
         bne no_exit
         jmp exit
no_exit

         ; next-pattern key pressed?
         ;
         ;txa
         ldy #but_i_next_pat$
         cmp (but$),y
         ;
         bne no_pat_n ; skips, if next-pattern key not pressed.
         lda flag_pre
         and #flag_pre_pat_n
         bne jmp_draw_on ; skips, if press already is processed.
         lda flag_pre
         ora #flag_pre_pat_n
         sta flag_pre ; rem. cur. key press to be alr. processed.
         lda flag_upd
         ora #flag_upd_pat
         sta flag_upd ; request update.
         inc patindex
         lda #pattern_count$
         cmp patindex
         bne set_pattern
         lda #0
         sta patindex
set_pattern ; (also used by other pattern key handling..)
         ldy patindex
         lda patterns$,y
         sta pattern$
jmp_draw_on
         jmp draw_on
no_pat_n

         ; last-pattern key pressed?
         ;
         ;txa
         ldy #but_i_last_pat$
         cmp (but$),y
         ;
         bne no_pat_l
         lda flag_pre
         and #flag_pre_pat_l
         beq pat_l_helper
         jmp draw_on
pat_l_helper
         lda flag_pre
         ora #flag_pre_pat_l
         sta flag_pre ; rem. cur. key press to be alr. processed.
         lda flag_upd
         ora #flag_upd_pat
         sta flag_upd ; request update.
         dec patindex
         lda #$ff
         cmp patindex
         bne set_pattern
         lda #pattern_count$ - 1
         sta patindex
         bne set_pattern ; (always branches)
no_pat_l

         ; record button pressed?
         ;
         ;txa
         ldy #but_i_rec$
         cmp (but$),y
         ;
         bne no_rec
         lda flag_pre
         and #flag_pre_rec
         bne rec_jmp_draw_on ; skips, if press already is processed.
         lda flag_pre
         ora #flag_pre_rec
         sta flag_pre ; rem. cur. key press to be alr. processed.
         lda flag_upd
         ora #flag_upd_rec
         sta flag_upd ; request update.
         ; (nothing to do, here)
rec_jmp_draw_on
         jmp draw_on
no_rec

         ; play button pressed?
         ;
         ;txa
         ldy #but_i_play$
         cmp (but$),y
         ;
         bne no_play
         lda flag_pre
         and #flag_pre_play
         bne draw_on ; skips, if press already is processed.
         lda flag_pre
         ora #flag_pre_play
         sta flag_pre ; rem. cur. key press to be alr. processed.
         lda flag_upd
         ora #flag_upd_play
         sta flag_upd ; request update.
         ; (nothing to do, here)
         jmp draw_on
no_play

         ; speed button pressed?
         ;
         ;txa
         ldy #but_i_speed$
         cmp (but$),y
         ;
         bne no_speed
         lda flag_pre
         and #flag_pre_speed
         bne draw_on ; skips, if press already is processed.
         lda flag_pre
         ora #flag_pre_speed
         sta flag_pre ; rem. cur. key press to be alr. processed.
         lda flag_upd
         ora #flag_upd_speed
         sta flag_upd ; request update.
         ; (nothing to do, here)
         jmp draw_on
no_speed

         ; loop button pressed?
         ;
         ;txa
         ldy #but_i_loop$
         cmp (but$),y
         ;
         bne no_loop
         lda flag_pre
         and #flag_pre_loop
         bne draw_on ; skips, if press already is processed.
         lda flag_pre
         ora #flag_pre_loop
         sta flag_pre ; rem. cur. key press to be alr. processed.
         lda flag_upd
         ora #flag_upd_loop
         sta flag_upd ; request update.
         ; (nothing to do, here)
         jmp draw_on
no_loop

         ; pressed key must be a note key at this point.

         ldy fndnote1
         cpy #note_none
         bne found_note1_already_set
         ldy keynote$,x ; gets note's index in array (never #note_none, here).
         sty fndnote1
         jmp draw_on
found_note1_already_set
         ldy fndnote2
         cpy #note_none
         bne draw_on
         ldy keynote$,x ; gets note's index in array (never #note_none, here).
         sty fndnote2

draw_on  txa ; for indirect addressing.
         tay ;
         lda (keyposx$),y ; draw key as pressed and go on.
         sta zero_word_buf1$
         lda (keyposy$),y
         tay
         txa
         pha
         jsr rev_on$
         pla
         tax
         jmp next_key

sup_but_is_not_pressed ; supported button is not pressed.
 
         ; next-pattern key?
         ;
         txa
         ldy #but_i_next_pat$
         cmp (but$),y
         ;
         bne no_pat_n_2
         lda flag_pre ; disable is-pressed flag.
         and #flag_pre_pat_n_neg
         sta flag_pre
         jmp drawnotpre
no_pat_n_2 

         ; last-pattern key?
         ;
         ;txa
         ldy #but_i_last_pat$
         cmp (but$),y
         ;
         bne no_pat_l_2
         lda flag_pre
         and #flag_pre_pat_l_neg
         sta flag_pre
         jmp drawnotpre
no_pat_l_2

         ; record key?
         ;
         ;txa
         ldy #but_i_rec$
         cmp (but$),y
         ;
         bne no_rec_2
         lda flag_pre ; disable is-pressed flag.
         and #flag_pre_rec_neg
         sta flag_pre
         ;
         lda mode ; keep reversed on screen, if record mode is already enabled.
         cmp #mode_rec
         beq next_key
         jmp drawnotpre
no_rec_2

         ; play key?
         ;
         ;txa
         ldy #but_i_play$
         cmp (but$),y
         ;
         bne no_play_2
         lda flag_pre ; disable is-pressed flag.
         and #flag_pre_play_neg
         sta flag_pre
         ;
         lda mode ; keep reversed on screen, if play mode is already enabled.
         cmp #mode_play
         beq next_key
         jmp drawnotpre
no_play_2

         ; speed key?
         ;
         ;txa
         ldy #but_i_speed$
         cmp (but$),y
         ;
         bne no_speed_2
         lda flag_pre ; disable is-pressed flag.
         and #flag_pre_speed_neg
         sta flag_pre
         jmp drawnotpre
no_speed_2

         ; loop key?
         ;
         ;txa
         ldy #but_i_loop$
         cmp (but$),y
         ;
         bne no_loop_2
         lda flag_pre ; disable is-pressed flag.
         and #flag_pre_loop_neg
         sta flag_pre
         ;
         lda loop + 1 ; keep reversed on screen, if loop playback is alr. enabled.
         bne next_key ; 0 = loop is disabled, 1 = loop is enabled.
         ;jmp drawnotpre
no_loop_2 


drawnotpre ; draw key as not pressed and go on.
         txa ; for indirect addressing.
         tay ;
         lda (keyposx$),y
         sta zero_word_buf1$
         lda (keyposy$),y
         tay
         txa
         pha
         jsr rev_off$
         pla
         tax

next_key inx
         cpx #64 ; hard-coded (for screen codes 0 - 63)!
         beq keyloopdone ; no more keys to check.
         jmp keyloop ; still more keys to check.

keyloopdone ; all keys got processed in loop.

         ; change/update mode, if necessary:
         ;
         lda flag_upd
         and #flag_upd_play
         beq mode_chk_rec ; no update because of play button necessary.
         ;
         ; update because of play button:
         ;
         lda flag_upd
         and #flag_upd_play_neg ; play button is handled.
         and #flag_upd_rec_neg ; record but. is handled (play button overrules).
         sta flag_upd
         ;
         lda mode
         beq play_enable ; switch from normal to play mode (normal mode = 0).
         cmp #mode_rec
         beq mode_no_upd ; must be in record mode, do nothing.
         ;
         ; disable play mode:
         ;
         bne normal_enable ; (always branches, as play mode value is not 0)
         ;
         ; enable play mode (must be in normal mode):
         ;
play_enable
         lda #<tune$
         sta tune_ptr$
         lda #>tune$
         sta tune_ptr$ + 1
         lda #1
         sta countdwn
         lda #0
         sta countdwn + 1
         sta note_nr
         sta note_nr + 1
         lda #<rec_freq
         sta timer1_low$ ; (n.b.: reading would also clear interrupt flag)
         lda #>rec_freq
         sta timer1_high$ ; clears interrupt flag and starts timer.
         lda #mode_play
         bne mode_upd ; (always branches, because play mode value is not zero)
         ;
         ; check, if record mode is enabled (play update must not be necessary):
         ;
mode_chk_rec
         lda flag_upd
         and #flag_upd_rec
         beq mode_no_upd ; no update because of record button necessary.
         ;
         ; update because of record button:
         ;
         lda flag_upd
         and #flag_upd_rec_neg ; record button is handled.
         sta flag_upd
         ;
         lda mode
         beq rec_enable ; switch from normal to record mode (normal = 0).
         cmp #mode_play
         beq mode_no_upd ; must be in play mode, do nothing.
         ;
         ; disable record mode:
         ;
         lda note_nr
         bne store_eot_and_count
         lda note_nr + 1
         beq normal_enable
store_eot_and_count
         ldy #0
         lda #0 ; end of tune marker.
         sta (tune_ptr$),y
         iny
         sta (tune_ptr$),y
         lda note_nr
         sta note_cnt
         lda note_nr + 1
         sta note_cnt + 1
normal_enable
         jsr drawnotecount
         lda #mode_normal
         beq mode_upd ; (always branches, because normal mode value is zero)
         ;
         ; enable record mode (must be in normal mode):
         ;
rec_enable
         lda #0
         sta note_nr
         sta note_nr + 1
         ; (don't show 0 as note nr., keep showing current note/pause count)
         ;
         lda #rec_is_waiting ; indicates waiting for first note to be played by
         sta tunenote      ; user to start recording via timer.
         lda #mode_rec
mode_upd
         sta mode
mode_no_upd

         ; change speed, if necessary:
         ;
         lda flag_upd
         and #flag_upd_speed
         beq speed_no_upd ; no update because of speed button necessary.
         ;
         ; update because of speed button:
         ;
         lda flag_upd
         and #flag_upd_speed_neg ; speed button is handled.
         sta flag_upd
         ;
         inc speed + 1
         lda #5 ; hard-coded speed maximum is this minus 1.
         cmp speed + 1
         bne speed_draw
speed_to_one
         lda #1
         sta speed + 1
speed_draw
         jsr drawspeed
speed_no_upd

         ; enable/disable loop playback, if necessary:
         ;
         lda flag_upd
         and #flag_upd_loop
         beq loop_no_upd ; no update because of loop button necessary.
         ;
         ; update because of loop button:
         ;
         lda flag_upd
         and #flag_upd_loop_neg ; loop button is handled.
         sta flag_upd
         ;
         lda loop + 1
         eor #1 ; toggles loop enabled/disabled.
         sta loop + 1
loop_no_upd

         ; do play mode stuff (before playing note), if play mode is active:
         ;
         lda mode
         cmp #mode_play
         beq play_mode
         jmp play_mode_stuff_end
         ;
         ; play mode:
         ;
play_mode
         lda playingn
         sta fndnote1
         lda #note_none
         sta fndnote2
         ;
         bit via_ifr$ ; did timer one time out?
         bvc play_mode_stuff_end ; no, it did not time out.
         ;
speed
         ldy #1 ; (byte value will be changed in-place to modify playback speed)
countdown_dec
         lda countdwn
         bne countdown_dec_lsb ; skip dec. msb, because lsb is not zero.
         dec countdwn + 1 ; dec. msb, because lsb will underflow.
countdown_dec_lsb
         dec countdwn ; dec. lsb.
         bne countdown_y_dec
         lda countdwn + 1
         beq countdown_next_note ; countdown already at zero, stop dec.
countdown_y_dec
         dey
         bne countdown_dec
         ;
         lda countdwn
         bne play_timer_restart
         lda countdwn + 1
         bne play_timer_restart
         ;
         ; next note of tune (if there is one), please:
         ;
countdown_next_note
         ldy #0
         lda (tune_ptr$),y ; load next note's length's low byte.
         sta countdwn
         inc tune_ptr$ ; incr. tune pointer to next note's length's high byte.
         bne play_tune_ptr_inc_done1
         inc tune_ptr$ + 1
play_tune_ptr_inc_done1
         lda (tune_ptr$),y ; load next note's length's high byte.
         sta countdwn + 1
         bne play_next_note ; it really is a note's length, if high byte not 0.
         lda countdwn
         bne play_next_note ; it really is a note's length, if low byte not 0.
         ;
         ; reached end of tune
         ; (high and low byte are zero, which is the end of tune marker).
         ;

loop     lda #0 ; 0 = don't loop, 1 = loop.
         bne play_loop
         ; 
         ; stop playback and enter normal mode:
         ;
         lda #mode_normal
         sta mode
         jmp play_mode_stuff_end
         ;
         ; infinite loop playback:
         ;
play_loop
         lda #<tune$
         sta tune_ptr$
         lda #>tune$
         sta tune_ptr$ + 1
         ;ldy #0 ; (already set to 0, above)
         sty note_nr
         sty note_nr + 1
         jmp countdown_next_note ; ok, there is alw. at least one note stored.
         ;
         ; play next note:
         ;
play_next_note
         inc tune_ptr$
         bne play_tune_ptr_inc_done2
         inc tune_ptr$ + 1
play_tune_ptr_inc_done2
         ;
         ldy #0
         lda (tune_ptr$),y
         sta fndnote1
         ;
         inc tune_ptr$
         bne play_tune_ptr_inc_done3
         inc tune_ptr$ + 1
play_tune_ptr_inc_done3
         ;
         inc note_nr
         bne play_note_nr_inc_done
         inc note_nr + 1
play_note_nr_inc_done
         ;
         jsr drawnotenr
         ;
         ; restart timer:
         ;
play_timer_restart
         lda #<rec_freq
         sta timer1_low$ ; (n.b.: reading would also clear interrupt flag)
         lda #>rec_freq
         sta timer1_high$ ; clears interrupt flag and starts timer.
play_mode_stuff_end

upd_pat_chk
         lda flag_upd ; upd. shift pattern on change (for timbre & maybe octave).
         and #flag_upd_pat
         beq no_upd_pat
         lda flag_upd
         and #flag_upd_pat_neg
         sta flag_upd
         lda pattern$
         sta via_shift$
         jsr patdraw$ ; draws shift pattern.
no_upd_pat

         ; update note to play, if necessary (pattern may alter octave, too):
         
         ldy playingn
         cpy #note_none
         bne a_note_is_playing
         ldy fndnote1

a_note_is_playing
         ldy fndnote1
         cpy #note_none
         beq do_upd_note ; no note (key) found. disable currently playing note.
         
         ; one note (key) was found.
         
         ldy fndnote2
         cpy #note_none
         bne did_find_two_notes
         sty lastnote
         ldy fndnote1 ; just the one note found.
         cpy playingn
         beq no_upd_note ; the note is already playing (nothing to do).
         jmp do_upd_note ; it is not the same as the note playing. update!
did_find_two_notes
         cpy playingn ; (expects found_note2 to be in y register).
         beq other_and_playing_found
         ldy fndnote1
         cpy playingn
         bne do_upd_note ; two note (keys) found, where both are not the
                          ; playing note. this will always use fndnote1.

         ; playing note (key) and other note (key) found (in this order).

         ldy fndnote2 ; reorder.
         sty fndnote1

         ldy playingn ; this is not necessary,
         sty fndnote2  ; if fndnote2 will not be used from here on.

other_and_playing_found
         ;ldy fndnote1 ; just use this for toggling between both notes.
         ;
         ldy fndnote1
         cpy lastnote
         beq no_upd_note

do_upd_note
         lda playingn
         sta lastnote
         sty playingn
         lda #0
         cpy #note_none
         beq set_timer2_low
         lda notes$,y ; loads notes' timer 2 low byte value.
set_timer2_low         
         sta timer2_low$ ; updates register.
         jsr drawnotea ; draws currently playing note.
no_upd_note
         
; * TODO: implement handling of reached recording byte limit!
;
         ; do record mode stuff (after playing note), if record mode is active:
         ;
         lda mode
         cmp #mode_rec
         beq rec_mode
         jmp rec_mode_stuff_end
         ;
         ; record mode:
         ;
rec_mode lda tunenote
         cmp #rec_is_waiting
         beq rec_is_waiting_for_first_note
         ;
         ; record is already running:
         ;
         bit via_ifr$ ; did timer one time out?
         bvc rec_mode_stuff_end ; no, it did not time out.
         ;
         ; timer ran out, take a measure:
         ;
         lda tunenote
         cmp playingn
         bne rec_note_changed ; the last memorized note is no longer playing.
         ;
         ; the last memorized note is still playing:
         ;
         inc countdwn
         bne inc_countdown_done
         inc countdwn + 1
inc_countdown_done
         ;
         ; * TODO: implement handling of reached limit $ffff!
         ;
         jmp rec_restart_timer
         ;
rec_note_changed
         lda countdwn
         bne rec_save_countdown
         lda countdwn + 1
         beq rec_next_note ; last note did play shorter than one measure unit.
         ;
         ; last note played for at least one measure unit, save it:
         ;
rec_save_countdown
         lda countdwn
         ldy #0
         sta (tune_ptr$),y
         inc tune_ptr$
         bne rec_save_countdown_msb
         inc tune_ptr$ + 1
rec_save_countdown_msb
         lda countdwn + 1
         sta (tune_ptr$),y
         inc tune_ptr$
         bne rec_save_note
         inc tune_ptr$ + 1
rec_save_note
         lda tunenote
         sta (tune_ptr$),y
         inc note_nr
         bne rec_note_nr_inc_done
         inc note_nr + 1
rec_note_nr_inc_done
         jsr drawnotenr
         inc tune_ptr$
         bne rec_next_note
         inc tune_ptr$ + 1
         jmp rec_next_note
         ;
rec_is_waiting_for_first_note
         lda playingn
         cmp #note_none
         beq rec_mode_stuff_end ; still waiting for first note to play..
         ;
         ; the first note now is playing, start recording:
         ;
         lda #<tune$
         sta tune_ptr$
         lda #>tune$
         sta tune_ptr$ + 1
rec_next_note
         lda #0
         sta countdwn
         sta countdwn + 1
         lda playingn
         sta tunenote
rec_restart_timer
         lda #<rec_freq
         sta timer1_low$ ; (n.b.: reading would also clear interrupt flag)
         lda #>rec_freq
         sta timer1_high$ ; clears interrupt flag and starts timer.
rec_mode_stuff_end

         jmp infloop ; restart infinite key processing loop.

         ; exit application (show "goodbye"):
         ;
exit     lda #80
         cmp line_len$
         bne exit_graph_done
         jsr v4_graph_off$ ; (disables graphics mode, enables blank lines)
exit_graph_done
         ;
         ; (not re-enabling first char. rom, because of "goodbye" screen using
         ;  at-sign..)
         ;
         lda #0
         sta loop + 1 ; TODO: implementing keeping loop enabled, if wanted!
         sta timer2_low$ ; disables sound by timer reset.

         sta keybufnum$
         ;
         ; (sometimes, the exit button char. will still be printed..)

         sta via_acr$ ; hard-coded. disables free-running mode
                      ; (e.g. makes tape usable again).
         clrscr$
         lda #<goodbye$
         sta zero_word_buf2$
         lda #>goodbye$
         sta zero_word_buf2$ + 1
         jsr keydrawstat$
         cli
         rts

; *****************
; *** drawspeed ***
; *****************
;
drawspeed
         ldy #7 ; hard-coded
         lda #35 ; hard-coded
         sta zero_word_buf1$
         lda speed + 1
         clc
         adc #'0'
         jmp pos_draw$

; *********************
; *** drawnotecount ***
; *********************
;
drawnotecount
         ldy #2 ; hard-coded
         lda #25 ; hard-coded
         sta zero_word_buf1$
         lda note_cnt + 1
         jsr printby$
         ldy #2 ; hard-coded
         lda #27 ; hard-coded
         sta zero_word_buf1$
         lda note_cnt
         jmp printby$
;
; ******************
; *** drawnotenr ***
; ******************
;
drawnotenr
         ldy #2 ; hard-coded
         lda #25 ; hard-coded
         sta zero_word_buf1$
         lda note_nr + 1
         jsr printby$
         ldy #2 ; hard-coded
         lda #27 ; hard-coded
         sta zero_word_buf1$
         lda note_nr
         jmp printby$

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
         jmp printby$

; ************
; *** init ***
; ************
;
init     

ifdef TGT_PETBV2

         ; *** find out, which basic version (2 or 4) and setup stuff ***
         ;
         ; no support for v1, yet (just ignoring the possibility)!

         ; prepare for v4:
         ;
         lda #<v4_cas_load$
         sta cas_load
         lda #>v4_cas_load$
         sta cas_load + 1
         lda #<v4_cas_save$
         sta cas_save
         lda #>v4_cas_save$
         sta cas_save + 1
         ; (add more, when necessary)
;         lda #'4'
;         sta basic_version$
         ;
         lda vec_nmi$
         cmp #<$fcfe ; hard-coded: lower byte of basic v2 nmi handling address.
         bne basic_setup_done ; assuming v4 ($fd49).
         ;
         ; prepare for (change to) v2:
         ;
         lda #<v2_cas_load$
         sta cas_load
         lda #>v2_cas_load$
         sta cas_load + 1
         lda #<v2_cas_save$
         sta cas_save
         lda #>v2_cas_save$
         sta cas_save + 1
         ; (add more, when necessary)
;         lda #'2'
;         sta basic_version$
basic_setup_done

endif ;TGT_PETBV2
         
ifdef TGT_NONE

         ; prepare for v1:
         ;
         lda #<v1_cas_load$
         sta cas_load
         lda #>v1_cas_load$
         sta cas_load + 1
         lda #<v1_cas_save$
         sta cas_save
         lda #>v1_cas_save$
         sta cas_save + 1
         ; (add more, when necessary)
;         lda #'1'
;         sta basic_version$         

endif ;TGT_NONE

         ; *** find out, if 40 or 80 column machine ***

         ldy #80 ; initialize y with value for 80 column machine.
         ;
         lda #$c0 ; first check..
         sta screen_ram$
         cmp screen_ram$ + 1024
         bne set_line_len ; does not mirror, 80 column machine.
         ;
         ; seems to mirror, recheck with another value (value could have already
         ; been stored there):
         ;
         lda #$dd
         sta screen_ram$
         cmp screen_ram$ + 1024
         bne set_line_len ; does NOT mirror (1. val. was there before), 80 cols.
         ;
         ; did mirror twice.
         ;
         ldy #40 ; set value for 40 column machine.
set_line_len
         sty line_len$

         ; *** initialize internal variables ***

         lda #0

         sta flag_pre ; disables all flags.
         sta flag_upd ;

         ; maybe some of these are not really necessary, here:
         ;
         sta note_nr
         sta note_nr + 1
         ;
         sta tunenote   
         ;
         sta countdwn
         sta countdwn + 1

         sta mode ; set to normal mode (equals 0).

         lda #note_none
         sta playingn
         sta fndnote1
         sta fndnote2
         sta lastnote

         ldy #def_pat_index ; TODO: keep pattern on exit / re-entry!
         sty patindex
         lda patterns$,y
         sta pattern$

         ; calc. max. count of bytes for notes/pauses storable in ram:
         ;
         sec
         lda tom$
         sbc #<tune$
         sta maxnotes
         lda tom$ + 1
         sbc #>tune$
         sta maxnotes + 1
         ;
         sec
         lda maxnotes
         sbc #2 ; hard-coded. byte count of end of tune marker.
         sta maxnotes
         lda maxnotes + 1
         sbc #0
         sta maxnotes + 1

         ; calc. max. count of notes/pauses storable in ram:
         ;
         ; * original division source code was found at: 
         ; 
         ;   www.codebase64.org/doku.php?id=base:16bit_division_16-bit_result
         ;
         lda #0 ; set remainder to zero.
         sta zero_word_buf1$
         sta zero_word_buf1$ + 1
         ;
         ldx #16 ; for each bit:
         ;
divloop  asl maxnotes
         rol maxnotes + 1
         rol zero_word_buf1$
         rol zero_word_buf1$ + 1
         lda zero_word_buf1$
         sec
         sbc #3 ; hard-coded: count of bytes for one note/pause in memory.
         tay
         lda zero_word_buf1$ + 1
         sbc #0
         bcc divskip
         ;
         sta zero_word_buf1$ + 1
         sty zero_word_buf1$
         inc maxnotes
         ;
divskip  dex
         bne divloop

         ; calc. current count of notes/pauses:
         ;
         ldy #0
         sty note_cnt
         sty note_cnt + 1
         lda #<tune$
         sta tune_ptr$
         lda #>tune$
         sta tune_ptr$ + 1
         ;
note_count_loop
         lda (tune_ptr$),y
         bne note_count_not_eot
         iny
         lda (tune_ptr$),y
         beq note_count_end
         ldy #0
note_count_not_eot
         ;
         ldx #3
note_count_inc_loop
         inc tune_ptr$
         bne note_count_ptr_inc_done
         inc tune_ptr$ + 1
note_count_ptr_inc_done
         dex
         bne note_count_inc_loop
         ;
         inc note_cnt
         bne note_count_cnt_inc_done
         inc note_cnt + 1
note_count_cnt_inc_done
         jmp note_count_loop
note_count_end

         ; *** setup system registers ***

         lda #0
         sta timer2_low$ ; disables sound by timer reset.

         lda #16 ; hard-coded. enable free running mode.
         sta via_acr$

         lda pattern$
         sta via_shift$

         lda #<key80_row$
         sta key_row$
         lda #>key80_row$
         sta key_row$ + 1
         lda #<key80_neg$
         sta key_neg$
         lda #>key80_neg$
         sta key_neg$ + 1
         ;
         lda #<keyposx80$
         sta keyposx$
         lda #>keyposx80$
         sta keyposx$ + 1
         lda #<keyposy80$
         sta keyposy$
         lda #>keyposy80$
         sta keyposy$ + 1
         ;
         lda #<but80$
         sta but$
         lda #>but80$
         sta but$ + 1
         ;
         lda #80
         cmp line_len$
         beq init_key_ptrs_done
         ;
         lda #<key40_row$
         sta key_row$
         lda #>key40_row$
         sta key_row$ + 1
         lda #<key40_neg$
         sta key_neg$
         lda #>key40_neg$
         sta key_neg$ + 1
         ;
         lda #<keyposx40$
         sta keyposx$
         lda #>keyposx40$
         sta keyposx$ + 1
         lda #<keyposy40$
         sta keyposy$
         lda #>keyposy40$
         sta keyposy$ + 1
         ;
         lda #<but40$
         sta but$
         lda #>but40$
         sta but$ + 1
init_key_ptrs_done

         lda #12; hard-coded. enable graphics mode (character set to use).
         sta via_pcr$

         lda #80
         cmp line_len$
         bne init_graph_done
         ;
         ; hard-coded: enable second char. rom, if available (e.g. switch from
         ;             german rom to english rom on 8032-SK with german DIN
         ;             keyboard (do this before enabling graphics mode!):
         ;
         lda #chr_alt_rom$
         jsr chrout$
         ;
         ; this machine has 80 cols., remove blank(s) between adjacent lines
         ; (because these must have the 6845 crt controller chip):
         ;
         jsr v4_graph_on$ ; (also sets graphics mode, as done manually above..)
init_graph_done

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

         ; draw count of notes/pauses currently stored in ram:
         ;
         jsr drawnotecount         

         ; draw count of notes/pauses that can be stored in ram via rec.:
         ;
         ldy #4 ; hard-coded
         lda #25 ; hard-coded
         sta zero_word_buf1$
         lda maxnotes + 1
         jsr printby$
         ldy #4 ; hard-coded
         lda #27 ; hard-coded
         sta zero_word_buf1$
         lda maxnotes
         jsr printby$

         jsr drawspeed ; draw playback speed.
      
         rts

; TODO: integrate into application (also loading):
;
; you need to enable irq's and disable free running mode before this (VIA ACR):
;
savetune lda #<tune$
         sta tapesave$
         sta zero_word_buf1$ ; to find end of tune address, below.
         lda #>tune$
         sta tapesave$ + 1
         sta zero_word_buf1$ + 1 ; to find end of tune address, below.

         ; word buffer in zero-page was filled with tune start address, above.
         ;
         ; find end of tune marker and store resulting end address for saving to
         ; tape in the correct place inside zero page:
         ;
         lda #0 ; (two zero bytes represent the end of tune marker)
savetune_loop
         ldy #0
         cmp (zero_word_buf1$),y
         bne savetune_not_zero ; not the end of tune marker, low byte is not 0.
         iny
         cmp (zero_word_buf1$),y
         beq savetune_end_found ; branches, if end of tune marker found.
savetune_not_zero ; end of tune marker not found.
         ldx #3 ; increment pointer to next note/pause or end of tune marker.
         ;
         ; hard-coded (above): length of one note/pause entry is three bytes.
         ;
savetune_next_inc
         inc zero_word_buf1$
         bne savetune_inc_done
         inc zero_word_buf1$ + 1
savetune_inc_done
         dex
         bne savetune_next_inc
         jmp savetune_loop ; check next note/pause or end of tune marker.
savetune_end_found ; end of tune marker (two zeros) was found.
         inc zero_word_buf1$
         bne savetune_inc2_done
         inc zero_word_buf1$ + 1
savetune_inc2_done
         inc zero_word_buf1$
         bne savetune_inc3_done
         inc zero_word_buf1$ + 1
savetune_inc3_done
         ;
         lda zero_word_buf1$
         sta tape_end$
         lda zero_word_buf1$ + 1
         sta tape_end$ + 1

         lda #1 ; hard-coded to tape nr. 1.
         sta devicenr$

         lda #4 ; hard-coded, see constant, below.
         sta fnamelen$

         lda #<filename
         sta fnameptr$
         lda #>filename
         sta fnameptr$ + 1

         ldx #0 ; really necessary?
         jmp (cas_save)

         rts

; TODO: integrate into application (also saving):
;
; you need to enable irq's and disable free running mode before this (VIA ACR):
;
loadtune lda #1 ; hard-coded to tape nr. 1.
         sta devicenr$

         lda #4 ; hard-coded, see constant, below.
         sta fnamelen$

         lda #<filename
         sta fnameptr$
         lda #>filename
         sta fnameptr$ + 1

         ldx #0 ; really necessary?
         jmp (cas_load)

         rts

; -----------------
; --- constants ---
; -----------------

filename text "tune" ; 4 bytes.

; -----------------
; --- variables ---
; -----------------

flag_pre byte 0 ; 1 byte.
flag_upd byte 0 ; 1 byte.

mode     byte 0 ; 1 byte. 0 = normal, 1 = record, 2 = play.

maxnotes word 0 ; 2 bytes. max. count of notes/pauses storable in ram.

note_nr  word 0 ; 2 bytes. current note's number (not index).
note_cnt word 0 ; 2 bytes. current count of notes/pauses stored in ram.
tunenote byte 0 ; 1 byte. it's the note's index in notes$ array.
countdwn word 0 ; 2 bytes. tune countdown.
fndnote1 byte 0 ; 1 byte.
fndnote2 byte 0 ; 1 byte.
lastnote byte 0 ; 1 byte.
playingn byte 0 ; 1 byte. the currently playing note.

patindex byte 0 ; 1 byte. pattern index.

cas_load word 0 ; 2 byte. will hold address of tape load routine after init().
cas_save word 0 ; 2 byte. will hold address of tape save routine after init().

         ; delay:
         ;
;         lda #$ff
;         sta timer1_low$ ; (reading would also clear interrupt flag)
;         lda #$07
;         sta timer1_high$ ; clears interrupt flag and starts timer.
;timeout bit via_ifr$ ; did timer one time out?
;         bvc timeout
