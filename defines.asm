
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
tune_countdown$ =  fp_acc3_3$ ; 2 bytes.
tune_note$ = fp_acc3_5$ ; 1 byte. it's the note's index in notes$ array.

note_count$ = fp_acc1_2$ ; 2 bytes. current count of notes/pauses stored in ram.
note_nr$ = fp_acc1_4$ ; 2 bytes. current note's number (not index).

; TODO: some of these store data that can be stored outside of zero-page without
;       any performance decrease!