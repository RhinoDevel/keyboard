
; marcel timm, rhinodevel, 2020mar23

; -------------------------------
; --- musical "notes" per key ---
; -------------------------------

; - index equals screen (not petscii) code.
; - value of 0 means not supported.
;
keynote$ byte $00 ; @
         byte $00 ; a
         byte 166 ; b * 1. G
         byte 198 ; c * 1. E
         byte 210 ; d * 1. D#
         byte  98 ; e * 2. E
         byte $00 ; f
         byte 176 ; g * 1. F# 
         byte 157 ; h * 1. G#
         byte  61 ; i * 3. C (highest note) 
         byte 139 ; j * 1. A#
         byte $00 ; k
         byte $00 ; l
         byte 132 ; m * 1. B
         byte 148 ; n * 1. A
         byte $00 ; o
         byte $00 ; p
         byte 124 ; q * 2. C (one of two buttons)
         byte  92 ; r * 2. F
         byte 236 ; s * 1. C#
         byte  82 ; t * 2. G
         byte  65 ; u * 2. B
         byte 187 ; v * 1. F 
         byte 110 ; w * 2. D
         byte 223 ; x * 1. D
         byte  73 ; y * 2. A
         byte 250 ; z * 1. C (lowest note)
         byte $00 ; [
         byte $00 ; \
         byte $00 ; ]
         byte $00 ; <up arrow>
         byte $00 ; <left arrow>
         byte $00 ; <space>
         byte $00 ; !
         byte 117 ; <quotation mark> * 2. C#
         byte 104 ; # * 2. D#
         byte $00 ; $
         byte  87 ; % * 2. F#
         byte  69 ; & * 2. A#
         byte  77 ; ' * 2. G#
         byte $00 ; (
         byte $00 ; )
         byte $00 ; *
         byte $00 ; +
         byte 124 ; , * 2. C (one of two buttons)
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
