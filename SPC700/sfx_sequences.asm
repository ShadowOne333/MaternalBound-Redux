; $182A - Menu cancel
                db $02
SFX_02:         db $04, $02           ; Note length, hold length
                db $08, $C8, $CA, $BC ; Instrument, volume, pan, note
                db $00                ; Detune

; $1832 - Menu confirm
                db $02
SFX_01:         db $04, $02           ; Note length, hold length
                db $08, $B4, $CA, $C3 ; Instrument, volume, pan, note
                db $00                ; Detune

; $183A - Cursor move
                db $02
SFX_03:         db $04, $02           ; Note length, hold length
                db $13, $BE, $CA, $AB ; Instrument, volume, pan, note
                db $00                ; Detune

; $1842 - Window open
                db $04
SFX_04:         db $13, $C8, $CA, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $45, $93, $B0, $00

; $184B - Error beep
                db $04
SFX_05:         db $0E, $E6, $CA, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $07, $98
                db $03, $C9
                db $0B, $98, $00

; $1857 - Inaudible, stops other SFX
                db $04
SFX_06:         db $1C, $01, $CA, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $0B, $8C, $8C, $8C, $00

; $1861 - Text blip
                db $02
SFX_07:         db $04, $02           ; Note length, hold length
                db $12, $4B, $CA, $BB ; Instrument, volume, pan, note
                db $00                ; Detune

; $1869 - Enter door
                db $02
SFX_08:         db $16, $14           ; Note length, hold length
                db $1C, $82, $CA, $B9 ; Instrument, volume, pan, note
                db $00                ; Detune

; $1871 - Exit door
                db $02
SFX_09:         db $19, $16           ; Note length, hold length
                db $1C, $DC, $CA, $9F ; Instrument, volume, pan, note
                db $00                ; Detune

; $1879 - Phone ring
                db $04
SFX_0A:         db $11, $64, $CA, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $0F, $B0, $00

; $1881 - Pick up phone
                db $04
SFX_0B:         db $0D, $3C, $CA, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $43, $A6
                db $ED, $28 ; Set volume
                db $B3
                db $ED, $0A ; Set volume
                db $9B, $00

; $188F - Cash register
                db $02
SFX_0C:         db $1F, $1C           ; Note length, hold length
                db $1B, $D2, $CA, $98 ; Instrument, volume, pan, note
                db $00                ; Detune

; $1897 - Camera shutter
                db $02
SFX_0D:         db $22, $20           ; Note length, hold length
                db $1A, $FA, $CA, $A4 ; Instrument, volume, pan, note
                db $00                ; Detune

; $189F - Blow a bubble
                db $06
SFX_0E:         db $08, $5A, $CA, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $29
                db $A4, $A6, $A8, $AA, $AB, $AC, $AD
                db $AE, $AF, $B0, $B1, $B2, $B3, $B4
                db $7F, $C9, $00

; $18B6 - Magicant footstep
                db $02
SFX_0F:         db $14, $12           ; Note length, hold length
                db $1A, $32, $CA, $98 ; Instrument, volume, pan, note
                db $00                ; Detune

; $18BE - Open present
                db $04
SFX_10:         db $12, $DC, $CA, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $33, $B7
                db $ED, $8C ; Set volume
                db $C7, $00

; $18C9 - Fall into hole
                db $06
SFX_11:         db $08, $5A, $CA, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $27, $BE, $BD, $BC, $BB, $BA
                db $B9, $B8, $B7, $B6, $B5, $B4
                db $7F, $C9, $00

; $18DD - Stairs
                db $04                ; SFX style 04
SFX_12:         db $1D, $DC, $CA, $00 ; Instrument, volume, pan, detune
                ; Sequence data
                db $0F, $9F, $9F, $9F, $9F, $00

; $18E8 - Shallow water step
                db $02
SFX_13:         db $16, $14           ; Note length, hold length
                db $1A, $32, $CA, $9A ; Instrument, volume, pan, note
L_18EF:         db $00                ; Detune (randomized)

; $18F0 - Deep water step
                db $02
SFX_14:         db $18, $16           ; Note length, hold length
                db $1A, $46, $CA, $8E ; Instrument, volume, pan, note
L_18F7:         db $00                ; Detune (randomized)

; $18F8 - Magicant step
                db $02
SFX_15:         db $0C, $09           ; Note length, hold length
                db $1A, $28, $CA, $A4 ; Instrument, volume, pan, note
L_18FF:         db $00                ; Detune (randomized)


; $1900 - Onett trumpet guy
                dw SFX_16_02
                db $0A
SFX_16:         db $02, $5A, $C8, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $13, $B4, $B7
                db $1F, $B4
                db $0B, $B2
                db $13, $B0
                db $1F, $B2
                db $0B, $B4
                db $1F, $B7
                db $0B, $B4
                db $17, $B2, $00

                db $04
SFX_16_02:      db $02, $14, $CE, $14 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $1B, $C9
                db $13, $B4, $B7
                db $1F, $B4
                db $0B, $B2
                db $13, $B0
                db $1F, $B2
                db $0B, $B4
                db $1F, $B7
                db $0B, $B4
                db $17, $B2, $00

; $1936 - Bicycle bell
                db $02
SFX_17:         db $23, $20           ; Note length, hold length
                db $1A, $DC, $CA, $A4 ; Instrument, volume, pan, note
                db $00                ; Detune

; $193E - Player turn
                db $04
SFX_18:         db $0D, $82, $CA, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $47, $B0, $B2, $B0, $00

; $1948 - Enemy turn
                db $04
SFX_19:         db $0E, $DC, $CA, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $47, $96, $97, $9C, $9B, $00

; $1953 - Bash
                db $06
SFX_1A:         db $18, $14, $CA, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $27, $C7
                db $ED, $28
                db $C6
                db $ED, $3C
                db $C5
                db $ED, $64
                db $C5
                db $7F, $C9, $00

; $1966 - Shoot
                db $06
SFX_1B:         db $18, $F0, $CA, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $27, $B0
                db $ED, $46
                db $AB, $A4
                db $ED, $32
                db $9F, $98
                db $ED, $28
                db $93, $90
                db $7F, $C9, $00

; $197C - Pray
                dw SFX_1C_02
                db $0A
SFX_1C:         db $08, $32, $CC, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $4B, $AD
                db $ED, $46
                db $B2
                db $ED, $5A
                db $B8
                db $ED, $78
                db $BC
                db $ED, $5A
                db $BC
                db $ED, $28
                db $BC, $00

                db $04
SFX_1C_02:      db $08, $14, $C8, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $07, $C9
                db $4B, $AE
                db $ED, $32
                db $B3
                db $ED, $3C
                db $B9
                db $ED, $50
                db $BD
                db $ED, $3C
                db $BD
                db $ED, $28
                db $BD
                db $ED, $14
                db $BD, $00

; $19B1 - Player PSI
                dw SFX_1D_02
                db $0C
SFX_1D:         db $08, $0A, $C8, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $03, $C4, $C3
                db $ED, $14
                db $C4, $C3
                db $ED, $1E
                db $C4, $C3
                db $ED, $28
                db $C4, $C3
                db $ED, $32
                db $C4, $C3
                db $ED, $28
                db $C4, $C3
                db $ED, $1E
                db $C4, $C3
                db $7F, $C9, $00

                db $06
SFX_1D_02:      db $08, $28, $CC, $F0 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $4B, $BA
                db $ED, $32
                db $C6
                db $ED, $28
                db $C6
                db $ED, $3C
                db $C6
                db $ED, $46
                db $C6
                db $ED, $50
                db $C6
                db $ED, $3C
                db $C6
                db $ED, $28
                db $C6
                db $ED, $14
                db $C6
                db $7F, $C9, $00

; $19F8 - Enemy damaged
                dw SFX_1E_02
                db $0A
SFX_1E:         db $14, $BE, $CA, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $01, $81, $88
                db $ED, $B4
                db $8A, $93
                db $ED, $96
                db $90, $98
                db $7F, $C9, $00

                db $06
SFX_1E_02:      db $0E, $8C, $CA, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $27, $8E, $8C
                db $ED, $82
                db $9B
                db $ED, $78
                db $9C, $9D, $8C
                db $ED, $6E
                db $93, $92
                db $ED, $5A
                db $90, $8F
                db $ED, $46
                db $8E, $8D
                db $ED, $28
                db $8C
                db $7F, $C9, $00

