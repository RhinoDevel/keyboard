
; marcel timm, rhinodevel, 2020mar23

; -------------------------------------------------------------
; --- musical notes' indices per key (see notes byte array) ---
; -------------------------------------------------------------

; - index equals screen (not petscii) code.
; - value of $ff means not supported.
; - holds some 40 & 80 column machine specific indices
;   (no problem, if no reuse of keys with different notes).
;
keynote$ byte $ff ; @
         byte $ff ; a
         byte  7 ; b * 1. g
         byte  4 ; c * 1. e
         byte  3 ; d * 1. d#
         byte 16 ; e * 2. e
         byte $ff ; f
         byte  6 ; g * 1. f# 
         byte  8 ; h * 1. g#
         byte 24 ; i * 3. c (highest note) 
         byte 10 ; j * 1. a#
         byte $ff ; k
         byte $ff ; l
         byte 11 ; m * 1. b
         byte  9 ; n * 1. a
         byte $ff ; o
         byte $ff ; p
         byte 12 ; q * 2. c (one of two buttons)
         byte 17 ; r * 2. f
         byte  1 ; s * 1. c#
         byte 19 ; t * 2. g
         byte 23 ; u * 2. b
         byte  5 ; v * 1. f 
         byte 14 ; w * 2. d
         byte  2 ; x * 1. d
         byte 21 ; y * 2. a
         byte  0 ; z * 1. c (lowest note)
         byte $ff ; [
         byte $ff ; \
         byte $ff ; ]
         byte $ff ; <up arrow>
         byte $ff ; <left arrow>
         byte $ff ; <space>
         byte $ff ; !
         byte 13 ; 40 columns: <quotation mark> * 2. c#
         byte 15 ; 40 columns: # * 2. d#
         byte $ff ; $
         byte 18 ; 40 columns: % * 2. f#
         byte 22 ; 40 columns: & * 2. a#
         byte 20 ; 40 columns: ' * 2. g#
         byte $ff ; (
         byte $ff ; )
         byte $ff ; *
         byte $ff ; +
         byte 12 ; , * 2. c (one of two buttons)
         byte $ff ; -
         byte $ff ; .
         byte $ff ; /
         byte $ff ; 0
         byte $ff ; 1
         byte 13 ; 80 columns: 2 * 2. c#
         byte 15 ; 80 columns: 3 * 2. d#
         byte $ff ; 4
         byte 18 ; 80 columns: 5 * 2. f#
         byte 20 ; 80 columns: 6 * 2. a#
         byte 22 ; 80 columns: 7 * 2. g#
         byte $ff ; 8
         byte $ff ; 9
         byte $ff ; :
         byte $ff ; ;
         byte $ff ; <
         byte $ff ; =
         byte $ff ; >
         byte $ff ; ?
