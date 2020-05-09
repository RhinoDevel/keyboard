
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
         byte $ff ; p
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
         byte $ff ; [
         byte $ff ; \
         byte $ff ; ]
         byte $ff ; <up arrow>
         byte $09 ; <left arrow>
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
         byte $ff ; -
         byte $ff ; .
         byte $08 ; /
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
         byte $02 ; ;
         byte $ff ; <
          byte $ff ; =
         byte $ff ; >
          byte $ffs ; ?

; ---------------------------------------------------------------
; --- inverted keyboard decoding codes for 80 column machines ---
; ---------------------------------------------------------------


; - index equals screen (not petscii) code.
; - value of $ff means not supported.
; - not compatible with 40 column machines.
;
; 7f bf df ef f7 fb fd fe ff
; 80 40 
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
         byte $80 ; /
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