; $1A2F - SMAAAAASH!!
                dw SFX_1F_02
                db $0A
SFX_1F:         db $14, $BE, $CA, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $01, $C0, $93
                db $ED, $B4
                db $A1, $A3, $A4
                db $ED, $A0
                db $93, $90, $8C
                db $ED, $8C
                db $98, $A3, $A1
                db $ED, $78
                db $91, $8E, $8C
                db $ED, $64
                db $98, $97
                db $ED, $50
                db $93
                db $ED, $3C
                db $90
                db $ED, $32
                db $8C, $98, $A4, $00

                db $06
SFX_1F_02:      db $0E, $96, $CA, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $27, $98, $97, $98, $9A, $9C
                db $9D, $93, $91, $8F, $8D, $8B
                db $ED, $A0
                db $91, $90, $8F, $8E, $8D
                db $ED, $8C
                db $8C, $8B, $89, $87
                db $7F, $C9, $00

; $1A7E - Player downed
                dw SFX_20_02
                db $0C
SFX_20:         db $0E, $82, $CC, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $29, $98, $9C, $9F, $A1, $9F, $9D, $9C, $9A
                db $ED, $64
                db $97, $95, $93, $91
                db $ED, $50
                db $90, $8E, $8C
                db $ED, $3C
                db $8B, $89
                db $ED, $28
                db $87, $85
                db $ED, $1E
                db $84, $82
                db $7F, $C9, $00

                db $06
SFX_20_02:      db $0E, $8C, $CA, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $27, $8C, $90, $93, $95, $93, $91, $90, $8E
                db $ED, $50
                db $8B, $89, $87, $85, $84, $82, $8C, $8B, $89
                db $ED, $32
                db $87, $85, $84, $82
                db $7F, $C9, $00

; $1ACA - Enemy defeated
                db $06
SFX_21:         db $18, $32, $CA, $00 ; Instrument, volume, pan, data
            ;**** SEQUENCE DATA ****
                db $4B, $8E, $91
                db $ED, $3C
                db $9F, $A1
                db $ED, $46
                db $A3, $A4
                db $ED, $3C
                db $A5
                db $ED, $14
                db $A6
                db $7F, $C9, $00

; $1AE3 - Miss attack
                db $04
SFX_22:         db $08, $E6, $CA, $00 ; Instrument, volume, pan, data
            ;**** SEQUENCE DATA ****
                db $05, $BF
                db $49, $C5, $00

; $1AED - Dodge attack
                db $04
SFX_23:         db $08, $E6, $CA, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $47, $BE, $C2, $BE, $00

; $1AF7 - Lifeup
                dw SFX_24_02
                db $0A
SFX_24:         db $08, $DC, $CA, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $4B, $B0, $B7
                db $ED, $96
                db $B9, $BB
                db $ED, $5A
                db $B0, $B7, $B9, $BB
                db $ED, $46
                db $B0, $B7
                db $ED, $1E
                db $B9, $BB, $00

                db $04
SFX_24_02:      db $08, $1E, $D2, $8C ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $23, $C9
                db $4B, $B0, $B7
                db $ED, $3C
                db $B9, $BB, $ED
                db $28, $B0, $B7
                db $ED, $1E
                db $B9, $BB
                db $ED, $0A
                db $B0, $B7, $B9, $BB, $00

; $1B31 - Status heal
                dw SFX_25_02
                db $0A
SFX_25:         db $08, $50, $CB, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $03, $B2, $B7
                db $ED, $B4
                db $BC, $BE
                db $ED, $46
                db $B9, $C1, $C3, $C5
                db $ED, $1E
                db $BA, $C2, $C4, $C6
                db $ED, $14
                db $BB, $C3, $C5, $C7, $B4, $B9, $BE, $C0, $00

                db $04
SFX_25_02:      db $08, $1E, $C3, $A0 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $23, $C9
                db $03, $B2, $B7
                db $ED, $46
                db $BC, $BE
                db $E1, $11
                db $ED, $1E
                db $B5, $BD, $BF, $C1
                db $E1, $03
                db $ED, $14
                db $B6, $BE, $C0, $C2
                db $E1, $11
                db $ED, $0A
                db $B7, $BF, $C1, $C3
                db $E1, $03
                db $B8, $C0, $C2, $C4, $00

; $1B83 - Shield
                dw SFX_26_02
                db $0A
SFX_26:         db $11, $64, $CC, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $07, $A4
                db $ED, $46
                db $45, $B0, $B2
                db $ED, $5A
                db $B4, $B5
                db $ED, $78
                db $B7, $B9
                db $ED, $8C
                db $BB, $C7
                db $ED, $46
                db $0B, $A4, $A8, $AB, $AF
                db $B0, $B4, $B7, $BB, $00

                db $04
SFX_26_02:      db $11, $3C, $C8, $64 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $1B, $C9
                db $07, $A4
                db $45, $A4, $A6, $A8, $A9, $AB, $AD, $AF, $BB
                db $ED, $1E
                db $E1, $12
                db $0B, $A4
                db $E1, $02
                db $A8
                db $E1, $12
                db $AB
                db $E1, $02
                db $AF
                db $E1, $12
                db $B0
                db $E1, $02
                db $B4
                db $E1, $12
                db $B7
                db $E1, $02
                db $BB, $00

; $1BD7 - PSI Shield
                dw SFX_27_02
                db $0A
SFX_27:         db $0F, $5A, $CF, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $0B, $98
                db $ED, $28
                db $03, $BC, $BB
                db $E1, $05
                db $ED, $3C
                db $C5, $C3
                db $E1, $0F
                db $ED, $5A
                db $C1, $C0, $BE
                db $ED, $78
                db $E1, $05
                db $B0, $BB
                db $ED, $96
                db $E1, $0F
                db $B9, $B7
                db $E1, $05
                db $ED, $50
                db $B5, $B4, $B2
                db $E1, $0A
                db $ED, $96
                db $E0, $08
                db $43, $B0, $B4
                db $ED, $5A
                db $C3, $C7, $BC, $C0, $C3, $C7
                db $ED, $50
                db $B0, $B4, $B7, $BB
                db $ED, $32
                db $BC, $C0, $C3, $C7
                db $ED, $1E
                db $B0, $B4, $B7, $BB
                db $ED, $14
                db $BC, $C0, $C3, $C7, $BC, $C0, $C3, $C7, $00

                db $04
SFX_27_02:      db $0F, $1E, $CA, $64 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $0B, $9F
                db $1B, $C9
                db $03
                db $BC, $BB, $B9, $B7, $B5, $B4, $A6
                db $B0, $BB, $B9, $C3, $C1, $C0, $BE
                db $ED, $1E
                db $E1, $02
                db $E0, $08
                db $43, $BC, $C0, $C3, $C7
                db $E1, $12
                db $B0, $B4, $B7, $BB
                db $E1, $02
                db $BC, $C0, $C3, $C7
                db $E1, $12
                db $B0, $B4, $B7, $BB
                db $E1, $02
                db $BC, $C0, $C3, $C7
                db $E1, $12
                db $B0, $B4, $B7, $BB, $BC, $C0, $C3, $C7, $00

; $1C79 - Stat up
                dw SFX_28_02
                db $0A
SFX_28:         db $0B, $E6, $CC, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $29, $85, $87, $8B, $8C
                db $ED, $78
                db $93, $95, $99, $9A
                db $ED, $5A
                db $A1, $A3, $A7, $A8
                db $ED, $50
                db $A3, $A5, $A9, $AA
                db $ED, $28
                db $B1, $B3, $B7, $B8, $00

                db $04
SFX_28_02:      db $0B, $5A, $C8, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $29, $C9, $C9
                db $85, $87, $8B, $8C
                db $ED, $3C
                db $93, $95, $99, $9A
                db $ED, $28
                db $A1, $A3, $A7, $A8
                db $ED, $1E
                db $A3, $A5, $A9, $AA
                db $ED, $14
                db $B1, $B3, $B7, $B8, $00

; $1CC3 - Stat down
                dw SFX_29_02
                db $0A
SFX_29:         db $0B, $78, $C8, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $29, $B5, $BA, $B5, $B0
                db $ED, $B4
                db $A7, $AC, $A7, $A2
                db $ED, $50
                db $99, $9E, $99, $94
                db $ED, $46
                db $97, $90, $97, $86
                db $ED, $32
                db $8B, $84, $82, $00

                db $04
