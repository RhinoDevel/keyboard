
; marcel timm, rhinodevel, 2020mar24

; ----------------------------------------------------
; --- message to show after exiting (screen codes) ---
; ----------------------------------------------------

goodbye$ byte 4, 9, 21
         byte 146, 136, 137, 142, 143, 132, 133, 150, 133, 140
         byte 167 ; '
         byte 147, 160, 139, 133, 153, 130, 143, 129, 146, 132

         byte 6, 3, 34
         text '**********************************'

         byte 7, 2, 36
         text '*** goodbye and have a nice day! ***'

         byte 8, 3, 34
         text '**********************************'

         byte 10, 0, 39
         text '++ (c) 2022, rhinodevel, marcel timm ++'

         byte 12, 0, 40
         text '-- source code: github.com/rhinodevel --'

         byte 14, 2, 36
         text '--- contact: '
         byte 'm', 'a', 'r', 'c', '@'
         byte 'r', 'h', 'i', 'n', 'o', 'd', 'e', 'v', 'e', 'l', '.'
         byte 'c', 'o', 'm'
         text ' ---'

         byte 16, 2, 36
         text '--- website: www.rhinodevel.com  ---'

         byte 18, 0, 39
         text '>>> type run to return to keyboard. <<<'

         byte $ff ; end marker.