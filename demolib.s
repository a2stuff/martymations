; da65 V2.19 - Git 6efe447d1
; Created:    2026-06-24 16:29:21
; Input file: DEMOLIB.BIN
; Page:       1


        .setcpu "6502"
        .org $8000

        .include "apple2.inc"

ptr_lo          := $0080
ptr_hi          := $0081
bc_row__decomp_col  := $0082
decomp_field        := $0084
decomp_dst_ptr_lo   := $0085
decomp_dst_ptr_hi   := $0086
data_byte       := $0087
rle_count       := $0088
prev_byte       := $0089
SELF_MODIFIED_ADDR:= $1F6F
FILE_A          := $4000
FILE_B          := $6000

ROM_WAIT        := $FCA8

kNumHiresRows = 192
kNumHiresCols = 40              ; bytes across

kNumTextRows  = 24
kNumTextCols  = 40

;;; ============================================================
;;; This chunk is not used for Martymations
;;; ============================================================

JumpTable1:
        jmp     JT1Ep1

        jmp     JT1Ep2

        jmp     JT1Ep3

        jmp     JT1Ep4

        jmp     JT1Ep5

        jmp     JT1Ep6

        jmp     JT1Ep7

        jmp     JT1Ep8

        jmp     JT1Ep9

L801B:  brk
        jmp     L8171

JT1Ep1: jsr     L84D3
        lda     #$00
        sta     decomp_op_index
        lda     #$60
        sta     decomp_src_hi
        jsr     RLEDecompress
        jsr     L8485
        ldx     #$06
L8034:  lda     L810E,x
        sta     L8909,x
        dex
        bpl     L8034
        jsr     L8903
        lda     #$40
        sta     current_row
        lda     #$44
        sta     L890C
        jsr     L8900
        lda     #$40
        sta     L8115
        jsr     L84EA
        lda     #$06
        jsr     L8499
        ldx     #$5F
        lda     #$07
        sta     L8909
        lda     #$1A
        sta     L890B
        lda     #$34
        sta     L890D
        lda     #$69
        sta     L890E
        stx     L810D
L8073:  ldx     #$00
L8075:  lda     hires_ytable_lo,x
        clc
        adc     #$07
        sta     L80A5
        lda     hires_ytable_hi,x
        and     #$1F
        ora     L8115
        sta     L80A6
        inx
        inx
        lda     hires_ytable_lo,x
        clc
        adc     #$07
        sta     L80A2
        lda     hires_ytable_hi,x
        and     #$1F
        ora     L8115
        sta     L80A3
        ldy     #$19
L80A1:
L80A2           := * + 1
L80A3           := * + 2
        lda     $2000,y
L80A5           := * + 1
L80A6           := * + 2
        sta     $2000,y
        dey
        bpl     L80A1
        dex
        cpx     #$83
        bne     L8075
        stx     current_row
        lda     #$02
        sta     L890C
        lda     L8115
        sta     hires_page
        jsr     L8900
        lda     L890D
        clc
        adc     #$1A
        sta     L890D
        bcc     L80CE
        inc     L890E
L80CE:  lda     L890D
        cmp     #$A2
        bne     L80E6
        lda     L890E
        cmp     #$71
        bne     L80E6
        lda     #$6A
        sta     L890D
        lda     #$70
        sta     L890E
L80E6:  lda     #$01
        ldy     #$10
        jsr     L8499
        ldx     #$00
        lda     L8115
        eor     #$60
        sta     L8115
        cmp     #$40
        beq     L80FC
        inx
L80FC:  lda     LOWSCR,x
        dec     L810D
        bmi     L8107
        jmp     L8073

L8107:  lda     #$06
        jsr     L8499
        rts

L810D:  .byte   $00
L810E:  .byte   $07,$41,$1A,$44,$00,$10,$20
L8115:  .byte   $00
JT1Ep2: jsr     L84D3
        lda     #$00
        sta     decomp_op_index
        lda     #$54
        sta     decomp_src_hi
        lda     #$20
        sta     decomp_dst_hi
        jsr     RLEDecompress
        jsr     L84EA
        lda     #$64
        sta     decomp_src_hi
        lda     #$40
        sta     decomp_dst_hi
        jsr     RLEDecompress
        jsr     FILE_B
        lda     $6003
        sta     L801B
        rts

JT1Ep3: jsr     L84D3
        lda     #$61
        sta     decomp_src_hi
        jsr     RLEDecompress
        jsr     L8485
        jsr     L84EA
        lda     #$04
        jsr     L8499
        lda     #$02
        sta     decomp_op_index
        lda     #$68
        sta     decomp_src_hi
        jsr     RLEDecompress
        jsr     L8485
        lda     #$06
        jsr     L8499
        rts

L8171:  lda     #$00
        sta     decomp_op_index
        lda     #$61
        sta     decomp_src_hi
        jsr     RLEDecompress
        jsr     FILE_B
        ldx     $6003
        lda     L81F8,x
        sta     L890D
        lda     L81FE,x
        sta     L890E
        lda     #$15
        sta     L8909
        lda     #$1A
        sta     current_row
        lda     #$0F
        sta     L890B
        lda     #$35
        sta     L890C
        jsr     L8900
        inc     $6003
        jsr     FILE_B
        lda     #$0F
        sta     L8909
        lda     #$0A
        sta     L890B
        lda     #$20
        sta     L890D
        asl     a
        sta     L890E
        lda     #$8D
        sta     L81F6
        lda     #$06
        sta     L81F7
L81CA:  lda     L81F6
        sta     current_row
        sec
        sbc     #$03
        sta     L81F6
        lda     L81F7
        sta     L890C
        clc
        adc     #$06
        sta     L81F7
        jsr     L8906
        inc     L890B
        inc     L890B
        dec     L8909
        bpl     L81CA
        lda     #$09
        jsr     L8499
        rts

L81F6:  .byte   $00
L81F7:  .byte   $00
L81F8:  .byte   $00,$60,$A0,$80,$40,$20
L81FE:  .byte   $6D,$76,$7C,$79,$73,$70
JT1Ep4: jsr     L84D3
        lda     #$00
        sta     decomp_op_index
        lda     #$63
        sta     decomp_src_hi
        lda     #$20
        sta     decomp_dst_hi
        jsr     RLEDecompress
        jsr     L84EA
        lda     #$04
        jsr     L8499
        jsr     FILE_B
        lda     #$06
        jsr     L8499
        rts

JT1Ep5: jsr     L84D3
        lda     #$00
        sta     decomp_op_index
        lda     #$20
        sta     decomp_dst_hi
        lda     L82C7
        sta     decomp_src_hi
        jsr     RLEDecompress
        jsr     L84EA
        lda     #$03
        jsr     L8499
        asl     decomp_dst_hi
L824B:  inc     L8467
        ldx     L8467
        lda     L82C7,x
        sta     decomp_src_hi
        jsr     RLEDecompress
        jsr     L828F
        lda     L801B
        bne     L826D
        lda     L8467
        cmp     #$03
        beq     L826E
        cmp     #$04
        bne     L824B
L826D:  rts

L826E:  ldy     #$08
        ldx     #$00
        lda     #$78
        sta     L827C
        sta     L827F
L827A:
L827C           := * + 2
        lda     $7830,x
L827F           := * + 2
        sta     $7800,x
        inx
        bne     L827A
        inc     L827C
        inc     L827F
        dey
        bne     L827A
        jmp     L824B

L828F:  ldx     #$00
L8291:  stx     L8468
        lda     L82CC,x
        sta     L8909
        lda     L82D2,x
        sta     current_row
        lda     #$0D
        sta     L890B
        lda     #$34
        sta     L890C
        lda     #$20
        sta     L890D
        lda     #$40
        sta     L890E
        lda     #$02
        ldy     #$80
        jsr     L8499
        jsr     L8906
        ldx     L8468
        inx
        cpx     #$06
        bne     L8291
        rts

