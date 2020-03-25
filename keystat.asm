
; marcel timm, rhinodevel, 2020mar24

; ---------------------------------------------
; --- static keyboard layout (screen codes) ---
; ---------------------------------------------

keystat$ byte 3 ; char row / line nr. (0 - 24).
         byte 2 ; char column / pos. in line (0 - 39 or 0 - 79).
         byte 13; char count.
         byte 85 ; rounded top-left edge.
         byte 64 ; -
         byte 114 ; T
         byte 64
         byte 73 ; rounded top-right edge.
         byte ' '
         byte 85, 64, 114, 64, 114, 64, 73

         byte 4
         byte 2
         byte 13
         byte 93 ; |
         byte ' '
         byte 93 ; |
         byte ' '
         byte 93 ; |
         byte ' '
         byte 93 ; |
         byte ' '
         byte 93 ; |
         byte ' '
         byte 93 ; |
         byte ' '
         byte 93 ; |
          
         

         byte $ff ; end marker.