
; marcel timm, rhinodevel, 2020mar24

; ----------------------------------------------------
; --- message to show after exiting (screen codes) ---
; ----------------------------------------------------

goodbye$ byte 5, 3, 34
         text '**********************************'

         byte 6, 2, 36
         text '*** goodbye and have a nice day! ***'

         byte 7, 3, 34
         text '**********************************'

         byte 9, 2, 36
         text '--- contact: '
         byte 'm', 'a', 'r', 'c', '@'
         byte 'r', 'h', 'i', 'n', 'o', 'd', 'e', 'v', 'e', 'l', '.'
         byte 'c', 'o', 'm'
         text ' ---'

         byte 11, 2, 36
         text '--- website: www.rhinodevel.com  ---'

         byte 13, 1, 38
         text '>>> type run to return to keyboard <<<'

         byte $ff ; end marker.