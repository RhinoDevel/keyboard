
; marcel timm, rhinodevel, 2020mar18

; ---------------
; --- defines ---
; ---------------

zero_word_buf1$ = fp_acc1$
zero_word_buf2$ = fp_acc1_2$
tune_ptr$ = adptr$ ; 2 bytes. initially set to tune$.

pattern$ = utility$ ; 1 byte. no need to be in zero page!