L82C7:  .byte   $59,$60,$68,$70,$78
L82CC:  .byte   $00,$0D,$1A,$00,$0D,$1A
L82D2:  .byte   $58,$8C,$58,$8C,$58,$8C
JT1Ep6: jsr     L84D3
L82DB:  ldx     L8467
        lda     L8309,x
        sta     decomp_src_hi
        txa
        beq     L82E9
        lda     #$01
L82E9:  sta     decomp_op_index
        jsr     RLEDecompress
        jsr     L8485
        lda     #$01
        tay
        jsr     L8499
        jsr     L84EA
        inc     L8467
        lda     L8467
        cmp     #$08
        bne     L82DB
        jsr     L8499
        rts

L8309:  rts

        .byte   $63,$66,$67,$69,$6C,$6D,$6E
JT1Ep7: jsr     L84D3
        jsr     L84BD
        jsr     L84EA
        lda     #$02
        sta     L834C
L831F:  lda     #$8C
        sta     L8A05
        lda     #$00
        sta     L8A06
        ldx     L834C
        lda     L834D,x
        sta     L8A07
        lda     L8350,x
        sta     L8A0C
        lda     L8353,x
        sta     L8A0D
        jsr     L8A00
        dec     L834C
        bpl     L831F
        lda     #$04
        jsr     L8499
        rts

L834C:  .byte   $00
L834D:  .byte   $80,$50,$20
L8350:  .byte   $63,$5E,$56
L8353:  .byte   $83,$83,$83,$54,$59,$50,$45,$20
        .byte   $49,$4E,$00,$59,$4F,$55,$52,$00
        .byte   $4D,$45,$53,$53,$41,$47,$45,$2E
        .byte   $2E,$2E,$00
JT1Ep8: jsr     L84D3
        jsr     L84BD
        jsr     L84EA
        lda     #$60
        sta     decomp_src_hi
        lda     #$00
        sta     decomp_op_index
        jsr     RLEDecompress
        lda     #$40
        sta     hires_page
        lda     #$00
        sta     L890D
        lda     #$05
        sta     L8467
L8393:  ldx     L8467
        lda     L843D,x
        sta     L845B,x
        lda     L8443,x
        sta     L8461,x
        lda     L8425,x
        tay
        lda     L842B,x
        jsr     L840B
        jsr     L8903
        dec     L8467
        bpl     L8393
        lda     #$11
        sta     L8468
        lda     #$20
        sta     hires_page
L83BE:  lda     #$05
        sta     L8467
L83C3:  ldx     L8467
        lda     L845B,x
        tay
        lda     L8461,x
        jsr     L840B
        jsr     L8900
        dec     L8467
        bpl     L83C3
        lda     #$01
        ldy     #$40
        jsr     L8499
        ldx     #$05
        stx     L8467
L83E4:  ldx     L8467
        lda     L845B,x
        clc
        adc     L8449,x
        sta     L845B,x
        lda     L8461,x
        clc
        adc     L844F,x
        sta     L8461,x
        dec     L8467
        bpl     L83E4
        dec     L8468
        bne     L83BE
        lda     #$06
        jsr     L8499
        rts

L840B:  sta     current_row
        tya
        sta     L8909
        lda     L8431,x
        sta     L890B
        lda     L8437,x
        sta     L890C
        lda     L8455,x
        sta     L890E
        rts

L8425:  .byte   $03,$11,$00,$11,$03,$13
L842B:  .byte   $31,$31,$54,$54,$72,$72
L8431:  .byte   $0C,$15,$10,$17,$10,$12
L8437:  .byte   $1E,$1E,$19,$19,$1E,$1E
L843D:  .byte   $F3,$21,$F0,$31,$F3,$23
L8443:  .byte   $E1,$E1,$54,$54,$C2,$C2
L8449:  .byte   $01,$FF,$01,$FE,$01,$FF
L844F:  .byte   $05,$05,$00,$00,$FB,$FB
L8455:  .byte   $60,$62,$65,$67,$6A,$6D
L845B:  .byte   $00,$00,$00,$00,$00,$00
L8461:  .byte   $00,$00,$00,$00,$00,$00
L8467:  .byte   $00
L8468:  .byte   $00
JT1Ep9: jsr     L84D3
        lda     #$00
        sta     decomp_op_index
        lda     #$60
        sta     decomp_src_hi
        jsr     RLEDecompress
        jsr     L8485
        jsr     L84EA
        lda     #$08
        jsr     L8499
        rts

L8485:  ldx     #$05
L8487:  lda     L8493,x
        sta     L8909,x
        dex
        bpl     L8487
        jmp     L8906

L8493:  brk
        brk
        plp
        cpy     #$20
        rti

L8499:  dex
        bne     L8499
        dey
        bne     L8499
        pha
        lda     KBD
        bpl     L84AC
        sta     KBDSTRB
        cmp     #$81
        beq     L84B3
L84AC:  pla
        sec
        sbc     #$01
        bne     L8499
        rts

L84B3:  pla
        inc     L801B
        lda     LOWSCR
        pla
        pla
        rts

L84BD:  lda     #$20
        sta     L84C8
        tax
        lda     #$00
        tay
L84C6:
L84C8           := * + 2
        sta     $2000,y
        iny
        bne     L84C6
        inc     L84C8
        dex
        bne     L84C6
        rts

L84D3:  jsr     ClearTextScreen
        lda     TXTSET
        lda     #$00
        sta     L801B
        sta     L8467
        sta     KBDSTRB
        lda     #$40
        sta     decomp_dst_hi
        rts

L84EA:  lda     TXTCLR
        lda     MIXCLR
        lda     HIRES
        rts

        .byte   $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
        .byte   $A0,$A0,$A0,$A0


;;; ============================================================
;;; Martymations
;;; ============================================================

;;; First entry point - this decompresses the two screens from $4000
;;; to $2000 and from $6000 to $4000.

AnimInit:
        jmp     AnimInitImpl

;;; Second entry point - this runs the animation for several frames.
;;; On exit, `anim_result` is set to non-zero if Escape was pressed.

AnimRun:
        jmp     AnimRunImpl

anim_result:
        .byte   $00
anim_counter:
        .byte   $00
anim_save_x:
        .byte   $00

;;; Initialize the animation - clear the screen and decompress both frames

AnimInitImpl:
        ;; Clear and display the text screen while decompressing
        jsr     ClearTextScreen
        lda     TXTSET

        ;; Decompress PICnA
        lda     #$20
        sta     decomp_dst_hi
        lda     #$40
        sta     decomp_src_hi
        lda     #$00
        sta     decomp_op_index
        jsr     RLEDecompress

        ;; Show decompressed PICnA
        lda     TXTCLR
        lda     MIXCLR
        lda     HIRES
        lda     #$F0
        jsr     ROM_WAIT

        ;; Decompress PICnB, and exit
        lda     #$40
        sta     decomp_dst_hi
        lda     #$60
        sta     decomp_src_hi
        jmp     RLEDecompress

;;; Run the animation

AnimRunImpl:
        ;; Set up the page to operate on
        ldy     #$40
        sty     page_hi
        ldx     #$00
        stx     anim_result
        inx
        lda     TXTCLR
        lda     MIXCLR
        lda     HIRES

AnimRunLoop:
        ;; Flip pages (to show and to cycle)
        lda     LOWSCR,x
        txa
        eor     #$01
        tax
        lda     page_hi
        eor     #$60
        sta     page_hi
        stx     anim_save_x
        lda     #$11
        jsr     ROM_WAIT

        ;; Run the color cycling animation
        jsr     ByteCycleHiresPage

        ;; Keypress?
        lda     KBD
        bpl     :+
        sta     KBDSTRB
        cmp     #$81            ; Ctrl+A
        beq     AnimExit
        cmp     #$9B            ; Escape
        beq     AnimExit
