
; marcel timm, rhinodevel, 2020may12

; --------------------------------------------------------
; --- key x-positions on screen for 80 column machines ---
; --------------------------------------------------------

; - index equals screen (not petscii) code.
; - value of $ff means not supported.
;
keyposx80$
         byte $ff ; @
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
          byte $1f ; k
          byte $1f ; l
          byte $10 ; m
          byte $0e ; n
          byte $1f ; o
          byte $1f ; p
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
         byte $ff ; <left arrow>
         byte $ff ; <space>
         byte $ff ; !
         byte $ff ; <quotation mark>
         byte $ff ; #
         byte $ff ; $
         byte $ff ; %
         byte $ff ; &
         byte $ff ; '
         byte $ff ; (
         byte $ff ; )
         byte $ff ; *
         byte $ff ; +
          byte $12 ; ,
         byte $ff ; -
          byte $15 ; .
          byte $17 ; /
          byte $1f ; 0
         byte $ff ; 1
          byte $03 ; 2
          byte $05 ; 3
         byte $ff ; 4
          byte $09 ; 5
          byte $0b ; 6
          byte $0d ; 7
         byte $ff ; 8
         byte $ff ; 9
         byte $ff ; :
         byte $ff ; ;
         byte $ff ; <
         byte $ff ; =
         byte $ff ; >
         byte $ff ; ?

; --------------------------------------------------------
; --- key y-positions on screen for 80 column machines ---
; --------------------------------------------------------

; - index equals screen (not petscii) code.
; - value of $ff means not supported.
;
keyposy80$
         byte $ff ; @
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
          byte $07 ; k
          byte $09 ; l
          byte $0a ; m
          byte $0a ; n
          byte $03 ; o
          byte $05 ; p
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
         byte $ff ; <left arrow>
         byte $ff ; <space>
         byte $ff ; !
         byte $ff ; <quotation mark>
         byte $ff ; #
         byte $ff ; $
         byte $ff ; %
         byte $ff ; &
         byte $ff ; '
         byte $ff ; (
         byte $ff ; )
         byte $ff ; *
         byte $ff ; +
          byte $0a ; ,
         byte $ff ; -
          byte $0a ; .
          byte $0a ; /
          byte $01 ; 0
         byte $ff ; 1
          byte $04 ; 2
          byte $04 ; 3
         byte $ff ; 4
          byte $04 ; 5
          byte $04 ; 6
          byte $04 ; 7
         byte $ff ; 8
         byte $ff ; 9
         byte $ff ; :
         byte $ff ; ;
         byte $ff ; <
         byte $ff ; =
         byte $ff ; >
         byte $ff ; ?
