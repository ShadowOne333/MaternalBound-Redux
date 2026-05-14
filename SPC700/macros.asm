macro END_TRACK()
    db 0
endmacro

macro TIE()
    db $C8
endmacro

macro REST()
    db $C9
endmacro

macro INSTRUMENT(instr)
    db $E0, <instr>
endmacro

macro PAN(value)
    db $E1, <value>
endmacro

macro FADE_PAN(time, target)
    db $E2, <time>, <target>
endmacro

macro VIBRATO(delay, freq, amp)
    db $E3, <delay>, <freq>, <amp>
endmacro

macro VIBRATO_OFF()
    db $E4
endmacro

macro VOLUME(value)
    db $E5, <value>
endmacro

macro FADE_VOLUME(time, target)
    db $E6, <time>, <target>
endmacro

macro TEMPO(value)
    db $E7, <value>
endmacro

macro FADE_TEMPO(time, target)
    db $E8, <time>, <target>
endmacro

macro TRANSPOSE(value)
    db $E9, <value>
endmacro

macro CHANNEL_TRANSPOSE(value)
    db $EA, <value>
endmacro

macro TREMOLO(delay, freq, amp)
    db $EB, <delay>, <freq>, <amp>
endmacro

macro TREMOLO_OFF()
    db $EC
endmacro

macro CHANNEL_VOLUME(value)
    db $ED, <value>
endmacro

macro FADE_CHANNEL_VOLUME(time, target)
    db $EE, <time>, <target>
endmacro

macro SUBROUTINE(addr, count)
    db $EF : dw <addr> : db <count>
endmacro

macro FADE_VIBRATO(value)
    db $F0, <value>
endmacro

macro PORTAMENTO_UP(delay, time, key)
    db $F1, <delay>, <time>, <key>
endmacro

macro PORTAMENTO_DOWN(delay, time, key)
    db $F2, <delay>, <time>, <key>
endmacro

macro PORTAMENTO_OFF()
    db $F3
endmacro

macro TUNING(value)
    db $F4, <value>
endmacro

macro ECHO_VOICES(voices, voll, volr)
    db $F5, <voices>, <voll>, <volr>
endmacro

macro ECHO_OFF()
    db $F6
endmacro

macro ECHO_PARAMS(edl, efb, filter)
    db $F7, <edl>, <efb>, <filter>
endmacro

macro FADE_ECHO_VOLUME(time, targetl, targetr)
    db $F8, <time>, <targetl>, <targetr>
endmacro

macro SLIDE_NOTE(delay, time, note)
    db $F9, <delay>, <time>, <note>
endmacro

macro PERCUSSION_BASE(value)
    db $FA, <value>
endmacro