:
        ;; Keep going?
        ldx     anim_save_x
        dec     anim_counter
        bne     AnimRunLoop
        rts

AnimExit:
        lda     LOWSCR
        inc     anim_result
        rts

;;; ============================================================
;;; Color Cycling
;;; ============================================================

        ;; Unused
        .byte   $00

page_hi:.byte   $20
starting_row_or_bits:
        .byte   $01
starting_col:
        .byte   $00
starting_row:
        .byte   $00
ending_col:
        .byte   $28
ending_row:
        .byte   $C0

        ;; Unused
        .byte   $80,$55,$2A,$80,$2A,$55

ByteCycleHiresPage:
        lda     starting_row
        ora     starting_row_or_bits
        tay
ByteCycleRowLoop:
        sty     bc_row__decomp_col
        lda     hires_ytable_hi,y
        and     #$1F
        ora     page_hi
        sta     ptr_hi
        lda     hires_ytable_lo,y
        sta     ptr_lo
        ldy     starting_col
ByteCycleColLoop:
        lda     (ptr_lo),y
        tax
        lda     even_byte_anim_table,x
        sta     (ptr_lo),y
        iny
        asl     a
        asl     a
        lda     (ptr_lo),y
        bcs     :+
        eor     #$01
:
        tax
        lda     odd_byte_anim_table,x
        sta     (ptr_lo),y
        iny
        cpy     ending_col
        bne     ByteCycleColLoop
        ldy     bc_row__decomp_col
        iny
        iny
        cpy     ending_row
        bcc     ByteCycleRowLoop
        rts

even_byte_anim_table:
        .byte   $55,$56,$57,$54,$59,$5A,$5B,$58
        .byte   $5D,$5E,$5F,$5C,$51,$52,$53,$50
        .byte   $65,$66,$67,$64,$69,$6A,$6B,$68
        .byte   $6D,$6E,$6F,$6C,$61,$62,$63,$60
        .byte   $75,$76,$77,$74,$79,$7A,$7B,$78
        .byte   $7D,$7E,$7F,$7C,$71,$72,$73,$70
        .byte   $45,$46,$47,$44,$49,$4A,$4B,$48
        .byte   $4D,$4E,$4F,$4C,$41,$42,$43,$40
        .byte   $15,$16,$17,$14,$19,$1A,$1B,$18
        .byte   $1D,$1E,$1F,$1C,$11,$12,$13,$10
        .byte   $25,$26,$27,$24,$29,$2A,$2B,$28
        .byte   $2D,$2E,$2F,$2C,$21,$22,$23,$20
        .byte   $35,$36,$37,$34,$39,$3A,$3B,$38
        .byte   $3D,$3E,$3F,$3C,$31,$32,$33,$30
        .byte   $05,$06,$07,$04,$09,$0A,$0B,$08
        .byte   $0D,$0E,$0F,$0C,$01,$02,$03,$00
        .byte   $D5,$D6,$D7,$D4,$D9,$DA,$DB,$D8
        .byte   $DD,$DE,$DF,$DC,$D1,$D2,$D3,$D0
        .byte   $E5,$E6,$E7,$E4,$E9,$EA,$EB,$E8
        .byte   $ED,$EE,$EF,$EC,$E1,$E2,$E3,$E0
        .byte   $F5,$F6,$F7,$F4,$F9,$FA,$FB,$F8
        .byte   $FD,$FE,$FF,$FC,$F1,$F2,$F3,$F0
        .byte   $C5,$C6,$C7,$C4,$C9,$CA,$CB,$C8
        .byte   $CD,$CE,$CF,$CC,$C1,$C2,$C3,$C0
        .byte   $95,$96,$97,$94,$99,$9A,$9B,$98
        .byte   $9D,$9E,$9F,$9C,$91,$92,$93,$90
        .byte   $A5,$A6,$A7,$A4,$A9,$AA,$AB,$A8
        .byte   $AD,$AE,$AF,$AC,$A1,$A2,$A3,$A0
        .byte   $B5,$B6,$B7,$B4,$B9,$BA,$BB,$B8
        .byte   $BD,$BE,$BF,$BC,$B1,$B2,$B3,$B0
        .byte   $85,$86,$87,$84,$89,$8A,$8B,$88
        .byte   $8D,$8E,$8F,$8C,$81,$82,$83,$80
odd_byte_anim_table:
        .byte   $2A,$2B,$2C,$2D,$2E,$2F,$28,$29
        .byte   $32,$33,$34,$35,$36,$37,$30,$31
        .byte   $3A,$3B,$3C,$3D,$3E,$3F,$38,$39
        .byte   $22,$23,$24,$25,$26,$27,$20,$21
        .byte   $4A,$4B,$4C,$4D,$4E,$4F,$48,$49
        .byte   $52,$53,$54,$55,$56,$57,$50,$51
        .byte   $5A,$5B,$5C,$5D,$5E,$5F,$58,$59
        .byte   $42,$43,$44,$45,$46,$47,$40,$41
        .byte   $6A,$6B,$6C,$6D,$6E,$6F,$68,$69
        .byte   $72,$73,$74,$75,$76,$77,$70,$71
        .byte   $7A,$7B,$7C,$7D,$7E,$7F,$78,$79
        .byte   $62,$63,$64,$65,$66,$67,$60,$61
        .byte   $0A,$0B,$0C,$0D,$0E,$0F,$08,$09
        .byte   $12,$13,$14,$15,$16,$17,$10,$11
        .byte   $1A,$1B,$1C,$1D,$1E,$1F,$18,$19
        .byte   $02,$03,$04,$05,$06,$07,$00,$01
        .byte   $AA,$AB,$AC,$AD,$AE,$AF,$A8,$A9
        .byte   $B2,$B3,$B4,$B5,$B6,$B7,$B0,$B1
        .byte   $BA,$BB,$BC,$BD,$BE,$BF,$B8,$B9
        .byte   $A2,$A3,$A4,$A5,$A6,$A7,$A0,$A1
        .byte   $CA,$CB,$CC,$CD,$CE,$CF,$C8,$C9
        .byte   $D2,$D3,$D4,$D5,$D6,$D7,$D0,$D1
        .byte   $DA,$DB,$DC,$DD,$DE,$DF,$D8,$D9
        .byte   $C2,$C3,$C4,$C5,$C6,$C7,$C0,$C1
        .byte   $EA,$EB,$EC,$ED,$EE,$EF,$E8,$E9
        .byte   $F2,$F3,$F4,$F5,$F6,$F7,$F0,$F1
        .byte   $FA,$FB,$FC,$FD,$FE,$FF,$F8,$F9
        .byte   $E2,$E3,$E4,$E5,$E6,$E7,$E0,$E1
        .byte   $8A,$8B,$8C,$8D,$8E,$8F,$88,$89
        .byte   $92,$93,$94,$95,$96,$97,$90,$91
        .byte   $9A,$9B,$9C,$9D,$9E,$9F,$98,$99
        .byte   $82,$83,$84,$85,$86,$87,$80,$81

        ;; Unused???
        .byte   $85,$86,$87,$80,$81,$A0,$A0,$A0
        .byte   $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
        .byte   $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
        .byte   $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
        .byte   $A0,$A0,$A0,$A0,$A0,$A0,$A0

;;; ============================================================
;;; RLE Decompressor
;;; ============================================================

