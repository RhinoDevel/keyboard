
; marcel timm, rhinodevel, 2020may15

; ---------------------------------------------------------------
; --- screen codes of function buttons for 80 column machines ---
; ---------------------------------------------------------------

; - index equals screen (not petscii) code.
; - not compatible with 40 column machines.
;
but80$   byte '0' ; exit

         byte 'k' ; speed
         byte 'l' ; loop
         
         byte 'p' ; play
         byte 'o' ; record

         byte '.' ; last pattern
         byte '/' ; next pattern