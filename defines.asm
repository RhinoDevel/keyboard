
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

mode$ = fp_acc3$ ; 1 byte. 0 = normal, 1 = record, 2 = play.
tune_ptr$ =  fp_acc3_1$ ; 2 bytes. initially set to tune$.
tune_countdown$ =  fp_acc3_3$ ; 2 bytes.
tune_note$ = fp_acc3_5$ ; 1 byte. it's the note's index in notes$ array.
