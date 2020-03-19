
; marcel timm, rhinodevel, 2020mar18

; -------------------------
; --- system properties ---
; -------------------------

line_len$ = 40 ; count of characters per line.

; --------------------------------------------------
; --- system memory locations (basic v2 / rev.3) ---
; --------------------------------------------------

;tapbufin$ = $bb ; tape buf. #1 & #2 indices to next char (2 bytes).
adptr$    = 15 ; term. width & lim. for scanning src. columns (2 unused bytes).

;cursor_y$ = $c4 ; lsb of cursor screen line mapped memory location.
;cursor_x$ = $c6 ; cursor position into the screen line.

sob$ = $0401 ; default start address of basic program / text area.
chrout$ = $ffd2 ; write a character to the screen.
chrin$ = $ffe4

screen_ram$ = $8000 ; start of video ram.