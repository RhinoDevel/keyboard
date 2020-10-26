
; marcel timm, rhinodevel, 2020oct26

; ------------------------------------------------------------------
; --- message to show for file handling selection (screen codes) ---
; ------------------------------------------------------------------

filemask$
         byte 0
         byte 1
         byte 38
         text 'forward or rewind tape now, if needed!'

         byte 3
         byte 1
         byte 21
         byte 177
         text ' = load from tape #1'

;         byte 5
;         byte 1
;         byte 21
;         byte 178
;         text ' = load from tape #2'

         byte 8
         byte 1
         byte 19 
         byte 182
         text ' = save to tape #1'

;         byte 10
;         byte 1
;         byte 19 
;         byte 183
;         text ' = save to tape #2'

         byte 13
         byte 1
         byte 10
         byte 131
         text ' = cancel'

         byte $ff ; end marker.