SFX_29_02:      db $0B, $5A, $CE, $64 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $29, $C9, $C9
                db $B5, $BA, $B5, $B0
                db $ED, $3C
                db $A7, $AC, $A7, $A2
                db $ED, $28
                db $99, $9E, $99, $94
                db $ED, $1E
                db $97, $90, $97, $86
                db $ED, $14
                db $8B, $84, $82, $00

; $1D0B - Hypnosis
                dw SFX_2A_02
                db $0A
SFX_2A:         db $0F, $50, $CD, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $4B, $A4
                db $ED, $96
                db $E1, $07
                db $B0
                db $ED, $64
                db $E1, $03
                db $B4
                db $ED, $8C
                db $E1, $0A
                db $B8
                db $ED, $1E
                db $E1, $0F
                db $B0
                db $E1, $07
                db $B4
                db $E1, $0A
                db $B8, $B0, $B4, $B8, $B0, $B4, $B8, $00

; $1D35
                db $04
SFX_2A_02:      db $0F, $28, $C8, $82 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $1B, $C9, $4B, $B0, $B4, $B8
                db $E1, $0C
                db $ED, $0A
                db $B0, $B4, $B8
                db $E1, $08
                db $B0, $B4, $B8, $B0, $B4, $B8, $00

; $1D50 - Magnet Alpha
                dw SFX_2B_02
                db $0A
SFX_2B:         db $0E, $3C, $CC, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $13, $C4, $0F, $C3
                db $E0, $0B
                db $ED, $A0
                db $07, $9A, $A6, $B2, $BE
                db $ED, $3C
                db $9A, $A6, $B2, $BE, $9A, $A6, $B2, $BE, $00

; $1D6F
                db $04
SFX_2B_02:      db $18, $1E, $C8, $64 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $13, $A3, $0F, $A3
                db $E0, $0B
                db $ED, $5A
                db $1B, $C9, $07, $9A, $A6
                db $ED, $1E
                db $B2, $BE
                db $ED, $0A
                db $9A, $A6, $B2, $BE, $9A, $A6, $B2, $BE, $00

; $1D90 - Magnet Omega
                dw SFX_4C_02
                db $0A
SFX_4C:         db $0E, $3C, $CC, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $13, $C7
                db $ED, $1E
                db $0F, $C7
                db $E0, $0B
                db $ED, $A0
                db $07, $9A, $A6, $B2, $BE
                db $ED, $28
                db $9A, $A6, $B2, $BE
                db $ED, $1E
                db $9A, $A6, $B2, $BE
                db $ED, $14
                db $9A, $A6, $B2, $BE, $00

; $1DB9
                db $04
SFX_4C_02:      db $18, $1E, $C8, $64 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $13, $C4, $0F, $C4
                db $E0, $0B
                db $ED, $5A
                db $1B, $C9, $07, $9A, $A6
                db $ED, $1E
                db $B2, $BE
                db $ED, $14
                db $9A, $A6, $B2, $BE
                db $ED, $0A
                db $9A, $A6, $B2, $BE, $9A, $A6, $B2, $BE, $00

; $1DE0 - Paralysis Alpha
                dw SFX_2C_02
                db $0A
SFX_2C:         db $08, $A0, $C8, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $45, $B3, $B6, $B5, $B9, $BD, $BF, $C2, $BF, $BD, $B9, $B2, $B4, $B5, $B9, $BC, $BD, $BE, $BD, $BC, $B8, $B7, $B6
                db $E0, $19
                db $07, $C9, $C9, $93, $9F, $A4
                db $ED, $46
                db $93, $9F, $A4
                db $ED, $1E
                db $93, $9F, $A4, $00

; $1E11
                db $04
SFX_2C_02:      db $08, $3C, $CE, $1E ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $1B, $C9, $45, $B3, $B6, $B5, $B9, $BD, $BF, $C2, $BF, $BD, $B9, $B2, $B4, $B5, $B9, $BC, $BD, $BE, $BD, $BC, $B8, $B7, $B6
                db $ED, $46
                db $E0, $19
                db $07, $C9, $C9, $93, $9F, $A4
                db $ED, $1E
                db $93, $9F, $A4
                db $ED, $14
                db $93, $9F, $A4, $00

; $1E44 - Paralysis Omega
                dw SFX_4F_02
                db $0A
SFX_4F:         db $13, $C8, $C5, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $45, $B3, $B6, $B5, $B9, $BD, $BF, $C2, $BF, $BD, $B9, $B2, $B4, $B5, $B9, $BC, $BD, $BE, $BD, $BC, $B8, $B7, $B6
                db $ED, $3C
                db $45, $B3, $B6, $B5, $B9, $BD, $BF, $C2, $BF, $BD, $B9, $B2, $B4, $B5, $B9, $BC, $BD
                db $ED, $1E
                db $BE, $BD, $BC
                db $E0, $19
                db $07, $93, $9F, $A4
                db $ED, $46
                db $93, $9F, $A4
                db $ED, $1E
                db $93, $9F, $A4, $00

; $1E8B
                db $04
SFX_4F_02:      db $13, $5A, $CF, $64 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $1B, $C9, $45, $B3, $B6, $B5, $B9, $BD, $BF, $C2, $BF, $BD, $B9, $B2, $B4, $B5, $B9, $BC, $BD, $BE, $BD, $BC, $B8, $B7, $B6
                db $ED, $28
                db $45, $B3, $B6, $B5, $B9, $BD, $BF, $C2, $BF, $BD, $B9, $B2, $B4, $B5, $B9, $BC, $BD
                db $ED, $14
                db $BE, $BD, $BC
                db $E0, $19
                db $07, $93, $9F, $A4
                db $ED, $46
                db $93, $9F, $A4
                db $ED, $1E
                db $93, $9F, $A4, $00
                db $00 ; Funny extra zero :)

; $1ED3 - Brainshock Alpha
                dw SFX_2D_02
                db $0A
SFX_2D:         db $19, $28, $C8, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $0F, $BB, $B4, $BB, $B5
                db $E0, $02
                db $1B
                db $ED, $8C
                db $B1, $B3, $00

; $1EE7
                db $04
SFX_2D_02:      db $19, $1E, $CC, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $1B, $C9, $0F, $BB, $B4, $BB, $B5
                db $E0, $02
                db $1B
                db $ED, $14
                db $E1, $03
                db $B1
                db $E1, $11
                db $B3, $00

; $1EFF - Brainshock Omega
                dw SFX_50_02
                db $0A
SFX_50:         db $19, $1E, $C8, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $1F, $B0
                db $ED, $8C
                db $B4, $9D, $B1, $A5
                db $E0, $02
                db $1B
                db $ED, $AA
                db $B1, $B3, $00

; $1F16
                db $04
SFX_50_02:      db $19, $32, $CC, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $1B, $C9, $1F, $98
                db $ED, $46
                db $B4, $AB, $A5, $B7
                db $E0, $02
                db $1B
                db $ED, $1E
                db $E1, $03
                db $B1
                db $E1, $11
                db $B3, $00

; $1F31 - Player wounded
                db $06
SFX_2E:         db $0D, $78, $CA, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $27, $90, $8E, $8C
                db $ED, $64
                db $8A, $88, $7F, $C9, $00

; $1F41 - Player mortally wounded
                db $06
SFX_2F:         db $0D, $B4, $CA, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $27, $96, $94, $92, $90, $93, $91, $8F, $8D, $8B, $89
                db $ED, $A0
                db $8B, $89, $87, $86
                db $ED, $8C
                db $88, $84, $83, $82, $81, $7F, $C9, $00

; $1F61 - Rockin 1
                dw SFX_30_02
                db $0A
SFX_30:         db $19, $B4, $CC, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $01, $9C
                db $ED, $32
                db $AE
                db $ED, $46
                db $B0, $B2
                db $ED, $32
                db $B4, $B5
                db $ED, $14
                db $C3, $C5, $00

; $1F7A
                db $04
SFX_30_02:      db $19, $5A, $C8, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $4B, $C9, $01, $9C
                db $ED, $0A
                db $AE, $B0, $B2, $B4, $B5, $C3, $C5, $00

; $1F8D - Rockin 2
                dw SFX_31_02
                db $0A
