
; marcel timm, rhinodevel, 2020mar24

; ---------------------------------
; --- key x-positions on screen ---
; ---------------------------------

; - index equals screen (not petscii) code.
; - value of $ff means not supported.
;
keyposx$ byte $ff ; @
         byte $ff ; a
         byte $0c ; b
         byte $08 ; c
         byte $07 ; d
         byte $06 ; e
         byte $ff ; f
         byte $0b ; g
         byte $0d ; h
         byte $10 ; i
         byte $0f ; j
         byte $ff ; k
         byte $ff ; l
         byte $10 ; m
         byte $0e ; n
         byte $ff ; o
         byte $ff ; p
         byte $02 ; q
         byte $08 ; r
         byte $05 ; s
         byte $0a ; t
         byte $0e ; u
         byte $0a ; v
         byte $04 ; w
         byte $06 ; x
         byte $0c ; y
         byte $04 ; z
         byte $ff ; [
         byte $ff ; \
         byte $ff ; ]
         byte $ff ; <up arrow>
         byte $1f ; <left arrow>
         byte $ff ; <space>
         byte $ff ; !
         byte $03 ; <quotation mark>
         byte $05 ; #
         byte $ff ; $
         byte $09 ; %
         byte $0d ; &
         byte $0b ; '
         byte $ff ; (
         byte $ff ; )
         byte $ff ; *
         byte $ff ; +
         byte $12 ; ,
         byte $ff ; -
         byte $ff ; .
         byte $ff ; /
         byte $ff ; 0
         byte $ff ; 1
         byte $ff ; 2
         byte $ff ; 3
         byte $ff ; 4
         byte $ff ; 5
         byte $ff ; 6
         byte $ff ; 7
         byte $ff ; 8
         byte $ff ; 9
         byte $ff ; :
         byte $15 ; ;
         byte $ff ; <
         byte $ff ; =
         byte $ff ; >
         byte $17 ; ?

; ---------------------------------
; --- key y-positions on screen ---
; ---------------------------------

; - index equals screen (not petscii) code.
; - value of $ff means not supported.
;
keyposy$ byte $ff ; @
         byte $ff ; a
         byte $0a ; b
         byte $0a ; c
         byte $08 ; d
         byte $06 ; e
         byte $ff ; f
         byte $08 ; g
         byte $08 ; h
         byte $06 ; i
         byte $08 ; j
         byte $ff ; k
         byte $ff ; l
         byte $0a ; m
         byte $0a ; n
         byte $ff ; o
         byte $ff ; p
         byte $06 ; q
         byte $06 ; r
         byte $08 ; s
         byte $06 ; t
         byte $06 ; u
         byte $0a ; v
         byte $06 ; w
         byte $0a ; x
         byte $06 ; y
         byte $0a ; z
         byte $ff ; [
         byte $ff ; \
         byte $ff ; ]
         byte $ff ; <up arrow>
         byte $01 ; <left arrow>
         byte $ff ; <space>
         byte $ff ; !
         byte $04 ; <quotation mark>
         byte $04 ; #
         byte $ff ; $
         byte $04 ; %
         byte $04 ; &
         byte $04 ; '
         byte $ff ; (
         byte $ff ; )
         byte $ff ; *
         byte $ff ; +
         byte $0a ; ,
         byte $ff ; -
         byte $ff ; .
         byte $ff ; /
         byte $ff ; 0
         byte $ff ; 1
         byte $ff ; 2
         byte $ff ; 3
         byte $ff ; 4
         byte $ff ; 5
         byte $ff ; 6
         byte $ff ; 7
         byte $ff ; 8
         byte $ff ; 9
         byte $ff ; :
         byte $0a ; ;
         byte $ff ; <
         byte $ff ; =
         byte $ff ; >
         byte $0a ; ?
