
; marcel timm, rhinodevel, 2020mar18

; ---------------
; --- defines ---
; ---------------

zero_word_buf1$ = adptr$ ; 2 bytes.
zero_word_buf2$ = fp_acc1$ ; 2 bytes.
tune_ptr$ = fp_acc1_2$ ; 2 bytes. initially set to tune$.

pattern$ = fp_acc1_4$ ; 1 byte. no need to be in zero page, just for speed.
