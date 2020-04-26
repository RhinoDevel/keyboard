
; marcel timm, rhinodevel, 2020apr20

; -------------------------------------------
; --- tune, must be at the end of binary! ---
; -------------------------------------------

; stores changes of tune:

tune$    word 50 ; length of note (or pause) in multiples of rec_freq.
                 ;
                 ; max. value: rec_freq * 65535 = 327.675 seconds.
                 ;
                 ; 0 = end of tune marker.
         ;
         byte 0 ; playing note's index (or 255 for a pause / no note playing).
         
         word 50
         byte 2

         word 50
         byte 4

         word 50
         byte 5

         word 100
         byte 7

         word 50
         byte 9

         word 50
         byte 11

         word 100
         byte 12

         word 0 ; end of tune marker.
