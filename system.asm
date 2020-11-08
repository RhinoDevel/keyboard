
; marcel timm, rhinodevel, 2020mar18

; toggle between these targets for v2/v4 or v1 assembly:
;
target TGT_PETBV2
;target TGT_NONE

ifdef TGT_PETBV2

; ---------------------------------------------------------
; --- system memory locations (basic v2 / rev.3 AND v4) ---
; ---------------------------------------------------------

adptr$ = $0f ; term. width & lim. for scanning src. columns (2 unused bytes).
tom$ = $34 ; pointer to top of memory / limit of basic.
;fp_acc3$ = $54 ; "floating-point accumulator" nr. 3 (6 bytes).
;fp_acc3_2$ = $54 + 2 ; inside floating-point accumulator nr. 3.
fp_acc1$ = $5e ; floating-point accumulator nr. 1 (6 bytes).
fp_acc1_2$ = $5e + 2 ; inside floating-point accumulator nr. 1.
;fp_acc1_4$ = $5e + 4 ; inside floating-point accumulator nr. 1.
;fp_acc2$ = $66 ; floating-point accumulator nr. 2 (6 bytes).
;fp_acc2_2$ = $66 + 2 ; inside floating-point accumulator nr. 2.
;fp_acc2_4$ = $66 + 4 ; inside floating-point accumulator nr. 2.
;keybufnum$ = $9e ; current number of characters in keyboard buffer.
;utility$ = $a2 ; not used / utility (1 unused byte).
;tapflag$ = $ab ; end of tape input flag / flag for tape write (1 byte).
;tappari$ = $b1 ; tape character parity (1 byte).
;receive$ = $b2 ; byte received flag (1 byte).
;io_util$ = $b3 ; i/o utility / temporary save, e.g. by dos wedge (1 byte).
;tapbufch$ = $b4 ; tape buffer character / mlm.
;tapeutil$ = $ba ; tape utility (1 byte).
;tapbufin$ = $bb ; tape buf. #1 & #2 indices to next char (2 bytes).
;cursor_y$ = $c4 ; lsb of cursor screen line mapped memory location.
;cursor_x$ = $c6 ; cursor position into the screen line.
tape_end$ = $c9 ; pointer to end addr. + 1 of bytes to store on tape (2 bytes).
fnamelen$ = $d1 ; length of file name (1 byte).
devicenr$ = $d4 ; current device nr. (1 byte).
fnameptr$ = $da ; pointer to start of filename (2 bytes).
tapesave$ = $fb ; pointer to start address of bytes to store on tape (2 bytes).

endif ;TGT_PETBV2

ifdef TGT_NONE

; ------------------------------------------
; --- system memory locations (basic v1) ---
; ------------------------------------------

adptr$ = $06 ; term. width & lim. for scanning src. columns (2 unused bytes).
tom$ = $86 ; pointer to top of memory / limit of basic.
;fp_acc3$ = $a6 ; "floating-point accumulator" nr. 3 (6 bytes).;
;fp_acc3_2$ = $a6 + 2 ; inside floating-point accumulator nr. 3.
fp_acc1$ = $b0 ; floating-point accumulator nr. 1 (6 bytes).
fp_acc1_2$ = $b0 + 2 ; inside floating-point accumulator nr. 1.
;fp_acc1_4$ = $b0 + 4 ; inside floating-point accumulator nr. 1.
;fp_acc2$ = $b8 ; floating-point accumulator nr. 2 (6 bytes).
;fp_acc2_2$ = $b8 + 2 ; inside floating-point accumulator nr. 2.
;fp_acc2_4$ = $b8 + 4 ; inside floating-point accumulator nr. 2.
;keybufnum$ = $020d ; current number of characters in keyboard buffer.
;utility$ = $021f ; not used / utility (1 unused byte).
;tapflag$ = $0228 ; end of tape input flag / flag for tape write (1 byte).
;tappari$ = $0265 ; tape character parity (1 byte).
;receive$ = $0266 ; byte received flag (1 byte).
;io_util$ =; i/o utility / temporary save, e.g. by dos wedge (1 byte).
;tapbufch$ = $e9 ; tape buffer character / mlm.
;tapeutil$ = $0270 ; tape utility (1 byte).
;tapbufin$ = $0271 ; tape buf. #1 & #2 indices to next char (2 bytes).
;cursor_y$ = $e0 ; lsb of cursor screen line mapped memory location.
;cursor_x$ = $e2 ; cursor position into the screen line.
tape_end$ = $e5 ; pointer to end addr. + 1 of bytes to store on tape (2 bytes).
fnamelen$ = $ee ; length of file name (1 byte).
devicenr$ = $f1 ; current device nr. (1 byte).
fnameptr$ = $f9 ; pointer to start of filename (2 bytes).
tapesave$ = $f7 ; pointer to start address of bytes to store on tape (2 bytes).

endif ;TGT_NONE

; --------------------------------------------------------------------
; --- system memory locations (basic v1 / basic v2 / rev.3 AND v4) ---
; --------------------------------------------------------------------

sob$ = $0401 ; default start address of basic program / text area.

screen_ram$ = $8000 ; start of video ram.

pia1porta$ = $e810
pia1portb$ = $e812
pia1ctrlb$ = $e813

;via_b$ = $e840 ; via port b.

timer1_low$ = $e844
timer1_high$ = $e845

timer2_low$ = $e848 ; low byte of timer 2.

via_shift$ = $e84a ; via's shift register.
via_acr$ = $e84b ; via's auxiliary control register.

via_pcr$ = $e84c ; via's peripheral control register.
;
; poke 59468, 12 for graphics mode (basic v2 / v4).
; poke 59468, 14 for lower-case mode (basic v2 / v4).

;via_ifr$ = $e84d ; via's interrupt flag register.

chrout$ = $ffd2 ; write a character to the screen.
chrin$ = $ffe4 ; get one character.

vec_nmi$ = $fffa
;vec_res$ = $fffc
;vec_irq$ = $fffe

; ------------------------------------------
; --- system memory locations (basic v1) ---
; ------------------------------------------

v1_cas_load$ = $f3a5 ; load from cassette.
v1_cas_save$ = $f6f6 ; save to cassette.

; ------------------------------------------
; --- system memory locations (basic v2) ---
; ------------------------------------------

v2_cas_load$ = $f395 ; load from cassette.
v2_cas_save$ = $f703 ; save to cassette.

; ------------------------------------------
; --- system memory locations (basic v4) ---
; ------------------------------------------

v4_graph_off$ = $e07a ; enable lower/upper case mode and add blanks betw. lines.
v4_graph_on$ = $e082 ; enable upper case / graphics mode and remove blanks.
v4_cas_load$ = $f3d4 ; load from cassette.
v4_cas_save$ = $f742 ; save to cassette.