;;; Set `decomp_src_hi` to the source address high byte (e.g. $40)
;;; Set `decomp_dst_hi` to the destination address high byte (e.g. $20)
;;; Set `decomp_op_index` to the raster operation:
;;;  0 = COPY (decompressed byte written directly to screen)
;;;  1 = OR   (decompressed byte OR'd with screen before writing)
;;;  1 = XOR  (decompressed byte XOR'd with screen before writing)

RLEDecompress:
        jmp     RLEDecompress_Impl

        ;; Unused?
        .byte   $60,$20,$00,$4C,$BB,$88,$4C,$BC
        .byte   $88

decomp_src_hi:
        .byte   $64
decomp_dst_hi:
        .byte   $40
decomp_op_index:
        .byte   $01

        kNumZPBytesToSave = 10
RLEDecompress_Impl:
        ldx     #kNumZPBytesToSave-1
:       lda     ptr_lo,x
        sta     save_zp_buffer
        dex
        bpl     :-

        jsr     RLEDecompress_Body

        ldx     #kNumZPBytesToSave-1
:       lda     save_zp_buffer,x
        sta     ptr_lo,x
        dex
        bpl     :-
        rts

RLEDecompress_Body:
        jsr     RLEDecompress_Prep
        lda     (ptr_lo),y
        sta     prev_byte
        inc     ptr_lo
RLEDecompress_DataLoop:
        lda     (ptr_lo),y
        cmp     prev_byte
        bne     RLEDecompress_DoByte
        inc     ptr_lo
        bne     :+
        inc     ptr_hi
:
        lda     (ptr_lo),y
        sta     rle_count
        inc     ptr_lo
        bne     :+
        inc     ptr_hi
:
        lda     (ptr_lo),y
        sta     data_byte
RLEDecompress_RepeatLoop:
        lda     data_byte
        dec     rle_count
RLEDecompress_DoByte:
        ldy     bc_row__decomp_col
decomp_smc1:
decomp_smc2         := * + 1
        ora     (decomp_dst_ptr_lo),y
        sta     (decomp_dst_ptr_lo),y
        inx
        inx
        cpx     #kNumHiresRows
        bcc     RLEDecompress_SetUpRow
        inc     bc_row__decomp_col
        ldy     bc_row__decomp_col
        cpy     #kNumHiresCols
        bcc     RLEDecompress_ColOK
        dec     decomp_field
        bmi     RLEDecompress_Exit
        ldy     #$00
        sty     bc_row__decomp_col
RLEDecompress_ColOK:
        ldx     decomp_field
RLEDecompress_SetUpRow:
        lda     hires_ytable_lo,x
        sta     decomp_dst_ptr_lo
        lda     hires_ytable_hi,x
        and     #$1F
        ora     decomp_dst_hi
        sta     decomp_dst_ptr_hi
        ldy     rle_count
        bne     RLEDecompress_RepeatLoop
        inc     ptr_lo
        bne     RLEDecompress_DataLoop
        inc     ptr_hi
        bne     RLEDecompress_DataLoop
RLEDecompress_Exit:
        rts

RLEDecompress_Prep:
        lda     decomp_dst_hi
        ora     #$04
        sta     decomp_dst_ptr_hi
        lda     decomp_src_hi
        sta     ptr_hi
        lda     decomp_op_index
        asl     a
        tax
        lda     instr_table,x
        sta     decomp_smc1
        lda     instr_table+1,x
        sta     decomp_smc2
        ldx     #$01
        stx     decomp_field
        ldy     #$00
        sty     bc_row__decomp_col
        sty     ptr_lo
        sty     decomp_dst_ptr_lo
        sty     rle_count
        rts

instr_table:
        nop                     ; index 0 - COPY to destination
        nop

        ora     ($85),y         ; index 1 - OR with destination

        eor     ($85),y         ; index 2 - XOR with destination

        ;; Unused
        .byte $60,$60,$60

        ;; Only `kNumZPBytesToSave` are used as a buffer; the
        ;; data here is not used.
save_zp_buffer:
        .byte   $50,$E8,$AA,$98,$69,$03,$A8,$EE
        .byte   $07,$89,$8A,$38,$E9,$64,$AA,$98
        .byte   $E9,$00,$A8,$B0,$F2,$CE,$07,$89
        .byte   $8A,$18,$69,$64,$AA,$EE,$08,$89
        .byte   $38,$E9,$0A,$B0,$F8,$CE,$08,$89
        .byte   $18,$69,$0A,$09,$30,$8D,$09,$89
        .byte   $A2,$00,$BD,$00,$89,$20,$45,$89
        .byte   $E8,$E0,$0A,$D0,$F5,$A9,$04,$8D
        .byte   $0F,$88,$60

;;; ============================================================
;;; This chunk is not used for Martymations
;;; ============================================================

L8900:  jmp     L8900Impl

L8903:  jmp     L8903Impl

L8906:
L8907           := * + 1
L8908           := * + 2
        jmp     L8997

L8909:  .byte   $00
current_row:
        .byte   $00
L890B:  .byte   $00
L890C:  .byte   $00
L890D:  .byte   $00
L890E:  .byte   $00
hires_page:
        .byte   $20
L8900Impl:
        jsr     L89D5
L8913:  ldx     current_row
        cpx     #kNumHiresRows
        bcs     L8944
        lda     hires_ytable_hi,x
        and     #$1F
        ora     hires_page
        sta     $C1
        lda     hires_ytable_lo,x
        sta     $C0
        lda     L8909
        clc
        adc     L890B
        tay
        ldx     L890B
L8934:  dey
        dex
        cpy     #kNumHiresCols
        bcs     L893F
L893B           := * + 1
L893C           := * + 2
        lda     JumpTable1,x
        sta     ($C0),y
L893F:  cpy     L8909
        bne     L8934
L8944:
L8945           := * + 1
        lda     L893B
        clc
        adc     L890B
        sta     L893B
        bcc     L8953
        inc     L893C
L8953:  inc     current_row
        dec     L890C
        bne     L8913
        jmp     L89CA

L8903Impl:
        jsr     L89D5
        ldx     current_row
L8964:  lda     hires_ytable_hi,x
        and     #$1F
        ora     hires_page
        sta     $C1
        lda     hires_ytable_lo,x
        clc
        adc     L8909
        sta     $C0
        ldy     L890B
        dey
L897B:  lda     ($C0),y
        sta     ($C2),y
        dey
        bpl     L897B
        lda     $C2
        clc
        adc     L890B
        sta     $C2
        bcc     L898E
        inc     $C3
L898E:  inx
        dec     L890C
        bne     L8964
        jmp     L89CA

L8997:  jsr     L89D5
        ldx     current_row
L899D:  lda     hires_ytable_hi,x
        and     #$1F
        ora     L890E
        sta     $C3
        and     #$1F
        ora     L890D
        sta     $C1
        lda     hires_ytable_lo,x
        clc
        adc     L8909
        sta     $C2
        sta     $C0
        ldy     L890B
        dey
L89BD:  lda     ($C2),y
        sta     ($C0),y
        dey
        bpl     L89BD
        inx
        dec     L890C
        bne     L899D
L89CA:  ldx     #$03
L89CC:  lda     L89F0,x
        sta     $C0,x
        dex
        bpl     L89CC
        rts

L89D5:  ldx     #$03
L89D7:  lda     $C0,x
        sta     L89F0,x
        dex
        bpl     L89D7
        lda     L890D
        sta     $C2
        sta     L893B
        lda     L890E
        sta     $C3
        sta     L893C
        rts

L89F0:  .byte   $00,$00,$00,$00,$C0,$4C,$BA,$89
        .byte   $44,$44,$44,$44,$00,$00,$00,$00
L8A00:  jmp     L8A12

L8A03:  .byte   $02
L8A04:  .byte   $02
L8A05:  .byte   $00
L8A06:  .byte   $00
L8A07:  .byte   $00
L8A08:  .byte   $00,$00
L8A0A:  .byte   $02
L8A0B:  .byte   $01
L8A0C:  .byte   $00
L8A0D:  .byte   $00,$00
        jmp     L8CBA

L8A12:  ldx     #$1F
L8A14:  lda     $C0,x
        sta     L95D0,x
        dex
        bpl     L8A14
        jsr     L8A2A
        ldx     #$1F
L8A21:  lda     L95D0,x
        sta     $C0,x
        dex
        bpl     L8A21
        rts

L8A2A:  lda     L8A0C
        sta     L8AE9
        lda     L8A0D
        sta     L8AEA
        jsr     L8BCE
        lda     L8A04
        beq     L8A9F
        ldx     #$00
        stx     $CF
        stx     $D0
L8A44:  jsr     L8AE8
        beq     L8A64
        sec
        sbc     #$20
        tay
        lda     FILE_B,y
        sec
        sbc     $0300,x
        clc
        adc     L8A0A
        adc     $CF
        sta     $CF
        bcc     L8A60
        inc     $D0
L8A60:  inx
        jmp     L8A44

L8A64:  cpx     #$00
        beq     L8A80
        lda     $CF
        sec
        sbc     L8A0A
        sta     $CF
        bcs     L8A74
        dec     $D0
L8A74:  ldx     L8A0B
        beq     L8A80
L8A79:  asl     $CF
        rol     $D0
        dex
        bne     L8A79
L8A80:  ldx     L8A04
        cpx     #$03
        beq     L8ADD
        dex
        beq     L8A8E
        lsr     $D0
        ror     $CF
L8A8E:  lda     L8A05
        sec
        sbc     $CF
        sta     L8A05
        lda     L8A06
        sbc     $D0
        sta     L8A06
L8A9F:  ldx     #$00
L8AA1:  stx     $CE
        jsr     L8AE8
        beq     L8AE7
        jsr     L8AEC
        lda     #$FF
        jsr     ROM_WAIT
        ldx     $CE
        jsr     L8AE8
        sec
        sbc     #$20
        tay
        lda     L8A0A
        clc
        adc     FILE_B,y
        inx
        sec
        sbc     $0300,x
        ldy     L8A0B
        beq     L8ACE
L8ACA:  asl     a
        dey
        bne     L8ACA
L8ACE:  clc
        adc     L8A05
        sta     L8A05
        bcc     L8AA1
        inc     L8A06
        jmp     L8AA1

L8ADD:  lda     $CF
        sta     L8A05
        lda     $D0
        sta     L8A06
L8AE7:  rts

L8AE8:
L8AE9           := * + 1
L8AEA           := * + 2
        lda     L8A0C,x
        rts

L8AEC:  sec
        sbc     #$20
        beq     L8B6B
        tax
        lda     $603B,x
        sta     $C7
        lda     FILE_B,x
        sta     $C9
        lda     $6076,x
        sta     $CC
        lda     $60B1,x
        sta     $CD
        lda     L8A0B
        asl     a
        bne     L8B0E
        lda     #$01
L8B0E:  sta     $C2
        lda     #$00
        sta     $CB
        lda     L8A07
        sta     $C5
        lda     L8A08
        sta     $C6
L8B1E:  lda     L8A05
        sta     $C3
        lda     L8A06
        sta     $C4
        lda     $C9
        sta     $C8
L8B2C:  ldy     $CB
        lda     ($CC),y
        ldx     #$08
        stx     $CA
L8B34:  asl     a
        pha
        jsr     L8B6C
        lda     $C3
        clc
        adc     $C2
        sta     $C3
        bcc     L8B44
        inc     $C4
L8B44:  pla
        dec     $C8
        beq     L8B56
        dec     $CA
        bne     L8B34
        inc     $CB
        bne     L8B2C
        inc     $CD
        jmp     L8B2C

L8B56:  lda     $C5
        clc
        adc     $C2
        sta     $C5
        bcc     L8B61
        inc     $C6
L8B61:  inc     $CB
        bne     L8B67
        inc     $CD
L8B67:  dec     $C7
        bne     L8B1E
L8B6B:  rts

L8B6C:  lda     L8A0B
        beq     L8BB0
        php
        asl     a
        sta     $C2
        sta     $D1
L8B77:  lda     $C2
        sta     $D0
L8B7B:  plp
        php
        jsr     L8BB0
        inc     $C3
        bne     L8B86
        inc     $C4
L8B86:  dec     $D0
        bne     L8B7B
        lda     $C3
        sec
        sbc     $C2
        sta     $C3
        lda     $C4
        sbc     #$00
        sta     $C4
        inc     $C5
        bne     L8B9D
        inc     $C6
L8B9D:  dec     $D1
        bne     L8B77
        plp
        lda     $C5
        sec
        sbc     $C2
        sta     $C5
        lda     $C6
        sbc     #$00
        sta     $C6
        rts

L8BB0:  ldx     L8A03
        bcs     L8BB8
        beq     L8BC4
        rts

L8BB8:  cpx     #$03
        beq     L8BC4
        jsr     L8CBA
        ora     ($C0),y
        sta     ($C0),y
        rts

L8BC4:  jsr     L8CBA
        eor     #$FF
        and     ($C0),y
        sta     ($C0),y
        rts

L8BCE:  ldx     #$00
        stx     $0300
L8BD3:  stx     $CE
        jsr     L8AE8
        beq     L8C00
        cmp     #$41
        bcc     L8BF5
        sta     $D6
        inx
        jsr     L8AE8
        beq     L8C00
        cmp     #$41
        bcc     L8BF5
        sta     $D7
        jsr     L8C06
        lda     $D9
        cmp     #$64
        bcc     L8BF7
L8BF5:  lda     #$00
L8BF7:  ldx     $CE
        inx
        sta     $0300,x
        jmp     L8BD3

L8C00:  lda     #$00
        sta     $0300,x
        rts

L8C06:  lda     $D6
        jsr     L8C68
        sta     $D4
        sty     $DA
        lda     $6076,x
        sta     $D0
        lda     $60B1,x
        sta     $D1
        lda     $603B,x
        sta     $C7
        lda     $D7
        jsr     L8C68
        sta     $D5
        lda     $6076,x
        sta     $D2
        lda     $60B1,x
        sta     $D3
        lda     $603B,x
        cmp     $C7
        bcs     L8C38
        sta     $C7
L8C38:  lda     #$64
        sta     $D9
L8C3C:  jsr     L8C80
        sta     $C2
        jsr     L8C9E
        clc
        adc     $C2
        cmp     $D9
        bcs     L8C4D
        sta     $D9
L8C4D:  lda     $D0
        clc
        adc     $D4
        sta     $D0
        bcc     L8C58
        inc     $D1
L8C58:  lda     $D2
        clc
        adc     $D5
        sta     $D2
        bcc     L8C63
        inc     $D3
L8C63:  dec     $C7
        bne     L8C3C
        rts

L8C68:  sec
        sbc     #$20
        tax
        lda     FILE_B,x
        sec
        sbc     #$01
        pha
        and     #$07
        eor     #$07
        tay
        pla
        lsr     a
        lsr     a
        lsr     a
        clc
        adc     #$01
        rts

L8C80:  ldx     #$00
        ldy     $D4
        dey
L8C85:  lda     ($D0),y
        bne     L8C94
        txa
        clc
        adc     #$08
        tax
        dey
        bpl     L8C85
        lda     #$64
        rts

L8C94:  inx
        lsr     a
        bcc     L8C94
        dex
        txa
        sec
        sbc     $DA
        rts

L8C9E:  ldx     #$00
        ldy     #$00
L8CA2:  lda     ($D2),y
        bne     L8CB3
        txa
        clc
        adc     #$08
        tax
        iny
        cpy     $D5
        bne     L8CA2
        lda     #$64
        rts

L8CB3:  inx
        asl     a
        bcc     L8CB3
        dex
        txa
        rts

L8CBA:  ldy     #$00
        jmp     L8CC3

L8CBF:  ldy     #$00
        tya
        rts

L8CC3:  ldy     $C5
        lda     hires_ytable_hi,y
        sta     $C1
        ldx     $C3
        lda     $C4
        beq     L8CDA
        cmp     #$01
        bne     L8CBF
        cpx     #$18
        bcs     L8CBF
        bcc     L8CE4
L8CDA:  lda     hires_xtable_mask,x
        pha
        lda     hires_xtable_byte,x
        jmp     L8CEB

L8CE4:  lda     hires_xtable_mask2,x
        pha
        lda     hires_xtable_byte2,x
L8CEB:  clc
        adc     hires_ytable_lo,y
        sta     $C0
        pla
        ldy     #$00
        rts

        clc
        adc     hires_ytable_lo,y
        sta     $C0
        pla
        ldy     #$00
        rts

        lda     $C3
        sta     $C0
        lda     hires_xtable_mask,x
        rts

L8D07:  ldy     #$00
        tya
        rts

        ldy     $C5
        lda     hires_ytable_hi,y
        sta     $C1
        ldx     $C3
        lda     $C4
        beq     L8D22
        cmp     #$01
        bne     L8D07
        cpx     #$18
        bcs     L8D07
        bcc     L8D2C
L8D22:  lda     hires_xtable_mask,x
        pha
        lda     hires_xtable_byte,x
        jmp     L8D33

L8D2C:  lda     hires_xtable_mask2,x
        pha
        lda     hires_xtable_byte2,x
L8D33:  clc
        adc     hires_ytable_lo,y
        sta     $C0
        pla
        ldy     #$00
        rts

        lda     $C3
        sta     $C0
        lda     $C4
        sta     $C1
        asl     $C0
        rol     $C1
        asl     $C0
        rol     $C1
        lda     $C0
        clc
        adc     $C3
        sta     $C0
        lda     $C1
        adc     $C4
        sta     $C1
        lda     $C5
        lsr     a
        lsr     a
        lsr     a
        clc
        adc     $C0
        sta     $C0
        lda     $C1
        adc     #$20
        sta     $C1
        lda     $C5
        and     #$07
        tax
        lda     L8D73,x
        rts

L8D73:  .byte   $80,$40,$20,$10,$08,$04,$02,$01
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00


;;; ============================================================
;;; Clear the Text Screen - used by Martymations
;;; ============================================================

ClearTextScreen:
        jmp     ClearTextScreenImpl

        ;; ???
        jmp     L8E17

        ;; ???
        jmp     L8E27

L8E09:  .byte   $00
L8E0A:  .byte   $16
L8E0B:  .byte   $8D
L8E0C:  .byte   $1F
L8E0D:  .byte   $00
L8E0E:  .byte   $80
L8E0F:  .byte   $00
        jmp     L8FA6

L8E13:  .byte   $01
        jmp     L8FED

L8E17:  lda     $08
        pha
        lda     $09
        pha
        jsr     L8E58
Restore08:
        pla
        sta     $09
        pla
        sta     $08
        rts

L8E27:  lda     $08
        pha
        lda     $09
        pha
        jsr     L8E95
        jmp     Restore08

ClearTextScreenImpl:
        lda     $08
        pha
        lda     $09
        pha
        jsr     ClearTextScreenTrash08
        jmp     Restore08

ClearTextScreenTrash08:
        ldx     #kNumTextRows - 1
L8E41:  lda     text_ytable_lo,x
        sta     $08
        lda     text_ytable_hi,x
        sta     $09
        ldy     #kNumTextCols - 1
        lda     #' ' | $80
:       sta     ($08),y
        dey
        bpl     :-
        dex
        bpl     L8E41
        rts

;;; None of this next chunk is used by Martymations

L8E58:  ldx     L8E0A
        lda     text_ytable_lo,x
        sta     $08
        lda     text_ytable_hi,x
        sta     $09
        lda     L8E0B
        sta     selfmodifiedstorebyx_lo
        sta     selfmodifiedloadbyx_lo
        lda     L8E0C
        sta     selfmodifiedstorebyx_hi
        sta     selfmodifiedloadbyx_hi
        ldy     L8E09
        ldx     #$00
        stx     L8E0F
L8E7F:  jsr     SelfModifiedLoadByX
        beq     L8E94
        and     #$3F
        ora     L8E0E
        sta     ($08),y
        inx
        jsr     L8F54
        cpx     L8E0D
        bne     L8E7F
L8E94:  rts

L8E95:  jsr     L8E58
IgnoreKey:
        tya
        pha
        lda     L8E0D
        cmp     #$3C
        bne     L8EA7
        jsr     L8F90
        jmp     L8EB0

L8EA7:  clc
        adc     L8E09
        tay
        lda     #$BC
        sta     ($08),y
L8EB0:  pla
        tay
        lda     L8E0D
        beq     L8EC2
        lda     ($08),y
        and     #$3F
        ora     #$40
        sta     ($08),y
        jmp     L8EC6

L8EC2:  lda     #$60
        sta     ($08),y
L8EC6:  jsr     L8FED
        bne     L8ED0
        lda     KBD
        bpl     L8EC6
L8ED0:  and     #$7F
        sta     KBDSTRB
        cmp     #$7F
        beq     OnKeyBackspace
        cmp     #$60
        bcc     DoneCaseAdjust
        and     #$DF
DoneCaseAdjust:
        cmp     #$08
        beq     OnKeyBackspace
        cmp     #$18
        beq     OnKeyCtrlX
        cmp     #$0D
        beq     OnKeyReturn
        cmp     #$20
        bcc     OnKeySpace
        cmp     #$5B
        bcs     IgnoreKey
        cpx     L8E0D
        bcc     L8EFE
        bne     IgnoreKey
        cpx     #$00
        bne     IgnoreKey
L8EFE:  jsr     SelfModifiedStoreByX
        and     #$3F
        ora     L8E0E
        sta     ($08),y
        inx
        jsr     L8F54
        lda     L8E0D
        beq     OnKeyReturn
        jmp     IgnoreKey

OnKeyBackspace:
        jsr     L8F1A
        jmp     IgnoreKey

L8F1A:  cpx     #$00
        beq     L8F2F
        dex
        lda     #$00
        jsr     SelfModifiedStoreByX
        lda     #$A0
        sta     ($08),y
        jsr     L8F79
        lda     #$A0
        sta     ($08),y
L8F2F:  rts

OnKeyCtrlX:
        jsr     L8F1A
        cpx     #$00
        bne     OnKeyCtrlX
        jmp     IgnoreKey

OnKeySpace:
        sta     L8E0F
OnKeyReturn:
        lda     ($08),y
        eor     #$C0
        sta     ($08),y
L8F43:  lda     #$00
        jsr     SelfModifiedStoreByX
        dex
        bmi     L8F52
        jsr     SelfModifiedLoadByX
        cmp     #$20
        beq     L8F43
L8F52:  inx
        rts

L8F54:  iny
        cpy     #$25
        bne     L8F78
        lda     L8E0D
        cmp     #$3C
        bne     L8F78
L8F60:  ldy     L8E0A
        iny
        lda     text_ytable_lo,y
        cmp     $08
        beq     L8F76
        sta     $08
        lda     text_ytable_hi,y
        sta     $09
        ldy     L8E09
        rts

L8F76:  ldy     #$25
L8F78:  rts

L8F79:  dey
        cpy     L8E09
        bcc     L8F80
        rts

L8F80:  ldy     L8E0A
        lda     text_ytable_lo,y
        sta     $08
        lda     text_ytable_hi,y
        sta     $09
        ldy     #$24
        rts

L8F90:  lda     $08
        pha
        lda     $09
        pha
        jsr     L8F60
        lda     #$BC
        ldy     #$25
        sta     ($08),y
        pla
        sta     $09
        pla
        sta     $08
        rts

L8FA6:  stx     L8E0B
        sty     L8E0C
        sta     L8E0A
        lda     #$00
        sta     L8E09
        ldx     #$28
        sta     L8E0D
        lda     #$01
        sta     L8FEC
L8FBE:  lda     L8FEC
        ldx     #$80
        cmp     L8E13
        bne     L8FCA
        ldx     #$00
L8FCA:  stx     L8E0E
        jsr     L8E17
        inx
        txa
        clc
        adc     L8E0B
        sta     L8E0B
        bcc     L8FDE
        inc     L8E0C
L8FDE:  inc     L8E0A
        inc     L8FEC
        jsr     SelfModifiedLoadByX
        cmp     #$FF
        bne     L8FBE
        rts

L8FEC:  php
L8FED:  stx     L903C
        sty     L903D
        ldx     #$01
L8FF5:  lda     BUTN0,x
        and     #$80
        sta     btn_flags,x
        ldy     #$00
L8FFF:  lda     BUTN0,x
        and     #$80
        cmp     btn_flags,x
        bne     L8FF5
        iny
        bne     L8FFF
        lda     btn_flags,x
        bpl     L9025
        lda     L9038,x
        beq     L902A
        dec     L9038,x
        lda     L903A,x
        ldx     L903C
        ldy     L903D
        pha
        pla
        rts

L9025:  lda     #$01
        sta     L9038,x
L902A:  dex
        bpl     L8FF5
        ldx     L903C
        ldy     L903D
        lda     #$00
        rts

btn_flags:
        .byte   $00,$00
L9038:  .byte   $00,$00
L903A:  .byte   $0D,$1B
L903C:  .byte   $00
L903D:  .byte   $85
SelfModifiedStoreByX:
selfmodifiedstorebyx_lo:= * + 1
selfmodifiedstorebyx_hi:= * + 2
        sta     SELF_MODIFIED_ADDR,x
        rts

SelfModifiedLoadByX:
selfmodifiedloadbyx_lo:= * + 1
selfmodifiedloadbyx_hi:= * + 2
        lda     SELF_MODIFIED_ADDR,x
        rts

        ;; Used by `ClearTextScreen`

text_ytable_lo:
        .byte   $00,$80,$00,$80,$00,$80,$00,$80
        .byte   $28,$A8,$28,$A8,$28,$A8,$28,$A8
        .byte   $50,$D0,$50,$D0,$50,$D0,$50,$D0
text_ytable_hi:
        .byte   $04,$04,$05,$05,$06,$06,$07,$07
        .byte   $04,$04,$05,$05,$06,$06,$07,$07
        .byte   $04,$04,$05,$05,$06,$06,$07,$07

        ;; ???
        .byte   $02,$E6,$C3,$E8,$CE,$0C,$90,$D0
        .byte   $D0,$4C,$00,$40,$20,$60,$10,$50
        .byte   $30,$70,$08,$48,$28,$68,$18,$58
        .byte   $38,$78,$04,$44,$24,$64,$14,$54
        .byte   $34,$74,$0C,$4C,$2C,$6C,$1C,$5C
        .byte   $3C,$7C,$02,$42,$22,$62,$12,$52
        .byte   $32,$72,$0A,$4A,$2A,$6A,$1A,$5A
        .byte   $3A,$7A,$06,$46,$26,$66,$16,$56
        .byte   $36,$76,$0E,$4E,$2E,$6E,$1E,$5E
        .byte   $3E,$7E,$01,$41,$21,$61,$11,$51
        .byte   $31,$71,$09,$49,$29,$69,$19,$59
        .byte   $39,$79,$05,$45,$25,$65,$15,$55
        .byte   $35,$75,$0D,$4D,$2D,$6D,$1D,$5D
        .byte   $3D,$7D,$03,$43,$23,$63,$13,$53
        .byte   $33,$73,$0B,$4B,$2B,$6B,$1B,$5B
        .byte   $3B,$7B,$07,$47,$27,$67,$17,$57
        .byte   $37,$77,$0F,$4F,$2F,$6F,$1F,$5F
        .byte   $3F,$7F

;;; ============================================================
;;; High Resolution Graphics - Y Tables
;;; ============================================================

;;; Index is Y (row), give hi/lo bytes for

hires_ytable_hi:
        .byte   $20,$24,$28,$2C,$30,$34,$38,$3C
        .byte   $20,$24,$28,$2C,$30,$34,$38,$3C
        .byte   $21,$25,$29,$2D,$31,$35,$39,$3D
        .byte   $21,$25,$29,$2D,$31,$35,$39,$3D
        .byte   $22,$26,$2A,$2E,$32,$36,$3A,$3E
        .byte   $22,$26,$2A,$2E,$32,$36,$3A,$3E
        .byte   $23,$27,$2B,$2F,$33,$37,$3B,$3F
        .byte   $23,$27,$2B,$2F,$33,$37,$3B,$3F
        .byte   $20,$24,$28,$2C,$30,$34,$38,$3C
        .byte   $20,$24,$28,$2C,$30,$34,$38,$3C
        .byte   $21,$25,$29,$2D,$31,$35,$39,$3D
        .byte   $21,$25,$29,$2D,$31,$35,$39,$3D
        .byte   $22,$26,$2A,$2E,$32,$36,$3A,$3E
        .byte   $22,$26,$2A,$2E,$32,$36,$3A,$3E
        .byte   $23,$27,$2B,$2F,$33,$37,$3B,$3F
        .byte   $23,$27,$2B,$2F,$33,$37,$3B,$3F
        .byte   $20,$24,$28,$2C,$30,$34,$38,$3C
        .byte   $20,$24,$28,$2C,$30,$34,$38,$3C
        .byte   $21,$25,$29,$2D,$31,$35,$39,$3D
        .byte   $21,$25,$29,$2D,$31,$35,$39,$3D
        .byte   $22,$26,$2A,$2E,$32,$36,$3A,$3E
        .byte   $22,$26,$2A,$2E,$32,$36,$3A,$3E
        .byte   $23,$27,$2B,$2F,$33,$37,$3B,$3F
        .byte   $23,$27,$2B,$2F,$33,$37,$3B,$3F
hires_ytable_lo:
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $80,$80,$80,$80,$80,$80,$80,$80
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $80,$80,$80,$80,$80,$80,$80,$80
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $80,$80,$80,$80,$80,$80,$80,$80
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $80,$80,$80,$80,$80,$80,$80,$80
        .byte   $28,$28,$28,$28,$28,$28,$28,$28
        .byte   $A8,$A8,$A8,$A8,$A8,$A8,$A8,$A8
        .byte   $28,$28,$28,$28,$28,$28,$28,$28
        .byte   $A8,$A8,$A8,$A8,$A8,$A8,$A8,$A8
        .byte   $28,$28,$28,$28,$28,$28,$28,$28
        .byte   $A8,$A8,$A8,$A8,$A8,$A8,$A8,$A8
        .byte   $28,$28,$28,$28,$28,$28,$28,$28
        .byte   $A8,$A8,$A8,$A8,$A8,$A8,$A8,$A8
        .byte   $50,$50,$50,$50,$50,$50,$50,$50
        .byte   $D0,$D0,$D0,$D0,$D0,$D0,$D0,$D0
        .byte   $50,$50,$50,$50,$50,$50,$50,$50
        .byte   $D0,$D0,$D0,$D0,$D0,$D0,$D0,$D0
        .byte   $50,$50,$50,$50,$50,$50,$50,$50
        .byte   $D0,$D0,$D0,$D0,$D0,$D0,$D0,$D0
        .byte   $50,$50,$50,$50,$50,$50,$50,$50
        .byte   $D0,$D0,$D0,$D0,$D0,$D0,$D0,$D0
        .byte   $00,$00,$00,$00,$01,$01,$01,$02
        .byte   $02,$02,$02,$03,$03,$03,$04,$04
        .byte   $04,$04,$05,$05,$05,$06,$06,$06
        .byte   $06,$07,$07,$07,$08,$08,$08,$08
        .byte   $09,$09,$09,$0A,$0A,$0A,$0A,$0B
        .byte   $0B,$0B,$0C,$0C,$0C,$0C,$0D,$0D
        .byte   $0D,$0E,$0E,$0E,$0E,$0F,$0F,$0F
        .byte   $10,$10,$10,$10,$11,$11,$11,$12
        .byte   $12,$12,$12,$13,$13,$13,$14,$14
        .byte   $14,$14,$15,$15,$15,$16,$16,$16
        .byte   $16,$17,$17,$17,$18,$18,$18,$18
        .byte   $19,$19,$19,$1A,$1A,$1A,$1A,$1B
        .byte   $1B,$1B,$1C,$1C,$1C,$1C,$1D,$1D
        .byte   $1D,$1E,$1E,$1E,$1E,$1F,$1F,$1F
        .byte   $20,$20,$20,$20,$21,$21,$21,$22
        .byte   $22,$22,$22,$23,$23,$23,$24,$24
        .byte   $24,$24,$25,$25,$25,$26,$26,$26
        .byte   $26,$27,$27,$27,$01,$04,$10,$40
        .byte   $02,$08,$20,$01,$04,$10,$40,$02
        .byte   $08,$20,$01,$04,$10,$40,$02,$08
        .byte   $20,$01,$04,$10,$40,$02,$08,$20
        .byte   $01,$04,$10,$40,$02,$08,$20,$01
        .byte   $04,$10,$40,$02,$08,$20,$01,$04
        .byte   $10,$40,$02,$08,$20,$01,$04,$10
        .byte   $40,$02,$08,$20,$01,$04,$10,$40
        .byte   $02,$08,$20,$01,$04,$10,$40,$02
        .byte   $08,$20,$01,$04,$10,$40,$02,$08
        .byte   $20,$01,$04,$10,$40,$02,$08,$20
        .byte   $01,$04,$10,$40,$02,$08,$20,$01
        .byte   $04,$10,$40,$02,$08,$20,$01,$04
        .byte   $10,$40,$02,$08,$20,$01,$04,$10
        .byte   $40,$02,$08,$20,$01,$04,$10,$40
        .byte   $02,$08,$20,$01,$04,$10,$40,$02
        .byte   $08,$20,$01,$04,$10,$40,$02,$08
        .byte   $20,$01,$04,$10,$40,$02,$08,$20

;;; ============================================================
;;; High Resolution Graphics - X Tables
;;; ============================================================

;;; Not used by Martymations

;;; Index is X coordinate (2 bytes, so 2 tables), value is byte in row
hires_xtable_byte:
        .byte   $00,$00,$00,$00,$00,$00,$00,$01
        .byte   $01,$01,$01,$01,$01,$01,$02,$02
        .byte   $02,$02,$02,$02,$02,$03,$03,$03
        .byte   $03,$03,$03,$03,$04,$04,$04,$04
        .byte   $04,$04,$04,$05,$05,$05,$05,$05
        .byte   $05,$05,$06,$06,$06,$06,$06,$06
        .byte   $06,$07,$07,$07,$07,$07,$07,$07
        .byte   $08,$08,$08,$08,$08,$08,$08,$09
        .byte   $09,$09,$09,$09,$09,$09,$0A,$0A
        .byte   $0A,$0A,$0A,$0A,$0A,$0B,$0B,$0B
        .byte   $0B,$0B,$0B,$0B,$0C,$0C,$0C,$0C
        .byte   $0C,$0C,$0C,$0D,$0D,$0D,$0D,$0D
        .byte   $0D,$0D,$0E,$0E,$0E,$0E,$0E,$0E
        .byte   $0E,$0F,$0F,$0F,$0F,$0F,$0F,$0F
        .byte   $10,$10,$10,$10,$10,$10,$10,$11
        .byte   $11,$11,$11,$11,$11,$11,$12,$12
        .byte   $12,$12,$12,$12,$12,$13,$13,$13
        .byte   $13,$13,$13,$13,$14,$14,$14,$14
        .byte   $14,$14,$14,$15,$15,$15,$15,$15
        .byte   $15,$15,$16,$16,$16,$16,$16,$16
        .byte   $16,$17,$17,$17,$17,$17,$17,$17
        .byte   $18,$18,$18,$18,$18,$18,$18,$19
        .byte   $19,$19,$19,$19,$19,$19,$1A,$1A
        .byte   $1A,$1A,$1A,$1A,$1A,$1B,$1B,$1B
        .byte   $1B,$1B,$1B,$1B,$1C,$1C,$1C,$1C
        .byte   $1C,$1C,$1C,$1D,$1D,$1D,$1D,$1D
        .byte   $1D,$1D,$1E,$1E,$1E,$1E,$1E,$1E
        .byte   $1E,$1F,$1F,$1F,$1F,$1F,$1F,$1F
        .byte   $20,$20,$20,$20,$20,$20,$20,$21
        .byte   $21,$21,$21,$21,$21,$21,$22,$22
        .byte   $22,$22,$22,$22,$22,$23,$23,$23
        .byte   $23,$23,$23,$23,$24,$24,$24,$24
hires_xtable_byte2:
        .byte   $24,$24,$24,$25,$25,$25,$25,$25
        .byte   $25,$25,$26,$26,$26,$26,$26,$26
        .byte   $26,$27,$27,$27,$27,$27,$27,$27


;;; Index is X coordinate (2 bytes, so 2 tables), value is byte mask
hires_xtable_mask:
        .byte   $01,$02,$04,$08,$10,$20,$40,$01
        .byte   $02,$04,$08,$10,$20,$40,$01,$02
        .byte   $04,$08,$10,$20,$40,$01,$02,$04
        .byte   $08,$10,$20,$40,$01,$02,$04,$08
        .byte   $10,$20,$40,$01,$02,$04,$08,$10
        .byte   $20,$40,$01,$02,$04,$08,$10,$20
        .byte   $40,$01,$02,$04,$08,$10,$20,$40
        .byte   $01,$02,$04,$08,$10,$20,$40,$01
        .byte   $02,$04,$08,$10,$20,$40,$01,$02
        .byte   $04,$08,$10,$20,$40,$01,$02,$04
        .byte   $08,$10,$20,$40,$01,$02,$04,$08
        .byte   $10,$20,$40,$01,$02,$04,$08,$10
        .byte   $20,$40,$01,$02,$04,$08,$10,$20
        .byte   $40,$01,$02,$04,$08,$10,$20,$40
        .byte   $01,$02,$04,$08,$10,$20,$40,$01
        .byte   $02,$04,$08,$10,$20,$40,$01,$02
        .byte   $04,$08,$10,$20,$40,$01,$02,$04
        .byte   $08,$10,$20,$40,$01,$02,$04,$08
        .byte   $10,$20,$40,$01,$02,$04,$08,$10
        .byte   $20,$40,$01,$02,$04,$08,$10,$20
        .byte   $40,$01,$02,$04,$08,$10,$20,$40
        .byte   $01,$02,$04,$08,$10,$20,$40,$01
        .byte   $02,$04,$08,$10,$20,$40,$01,$02
        .byte   $04,$08,$10,$20,$40,$01,$02,$04
        .byte   $08,$10,$20,$40,$01,$02,$04,$08
        .byte   $10,$20,$40,$01,$02,$04,$08,$10
        .byte   $20,$40,$01,$02,$04,$08,$10,$20
        .byte   $40,$01,$02,$04,$08,$10,$20,$40
        .byte   $01,$02,$04,$08,$10,$20,$40,$01
        .byte   $02,$04,$08,$10,$20,$40,$01,$02
        .byte   $04,$08,$10,$20,$40,$01,$02,$04
        .byte   $08,$10,$20,$40,$01,$02,$04,$08
hires_xtable_mask2:
        .byte   $10,$20,$40,$01,$02,$04,$08,$10
        .byte   $20,$40,$01,$02,$04,$08,$10,$20
        .byte   $40,$01,$02,$04,$08,$10,$20,$40

;;; Unused?

        .byte   $FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE
L95D0:  .byte   $FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE
        .byte   $FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE
        .byte   $FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE
        .byte   $FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE
