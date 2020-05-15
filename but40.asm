
; marcel timm, rhinodevel, 2020may15

; ---------------------------------------------------------------
; --- screen codes of function buttons for 40 column machines ---
; ---------------------------------------------------------------

; - index equals screen (not petscii) code.
; - not compatible with 80 column machines.
;
but40$   byte 'p' ; exit

         byte '(' ; speed
         byte ')' ; loop
         
         byte '<' ; play
         byte '>' ; record

         byte 59 ; ';' ; last pattern
         byte '?' ; next pattern
         