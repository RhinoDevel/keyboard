
; marcel timm, rhinodevel, 2020oct26

; ------------------------------------------------------------------
; --- message to show for file handling selection (screen codes) ---
; ------------------------------------------------------------------

filemask$
         byte 0
         byte 0
         byte 21
         byte 177
         text ' = load from tape #1'

         byte 2
         byte 0
         byte 21
         byte 178
         text ' = load from tape #2'

         byte 5
         byte 0
         byte 19 
         byte 182
         text ' = save to tape #1'

         byte 7
         byte 0
         byte 19 
         byte 183
         text ' = save to tape #2'

         byte 10
         byte 0
         byte 10
         byte 131
         text ' = cancel'

         byte 13
         byte 0
         byte 6
         text 'hints:'

         byte 15
         byte 0
         byte 39
         text '- forward or rewind tape now, if needed'

         byte 17
         byte 0
         byte 40
         text '- if tape fails, go to basic & enter run'

         byte $ff ; end marker.