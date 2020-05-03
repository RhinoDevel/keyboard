
; marcel timm, rhinodevel, 2020mar18

; ---------------
; --- defines ---
; ---------------

zero_word_buf1$ = adptr$
zero_word_buf2$ = tapbufin$
pat_index$ = tappari$
pattern$ = io_util$
playing_note$ = tapeutil$
last_note$ = tapflag$
found_note1$ = utility$
found_note2$ = receive$

tune_ptr$ =  fp_acc3_1$ ; 2 bytes. initially set to tune$.

; TODO: some of these store data that can be stored outside of zero-page without
;       any performance decrease!