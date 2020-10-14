
; rhinodevel, marcel timm, 2020sep25

; --------------
; --- macros ---
; --------------

; *********************************
; *** wait for retrace irq flag ***
; *********************************

defm wait_for_retrace_flag$
@wait_fl bit pia1ctrlb$ ; load bit 7 into n flag/bit of status register.
         bpl @wait_fl ; loop as long as flag is not set.
         ;
         ; flag cb1 is set to 1.
         ;
         bit pia1portb$ ; unset flag by reading port b.
         endm

; Keep these macros commented-out as reference (they do work on non-CRTC
; machines):
;
;; ****************************
;; *** wait for retrace irq ***
;; ****************************
;;
;; not reliable on cbm/pets with crtc, because signal state does not represent
;; the whole drawing or retrace time (its actually the vsync/vdrive signal on
;; crtc machines or maybe the inverted vsync/vdrive signal, not sure..).
;
;defm wait_for_retrace$
;@wait_ri lda via_b$
;         and #$20 ; bit 5 is retrace-in.
;         beq @wait_ri ; wait for bit 5 being 1.
;         endm
;
;; *******************************
;; *** wait for no retrace irq ***
;; *******************************
;;
;; not reliable on cbm/pets with crtc, because signal state does not represent
;; the whole drawing or retrace time (its actually the vsync/vdrive signal on
;; crtc machines or maybe the inverted vsync/vdrive signal, not sure..).
;
;defm wait_for_no_retrace$
;@waitnri lda via_b$
;         and #$20 ; bit 5 is retrace-in.
;         bne @waitnri ; wait for bit 5 being 0.
;         endm