SFX_31:         db $0D, $14, $CC, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $27, $C3, $C0
                db $ED, $28
                db $BF, $BD
                db $ED, $3C
                db $BC, $B9
                db $ED, $5A
                db $B7, $B6
                db $ED, $50
                db $C3, $C0
                db $ED, $32
                db $BF, $BD
                db $ED, $1E
                db $BC, $B9
                db $ED, $14
                db $B7, $B6
                db $ED, $0A
                db $7F, $C9, $00

; $1FB8
                db $04
SFX_31_02:      db $0D, $0A, $C8, $50 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $27, $C9, $C9, $C5, $C2, $C1, $BF
                db $ED, $14
                db $BE, $BB, $B9, $B8
                db $ED, $0A
                db $C5, $C2, $C1, $BF, $BE, $BB, $B9, $B8, $7F, $C9, $00

; $1FD7 - Rockin 3
                dw SFX_32_02
                db $0A
SFX_32:         db $08, $C8, $CB, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $45, $C7, $C5, $C3, $C1
                db $ED, $28
                db $C0, $C1, $C3, $C5
                db $ED, $82
                db $C7, $C5, $C3, $C1
                db $ED, $28
                db $C0, $C1, $C3, $C5, $00

; $1FF6
                db $04
SFX_32_02:      db $07, $82, $C2, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $45, $B2, $C9, $C6
                db $E1, $12
                db $B3, $C9, $C5
                db $E1, $02
                db $B4, $C9, $C4
                db $E1, $12
                db $B5, $C9, $C3
                db $E1, $02
                db $B6, $C9, $C2, $00

; $2014 - Fire 1
                dw SFX_33_02
                db $0C
SFX_33:         db $18, $B4, $CA, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $27, $89, $BB
                db $ED, $82
                db $BA
                db $ED, $5A
                db $B9
                db $ED, $50
                db $B9
                db $ED, $3C
                db $B7
                db $ED, $28
                db $B5
                db $ED, $1E
                db $B4, $7F, $C9, $00

; $2033
                db $06
SFX_33_02:      db $18, $3C, $CA, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $29, $A1, $AF
                db $ED, $28
                db $AE, $AD, $AD, $AB, $A9, $A8, $A8, $A8, $A8, $A8, $7F, $C9, $00

; $204A - Fire 2
                dw $0000
                dw L_2056
                db $10
SFX_34:         db $F0, $E0, $0F, $28 ; ??, ??, ??, ??
                db $CA, $14, $02      ; pan, ??, ??

L_2056:         db $0A, $1E, $28, $32, $46
                db $50, $5A, $64, $78, $82
                db $8C, $AA, $B4, $BE, $B4
                db $96, $78, $82, $8C, $AA
                db $B4, $BE, $B4, $96, $8C
                db $82, $78, $64, $5A, $50
                db $46, $3C, $7F, $0A, $00

; $2079 - Fire 3
                dw L_20A8
                dw L_2085
                db $10
SFX_35:         db $F0, $E0, $0F, $E6 ; ??, ??, ??, ??
                db $CA, $0F, $02      ; pan, ??, ??

L_2085:         db $01, $0A, $19, $1E, $31
                db $32, $3C, $5F, $73, $78
                db $7D, $78, $64, $5A, $50
                db $46, $73, $78, $7D, $78
                db $64, $5A, $50, $46, $46
                db $3C, $50, $3C, $32, $28
                db $1E, $01, $7F, $01, $00

L_20A8:         db $0F, $14, $10, $11, $14
                db $12, $11, $12, $13, $12
                db $11, $10, $11, $12, $11
                db $10, $13, $12, $11, $10
                db $11, $12, $11, $10, $13
                db $13, $12, $13, $0E, $0E
                db $0F, $1F

; $20C8 - Counter-PSI Unit
                dw SFX_36_02
                db $0A
SFX_36:         db $18, $3C, $CA, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $0F, $9D, $9F
                db $ED, $82
                db $AF, $A1
                db $ED, $5A
                db $9F, $9D
                db $ED, $28
                db $9C, $8E
                db $ED, $3C
                db $84, $9A
                db $ED, $1E
                db $9C
                db $ED, $0A
                db $9A, $00

; $20E9
                db $04
SFX_36_02:      db $19, $82, $CA, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $13, $98, $8C
                db $ED, $50
                db $90, $98
                db $ED, $28
                db $B0, $8C
                db $ED, $14
                db $A4, $8E
                db $ED, $0A
                db $85, $98, $00

; $2102 - Enemy PSI
                dw SFX_37_02
                db $0C
SFX_37:         db $08, $0A, $C8, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $03, $BF, $BE
                db $ED, $14
                db $BF, $BE
                db $ED, $1E
                db $BF, $BE
                db $ED, $28
                db $BF, $BE
                db $ED, $32
                db $BF, $BE
                db $ED, $3C
                db $BF, $BE
                db $ED, $28
                db $BF, $BE, $7F, $C9, $00

; $2127
                db $06
SFX_37_02:      db $08, $14, $CC, $F0 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $4B, $B3
                db $ED, $1E
                db $BF
                db $ED, $28
                db $BF
                db $ED, $32
                db $BF
                db $ED, $3C
                db $BF
                db $ED, $32
                db $BF
                db $ED, $28
                db $BF
                db $ED, $1E
                db $BF
                db $ED, $14
                db $BF, $7F, $C9, $00

; $2149 - Freeze 1
                dw SFX_38_02
                db $0A
SFX_38:         db $08, $D2, $C8, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $43, $B5, $B0
                db $ED, $46
                db $C7, $BB
                db $ED, $32
                db $C7, $BB
                db $ED, $14
                db $C7, $BB
                db $ED, $0A
                db $C7, $BB, $00

; $2164
                db $04
SFX_38_02:      db $08, $BE, $CC, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $0B, $C9, $43, $B5, $B0
                db $ED, $28
                db $C7, $BB
                db $ED, $0A
                db $C7, $BB, $C7, $BB, $C7, $BB, $00

; $217B - Freeze 2
                dw SFX_39_02
                db $0A
SFX_39:         db $08, $E6, $C5, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $43, $C7, $C1
                db $ED, $78
                db $BC, $B0, $B5, $BB
                db $ED, $14
                db $C7, $C1, $BC, $B0, $B5, $BB, $00

; $2194
                db $04
SFX_39_02:      db $08, $8C, $CF, $C8 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $1B, $C9, $43, $C7, $C1, $BC, $B0, $B5, $BB
                db $ED, $14
                db $C7, $C1, $BC, $B0, $B5, $BB, $00

; $21AB - Freeze 3
                dw SFX_3A_02
                db $0A
SFX_3A:         db $19, $BE, $C8, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $07, $82, $03, $91, $9D, $A9, $B5, $C1
                db $ED, $1E
                db $97, $A3, $AF, $BB, $C7, $00

; $21C2
                db $04
SFX_3A_02:      db $19, $5A, $CE, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $4B, $C9, $07, $82, $03, $91, $9D, $A9, $B5, $C1
                db $ED, $14
                db $97, $A3, $AF, $BB, $C7, $00


; $21D9 - HP Sucker
                dw SFX_3B_02
                db $0A
SFX_3B:         db $0D, $BE, $C8, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $07, $82, $03, $91, $9D, $A9, $B5, $C1
                db $ED, $1E
                db $97, $A3, $AF, $BB, $C7
                db $E0, $08
                db $ED, $8C
                db $C6, $C4, $C2, $C0, $C2, $BF, $BD, $BC
                db $ED, $3C
                db $C5, $C3, $C1, $C0, $C1, $BE, $BC, $BC
                db $ED, $14
                db $C6, $C4, $C2, $C0, $C2, $BF, $BD, $BC, $00

; $2210
                db $04
SFX_3B_02:      db $0D, $5A, $CE, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $4B, $C9, $07, $82, $03, $91, $9D, $A9, $B5, $C1
                db $ED, $14
                db $97, $A3, $AF, $BB, $C7
                db $E0, $08
                db $ED, $3C
                db $C6, $C4, $C2, $C0, $C2, $BF, $BD, $BC
                db $ED, $1E
                db $C5, $C3, $C1, $C0, $C1, $BE, $BC, $BC
                db $ED, $14
                db $C6, $C4, $C2, $C0, $C2, $BF, $BD, $BC, $00

; $2247 - Thunder Alpha/Beta miss
                db $06
