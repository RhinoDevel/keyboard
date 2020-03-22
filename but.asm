
; marcel timm, rhinodevel, 2020mar20

; - needs tables key_row$ and key_neg$.

; -----------------
; --- functions ---
; -----------------

; *** check, if button is currently pressed.
; ***
; *** you may need to disable interrupts before calling this function.
; ***
; *** input:
; *** ------
; *** x = screen (not petscii) code of button to check.
; ***
; *** output:
; *** -------
; *** a = 0, if pressed(!). not 0, if not pressed.
; ***
; *** z-flag = 0, if pressed(!). 1, if not pressed.
; ***
;

but_pre$ lda key_row$,x ; set keyboard row to check (seems to be the way to do
         sta pia1porta$ ; this, just "overwrite" whole port a with row nr. 0-9).

         lda pia1portb$ ; loads row's data.
         and key_neg$,x ; checks, if button is pressed.
         rts
