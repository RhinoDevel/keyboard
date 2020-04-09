
; marcel timm, rhinodevel, 2020mar23

; -------------------------------
; --- musical "notes" per key ---
; -------------------------------

; - index equals screen (not petscii) code.
; - value of 0 means not supported.
;
keynote$ byte $00 ; @
         byte $00 ; a
         byte 166 ; b * 1. g
         byte 198 ; c * 1. e
         byte 210 ; d * 1. d#
         byte  98 ; e * 2. e
         byte $00 ; f
         byte 176 ; g * 1. f# 
         byte 157 ; h * 1. g#
         byte  61 ; i * 3. c (highest note) 
         byte 139 ; j * 1. a#
         byte $00 ; k
         byte $00 ; l
         byte 132 ; m * 1. b
         byte 148 ; n * 1. a
         byte $00 ; o
         byte $00 ; p
         byte 124 ; q * 2. c (one of two buttons)
         byte  92 ; r * 2. f
         byte 236 ; s * 1. c#
         byte  82 ; t * 2. g
         byte  65 ; u * 2. b
         byte 187 ; v * 1. f 
         byte 110 ; w * 2. d
         byte 223 ; x * 1. d
         byte  73 ; y * 2. a
         byte 250 ; z * 1. c (lowest note)
         byte $00 ; [
         byte $00 ; \
         byte $00 ; ]
         byte $00 ; <up arrow>
         byte $00 ; <left arrow>
         byte $00 ; <space>
         byte $00 ; !
         byte 117 ; <quotation mark> * 2. c#
         byte 104 ; # * 2. d#
         byte $00 ; $
         byte  87 ; % * 2. f#
         byte  69 ; & * 2. a#
         byte  77 ; ' * 2. g#
         byte $00 ; (
         byte $00 ; )
         byte $00 ; *
         byte $00 ; +
         byte 124 ; , * 2. c (one of two buttons)
         byte $00 ; -
         byte $00 ; .
         byte $00 ; /
         byte $00 ; 0
         byte $00 ; 1
         byte $00 ; 2
         byte $00 ; 3
         byte $00 ; 4
         byte $00 ; 5
         byte $00 ; 6
         byte $00 ; 7
         byte $00 ; 8
         byte $00 ; 9
         byte $00 ; :
         byte $00 ; ;
         byte $00 ; <
         byte $00 ; =
         byte $00 ; >
         byte $00 ; ?