SFX_3C:         db $18, $3C, $CA, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $01, $C7, $C5, $C3, $C1, $C0, $BE, $BC
                db $ED, $32
                db $BB, $B9, $B7, $B5, $B4, $B2, $B0
                db $ED, $28
                db $AF, $AD
                db $ED, $1E
                db $AB
                db $ED, $14
                db $A9, $A8
                db $ED, $0A
                db $A6, $A4, $7F, $C9, $00


; $226F - Thunder Gamma/Omega miss
                db $06
SFX_3D:         db $18, $78, $CA, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $01, $C7, $C3, $C0, $BC, $BB, $B7, $B4, $B0, $AF, $AB, $A8, $A4, $A3, $9F, $9C, $98
                db $ED, $3C
                db $97, $95, $93, $91, $90, $8E, $8C
                db $ED, $28
                db $8B, $89
                db $ED, $14
                db $87, $85
                db $ED, $0A
                db $84, $82, $7F, $C9, $00

; $229D - Thunder Alpha/Beta strike
                db $06
SFX_3E:         db $18, $BE, $CA, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $01, $C4, $C6, $C2
                db $ED, $8C
                db $BE, $C0, $BC, $B8, $BA, $B6
                db $ED, $50
                db $B2, $B4, $B0, $AC, $AE, $AA, $A6, $A8, $A4, $A0, $A2, $9E, $9A, $9C, $98
                db $ED, $3C
                db $94, $96, $92
                db $ED, $1E
                db $8E, $90, $8C
                db $ED, $0A
                db $82, $84, $82, $7F, $C9, $00

; $22D1 - Thunder Gamma/Omega strike
                db $06
SFX_3F:         db $18, $F0, $CA, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $27, $AC, $A4, $A8, $AB, $A6, $92, $A2, $99
                db $ED, $D2
                db $A3, $9E, $AD, $AB, $A1, $A9, $AC, $99, $9F, $9C, $AB, $A6
                db $ED, $64
                db $A0, $A4, $A8, $9F, $9A, $92, $AE, $A5
                db $ED, $50
                db $A3, $AA, $AD, $AB
                db $ED, $32
                db $A1, $9D, $AC, $99
                db $ED, $1E
                db $9F, $A8, $AB, $A6, $7F, $C9, $00

; $230C - Starstorm
                dw SFX_40_02
                db $0A
SFX_40:         db $0D, $82, $CC, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $03, $C4, $C3, $C1, $C0
                db $ED, $5A
                db $BF, $BE, $BC, $BB, $B9
                db $ED, $B4
                db $C6, $C5, $C3, $C1, $C0
                db $ED, $32
                db $C2, $C1, $C0, $BE
                db $ED, $64
                db $BD, $BC, $BB, $B9, $B7, $C4, $C3, $C1, $C0
                db $ED, $5A
                db $BF, $BE, $BC, $BB, $B9
                db $ED, $B4
                db $C6, $C5, $C3, $C1, $C0
                db $ED, $32
                db $C2, $C1, $C0, $BE
                db $ED, $64
                db $BD, $BC, $BB, $B9, $B7, $00

; $2353
                db $04
SFX_40_02:      db $0D, $82, $C5, $C8 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $1B, $C9, $03, $C4, $C3, $C1, $C0
                db $ED, $5A
                db $BF, $BE, $BC, $BB, $B9
                db $ED, $B4
                db $C6, $C5, $C3, $C1, $C0
                db $ED, $32
                db $C2, $C1, $C0, $BE
                db $ED, $64
                db $BD, $BC, $BB, $B9, $B7, $C4, $C3, $C1, $C0
                db $ED, $5A
                db $BF, $BE, $BC, $BB, $B9
                db $ED, $B4
                db $C6, $C5, $C3, $C1, $C0
                db $ED, $32
                db $C2, $C1, $C0, $BE
                db $ED, $64
                db $BD, $BC, $BB, $B9, $B7, $00

; $239A - Flash 1
                dw SFX_41_02          ; UNUSED, because header is 04
                db $04
SFX_41:         db $07, $DC, $CA, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $4B, $BA
                db $E1, $07
                db $C6
                db $E1, $0D
                db $B9
                db $ED, $32
                db $E1, $0A
                db $BA
                db $E1, $0D
                db $C6
                db $E1, $07
                db $B9
                db $ED, $1E
                db $E1, $0A
                db $BA
                db $E1, $07
                db $C6, $B9
                db $E1, $0A
                db $BA
                db $E1, $0D
                db $C6, $B9
                db $E1, $0A
                db $BA, $C6, $B9, $00

; $23CA
                db $04
SFX_41_02:      db $07, $5A, $D2, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $4B, $C9, $C9, $B6, $C2, $B5
                db $ED, $14
                db $E1, $02
                db $B6, $C2, $B5
                db $E1, $12
                db $B6, $C2, $B5
                db $E1, $02
                db $B6, $C2, $B5
                db $E1, $12
                db $B6, $C2, $B5, $00

; $23EC - Flash 2
                dw SFX_42_02
                db $0A
SFX_42:         db $07, $DC, $D2, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $4B, $8D, $B3, $C6
                db $ED, $B4
                db $C5, $AB
                db $E1, $0F
                db $ED, $50
                db $B1, $B3, $C6, $C5, $AB
                db $ED, $3C
                db $E1, $0C
                db $B1, $B3, $C6, $C5, $AB
                db $ED, $28
                db $E1, $08
                db $B1, $B3, $C6, $C5, $AB
                db $ED, $1E
                db $E1, $06
                db $B1, $B3, $C6, $C5, $AB
                db $E1, $03
                db $B1, $B3, $C6, $C5, $AB, $00

; $2427
                db $04
SFX_42_02:      db $07, $BE, $C2, $78 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $4B, $8D, $B3, $C6, $C5, $AB
                db $E1, $05
                db $ED, $1E
                db $B1, $B3, $C6, $C5, $AB
                db $ED, $14
                db $E1, $08
                db $B1, $B3, $C6, $C5, $AB
                db $ED, $0A
                db $E1, $0C
                db $B1, $B3, $C6, $C5, $AB
                db $E1, $0E
                db $B1, $B3, $C6, $C5, $AB
                db $E1, $11
                db $B1, $B3, $C6, $C5, $AB, $00

; $245C - Flash 3
                dw SFX_43_02
                db $0A
SFX_43:         db $07, $BE, $CD, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $45, $B7, $B9, $BE, $C0
                db $ED, $28
                db $B7, $BB, $C0, $C2, $C7, $03
                db $ED, $28
                db $B7, $B9, $BE, $C0, $C3, $BB, $C0, $C2, $C7
                db $ED, $1E
                db $B7, $B9, $BE, $C0, $C3, $BB, $C0, $C2, $C7
                db $ED, $14
                db $B7, $B9, $BE, $C0, $C3, $BB, $C0, $C2, $C7, $00

; $2492
                db $04
SFX_43_02:      db $07, $AA, $C7, $F0 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $45, $C9, $C9, $B7, $B9, $BE, $C0, $B7, $BB, $C0, $C2, $C7, $03
                db $ED, $14
                db $B7, $C5, $BE, $C0, $B7, $BB, $C0, $C2, $C7, $B7, $C5, $BE, $C0, $B7, $BB, $C0, $C2, $C7
                db $ED, $0A
                db $B7, $C5, $BE, $C0, $B7, $BB, $C0, $C2, $C7, $00

; $24C4 - Eat/drink
                db $06
SFX_44:         db $08, $E6, $CA, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $27, $98, $97, $95, $87, $8B, $90, $93, $97, $9A, $9D, $7F, $C9, $00

; $24D7 - Unknown/Unused
                db $04
SFX_45:         db $12, $5A, $CA, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $0B, $A4, $00

; $24DF - Bottle Rocket
                db $06
SFX_46:         db $18, $5A, $CA, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $27, $8C, $9A, $9C, $9D, $9F
                db $ED, $3C
                db $A4, $A8, $AB, $AF, $B2, $B5, $B7, $B9, $BB, $BC, $BE, $C0, $C1, $C3, $C5, $7F, $C9, $00

; $24FE - White noise
                dw L_148B
                db $08
SFX_47:         mov.b a, #L_250A                ; E8 0A
                mov.b y, #L_250A>>8             ; 8D 25
                mov   x, #$1F                   ; CD 1F
                jmp   L_14EE                    ; 5F EE 14

