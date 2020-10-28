
; marcel timm, rhinodevel, 2020oct26

; ------------------------------------------------------------------
; --- message to show for file handling selection (screen codes) ---
; ------------------------------------------------------------------

filemask$
         byte 1
         byte 1
         byte 21
         byte 177
         text ' = load from tape #1'

         byte 3
         byte 1
         byte 21
         byte 178
         text ' = load from tape #2'

         byte 6
         byte 1
         byte 19 
         byte 182
         text ' = save to tape #1'

         byte 8
         byte 1
         byte 19 
         byte 183
         text ' = save to tape #2'

         byte 11
         byte 1
         byte 10
         byte 131
         text ' = cancel'

         byte 14
         byte 1
         byte 6
         text 'hints:'

         byte 16
         byte 1
         byte 38
         text '- forward / rewind tape now, if needed'

         byte 18
         byte 1
         byte 37
         text '- on failure, go to basic & enter run'

         byte $ff ; end marker.