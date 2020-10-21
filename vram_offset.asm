
; marcel timm, rhinodevel, 2020oct21

; ********************************
; *** 40 column screen offsets ***
; ********************************

; offsets of note buttons from video/screen ram start:
;
vram_offset40_cis2$ = 40 *  4 +  3
vram_offset40_dis2$ = 40 *  4 +  5
vram_offset40_fis2$ = 40 *  4 +  9
vram_offset40_gis2$ = 40 *  4 + 11
vram_offset40_ais2$ = 40 *  4 + 13
;
vram_offset40_c02b$ = 40 *  6 +  2
vram_offset40_d002$ = 40 *  6 +  4
vram_offset40_e002$ = 40 *  6 +  6
vram_offset40_f002$ = 40 *  6 +  8
vram_offset40_g002$ = 40 *  6 + 10
vram_offset40_a002$ = 40 *  6 + 12
vram_offset40_b002$ = 40 *  6 + 14
vram_offset40_c003$ = 40 *  6 + 16
;
vram_offset40_cis1$ = 40 *  8 +  5
vram_offset40_dis1$ = 40 *  8 +  7
vram_offset40_fis1$ = 40 *  8 + 11
vram_offset40_gis1$ = 40 *  8 + 13
vram_offset40_ais1$ = 40 *  8 + 15
;
vram_offset40_c001$ = 40 * 10 +  4
vram_offset40_d001$ = 40 * 10 +  6
vram_offset40_e001$ = 40 * 10 +  8
vram_offset40_f001$ = 40 * 10 + 10
vram_offset40_g001$ = 40 * 10 + 12
vram_offset40_a001$ = 40 * 10 + 14
vram_offset40_b001$ = 40 * 10 + 16
vram_offset40_c02a$ = 40 * 10 + 18

; offset of other buttons from video/screen ram start:
;
vram_offset40_exit$ = 40 *  1 + 31
vram_offset40_reco$ = 40 *  3 + 31
vram_offset40_play$ = 40 *  5 + 31
vram_offset40_spee$ = 40 *  7 + 31
vram_offset40_loop$ = 40 *  9 + 31
;
vram_offset40_patl$ = 40 * 10 + 21
vram_offset40_patn$ = 40 * 10 + 23

; offset of non-button elements from video/screen ram start:
;
vram_offset40_val_spee$ = 40 *  7 + 35
vram_offset40_note_pre$ = 40 *  3 + 16

; ********************************
; *** 80 column screen offsets ***
; ********************************

; offsets of note buttons from video/screen ram start:
;
vram_offset80_cis2$ = 80 *  4 +  3
vram_offset80_dis2$ = 80 *  4 +  5
vram_offset80_fis2$ = 80 *  4 +  9
vram_offset80_gis2$ = 80 *  4 + 11
vram_offset80_ais2$ = 80 *  4 + 13
;
vram_offset80_c02b$ = 80 *  6 +  2
vram_offset80_d002$ = 80 *  6 +  4
vram_offset80_e002$ = 80 *  6 +  6
vram_offset80_f002$ = 80 *  6 +  8
vram_offset80_g002$ = 80 *  6 + 10
vram_offset80_a002$ = 80 *  6 + 12
vram_offset80_b002$ = 80 *  6 + 14
vram_offset80_c003$ = 80 *  6 + 16
;
vram_offset80_cis1$ = 80 *  8 +  5
vram_offset80_dis1$ = 80 *  8 +  7
vram_offset80_fis1$ = 80 *  8 + 11
vram_offset80_gis1$ = 80 *  8 + 13
vram_offset80_ais1$ = 80 *  8 + 15
;
vram_offset80_c001$ = 80 * 10 +  4
vram_offset80_d001$ = 80 * 10 +  6
vram_offset80_e001$ = 80 * 10 +  8
vram_offset80_f001$ = 80 * 10 + 10
vram_offset80_g001$ = 80 * 10 + 12
vram_offset80_a001$ = 80 * 10 + 14
vram_offset80_b001$ = 80 * 10 + 16
vram_offset80_c02a$ = 80 * 10 + 18

; offset of other buttons from video/screen ram start:
;
vram_offset80_exit$ = 80 *  1 + 31
vram_offset80_reco$ = 80 *  3 + 31
vram_offset80_play$ = 80 *  5 + 31
vram_offset80_spee$ = 80 *  7 + 31
vram_offset80_loop$ = 80 *  9 + 31
;
vram_offset80_patl$ = 80 * 10 + 21
vram_offset80_patn$ = 80 * 10 + 23

; offset of non-button elements from video/screen ram start:
;
vram_offset80_val_spee$ = 80 *  7 + 35
vram_offset80_note_pre$ = 80 *  3 + 16