L_250A:         db $22, $20, $0F, $46 ; ??, ??, ??, ??
                db $CA, $B4, $00      ; pan, ??, ??

; $2511 - Call for help
                db $04
SFX_48:         db $08, $5A, $CA, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $4B, $B1, $B3, $AC
                db $ED, $82
                db $AE
                db $ED, $3C
                db $AA, $00

; $2521 - Sky Runner signal/Giygas shield
                dw SFX_49_02
                db $0A
SFX_49:         db $08, $E6, $CC, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $07, $C7, $C7
                db $ED, $28
                db $C7, $C7
                db $ED, $14
                db $C7, $C7
                db $ED, $0A
                db $C7, $C7, $00

; $2538
                db $04
SFX_49_02:      db $08, $14, $C5, $14 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $01, $C9
                db $07, $C7, $C7
                db $E1, $0F
                db $C7, $C7
                db $E1, $05
                db $C7, $C7
                db $E1, $0F
                db $C7, $C7
                db $E1, $05
                db $C7, $C7, $00

; $2553 - Devil's machine turned off
                dw SFX_4A_02
                db $0C
SFX_4A:         db $18, $F0, $CA, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $07, $8C, $2F
                db $ED, $BE
                db $A4
                db $ED, $28
                db $9F
                db $ED, $1E
                db $98
                db $ED, $32
                db $93
                db $ED, $0A
                db $8C, $7F, $C9, $00

; $256F
                db $06
SFX_4A_02:      db $18, $F0, $CA, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $12, $89, $2F
                db $ED, $C8
                db $93
                db $ED, $28
                db $90
                db $ED, $78
                db $8B
                db $ED, $14
                db $87
                db $ED, $0A
                db $97, $7F, $C9, $00

; $2589 - Burst into flames
                db $06
SFX_4B:         db $18, $5A, $CA, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $03, $9F, $A0, $9C
                db $ED, $E6
                db $9F, $A0, $9C, $9F, $A0, $9C, $9F, $A0, $9C, $9F, $A0, $9C
                db $ED, $96
                db $9F, $A0, $9C
                db $ED, $64
                db $9F, $A0, $9C
                db $ED, $1E
                db $9F, $A0, $9C
                db $ED, $0A
                db $9F, $A0, $9C, $00

; $25B5 - Fire a beam
                dw SFX_4D_02
                db $0A
SFX_4D:         db $19, $82, $CD, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $17, $B7, $00

; $25BF
                db $04
SFX_4D_02:      db $19, $1E, $C5, $64 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $19, $C9, $17, $B7, $00

; $25C9 - Belch's burp
                dw SFX_4E_02
                db $0A
SFX_4E:         db $1A, $DC, $C9, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $1F, $A8, $00

; $25D3
                db $04
SFX_4E_02:      db $1A, $DC, $CB, $14 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $1F, $A8, $00

; $25DB - Giygas' attack/arctic-cold breath
                db $06
SFX_51:         db $18, $14, $CA, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $03, $C7
                db $ED, $28
                db $C7
                db $ED, $3C
                db $C7
                db $ED, $50
                db $C7, $0F
                db $ED, $5A
                db $C7, $03
                db $ED, $32
                db $C6
                db $ED, $1E
                db $C5
                db $ED, $14
                db $C4
                db $ED, $0A
                db $C3, $7F, $C9, $00

; $25FF - Scatter pollen/spores
                dw SFX_52_02
                db $0A
SFX_52:         db $08, $E6, $C8, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $49, $BD, $BE, $C3, $C7
                db $ED, $50
                db $BF, $C0, $C5, $C6
                db $ED, $46
                db $BD, $BE, $C3, $C7
                db $ED, $28
                db $BF, $C0, $C5, $C6
                db $ED, $1E
                db $BD, $BE, $C3, $C7
                db $ED, $0A
                db $BF, $C0, $C5, $C6, $00

; $262A
                db $04
SFX_52_02:      db $08, $46, $CC, $C8 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $1B, $C9, $4B, $BD, $BE, $C3
                db $ED, $32
                db $C7, $BF, $C0, $C5, $C6
                db $ED, $14
                db $BD, $BE, $C3, $C7, $BF, $C0, $C5, $C6
                db $ED, $0A
                db $BD, $BE, $C3, $C7, $BF, $C0, $C5, $C6, $00

; $2651 - Status inflicted
                dw SFX_53_02
                db $0A
SFX_53:         db $0A, $1E, $CA, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $0B, $B0
                db $ED, $3C
                db $B2, $B3
                db $ED, $28
                db $B4, $B5, $00

; $2663
                db $04
SFX_53_02:      db $0A, $46, $C8, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $4B, $C9, $0B, $AC
                db $E1, $0C
                db $AD
                db $E1, $08
                db $AE
                db $E1, $0C
                db $AF
                db $E1, $08
                db $B0, $00

; $2679 - Yell/say something nasty
                dw SFX_54_02
                db $0A
SFX_54:         db $16, $8C, $CA, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $4B, $81
                db $E1, $01
                db $4D, $B0
                db $E1, $0F
                db $E0, $09
                db $94
                db $E1, $03
                db $E0, $14
                db $86
                db $E1, $0A
                db $E0, $05
                db $AA
                db $E1, $13
                db $07
                db $E0, $16
                db $A9
                db $E1, $14
                db $E0, $11
                db $C7
                db $E1, $0A
                db $E0, $0E
                db $82, $00

; $26A6
                db $04
SFX_54_02:      db $16, $3C, $C3, $64 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $4B, $C9, $81
                db $E1, $14
                db $4D, $B0
                db $E1, $05
                db $E0, $09
                db $94
                db $E1, $11
                db $E0, $14
                db $86
                db $E1, $0A
                db $E0, $05
                db $AA
                db $E1, $02
                db $07
                db $E0, $16
                db $A9
                db $E1, $01
                db $E0, $11
                db $C7
                db $E1, $0A
                db $E0, $0E
                db $82, $00

; $26D2 - Do something very mysterious
                db $04
SFX_55:         db $0F, $5A, $CA, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $23, $82, $92, $89, $00

; $26DC - Storm
                dw SFX_56_02
                db $0C
SFX_56:         db $18, $F0, $CA, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $0B, $8E, $8F, $90, $91, $92, $91, $90
                db $ED, $3C
                db $8F, $7F, $C9, $00

; $26F1
                db $06
SFX_56_02:      db $18, $A0, $C5, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $0B, $AD, $AB, $A9, $A8, $A9
                db $ED, $64
                db $AC, $AD
                db $ED, $3C
                db $B0, $7F, $C9, $00

; $2706 - Dummy inaudible sound (stop sound effects)
                dw SFX_57_02
                db $0A
SFX_57:         db $08, $01, $CA, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $03, $8E, $00

; $2710
                db $04
SFX_57_02:      db $08, $01, $CA, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $03, $8E, $00

; $2718 - Extinguishing blast
                db $06
SFX_58:         db $18, $78, $CA, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $03, $B0, $B5, $B1, $B6
                db $ED, $3C
                db $B2, $B7
                db $ED, $32
                db $B3, $B8
                db $ED, $28
                db $B4, $B9
                db $ED, $1E
                db $B5, $BA, $7F, $C9, $00

; $2735 - Replenish a fuel supply
                dw SFX_59_02
                db $0C
SFX_59:         db $08, $78, $CD, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $07, $B5, $B6, $B7, $B8, $B7, $B6, $B5
                db $ED, $64
                db $B8, $B9, $BA, $BB
                db $ED, $3C
                db $BC, $BD
                db $ED, $28
                db $7F, $C9, $00

; $2753
                db $06
SFX_59_02:      db $08, $3C, $C7, $8C ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $07, $C9, $B5, $B6
                db $ED, $32
                db $B7, $B8, $B7, $B6, $B5
                db $ED, $28
                db $B8, $B9, $BA, $BB
                db $ED, $1E
                db $BC, $BD
                db $ED, $0A
                db $7F, $C9, $00

; $2772 - Tornado
                dw SFX_5A_02
                db $0C
SFX_5A:         db $18, $E6, $CA, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $03, $A4, $B4, $9F, $BB, $A4, $B4, $9F, $BB, $A4, $B4, $9F, $BB, $8C, $A8, $98, $B4, $93, $AF, $98, $B4, $93, $AF, $98, $B4, $93, $AF, $98, $B4, $7F, $C9, $00

