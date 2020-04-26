
; marcel timm, rhinodevel, 2020apr20

; -------------------------------------------
; --- tune, must be at the end of binary! ---
; -------------------------------------------

; stores changes of tune:

tune$    byte 5 ; length of note (or pause) in multiples of rec_freq.
                 ;
                 ; max. value: rec_freq * 255 = 12.75 seconds.
                 ;
                 ; 0 = end of tune marker.
         ;
         byte 0 ; playing note's index (or 255 for a pause / no note playing).
         
         byte 5
         byte 2

         byte 5
         byte 4

         byte 5
         byte 5

         byte 10
         byte 7

         byte 5
         byte 9

         byte 5
         byte 11

         byte 10
         byte 12

         byte 0 ; end of tune marker.
