
; marcel timm, rhinodevel, 2020mar18

; ---------------
; --- defines ---
; ---------------

zero_word_buf1$ = adptr$
zero_word_buf2$ = tapbufin$
pat_index$ = tappari$
pattern$ = io_util$
flags$ = tapbufch$
playing_note$ = tapeutil$
last_note$ = tapflag$
found_note1$ = utility$
found_note2$ = receive$

mode$ = fp_acc3$ ; 0 = normal, 1 = record, 2 = play.
tune_ptr$ =  fp_acc3_1$
tune_countdown$ =  fp_acc3_3$