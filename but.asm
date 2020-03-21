
; marcel timm, rhinodevel, 2020mar20

; - needs tables key_row$ and key_neg$.

; -----------------
; --- functions ---
; -----------------

; ***
; *** you must disable interrupts before calling this function.
; ***
; *** input:
; *** ------
; *** x = screen (not petscii) code of button to check.
; ***
; *** output:
; *** -------
; *** a = 1, if pressed. 0, if not pressed.
; *** x = screen (not petscii) code of button to check (kept).
; ***
;

but_pre$ lda key_row$,x ; set keyboard row to check (seems to be the way to do
         sta pia1porta$ ; this, just "overwrite" whole port a with row nr. 0-9).

         lda pia1portb$ ; load row's data.
         and key_neg$,x
         beq pressed@
         lda #0 ; is not pressed.
         rts
         
pressed@ lda #1 ; is pressed.
         rts
