
; marcel timm, rhinodevel, 2020nov05

; ---------------------------------------------
; --- data necessary to handle note buttons ---
; ---------------------------------------------

; note data format: 0 byte $23   ; screen code of button's character.
;                   1 byte 3     ; column in keyboard matrix.
;                   2 byte $10   ; index of note in notes$
;                   3 word $8102 ; absolute position of character in screen ram.

; *** for 40 column machines: ***

notebut40_c001$
         byte 'z'
         byte 1
         byte 0
         word screen_ram$ + vram_offset40_c001$

notebut40_cis1$
         byte 's'
         byte 1
         byte 1
         word screen_ram$ + vram_offset40_cis1$

notebut40_d001$
         byte 'x'
         byte 1
         byte 2
         word screen_ram$ + vram_offset40_d001$

notebut40_dis1$
         byte 'd'
         byte 2
         byte 3
         word screen_ram$ + vram_offset40_dis1$

notebut40_e001$
         byte 'c'
         byte 2
         byte 4
         word screen_ram$ + vram_offset40_e001$

notebut40_f001$
         byte 'v'
         byte 2
         byte 5
         word screen_ram$ + vram_offset40_f001$

notebut40_fis1$
         byte 'g'
         byte 4
         byte 6
         word screen_ram$ + vram_offset40_fis1$

notebut40_g001$
         byte 'b'
         byte 4
         byte 7
         word screen_ram$ + vram_offset40_g001$

notebut40_gis1$
         byte 'h'
         byte 4
         byte 8
         word screen_ram$ + vram_offset40_gis1$

notebut40_a001$
         byte 'n'
         byte 4
         byte 9
         word screen_ram$ + vram_offset40_a001$

notebut40_ais1$
         byte 'j'
         byte 8
         byte 10
         word screen_ram$ + vram_offset40_ais1$

notebut40_b001$
         byte 'm'
         byte 8
         byte 11
         word screen_ram$ + vram_offset40_b001$

notebut40_c02a$
         byte 44 ; 44 = ','
         byte 8
         byte 12
         word screen_ram$ + vram_offset40_c02a$

notebut40_c02b$
         byte 'q'
         byte 1
         byte 12
         word screen_ram$ + vram_offset40_c02b$

notebut40_cis2$
         byte '"'
         byte 1
         byte 13
         word screen_ram$ + vram_offset40_cis2$

notebut40_d002$
         byte 'w'
         byte 1
         byte 14
         word screen_ram$ + vram_offset40_d002$

notebut40_dis2$
         byte '#'
         byte 2
         byte 15
         word screen_ram$ + vram_offset40_dis2$

notebut40_e002$
         byte 'e'
         byte 2
         byte 16
         word screen_ram$ + vram_offset40_e002$

notebut40_f002$
         byte 'r'
         byte 2
         byte 17
         word screen_ram$ + vram_offset40_f002$

notebut40_fis2$
         byte '%'
         byte 4
         byte 18
         word screen_ram$ + vram_offset40_fis2$

notebut40_g002$
         byte 't'
         byte 4
         byte 19
         word screen_ram$ + vram_offset40_g002$

notebut40_gis2$
         byte 39 ; 39 = <apostrophe>.
         byte 4
         byte 20
         word screen_ram$ + vram_offset40_gis2$

notebut40_a002$
         byte 'y'
         byte 4
         byte 21
         word screen_ram$ + vram_offset40_a002$

notebut40_ais2$
         byte '&'
         byte 8
         byte 22
         word screen_ram$ + vram_offset40_ais2$

notebut40_b002$
         byte 'u'
         byte 8
         byte 23
         word screen_ram$ + vram_offset40_b002$

notebut40_c003$
         byte 'i'
         byte 8
         byte 24
         word screen_ram$ + vram_offset40_c003$

; *** for 80 column machines: ***

notebut80_c001$
         byte 'z'
         byte 1
         byte 0
         word screen_ram$ + vram_offset80_c001$

notebut80_cis1$
         byte 's'
         byte 2
         byte 1
         word screen_ram$ + vram_offset80_cis1$

notebut80_d001$
         byte 'x'
         byte 2
         byte 2
         word screen_ram$ + vram_offset80_d001$

notebut80_dis1$
         byte 'd'
         byte 2
         byte 3
         word screen_ram$ + vram_offset80_dis1$

notebut80_e001$
         byte 'c'
         byte 2
         byte 4
         word screen_ram$ + vram_offset80_e001$

notebut80_f001$
         byte 'v'
         byte 2
         byte 5
         word screen_ram$ + vram_offset80_f001$

notebut80_fis1$
         byte 'g'
         byte 4
         byte 6
         word screen_ram$ + vram_offset80_fis1$

notebut80_g001$
         byte 'b'
         byte 4
         byte 7
         word screen_ram$ + vram_offset80_g001$

notebut80_gis1$
         byte 'h'
         byte 8
         byte 8
         word screen_ram$ + vram_offset80_gis1$

notebut80_a001$
         byte 'n'
         byte 4
         byte 9
         word screen_ram$ + vram_offset80_a001$

notebut80_ais1$
         byte 'j'
         byte 8
         byte 10
         word screen_ram$ + vram_offset80_ais1$

notebut80_b001$
         byte 'm'
         byte 8
         byte 11
         word screen_ram$ + vram_offset80_b001$

notebut80_c02a$
         byte 44 ; 44 = ','
         byte 8
         byte 12
         word screen_ram$ + vram_offset80_c02a$

notebut80_c02b$
         byte 'q'
         byte 1
         byte 12
         word screen_ram$ + vram_offset80_c02b$

notebut80_cis2$
         byte '2'
         byte 1
         byte 13
         word screen_ram$ + vram_offset80_cis2$

notebut80_d002$
         byte 'w'
         byte 2
         byte 14
         word screen_ram$ + vram_offset80_d002$

notebut80_dis2$
         byte '3'
         byte 2
         byte 15
         word screen_ram$ + vram_offset80_dis2$

notebut80_e002$
         byte 'e'
         byte 2
         byte 16
         word screen_ram$ + vram_offset80_e002$

notebut80_f002$
         byte 'r'
         byte 4
         byte 17
         word screen_ram$ + vram_offset80_f002$

notebut80_fis2$
         byte '5'
         byte 2
         byte 18
         word screen_ram$ + vram_offset80_fis2$

notebut80_g002$
         byte 't'
         byte 4
         byte 19
         word screen_ram$ + vram_offset80_g002$

notebut80_gis2$
         byte '6'
         byte 4
         byte 20
         word screen_ram$ + vram_offset80_gis2$

notebut80_a002$
         byte 'y'
         byte 8
         byte 21
         word screen_ram$ + vram_offset80_a002$

notebut80_ais2$
         byte '7'
         byte 4
         byte 22
         word screen_ram$ + vram_offset80_ais2$

notebut80_b002$
         byte 'u'
         byte 8
         byte 23
         word screen_ram$ + vram_offset80_b002$

notebut80_c003$
         byte 'i'
         byte $20
         byte 24
         word screen_ram$ + vram_offset80_c003$

; "input":    x = row's data.
;
; parameters: 1 = column in keyboard matrix (1 byte).
;             2 = screen code of button's character (1 byte).
;             3 = offset of character in video ram.
;             4 = index of note in notes$ (1 byte).
;             5 = inverted screen code of button's character (1 byte). 


