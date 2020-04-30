
; marcel timm, rhinodevel, 2020mar20

; ------------------------------------------------------
; --- decode table row of supported keyboard buttons ---
; ------------------------------------------------------

; - index equals screen (not petscii) code.
; - value of $ff means not supported.
; - not compatible with 8032.
;
key_row$ byte $ff ; @
         byte $ff ; a
         byte $06 ; b
         byte $06 ; c
         byte $04 ; d
         byte $02 ; e
         byte $ff ; f
         byte $04 ; g
         byte $05 ; h
         byte $03 ; i
         byte $04 ; j
         byte $ff ; k
         byte $ff ; l
         byte $06 ; m
         byte $07 ; n
         byte $ff ; o
         byte $ff ; p
         byte $02 ; q
         byte $03 ; r
         byte $05 ; s
         byte $02 ; t
         byte $02 ; u
         byte $07 ; v
         byte $03 ; w
         byte $07 ; x
         byte $03 ; y
         byte $06 ; z
         byte $ff ; [
         byte $ff ; \
         byte $ff ; ]
         byte $ff ; <up arrow>
         byte $00 ; <left arrow>
         byte $ff ; <space>
         byte $ff ; !
         byte $01 ; <quotation mark>
         byte $00 ; #
         byte $ff ; $
         byte $00 ; %
         byte $00 ; &
         byte $01 ; '
         byte $ff ; (
         byte $ff ; )
         byte $05 ; *
         byte $07 ; +
         byte $07 ; ,
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
         byte $06 ; ;
         byte $ff ; <
         byte $09 ; =
         byte $ff ; >
         byte $07 ; ?

; ----------------------------------------
; --- inverted keyboard decoding codes ---
; ----------------------------------------

; - index equals screen (not petscii) code.
; - value of $ff means not supported.
; - not compatible with 8032.
;
key_neg$ byte $ff ; @
         byte $ff ; a
         byte $04 ; b
         byte $02 ; c
         byte $02 ; d
         byte $02 ; e
         byte $ff ; f
         byte $04 ; g
         byte $04 ; h
         byte $08 ; i
         byte $08 ; j
         byte $ff ; k
         byte $ff ; l
         byte $08 ; m
         byte $04 ; n
         byte $ff ; o
         byte $ff ; p
         byte $01 ; q
         byte $02 ; r
         byte $01 ; s
         byte $04 ; t
         byte $08 ; u
         byte $02 ; v
         byte $01 ; w
         byte $01 ; x
         byte $04 ; y
         byte $01 ; z
         byte $ff ; [
         byte $ff ; \
         byte $ff ; ]
         byte $ff ; <up arrow>
         byte $20 ; <left arrow>
         byte $ff ; <space>
         byte $ff ; !
         byte $01 ; <quotation mark>
         byte $02 ; #
         byte $ff ; $
         byte $04 ; %
         byte $08 ; &
         byte $04 ; '
         byte $ff ; (
         byte $ff ; )
         byte $80 ; *
         byte $80 ; +
         byte $08 ; ,
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
         byte $10 ; ;
         byte $ff ; <
         byte $80 ; =
         byte $ff ; >
         byte $10 ; ?
