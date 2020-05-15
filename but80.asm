
; marcel timm, rhinodevel, 2020may15

; ---------------------------------------------------------------
; --- screen codes of function buttons for 80 column machines ---
; ---------------------------------------------------------------

; - index equals screen (not petscii) code.
; - not compatible with 40 column machines.
;
but80$   byte 'p' ; exit

         byte '9' ; speed
         byte '0' ; loop
         
         byte '[' ; play
         byte ']' ; record

         byte '.' ; last pattern
         byte '-' ; next pattern