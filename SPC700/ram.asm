; DSP REGISTERS
!DSP_VxVOLL  = $00
!DSP_VxVOLR  = $01
!DSP_VxPL    = $02
!DSP_VxPH    = $03
!DSP_VxSRCN  = $04
!DSP_VxADSR1 = $05
!DSP_VxADSR2 = $06
!DSP_VxGAIN  = $07
!DSP_VxENVX  = $08

!DSP_COEFF   = $0F

!DSP_MVOLL   = $0C
!DSP_MVOLR   = $1C

!DSP_EVOLL   = $2C
!DSP_EVOLR   = $3C

!DSP_KON     = $4C
!DSP_KOF     = $5C

!DSP_EFB     = $0D
!DSP_PMON    = $2D
!DSP_NON     = $3D
!DSP_EON     = $4D
!DSP_DIR     = $5D
!DSP_FLG     = $6C
!DSP_ESA     = $6D
!DSP_EDL     = $7D

; SPC I/O REGISTERS
TEST                  = $00F0
CONTROL               = $00F1
DSPADDR               = $00F2
DSPDATA               = $00F3
PORT0                 = $00F4
PORT1                 = $00F5
PORT2                 = $00F6
PORT3                 = $00F7
; $F8 and $F9 are regular memory
T0DIV                 = $00FA
T1DIV                 = $00FB
T2DIV                 = $00FC
T0OUT                 = $00FD
T1OUT                 = $00FE
T2OUT                 = $00FF

; VARIABLES
port0_in              = $0000
port1_in              = $0001
port2_in              = $0002
port3_in              = $0003
music_id              = $0004 ; Actually some sort of "port0_out" value
; $05~$07 UNUSED
prev_port0_in         = $0008 ; Value of "port0_in" in the previous tick
; $09~$0B UNUSED
music_init_timer      = $000C ; No idea why this exists, but sure
; $0D UNUSED
zp_0000               = $000E ; Constant 0000 for easy MOVW manipulation
; IMPORTANT: THESE TEMP BYTES MUST BE CONTIGUOUS
temp0                 = $0010
temp1                 = $0011
temp2                 = $0012
temp3                 = $0013
temp4                 = $0014
temp5                 = $0015
temp6                 = $0016
temp7                 = $0017
random_num            = $0018 ; 2 bytes
sfx_voices            = $001A ; Voices currently playing sound effects
fast_forward_flag     = $001B
; $1C~$1F UNUSED
; IMPORTANT: THESE TEMP BYTES MUST BE CONTIGUOUS (temp bytes specific to Tanaka's modifications to N-SPC)
tanaka_temp0          = $0020
tanaka_temp1          = $0021
tanaka_temp2          = $0022
tanaka_temp3          = $0023
tanaka_temp4          = $0024
tanaka_temp5          = $0025
tanaka_temp6          = $0026
tanaka_temp7          = $0027
tanaka_temp8          = $0028
tanaka_temp9          = $0029
tanaka_tempA          = $002A
tanaka_tempB          = $002B
tanaka_tempC          = $002C
tanaka_tempD          = $002D
tanaka_tempE          = $002E
tanaka_tempF          = $002F

voice_muted           = $0400
; $0410~$0430 UNUSED
mono_flag             = $0431
; $0432 UNUSED
temp_sfx_pan          = $0433
; $0434~$0437 UNUSED
mfx_fastforward_timer = $0438
mfx_volume240_timer   = $0439
mfx_volume160_timer   = $043A

sfx_adsr_changed      = $0454 ; 1 byte per port, nonzero if ADSR changed
sfx_adsr              = $0458 ; 2 bytes per port

mfx_tempo_backup      = $0493

sfx_dsp_base          = $04D5
sfx_voice_bit_NOT     = $04D6
sfx_voice_bit         = $04D7

sfx_detune            = $04DE
sfx_voice_x2          = $04DF
