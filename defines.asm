
; marcel timm, rhinodevel, 2020mar18

; ---------------
; --- defines ---
; ---------------

zero_word_buf1$ = fp_acc1$
zero_word_buf2$ = fp_acc1_2$
cas_save$ = fp_acc2$ ; 2 bytes. to hold address of cassette save basic routine.
line_len$ = fp_acc1_4$ ; 1 byte. to store max. count of characters in one line.
tune_ptr$ = adptr$ ; 2 bytes. initially set to tune$.
key_row$ = fp_acc2_2$ ; 2 bytes.
key_neg$ = fp_acc2_4$ ; 2 bytes.

pattern$ = utility$ ; 1 byte. no need to be in zero page!
