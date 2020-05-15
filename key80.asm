
; marcel timm, rhinodevel, 2020may09

; -----------------------------------------------------------------------------
; --- decode table row of supported keyboard buttons for 80 column machines ---
; -----------------------------------------------------------------------------

; - index equals screen (not petscii) code.
; - value of $ff means not supported.
; - not compatible with 40 column machines.
;
key80_row$ 
         byte $ff ; @
         byte $ff ; a
         byte $06 ; b
         byte $06 ; c
         byte $03 ; d
         byte $05 ; e
         byte $ff ; f
         byte $03 ; g
         byte $02 ; h
         byte $04 ; i
         byte $03 ; j
         byte $ff ; k
         byte $ff ; l
         byte $08 ; m
         byte $07 ; n
         byte $ff ; o
         byte $04 ; p
         byte $05 ; q
         byte $04 ; r
         byte $02 ; s
         byte $05 ; t
         byte $05 ; u
         byte $07 ; v
         byte $04 ; w
         byte $08 ; x
         byte $04 ; y
         byte $07 ; z
         byte $05 ; [
         byte $ff ; \
         byte $02 ; ]
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
         byte $07 ; ,
         byte $00 ; -
         byte $06 ; .
         byte $ff ; /
         byte $01 ; 0
         byte $ff ; 1
         byte $00 ; 2
         byte $09 ; 3
         byte $ff ; 4
         byte $00 ; 5
         byte $09 ; 6
         byte $01 ; 7
         byte $ff ; 8
         byte $09 ; 9
         byte $ff ; :
         byte $ff ; ;
         byte $ff ; <
         byte $ff ; =
         byte $ff ; >
         byte $ff ; ?

; ---------------------------------------------------------------
; --- inverted keyboard decoding codes for 80 column machines ---
; ---------------------------------------------------------------


; - index equals screen (not petscii) code.
; - value of $ff means not supported.
; - not compatible with 40 column machines.
;
; 7f bf df ef f7 fb fd fe ff
; 80 40 20 10 08 04 02 01 00
;
key80_neg$
         byte $ff ; @
         byte $ff ; a
         byte $04 ; b
         byte $02 ; c
         byte $02 ; d
         byte $02 ; e
         byte $ff ; f
         byte $04 ; g
         byte $08 ; h
         byte $20 ; i
         byte $08 ; j
         byte $ff ; k
         byte $ff ; l
         byte $08 ; m
         byte $04 ; n
         byte $ff ; o
         byte $40 ; p
         byte $01 ; q
         byte $04 ; r
         byte $02 ; s
         byte $04 ; t
         byte $08 ; u
         byte $02 ; v
         byte $02 ; w
         byte $02 ; x
         byte $08 ; y
         byte $01 ; z
         byte $40 ; [
         byte $ff ; \
         byte $10 ; ]
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
         byte $08 ; ,
         byte $08 ; -
         byte $08 ; .
         byte $ff ; /
         byte $08 ; 0
         byte $ff ; 1
         byte $01 ; 2
         byte $02 ; 3
         byte $ff ; 4
         byte $02 ; 5
         byte $04 ; 6
         byte $04 ; 7
         byte $ff ; 8
         byte $08 ; 9
         byte $ff ; :
         byte $ff ; ;
         byte $ff ; <
         byte $ff ; =
         byte $ff ; >
         byte $ff ; ?
