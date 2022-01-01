
; marcel timm, rhinodevel, 2020mar24

; ---------------------------------------------
; --- static keyboard layout (screen codes) ---
; ---------------------------------------------

keystat$ byte 1
         byte 1
         byte 21
         byte 'r', 'h', 'i', 'n', 'o', 'd', 'e', 'v', 'e', 'l'
         byte 39 ; '
         byte 's', ' ', 'k', 'e', 'y', 'b', 'o', 'a', 'r', 'd'
         
         byte 1
         byte 33
         byte 6
         byte '=', ' ', 'e', 'x', 'i', 't'

         byte 2
         byte 24
         byte 1
         byte '$'
         ;
         byte 3
         byte 26
         byte 1
         byte '/'
         ;
         byte 4
         byte 24
         byte 1
         byte '$'

         byte 3
         byte 33
         byte 6
         text '= rec.'

         byte 5
         byte 33
         byte 6
         text '= play'

         byte 7
         byte 33
         byte 1
         byte '='
         ;
         byte 7
         byte 36
         byte 1
         byte 'x'

         byte 9
         byte 33
         byte 6
         text '= loop'

         byte 11
         byte 33
         byte 6
         text '= vib.'

         byte 13
         byte 33
         byte 6
         text '= file'

         byte 3 ; char row / line nr. (0 - 24).
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
         byte ' ', 93, ' ', 93,' ', 93,' ', 93,' ', 93,' ', 93
          
         byte 5
         byte 1
         byte 17
         byte 85
         byte 113 ; 180 deg rotated T.
         byte 114, 113, 114, 113, 114, 113, 114, 113, 114, 113, 114, 113, 114
         byte 64, 73 

         byte 6
         byte 1
         byte 17
         byte 93, ' ', 93, ' ', 93, ' ', 93, ' ', 93, ' ', 93, ' ', 93, ' ', 93
         byte ' ', 93 

         byte 7
         byte 1
         byte 17
         byte 74 ; rounded bottom-left edge.
         byte 64, 113, 114, 113, 114, 113, 114, 113, 114, 113, 114, 113, 114
         byte 113, 114
         byte 75 ; rounded bottom-right edge.

         byte 8
         byte 4
         byte 13
         byte 93, ' ', 93, ' ', 93, ' ', 93, ' ', 93, ' ', 93, ' ', 93

         byte 9
         byte 3
         byte 22
         byte 85, 113, 114, 113, 114, 113, 114, 113, 114, 113, 114, 113, 114
         byte 113, 114, 64, 73
         byte 112 ; top-left edge.
         byte 64, 114, 64
         byte 110 ; top-right edge.

         byte 10
         byte 3
         byte 22
         byte 93, ' ', 93, ' ', 93, ' ', 93, ' ', 93, ' ', 93, ' ', 93, ' ', 93
         byte ' ', 93, 93, ' ', 93, ' ', 93

         byte 11
         byte 3
         byte 22
         byte 74, 64, 113, 64, 113, 64, 113, 64, 113, 64, 113, 64, 113
         byte 64, 113, 64, 75
         byte 109 ; bottom-left edge.
         byte 64, 113, 64
         byte 125 ; bottom-right edge.

         byte 24
         byte 0
         byte 4
         text 'v1.3'

;         byte 24
;         byte 32
;         byte 8
;         text 'basic v'
;basic_version$
;         byte '0' ; hack: to be filled by init().

         byte $ff ; end marker.