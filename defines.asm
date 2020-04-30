
; marcel timm, rhinodevel, 2020mar18

; ---------------
; --- defines ---
; ---------------

zero_word_buf1$ = adptr$
zero_word_buf2$ = tapbufin$
pat_index$ = tappari$
pattern$ = io_util$
flag_pre$ = tapbufch$
playing_note$ = tapeutil$
last_note$ = tapflag$
found_note1$ = utility$
found_note2$ = receive$

mode$ = fp_acc3$ ; 1 byte. 0 = normal, 1 = record, 2 = play.
tune_ptr$ =  fp_acc3_1$ ; 2 bytes. initially set to tune$.
tune_countdown$ =  fp_acc3_3$ ; 2 bytes.
tune_note$ = fp_acc3_5$ ; 1 byte. it's the note's index in notes$ array.

max_notes$ = fp_acc1$ ; 2 bytes. max. count of notes/pauses storable in ram.
note_count$ = fp_acc1_2$ ; 2 bytes. current count of notes/pauses stored in ram.
note_nr$ = fp_acc1_4$ ; 2 bytes. current note's number (not index).

flag_upd$ = fp_acc2$ ; 1 byte.

; TODO: some of these store data that can be stored outside of zero-page without
;       any performance decrease!