; $2799
                db $06
SFX_5A_02:      db $18, $BE, $C1, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $07, $A6, $B0
                db $E1, $14
                db $A1, $B7
                db $E1, $02
                db $A6, $B0
                db $E1, $12
                db $A1, $B7
                db $E1, $04
                db $A6, $B0
                db $E1, $11
                db $A1, $B7
                db $E1, $02
                db $A6, $B0, $7F, $C9, $00

; $27BC - Explosion
                dw L_27E3
                dw L_27C8
                db $10
SFX_5B:         db $F0, $E0, $0F, $E6 ; ??, ??, ??, ??
                db $CA, $0F, $02      ; pan, ??, ??

L_27C8:         db $7D, $5A, $7D, $78, $45
                db $78, $6E, $7D, $37, $32
                db $2D, $28, $23, $1E, $19
                db $14, $14, $12, $0F, $0C
                db $0A, $09, $08, $01, $7F
                db $01, $00

L_27E3:         db $0F, $14, $10, $11, $14
                db $12, $11, $12, $13, $12
                db $11, $10, $11, $12, $11
                db $10, $13, $13, $12, $13
                db $0E, $0E, $0F, $1F

; $27FB - Slimy Pile burp
                db $04
SFX_5C:         db $1A, $BE, $C9, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $0F, $BB, $00

; $2803 - Shield reflect
                dw SFX_5D_02
                db $0A
SFX_5D:         db $07, $DC, $CC, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $45, $81, $9B, $AE
                db $ED, $B4
                db $C5
                db $E1, $0F
                db $ED, $1E
                db $81, $9B, $C6
                db $ED, $1E
                db $E1, $0C
                db $81, $9B, $C6, $00

; $2820
                db $04
SFX_5D_02:      db $19, $F0, $C8, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $01, $C0, $93
                db $ED, $32
                db $8E, $93, $97, $9A, $9F, $A3, $A6, $AB, $AF, $B2
                db $ED, $1E
                db $B8, $BB, $00

; $2839 - Magic Butterfly
                dw SFX_5F_02
                db $0A
SFX_5F:         db $0B, $28, $CF, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $07, $93, $96, $99, $9C, $9F, $A2, $A5, $A8, $AB, $AE, $B1, $B4, $B7, $BA, $BD, $C0, $95, $98, $9B, $9E, $A1, $A4, $A7, $AA, $AD, $B0, $B3, $B6, $B9, $BC, $BF, $C2, $00

; $2862
                db $04
SFX_5F_02:      db $0B, $1E, $C3, $64 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $0B, $C9, $07, $93, $96, $99, $9C, $9F, $A2, $A5, $A8, $AB, $AE, $B1, $B4, $B7, $BA, $BD, $C0, $95, $98, $9B, $9E, $A1, $A4, $A7, $AA, $AD, $B0, $B3, $B6, $B9, $BC, $BF, $C2, $00

; $288B - Ghost
                dw SFX_60_02
                db $0A
SFX_60:         db $0B, $28, $CC, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $0F, $8E
                db $ED, $3C
                db $94
                db $ED, $82
                db $93
                db $ED, $1E
                db $1F, $8D, $00

; $289F
                db $04
SFX_60_02:      db $0B, $1E, $C8, $C8 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $0B, $C9, $0F, $8E
                db $ED, $28
                db $94
                db $ED, $32
                db $93
                db $ED, $1E
                db $1F, $8D, $00

; $28B3 - Pokey gets BEATEN by Aloysius
                dw SFX_62_02
                db $0A
SFX_62:         db $16, $BE, $C8, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $07, $98, $98, $93, $87, $87, $B0, $98, $C9, $87, $B0, $B0, $98, $C9, $87, $C3, $00

; $28CB
                db $04
SFX_62_02:      db $16, $BE, $C5, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $03, $B4, $B4
                db $E1, $0F
                db $B4, $B4
                db $E1, $02
                db $9F, $9F
                db $E1, $12
                db $9F, $9F
                db $E1, $0A
                db $C3, $C3
                db $E1, $0F
                db $B0, $B0
                db $E1, $02
                db $AB, $AB
                db $E1, $12
                db $9F, $9F, $00

; $28F0 - Stairs fast
                db $04
SFX_61:         db $1D, $F0, $CA, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $0B, $9F, $9F, $9F, $9F, $9F, $00

 ; $28FC - Shield Killer/Star Master
                dw SFX_63_02
                db $0A
SFX_63:         db $12, $BE, $CF, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $07, $9A, $9C, $A1, $A3
                db $ED, $8C
                db $A6, $A8, $AD, $AF
                db $ED, $78
                db $B2, $B4, $B9, $BB
                db $ED, $5A
                db $BE, $C0, $C5, $C7, $00

; $291B
                db $04
SFX_63_02:      db $12, $64, $C5, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $1B, $C9, $C9, $07, $9A, $9C, $A1, $A3
                db $ED, $50
                db $A6, $A8, $AD, $AF
                db $ED, $32
                db $B2, $B4, $B9, $BB
                db $ED, $1E
                db $BE, $C0, $C5, $C7, $00

; $293B - Sea of Eden warp
                dw SFX_64_02
                db $0A
SFX_64:         db $12, $96, $CC, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $33, $B4, $B5, $BC, $B9, $BA, $BF
                db $ED, $78
                db $C7, $C2, $BD
                db $ED, $50
                db $C6, $BF, $BA, $00

; $2954
                db $04
SFX_64_02:      db $12, $64, $C5, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $1B, $C9, $33, $B4, $B5, $BC
                db $ED, $50
                db $B9, $BA, $BF
                db $ED, $3C
                db $C7, $C2, $BD
                db $ED, $1E
                db $C6, $BF, $BA, $00

; $296F - Key item fanfare
                dw SFX_66_02
                db $0A
SFX_66:         db $04, $78, $CB, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $07, $B4, $A4, $B4, $B5, $B2, $B5, $1B, $BC, $07
                db $E1, $02
                db $ED, $28
                db $BC
                db $ED, $1E
                db $BC
                db $E1, $12
                db $ED, $14
                db $BC
                db $ED, $0A
                db $BC, $00

; $2991
                db $04
SFX_66_02:      db $04, $78, $C9, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $07, $B0, $AB, $B0, $B2, $AF, $B2, $1B, $B4, $07
                db $E1, $12
                db $ED, $28
                db $B4
                db $ED, $1E
                db $B4
                db $E1, $02
                db $ED, $14
                db $B4
                db $ED, $0A
                db $B4, $00


; $29B1 - PSI learn fanfare
                dw SFX_67_02
                db $0A
SFX_67:         db $05, $78, $CB, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $4B, $B1, $B2, $B4, $B8, $C9, $B6, $B9, $C9
                db $ED, $3C
                db $B8
                db $E1, $02
                db $ED, $28
                db $B9, $C9
                db $ED, $1E
                db $B8
                db $E1, $12
                db $ED, $14
                db $B9, $C9
                db $ED, $0A
                db $B8, $B9, $C9, $B8, $00

; $29DA
                db $04
SFX_67_02:      db $05, $78, $C9, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $4B, $A8, $AA, $AC, $AF, $C9, $AD, $B1, $C9
                db $ED, $32
                db $AF
                db $E1, $12
                db $ED, $1E
                db $B1, $C9
                db $E1, $02
                db $ED, $14
                db $AF
                db $ED, $0A
                db $B1, $C9, $AF, $B1, $C9, $AF, $00

; $29FF - Chick
                db $04
SFX_65:         db $10, $46, $CC, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $1F, $A6
                db $E1, $08
                db $ED, $32
                db $A7, $00

; $2A0C - Chicken
                db $04
SFX_68:         db $0D, $50, $CA, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $05, $B0
                db $ED, $3C
                db $0B, $B7
                db $ED, $50
                db $45, $B0, $00

; $2A1C - Sphinx 1
                dw SFX_69_02
                db $0A
SFX_69:         db $07, $6E, $CC, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $0B, $A4, $B0, $00

; $2A27
                db $04
SFX_69_02:      db $07, $1E, $C5, $14 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $1B, $C9, $0B, $A4, $B0, $00

; $2A32 - Sphinx 2
                dw SFX_6A_02
                db $0A
SFX_6A:         db $07, $6E, $CC, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $0B, $A6, $B2, $00

