
; marcel timm, rhinodevel, 2020mar18

target TGT_PETBV2;TGT_PETBV4

; ---------------------------------------------------------
; --- system memory locations (basic v2 / rev.3 AND v4) ---
; ---------------------------------------------------------

adptr$ = 15 ; term. width & lim. for scanning src. columns (2 unused bytes).
fp_acc3$ = $54 ; "floating-point accumulator" nr. 3 (6 bytes).
;fp_acc1$ = $5e ; floating-point accumulator nr. 1 (6 bytes).
;fp_acc2$ = $66 ; floating-point accumulator nr. 2 (6 bytes).
keybufnum$ = $9e ; current number of characters in keyboard buffer.
utility$ = $a2 ; not used / utility (1 unused byte).
tapflag$ = $ab ; end of tape input flag / flag for tape write (1 byte).
tappari$ = $b1 ; tape character parity (1 byte).
receive$ = $b2 ; byte received flag (1 byte).
io_util$ = $b3 ; i/o utility / temporary save, e.g. by dos wedge (1 byte).
tapbufch$ = $b4 ; tape buffer character / mlm.
tapeutil$ = $ba ; tape utility (1 byte).
tapbufin$ = $bb ; tape buf. #1 & #2 indices to next char (2 bytes).
;cursor_y$ = $c4 ; lsb of cursor screen line mapped memory location.
;cursor_x$ = $c6 ; cursor position into the screen line.

sob$ = $0401 ; default start address of basic program / text area.

screen_ram$ = $8000 ; start of video ram.

pia1porta$ = $e810
pia1portb$ = $e812

timer1_low$ = $e844
timer1_high$ = $e845

timer2_low$ = $e848 ; low byte of timer 2.

via_shift$ = $e84a ; via's shift register.
via_acr$ = $e84b ; via's auxiliary control register.

via_pcr$ = $e84c ; via's peripheral control register.
;
; poke 59468, 12 for graphics mode.
; poke 59468, 14 for lower-case mode.

via_ifr$ = $e84d ; via's interrupt flag register.

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

endif ;TGT_PETBV4