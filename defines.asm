
; marcel timm, rhinodevel, 2020mar18

; ---------------
; --- defines ---
; ---------------

zero_word_buf$ = adptr$
pattern$ = tapbufin$
flags$ = $bc;tapbufin$ + 1 ; hard-coded
old_note$ = tapeutil$
cur_note$ = utility$