; $2A3D
                db $04
SFX_6A_02:      db $07, $1E, $C5, $14 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $1B, $C9, $0B, $A6, $B2, $00

; $2A48 - Sphinx 3
                dw SFX_6B_02
                db $0A
SFX_6B:         db $07, $6E, $CC, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $0B, $A8, $B4, $00

; $2A53
                db $04
SFX_6B_02:      db $07, $1E, $C5, $14 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $1B, $C9, $0B, $A8, $B4, $00

; $2A5E - Sphinx 4
                dw SFX_6C_02
                db $0A
SFX_6C:         db $07, $6E, $CC, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $0B, $A9, $B5, $00

; $2A69
                db $04
SFX_6C_02:      db $07, $1E, $C5, $14 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $1B, $C9, $0B, $A9, $B5, $00

; $2A74 - Sphinx 5
                dw SFX_6D_02
                db $0A
SFX_6D:         db $07, $6E, $CC, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $0B, $AB, $B7, $00

; $2A7F
                db $04
SFX_6D_02:      db $07, $1E, $C5, $14 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $1B, $C9, $0B, $AB, $B7, $00

; $2A8A - Sphinx done
                dw SFX_6E_02
                db $0A
SFX_6E:         db $07, $6E, $CC, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $07, $AB, $AC, $AF, $B0, $AF, $AC, $AB
                db $ED, $32
                db $AB, $AC
                db $ED, $1E
                db $AF, $B0
                db $ED, $14
                db $AF, $AC
                db $ED, $0A
                db $AB, $00

; $2AA9
                db $04
SFX_6E_02:      db $07, $1E, $C5, $14 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $1B, $C9, $07, $B7, $B8, $BB, $BC, $BB, $B8, $B7
                db $E1, $02
                db $ED, $14
                db $AB, $AC, $AF, $B0
                db $ED, $0A
                db $AF, $AC, $AB, $00

; $2AC6 - Door knocking
                dw SFX_6F_02
                db $0A
SFX_6F:         db $15, $DC, $C9, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $07, $B0, $B0, $B0, $00

; $2AD2
                db $04
SFX_6F_02:      db $16, $64, $C9, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $07, $8C, $8C, $8C, $00

; $2ADC - Nearly inaudible
                db $04
SFX_70:         db $16, $0A, $C9, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $07, $8C, $00
                db $04 ; Funny extra byte :)

; $2AE5 - Mani Mani glows
                dw SFX_71_02
                db $0A
SFX_71:         db $07, $1E, $C9, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $0B, $AD
                db $ED, $32
                db $B2
                db $ED, $46
                db $B3
                db $ED, $5A
                db $B7, $B8, $BE, $BF
                db $ED, $1E
                db $BF
                db $ED, $46
                db $B9
                db $ED, $28
                db $ED, $14
                db $B9, $B9, $00

; $2B07
                db $04
SFX_71_02:      db $07, $14, $CF, $1E ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $1B, $C9, $0B, $AD
                db $ED, $1E
                db $B2
                db $ED, $28
                db $B3, $B7
                db $ED, $32
                db $B8, $BE, $BF
                db $ED, $0A
                db $BF, $B9, $B9, $B9, $00

; $2B23 - Spooky...
                dw SFX_72_02
                db $0A
SFX_72:         db $08, $32, $C9, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $0F, $B9
                db $ED, $3C
                db $BE
                db $ED, $64
                db $BF
                db $ED, $46
                db $C3
                db $ED, $1E
                db $C2, $00

; $2B39
                db $04
SFX_72_02:      db $08, $14, $CC, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $1B, $C9, $0F, $B9
                db $ED, $1E
                db $BE
                db $ED, $28
                db $BF
                db $ED, $14
                db $C3
                db $ED, $0A
                db $C2, $00

; $2B4F - Equip item
                db $04
SFX_73:         db $0D, $8C, $CA, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $33, $AD, $B5, $05, $B0, $00

; $2B5A - Take item/money
                db $04
SFX_74:         db $12, $BE, $CA, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $33, $BC, $BE, $B4, $00

; $2B64 - Open present (lower volume)
                db $04
SFX_75:         db $12, $C8, $CA, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $33, $B7
                db $ED, $8C
                db $C7, $00

; $2B6F - Give item/money
                db $04
SFX_76:         db $12, $B4, $CA, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $07, $B6, $B8, $B4, $00

; $2B79 - Unlock door
                db $04
SFX_77:         db $12, $BE, $CA, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $33, $B7, $B8, $B8, $B9, $00

; $2B84 - Buy item
                dw SFX_78_02
                db $0A
SFX_78:         db $0D, $64, $C9, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $33, $B4, $35
                db $ED, $50
                db $C0, $00

; $2B92
                db $04
SFX_78_02:      db $0D, $0A, $CC, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $03, $C9, $33, $B4, $0B, $C0, $00

; $2B9E - Pyramid open/Tenda underground open
                dw SFX_79_02
                db $0A
SFX_79:         db $08, $BE, $CA, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $33, $B0, $B5, $B9, $03, $C0, $B7, $C0, $B7
                db $ED, $32
                db $C0, $B7
                db $ED, $1E
                db $C0, $B7, $00

; $2BB7
                db $04
SFX_79_02:      db $08, $3C, $CA, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $33, $C9, $B0, $B5, $B9, $03, $C0, $B7, $C0, $B7
                db $ED, $1E
                db $C0, $B7
                db $ED, $14
                db $C0, $B7, $00

; $2BCF - Name input START button
                dw SFX_5E_02
                db $0A
SFX_5E:         db $10, $BE, $C9, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $13, $9C, $00

; $2BD9
                db $04
SFX_5E_02:      db $10, $14, $CF, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $4B, $C9, $13, $9C, $00

; $2BE3 - Name input add letter
                dw SFX_7A_02
                db $0A
SFX_7A:         db $07, $8C, $C9, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $13, $98, $00

; $2BED
                db $04
SFX_7A_02:      db $07, $78, $CB, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $13, $8C, $00

; $2BF5 - Name input cursor move left/right
                dw SFX_7B_02
                db $0A
SFX_7B:         db $08, $78, $CA, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $45, $C3, $00

; $2BFF
                db $04
SFX_7B_02:      db $08, $14, $CF, $64 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $45, $C3
                db $E1, $05
                db $C3, $00

; $2C0A - Name input cursor move up/down
                dw SFX_7C_02
                db $0A
SFX_7C:         db $05, $82, $C8, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $03, $B9, $13, $B0, $00

; $2C16
                db $04
SFX_7C_02:      db $05, $50, $CF, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $03, $C9, $AD
                db $E1, $05
                db $13, $A4, $00

; $2C23 - Name input backspace
                dw SFX_7D_02
                db $0A
SFX_7D:         db $05, $78, $C2, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $03, $BC
                db $ED, $28
                db $E1, $12
                db $BC
                db $ED, $1E
                db $E1, $03
                db $BC, $00

; $2C37
                db $04
SFX_7D_02:      db $05, $64, $D2, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $03, $C0
                db $ED, $82
                db $E1, $05
                db $C0
                db $E1, $12
                db $C0
                db $ED, $1E
                db $E1, $03
                db $C0, $00

; $2C4C - Name input confirm
                dw SFX_7E_02
                db $0A
SFX_7E:         db $0D, $78, $CA, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $0B, $B7, $C3
                db $E0, $0E
                db $0F, $A3
                db $E1, $02
                db $A4
                db $E1, $10
                db $AB, $00

; $2C61
                db $04
SFX_7E_02:      db $05, $64, $CA, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $03, $BC, $C3, $49, $B4, $C3, $C7
                db $ED, $78
                db $E0, $0E
                db $0B, $B7, $9F, $AD, $00

; $2C76 - Unused, unreachable sound effect
                db $04
L_2C77:         db $0A, $D2, $CA, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $33, $C0, $BC, $00

; $2C7F - Unused, unreachable sound effect
                db $02
L_2C80:         db $04, $02           ; Note length, hold length
                db $08, $E6, $CA, $C5 ; Instrument, volume, pan, note
                db $00                ; Detune

; $2C87 - Unused, unreachable sound effect
                db $02
L_2C88:         db $04, $02           ; Note length, hold length
                db $08, $E6, $CA, $C5 ; Instrument, volume, pan, note
                db $F0                ; Detune
