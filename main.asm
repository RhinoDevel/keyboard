
; marcel timm, rhinodevel, 2020mar17

; TODO: immediately disable vibrato on user-toggle, not just with next note!

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
flag_pre_vibr = 64
flag_pre_vibr_neg = 255 - flag_pre_vibr

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
;
flag_upd_vibr = 64
flag_upd_vibr_neg = 255 - flag_upd_vibr

; to be used with variable named mode:
;
mode_normal = 0
mode_rec = 1
mode_play = 2

rec_is_waiting = $ee ; value indicates rec. mode waiting for first note.

note_none = $ff ; represents a pause "note" / no note.

; --------------
; --- macros ---
; --------------

; *********************************************************
; *** macro to handle note button pressed / not pressed ***
; *********************************************************
;
; "input":    x = row's data.
;
; parameters: 1 = column in keyboard matrix (1 byte).
;             2 = screen code of button's character (1 byte).
;             3 = offset of character in video ram.
;             4 = index of note in notes$ (1 byte).
;             5 = inverted screen code of button's character (1 byte).         
;
defm     but_note
         txa              ; reset a to row's data.
         and #/1          ; => z-flag = 0, if pressed(!). 1, if not pressed.
         beq @pressed     ; branches, if pressed.
         lda #/2
         bpl @draw        ; (always branches, here)
@pressed lda #/4
         jsr trysetfndnote
         lda #/5
@draw    sta screen_ram$ + /3    
         endm

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

main
         ; initialization stuff to be done before disabling interrupt service
         ; routine (because "jsr chrout$" does somehow cause waiting for retrace
         ; flag to not work correctly):
         ;
         jsr init_basic
         jsr init_linelen
         jsr init_graphic80
         clrscr$

         sei

         jsr init

         wait_for_retrace_flag$ ; to make sure that first iterations starts when
                                ; flag just got set to one (draw started).

infloop ; infinite loop.

         wait_for_retrace_flag$

         lda #note_none ; reset found notes to none. 
         sta fndnote1
         sta fndnote2

         ; ********************
         ; *** key handling ***
         ; ********************

         bit linelen$ + 1
         bvc keyhandling40
         jmp keyhandling80

         ; *******************************
         ; *** for 40 column machines: ***
         ; *******************************

