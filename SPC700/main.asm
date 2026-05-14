; =================================== ;
; EarthBound Sound Driver Disassembly ;
; Disassembled by Catador             ;
; and amended by SupremeKirb          ;
; Revision 2                          ;
; =================================== ;

; Use asar (https://github.com/RPGHacker/asar) to compile it:
; `asar main.asm engine.bin`

; This disassembly has been adjusted to include the footer
; that CoilSnake reads to relocate the song table (past v4.2).
; Remove the footer to create a byte-accurate copy
; of the vanilla sound driver.
; Only do this if you know what it means!

; After assembling,
; move the binary to /Music/Packs/01/engine.bin to use it.

; If you're using CoilSnake 4.2, please be aware
; that the song table may not be moved, which also means
; that the code before it cannot be changed in size.
; Instead, insert new code and data
; at the bottom of the file.

incsrc "macros.asm"
incsrc "ram.asm"

; Disable annoying "this opcode does not exist with 16-bit parameters, assuming 8-bit"
warnings disable Wspc700_assuming_8_bit

norom
org $0000
base $0500

optimize dp always

arch spc700

L_0500:         clrp                            ; 20
L_0501:         mov   x, #$CF                   ; CD CF
L_0503:         mov   sp, x                     ; BD
L_0504:         mov   a, #$00                   ; E8 00
L_0506:         mov   x, a                      ; 5D
L_0507:         mov   (x+), a                   ; AF
L_0508:         cmp   x, #$E0                   ; C8 E0
L_050A:         bne   L_0507                    ; D0 FB
L_050C:         call  L_16A5                    ; 3F A5 16
L_050F:         mov   a, #$55                   ; E8 55
L_0511:         mov   $18, a                    ; C4 18
L_0513:         mov   $19, a                    ; C4 19
L_0515:         mov   a, #$00                   ; E8 00
L_0517:         inc   a                         ; BC
L_0518:         call  SetEchoDelay              ; 3F 2C 0B
L_051B:         set5  $48                       ; A2 48
L_051D:         mov   a, #$70                   ; E8 70
L_051F:         mov   y, #!DSP_MVOLL            ; 8D 0C
L_0521:         call  WriteDsp                  ; 3F 49 07
L_0524:         mov   y, #!DSP_MVOLR            ; 8D 1C
L_0526:         call  WriteDsp                  ; 3F 49 07
L_0529:         mov   a, #$6C                   ; E8 6C
L_052B:         mov   y, #!DSP_DIR              ; 8D 5D
L_052D:         call  WriteDsp                  ; 3F 49 07
L_0530:         mov   a, #%11110000             ; E8 F0    // Reset ports, IPL boot ROM visible
L_0532:         mov.w CONTROL, a                ; C5 F1 00
L_0535:         mov   a, #$10                   ; E8 10
L_0537:         mov.w T0DIV, a                  ; C5 FA 00
L_053A:         mov   $53, a                    ; C4 53
L_053C:         mov   a, #%00000001             ; E8 01    // Start timer0
L_053E:         mov.w CONTROL, a                ; C5 F1 00
L_0541:         bne   L_0546                    ; D0 03
L_0543:         jmp   L_05D8                    ; 5F D8 05

; UPDATE DSP REGISTERS
L_0546:         mov   a, $1B                    ; E4 1B
L_0548:         bne   L_0543                    ; D0 F9
L_054A:         mov   y, #$0A                   ; 8D 0A
L_054C:         cmp   y, #$05                   ; AD 05
L_054E:         beq   L_0557                    ; F0 07
L_0550:         bcs   L_055A                    ; B0 08
L_0552:         cmp   ($4C), ($4D)              ; 69 4D 4C
L_0555:         bne   L_0568                    ; D0 11
L_0557:         bbs7  $4C, L_0568               ; E3 4C 0E
L_055A:         mov   a, Dsp_Addr_Table-1+y     ; F6 A7 0E
L_055D:         mov.w DSPADDR, a                ; C5 F2 00
L_0560:         mov   a, Dsp_Data_Table-1+y     ; F6 B1 0E
L_0563:         mov   x, a                      ; 5D
L_0564:         mov   a, (x)                    ; E6
L_0565:         mov.w DSPDATA, a                ; C5 F3 00
L_0568:         dbnz  y, L_054C                 ; FE E2
L_056A:         mov   $45, y                    ; CB 45
L_056C:         mov   $46, y                    ; CB 46
L_056E:         mov   a, $18                    ; E4 18
L_0570:         eor   a, $19                    ; 44 19
L_0572:         lsr   a                         ; 5C
L_0573:         lsr   a                         ; 5C
L_0574:         notc                            ; ED
L_0575:         ror   $18                       ; 6B 18
L_0577:         ror   $19                       ; 6B 19

; MAIN LOOP
L_0579:         mov.w y, T0OUT                  ; EC FD 00
L_057C:         beq   L_0579                    ; F0 FB
L_057E:         push  y                         ; 6D
L_057F:         mov   a, #$20                   ; E8 20
L_0581:         mul   ya                        ; CF
L_0582:         clrc                            ; 60
L_0583:         adc   a, $43                    ; 84 43
L_0585:         mov   $43, a                    ; C4 43
L_0587:         bcc   L_05CD                    ; 90 44
L_0589:         jmp   L_0596                    ; 5F 96 05
            ;**** 16ms tick ****
L_058C:         mov   a, $04B1                  ; E5 B1 04
L_058F:         cmp   a, #$AA                   ; 68 AA
L_0591:         bne   L_0596                    ; D0 03
L_0593:         call  ResetSpc                  ; 3F FC 05
L_0596:         call  L_1609                    ; 3F 09 16
L_0599:         call  TickFastForward           ; 3F AB 2D // Tick MFX fast forward timer
L_059C:         call  TickVolume240             ; 3F F3 2D // Tick MFX volume 240 timer
L_059F:         call  TickVolume160             ; 3F D5 2D // Tick MFX volume 160 timer
L_05A2:         call  ProcessPort3              ; 3F DC 11 // Process PORT3 (sound effects)
L_05A5:         mov   x, #$03                   ; CD 03
L_05A7:         call  UpdatePort                ; 3F 35 06
L_05AA:         mov   $04B3, a                  ; C5 B3 04
L_05AD:         call  L_2E1D                    ; 3F 1D 2E
L_05B0:         call  ProcessPort2              ; 3F BA 11 // Process PORT2 (static control)
L_05B3:         mov   x, #$02                   ; CD 02
L_05B5:         call  UpdatePort                ; 3F 35 06
L_05B8:         mov   $04B2, a                  ; C5 B2 04
L_05BB:         call  ProcessPort1              ; 3F 98 11 // Process PORT1 (music effects)
L_05BE:         mov   x, #$01                   ; CD 01
L_05C0:         call  UpdatePort                ; 3F 35 06
L_05C3:         mov   $04B1, a                  ; C5 B1 04
L_05C6:         cmp   ($4C), ($4D)              ; 69 4D 4C
L_05C9:         beq   L_05CD                    ; F0 02
L_05CB:         inc   $4C                       ; AB 4C
L_05CD:         mov   a, $53                    ; E4 53
L_05CF:         pop   y                         ; EE
L_05D0:         mul   ya                        ; CF
L_05D1:         clrc                            ; 60
L_05D2:         adc   a, $51                    ; 84 51
L_05D4:         mov   $51, a                    ; C4 51
L_05D6:         bcc   L_05E0                    ; 90 08
            ;**** 2ms*tempo tick ****
L_05D8:         call  PlayMusic                 ; 3F F9 07
L_05DB:         call  UpdatePort0               ; 3F 25 06
L_05DE:         bra   L_05F9                    ; 2F 19

            ;**** 2ms tick ****
L_05E0:         mov   a, music_id               ; E4 04
L_05E2:         beq   L_05F6                    ; F0 12
L_05E4:         mov   x, #$00                   ; CD 00
L_05E6:         mov   $47, #$01                 ; 8F 01 47
L_05E9:         mov   a, $31+x                  ; F4 31
L_05EB:         beq   L_05F0                    ; F0 03
L_05ED:         call  DoVoiceLfo                ; 3F D0 0D // Voice LFO processing (tremolo, vibrato, pan fade, etc)
L_05F0:         inc   x                         ; 3D
L_05F1:         inc   x                         ; 3D
L_05F2:         asl   $47                       ; 0B 47
L_05F4:         bne   L_05E9                    ; D0 F3
L_05F6:         jmp   L_0546                    ; 5F 46 05

L_05F9:         jmp   L_0546                    ; 5F 46 05

; $05FC - Completely resets the SPC700
; (Unreachable)
ResetSpc:       mov   a, #$00                   ; E8 00
L_05FE:         mov   y, #!DSP_EVOLL            ; 8D 2C
L_0600:         call  WriteDsp                  ; 3F 49 07
L_0603:         mov   y, #!DSP_EVOLR            ; 8D 3C
L_0605:         call  WriteDsp                  ; 3F 49 07
L_0608:         mov   a, #$FF                   ; E8 FF
L_060A:         mov   y, #!DSP_KOF              ; 8D 5C
L_060C:         call  WriteDsp                  ; 3F 49 07
L_060F:         mov   a, #$00                   ; E8 00
L_0611:         mov   y, #!DSP_EON              ; 8D 4D
L_0613:         call  WriteDsp                  ; 3F 49 07
L_0616:         mov   a, #$20                   ; E8 20
L_0618:         mov   y, #!DSP_FLG              ; 8D 6C
L_061A:         call  WriteDsp                  ; 3F 49 07
L_061D:         mov   a, #%10000000             ; E8 80    // IPL boot ROM visible
L_061F:         mov.w CONTROL, a                ; C5 F1 00
L_0622:         jmp   $FFC0                     ; 5F C0 FF

; $0625
; Updates the APUIO0 port
UpdatePort0:    mov   a, music_id               ; E4 04
L_0627:         mov.w PORT0, a                  ; C5 F4 00
L_062A:         mov.w a, PORT0                  ; E5 F4 00
L_062D:         cmp.w a, PORT0                  ; 65 F4 00
L_0630:         bne   L_062A                    ; D0 F8
L_0632:         mov   port0_in, a               ; C4 00
L_0634:         ret                             ; 6F

; $0635
; X = APU I/O port to update
UpdatePort:     mov   a, $04A4+x                ; F5 A4 04
L_0638:         mov   $20, a                    ; C4 20
L_063A:         mov.w a, PORT0+x                ; F5 F4 00
L_063D:         cmp.w a, PORT0+x                ; 75 F4 00
L_0640:         bne   L_063A                    ; D0 F8
L_0642:         mov   port0_in+x, a             ; D4 00
L_0644:         mov.w PORT0+x, a                ; D5 F4 00
L_0647:         mov   $04A4+x, a                ; D5 A4 04
L_064A:         cmp   a, $20                    ; 64 20
L_064C:         bne   L_0650                    ; D0 02
L_064E:         mov   a, #$00                   ; E8 00
L_0650:         mov   $04A0+x, a                ; D5 A0 04
L_0653:         ret                             ; 6F

; $0654
; Plays a note
;
; In:
;  A - Note number
;  Y - Note number (yep it's passed both in A and Y)
;
; Behaves like you're used to:
;  0x80 to 0xC7 = C1 to B7
;  0xC8         = Tie
;  0xC9         = Rest
;  0xCA to 0xDF = Percussion note (Play A4 with percussion instrument)
;
PlayNote:       cmp   y, #$CA                   ; AD CA
L_0656:         bcc   L_065D                    ; 90 05
L_0658:         call  VCMD_Instrument           ; 3F 5F 09
L_065B:         mov   y, #$A4                   ; 8D A4
L_065D:         cmp   y, #$C8                   ; AD C8
L_065F:         bcs   L_0653                    ; B0 F2
L_0661:         mov   a, $1A                    ; E4 1A
L_0663:         and   a, $47                    ; 24 47
L_0665:         bne   L_0653                    ; D0 EC
L_0667:         mov   a, y                      ; DD
L_0668:         and   a, #$7F                   ; 28 7F
L_066A:         clrc                            ; 60
L_066B:         adc   a, $50                    ; 84 50
L_066D:         clrc                            ; 60
L_066E:         adc   a, $02F0+x                ; 95 F0 02
L_0671:         mov   $0361+x, a                ; D5 61 03
L_0674:         mov   a, $0381+x                ; F5 81 03
L_0677:         mov   $0360+x, a                ; D5 60 03
L_067A:         mov   a, $02B1+x                ; F5 B1 02
L_067D:         lsr   a                         ; 5C
L_067E:         mov   a, #$00                   ; E8 00
L_0680:         ror   a                         ; 7C
L_0681:         mov   $02A0+x, a                ; D5 A0 02
L_0684:         mov   a, #$00                   ; E8 00
L_0686:         mov   $B0+x, a                  ; D4 B0
L_0688:         mov   $0100+x, a                ; D5 00 01
L_068B:         mov   $02D0+x, a                ; D5 D0 02
L_068E:         mov   $C0+x, a                  ; D4 C0
L_0690:         or    ($5E), ($47)              ; 09 47 5E
L_0693:         or    ($45), ($47)              ; 09 47 45
L_0696:         mov   a, $0280+x                ; F5 80 02
L_0699:         mov   $A0+x, a                  ; D4 A0
L_069B:         beq   L_06BB                    ; F0 1E
L_069D:         mov   a, $0281+x                ; F5 81 02
L_06A0:         mov   $A1+x, a                  ; D4 A1
L_06A2:         mov   a, $0290+x                ; F5 90 02
L_06A5:         bne   L_06B1                    ; D0 0A
L_06A7:         mov   a, $0361+x                ; F5 61 03
L_06AA:         setc                            ; 80
L_06AB:         sbc   a, $0291+x                ; B5 91 02
L_06AE:         mov   $0361+x, a                ; D5 61 03
L_06B1:         mov   a, $0291+x                ; F5 91 02
L_06B4:         clrc                            ; 60
L_06B5:         adc   a, $0361+x                ; 95 61 03
L_06B8:         call  L_0BA4                    ; 3F A4 0B
L_06BB:         call  GetPitch                  ; 3F BC 0B
L_06BE:         mov   y, #$00                   ; 8D 00
L_06C0:         mov   a, $11                    ; E4 11
L_06C2:         setc                            ; 80
L_06C3:         sbc   a, #$34                   ; A8 34
L_06C5:         bcs   L_06D0                    ; B0 09
L_06C7:         mov   a, $11                    ; E4 11
L_06C9:         setc                            ; 80
L_06CA:         sbc   a, #$13                   ; A8 13
L_06CC:         bcs   L_06D4                    ; B0 06
L_06CE:         dec   y                         ; DC
L_06CF:         asl   a                         ; 1C
L_06D0:         addw  ya, $10                   ; 7A 10
L_06D2:         movw  $10, ya                   ; DA 10
L_06D4:         push  x                         ; 4D
L_06D5:         mov   a, $11                    ; E4 11
L_06D7:         asl   a                         ; 1C
L_06D8:         mov   y, #$00                   ; 8D 00
L_06DA:         mov   x, #$18                   ; CD 18
L_06DC:         div   ya, x                     ; 9E
L_06DD:         mov   x, a                      ; 5D
L_06DE:         mov   a, Pitch_Table+1+y        ; F6 BD 0E
L_06E1:         mov   $15, a                    ; C4 15
L_06E3:         mov   a, Pitch_Table+0+y        ; F6 BC 0E
L_06E6:         mov   $14, a                    ; C4 14
L_06E8:         mov   a, Pitch_Table+3+y        ; F6 BF 0E
L_06EB:         push  a                         ; 2D
L_06EC:         mov   a, Pitch_Table+2+y        ; F6 BE 0E
L_06EF:         pop   y                         ; EE
L_06F0:         subw  ya, $14                   ; 9A 14
L_06F2:         mov   y, $10                    ; EB 10
L_06F4:         mul   ya                        ; CF
L_06F5:         mov   a, y                      ; DD
L_06F6:         mov   y, #$00                   ; 8D 00
L_06F8:         addw  ya, $14                   ; 7A 14
L_06FA:         mov   $15, y                    ; CB 15
L_06FC:         asl   a                         ; 1C
L_06FD:         rol   $15                       ; 2B 15
L_06FF:         mov   $14, a                    ; C4 14
L_0701:         bra   L_0707                    ; 2F 04

L_0703:         lsr   $15                       ; 4B 15
L_0705:         ror   a                         ; 7C
L_0706:         inc   x                         ; 3D
L_0707:         cmp   x, #$06                   ; C8 06
L_0709:         bne   L_0703                    ; D0 F8
L_070B:         mov   $14, a                    ; C4 14
L_070D:         pop   x                         ; CE
L_070E:         mov   a, $0220+x                ; F5 20 02
L_0711:         mov   y, $15                    ; EB 15
L_0713:         mul   ya                        ; CF
L_0714:         movw  $16, ya                   ; DA 16
L_0716:         mov   a, $0220+x                ; F5 20 02
L_0719:         mov   y, $14                    ; EB 14
L_071B:         mul   ya                        ; CF
L_071C:         push  y                         ; 6D
L_071D:         mov   a, $0221+x                ; F5 21 02
L_0720:         mov   y, $14                    ; EB 14
L_0722:         mul   ya                        ; CF
L_0723:         addw  ya, $16                   ; 7A 16
L_0725:         movw  $16, ya                   ; DA 16
L_0727:         mov   a, $0221+x                ; F5 21 02
L_072A:         mov   y, $15                    ; EB 15
L_072C:         mul   ya                        ; CF
L_072D:         mov   y, a                      ; FD
L_072E:         pop   a                         ; AE
L_072F:         addw  ya, $16                   ; 7A 16
L_0731:         movw  $16, ya                   ; DA 16
L_0733:         mov   a, x                      ; 7D
L_0734:         xcn   a                         ; 9F
L_0735:         lsr   a                         ; 5C
L_0736:         or    a, #!DSP_VxPL             ; 08 02
L_0738:         mov   y, a                      ; FD
L_0739:         mov   a, $16                    ; E4 16
L_073B:         call  WriteDspMusic             ; 3F 41 07
L_073E:         inc   y                         ; FC
L_073F:         mov   a, $17                    ; E4 17

; $0741
; Writes A into DSP register Y (only if voice is playing music)
WriteDspMusic:  push  a                         ; 2D
L_0742:         mov   a, $47                    ; E4 47
L_0744:         and   a, $1A                    ; 24 1A
L_0746:         pop   a                         ; AE
L_0747:         bne   L_074F                    ; D0 06
                ; FALLTHROUGH
; $0749
; Writes A into DSP register Y
WriteDsp:       mov.w DSPADDR, y                ; CC F2 00
L_074C:         mov.w DSPDATA, a                ; C5 F3 00
L_074F:         ret                             ; 6F

; $0750
NextPatternPtr: mov   y, #$00                   ; 8D 00
L_0752:         mov   a, ($40)+y                ; F7 40
L_0754:         incw  $40                       ; 3A 40
L_0756:         push  a                         ; 2D
L_0757:         mov   a, ($40)+y                ; F7 40
L_0759:         incw  $40                       ; 3A 40
L_075B:         mov   y, a                      ; FD
L_075C:         pop   a                         ; AE
L_075D:         ret                             ; 6F

; $075E
BeginTransfer:  mov   a, #$FF                   ; E8 FF
L_0760:         mov   y, #!DSP_KOF              ; 8D 5C
L_0762:         call  WriteDsp                  ; 3F 49 07
L_0765:         call  L_141A                    ; 3F 1A 14
L_0768:         call  L_1453                    ; 3F 53 14
L_076B:         call  TransferData              ; 3F E1 0E
L_076E:         mov   a, #$00                   ; E8 00
L_0770:         mov   prev_port0_in, a          ; C4 08
                ; FALLTHROUGH
; $0772
StartMusic:     mov   music_id, a               ; C4 04
L_0774:         clrc                            ; 60
L_0775:         adc   a, #$00                   ; 88 00
L_0777:         bmi   L_079A                    ; 30 21
L_0779:         asl   a                         ; 1C
L_077A:         mov   x, a                      ; 5D
L_077B:         mov   a, Song_Table-2+1+x       ; F5 49 2E
L_077E:         mov   y, a                      ; FD
L_077F:         mov   a, Song_Table-2+x         ; F5 48 2E
L_0782:         movw  $40, ya                   ; DA 40
L_0784:         mov   $0C, #$02                 ; 8F 02 0C
L_0787:         mov   a, #$00                   ; E8 00
L_0789:         mov   $0491, a                  ; C5 91 04
L_078C:         mov   $04B1, a                  ; C5 B1 04
L_078F:         mov   $04B5, a                  ; C5 B5 04
L_0792:         mov   a, $1A                    ; E4 1A
L_0794:         eor   a, #$FF                   ; 48 FF
L_0796:         tset  $0046, a                  ; 0E 46 00
L_0799:         ret                             ; 6F

L_079A:         and   a, #$7F                   ; 28 7F
L_079C:         inc   a                         ; BC
L_079D:         asl   a                         ; 1C
L_079E:         mov   x, a                      ; 5D
                ; $FC is $7E * 2
L_079F:         mov   a, Song_Table+$FC+1+x     ; F5 47 2F
L_07A2:         mov   y, a                      ; FD
L_07A3:         mov   a, Song_Table+$FC+x       ; F5 46 2F
L_07A6:         jmp   L_0782                    ; 5F 82 07

; $07A9
; Initialize voices for music playback
InitVoices:     mov   x, #$0E                   ; CD 0E
L_07AB:         mov   $47, #$80                 ; 8F 80 47
L_07AE:         mov   a, #$FF                   ; E8 FF
L_07B0:         mov   $0301+x, a                ; D5 01 03
L_07B3:         mov   a, #$0A                   ; E8 0A
L_07B5:         call  VCMD_Pan                  ; 3F B8 09
L_07B8:         mov   $0211+x, a                ; D5 11 02
L_07BB:         mov   $0381+x, a                ; D5 81 03
L_07BE:         mov   $02F0+x, a                ; D5 F0 02
L_07C1:         mov   $0280+x, a                ; D5 80 02
L_07C4:         mov   voice_muted+x, a          ; D5 00 04
L_07C7:         mov   $B1+x, a                  ; D4 B1
L_07C9:         mov   $C1+x, a                  ; D4 C1
L_07CB:         dec   x                         ; 1D
L_07CC:         dec   x                         ; 1D
L_07CD:         lsr   $47                       ; 4B 47
L_07CF:         bne   L_07AE                    ; D0 DD
L_07D1:         mov   $5A, a                    ; C4 5A
L_07D3:         mov   $68, a                    ; C4 68
L_07D5:         mov   $54, a                    ; C4 54
L_07D7:         mov   $50, a                    ; C4 50
L_07D9:         mov   $42, a                    ; C4 42
L_07DB:         mov   $5F, a                    ; C4 5F
L_07DD:         mov   $59, #$C0                 ; 8F C0 59
L_07E0:         mov   $53, #$20                 ; 8F 20 53
L_07E3:         ret                             ; 6F

; $07E4
JMP_BeginTransfer:
                jmp   BeginTransfer             ; 5F 5E 07

; $07E7
JMP_StartMusic: jmp   StartMusic                ; 5F 72 07

; $07EA
StopMusic:      mov   a, #$00                   ; E8 00
L_07EC:         mov.w PORT0, a                  ; C5 F4 00
L_07EF:         mov   a, #$00                   ; E8 00
L_07F1:         jmp   StartMusic                ; 5F 72 07

L_07F4:         mov   a, prev_port0_in          ; E4 08
L_07F6:         bmi   L_07FF                    ; 30 07
L_07F8:         ret                             ; 6F

; $07F9
; Routine responsible for music playback (yay!)
; Runs a single music tick
PlayMusic:      mov   y, prev_port0_in          ; EB 08
L_07FB:         mov   a, port0_in               ; E4 00
L_07FD:         mov   prev_port0_in, a          ; C4 08
L_07FF:         cmp   a, #$F0                   ; 68 F0
L_0801:         beq   L_0787                    ; F0 84
L_0803:         cmp   a, #$F1                   ; 68 F1
L_0805:         beq   L_080F                    ; F0 08
L_0807:         cmp   a, #$FF                   ; 68 FF
L_0809:         beq   JMP_BeginTransfer         ; F0 D9
L_080B:         cmp   y, port0_in               ; 7E 00
L_080D:         bne   JMP_StartMusic            ; D0 D8
L_080F:         mov   a, music_id               ; E4 04
L_0811:         beq   L_07E3                    ; F0 D0
L_0813:         mov   a, $0C                    ; E4 0C
L_0815:         beq   L_0871                    ; F0 5A
L_0817:         dbnz  $0C, InitVoices           ; 6E 0C 8F
L_081A:         call  NextPatternPtr            ; 3F 50 07
L_081D:         bne   L_0841                    ; D0 22
L_081F:         mov   y, a                      ; FD
L_0820:         beq   StopMusic                 ; F0 C8
L_0822:         cmp   a, #$80                   ; 68 80
L_0824:         beq   L_082C                    ; F0 06
L_0826:         cmp   a, #$81                   ; 68 81
L_0828:         bne   L_0830                    ; D0 06
L_082A:         mov   a, #$00                   ; E8 00
L_082C:         mov   $1B, a                    ; C4 1B
L_082E:         bra   L_081A                    ; 2F EA

L_0830:         dec   $42                       ; 8B 42
L_0832:         bpl   L_0836                    ; 10 02
L_0834:         mov   $42, a                    ; C4 42
L_0836:         call  NextPatternPtr            ; 3F 50 07
L_0839:         mov   x, $42                    ; F8 42
L_083B:         beq   L_081A                    ; F0 DD
L_083D:         movw  $40, ya                   ; DA 40
L_083F:         bra   L_081A                    ; 2F D9

L_0841:         movw  $16, ya                   ; DA 16
L_0843:         mov   y, #$0F                   ; 8D 0F
L_0845:         mov   a, ($16)+y                ; F7 16
L_0847:         mov   $0030+y, a                ; D6 30 00
L_084A:         dec   y                         ; DC
L_084B:         bpl   L_0845                    ; 10 F8
L_084D:         mov   x, #$00                   ; CD 00
L_084F:         mov   $47, #$01                 ; 8F 01 47
L_0852:         mov   a, $31+x                  ; F4 31
L_0854:         beq   L_0860                    ; F0 0A
L_0856:         mov   a, $0211+x                ; F5 11 02
L_0859:         bne   L_0860                    ; D0 05
L_085B:         mov   a, #$00                   ; E8 00
L_085D:         call  VCMD_Instrument           ; 3F 5F 09
L_0860:         mov   a, #$00                   ; E8 00
L_0862:         mov   $80+x, a                  ; D4 80
L_0864:         mov   $90+x, a                  ; D4 90
L_0866:         mov   $91+x, a                  ; D4 91
L_0868:         inc   a                         ; BC
L_0869:         mov   $70+x, a                  ; D4 70
L_086B:         inc   x                         ; 3D
L_086C:         inc   x                         ; 3D
L_086D:         asl   $47                       ; 0B 47
L_086F:         bne   L_0852                    ; D0 E1
L_0871:         mov   x, #$00                   ; CD 00
L_0873:         mov   $5E, x                    ; D8 5E
L_0875:         mov   $47, #$01                 ; 8F 01 47
L_0878:         mov   $44, x                    ; D8 44
L_087A:         mov   a, $31+x                  ; F4 31
L_087C:         beq   L_08F0                    ; F0 72
L_087E:         dec   $70+x                     ; 9B 70
L_0880:         bne   L_08E6                    ; D0 64
L_0882:         call  GetNextByte               ; 3F 55 09
L_0885:         bne   L_089E                    ; D0 17
L_0887:         mov   a, $80+x                  ; F4 80
L_0889:         beq   L_081A                    ; F0 8F
L_088B:         call  L_0AC4                    ; 3F C4 0A
L_088E:         dec   $80+x                     ; 9B 80
L_0890:         bne   L_0882                    ; D0 F0
L_0892:         mov   a, $0230+x                ; F5 30 02
L_0895:         mov   $30+x, a                  ; D4 30
L_0897:         mov   a, $0231+x                ; F5 31 02
L_089A:         mov   $31+x, a                  ; D4 31
L_089C:         bra   L_0882                    ; 2F E4

L_089E:         bmi   L_08C0                    ; 30 20
L_08A0:         mov   $0200+x, a                ; D5 00 02
L_08A3:         call  GetNextByte               ; 3F 55 09
L_08A6:         bmi   L_08C0                    ; 30 18
L_08A8:         push  a                         ; 2D
L_08A9:         xcn   a                         ; 9F
L_08AA:         and   a, #$07                   ; 28 07
L_08AC:         mov   y, a                      ; FD
L_08AD:         mov   a, $6F80+y                ; F6 80 6F
L_08B0:         mov   $0201+x, a                ; D5 01 02
L_08B3:         pop   a                         ; AE
L_08B4:         and   a, #$0F                   ; 28 0F
L_08B6:         mov   y, a                      ; FD
L_08B7:         mov   a, $6F88+y                ; F6 88 6F
L_08BA:         mov   $0210+x, a                ; D5 10 02
L_08BD:         call  GetNextByte               ; 3F 55 09
L_08C0:         cmp   a, #$E0                   ; 68 E0
L_08C2:         bcc   L_08C9                    ; 90 05
L_08C4:         call  L_0943                    ; 3F 43 09
L_08C7:         bra   L_0882                    ; 2F B9

L_08C9:         mov   a, voice_muted+x          ; F5 00 04
L_08CC:         or    a, $1B                    ; 04 1B
L_08CE:         bne   L_08D4                    ; D0 04
L_08D0:         mov   a, y                      ; DD
L_08D1:         call  PlayNote                  ; 3F 54 06
L_08D4:         mov   a, $0200+x                ; F5 00 02
L_08D7:         mov   $70+x, a                  ; D4 70
L_08D9:         mov   y, a                      ; FD
L_08DA:         mov   a, $0201+x                ; F5 01 02
L_08DD:         mul   ya                        ; CF
L_08DE:         mov   a, y                      ; DD
L_08DF:         bne   L_08E2                    ; D0 01
L_08E1:         inc   a                         ; BC
L_08E2:         mov   $71+x, a                  ; D4 71
L_08E4:         bra   L_08ED                    ; 2F 07

L_08E6:         mov   a, $1B                    ; E4 1B
L_08E8:         bne   L_08F0                    ; D0 06
L_08EA:         call  L_0CF7                    ; 3F F7 0C
L_08ED:         call  CheckNoteSlide            ; 3F 84 0B
L_08F0:         inc   x                         ; 3D
L_08F1:         inc   x                         ; 3D
L_08F2:         asl   $47                       ; 0B 47
L_08F4:         bne   L_0878                    ; D0 82
L_08F6:         mov   a, $54                    ; E4 54
L_08F8:         beq   L_0905                    ; F0 0B
L_08FA:         movw  ya, $56                   ; BA 56
L_08FC:         addw  ya, $52                   ; 7A 52
L_08FE:         dbnz  $54, L_0903               ; 6E 54 02
L_0901:         movw  ya, $54                   ; BA 54
L_0903:         movw  $52, ya                   ; DA 52
L_0905:         mov   a, $68                    ; E4 68
L_0907:         beq   L_091E                    ; F0 15
L_0909:         movw  ya, $64                   ; BA 64
L_090B:         addw  ya, $60                   ; 7A 60
L_090D:         movw  $60, ya                   ; DA 60
L_090F:         movw  ya, $66                   ; BA 66
L_0911:         addw  ya, $62                   ; 7A 62
L_0913:         dbnz  $68, L_091C               ; 6E 68 06
L_0916:         movw  ya, $68                   ; BA 68
L_0918:         movw  $60, ya                   ; DA 60
L_091A:         mov   y, $6A                    ; EB 6A
L_091C:         movw  $62, ya                   ; DA 62
L_091E:         mov   a, $5A                    ; E4 5A
L_0920:         beq   L_0930                    ; F0 0E
L_0922:         movw  ya, $5C                   ; BA 5C
L_0924:         addw  ya, $58                   ; 7A 58
L_0926:         dbnz  $5A, L_092B               ; 6E 5A 02
L_0929:         movw  ya, $5A                   ; BA 5A
L_092B:         movw  $58, ya                   ; DA 58
L_092D:         mov   $5E, #$FF                 ; 8F FF 5E
L_0930:         mov   x, #$00                   ; CD 00
L_0932:         mov   $47, #$01                 ; 8F 01 47
L_0935:         mov   a, $31+x                  ; F4 31
L_0937:         beq   L_093C                    ; F0 03
L_0939:         call  DoVoiceFades              ; 3F 40 0C
L_093C:         inc   x                         ; 3D
L_093D:         inc   x                         ; 3D
L_093E:         asl   $47                       ; 0B 47
L_0940:         bne   L_0935                    ; D0 F3
L_0942:         ret                             ; 6F

L_0943:         asl   a                         ; 1C
L_0944:         mov   y, a                      ; FD
L_0945:         mov   a, VCMD_Jump_Table-$C0+1+y; F6 24 0B
L_0948:         push  a                         ; 2D
L_0949:         mov   a, VCMD_Jump_Table-$C0+0+y; F6 23 0B
L_094C:         push  a                         ; 2D
L_094D:         mov   a, y                      ; DD
L_094E:         lsr   a                         ; 5C
L_094F:         mov   y, a                      ; FD
L_0950:         mov   a, VCMD_Arg_Length-$60+y  ; F6 C1 0B
L_0953:         beq   L_095D                    ; F0 08

; $0955
; Gets a music data byte for voice X in A and Y, and advances the pointer
GetNextByte:    mov   a, ($30+x)                ; E7 30
                ; FALLTHROUGH
; $0957
; Increments music data pointer for voice X
SkipByte:       inc   $30+x                     ; BB 30
L_0959:         bne   L_095D                    ; D0 02
L_095B:         inc   $31+x                     ; BB 31
L_095D:         mov   y, a                      ; FD
L_095E:         ret                             ; 6F

; $095F
VCMD_Instrument:
                mov   $0211+x, a                ; D5 11 02
                ; FALLTHROUGH
; $0962
SetInstrument:  mov   y, a                      ; FD
L_0963:         bpl   L_096B                    ; 10 06
L_0965:         setc                            ; 80
L_0966:         sbc   a, #$CA                   ; A8 CA
L_0968:         clrc                            ; 60
L_0969:         adc   a, $5F                    ; 84 5F
L_096B:         mov   y, #$06                   ; 8D 06
L_096D:         mul   ya                        ; CF
L_096E:         movw  $14, ya                   ; DA 14
L_0970:         clrc                            ; 60
L_0971:         adc   $14, #$00                 ; 98 00 14
L_0974:         adc   $15, #$6E                 ; 98 6E 15
L_0977:         mov   a, $1A                    ; E4 1A
L_0979:         and   a, $47                    ; 24 47
L_097B:         bne   L_09B7                    ; D0 3A
L_097D:         push  x                         ; 4D
L_097E:         mov   a, x                      ; 7D
L_097F:         xcn   a                         ; 9F
L_0980:         lsr   a                         ; 5C
L_0981:         or    a, #!DSP_VxSRCN           ; 08 04
L_0983:         mov   x, a                      ; 5D
L_0984:         mov   y, #$00                   ; 8D 00
L_0986:         mov   a, ($14)+y                ; F7 14
L_0988:         bpl   L_0998                    ; 10 0E
L_098A:         and   a, #$1F                   ; 28 1F
L_098C:         and   $48, #$20                 ; 38 20 48
L_098F:         tset  $0048, a                  ; 0E 48 00
L_0992:         or    ($49), ($47)              ; 09 47 49
L_0995:         mov   a, y                      ; DD
L_0996:         bra   L_099F                    ; 2F 07

L_0998:         mov   a, $47                    ; E4 47
L_099A:         tclr  $0049, a                  ; 4E 49 00
L_099D:         mov   a, ($14)+y                ; F7 14
L_099F:         mov.w DSPADDR, x                ; C9 F2 00
L_09A2:         mov.w DSPDATA, a                ; C5 F3 00
L_09A5:         inc   x                         ; 3D
L_09A6:         inc   y                         ; FC
L_09A7:         cmp   y, #$04                   ; AD 04
L_09A9:         bne   L_099D                    ; D0 F2
L_09AB:         pop   x                         ; CE
L_09AC:         mov   a, ($14)+y                ; F7 14
L_09AE:         mov   $0221+x, a                ; D5 21 02
L_09B1:         inc   y                         ; FC
L_09B2:         mov   a, ($14)+y                ; F7 14
L_09B4:         mov   $0220+x, a                ; D5 20 02
L_09B7:         ret                             ; 6F

; $09B8
VCMD_Pan:       mov   $20, a                    ; C4 20
L_09BA:         mov   a, mono_flag              ; E5 31 04
L_09BD:         cmp   a, #$00                   ; 68 00    // OOF!
L_09BF:         beq   L_09C6                    ; F0 05
L_09C1:         mov   a, #$0A                   ; E8 0A
L_09C3:         jmp   L_09C8                    ; 5F C8 09 // OUCH!

L_09C6:         mov   a, $20                    ; E4 20
L_09C8:         mov   $0351+x, a                ; D5 51 03
L_09CB:         and   a, #$1F                   ; 28 1F
L_09CD:         mov   $0331+x, a                ; D5 31 03
L_09D0:         mov   a, #$00                   ; E8 00
L_09D2:         mov   $0330+x, a                ; D5 30 03
L_09D5:         ret                             ; 6F

; $09D8
VCMD_PanFade:   mov   $91+x, a                  ; D4 91
L_09D8:         push  a                         ; 2D
L_09D9:         call  GetNextByte               ; 3F 55 09
L_09DC:         mov   $20, a                    ; C4 20
L_09DE:         mov   a, mono_flag              ; E5 31 04
L_09E1:         cmp   a, #$00                   ; 68 00
L_09E3:         beq   L_09E8                    ; F0 03
L_09E5:         mov   $20, #$0A                 ; 8F 0A 20
L_09E8:         mov   a, $20                    ; E4 20
L_09EA:         mov   $0350+x, a                ; D5 50 03
L_09ED:         setc                            ; 80
L_09EE:         sbc   a, $0331+x                ; B5 31 03
L_09F1:         pop   x                         ; CE
L_09F2:         call  DivideWithFraction        ; 3F C7 0B
L_09F5:         mov   $0340+x, a                ; D5 40 03
L_09F8:         mov   a, y                      ; DD
L_09F9:         mov   $0341+x, a                ; D5 41 03
L_09FC:         ret                             ; 6F

; $09FD
VCMD_Vibrato:   mov   $02B0+x, a                ; D5 B0 02
L_0A00:         call  GetNextByte               ; 3F 55 09
L_0A03:         mov   $02A1+x, a                ; D5 A1 02
L_0A06:         call  GetNextByte               ; 3F 55 09
                ; FALLTHROUGH
; $0A09
VCMD_VibratoOff:
                mov   $B1+x, a                  ; D4 B1
L_0A0B:         mov   $02C1+x, a                ; D5 C1 02
L_0A0E:         mov   a, #$00                   ; E8 00
L_0A10:         mov   $02B1+x, a                ; D5 B1 02
L_0A13:         ret                             ; 6F

; $0A14
VCMD_VibratoFade:
                mov   $02B1+x, a                ; D5 B1 02
L_0A17:         push  a                         ; 2D
L_0A18:         mov   y, #$00                   ; 8D 00
L_0A1A:         mov   a, $B1+x                  ; F4 B1
L_0A1C:         pop   x                         ; CE
L_0A1D:         div   ya, x                     ; 9E
L_0A1E:         mov   x, $44                    ; F8 44
L_0A20:         mov   $02C0+x, a                ; D5 C0 02
L_0A23:         ret                             ; 6F

; $0A24
VCMD_Volume:    mov   a, #$00                   ; E8 00
L_0A26:         movw  $58, ya                   ; DA 58
L_0A28:         ret                             ; 6F

; $0A29
VCMD_VolumeFade:
                mov   $5A, a                    ; C4 5A
L_0A2B:         call  GetNextByte               ; 3F 55 09
L_0A2E:         mov   $5B, a                    ; C4 5B
L_0A30:         setc                            ; 80
L_0A31:         sbc   a, $59                    ; A4 59
L_0A33:         mov   x, $5A                    ; F8 5A
L_0A35:         call  DivideWithFraction        ; 3F C7 0B
L_0A38:         movw  $5C, ya                   ; DA 5C
L_0A3A:         ret                             ; 6F

; $0A3B
VCMD_Tempo:     mov   a, #$00                   ; E8 00
L_0A3D:         movw  $52, ya                   ; DA 52
L_0A3F:         ret                             ; 6F

; $0A40
VCMD_TempoFade: mov   $54, a                    ; C4 54
L_0A42:         call  GetNextByte               ; 3F 55 09
L_0A45:         mov   $55, a                    ; C4 55
L_0A47:         setc                            ; 80
L_0A48:         sbc   a, $53                    ; A4 53
L_0A4A:         mov   x, $54                    ; F8 54
L_0A4C:         call  DivideWithFraction        ; 3F C7 0B
L_0A4F:         movw  $56, ya                   ; DA 56
L_0A51:         ret                             ; 6F

; $0A52
VCMD_Transpose: mov   $50, a                    ; C4 50
L_0A54:         ret                             ; 6F

; $0A55
VCMD_VoiceTranspose:
                mov   $02F0+x, a                ; D5 F0 02
L_0A58:         ret                             ; 6F

; $0A59
VCMD_Tremolo:   mov   $02E0+x, a                ; D5 E0 02
L_0A5C:         call  GetNextByte               ; 3F 55 09
L_0A5F:         mov   $02D1+x, a                ; D5 D1 02
L_0A62:         call  GetNextByte               ; 3F 55 09
                ; FALLTHROUGH
; $0A65
VCMD_TremoloOff:
                mov   $C1+x, a                  ; D4 C1
L_0A67:         ret                             ; 6F

; $0A68
VCMD_PortamentoTo:
                mov   a, #$01                   ; E8 01
L_0A6A:         bra   L_0A6E                    ; 2F 02

; $0A6C
VCMD_PortamentoFrom:
                mov   a, #$00                   ; E8 00
L_0A6E:         mov   $0290+x, a                ; D5 90 02
L_0A71:         mov   a, y                      ; DD
L_0A72:         mov   $0281+x, a                ; D5 81 02
L_0A75:         call  GetNextByte               ; 3F 55 09
L_0A78:         mov   $0280+x, a                ; D5 80 02
L_0A7B:         call  GetNextByte               ; 3F 55 09
L_0A7E:         mov   $0291+x, a                ; D5 91 02
L_0A81:         ret                             ; 6F

; $0A82
VCMD_PortamentoOff:
                mov   $0280+x, a                ; D5 80 02
L_0A85:         ret                             ; 6F

; $0A86
VCMD_VoiceVolume:
                mov   $0301+x, a                ; D5 01 03
L_0A89:         mov   a, #$00                   ; E8 00
L_0A8B:         mov   $0300+x, a                ; D5 00 03
L_0A8E:         ret                             ; 6F

; $0A8F
VCMD_VoiceVolumeFade:
                mov   $90+x, a                  ; D4 90
L_0A91:         push  a                         ; 2D
L_0A92:         call  GetNextByte               ; 3F 55 09
L_0A95:         mov   $0320+x, a                ; D5 20 03
L_0A98:         setc                            ; 80
L_0A99:         sbc   a, $0301+x                ; B5 01 03
L_0A9C:         pop   x                         ; CE
L_0A9D:         call  DivideWithFraction        ; 3F C7 0B
L_0AA0:         mov   $0310+x, a                ; D5 10 03
L_0AA3:         mov   a, y                      ; DD
L_0AA4:         mov   $0311+x, a                ; D5 11 03
L_0AA7:         ret                             ; 6F

; $0AA8
VCMD_Detune:    mov   $0381+x, a                ; D5 81 03
L_0AAB:         ret                             ; 6F

; $0AAC
VCMD_Subroutine:
                mov   $0240+x, a                ; D5 40 02
L_0AAF:         call  GetNextByte               ; 3F 55 09
L_0AB2:         mov   $0241+x, a                ; D5 41 02
L_0AB5:         call  GetNextByte               ; 3F 55 09
L_0AB8:         mov   $80+x, a                  ; D4 80
L_0ABA:         mov   a, $30+x                  ; F4 30
L_0ABC:         mov   $0230+x, a                ; D5 30 02
L_0ABF:         mov   a, $31+x                  ; F4 31
L_0AC1:         mov   $0231+x, a                ; D5 31 02
L_0AC4:         mov   a, $0240+x                ; F5 40 02
L_0AC7:         mov   $30+x, a                  ; D4 30
L_0AC9:         mov   a, $0241+x                ; F5 41 02
L_0ACC:         mov   $31+x, a                  ; D4 31
L_0ACE:         ret                             ; 6F

; $0ACF
VCMD_EchoVolume:
                mov   $4A, a                    ; C4 4A
L_0AD1:         call  GetNextByte               ; 3F 55 09
L_0AD4:         mov   a, #$00                   ; E8 00
L_0AD6:         movw  $60, ya                   ; DA 60
L_0AD8:         call  GetNextByte               ; 3F 55 09
L_0ADB:         mov   a, #$00                   ; E8 00
L_0ADD:         movw  $62, ya                   ; DA 62
L_0ADF:         clr5  $48                       ; B2 48
L_0AE1:         ret                             ; 6F

; $0AE2
VCMD_EchoVolumeFade:
L_0AE2:         mov   $68, a                    ; C4 68
L_0AE4:         call  GetNextByte               ; 3F 55 09
L_0AE7:         mov   $69, a                    ; C4 69
L_0AE9:         setc                            ; 80
L_0AEA:         sbc   a, $61                    ; A4 61
L_0AEC:         mov   x, $68                    ; F8 68
L_0AEE:         call  DivideWithFraction        ; 3F C7 0B
L_0AF1:         movw  $64, ya                   ; DA 64
L_0AF3:         call  GetNextByte               ; 3F 55 09
L_0AF6:         mov   $6A, a                    ; C4 6A
L_0AF8:         setc                            ; 80
L_0AF9:         sbc   a, $63                    ; A4 63
L_0AFB:         mov   x, $68                    ; F8 68
L_0AFD:         call  DivideWithFraction        ; 3F C7 0B
L_0B00:         movw  $66, ya                   ; DA 66
L_0B02:         ret                             ; 6F

; $0B03
VCMD_EchoOff:   movw  $60, ya                   ; DA 60
L_0B05:         movw  $62, ya                   ; DA 62
L_0B07:         set5  $48                       ; A2 48
L_0B09:         ret                             ; 6F

; $0B0A
VCMD_EchoParameters:
                call  SetEchoDelay              ; 3F 2C 0B
L_0B0D:         call  GetNextByte               ; 3F 55 09
L_0B10:         mov   $4E, a                    ; C4 4E
L_0B12:         call  GetNextByte               ; 3F 55 09
L_0B15:         mov   y, #$08                   ; 8D 08
L_0B17:         mul   ya                        ; CF
L_0B18:         mov   x, a                      ; 5D
L_0B19:         mov   y, #!DSP_COEFF            ; 8D 0F
L_0B1B:         mov   a, Filter_Table+x         ; F5 88 0E
L_0B1E:         call  WriteDsp                  ; 3F 49 07
L_0B21:         inc   x                         ; 3D
L_0B22:         mov   a, y                      ; DD
L_0B23:         clrc                            ; 60
L_0B24:         adc   a, #$10                   ; 88 10
L_0B26:         mov   y, a                      ; FD
L_0B27:         bpl   L_0B1B                    ; 10 F2
L_0B29:         mov   x, $44                    ; F8 44
L_0B2B:         ret                             ; 6F

; $0B2C
SetEchoDelay:   mov   $4D, a                    ; C4 4D
L_0B2E:         mov   y, #!DSP_EDL              ; 8D 7D
L_0B30:         mov.w DSPADDR, y                ; CC F2 00
L_0B33:         mov.w a, DSPDATA                ; E5 F3 00
L_0B36:         cmp   a, $4D                    ; 64 4D
L_0B38:         beq   L_0B65                    ; F0 2B
L_0B3A:         and   a, #$0F                   ; 28 0F
L_0B3C:         eor   a, #$FF                   ; 48 FF
L_0B3E:         bbc7  $4C, L_0B44               ; F3 4C 03
L_0B41:         clrc                            ; 60
L_0B42:         adc   a, $4C                    ; 84 4C
L_0B44:         mov   $4C, a                    ; C4 4C
L_0B46:         mov   y, #$04                   ; 8D 04
L_0B48:         mov   a, Dsp_Addr_Table-1+y     ; F6 A7 0E
L_0B4B:         mov.w DSPADDR, a                ; C5 F2 00
L_0B4E:         mov   a, #$00                   ; E8 00
L_0B50:         mov.w DSPDATA, a                ; C5 F3 00
L_0B53:         dbnz  y, L_0B48                 ; FE F3
L_0B55:         mov   a, $48                    ; E4 48
L_0B57:         or    a, #$20                   ; 08 20
L_0B59:         mov   y, #!DSP_FLG              ; 8D 6C
L_0B5B:         call  WriteDsp                  ; 3F 49 07
L_0B5E:         mov   a, $4D                    ; E4 4D
L_0B60:         mov   y, #!DSP_EDL              ; 8D 7D
L_0B62:         call  WriteDsp                  ; 3F 49 07
L_0B65:         asl   a                         ; 1C
L_0B66:         asl   a                         ; 1C
L_0B67:         asl   a                         ; 1C
L_0B68:         eor   a, #$FF                   ; 48 FF
L_0B6A:         setc                            ; 80
L_0B6B:         adc   a, #$FF                   ; 88 FF
L_0B6D:         mov   y, #!DSP_ESA              ; 8D 6D
L_0B6F:         jmp   WriteDsp                  ; 5F 49 07

; $0B72
VCMD_PercussionInstrument:
                mov   $5F, a                    ; C4 5F
L_0B74:         ret                             ; 6F

; $0B75
VCMD_Nop:       call  SkipByte                  ; 3F 57 09
L_0B78:         ret                             ; 6F

; $0B79
VCMD_MuteVoice: inc   a                         ; BC
L_0B7A:         mov   voice_muted+x, a          ; D5 00 04
L_0B7D:         ret                             ; 6F

; $0B7E
VCMD_FastForward:
                inc   a                         ; BC
                ; FALLTHROUGH
; $0B7F
VCMD_FastForwardOff:
                mov   $1B, a                    ; C4 1B
L_0B81:         jmp   L_0787                    ; 5F 87 07

; $0B84
CheckNoteSlide: mov   a, $A0+x                  ; F4 A0
L_0B86:         bne   L_0BBB                    ; D0 33
L_0B88:         mov   a, ($30+x)                ; E7 30
L_0B8A:         cmp   a, #$F9                   ; 68 F9
L_0B8C:         bne   L_0BBB                    ; D0 2D
L_0B8E:         call  SkipByte                  ; 3F 57 09
L_0B91:         call  GetNextByte               ; 3F 55 09
                ; FALLTHROUGH
; $0B94
VCMD_NoteSlide: mov   $A1+x, a                  ; D4 A1
L_0B96:         call  GetNextByte               ; 3F 55 09
L_0B99:         mov   $A0+x, a                  ; D4 A0
L_0B9B:         call  GetNextByte               ; 3F 55 09
L_0B9E:         clrc                            ; 60
L_0B9F:         adc   a, $50                    ; 84 50
L_0BA1:         adc   a, $02F0+x                ; 95 F0 02
L_0BA4:         and   a, #$7F                   ; 28 7F
L_0BA6:         mov   $0380+x, a                ; D5 80 03
L_0BA9:         setc                            ; 80
L_0BAA:         sbc   a, $0361+x                ; B5 61 03
L_0BAD:         mov   y, $A0+x                  ; FB A0
L_0BAF:         push  y                         ; 6D
L_0BB0:         pop   x                         ; CE
L_0BB1:         call  DivideWithFraction        ; 3F C7 0B
L_0BB4:         mov   $0370+x, a                ; D5 70 03
L_0BB7:         mov   a, y                      ; DD
L_0BB8:         mov   $0371+x, a                ; D5 71 03
L_0BBB:         ret                             ; 6F

; $0BBC
; Stores voice pitch into $10/$11
GetPitch:       mov   a, $0361+x                ; F5 61 03
L_0BBF:         mov   $11, a                    ; C4 11
L_0BC1:         mov   a, $0360+x                ; F5 60 03
L_0BC4:         mov   $10, a                    ; C4 10
L_0BC6:         ret                             ; 6F

;**********************************************************
; $0BC7
;
; 8-bit division with 16-bit fixed-point result
; (e.g. 5 / 2 = 2.5, or 0x0280)
;
; In:
;   CARRY -> Set if dividend is positive, clear otherwise
;   A     -> Dividend
;   X     -> Divisor
;
; Out:
;   YA    -> Quotient (Y = whole, A = fraction)
;
; Clobbers `temp2` (byte) and `temp4` (word)
;
; Algorithm:
;   negative = dividend < 0
;   if negative: dividend = -dividend
;
;   high = dividend / divisor
;   low = ((dividend % divisor) << 8) / divisor
;   result = (high << 8) | low
;   if negative: result = -result
;   return result
;
DivideWithFraction:
                notc                            ; ED
L_0BC8:         ror   $12                       ; 6B 12
L_0BCA:         bpl   L_0BCF                    ; 10 03
L_0BCC:         eor   a, #$FF                   ; 48 FF
L_0BCE:         inc   a                         ; BC
L_0BCF:         mov   y, #$00                   ; 8D 00
L_0BD1:         div   ya, x                     ; 9E
L_0BD2:         push  a                         ; 2D
L_0BD3:         mov   a, #$00                   ; E8 00
L_0BD5:         div   ya, x                     ; 9E
L_0BD6:         pop   y                         ; EE
L_0BD7:         mov   x, $44                    ; F8 44
L_0BD9:         bbc7  $12, L_0BE2               ; F3 12 06
L_0BDC:         movw  $14, ya                   ; DA 14
L_0BDE:         movw  ya, $0E                   ; BA 0E
L_0BE0:         subw  ya, $14                   ; 9A 14
L_0BE2:         ret                             ; 6F

; $0BE3
VCMD_Jump_Table:
                dw VCMD_Instrument           ; [E0 instrument]
                dw VCMD_Pan                  ; [E1 pan]
                dw VCMD_PanFade              ; [E2 length destination]
                dw VCMD_Vibrato              ; [E3 delay frequency amplitude]
                dw VCMD_VibratoOff           ; [E4]
                dw VCMD_Volume               ; [E5 volume]
                dw VCMD_VolumeFade           ; [E6 length destination]
                dw VCMD_Tempo                ; [E7 tempo]
                dw VCMD_TempoFade            ; [E8 length destination]
                dw VCMD_Transpose            ; [E9 semitones]
                dw VCMD_VoiceTranspose       ; [EA semitones]
                dw VCMD_Tremolo              ; [EB delay frequency amplitude]
                dw VCMD_TremoloOff           ; [EC]
                dw VCMD_VoiceVolume          ; [ED volume]
                dw VCMD_VoiceVolumeFade      ; [EE length destination]
                dw VCMD_Subroutine           ; [EF address count]
                dw VCMD_VibratoFade          ; [F0 length]
                dw VCMD_PortamentoTo         ; [F1 delay length semitones]
                dw VCMD_PortamentoFrom       ; [F2 delay length semitones]
                dw VCMD_PortamentoOff        ; [F3]
                dw VCMD_Detune               ; [F4 detune] (in units of 256th of a semitone)
                dw VCMD_EchoVolume           ; [F5 voicebits left right]
                dw VCMD_EchoOff              ; [F6]
                dw VCMD_EchoParameters       ; [F7 delay feedback filter]
                dw VCMD_EchoVolumeFade       ; [F8 length destinationleft destinationright]
                dw VCMD_NoteSlide            ; [F9 delay length note]
                dw VCMD_PercussionInstrument ; [FA instrument]
                dw VCMD_Nop                  ; [FB ignored1 ignored2]
                dw VCMD_MuteVoice            ; [FC]
                dw VCMD_FastForward          ; [FD]
                dw VCMD_FastForwardOff       ; [FE]

; $0C21
VCMD_Arg_Length:
                 ; 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
                db 1, 1, 2, 3, 0, 1, 2, 1, 2, 1, 1, 3, 0, 1, 2, 3 ; Ex
                db 1, 3, 3, 0, 1, 3, 0, 3, 3, 3, 1, 2, 0, 0, 0

; $0C40
DoVoiceFades:   mov   a, $90+x                  ; F4 90
L_0C42:         beq   L_0C4D                    ; F0 09
L_0C44:         mov   a, #$00                   ; E8 00
L_0C46:         mov   y, #$03                   ; 8D 03
L_0C48:         dec   $90+x                     ; 9B 90
L_0C4A:         call  VoiceFadeWithVolumeChange ; 3F D3 0C
L_0C4D:         mov   y, $C1+x                  ; FB C1
L_0C4F:         beq   L_0C74                    ; F0 23
L_0C51:         mov   a, $02E0+x                ; F5 E0 02
L_0C54:         cbne  $C0+x, L_0C72             ; DE C0 1B
L_0C57:         or    ($5E), ($47)              ; 09 47 5E
L_0C5A:         mov   a, $02D0+x                ; F5 D0 02
L_0C5D:         bpl   L_0C66                    ; 10 07
L_0C5F:         inc   y                         ; FC
L_0C60:         bne   L_0C66                    ; D0 04
L_0C62:         mov   a, #$80                   ; E8 80
L_0C64:         bra   L_0C6A                    ; 2F 04

L_0C66:         clrc                            ; 60
L_0C67:         adc   a, $02D1+x                ; 95 D1 02
L_0C6A:         mov   $02D0+x, a                ; D5 D0 02
L_0C6D:         call  CalcVolumeWithTremolo     ; 3F 56 0E
L_0C70:         bra   L_0C79                    ; 2F 07

L_0C72:         inc   $C0+x                     ; BB C0
L_0C74:         mov   a, #$FF                   ; E8 FF
L_0C76:         call  CalcVolume                ; 3F 61 0E
L_0C79:         mov   a, $91+x                  ; F4 91
L_0C7B:         beq   L_0C86                    ; F0 09
L_0C7D:         mov   a, #$30                   ; E8 30
L_0C7F:         mov   y, #$03                   ; 8D 03
L_0C81:         dec   $91+x                     ; 9B 91
L_0C83:         call  VoiceFadeWithVolumeChange ; 3F D3 0C
L_0C86:         mov   a, $47                    ; E4 47
L_0C88:         and   a, $5E                    ; 24 5E
L_0C8A:         beq   L_0CD2                    ; F0 46
L_0C8C:         mov   a, $0331+x                ; F5 31 03
L_0C8F:         mov   y, a                      ; FD
L_0C90:         mov   a, $0330+x                ; F5 30 03
L_0C93:         movw  $10, ya                   ; DA 10
L_0C95:         mov   a, x                      ; 7D
L_0C96:         xcn   a                         ; 9F
L_0C97:         lsr   a                         ; 5C
L_0C98:         mov   $12, a                    ; C4 12
L_0C9A:         mov   y, $11                    ; EB 11
L_0C9C:         mov   a, Pan_Table+1+y          ; F6 74 0E
L_0C9F:         setc                            ; 80
L_0CA0:         sbc   a, Pan_Table+0+y          ; B6 73 0E
L_0CA3:         mov   y, $10                    ; EB 10
L_0CA5:         mul   ya                        ; CF
L_0CA6:         mov   a, y                      ; DD
L_0CA7:         mov   y, $11                    ; EB 11
L_0CA9:         clrc                            ; 60
L_0CAA:         adc   a, Pan_Table+0+y          ; 96 73 0E
L_0CAD:         mov   y, a                      ; FD
L_0CAE:         mov   a, $0321+x                ; F5 21 03
L_0CB1:         mul   ya                        ; CF
L_0CB2:         mov   a, $0351+x                ; F5 51 03
L_0CB5:         asl   a                         ; 1C
L_0CB6:         bbc0  $12, L_0CBA               ; 13 12 01
L_0CB9:         asl   a                         ; 1C
L_0CBA:         mov   a, y                      ; DD
L_0CBB:         bcc   L_0CC0                    ; 90 03
L_0CBD:         eor   a, #$FF                   ; 48 FF
L_0CBF:         inc   a                         ; BC
L_0CC0:         mov   y, $12                    ; EB 12
L_0CC2:         call  WriteDspMusic             ; 3F 41 07
L_0CC5:         mov   y, #$14                   ; 8D 14
L_0CC7:         mov   a, #$00                   ; E8 00
L_0CC9:         subw  ya, $10                   ; 9A 10
L_0CCB:         movw  $10, ya                   ; DA 10
L_0CCD:         inc   $12                       ; AB 12
L_0CCF:         bbc1  $12, L_0C9A               ; 33 12 C8
L_0CD2:         ret                             ; 6F

; $0CD3
VoiceFadeWithVolumeChange:
                or    ($5E), ($47)              ; 09 47 5E
                ; FALLTHROUGH
; $0CD6
VoiceFade:      movw  $14, ya                   ; DA 14
L_0CD8:         movw  $16, ya                   ; DA 16
L_0CDA:         push  x                         ; 4D
L_0CDB:         pop   y                         ; EE
L_0CDC:         clrc                            ; 60
L_0CDD:         bne   L_0CE9                    ; D0 0A
L_0CDF:         adc   $16, #$1F                 ; 98 1F 16
L_0CE2:         mov   a, #$00                   ; E8 00
L_0CE4:         mov   ($14)+y, a                ; D7 14
L_0CE6:         inc   y                         ; FC
L_0CE7:         bra   L_0CF2                    ; 2F 09

L_0CE9:         adc   $16, #$10                 ; 98 10 16
L_0CEC:         call  L_0CF0                    ; 3F F0 0C
L_0CEF:         inc   y                         ; FC
L_0CF0:         mov   a, ($14)+y                ; F7 14
L_0CF2:         adc   a, ($16)+y                ; 97 16
L_0CF4:         mov   ($14)+y, a                ; D7 14
L_0CF6:         ret                             ; 6F

; $0CF7
L_0CF7:         mov   a, $71+x                  ; F4 71
L_0CF9:         beq   L_0D60                    ; F0 65
L_0CFB:         dec   $71+x                     ; 9B 71
L_0CFD:         beq   L_0D04                    ; F0 05
L_0CFF:         mov   a, #$02                   ; E8 02
L_0D01:         cbne  $70+x, L_0D60             ; DE 70 5C
L_0D04:         mov   a, $80+x                  ; F4 80
L_0D06:         mov   $17, a                    ; C4 17
L_0D08:         mov   a, $30+x                  ; F4 30
L_0D0A:         mov   y, $31+x                  ; FB 31
L_0D0C:         movw  $14, ya                   ; DA 14
L_0D0E:         mov   y, #$00                   ; 8D 00
L_0D10:         mov   a, ($14)+y                ; F7 14
L_0D12:         beq   L_0D32                    ; F0 1E
L_0D14:         bmi   L_0D1D                    ; 30 07
L_0D16:         inc   y                         ; FC
L_0D17:         bmi   L_0D59                    ; 30 40
L_0D19:         mov   a, ($14)+y                ; F7 14
L_0D1B:         bpl   L_0D16                    ; 10 F9
L_0D1D:         cmp   a, #$C8                   ; 68 C8
L_0D1F:         beq   L_0D60                    ; F0 3F
L_0D21:         cmp   a, #$EF                   ; 68 EF
L_0D23:         beq   L_0D4E                    ; F0 29
L_0D25:         cmp   a, #$E0                   ; 68 E0
L_0D27:         bcc   L_0D59                    ; 90 30
L_0D29:         push  y                         ; 6D
L_0D2A:         mov   y, a                      ; FD
L_0D2B:         pop   a                         ; AE
L_0D2C:         adc   a, VCMD_Arg_Length-$E0+y  ; 96 41 0B
L_0D2F:         mov   y, a                      ; FD
L_0D30:         bra   L_0D10                    ; 2F DE

L_0D32:         mov   a, $17                    ; E4 17
L_0D34:         beq   L_0D59                    ; F0 23
L_0D36:         dec   $17                       ; 8B 17
L_0D38:         bne   L_0D44                    ; D0 0A
L_0D3A:         mov   a, $0231+x                ; F5 31 02
L_0D3D:         push  a                         ; 2D
L_0D3E:         mov   a, $0230+x                ; F5 30 02
L_0D41:         pop   y                         ; EE
L_0D42:         bra   L_0D0C                    ; 2F C8

L_0D44:         mov   a, $0241+x                ; F5 41 02
L_0D47:         push  a                         ; 2D
L_0D48:         mov   a, $0240+x                ; F5 40 02
L_0D4B:         pop   y                         ; EE
L_0D4C:         bra   L_0D0C                    ; 2F BE

L_0D4E:         inc   y                         ; FC
L_0D4F:         mov   a, ($14)+y                ; F7 14
L_0D51:         push  a                         ; 2D
L_0D52:         inc   y                         ; FC
L_0D53:         mov   a, ($14)+y                ; F7 14
L_0D55:         mov   y, a                      ; FD
L_0D56:         pop   a                         ; AE
L_0D57:         bra   L_0D0C                    ; 2F B3

L_0D59:         mov   a, $47                    ; E4 47
L_0D5B:         mov   y, #!DSP_KOF              ; 8D 5C
L_0D5D:         call  WriteDspMusic             ; 3F 41 07
L_0D60:         clr7  $13                       ; F2 13
L_0D62:         mov   a, $A0+x                  ; F4 A0
L_0D64:         beq   L_0D79                    ; F0 13
L_0D66:         mov   a, $A1+x                  ; F4 A1
L_0D68:         beq   L_0D6E                    ; F0 04
L_0D6A:         dec   $A1+x                     ; 9B A1
L_0D6C:         bra   L_0D79                    ; 2F 0B

L_0D6E:         set7  $13                       ; E2 13
L_0D70:         mov   a, #$60                   ; E8 60
L_0D72:         mov   y, #$03                   ; 8D 03
L_0D74:         dec   $A0+x                     ; 9B A0
L_0D76:         call  VoiceFade                 ; 3F D6 0C
L_0D79:         call  GetPitch                  ; 3F BC 0B
L_0D7C:         mov   a, $B1+x                  ; F4 B1
L_0D7E:         beq   L_0DCC                    ; F0 4C
L_0D80:         mov   a, $02B0+x                ; F5 B0 02
L_0D83:         cbne  $B0+x, L_0DCA             ; DE B0 44
L_0D86:         mov   a, $0100+x                ; F5 00 01
L_0D89:         cmp   a, $02B1+x                ; 75 B1 02
L_0D8C:         bne   L_0D93                    ; D0 05
L_0D8E:         mov   a, $02C1+x                ; F5 C1 02
L_0D91:         bra   L_0DA0                    ; 2F 0D

L_0D93:         setp                            ; 40
L_0D94:         inc.b $0100+x                   ; BB 00
L_0D96:         clrp                            ; 20
L_0D97:         mov   y, a                      ; FD
L_0D98:         beq   L_0D9C                    ; F0 02
L_0D9A:         mov   a, $B1+x                  ; F4 B1
L_0D9C:         clrc                            ; 60
L_0D9D:         adc   a, $02C0+x                ; 95 C0 02
L_0DA0:         mov   $B1+x, a                  ; D4 B1
L_0DA2:         mov   a, $02A0+x                ; F5 A0 02
L_0DA5:         clrc                            ; 60
L_0DA6:         adc   a, $02A1+x                ; 95 A1 02
L_0DA9:         mov   $02A0+x, a                ; D5 A0 02
L_0DAC:         mov   $12, a                    ; C4 12
L_0DAE:         asl   a                         ; 1C
L_0DAF:         asl   a                         ; 1C
L_0DB0:         bcc   L_0DB4                    ; 90 02
L_0DB2:         eor   a, #$FF                   ; 48 FF
L_0DB4:         mov   y, a                      ; FD
L_0DB5:         mov   a, $B1+x                  ; F4 B1
L_0DB7:         cmp   a, #$F1                   ; 68 F1
L_0DB9:         bcc   L_0DC0                    ; 90 05
L_0DBB:         and   a, #$0F                   ; 28 0F
L_0DBD:         mul   ya                        ; CF
L_0DBE:         bra   L_0DC4                    ; 2F 04

L_0DC0:         mul   ya                        ; CF
L_0DC1:         mov   a, y                      ; DD
L_0DC2:         mov   y, #$00                   ; 8D 00
L_0DC4:         call  L_0E41                    ; 3F 41 0E
L_0DC7:         jmp   L_06BE                    ; 5F BE 06

L_0DCA:         inc   $B0+x                     ; BB B0
L_0DCC:         bbs7  $13, L_0DC7               ; E3 13 F8
L_0DCF:         ret                             ; 6F

; $0DD0
; Responsible for voice LFO (tremolo, vibrato, pan fade, etc.)
DoVoiceLfo:     clr7  $13                       ; F2 13
L_0DD2:         mov   a, $C1+x                  ; F4 C1
L_0DD4:         beq   L_0DDF                    ; F0 09
L_0DD6:         mov   a, $02E0+x                ; F5 E0 02
L_0DD9:         cbne  $C0+x, L_0DDF             ; DE C0 03
L_0DDC:         call  TremoloTick               ; 3F 49 0E
L_0DDF:         mov   a, $0331+x                ; F5 31 03
L_0DE2:         mov   y, a                      ; FD
L_0DE3:         mov   a, $0330+x                ; F5 30 03
L_0DE6:         movw  $10, ya                   ; DA 10
L_0DE8:         mov   a, $91+x                  ; F4 91
L_0DEA:         beq   L_0DF6                    ; F0 0A
L_0DEC:         mov   a, $0341+x                ; F5 41 03
L_0DEF:         mov   y, a                      ; FD
L_0DF0:         mov   a, $0340+x                ; F5 40 03
L_0DF3:         call  L_0E2B                    ; 3F 2B 0E
L_0DF6:         bbc7  $13, L_0DFC               ; F3 13 03
L_0DF9:         call  L_0C95                    ; 3F 95 0C
L_0DFC:         clr7  $13                       ; F2 13
L_0DFE:         call  GetPitch                  ; 3F BC 0B
L_0E01:         mov   a, $A0+x                  ; F4 A0
L_0E03:         beq   L_0E13                    ; F0 0E
L_0E05:         mov   a, $A1+x                  ; F4 A1
L_0E07:         bne   L_0E13                    ; D0 0A
L_0E09:         mov   a, $0371+x                ; F5 71 03
L_0E0C:         mov   y, a                      ; FD
L_0E0D:         mov   a, $0370+x                ; F5 70 03
L_0E10:         call  L_0E2B                    ; 3F 2B 0E
L_0E13:         mov   a, $B1+x                  ; F4 B1
L_0E15:         beq   L_0DCC                    ; F0 B5
L_0E17:         mov   a, $02B0+x                ; F5 B0 02
L_0E1A:         cbne  $B0+x, L_0DCC             ; DE B0 AF
L_0E1D:         mov   y, $51                    ; EB 51
L_0E1F:         mov   a, $02A1+x                ; F5 A1 02
L_0E22:         mul   ya                        ; CF
L_0E23:         mov   a, y                      ; DD
L_0E24:         clrc                            ; 60
L_0E25:         adc   a, $02A0+x                ; 95 A0 02
L_0E28:         jmp   L_0DAC                    ; 5F AC 0D

L_0E2B:         set7  $13                       ; E2 13
L_0E2D:         mov   $12, y                    ; CB 12
L_0E2F:         call  L_0BD9                    ; 3F D9 0B
L_0E32:         push  y                         ; 6D
L_0E33:         mov   y, $51                    ; EB 51
L_0E35:         mul   ya                        ; CF
L_0E36:         mov   $14, y                    ; CB 14
L_0E38:         mov   $15, #$00                 ; 8F 00 15
L_0E3B:         mov   y, $51                    ; EB 51
L_0E3D:         pop   a                         ; AE
L_0E3E:         mul   ya                        ; CF
L_0E3F:         addw  ya, $14                   ; 7A 14
L_0E41:         call  L_0BD9                    ; 3F D9 0B
L_0E44:         addw  ya, $10                   ; 7A 10
L_0E46:         movw  $10, ya                   ; DA 10
L_0E48:         ret                             ; 6F

; $0E49
TremoloTick:    set7  $13                       ; E2 13
L_0E4B:         mov   y, $51                    ; EB 51
L_0E4D:         mov   a, $02D1+x                ; F5 D1 02
L_0E50:         mul   ya                        ; CF
L_0E51:         mov   a, y                      ; DD
L_0E52:         clrc                            ; 60
L_0E53:         adc   a, $02D0+x                ; 95 D0 02
                ; FALLTHROUGH
; $0E56
CalcVolumeWithTremolo:
                asl   a                         ; 1C
L_0E57:         bcc   L_0E5B                    ; 90 02
L_0E59:         eor   a, #$FF                   ; 48 FF
L_0E5B:         mov   y, $C1+x                  ; FB C1
L_0E5D:         mul   ya                        ; CF
L_0E5E:         mov   a, y                      ; DD
L_0E5F:         eor   a, #$FF                   ; 48 FF
                ; FALLTHROUGH
; $0E61
CalcVolume:     mov   y, $59                    ; EB 59
L_0E63:         mul   ya                        ; CF
L_0E64:         mov   a, $0210+x                ; F5 10 02
L_0E67:         mul   ya                        ; CF
L_0E68:         mov   a, $0301+x                ; F5 01 03
L_0E6B:         mul   ya                        ; CF
L_0E6C:         mov   a, y                      ; DD
L_0E6D:         mul   ya                        ; CF
L_0E6E:         mov   a, y                      ; DD
L_0E6F:         mov   $0321+x, a                ; D5 21 03
L_0E72:         ret                             ; 6F

; $0E73
Pan_Table:      db $00,$01,$03,$07,$0D,$15,$1E,$29,$34,$42,$51,$5E,$67,$6E,$73,$77
                db $7A,$7C,$7D,$7E,$7F

; $0E88
Filter_Table:   db $7F,$00,$00,$00,$00,$00,$00,$00 ; No filter
                db $58,$BF,$DB,$F0,$FE,$07,$0C,$0C ; High pass
                db $0C,$21,$2B,$2B,$13,$FE,$F3,$F9 ; Low pass
                db $34,$33,$00,$D9,$E5,$01,$FC,$EB ; Band pass

; $0EA8
Dsp_Addr_Table: db !DSP_EVOLL,  !DSP_EVOLR,  !DSP_EFB, !DSP_EON, !DSP_FLG, !DSP_KON, !DSP_KOF, !DSP_NON, !DSP_PMON, !DSP_KOF
; $0EB2
; TODO: ADD LABELS
Dsp_Data_Table: db $60+1, $62+1, $4E, $4A, $48, $45, $0E, $49, $4B, $46

; $0EBC
Pitch_Table:    dw $085F, $08DE
                dw $0965, $09F4
                dw $0A8C, $0B2C
                dw $0BD6, $0C8B
                dw $0D4A, $0E14
                dw $0EEA, $0FCD
                dw $10BE

; $0ED5
Version_String: db "*Ver S1.20*"

; $0EE1
; Just like the IPL Boot ROM, except it doesn't nuke the zero page!
TransferData:   mov   a, #$AA                   ; E8 AA
L_0EE3:         mov.w PORT0, a                  ; C5 F4 00
L_0EE6:         mov   a, #$BB                   ; E8 BB
L_0EE8:         mov.w PORT1, a                  ; C5 F5 00
L_0EEB:         mov.w a, PORT0                  ; E5 F4 00
L_0EEE:         cmp   a, #$CC                   ; 68 CC
L_0EF0:         bne   L_0EEB                    ; D0 F9
L_0EF2:         bra   L_0F14                    ; 2F 20

L_0EF4:         mov.w y, PORT0                  ; EC F4 00
L_0EF7:         bne   L_0EF4                    ; D0 FB
L_0EF9:         cmp.w y, PORT0                  ; 5E F4 00
L_0EFC:         bne   L_0F0D                    ; D0 0F
L_0EFE:         mov.w a, PORT1                  ; E5 F5 00
L_0F01:         mov.w PORT0, y                  ; CC F4 00
L_0F04:         mov   ($14)+y, a                ; D7 14
L_0F06:         inc   y                         ; FC
L_0F07:         bne   L_0EF9                    ; D0 F0
L_0F09:         inc   $15                       ; AB 15
L_0F0B:         bra   L_0EF9                    ; 2F EC

L_0F0D:         bpl   L_0EF9                    ; 10 EA
L_0F0F:         cmp.w y, PORT0                  ; 5E F4 00
L_0F12:         bpl   L_0EF9                    ; 10 E5
L_0F14:         mov.w a, PORT2                  ; E5 F6 00
L_0F17:         mov.w y, PORT3                  ; EC F7 00
L_0F1A:         movw  $14, ya                   ; DA 14
L_0F1C:         mov.w y, PORT0                  ; EC F4 00
L_0F1F:         mov.w a, PORT1                  ; E5 F5 00
L_0F22:         mov.w PORT0, y                  ; CC F4 00
L_0F25:         bne   L_0EF4                    ; D0 CD
L_0F27:         mov   x, #%00110001             ; CD 31    // Reset ports, start timer0
L_0F29:         mov.w CONTROL, x                ; C9 F1 00
L_0F2C:         ret                             ; 6F

; $0F2D
; Read 8 bytes of SFX data into $04D8?
L_0F2D:         movw  $20, ya                   ; DA 20
L_0F2F:         mov   y, #$00                   ; 8D 00
L_0F31:         mov   a, ($20)+y                ; F7 20
L_0F33:         mov   $04D8+y, a                ; D6 D8 04
L_0F36:         inc   y                         ; FC
L_0F37:         cmp   y, #$07                   ; AD 07
L_0F39:         bne   L_0F31                    ; D0 F6
L_0F3B:         ret                             ; 6F

; $0F3C
; Read 3 bytes of SFX data into $04DA?
L_0F3C:         movw  $20, ya                   ; DA 20
L_0F3E:         mov   y, #$00                   ; 8D 00
L_0F40:         mov   a, ($20)+y                ; F7 20
L_0F42:         mov   $04DA+y, a                ; D6 DA 04
L_0F45:         inc   y                         ; FC
L_0F46:         cmp   y, #$03                   ; AD 03
L_0F48:         bne   L_0F40                    ; D0 F6
L_0F4A:         ret                             ; 6F

; $0F4B
L_0F4B:         call  L_0F56                    ; 3F 56 0F
L_0F4E:         mov   x, $2E                    ; F8 2E
L_0F50:         mov   a, #$01                   ; E8 01
L_0F52:         call  L_1394                    ; 3F 94 13
L_0F55:         ret                             ; 6F

L_0F56:         call  L_0F3C                    ; 3F 3C 0F
L_0F59:         mov   a, ($20)+y                ; F7 20
L_0F5B:         mov   sfx_detune, a             ; C5 DE 04
L_0F5E:         mov   x, $2F                    ; F8 2F
L_0F60:         mov   a, $20                    ; E4 20
L_0F62:         mov   $0480+x, a                ; D5 80 04
L_0F65:         mov   a, $21                    ; E4 21
L_0F67:         inc   x                         ; 3D
L_0F68:         mov   $0480+x, a                ; D5 80 04
L_0F6B:         mov   x, $2E                    ; F8 2E
L_0F6D:         mov   a, #$00                   ; E8 00
L_0F6F:         mov   $04C8+x, a                ; D5 C8 04
L_0F72:         mov   y, #$04                   ; 8D 04
L_0F74:         mov   a, ($20)+y                ; F7 20
L_0F76:         mov   $22, a                    ; C4 22
L_0F78:         inc   y                         ; FC
L_0F79:         mov   a, ($20)+y                ; F7 20
L_0F7B:         mov   $04DD, a                  ; C5 DD 04
L_0F7E:         cmp   a, #$C9                   ; 68 C9
L_0F80:         bne   L_0F85                    ; D0 03
L_0F82:         mov   $04C8+x, a                ; D5 C8 04
L_0F85:         call  L_0FA1                    ; 3F A1 0F
L_0F88:         mov   a, #$D8                   ; E8 D8
L_0F8A:         mov   y, #$04                   ; 8D 04
L_0F8C:         jmp   L_14FC                    ; 5F FC 14

L_0F8F:         mov   a, $46                    ; E4 46
L_0F91:         or    a, sfx_voice_bit          ; 05 D7 04
L_0F94:         mov   $46, a                    ; C4 46
L_0F96:         mov   a, #$04                   ; E8 04
L_0F98:         mov   $04D8, a                  ; C5 D8 04
L_0F9B:         mov   a, #$02                   ; E8 02
L_0F9D:         mov   $04D9, a                  ; C5 D9 04
L_0FA0:         ret                             ; 6F

L_0FA1:         mov   a, $22                    ; E4 22
L_0FA3:         cmp   a, #$7F                   ; 68 7F
L_0FA5:         beq   L_0F8F                    ; F0 E8
L_0FA7:         dec   a                         ; 9C
L_0FA8:         mov   y, a                      ; FD
L_0FA9:         mov   a, SFX_Note_Table+y       ; F6 68 10
L_0FAC:         mov   $04D8, a                  ; C5 D8 04
L_0FAF:         inc   y                         ; FC
L_0FB0:         mov   a, SFX_Note_Table+y       ; F6 68 10
L_0FB3:         mov   $04D9, a                  ; C5 D9 04
L_0FB6:         ret                             ; 6F

L_0FB7:         call  L_13A0                    ; 3F A0 13
L_0FBA:         bne   L_0FB6                    ; D0 FA
L_0FBC:         mov   a, $2A                    ; E4 2A
L_0FBE:         inc   a                         ; BC
L_0FBF:         inc   a                         ; BC
L_0FC0:         mov   y, $2B                    ; EB 2B
L_0FC2:         call  L_0F3C                    ; 3F 3C 0F
L_0FC5:         inc   y                         ; FC
L_0FC6:         mov   a, ($20)+y                ; F7 20
L_0FC8:         mov   sfx_detune, a             ; C5 DE 04
L_0FCB:         mov   a, $D0+x                  ; F4 D0
L_0FCD:         clrc                            ; 60
L_0FCE:         adc   a, #$06                   ; 88 06
L_0FD0:         mov   y, a                      ; FD
L_0FD1:         inc   $D0+x                     ; BB D0
L_0FD3:         mov   x, $2F                    ; F8 2F
L_0FD5:         mov   a, $0480+x                ; F5 80 04
L_0FD8:         mov   $20, a                    ; C4 20
L_0FDA:         inc   x                         ; 3D
L_0FDB:         mov   a, $0480+x                ; F5 80 04
L_0FDE:         mov   $21, a                    ; C4 21
L_0FE0:         mov   a, ($20)+y                ; F7 20
L_0FE2:         mov   $22, a                    ; C4 22
L_0FE4:         beq   L_100B                    ; F0 25
L_0FE6:         mov   x, $2E                    ; F8 2E
L_0FE8:         and   a, #$80                   ; 28 80
L_0FEA:         beq   L_100E                    ; F0 22
L_0FEC:         mov   a, $22                    ; E4 22
L_0FEE:         cmp   a, #$E0                   ; 68 E0
L_0FF0:         beq   L_1020                    ; F0 2E
L_0FF2:         cmp   a, #$C9                   ; 68 C9
L_0FF4:         beq   L_1064                    ; F0 6E
L_0FF6:         cmp   a, #$E1                   ; 68 E1
L_0FF8:         beq   L_102C                    ; F0 32
L_0FFA:         cmp   a, #$ED                   ; 68 ED
L_0FFC:         beq   L_1058                    ; F0 5A
L_0FFE:         mov   y, $22                    ; EB 22
L_1000:         mov   a, #$00                   ; E8 00
L_1002:         mov   $04C8+x, a                ; D5 C8 04
L_1005:         mov   a, sfx_detune             ; E5 DE 04
L_1008:         jmp   L_10E7                    ; 5F E7 10

L_100B:         jmp   L_1491                    ; 5F 91 14

L_100E:         call  L_0FA1                    ; 3F A1 0F
L_1011:         mov   a, $04D8                  ; E5 D8 04
L_1014:         mov   $04BC+x, a                ; D5 BC 04
L_1017:         mov   a, $04D9                  ; E5 D9 04
L_101A:         mov   $04C0+x, a                ; D5 C0 04
L_101D:         jmp   L_0FCB                    ; 5F CB 0F

L_1020:         inc   y                         ; FC
L_1021:         mov   a, ($20)+y                ; F7 20
L_1023:         call  L_1130                    ; 3F 30 11
L_1026:         mov   x, $2E                    ; F8 2E
L_1028:         inc   $D0+x                     ; BB D0
L_102A:         bne   L_0FCB                    ; D0 9F
L_102C:         inc   y                         ; FC
L_102D:         mov   a, ($20)+y                ; F7 20
L_102F:         mov   $23, a                    ; C4 23
L_1031:         mov   a, $04DB                  ; E5 DB 04
L_1034:         mov   $22, a                    ; C4 22
L_1036:         mov   a, sfx_voice_x2           ; E5 DF 04
L_1039:         mov   x, a                      ; 5D
L_103A:         call  L_10B6                    ; 3F B6 10
L_103D:         mov   y, $2E                    ; EB 2E
L_103F:         mov   a, #$08                   ; E8 08
L_1041:         mul   ya                        ; CF
L_1042:         mov   x, a                      ; 5D
L_1043:         mov   a, $23                    ; E4 23
L_1045:         mov   $0464+x, a                ; D5 64 04
L_1048:         mov   $04DC, a                  ; C5 DC 04
L_104B:         mov   a, $22                    ; E4 22
L_104D:         mov   $0463+x, a                ; D5 63 04
L_1050:         mov   $04DB, a                  ; C5 DB 04
L_1053:         mov   x, $2E                    ; F8 2E
L_1055:         jmp   L_1028                    ; 5F 28 10

L_1058:         inc   y                         ; FC
L_1059:         mov   a, ($20)+y                ; F7 20
L_105B:         mov   $22, a                    ; C4 22
L_105D:         mov   a, $04DC                  ; E5 DC 04
L_1060:         mov   $23, a                    ; C4 23
L_1062:         bne   L_1036                    ; D0 D2
L_1064:         mov   $04C8+x, a                ; D5 C8 04
L_1067:         ret                             ; 6F

; Note lengths + hold lengths for SFX
SFX_Note_Table: db $03, $01 ; 01
                db $03, $02 ; 03
                db $06, $02 ; 05
                db $06, $05 ; 07
                db $0C, $02 ; 09
                db $0C, $0A ; 0B
                db $18, $02 ; 0D
                db $18, $16 ; 0F
                db $30, $02 ; 11
                db $30, $2E ; 13
                db $60, $02 ; 15
                db $60, $5E ; 17
                db $12, $02 ; 19
                db $12, $10 ; 1B
                db $24, $02 ; 1D
                db $24, $22 ; 1F
                db $09, $02 ; 21
                db $09, $07 ; 23
                db $01, $02 ; 25
                db $02, $02 ; 27
                db $03, $02 ; 29
                db $04, $02 ; 2B
                db $05, $02 ; 2D
                db $06, $02 ; 2F
                db $03, $03 ; 31
                db $06, $03 ; 33
                db $0C, $06 ; 35
                db $18, $0C ; 37
                db $30, $18 ; 39
                db $60, $30 ; 3B
                db $12, $09 ; 3D
                db $24, $12 ; 3F
                db $04, $02 ; 41
                db $04, $02 ; 43
                db $04, $03 ; 45
                db $05, $03 ; 47
                db $05, $02 ; 49
                db $05, $04 ; 4B
                db $02, $01 ; 4D

; TODO: Set sound effect pan
L_10B6:         mov   a, $22                    ; E4 22
L_10B8:         mov   $0321+x, a                ; D5 21 03
L_10BB:         mov   a, $23                    ; E4 23
L_10BD:         and   a, #$C0                   ; 28 C0
L_10BF:         mov   $0351+x, a                ; D5 51 03
L_10C2:         mov   a, $23                    ; E4 23
L_10C4:         and   a, #$3F                   ; 28 3F
L_10C6:         mov   temp_sfx_pan, a           ; C5 33 04
L_10C9:         mov   a, mono_flag              ; E5 31 04
L_10CC:         cmp   a, #$00                   ; 68 00
L_10CE:         beq   L_10D5                    ; F0 05
L_10D0:         mov   a, #$0A                   ; E8 0A
L_10D2:         mov   temp_sfx_pan, a           ; C5 33 04
L_10D5:         mov   a, temp_sfx_pan           ; E5 33 04
L_10D8:         mov   $11, a                    ; C4 11
L_10DA:         mov   $10, #$00                 ; 8F 00 10
L_10DD:         mov   a, $47                    ; E4 47
L_10DF:         and   a, sfx_voice_bit_NOT      ; 25 D6 04
L_10E2:         mov   $47, a                    ; C4 47
L_10E4:         jmp   L_0C95                    ; 5F 95 0C

; TODO: Maybe set sound effect note? Or pitch?
L_10E7:         push  x                         ; 4D
L_10E8:         push  a                         ; 2D
L_10E9:         mov   a, $47                    ; E4 47
L_10EB:         and   a, sfx_voice_bit_NOT      ; 25 D6 04
L_10EE:         mov   $47, a                    ; C4 47
L_10F0:         mov   a, sfx_voice_x2           ; E5 DF 04
L_10F3:         mov   x, a                      ; 5D
L_10F4:         pop   a                         ; AE
L_10F5:         movw  $10, ya                   ; DA 10
L_10F7:         call  L_06D4                    ; 3F D4 06
L_10FA:         pop   x                         ; CE
L_10FB:         ret                             ; 6F

L_10FC:         mov   x, $2F                    ; F8 2F
L_10FE:         mov   sfx_adsr+0+x, a           ; D5 58 04
L_1101:         mov   a, y                      ; DD
L_1102:         mov   sfx_adsr+1+x, a           ; D5 59 04
L_1105:         mov   x, $2E                    ; F8 2E
L_1107:         mov   a, #$01                   ; E8 01
L_1109:         mov   sfx_adsr_changed+x, a     ; D5 54 04
L_110C:         ret                             ; 6F

; TODO: Set sound effect ADSR
L_110D:         push  y                         ; 6D
L_110E:         push  a                         ; 2D
L_110F:         mov   a, sfx_dsp_base           ; E5 D5 04
L_1112:         clrc                            ; 60
L_1113:         adc   a, #!DSP_VxADSR1          ; 88 05
L_1115:         mov   y, a                      ; FD
L_1116:         mov   $20, a                    ; C4 20
L_1118:         pop   a                         ; AE
L_1119:         call  WriteDsp                  ; 3F 49 07
L_111C:         pop   y                         ; EE
L_111D:         mov   a, y                      ; DD
L_111E:         mov   y, $20                    ; EB 20
L_1120:         inc   y                         ; FC
L_1121:         jmp   WriteDsp                  ; 5F 49 07

; TODO: Set sound effect GAIN
L_1124:         push  a                         ; 2D
L_1125:         mov   a, sfx_dsp_base           ; E5 D5 04
L_1128:         clrc                            ; 60
L_1129:         adc   a, #!DSP_VxGAIN           ; 88 07
L_112B:         mov   y, a                      ; FD
L_112C:         pop   a                         ; AE
L_112D:         jmp   WriteDsp                  ; 5F 49 07

; TODO: Set sound effect instrument
L_1130:         push  a                         ; 2D
L_1131:         mov   a, $49                    ; E4 49
L_1133:         and   a, sfx_voice_bit_NOT      ; 25 D6 04
L_1136:         mov   $49, a                    ; C4 49
L_1138:         mov   a, sfx_voice_x2           ; E5 DF 04
L_113B:         mov   x, a                      ; 5D
L_113C:         pop   a                         ; AE
L_113D:         mov   $47, #$00                 ; 8F 00 47
L_1140:         call  SetInstrument             ; 3F 62 09
L_1143:         ret                             ; 6F

; TODO: Set sound effect voice volume?
L_1144:         push  a                         ; 2D
L_1145:         mov   a, sfx_dsp_base           ; E5 D5 04
L_1148:         mov   y, a                      ; FD
L_1149:         pop   a                         ; AE
L_114A:         call  WriteDsp                  ; 3F 49 07
L_114D:         inc   y                         ; FC
L_114E:         call  WriteDsp                  ; 3F 49 07
L_1151:         ret                             ; 6F

L_1152:         mov   x, #$00                   ; CD 00
L_1154:         decw  $20                       ; 1A 20
L_1156:         decw  $20                       ; 1A 20
L_1158:         mov   a, ($20+x)                ; E7 20
L_115A:         mov   $17C6, a                  ; C5 C6 17
L_115D:         decw  $20                       ; 1A 20
L_115F:         mov   a, ($20+x)                ; E7 20
L_1161:         mov   $17C5, a                  ; C5 C5 17
L_1164:         mov   a, #$01                   ; E8 01
L_1166:         mov   $04B2, a                  ; C5 B2 04
L_1169:         incw  $20                       ; 3A 20
L_116B:         incw  $20                       ; 3A 20
L_116D:         incw  $20                       ; 3A 20
L_116F:         ret                             ; 6F

; $1170
L_1170:         call  L_1152                    ; 3F 52 11
L_1173:         jmp   L_1278                    ; 5F 78 12

; $1176
L_1176:         call  L_1152                    ; 3F 52 11
L_1179:         jmp   L_1270                    ; 5F 70 12

; $117C
L_117C:         db $0E, $00, $02, $04, $06, $08, $0A, $0C

; $1184
L_1184:         mov   $2A, #$60                 ; 8F 60 2A
L_1187:         mov   $2B, #$04                 ; 8F 04 2B
L_118A:         mov   x, #$00                   ; CD 00
L_118C:         mov   a, #~$10                  ; E8 EF
L_118E:         mov   y, #$10                   ; 8D 10
L_1190:         mov   $20, #$08                 ; 8F 08 20
L_1193:         mov   $21, #$40                 ; 8F 40 21
L_1196:         bne   L_1207                    ; D0 6F

; $1198 - Process PORT1 (music effects)
ProcessPort1:   mov   a, $04B1                  ; E5 B1 04
L_119B:         and   a, #$7F                   ; 28 7F
L_119D:         mov   $04B1, a                  ; C5 B1 04
L_11A0:         mov.b $24, #L_17D5              ; 8F D5 24
L_11A3:         mov.b $25, #L_17D5>>8           ; 8F 17 25
L_11A6:         mov   $2A, #$68                 ; 8F 68 2A
L_11A9:         mov   $2B, #$04                 ; 8F 04 2B
L_11AC:         mov   x, #$01                   ; CD 01
L_11AE:         mov   a, #~$20                  ; E8 DF
L_11B0:         mov   y, #$20                   ; 8D 20
L_11B2:         mov   $20, #$0A                 ; 8F 0A 20
L_11B5:         mov   $21, #$50                 ; 8F 50 21
L_11B8:         bne   L_1207                    ; D0 4D

; $11BA - Process PORT2 (static control)
ProcessPort2:   mov   a, $04B2                  ; E5 B2 04
L_11BD:         and   a, #$7F                   ; 28 7F
L_11BF:         mov   $04B2, a                  ; C5 B2 04
L_11C2:         mov.b $24, #L_17C5              ; 8F C5 24
L_11C5:         mov.b $25, #L_17C5>>8           ; 8F 17 25
L_11C8:         mov   $2A, #$70                 ; 8F 70 2A
L_11CB:         mov   $2B, #$04                 ; 8F 04 2B
L_11CE:         mov   x, #$02                   ; CD 02
L_11D0:         mov   a, #~$40                  ; E8 BF
L_11D2:         mov   y, #$40                   ; 8D 40
L_11D4:         mov   $20, #$0C                 ; 8F 0C 20
L_11D7:         mov   $21, #$60                 ; 8F 60 21
L_11DA:         bne   L_1207                    ; D0 2B

; $11DC - Process PORT3 (sound effects)
ProcessPort3:   mov   a, $04B3                  ; E5 B3 04
L_11DF:         and   a, #$7F                   ; 28 7F
L_11E1:         mov   $04B3, a                  ; C5 B3 04
L_11E4:         mov.b $24, #SFX_Table           ; 8F C7 24
L_11E7:         mov.b $25, #SFX_Table>>8        ; 8F 16 25
L_11EA:         mov   a, $19                    ; E4 19
            ;**** Randomize detune of SFX $13, $14 and $15 ****
L_11EC:         mov   L_18EF, a                 ; C5 EF 18
L_11EF:         mov   L_18F7, a                 ; C5 F7 18
L_11F2:         mov   L_18FF, a                 ; C5 FF 18
L_11F5:         mov   $2A, #$78                 ; 8F 78 2A
L_11F8:         mov   $2B, #$04                 ; 8F 04 2B
L_11FB:         mov   x, #$03                   ; CD 03
L_11FD:         mov   a, #~$80                  ; E8 7F
L_11FF:         mov   y, #$80                   ; 8D 80
L_1201:         mov   $20, #$0E                 ; 8F 0E 20
L_1204:         mov   $21, #$70                 ; 8F 70 21
L_1207:         mov   sfx_voice_bit_NOT, a      ; C5 D6 04
L_120A:         mov   sfx_voice_bit, y          ; CC D7 04
L_120D:         mov   a, $20                    ; E4 20
L_120F:         mov   sfx_voice_x2, a           ; C5 DF 04
L_1212:         mov   a, $21                    ; E4 21
L_1214:         mov   sfx_dsp_base, a           ; C5 D5 04
L_1217:         mov   a, x                      ; 7D
L_1218:         mov   $2E, a                    ; C4 2E
L_121A:         asl   a                         ; 1C
L_121B:         mov   $2F, a                    ; C4 2F
L_121D:         mov   a, $04B0+x                ; F5 B0 04
L_1220:         mov   $20, a                    ; C4 20
L_1222:         mov   $2D, a                    ; C4 2D
L_1224:         beq   L_126D                    ; F0 47
L_1226:         cmp   a, $04D0+x                ; 75 D0 04
L_1229:         bcs   L_126D                    ; B0 42
L_122B:         and   a, #$07                   ; 28 07
L_122D:         mov   y, a                      ; FD
L_122E:         mov   a, L_117C+y               ; F6 7C 11
L_1231:         dec   $20                       ; 8B 20
L_1233:         and   $20, #$F8                 ; 38 F8 20
L_1236:         asl   $20                       ; 0B 20
L_1238:         or    a, $20                    ; 04 20
L_123A:         mov   x, a                      ; 5D
L_123B:         mov   a, $2E                    ; E4 2E
L_123D:         mov   a, x                      ; 7D
L_123E:         mov   y, a                      ; FD
L_123F:         mov   a, ($24)+y                ; F7 24
L_1241:         mov   $20, a                    ; C4 20
L_1243:         incw  $24                       ; 3A 24
L_1245:         mov   a, ($24)+y                ; F7 24
L_1247:         mov   $21, a                    ; C4 21
L_1249:         push  x                         ; 4D
L_124A:         decw  $20                       ; 1A 20
L_124C:         mov   x, #$00                   ; CD 00
L_124E:         mov   a, ($20+x)                ; E7 20
L_1250:         mov   x, $2E                    ; F8 2E
L_1252:         mov   $048C+x, a                ; D5 8C 04
L_1255:         incw  $20                       ; 3A 20
L_1257:         mov   x, a                      ; 5D
L_1258:         jmp   (L_125B+x)                ; 1F 5B 12

; SFX STLYE JUMP TABLE
L_125B:         dw L_1280 ; 00
                dw L_1280 ; 02
                dw L_1270 ; 04
                dw L_1278 ; 06
                dw L_12C7 ; 08
                dw L_1176 ; 0A
                dw L_1170 ; 0C
                dw L_1288 ; 0E
                dw L_1288 ; 10

L_126D:         jmp   L_131A                    ; 5F 1A 13

L_1270:         pop   x                         ; CE
L_1271:         mov   a, $20                    ; E4 20
L_1273:         mov   y, $21                    ; EB 21
L_1275:         jmp   L_0F56                    ; 5F 56 0F

L_1278:         pop   x                         ; CE
L_1279:         mov   a, $20                    ; E4 20
L_127B:         mov   y, $21                    ; EB 21
L_127D:         jmp   L_0F4B                    ; 5F 4B 0F

L_1280:         pop   x                         ; CE
L_1281:         mov   a, $20                    ; E4 20
L_1283:         mov   y, $21                    ; EB 21
L_1285:         jmp   L_14DF                    ; 5F DF 14

L_1288:         pop   x                         ; CE
L_1289:         mov   x, #$00                   ; CD 00
L_128B:         decw  $20                       ; 1A 20
L_128D:         decw  $20                       ; 1A 20
L_128F:         mov   a, ($20+x)                ; E7 20
L_1291:         mov   $27, a                    ; C4 27
L_1293:         decw  $20                       ; 1A 20
L_1295:         mov   a, ($20+x)                ; E7 20
L_1297:         mov   $26, a                    ; C4 26
L_1299:         decw  $20                       ; 1A 20
L_129B:         mov   a, ($20+x)                ; E7 20
L_129D:         mov   $29, a                    ; C4 29
L_129F:         decw  $20                       ; 1A 20
L_12A1:         mov   a, ($20+x)                ; E7 20
L_12A3:         mov   $28, a                    ; C4 28
L_12A5:         incw  $20                       ; 3A 20
L_12A7:         incw  $20                       ; 3A 20
L_12A9:         incw  $20                       ; 3A 20
L_12AB:         incw  $20                       ; 3A 20
L_12AD:         incw  $20                       ; 3A 20
L_12AF:         mov   y, #$05                   ; 8D 05
L_12B1:         mov   a, ($20)+y                ; F7 20
L_12B3:         mov   x, a                      ; 5D
L_12B4:         inc   y                         ; FC
L_12B5:         mov   a, ($20)+y                ; F7 20
L_12B7:         mov   $2C, a                    ; C4 2C
L_12B9:         mov   a, $20                    ; E4 20
L_12BB:         mov   y, $21                    ; EB 21
L_12BD:         call  L_14EE                    ; 3F EE 14
L_12C0:         mov   a, #$00                   ; E8 00
L_12C2:         mov   y, #$00                   ; 8D 00
L_12C4:         jmp   L_10FC                    ; 5F FC 10

L_12C7:         mov   x, #$00                   ; CD 00
L_12C9:         decw  $20                       ; 1A 20
L_12CB:         decw  $20                       ; 1A 20
L_12CD:         mov   a, ($20+x)                ; E7 20
L_12CF:         mov   $23, a                    ; C4 23
L_12D1:         decw  $20                       ; 1A 20
L_12D3:         mov   a, ($20+x)                ; E7 20
L_12D5:         mov   $22, a                    ; C4 22
L_12D7:         pop   x                         ; CE
L_12D8:         mov   a, $2E                    ; E4 2E
L_12DA:         cmp   a, #$03                   ; 68 03
L_12DC:         beq   L_12F3                    ; F0 15
L_12DE:         cmp   a, #$02                   ; 68 02
L_12E0:         beq   L_1300                    ; F0 1E
L_12E2:         cmp   a, #$01                   ; 68 01
L_12E4:         beq   L_130D                    ; F0 27
L_12E6:         mov   a, $22                    ; E4 22
L_12E8:         mov   $0440, a                  ; C5 40 04
L_12EB:         mov   a, $23                    ; E4 23
L_12ED:         mov   $0441, a                  ; C5 41 04
L_12F0:         jmp   (L_180D+x)                ; 1F 0D 18

L_12F3:         mov   a, $22                    ; E4 22
L_12F5:         mov   $0446, a                  ; C5 46 04
L_12F8:         mov   a, $23                    ; E4 23
L_12FA:         mov   $0447, a                  ; C5 47 04
L_12FD:         jmp   (SFX_Table+x)             ; 1F C7 16

L_1300:         mov   a, $22                    ; E4 22
L_1302:         mov   $0444, a                  ; C5 44 04
L_1305:         mov   a, $23                    ; E4 23
L_1307:         mov   $0445, a                  ; C5 45 04
L_130A:         jmp   (L_17C5+x)                ; 1F C5 17

L_130D:         mov   a, $22                    ; E4 22
L_130F:         mov   $0442, a                  ; C5 42 04
L_1312:         mov   a, $23                    ; E4 23
L_1314:         mov   $0443, a                  ; C5 43 04
L_1317:         jmp   (L_17D5+x)                ; 1F D5 17

L_131A:         mov   a, $04B4+x                ; F5 B4 04
L_131D:         mov   $20, a                    ; C4 20
L_131F:         beq   L_132D                    ; F0 0C
L_1321:         cmp   a, $04D0+x                ; 75 D0 04
L_1324:         bcs   L_132D                    ; B0 07
L_1326:         mov   a, $048C+x                ; F5 8C 04
L_1329:         mov   x, a                      ; 5D
L_132A:         jmp   (L_132E+x)                ; 1F 2E 13

L_132D:         ret                             ; 6F

; $132E
; Jump table for sound effect styles
L_132E:         dw L_1348 ; 00
                dw L_1348 ; 02
                dw L_134B ; 04
                dw L_134B ; 06
                dw L_1343 ; 08
                dw L_134B ; 0A
                dw L_134B ; 0C
                dw L_1340 ; 0E
                dw L_1340 ; 10

L_1340:         jmp   L_134E                    ; 5F 4E 13

L_1343:         mov   x, $2F                    ; F8 2F
L_1345:         jmp   ($0440+x)                 ; 1F 40 04

L_1348:         jmp   L_148B                    ; 5F 8B 14

L_134B:         jmp   L_0FB7                    ; 5F B7 0F

L_134E:         call  L_13A0                    ; 3F A0 13
L_1351:         beq   L_1391                    ; F0 3E
L_1353:         inc   $D4+x                     ; BB D4
L_1355:         mov   a, $D4+x                  ; F4 D4
L_1357:         cmp   a, $2C                    ; 64 2C
L_1359:         bne   L_1384                    ; D0 29
L_135B:         mov   a, #$00                   ; E8 00
L_135D:         mov   $D4+x, a                  ; D4 D4
L_135F:         mov   a, $D0+x                  ; F4 D0
L_1361:         mov   y, a                      ; FD
L_1362:         inc   $D0+x                     ; BB D0
L_1364:         mov   a, ($26)+y                ; F7 26
L_1366:         cmp   a, #$00                   ; 68 00
L_1368:         beq   L_1391                    ; F0 27
L_136A:         cmp   a, #$7F                   ; 68 7F
L_136C:         beq   L_1385                    ; F0 17
L_136E:         push  y                         ; 6D
L_136F:         call  L_1124                    ; 3F 24 11
L_1372:         pop   y                         ; EE
L_1373:         mov   a, $29                    ; E4 29
L_1375:         beq   L_1384                    ; F0 0D
L_1377:         mov   a, ($28)+y                ; F7 28
L_1379:         and   a, #$1F                   ; 28 1F
L_137B:         mov   $48, a                    ; C4 48
L_137D:         mov   a, $49                    ; E4 49
L_137F:         or    a, sfx_voice_bit          ; 05 D7 04
L_1382:         mov   $49, a                    ; C4 49
L_1384:         ret                             ; 6F

L_1385:         mov   a, $46                    ; E4 46
L_1387:         or    a, sfx_voice_bit          ; 05 D7 04
L_138A:         mov   $46, a                    ; C4 46
L_138C:         mov   a, #$00                   ; E8 00
L_138E:         jmp   L_1144                    ; 5F 44 11

L_1391:         jmp   L_1491                    ; 5F 91 14

L_1394:         mov   $049C+x, a                ; D5 9C 04
L_1397:         ret                             ; 6F

L_1398:         mov   $04BC+x, a                ; D5 BC 04
L_139B:         mov   a, y                      ; DD
L_139C:         mov   $04C0+x, a                ; D5 C0 04
L_139F:         ret                             ; 6F

L_13A0:         mov   x, $2E                    ; F8 2E
L_13A2:         mov   a, $04B8+x                ; F5 B8 04
L_13A5:         inc   a                         ; BC
L_13A6:         mov   $04B8+x, a                ; D5 B8 04
L_13A9:         cmp   a, #$01                   ; 68 01
L_13AB:         beq   L_13DF                    ; F0 32
L_13AD:         cmp   a, $04BC+x                ; 75 BC 04
L_13B0:         beq   L_13C7                    ; F0 15
L_13B2:         cmp   a, $04C0+x                ; 75 C0 04
L_13B5:         bne   L_13D4                    ; D0 1D
L_13B7:         mov   a, $049C+x                ; F5 9C 04
L_13BA:         and   a, #$01                   ; 28 01
L_13BC:         bne   L_13D4                    ; D0 16
L_13BE:         mov   a, $46                    ; E4 46
L_13C0:         or    a, sfx_voice_bit          ; 05 D7 04
L_13C3:         mov   $46, a                    ; C4 46
L_13C5:         bne   L_13D4                    ; D0 0D
L_13C7:         cmp   a, #$FF                   ; 68 FF
L_13C9:         bne   L_13CF                    ; D0 04
L_13CB:         mov   a, #$FE                   ; E8 FE
L_13CD:         bne   L_13D1                    ; D0 02
L_13CF:         mov   a, #$00                   ; E8 00
L_13D1:         mov   $04B8+x, a                ; D5 B8 04
L_13D4:         mov   a, $04B8+x                ; F5 B8 04
L_13D7:         ret                             ; 6F

L_13D8:         mov   a, #$81                   ; E8 81
L_13DA:         mov   $049C+x, a                ; D5 9C 04
L_13DD:         bne   L_13EA                    ; D0 0B
L_13DF:         mov   a, $049C+x                ; F5 9C 04
L_13E2:         cmp   a, #$01                   ; 68 01
L_13E4:         beq   L_13D8                    ; F0 F2
L_13E6:         cmp   a, #$81                   ; 68 81
L_13E8:         beq   L_13D4                    ; F0 EA
L_13EA:         mov   a, $0450+x                ; F5 50 04
L_13ED:         bne   L_1409                    ; D0 1A
L_13EF:         inc   a                         ; BC
L_13F0:         mov   $0450+x, a                ; D5 50 04
L_13F3:         call  L_1557                    ; 3F 57 15
L_13F6:         mov   x, $2E                    ; F8 2E
L_13F8:         mov   a, sfx_adsr_changed+x     ; F5 54 04
L_13FB:         beq   L_1409                    ; F0 0C
L_13FD:         mov   x, $2F                    ; F8 2F
L_13FF:         mov   a, sfx_adsr+1+x           ; F5 59 04
L_1402:         mov   y, a                      ; FD
L_1403:         mov   a, sfx_adsr+0+x           ; F5 58 04
L_1406:         call  L_110D                    ; 3F 0D 11
L_1409:         mov   x, $2E                    ; F8 2E
L_140B:         mov   a, $04C8+x                ; F5 C8 04
L_140E:         bne   L_13D4                    ; D0 C4
L_1410:         mov   a, $45                    ; E4 45
L_1412:         or    a, sfx_voice_bit          ; 05 D7 04
L_1415:         mov   $45, a                    ; C4 45
L_1417:         jmp   L_13D4                    ; 5F D4 13

L_141A:         call  L_1438                    ; 3F 38 14
L_141D:         mov   a, #$00                   ; E8 00
L_141F:         mov   $0491, a                  ; C5 91 04
L_1422:         mov   mfx_fastforward_timer, a  ; C5 38 04
L_1425:         mov   mfx_volume240_timer, a    ; C5 39 04
L_1428:         mov   mfx_volume160_timer, a    ; C5 3A 04
L_142B:         mov   $04C8, a                  ; C5 C8 04
L_142E:         mov   $04C9, a                  ; C5 C9 04
L_1431:         mov   $04CA, a                  ; C5 CA 04
L_1434:         mov   $04CB, a                  ; C5 CB 04
L_1437:         ret                             ; 6F

L_1438:         mov   a, #$00                   ; E8 00
L_143A:         mov   $04B4, a                  ; C5 B4 04
L_143D:         mov   $04B5, a                  ; C5 B5 04
L_1440:         mov   $04B6, a                  ; C5 B6 04
L_1443:         mov   $04B7, a                  ; C5 B7 04
L_1446:         mov   $04B0, a                  ; C5 B0 04
L_1449:         mov   $04B1, a                  ; C5 B1 04
L_144C:         mov   $04B2, a                  ; C5 B2 04
L_144F:         mov   $04B3, a                  ; C5 B3 04
L_1452:         ret                             ; 6F

L_1453:         call  L_145D                    ; 3F 5D 14
L_1456:         call  L_146B                    ; 3F 6B 14
L_1459:         call  L_1479                    ; 3F 79 14
L_145C:         ret                             ; 6F

L_145D:         clr5  $1A                       ; B2 1A
L_145F:         set5  $46                       ; A2 46
L_1461:         set5  $47                       ; A2 47
L_1463:         set5  $5E                       ; A2 5E
L_1465:         mov   a, #$00                   ; E8 00
L_1467:         mov   $04B5, a                  ; C5 B5 04
L_146A:         ret                             ; 6F

L_146B:         clr6  $1A                       ; D2 1A
L_146D:         set6  $46                       ; C2 46
L_146F:         set6  $47                       ; C2 47
L_1471:         set6  $5E                       ; C2 5E
L_1473:         mov   a, #$00                   ; E8 00
L_1475:         mov   $04B6, a                  ; C5 B6 04
L_1478:         ret                             ; 6F

L_1479:         clr7  $1A                       ; F2 1A
L_147B:         set7  $46                       ; E2 46
L_147D:         set7  $47                       ; E2 47
L_147F:         set7  $5E                       ; E2 5E
L_1481:         mov   a, #$00                   ; E8 00
L_1483:         mov   $04B7, a                  ; C5 B7 04
L_1486:         ret                             ; 6F

                dw L_148A
                db $08
L_148A:         ret                             ; 6F

L_148B:         call  L_13A0                    ; 3F A0 13
L_148E:         beq   L_1491                    ; F0 01
L_1490:         ret                             ; 6F

L_1491:         mov   a, sfx_voice_x2           ; E5 DF 04
L_1494:         mov   x, a                      ; 5D
L_1495:         mov   a, $1A                    ; E4 1A
L_1497:         and   a, sfx_voice_bit_NOT      ; 25 D6 04
L_149A:         mov   $1A, a                    ; C4 1A
L_149C:         mov   a, $47                    ; E4 47
L_149E:         or    a, sfx_voice_bit          ; 05 D7 04
L_14A1:         mov   $47, a                    ; C4 47
L_14A3:         mov   a, $5E                    ; E4 5E
L_14A5:         or    a, sfx_voice_bit          ; 05 D7 04
L_14A8:         mov   $5E, a                    ; C4 5E
L_14AA:         mov   a, $04E0+x                ; F5 E0 04
L_14AD:         mov   $0321+x, a                ; D5 21 03
L_14B0:         mov   a, $04F0+x                ; F5 F0 04
L_14B3:         mov   $0351+x, a                ; D5 51 03
L_14B6:         call  L_0C86                    ; 3F 86 0C
L_14B9:         mov   a, sfx_voice_x2           ; E5 DF 04
L_14BC:         mov   x, a                      ; 5D
L_14BD:         mov   a, $1A                    ; E4 1A
L_14BF:         and   a, sfx_voice_bit_NOT      ; 25 D6 04
L_14C2:         mov   $1A, a                    ; C4 1A
L_14C4:         mov   a, $0211+x                ; F5 11 02
L_14C7:         call  SetInstrument             ; 3F 62 09
L_14CA:         mov   x, $2E                    ; F8 2E
L_14CC:         mov   a, #$00                   ; E8 00
L_14CE:         mov   $04B4+x, a                ; D5 B4 04
L_14D1:         mov   $04C8+x, a                ; D5 C8 04
L_14D4:         mov   $048C+x, a                ; D5 8C 04
L_14D7:         mov   a, $46                    ; E4 46
L_14D9:         or    a, sfx_voice_bit          ; 05 D7 04
L_14DC:         mov   $46, a                    ; C4 46
L_14DE:         ret                             ; 6F

L_14DF:         movw  $22, ya                   ; DA 22
L_14E1:         mov   a, #$00                   ; E8 00
L_14E3:         mov   x, $2E                    ; F8 2E
L_14E5:         mov   $04CC+x, a                ; D5 CC 04
L_14E8:         mov   $04C8+x, a                ; D5 C8 04
L_14EB:         jmp   L_1505                    ; 5F 05 15

L_14EE:         movw  $22, ya                   ; DA 22
L_14F0:         mov   $24, x                    ; D8 24
L_14F2:         mov   a, $48                    ; E4 48
L_14F4:         and   a, #$E0                   ; 28 E0
L_14F6:         or    a, $24                    ; 04 24
L_14F8:         mov   $48, a                    ; C4 48
L_14FA:         bne   L_1500                    ; D0 04
L_14FC:         movw  $22, ya                   ; DA 22
L_14FE:         mov   a, #$00                   ; E8 00
L_1500:         mov   x, $2E                    ; F8 2E
L_1502:         mov   $04CC+x, a                ; D5 CC 04
L_1505:         call  L_1547                    ; 3F 47 15
L_1508:         mov   ($20), ($2A)              ; FA 2A 20
L_150B:         mov   ($21), ($2B)              ; FA 2B 21
L_150E:         mov   y, #$00                   ; 8D 00
L_1510:         mov   a, ($22)+y                ; F7 22
L_1512:         mov   ($20)+y, a                ; D7 20
L_1514:         inc   y                         ; FC
L_1515:         cmp   y, #$07                   ; AD 07
L_1517:         bne   L_1510                    ; D0 F7
L_1519:         mov   a, $1A                    ; E4 1A
L_151B:         or    a, sfx_voice_bit          ; 05 D7 04
L_151E:         mov   $1A, a                    ; C4 1A
L_1520:         mov   a, $46                    ; E4 46
L_1522:         or    a, sfx_voice_bit          ; 05 D7 04
L_1525:         mov   $46, a                    ; C4 46
L_1527:         mov   a, sfx_voice_bit          ; E5 D7 04
L_152A:         mov   a, #$00                   ; E8 00
L_152C:         mov   $04B8+x, a                ; D5 B8 04
L_152F:         mov   $D0+x, a                  ; D4 D0
L_1531:         mov   $D4+x, a                  ; D4 D4
L_1533:         mov   $D8+x, a                  ; D4 D8
L_1535:         mov   $049C+x, a                ; D5 9C 04
L_1538:         mov   $04B0+x, a                ; D5 B0 04
L_153B:         mov   $0450+x, a                ; D5 50 04
L_153E:         mov   sfx_adsr_changed+x, a     ; D5 54 04
L_1541:         mov   a, $2D                    ; E4 2D
L_1543:         mov   $04B4+x, a                ; D5 B4 04
L_1546:         ret                             ; 6F

L_1547:         mov   y, #$00                   ; 8D 00
L_1549:         mov   a, ($22)+y                ; F7 22
L_154B:         mov   $04BC+x, a                ; D5 BC 04
L_154E:         inc   y                         ; FC
L_154F:         mov   a, ($22)+y                ; F7 22
L_1551:         mov   $21, a                    ; C4 21
L_1553:         mov   $04C0+x, a                ; D5 C0 04
L_1556:         ret                             ; 6F

L_1557:         mov   a, $2A                    ; E4 2A
L_1559:         inc   a                         ; BC
L_155A:         inc   a                         ; BC
L_155B:         mov   y, $2B                    ; EB 2B
L_155D:         movw  $22, ya                   ; DA 22
L_155F:         mov   y, #$00                   ; 8D 00
L_1561:         mov   a, $04CC+x                ; F5 CC 04
L_1564:         beq   L_156F                    ; F0 09
L_1566:         mov   a, $49                    ; E4 49
L_1568:         or    a, sfx_voice_bit          ; 05 D7 04
L_156B:         mov   $49, a                    ; C4 49
L_156D:         bne   L_1576                    ; D0 07
L_156F:         mov   a, $49                    ; E4 49
L_1571:         and   a, sfx_voice_bit_NOT      ; 25 D6 04
L_1574:         mov   $49, a                    ; C4 49
L_1576:         mov   x, sfx_voice_x2           ; E9 DF 04
L_1579:         mov   a, $0321+x                ; F5 21 03
L_157C:         mov   $04E0+x, a                ; D5 E0 04
L_157F:         mov   a, $0351+x                ; F5 51 03
L_1582:         mov   $04F0+x, a                ; D5 F0 04
L_1585:         mov   $47, #$00                 ; 8F 00 47
L_1588:         mov   a, ($22)+y                ; F7 22
L_158A:         push  y                         ; 6D
L_158B:         call  SetInstrument             ; 3F 62 09
L_158E:         pop   y                         ; EE
L_158F:         inc   y                         ; FC
L_1590:         mov   a, ($22)+y                ; F7 22
L_1592:         inc   y                         ; FC
L_1593:         mov   $0321+x, a                ; D5 21 03
L_1596:         mov   a, ($22)+y                ; F7 22
L_1598:         and   a, #$C0                   ; 28 C0
L_159A:         mov   $0351+x, a                ; D5 51 03
L_159D:         mov   a, ($22)+y                ; F7 22
L_159F:         inc   y                         ; FC
L_15A0:         and   a, #$3F                   ; 28 3F
L_15A2:         mov   temp_sfx_pan, a           ; C5 33 04
L_15A5:         mov   a, mono_flag              ; E5 31 04
L_15A8:         cmp   a, #$00                   ; 68 00
L_15AA:         beq   L_15B1                    ; F0 05
L_15AC:         mov   a, #$0A                   ; E8 0A
L_15AE:         mov   temp_sfx_pan, a           ; C5 33 04
L_15B1:         mov   a, temp_sfx_pan           ; E5 33 04
L_15B4:         mov   $11, a                    ; C4 11
L_15B6:         mov   $10, #$00                 ; 8F 00 10
L_15B9:         mov   a, $47                    ; E4 47
L_15BB:         and   a, sfx_voice_bit_NOT      ; 25 D6 04
L_15BE:         mov   $47, a                    ; C4 47
L_15C0:         push  y                         ; 6D
L_15C1:         call  L_0C95                    ; 3F 95 0C
L_15C4:         pop   y                         ; EE
L_15C5:         mov   a, ($22)+y                ; F7 22
L_15C7:         inc   y                         ; FC
L_15C8:         mov   $11, a                    ; C4 11
L_15CA:         mov   a, ($22)+y                ; F7 22
L_15CC:         mov   $10, a                    ; C4 10
L_15CE:         mov   a, $47                    ; E4 47
L_15D0:         and   a, sfx_voice_bit_NOT      ; 25 D6 04
L_15D3:         mov   $47, a                    ; C4 47
L_15D5:         jmp   L_06D4                    ; 5F D4 06

L_15D8:         dw    L_148A
                db    $08
L_15DB:         mov   a, #$00                   ; E8 00
L_15DD:         mov   $04B5, a                  ; C5 B5 04
L_15E0:         mov   $0491, a                  ; C5 91 04
L_15E3:         ret                             ; 6F

L_15E4:         dw    L_148A
                db    $08
L_15E7:         mov   a, #$02                   ; E8 02
L_15E9:         mov   $0492, a                  ; C5 92 04
L_15EC:         mov   a, #$70                   ; E8 70
L_15EE:         mov   $0491, a                  ; C5 91 04
L_15F1:         bne   L_1600                    ; D0 0D

L_15F3:         dw    L_148A
                db    $08
L_15F6:         mov   a, #$01                   ; E8 01
L_15F8:         mov   $0492, a                  ; C5 92 04
L_15FB:         mov   a, #$18                   ; E8 18
L_15FD:         mov   $0491, a                  ; C5 91 04
L_1600:         mov   $5A, a                    ; C4 5A
L_1602:         mov   a, #$10                   ; E8 10
L_1604:         mov   $5B, a                    ; C4 5B
L_1606:         jmp   L_0A30                    ; 5F 30 0A

L_1609:         mov   a, $0491                  ; E5 91 04
L_160C:         cmp   a, #$00                   ; 68 00
L_160E:         beq   L_1627                    ; F0 17
L_1610:         cmp   a, #$FF                   ; 68 FF
L_1612:         beq   L_1628                    ; F0 14
L_1614:         dec   a                         ; 9C
L_1615:         mov   $0491, a                  ; C5 91 04
L_1618:         cmp   a, #$00                   ; 68 00
L_161A:         bne   L_1627                    ; D0 0B
L_161C:         mov   a, #%00110001             ; E8 31    // Reset ports, start timer0
L_161E:         mov.w CONTROL, a                ; C5 F1 00
L_1621:         call  L_1438                    ; 3F 38 14
L_1624:         call  L_1453                    ; 3F 53 14
L_1627:         ret                             ; 6F

L_1628:         mov   a, #$00                   ; E8 00
L_162A:         mov   $0491, a                  ; C5 91 04
L_162D:         ret                             ; 6F

; $162E
SetVolume:      mov   y, a                      ; FD
                jmp   VCMD_Volume               ; 5F 24 0A

; $1632
SetTempo:       mov   y, a                      ; FD
L_1633:         mov   a, $53                    ; E4 53
L_1635:         mov   mfx_tempo_backup, a       ; C5 93 04
L_1638:         jmp   VCMD_Tempo                ; 5F 3B 0A

; $163B
RestoreTempo:   mov   a, mfx_tempo_backup       ; E5 93 04
L_163E:         mov   y, a                      ; FD
L_163F:         bne   L_1638                    ; D0 F7
L_1641:         mov   $54, a                    ; C4 54
L_1643:         mov   a, $20                    ; E4 20
L_1645:         mov   $55, a                    ; C4 55
L_1647:         jmp   L_0A47                    ; 5F 47 0A

L_164A:         mov   $02B0+x, a                ; D5 B0 02
L_164D:         mov   a, $20                    ; E4 20
L_164F:         mov   $02A1+x, a                ; D5 A1 02
L_1652:         mov   a, $21                    ; E4 21
L_1654:         mov   $B1+x, a                  ; D4 B1
L_1656:         mov   $02C1+x, a                ; D5 C1 02
L_1659:         mov   a, #$00                   ; E8 00
L_165B:         mov   $02B1+x, a                ; D5 B1 02
L_165E:         ret                             ; 6F

L_165F:         mov   a, #$00                   ; E8 00
L_1661:         beq   L_1654                    ; F0 F1
; $1663
SetTranspose:   mov   $50, a                    ; C4 50
L_1665:         ret                             ; 6F

L_1666:         mov   $02F0+x, a                ; D5 F0 02
L_1669:         ret                             ; 6F

; $166A
SetVoiceVolume: call  VCMD_VoiceVolume          ; 3F 86 0A
                ret                             ; 6F

L_166E:         mov   $44, x                    ; D8 44
L_1670:         mov   $90+x, a                  ; D4 90
L_1672:         push  a                         ; 2D
L_1673:         mov   a, $20                    ; E4 20
L_1675:         jmp   L_0A95                    ; 5F 95 0A

L_1678:         push  a                         ; 2D
L_1679:         mov   a, #$01                   ; E8 01
L_167B:         bra   L_1680                    ; 2F 03

L_167D:         push  a                         ; 2D
L_167E:         mov   a, #$00                   ; E8 00
L_1680:         mov   $0290+x, a                ; D5 90 02
L_1683:         pop   a                         ; AE
L_1684:         mov   $0281+x, a                ; D5 81 02
L_1687:         mov   a, $20                    ; E4 20
L_1689:         mov   $0280+x, a                ; D5 80 02
L_168C:         mov   a, $21                    ; E4 21
L_168E:         mov   $0291+x, a                ; D5 91 02
L_1691:         ret                             ; 6F

L_1692:         mov   a, #$00                   ; E8 00
L_1694:         mov   $0280+x, a                ; D5 80 02
L_1697:         ret                             ; 6F

L_1698:         jmp   L_09C8                    ; 5F C8 09

L_169B:         mov   $44, x                    ; D8 44
L_169D:         mov   $91+x, a                  ; D4 91
L_169F:         push  a                         ; 2D
L_16A0:         mov   a, $20                    ; E4 20
L_16A2:         jmp   L_09DC                    ; 5F DC 09

; $16A5
L_16A5:         mov   x, #$20                   ; CD 20
L_16A7:         mov   $0400+x, a                ; D5 00 04
L_16AA:         inc   x                         ; 3D
L_16AB:         cmp   x, #$00                   ; C8 00
L_16AD:         bne   L_16A7                    ; D0 F8
L_16AF:         mov   y, a                      ; FD
L_16B0:         mov   $24, #$00                 ; 8F 00 24
L_16B3:         mov   $25, #$E8                 ; 8F E8 25
L_16B6:         mov   ($24)+y, a                ; D7 24
L_16B8:         inc   y                         ; FC
L_16B9:         cmp   y, #$00                   ; AD 00
L_16BB:         bne   L_16B6                    ; D0 F9
L_16BD:         inc   $25                       ; AB 25
L_16BF:         cmp   $25, #$FF                 ; 78 FF 25
L_16C2:         bne   L_16B6                    ; D0 F2
L_16C4:         jmp   L_2FC8                    ; 5F C8 2F

; $16C7
SFX_Table:      dw SFX_01 ; 001 [01] (Menu confirm)
                dw SFX_02 ; 002 [02] (Menu cancel)
                dw SFX_03 ; 003 [03] (Cursor move)
                dw SFX_04 ; 004 [04] (Slot machine)
                dw SFX_05 ; 005 [05] (Error beep)
                dw SFX_06 ; 006 [06] (Inaudible, stops other SFX)
                dw SFX_07 ; 007 [07] (Text blip)
                dw SFX_08 ; 008 [08] (Enter door)
                dw SFX_09 ; 009 [09] (Exit door)
                dw SFX_0A ; 010 [0A] (Phone ring)
                dw SFX_0B ; 011 [0B] (Pick up phone)
                dw SFX_0C ; 012 [0C] (Cash register)
                dw SFX_0D ; 013 [0D] (Camera shutter)
                dw SFX_0E ; 014 [0E] (Blow a bubble)
                dw SFX_0F ; 015 [0F] (Robot footstep)
                dw SFX_10 ; 016 [10] (Open present)
                dw SFX_11 ; 017 [11] (Fall into hole)
                dw SFX_12 ; 018 [12] (Stairs)
                dw SFX_13 ; 019 [13] (Shallow water step)
                dw SFX_14 ; 020 [14] (Deep water step)
                dw SFX_15 ; 021 [15] (Magicant footstep)
                dw SFX_16 ; 022 [16] (Onett trumpet guy)
                dw SFX_17 ; 023 [17] (Bicycle bell)
                dw SFX_18 ; 024 [18] (Player turn)
                dw SFX_19 ; 025 [19] (Enemy turn)
                dw SFX_1A ; 026 [1A] (Bash)
                dw SFX_1B ; 027 [1B] (Shoot)
                dw SFX_1C ; 028 [1C] (Pray)
                dw SFX_1D ; 029 [1D] (Player PSI)
                dw SFX_1E ; 030 [1E] (Enemy damaged)
                dw SFX_1F ; 031 [1F] (SMAAAAASH!!)
                dw SFX_20 ; 032 [20] (Player downed)
                dw SFX_21 ; 033 [21] (Enemy defeated)
                dw SFX_22 ; 034 [22] (Miss attack)
                dw SFX_23 ; 035 [23] (Dodge attack)
                dw SFX_24 ; 036 [24] (Lifeup)
                dw SFX_25 ; 037 [25] (Status heal)
                dw SFX_26 ; 038 [26] (Shield)
                dw SFX_27 ; 039 [27] (PSI Shield)
                dw SFX_28 ; 040 [28] (Stat up)
                dw SFX_29 ; 041 [29] (Stat down)
                dw SFX_2A ; 042 [2A] (Hypnosis Alpha/Omega)
                dw SFX_2B ; 043 [2B] (Magnet Alpha)
                dw SFX_2C ; 044 [2C] (Paralysis Alpha)
                dw SFX_2D ; 045 [2D] (Brainshock Alpha)
                dw SFX_2E ; 046 [2E] (Player wounded)
                dw SFX_2F ; 047 [2F] (Player mortally wounded)
                dw SFX_30 ; 048 [30] (Rockin 1)
                dw SFX_31 ; 049 [31] (Rockin 2)
                dw SFX_32 ; 050 [32] (Rockin 3)
                dw SFX_33 ; 051 [33] (Fire 1)
                dw SFX_34 ; 052 [34] (Fire 2)
                dw SFX_35 ; 053 [35] (Fire 3)
                dw SFX_36 ; 054 [36] (Counter-PSI Unit)
                dw SFX_37 ; 055 [37] (Enemy PSI)
                dw SFX_38 ; 056 [38] (Freeze 1)
                dw SFX_39 ; 057 [39] (Freeze 2)
                dw SFX_3A ; 058 [3A] (Freeze 3)
                dw SFX_3B ; 059 [3B] (HP Sucker)
                dw SFX_3C ; 060 [3C] (Thunder Alpha/Beta miss)
                dw SFX_3D ; 061 [3D] (Thunder Gamma/Omega miss)
                dw SFX_3E ; 062 [3E] (Thunder Alpha/Beta strike)
                dw SFX_3F ; 063 [3F] (Thunder Gamme/Omega strike)
                dw SFX_40 ; 064 [40] (Starstorm)
                dw SFX_41 ; 065 [41] (Flash 1)
                dw SFX_42 ; 066 [42] (Flash 2)
                dw SFX_43 ; 067 [43] (Flash 3)
                dw SFX_44 ; 068 [44] (Eat/drink)
                dw SFX_45 ; 069 [45]
                dw SFX_46 ; 070 [46] (Bottle Rocket)
                dw SFX_47 ; 071 [47] (White noise)
                dw SFX_48 ; 072 [48] (Call for help)
                dw SFX_49 ; 073 [49] (Sky Runner signal/Giygas shield)
                dw SFX_4A ; 074 [4A] (Devil's machine turned off)
                dw SFX_4B ; 075 [4B] (Burst into flames)
                dw SFX_4C ; 076 [4C] (Magnet Omega)
                dw SFX_4D ; 077 [4D] (Fire a beam)
                dw SFX_4E ; 078 [4E] (Belch's burp)
                dw SFX_4F ; 079 [4F] (Paralysis Omega)
                dw SFX_50 ; 080 [50] (Brainshock Omega)
                dw SFX_51 ; 081 [51] (Giygas' attack/actic-cold breath)
                dw SFX_52 ; 082 [52] (Scatter pollen/spores)
                dw SFX_53 ; 083 [53] (Status inflicted)
                dw SFX_54 ; 084 [54] (Yell/say something nasty)
                dw SFX_55 ; 085 [55] (Do something very mysterious)
                dw SFX_56 ; 086 [56] (Storm)
                dw SFX_57 ; 087 [57] (Dummy inaudible sound)
                dw SFX_58 ; 088 [58] (Extinguishing blast)
                dw SFX_59 ; 089 [59] (Replenish a fuel supply)
                dw SFX_5A ; 090 [5A] (Tornado)
                dw SFX_5B ; 091 [5B] (Explosion)
                dw SFX_5C ; 092 [5C] (Slimy Pile burp)
                dw SFX_5D ; 093 [5D] (Shield reflect)
                dw SFX_5E ; 094 [5E] (Name input START button)
                dw SFX_5F ; 095 [5F] (Magic Butterfly)
                dw SFX_60 ; 096 [60] (Ghost)
                dw SFX_61 ; 097 [61] (Stairs fast)
                dw SFX_62 ; 098 [62] (Pokey gets BEATEN by Aloysius)
                dw SFX_63 ; 099 [63] (Shield Killer/Star Master)
                dw SFX_64 ; 100 [64] (Sea of Eden warp)
                dw SFX_65 ; 101 [65] (Chick)
                dw SFX_66 ; 102 [66] (Key item fanfare)
                dw SFX_67 ; 103 [67] (PSI learn fanfare)
                dw SFX_68 ; 104 [68] (Chicken)
                dw SFX_69 ; 105 [69] (Sphinx 1)
                dw SFX_6A ; 106 [6A] (Sphinx 2)
                dw SFX_6B ; 107 [6B] (Sphinx 3)
                dw SFX_6C ; 108 [6C] (Sphinx 4)
                dw SFX_6D ; 109 [6D] (Sphinx 5)
                dw SFX_6E ; 110 [6E] (Sphinx done)
                dw SFX_6F ; 111 [6F] (Door knocking)
                dw SFX_70 ; 112 [70] (Nearly inaudible)
                dw SFX_71 ; 113 [71] (Mani Mani glows)
                dw SFX_72 ; 114 [72] (Spooky...)
                dw SFX_73 ; 115 [73] (Equip item)
                dw SFX_74 ; 116 [74] (Take item/money)
                dw SFX_75 ; 117 [75] (Open present lower volume)
                dw SFX_76 ; 118 [76] (Give item/money)
                dw SFX_77 ; 119 [77] (Unlock door)
                dw SFX_78 ; 120 [78] (Buy item)
                dw SFX_79 ; 121 [79] (Pyramid open/Tenda underground open)
                dw SFX_7A ; 122 [7A] (Name input add letter)
                dw SFX_7B ; 123 [7B] (Name input cursor move left/right)
                dw SFX_7C ; 124 [7C] (Name input cursor move up/down)
                dw SFX_7D ; 125 [7D] (Name input backspace)
                dw SFX_7E ; 126 [7E] (Name input confirm)
                dw SFX_7F ; 127 [7F], L_148A

; $17C5
L_17C5:         dw L_1810 ; 01 - Stop static
                dw L_1823 ; 02 - Start static
                dw L_148A ; 03
                dw L_148A ; 04
                dw L_148A ; 05
                dw L_148A ; 06
                dw L_148A ; 07
                dw L_148A ; 08

; $17D5
L_17D5:         dw L_15DB ; 01 [01]
                dw L_15F6 ; 02 [02]
                dw L_15E7 ; 03 [03]
                dw L_148A ; 04 [04]
                dw MFX_05 ; 05 [05] (Fast forward)
                dw L_148A ; 06 [06]
                dw MFX_07 ; 07 [07] (Set volume to 160 after 40 16ms ticks)
                dw MFX_08 ; 08 [08] (Set volume to 240 after 105 16ms ticks)
                dw L_2CDA ; 09 [09]
                dw L_2CE6 ; 10 [0A]
                dw L_2CF2 ; 11 [0B]
                dw L_2CFE ; 12 [0C]
                dw L_2D0A ; 13 [0D]
                dw L_2D16 ; 14 [0E]
                dw L_2D22 ; 15 [0F]
                dw L_2D2E ; 16 [10]
                dw L_148A ; 17 [11]
                dw L_148A ; 18 [12]
                dw L_148A ; 19 [13]
                dw L_148A ; 20 [14]
                dw MFX_15 ; 21 [15] (Set transpose to 16 semitones)
                dw MFX_16 ; 22 [16] (Set transpose to 0 semitones)
                dw MFX_17 ; 23 [17] (Set volume to 100)
                dw MFX_18 ; 24 [18] (Set volume to 240)
                dw L_2D8D ; 25 [19]
                dw L_2DA3 ; 26 [1A]
                dw L_2D82 ; 27 [1B]
                dw L_2D98 ; 28 [1C]

; $180D - Stop static
L_180D:         dw L_148A
                db $08
L_1810:         jmp   L_1491

; $1813
L_1813:         db $02                ; SFX style 02
                db $16, $14           ; Note length, hold length
                db $05, $FF, $C2, $A6 ; Instrument, volume, pan, note
                db $00                ; Detune

; $181B
L_181B:         mov   a, #$D8                   ; E8 D8
L_181D:         mov   y, #$04                   ; 8D 04
L_181F:         jmp   L_14DF                    ; 5F DF 14

; $1822 - Start static
                db $02
L_1823:         db $F9, $F4           ; Note length, hold length
                db $18, $DC, $CA, $B0 ; Instrument, volume, pan, note
                db $00                ; Detune

; sound effect data
incsrc "sfx_sequences.asm"


; $2C8F - Set volume to 100
                dw L_148A
                db $08
MFX_17:         mov   a, #$64                   ; E8 64
                jmp   SetVolume                 ; 5F 2E 16

; $2C97 - Set volume to 240
                dw L_148A
                db $08
MFX_18:         mov   a, #$F0                   ; E8 F0
                jmp   SetVolume                 ; 5F 2E 16

; $2C9F - Set transpose to 16 semitones
                dw L_148A
                db $08
MFX_15:         mov   a, #$10                   ; E8 10
                jmp   SetTranspose              ; 5F 63 16

; $2CA7 - Set transpose to 0 semitones
                dw L_148A
                db $08
MFX_16:         mov   a, #$00                   ; E8 00
                jmp   SetTranspose              ; 5F 63 16

; $2CAF
L_2CAF:         db 0, 0, 0, 0, 0

; $2CB4
L_2CB4:         db 0, 0, 0, 0, 0

; $2CB9
L_2CB9:         db 0, 0, 0, 0, 120

; $2CBE
L_2CBE:         db 100, 0, 0, 0, 120

; $2CC3
L_2CC3:         db 100, 100, 0, 0, 120

; $2CC8 - Unused lol
L_2CC8:         db 100, 100, 0, 0, 120

; $2CCD
L_2CCD:         db 100, 100, 100, 0, 120

; $2CD2
L_2CD2:         db 100, 100, 100, 120, 120

; $2CD7
                dw L_148A
                db $08
L_2CDA:         mov.b $22, #L_2CAF              ; 8F AF 22
L_2CDD:         mov.b $23, #L_2CAF>>8           ; 8F 2C 23
L_2CE0:         jmp   L_2D37                    ; 5F 37 2D

                dw L_148A
                db $08
L_2CE6:         mov.b $22, #L_2CB4              ; 8F B4 22
L_2CE9:         mov.b $23, #L_2CB4>>8           ; 8F 2C 23
L_2CEC:         jmp   L_2D37                    ; 5F 37 2D

                dw L_148A
                db $08
L_2CF2:         mov.b $22, #L_2CB9              ; 8F B9 22
L_2CF5:         mov.b $23, #L_2CB9>>8           ; 8F 2C 23
L_2CF8:         jmp   L_2D37                    ; 5F 37 2D

                dw L_148A
                db $08
L_2CFE:         mov.b $22, #L_2CBE              ; 8F BE 22
L_2D01:         mov.b $23, #L_2CBE>>8           ; 8F 2C 23
L_2D04:         jmp   L_2D37                    ; 5F 37 2D

                dw L_148A
                db $08
L_2D0A:         mov.b $22, #L_2CC3              ; 8F C3 22
L_2D0D:         mov.b $23, #L_2CC3>>8           ; 8F 2C 23
L_2D10:         jmp   L_2D37                    ; 5F 37 2D

                dw L_148A
                db $08
L_2D16:         mov.b $22, #L_2CC3              ; 8F C3 22
L_2D19:         mov.b $23, #L_2CC3>>8           ; 8F 2C 23
L_2D1C:         jmp   L_2D37                    ; 5F 37 2D

                dw L_148A
                db $08
L_2D22:         mov.b $22, #L_2CCD              ; 8F CD 22
L_2D25:         mov.b $23, #L_2CCD>>8           ; 8F 2C 23
L_2D28:         jmp   L_2D37                    ; 5F 37 2D

                dw L_148A
                db $08
L_2D2E:         mov.b $22, #L_2CD2              ; 8F D2 22
L_2D31:         mov.b $23, #L_2CD2>>8           ; 8F 2C 23
L_2D34:         jmp   L_2D37                    ; 5F 37 2D

L_2D37:         mov   y, #$00                   ; 8D 00
L_2D39:         mov   x, #$02                   ; CD 02
L_2D3B:         mov   a, ($22)+y                ; F7 22
L_2D3D:         mov   $20, a                    ; C4 20
L_2D3F:         mov   a, #$14                   ; E8 14
L_2D41:         push  y                         ; 6D
L_2D42:         call  L_166E                    ; 3F 6E 16
L_2D45:         pop   y                         ; EE
L_2D46:         inc   y                         ; FC
L_2D47:         mov   x, #$04                   ; CD 04
L_2D49:         mov   a, ($22)+y                ; F7 22
L_2D4B:         mov   $20, a                    ; C4 20
L_2D4D:         mov   a, #$14                   ; E8 14
L_2D4F:         push  y                         ; 6D
L_2D50:         call  L_166E                    ; 3F 6E 16
L_2D53:         pop   y                         ; EE
L_2D54:         inc   y                         ; FC
L_2D55:         mov   x, #$06                   ; CD 06
L_2D57:         mov   a, ($22)+y                ; F7 22
L_2D59:         mov   $20, a                    ; C4 20
L_2D5B:         mov   a, #$14                   ; E8 14
L_2D5D:         push  y                         ; 6D
L_2D5E:         call  L_166E                    ; 3F 6E 16
L_2D61:         pop   y                         ; EE
L_2D62:         inc   y                         ; FC
L_2D63:         mov   x, #$08                   ; CD 08
L_2D65:         mov   a, ($22)+y                ; F7 22
L_2D67:         mov   $20, a                    ; C4 20
L_2D69:         mov   a, #$14                   ; E8 14
L_2D6B:         push  y                         ; 6D
L_2D6C:         call  L_166E                    ; 3F 6E 16
L_2D6F:         pop   y                         ; EE
L_2D70:         inc   y                         ; FC
L_2D71:         mov   x, #$0A                   ; CD 0A
L_2D73:         mov   a, ($22)+y                ; F7 22
L_2D75:         mov   $20, a                    ; C4 20
L_2D77:         mov   a, #$14                   ; E8 14
L_2D79:         push  y                         ; 6D
L_2D7A:         call  L_166E                    ; 3F 6E 16
L_2D7D:         pop   y                         ; EE
L_2D7E:         ret                             ; 6F

                dw L_148A
                db $08
L_2D82:         mov   x, #$0E                   ; CD 0E
L_2D84:         mov   a, #$5A                   ; E8 5A
L_2D86:         call  SetVoiceVolume            ; 3F 6A 16
L_2D89:         ret                             ; 6F

                dw L_148A
                db $08
L_2D8D:         mov   x, #$0E                   ; CD 0E
L_2D8F:         mov   a, #$FA                   ; E8 FA
L_2D91:         call  SetVoiceVolume            ; 3F 6A 16
L_2D94:         ret                             ; 6F

                dw L_148A
                db $08
L_2D98:         mov   x, #$0E                   ; CD 0E
L_2D9A:         mov   a, #$28                   ; E8 28
L_2D9C:         call  SetVoiceVolume            ; 3F 6A 16
L_2D9F:         ret                             ; 6F

                dw L_148A
                db $08
L_2DA3:         mov   x, #$0E                   ; CD 0E
L_2DA5:         mov   a, #$00                   ; E8 00
L_2DA7:         call  SetVoiceVolume            ; 3F 6A 16
L_2DAA:         ret                             ; 6F

; $2DAB
TickFastForward:
                mov   a, mfx_fastforward_timer  ; E5 38 04
                cmp   a, #$00                   ; 68 00
                bne   L_2DB3                    ; D0 01
L_2DB2:         ret                             ; 6F

L_2DB3:         dec   a                         ; 9C
                mov   mfx_fastforward_timer, a  ; C5 38 04
                cmp   a, #$00                   ; 68 00
                bne   L_2DB2                    ; D0 F7
                mov   a, #$00                   ; E8 00
                call  SetTranspose              ; 3F 63 16
                jmp   RestoreTempo              ; 5F 3B 16

; $2DC3 - Fast forward
                dw L_148A
                db $08
MFX_05:         mov   a, #$70                   ; E8 70
                mov   mfx_fastforward_timer, a  ; C5 38 04
                mov   a, #$0E                   ; E8 0E
                call  SetTranspose              ; 3F 63 16
                mov   a, #$C8                   ; E8 C8
                jmp   SetTempo                  ; 5F 32 16

; $2DD5
TickVolume160:  mov   a, mfx_volume160_timer    ; E5 3A 04
                cmp   a, #$00                   ; 68 00
                bne   L_2DDD                    ; D0 01
L_2DDC:         ret                             ; 6F

L_2DDD:         dec   a                         ; 9C
                mov   mfx_volume160_timer, a    ; C5 3A 04
                cmp   a, #$00                   ; 68 00
                bne   L_2DDC                    ; D0 F7
                mov   a, #$A0                   ; E8 A0
                jmp   SetVolume                 ; 5F 2E 16

; $2DEA - Set volume to 160 after 40 16ms ticks
                dw L_148A
                db $08
MFX_07:         mov   a, #$28                   ; E8 28
                mov   mfx_volume160_timer, a    ; C5 3A 04
                ret                             ; 6F

; $2DF3
TickVolume240:  mov   a, mfx_volume240_timer    ; E5 39 04
                cmp   a, #$00                   ; 68 00
                bne   L_2DFB                    ; D0 01
L_2DFA:         ret                             ; 6F

L_2DFB:         dec   a                         ; 9C
                mov   mfx_volume240_timer, a    ; C5 39 04
                cmp   a, #$00                   ; 68 00
                bne   L_2DFA                    ; D0 F7
                mov   a, #$F0                   ; E8 F0
                jmp   SetVolume                 ; 5F 2E 16

; $2E08 - Set volume to 240 after 105 16ms ticks
                dw L_148A
                db $08
MFX_08:         mov   a, #$69                   ; E8 69
                mov   mfx_volume240_timer, a    ; C5 39 04
                ret                             ; 6F

L_2E11:         mov   a, $04                    ; E4 04
L_2E13:         cmp   a, #$1C                   ; 68 1C
L_2E15:         bne   L_2E1C                    ; D0 05
L_2E17:         mov   a, #$02                   ; E8 02
L_2E19:         call  StartMusic                ; 3F 72 07
L_2E1C:         ret                             ; 6F

L_2E1D:         and   a, #$7F                   ; 28 7F
L_2E1F:         mov   $20, a                    ; C4 20
L_2E21:         cmp   a, #$08                   ; 68 08
L_2E23:         bcc   L_2E38                    ; 90 13
L_2E25:         mov   a, $20                    ; E4 20
L_2E27:         cmp   a, #$07                   ; 68 07
L_2E29:         bne   L_2E37                    ; D0 0C
L_2E2B:         mov   a, $04B7                  ; E5 B7 04
L_2E2E:         cmp   a, #$07                   ; 68 07
L_2E30:         bne   L_2E37                    ; D0 05
L_2E32:         mov   a, #$00                   ; E8 00
L_2E34:         mov   $04B3, a                  ; C5 B3 04
L_2E37:         ret                             ; 6F

L_2E38:         mov   a, $04B7                  ; E5 B7 04
L_2E3B:         cmp   a, #$00                   ; 68 00
L_2E3D:         beq   L_2E25                    ; F0 E6
L_2E3F:         cmp   a, #$08                   ; 68 08
L_2E41:         bcc   L_2E25                    ; 90 E2
L_2E43:         mov   a, #$00                   ; E8 00
L_2E45:         mov   $04B3, a                  ; C5 B3 04
L_2E48:         beq   L_2E25                    ; F0 DB


print "SONG TABLE AT $", pc
print "SONG TABLE SHOULD BE AT $002E4A FOR COILSNAKE 4.2"
; $2E4A - Song table
Song_Table:     dw $4800 ; 001 [01]
                dw $5000 ; 002 [02]
                dw $4800 ; 003 [03]
                dw $2FDD ; 004 [04] (in-engine, eventually overwritten by CoilSnake)
                dw $301C ; 005 [05] (in-engine, eventually overwritten by CoilSnake)
                dw $36AA ; 006 [06] (in-engine, eventually overwritten by CoilSnake)
                dw $4800 ; 007 [07]
                dw $3A52 ; 008 [08] (in-engine, eventually overwritten by CoilSnake)
                dw $3B81 ; 009 [09] (in-engine, eventually overwritten by CoilSnake)
                dw $4800 ; 010 [0A]
                dw $3DA1 ; 011 [0B] (in-engine, eventually overwritten by CoilSnake)
                dw $4064 ; 012 [0C] (in-engine, eventually overwritten by CoilSnake)
                dw $4298 ; 013 [0D] (in-engine, eventually overwritten by CoilSnake)
                dw $41A8 ; 014 [0E] (in-engine, eventually overwritten by CoilSnake)
                dw $4800 ; 015 [0F]
                dw $5800 ; 016 [10]
                dw $5800 ; 017 [11]
                dw $5800 ; 018 [12]
                dw $4800 ; 019 [13]
                dw $5800 ; 020 [14]
                dw $5800 ; 021 [15]
                dw $4800 ; 022 [16]
                dw $4800 ; 023 [17]
                dw $4800 ; 024 [18]
                dw $5800 ; 025 [19]
                dw $4800 ; 026 [1A]
                dw $5200 ; 027 [1B]
                dw $4800 ; 028 [1C]
                dw $5800 ; 029 [1D]
                dw $5800 ; 030 [1E]
                dw $6000 ; 031 [1F]
                dw $4800 ; 032 [20]
                dw $4A00 ; 033 [21]
                dw $4C00 ; 034 [22]
                dw $4E00 ; 035 [23]
                dw $5000 ; 036 [24]
                dw $5200 ; 037 [25]
                dw $5400 ; 038 [26]
                dw $5600 ; 039 [27]
                dw $5800 ; 040 [28]
                dw $5800 ; 041 [29]
                dw $5800 ; 042 [2A]
                dw $5800 ; 043 [2B]
                dw $5800 ; 044 [2C]
                dw $5800 ; 045 [2D]
                dw $5802 ; 046 [2E]
                dw $5800 ; 047 [2F]
                dw $5800 ; 048 [30]
                dw $5800 ; 049 [31]
                dw $5800 ; 050 [32]
                dw $5800 ; 051 [33]
                dw $5800 ; 052 [34]
                dw $5800 ; 053 [35]
                dw $5800 ; 054 [36]
                dw $5800 ; 055 [37]
                dw $5800 ; 056 [38]
                dw $5800 ; 057 [39]
                dw $5800 ; 058 [3A]
                dw $5800 ; 059 [3B]
                dw $4800 ; 060 [3C]
                dw $5800 ; 061 [3D]
                dw $5800 ; 062 [3E]
                dw $5800 ; 063 [3F]
                dw $5800 ; 064 [40]
                dw $5800 ; 065 [41]
                dw $5800 ; 066 [42]
                dw $5800 ; 067 [43]
                dw $5800 ; 068 [44]
                dw $5800 ; 069 [45]
                dw $5800 ; 070 [46]
                dw $4800 ; 071 [47]
                dw $5200 ; 072 [48]
                dw $4800 ; 073 [49]
                dw $4800 ; 074 [4A]
                dw $4800 ; 075 [4B]
                dw $4800 ; 076 [4C]
                dw $4800 ; 077 [4D]
                dw $4800 ; 078 [4E]
                dw $4800 ; 079 [4F]
                dw $4800 ; 080 [50]
                dw $4800 ; 081 [51]
                dw $5800 ; 082 [52]
                dw $4800 ; 083 [53]
                dw $4F80 ; 084 [54]
                dw $4800 ; 085 [55]
                dw $4800 ; 086 [56]
                dw $4800 ; 087 [57]
                dw $4800 ; 088 [58]
                dw $4800 ; 089 [59]
                dw $4800 ; 090 [5A]
                dw $4800 ; 091 [5B]
                dw $5800 ; 092 [5C]
                dw $5800 ; 093 [5D]
                dw $4800 ; 094 [5E]
                dw $4800 ; 095 [5F]
                dw $4800 ; 096 [60]
                dw $4800 ; 097 [61]
                dw $4800 ; 098 [62]
                dw $4800 ; 099 [63]
                dw $4800 ; 100 [64]
                dw $4800 ; 101 [65]
                dw $4800 ; 102 [66]
                dw $4800 ; 103 [67]
                dw $4800 ; 104 [68]
                dw $4800 ; 105 [69]
                dw $5800 ; 106 [6A]
                dw $5800 ; 107 [6B]
                dw $5800 ; 108 [6C]
                dw $5100 ; 109 [6D]
                dw $5400 ; 110 [6E]
                dw $4800 ; 111 [6F]
                dw $6000 ; 112 [70]
                dw $6400 ; 113 [71]
                dw $5800 ; 114 [72]
                dw $44FC ; 115 [73] (in-engine, eventually overwritten by CoilSnake)
                dw $5C00 ; 116 [74]
                dw $5800 ; 117 [75]
                dw $5C00 ; 118 [76]
                dw $5800 ; 119 [77]
                dw $4800 ; 120 [78]
                dw $6200 ; 121 [79]
                dw $5800 ; 122 [7A]
                dw $455D ; 123 [7B] (in-engine, eventually overwritten by CoilSnake)
                dw $4800 ; 124 [7C]
                dw $5800 ; 125 [7D]
                dw $4C00 ; 126 [7E]
                dw $5200 ; 127 [7F]
                dw $5800 ; 128 [80]
                dw $5800 ; 129 [81]
                dw $5000 ; 130 [82]
                dw $4800 ; 131 [83]
                dw $5800 ; 132 [84]
                dw $5800 ; 133 [85]
                dw $4800 ; 134 [86]
                dw $43FB ; 135 [87] (in-engine, eventually overwritten by CoilSnake)
                dw $6200 ; 136 [88]
                dw $5C00 ; 137 [89]
                dw $6000 ; 138 [8A]
                dw $6400 ; 139 [8B]
                dw $5800 ; 140 [8C]
                dw $4800 ; 141 [8D]
                dw $4800 ; 142 [8E]
                dw $4800 ; 143 [8F]
                dw $6000 ; 144 [90]
                dw $6000 ; 145 [91]
                dw $5000 ; 146 [92]
                dw $5800 ; 147 [93]
                dw $4800 ; 148 [94]
                dw $5000 ; 149 [95]
                dw $5800 ; 150 [96]
                dw $5800 ; 151 [97]
                dw $6200 ; 152 [98]
                dw $6000 ; 153 [99]
                dw $5800 ; 154 [9A]
                dw $4800 ; 155 [9B]
                dw $5C00 ; 156 [9C]
                dw $4800 ; 157 [9D]
                dw $6000 ; 158 [9E]
                dw $5800 ; 159 [9F]
                dw $4900 ; 160 [A0]
                dw $4AE0 ; 161 [A1]
                dw $4CC0 ; 162 [A2]
                dw $4EA0 ; 163 [A3]
                dw $5080 ; 164 [A4]
                dw $5260 ; 165 [A5]
                dw $5440 ; 166 [A6]
                dw $5620 ; 167 [A7]
                dw $4800 ; 168 [A8]
                dw $4800 ; 169 [A9]
                dw $5800 ; 170 [AA]
                dw $5800 ; 171 [AB]
                dw $4800 ; 172 [AC]
                dw $5200 ; 173 [AD]
                dw $4A3D ; 174 [AE]
                dw $4800 ; 175 [AF]
                dw $3C7B ; 176 [B0] (in-engine, eventually overwritten by CoilSnake)
                dw $6700 ; 177 [B1]
                dw $4800 ; 178 [B2]
                dw $4800 ; 179 [B3]
                dw $5000 ; 180 [B4]
                dw $5200 ; 181 [B5]
                dw $5200 ; 182 [B6]
                dw $342A ; 183 [B7] (in-engine, eventually overwritten by CoilSnake)
                dw $31FA ; 184 [B8] (in-engine, eventually overwritten by CoilSnake)
                dw $4B00 ; 185 [B9]
                dw $4800 ; 186 [BA]
                dw $5400 ; 187 [BB]
                dw $4800 ; 188 [BC]
                dw $4800 ; 189 [BD]
                dw $5300 ; 190 [BE]
                dw $5200 ; 191 [BF]

; $2FC8
L_2FC8:         mov   a, #$80                   ; E8 80
L_2FCA:         mov   $04D3, a                  ; C5 D3 04
L_2FCD:         mov   a, #$09                   ; E8 09
L_2FCF:         mov   $04D2, a                  ; C5 D2 04
L_2FD2:         mov   a, #$1D                   ; E8 1D
L_2FD4:         mov   $04D1, a                  ; C5 D1 04
L_2FD7:         mov   a, #$C0                   ; E8 C0
L_2FD9:         mov   $04D4, a                  ; C5 D4 04
L_2FDC:         ret                             ; 6F

; Footer for CoilSnake to know where to put the song table
; Do NOT remove unless you know what you're doing!!
db "COILSNAKE SONG TABLE POINTER"
dw Song_Table

; New code & data can go here

; Very last thing
print "ENDS AT $", pc

CUSTOMCODE:

; New SFX for Offense Up, Defense Up and Quick Up
; Copy of SFX_3B (Sound 59) but reversed.
                dw SFX_3B_02
                db $0A
SFX_7F:         db $0D, $BE, $C8, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $07, $82, $03, $91, $9D, $A9, $B5, $C1
                db $ED, $1E
                db $C7, $BB, $AF, $A3, $97
                db $E0, $08
                db $ED, $8C
                db $BC, $BD, $BF, $C2, $C0, $C2, $C4, $C6
                db $ED, $3C
                db $BC, $BC, $BE, $C1, $C0, $C1, $C3, $C5
                db $ED, $14
                db $BC, $BD, $BF, $C2, $C0, $C2, $C4, $C6, $00

; $2210
                db $04
SFX_7F_02:      db $0D, $5A, $CE, $00 ; Instrument, volume, pan, detune
            ;**** SEQUENCE DATA ****
                db $4B, $C9, $07, $82, $03, $91, $9D, $A9, $B5, $C1
                db $ED, $14
                db $C7, $BB, $AF, $A3, $97
                db $E0, $08
                db $ED, $3C
                db $BC, $BD, $BF, $C2, $C0, $C2, $C4, $C6
                db $ED, $1E
                db $BC, $BC, $BE, $C1, $C0, $C1, $C3, $C5
                db $ED, $14
                db $BC, $BD, $BF, $C2, $C0, $C2, $C4, $C6, $00
