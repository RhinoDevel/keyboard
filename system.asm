
; marcel timm, rhinodevel, 2020mar18

target TGT_PETBV2;TGT_PETBV4

; ---------------------------------------------------------
; --- system memory locations (basic v2 / rev.3 AND v4) ---
; ---------------------------------------------------------

adptr$ = 15 ; term. width & lim. for scanning src. columns (2 unused bytes).
tapbufin$ = $bb ; tape buf. #1 & #2 indices to next char (2 bytes).
;cursor_y$ = $c4 ; lsb of cursor screen line mapped memory location.
;cursor_x$ = $c6 ; cursor position into the screen line.

sob$ = $0401 ; default start address of basic program / text area.

screen_ram$ = $8000 ; start of video ram.

pia1porta$ = $e810
pia1portb$ = $e812

chrout$ = $ffd2 ; write a character to the screen.
chrin$ = $ffe4 ; get one character.

ifdef TGT_PETBV2

; -------------------------
; --- system properties ---
; -------------------------

line_len$ = 40 ; count of characters per line.

endif ;TGT_PETBV2

ifdef TGT_PETBV4 ; assuming 80 columns!!

; -------------------------
; --- system properties ---
; -------------------------

line_len$ = 80 ; count of characters per line.

endif ;TGT_PETBV2