keyhandling40

         ; *** row 0: ***

         lda #0         ; set keyboard row to check (seems to be the way to do
         sta pia1porta$ ; this, just "overwrite" whole port a with row nr.
                        ; 0-9).
         lda pia1portb$ ; loads row's data.
         tax            ; store row's data in x register for reuse.

         but_note 2, '#', vram_offset40_dis2$, 15, 163
         but_note 4, '%', vram_offset40_fis2$, 18, 165
         but_note 8, '&', vram_offset40_ais2$, 22, 166

         ; *** row 1: ***

         lda #1     
         sta pia1porta$
         lda pia1portb$
         tax

         but_note 1, '"', vram_offset40_cis2$, 13, 162
         but_note 4, ''', vram_offset40_gis2$, 20, 167

         ; exit
         ;
         ; )
         ;
         txa
         and #$10
         bne exitcheckdone40
         ;lda #41 + 128                         ; 41 = ')'. this is more or less
         ;sta screen_ram$ + vram_offset40_exit$ ; academic (no one sees this..).
         jmp exit
exitcheckdone40

         ; *** row 2: ***

         lda #2     
         sta pia1porta$
         lda pia1portb$
         tax

         but_note 1, 'q', vram_offset40_c02b$, 12, 145 ; (2 buttons used)
         but_note 2, 'e', vram_offset40_e002$, 16, 133
         but_note 4, 't', vram_offset40_g002$, 19, 148 
         but_note 8, 'u', vram_offset40_b002$, 23, 149

         ; record
         ;
         ; o
         ;
         txa
         and #$10
         beq pres2_10
         lda flag_pre ; disable is-pressed flag.
         and #flag_pre_rec_neg
         sta flag_pre
         lda mode ; keep reversed on screen, if record mode is already enabled.
         cmp #mode_rec
         beq done2_10
         lda #'o'
         sta screen_ram$ + vram_offset40_reco$
         jmp done2_10
pres2_10 lda flag_pre
         and #flag_pre_rec
         bne done2_10 ; skips, if press already is processed.
         lda flag_pre
         ora #flag_pre_rec
         sta flag_pre ; rem. cur. key press to be alr. processed.
         lda flag_upd
         ora #flag_upd_rec
         sta flag_upd ; request update.
         lda #$0f + 128 ; $0f = 'o'.
         sta screen_ram$ + vram_offset40_reco$ 
done2_10

         ; *** row 3: ***

         lda #3
         sta pia1porta$
         lda pia1portb$
         tax

         but_note 1, 'w', vram_offset40_d002$, 14, 151
         but_note 2, 'r', vram_offset40_f002$, 17, 146
         but_note 4, 'y', vram_offset40_a002$, 21, 153
         but_note 8, 'i', vram_offset40_c003$, 24, 137 ; (highest note)

         ; play
         ;
         ; p
         ;
         txa
         and #$10
         beq pres3_10
         lda flag_pre ; disable is-pressed flag.
         and #flag_pre_play_neg
         sta flag_pre
         lda mode ; keep reversed on screen, if play mode is already enabled.
         cmp #mode_play
         beq done3_10
         lda #'p'
         sta screen_ram$ + vram_offset40_play$
         jmp done3_10
pres3_10 lda flag_pre
         and #flag_pre_play
         bne done3_10 ; skips, if press already is processed.
         lda flag_pre
         ora #flag_pre_play
         sta flag_pre ; rem. cur. key press to be alr. processed.
         lda flag_upd
         ora #flag_upd_play
         sta flag_upd ; request update.
         lda #$10 + 128 ; $10 = 'p'.
         sta screen_ram$ + vram_offset40_play$
done3_10

         ; *** row 4: ***

         lda #4
         sta pia1porta$
         lda pia1portb$
         tax

         but_note 2, 'd', vram_offset40_dis1$,  3, 132
         but_note 4, 'g', vram_offset40_fis1$,  6, 135
         but_note 8, 'j', vram_offset40_ais1$, 10, 138

         ; loop
         ;
         ; l
         ;
         txa
         and #$10
         beq pres4_10
         lda flag_pre ; disable is-pressed flag.
         and #flag_pre_loop_neg
         sta flag_pre
         lda loop_val + 1 ; keep rev. on screen, if loop playback is alr. enabl.
         bne done4_10 ; 0 = loop is disabled, 1 = loop is enabled.
         lda #'l'
         sta screen_ram$ + vram_offset40_loop$
         jmp done4_10
pres4_10 lda flag_pre
         and #flag_pre_loop
         bne done4_10 ; skips, if press already is processed.
         lda flag_pre
         ora #flag_pre_loop
         sta flag_pre ; rem. cur. key press to be alr. processed.
         lda flag_upd
         ora #flag_upd_loop
         sta flag_upd ; request update.
         lda #$0c + 128 ; $0c = 'l'.
         sta screen_ram$ + vram_offset40_loop$
done4_10

         ; *** row 5: ***

         lda #5
         sta pia1porta$
         lda pia1portb$
         tax

         but_note 1, 's', vram_offset40_cis1$,  1, 147
         but_note 4, 'h', vram_offset40_gis1$,  8, 136

         ; speed
         ;
         ; k
         ;
         txa
         and #8
         beq pres5_08
         lda flag_pre ; disable is-pressed flag.
         and #flag_pre_speed_neg
         sta flag_pre
         lda #'k'
         sta screen_ram$ + vram_offset40_spee$
         jmp done5_08
pres5_08 lda flag_pre
         and #flag_pre_speed
         bne done5_08 ; skips, if press already is processed.
         lda flag_pre
         ora #flag_pre_speed
         sta flag_pre ; rem. cur. key press to be alr. processed.
         lda flag_upd
         ora #flag_upd_speed
         sta flag_upd ; request update.
         lda #$0b + 128 ; $0b = 'k'.
         sta screen_ram$ + vram_offset40_spee$
done5_08

         ; vibrato
         ;
         ; :
         ;
         txa
         and #$10
         beq pres5_10
         lda flag_pre ; disable is-pressed flag.
         and #flag_pre_vibr_neg
         sta flag_pre
         lda vibr_val + 1 ; keep rev. on screen, if vibrato is already enabled.
         bne done5_10 ; 0 = vibrato is disabled, 1 = vibrato is enabled.
         lda #':'
         sta screen_ram$ + vram_offset40_vibr$
         jmp done5_10
pres5_10 lda flag_pre
         and #flag_pre_vibr
         bne done5_10 ; skips, if press already is processed.
         lda flag_pre
         ora #flag_pre_vibr
         sta flag_pre ; rem. cur. key press to be alr. processed.
         lda flag_upd
         ora #flag_upd_vibr
         sta flag_upd ; request update.
         lda #58 + 128 ; 58 = ':'.
         sta screen_ram$ + vram_offset40_vibr$
done5_10

         ; *** row 6: ***

         lda #6
         sta pia1porta$
         lda pia1portb$
         tax

         but_note 1, 'z', vram_offset40_c001$,  0, 154 ; (lowest note)
         but_note 2, 'c', vram_offset40_e001$,  4, 131
         but_note 4, 'b', vram_offset40_g001$,  7, 130
         but_note 8, 'm', vram_offset40_b001$, 11, 141

         ; last-pattern
         ;
         ; ;
         ;
         txa
         and #$10
         beq pres6_10
         lda flag_pre
         and #flag_pre_pat_l_neg
         sta flag_pre
         lda #$3b ; $3b = ';'.
         sta screen_ram$ + vram_offset40_patl$
         jmp done6_10
pres6_10 lda flag_pre
         and #flag_pre_pat_l
         bne done6_10
         lda flag_pre
         ora #flag_pre_pat_l
         sta flag_pre ; rem. cur. key press to be alr. processed.
         lda flag_upd
         ora #flag_upd_pat
         sta flag_upd ; request update.
         dec patindex
         lda #$ff
         cmp patindex
         bne set_pattern_l
         lda #pattern_count$ - 1
         sta patindex
set_pattern_l
         ldy patindex
         lda patterns$,y
         sta pattern$
         lda #$3b + 128 ; $3b = ';'.
         sta screen_ram$ + vram_offset40_patl$
done6_10

         ; *** row 7: ***

         lda #7
         sta pia1porta$
         lda pia1portb$
         tax

         but_note 1, 'x', vram_offset40_d001$,  2, 152
         but_note 2, 'v', vram_offset40_f001$,  5, 150
         but_note 4, 'n', vram_offset40_a001$,  9, 142
         
         but_note 8,  44, vram_offset40_c02a$, 12, 172
         ;
         ; 44 = ',' (2 buttons used).

         ; next-pattern
         ;
         ; ?
         ;
         txa
         and #$10
         beq pres7_10
         lda flag_pre ; disable is-pressed flag.
         and #flag_pre_pat_n_neg
         sta flag_pre
         lda #'?'
         sta screen_ram$ + vram_offset40_patn$
         jmp done7_10
pres7_10 lda flag_pre
         and #flag_pre_pat_n
         bne done7_10 ; skips, if press already is processed.
         lda flag_pre
         ora #flag_pre_pat_n
         sta flag_pre ; rem. cur. key press to be alr. processed.
         lda flag_upd
         ora #flag_upd_pat
         sta flag_upd ; request update.
         inc patindex
         lda #pattern_count$
         cmp patindex
         bne set_pattern_n
         lda #0
         sta patindex
set_pattern_n
         ldy patindex
         lda patterns$,y
         sta pattern$
         lda #$3f + 128 ; $3f = '?'.
         sta screen_ram$ + vram_offset40_patn$
done7_10
         
         jmp keyhandling_done

         ; *******************************
         ; *** for 80 column machines: ***
         ; *******************************

keyhandling80

         ; *** row 0: ***

         lda #0
         sta pia1porta$          
         lda pia1portb$
         tax

         but_note   1, '2', vram_offset80_cis2$, 13, 178
         but_note   2, '5', vram_offset80_fis2$, 18, 181

         ; *** row 1: ***

         lda #1     
         sta pia1porta$
         lda pia1portb$
         tax

         but_note   4, '7', vram_offset80_ais2$, 22, 183   

         ; exit
         ;
         ; '0'
         ;
         txa
         and #8
         bne exitcheckdone80
         ;lda #48 + 128                         ; 48 = '0'. this is more or less
         ;sta screen_ram$ + vram_offset80_exit$ ; academic (no one sees this..).
         jmp exit
exitcheckdone80

         ; *** row 2: ***

         lda #2     
         sta pia1porta$
         lda pia1portb$
         tax

         but_note   2, 's', vram_offset80_cis1$,  1, 147
         but_note   8, 'h', vram_offset80_gis1$,  8, 136

         ; speed
         ;
         ; k
         ;
         txa
         and #$20
         beq pres2_20_80
         lda flag_pre ; disable is-pressed flag.
         and #flag_pre_speed_neg
         sta flag_pre
         lda #'k'
         sta screen_ram$ + vram_offset80_spee$
         jmp don2_20_80
pres2_20_80
         lda flag_pre
         and #flag_pre_speed
         bne don2_20_80 ; skips, if press already is processed.
         lda flag_pre
         ora #flag_pre_speed
         sta flag_pre ; rem. cur. key press to be alr. processed.
         lda flag_upd
         ora #flag_upd_speed
         sta flag_upd ; request update.
         lda #$0b + 128 ; $0b = 'k'.
         sta screen_ram$ + vram_offset80_spee$
don2_20_80

         ; vibrato
         ;
         ; ;
         ;
         txa
         and #$40
         beq pres2_40_80
         lda flag_pre ; disable is-pressed flag.
         and #flag_pre_vibr_neg
         sta flag_pre
         lda vibr_val + 1 ; keep rev. on screen, if vibrato is already enabled.
         bne done2_40_80 ; 0 = vibrato is disabled, 1 = vibrato is enabled.
         lda #59 ; 59 = ';'.
         sta screen_ram$ + vram_offset80_vibr$
         jmp done2_40_80
pres2_40_80
         lda flag_pre
         and #flag_pre_vibr
         bne done2_40_80 ; skips, if press already is processed.
         lda flag_pre
         ora #flag_pre_vibr
         sta flag_pre ; rem. cur. key press to be alr. processed.
         lda flag_upd
         ora #flag_upd_vibr
         sta flag_upd ; request update.
         lda #59 + 128 ; 59 = ';'.
         sta screen_ram$ + vram_offset80_vibr$
done2_40_80

         ; *** row 3: ***

         lda #3
         sta pia1porta$
         lda pia1portb$
         tax

         but_note   2, 'd', vram_offset80_dis1$,  3, 132
         but_note   4, 'g', vram_offset80_fis1$,  6, 135
         but_note   8, 'j', vram_offset80_ais1$, 10, 138
 
         ; loop
         ;
         ; l
         ;
         txa
         and #$20
         beq pres3_20_80
         lda flag_pre ; disable is-pressed flag.
         and #flag_pre_loop_neg
         sta flag_pre
         lda loop_val + 1 ; keep rev. on screen, if loop playback is alr. enabl.
         bne done3_20_80 ; 0 = loop is disabled, 1 = loop is enabled.
         lda #'l'
         sta screen_ram$ + vram_offset80_loop$
         jmp done3_20_80
pres3_20_80
        lda flag_pre
         and #flag_pre_loop
         bne done3_20_80 ; skips, if press already is processed.
         lda flag_pre
         ora #flag_pre_loop
         sta flag_pre ; rem. cur. key press to be alr. processed.
         lda flag_upd
         ora #flag_upd_loop
         sta flag_upd ; request update.
         lda #$0c + 128 ; $0c = 'l'.
         sta screen_ram$ + vram_offset80_loop$
done3_20_80

         ; *** row 4: ***

         lda #4
         sta pia1porta$
         lda pia1portb$
         tax

         but_note   2, 'w', vram_offset80_d002$, 14, 151
         but_note   4, 'r', vram_offset80_f002$, 17, 146
         but_note   8, 'y', vram_offset80_a002$, 21, 153
         but_note $20, 'i', vram_offset80_c003$, 24, 137
      
         ; play
         ;
         ; p
         ;
         txa
         and #$40
         beq pres4_40_80
         lda flag_pre ; disable is-pressed flag.
         and #flag_pre_play_neg
         sta flag_pre
         lda mode ; keep reversed on screen, if play mode is already enabled.
         cmp #mode_play
         beq done4_40_80
         lda #'p'
         sta screen_ram$ + vram_offset80_play$
         jmp done4_40_80
pres4_40_80
         lda flag_pre
         and #flag_pre_play
         bne done4_40_80 ; skips, if press already is processed.
         lda flag_pre
         ora #flag_pre_play
         sta flag_pre ; rem. cur. key press to be alr. processed.
         lda flag_upd
         ora #flag_upd_play
         sta flag_upd ; request update.
         lda #$10 + 128 ; $10 = 'p'.
         sta screen_ram$ + vram_offset80_play$
done4_40_80

         ; *** row 5: ***

         lda #5
         sta pia1porta$
         lda pia1portb$
         tax

         but_note   1, 'q', vram_offset80_c02b$, 12, 145
         but_note   2, 'e', vram_offset80_e002$, 16, 133
         but_note   4, 't', vram_offset80_g002$, 19, 148
         but_note   8, 'u', vram_offset80_b002$, 23, 149
     
         ; record
         ;
         ; o
         ;
         txa
         and #$20
         beq pres5_20_80
         lda flag_pre ; disable is-pressed flag.
         and #flag_pre_rec_neg
         sta flag_pre
         lda mode ; keep reversed on screen, if record mode is already enabled.
         cmp #mode_rec
         beq done5_20_80
         lda #'o'
         sta screen_ram$ + vram_offset80_reco$
         jmp done5_20_80
pres5_20_80 
         lda flag_pre
         and #flag_pre_rec
         bne done5_20_80 ; skips, if press already is processed.
         lda flag_pre
         ora #flag_pre_rec
         sta flag_pre ; rem. cur. key press to be alr. processed.
         lda flag_upd
         ora #flag_upd_rec
         sta flag_upd ; request update.
         lda #$0f + 128 ; $0f = 'o'.
         sta screen_ram$ + vram_offset80_reco$ 
done5_20_80

         ; *** row 6: ***

         lda #6
         sta pia1porta$
         lda pia1portb$
         tax

         but_note   2, 'c', vram_offset80_e001$,  4, 131
         but_note   4, 'b', vram_offset80_g001$,  7, 130

         ; last-pattern
         ;
         ; .
         ;
         txa
         and #8
         beq pres6_8_80
         lda flag_pre
         and #flag_pre_pat_l_neg
         sta flag_pre
         lda #'.'
         sta screen_ram$ + vram_offset80_patl$
         jmp done6_8_80
pres6_8_80
         lda flag_pre
         and #flag_pre_pat_l
         bne done6_8_80
         lda flag_pre
         ora #flag_pre_pat_l
         sta flag_pre ; rem. cur. key press to be alr. processed.
         lda flag_upd
         ora #flag_upd_pat
         sta flag_upd ; request update.
         dec patindex
         lda #$ff
         cmp patindex
         bne set_pattern_l_80
         lda #pattern_count$ - 1
         sta patindex
set_pattern_l_80
         ldy patindex
         lda patterns$,y
         sta pattern$
         lda #46 + 128 ; 46 = '.'.
         sta screen_ram$ + vram_offset80_patl$
done6_8_80

         ; *** row 7: ***

         lda #7
         sta pia1porta$
         lda pia1portb$
         tax

         but_note   1, 'z', vram_offset80_c001$,  0, 154
         but_note   2, 'v', vram_offset80_f001$,  5, 150
         but_note   4, 'n', vram_offset80_a001$,  9, 142
         but_note   8,  44, vram_offset80_c02a$, 12, 172 ; 44 = ','

         ; *** row 8: ***

         lda #8
         sta pia1porta$
         lda pia1portb$
         tax

         but_note   2, 'x', vram_offset80_d001$,  2, 152
         but_note   8, 'm', vram_offset80_b001$, 11, 141

         ; next-pattern
         ;
         ; /
         ;
         txa
         and #$40
         beq pres8_40_80
         lda flag_pre ; disable is-pressed flag.
         and #flag_pre_pat_n_neg
         sta flag_pre
         lda #'/'
         sta screen_ram$ + vram_offset80_patn$
         jmp done8_40_80
pres8_40_80
         lda flag_pre
         and #flag_pre_pat_n
         bne done8_40_80 ; skips, if press already is processed.
         lda flag_pre
         ora #flag_pre_pat_n
         sta flag_pre ; rem. cur. key press to be alr. processed.
         lda flag_upd
         ora #flag_upd_pat
         sta flag_upd ; request update.
         inc patindex
         lda #pattern_count$
         cmp patindex
         bne set_pattern_n_80
         lda #0
         sta patindex
set_pattern_n_80
         ldy patindex
         lda patterns$,y
         sta pattern$
         lda #47 + 128 ; 47 = '/'.
         sta screen_ram$ + vram_offset80_patn$
done8_40_80

         ; *** row 9: ***

         lda #9
         sta pia1porta$
         lda pia1portb$
         tax

         but_note   2, '3', vram_offset80_dis2$, 15, 179
         but_note   4, '6', vram_offset80_gis2$, 20, 182

keyhandling_done

         ; ---

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
         lda loop_val + 1
         eor #1 ; toggles loop enabled/disabled.
         sta loop_val + 1
loop_no_upd

         ; enable/disable vibrato, if necessary:
         ;
         lda flag_upd
         and #flag_upd_vibr
         beq vibr_no_upd ; no update because of vibrato button necessary.
         ;
         ; update because of vibrato button:
         ;
         lda flag_upd
         and #flag_upd_vibr_neg ; vibrato button is handled.
         sta flag_upd
         ;
         lda vibr_val + 1
         eor #1 ; toggles vibrato enabled/disabled.
         sta vibr_val + 1
vibr_no_upd

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
         bne play_mode_stuff_end
         lda countdwn + 1
         bne play_mode_stuff_end
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

loop_val lda #0 ; 0 = don't loop, 1 = loop. value will be changed in-place.
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
         sty fndnote2 ; if fndnote2 will not be used from here on.

other_and_playing_found
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
         
         ; vibrato (neither note-dependent, nor speed-dependent):
         ;
vibr_val lda #0 ; 0 = vibrato off, 1 = vibr. on. value will be changed in-place.
         beq vibr_end
         lda vibr_beg
         sec
         sbc timer1_high$
         cmp vibr_int     ; compare with timespan to be between vibrato
                          ; modifications.
         bcc vibr_end     ; skip and wait a while longer before modifying
                          ; vibrato again, if not enough time went by.
         lda timer1_high$
         sta vibr_beg
         ;
         ldy playingn
         cpy #note_none
         beq vibr_end
         ;
         lda notes$,y ; loads notes' timer 2 low byte value.
         clc
vibrato  adc #2 ; will get altered in-place, below.
         sta timer2_low$ ; modify frequency in one "direction".
         lda vibrato+1
         eor #$ff ; flip between (e.g.) 10 and 245 (negative value).
         clc      ;
         adc #1   ;
         sta vibrato+1 ; update for next freq.-change in other "direction".
vibr_end         

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
         ; next recording step reached, take a measure:
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
         ; don't care about theoretically reachable limit of $ffff,
         ; because step length equals screen retrace cycle time which is at
         ; least 1 / 60 hz = ~16,6667 ms. => $ffff would be reached after
         ; ~18 minutes.
         ;
         jmp rec_mode_stuff_end
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
rec_mode_stuff_end

         jmp infloop ; restart infinite key processing loop.

         ; exit application (show "goodbye"):
         ;
exit     lda #0
         sta loop_val + 1 ; TODO: implementing keeping loop enabled, if wanted!
         sta vibr_val + 1 ; TODO: implementing keeping vibr. enabled, if wanted!
         sta timer2_low$ ; disables sound by timer reset.

         sta keybufnum$
         ;
         ; (sometimes, the exit button char. will still be printed..)

         sta via_acr$ ; hard-coded. disables free-running mode
                      ; (e.g. makes tape usable again).

         jsr clrscr_own$

         lda #<goodbye$
         sta zero_word_buf2$
         lda #>goodbye$
         sta zero_word_buf2$ + 1
         jsr keydrawstat$

         cli

         ; doing this after re-enabling interrupt service routine,
         ; because of problems with chrout$ and waiting for retrace (see above):
         ;
         bit linelen$ + 1
         bvc exit_graph_done
         jsr v4_graph_off$ ; (disables graphics mode, enables blank lines)
exit_graph_done
         ;
         ; (not re-enabling first char. rom, because of "goodbye" screen using
         ;  at-sign..)

         rts

; *********************
; *** trysetfndnote ***
; ***               ***
; *** a = input     ***
; *** y = used      ***
; *** sets fndnote1 ***
; *** or fndnote2,  ***
; *** if not both   ***
; *** already set.  ***
; *********************
;
trysetfndnote
         ldy fndnote1
         cpy #note_none
         bne fndnote1_already_set
         sta fndnote1 ; save note's index from a (must not be #note_none, here).
         rts
fndnote1_already_set
         ldy fndnote2
         cpy #note_none
         beq fndnote2_not_set
         rts ; two notes were already found.  
fndnote2_not_set
         sta fndnote2 ; save note's index from a (must not be #note_none, here).
         rts

; *****************
; *** drawspeed ***
; *****************
;
drawspeed
         lda speed + 1
         clc
         adc #'0'
         bit linelen$ + 1
         bvc drawspeed40
         sta screen_ram$ + vram_offset80_val_spee$
         rts
drawspeed40
         sta screen_ram$ + vram_offset40_val_spee$
         rts

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

; ******************
; *** init_basic ***
; ******************
;
init_basic

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
         lda #'4'
         sta basic_version$
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
         lda #'2'
         sta basic_version$
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
         lda #'1'
         sta basic_version$         

endif ;TGT_NONE

         rts

; ********************
; *** init_linelen ***
; ********************
;
init_linelen
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
         sty linelen$ + 1
         rts

; **********************
; *** init_graphic80 ***
; **********************
;
init_graphic80
         bit linelen$ + 1
         bvc init_graph_done ; do nothing, if 40 line machine.
         ;
         ; hard-coded: enable second char. rom, if available (e.g. switch from
         ;             german rom to english rom on 8032-sk with german din
         ;             keyboard (do this before enabling graphics mode!):
         ;
         lda #chr_alt_rom$
         jsr chrout$
         ;
         ; this machine has 80 cols., remove blank(s) between adjacent lines
         ; (because these must have the 6845 crt controller chip):
         ;
         jsr v4_graph_on$ ; (also sets graphics mode,
                          ;  as done elsewhere during init..)
init_graph_done
         rts

; ************
; *** init ***
; ************
;
init     ; *** initialize internal variables ***

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

;         ; this should not be necessary, because timers are always running:
;         ;
;         ; make sure that timer 1 is running:
;         ;
;         lda #$ff
;         sta timer1_low$ ; (n.b.: reading would also clear interrupt flag)
;         sta timer1_high$ ; clears interrupt flag and starts timer.

         lda #16 ; hard-coded. enable free running mode.
         sta via_acr$

         lda pattern$
         sta via_shift$

         lda #12 ; hard-coded. enable graphics mode (character set to use).
         sta via_pcr$

         ; *** draw initial screen ***

         ; (screen must already have been cleared)

         lda #<keystat$
         sta zero_word_buf2$
         lda #>keystat$
         sta zero_word_buf2$ + 1
         jsr keydrawstat$

         bit linelen$ + 1
         bvc init_extradraw40

         lda #'0'
         sta screen_ram$ + vram_offset80_exit$ ; academic (no one sees this..).
         ;
         ; no other key label drawing, here (because always done by loop..).

         ; draw dollar sign (indicating hexadecimal number) before cur. "note":
         ;
         lda #'$'
         sta screen_ram$ + vram_offset80_note_pre$
         jmp init_extradraw_done

init_extradraw40

         lda #')'
         sta screen_ram$ + vram_offset40_exit$ ; academic (no one sees this..).
         ;
         ; no other key label drawing, here (because always done by loop..).

         ; draw dollar sign (indicating hexadecimal number) before cur. "note":
         ;
         lda #'$'
         sta screen_ram$ + vram_offset40_note_pre$

init_extradraw_done

         patstaticdraw$

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

vibr_int byte 128 ; vibr_int * 256 microseconds.
vibr_beg byte 0 ; 1 byte. used for vibrato.

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
