# Creates an MLB file for Mesen's debugger to use based on summary.txt
# SupremeKirb

import argparse

# Default symbols for the SNES hardware
SNES_MLB_BASE = """\
SnesRegister:2100:INIDISP:Screen Display Register
SnesRegister:2101:OBSEL:Object Size and Character Size Register
SnesRegister:2102:OAMADDL:OAM Address Registers (Low)
SnesRegister:2103:OAMADDH:OAM Address Registers (High)
SnesRegister:2104:OAMDATA:OAM Data Write Register
SnesRegister:2105:BGMODE:BG Mode and Character Size Register
SnesRegister:2106:MOSAIC:Mosaic Register
SnesRegister:2107:BG1SC:BG Tilemap Address Registers (BG1)
SnesRegister:2108:BG2SC:BG Tilemap Address Registers (BG2)
SnesRegister:2109:BG3SC:BG Tilemap Address Registers (BG3)
SnesRegister:210A:BG4SC:BG Tilemap Address Registers (BG4)
SnesRegister:210B:BG12NBA:BG Character Address Registers (BG1&2)
SnesRegister:210C:BG34NBA:BG Character Address Registers (BG3&4)
SnesRegister:210D:BG1HOFS:BG Scroll Registers (BG1)
SnesRegister:210E:BG1VOFS:BG Scroll Registers (BG1)
SnesRegister:210F:BG2HOFS:BG Scroll Registers (BG2)
SnesRegister:2110:BG2VOFS:BG Scroll Registers (BG2)
SnesRegister:2111:BG3HOFS:BG Scroll Registers (BG3)
SnesRegister:2112:BG3VOFS:BG Scroll Registers (BG3)
SnesRegister:2113:BG4HOFS:BG Scroll Registers (BG4)
SnesRegister:2114:BG4VOFS:BG Scroll Registers (BG4)
SnesRegister:2115:VMAIN:Video Port Control Register
SnesRegister:2116:VMADDL:VRAM Address Registers (Low)
SnesRegister:2117:VMADDH:VRAM Address Registers (High)
SnesRegister:2118:VMDATAL:VRAM Data Write Registers (Low)
SnesRegister:2119:VMDATAH:VRAM Data Write Registers (High)
SnesRegister:211A:M7SEL:Mode 7 Settings Register
SnesRegister:211B:M7A:Mode 7 Matrix Registers
SnesRegister:211C:M7B:Mode 7 Matrix Registers
SnesRegister:211D:M7C:Mode 7 Matrix Registers
SnesRegister:211E:M7D:Mode 7 Matrix Registers
SnesRegister:211F:M7X:Mode 7 Matrix Registers
SnesRegister:2120:M7Y:Mode 7 Matrix Registers
SnesRegister:2121:CGADD:CGRAM Address Register
SnesRegister:2122:CGDATA:CGRAM Data Write Register
SnesRegister:2123:W12SEL:Window Mask Settings Registers
SnesRegister:2124:W34SEL:Window Mask Settings Registers
SnesRegister:2125:WOBJSEL:Window Mask Settings Registers
SnesRegister:2126:WH0:Window Position Registers (WH0)
SnesRegister:2127:WH1:Window Position Registers (WH1)
SnesRegister:2128:WH2:Window Position Registers (WH2)
SnesRegister:2129:WH3:Window Position Registers (WH3)
SnesRegister:212A:WBGLOG:Window Mask Logic registers (BG)
SnesRegister:212B:WOBJLOG:Window Mask Logic registers (OBJ)
SnesRegister:212C:TM:Screen Destination Registers
SnesRegister:212D:TS:Screen Destination Registers
SnesRegister:212E:TMW:Window Mask Destination Registers
SnesRegister:212F:TSW:Window Mask Destination Registers
SnesRegister:2130:CGWSEL:Color Math Registers
SnesRegister:2131:CGADSUB:Color Math Registers
SnesRegister:2132:COLDATA:Color Math Registers
SnesRegister:2133:SETINI:Screen Mode Select Register
SnesRegister:2134:MPYL:Multiplication Result Registers
SnesRegister:2135:MPYM:Multiplication Result Registers
SnesRegister:2136:MPYH:Multiplication Result Registers
SnesRegister:2137:SLHV:Software Latch Register
SnesRegister:2138:OAMDATAREAD:OAM Data Read Register
SnesRegister:2139:VMDATALREAD:VRAM Data Read Register (Low)
SnesRegister:213A:VMDATAHREAD:VRAM Data Read Register (High)
SnesRegister:213B:CGDATAREAD:CGRAM Data Read Register
SnesRegister:213C:OPHCT:Scanline Location Registers (Horizontal)
SnesRegister:213D:OPVCT:Scanline Location Registers (Vertical)
SnesRegister:213E:STAT77:PPU Status Register
SnesRegister:213F:STAT78:PPU Status Register
SnesRegister:2140:APUIO0:APU IO Registers
SnesRegister:2141:APUIO1:APU IO Registers
SnesRegister:2142:APUIO2:APU IO Registers
SnesRegister:2143:APUIO3:APU IO Registers
SnesRegister:2180:WMDATA:WRAM Data Register
SnesRegister:2181:WMADDL:WRAM Address Registers
SnesRegister:2182:WMADDM:WRAM Address Registers
SnesRegister:2183:WMADDH:WRAM Address Registers
SnesRegister:4016:JOYSER0:Old Style Joypad Registers
SnesRegister:4017:JOYSER1:Old Style Joypad Registers
SnesRegister:4200:NMITIMEN:Interrupt Enable Register
SnesRegister:4201:WRIO:IO Port Write Register
SnesRegister:4202:WRMPYA:Multiplicand Registers
SnesRegister:4203:WRMPYB:Multiplicand Registers
SnesRegister:4204:WRDIVL:Divisor & Dividend Registers
SnesRegister:4205:WRDIVH:Divisor & Dividend Registers
SnesRegister:4206:WRDIVB:Divisor & Dividend Registers
SnesRegister:4207:HTIMEL:IRQ Timer Registers (Horizontal - Low)
SnesRegister:4208:HTIMEH:IRQ Timer Registers (Horizontal - High)
SnesRegister:4209:VTIMEL:IRQ Timer Registers (Vertical - Low)
SnesRegister:420A:VTIMEH:IRQ Timer Registers (Vertical - High)
SnesRegister:420B:MDMAEN:DMA Enable Register
SnesRegister:420C:HDMAEN:HDMA Enable Register
SnesRegister:420D:MEMSEL:ROM Speed Register
SnesRegister:4210:RDNMI:Interrupt Flag Registers
SnesRegister:4211:TIMEUP:Interrupt Flag Registers
SnesRegister:4212:HVBJOY:PPU Status Register
SnesRegister:4213:RDIO:IO Port Read Register
SnesRegister:4214:RDDIVL:Multiplication Or Divide Result Registers (Low)
SnesRegister:4215:RDDIVH:Multiplication Or Divide Result Registers (High)
SnesRegister:4216:RDMPYL:Multiplication Or Divide Result Registers (Low)
SnesRegister:4217:RDMPYH:Multiplication Or Divide Result Registers (High)
SnesRegister:4218:JOY1L:Controller Port Data Registers (Pad 1 - Low)
SnesRegister:4219:JOY1H:Controller Port Data Registers (Pad 1 - High)
SnesRegister:421A:JOY2L:Controller Port Data Registers (Pad 2 - Low)
SnesRegister:421B:JOY2H:Controller Port Data Registers (Pad 2 - High)
SnesRegister:421C:JOY3L:Controller Port Data Registers (Pad 3 - Low)
SnesRegister:421D:JOY3H:Controller Port Data Registers (Pad 3 - High)
SnesRegister:421E:JOY4L:Controller Port Data Registers (Pad 4 - Low)
SnesRegister:421F:JOY4H:Controller Port Data Registers (Pad 4 - High)
SnesRegister:4300:DMAP0:(H)DMA Control
SnesRegister:4301:BBAD0:(H)DMA B-Bus Address
SnesRegister:4302:A1T0L:DMA A-Bus Address / HDMA Table Address (Low)
SnesRegister:4303:A1T0H:DMA A-Bus Address / HDMA Table Address (High)
SnesRegister:4304:A1B0:DMA A-Bus Address / HDMA Table Address (Bank)
SnesRegister:4305:DAS0L:DMA Size / HDMA Indirect Address (Low)
SnesRegister:4306:DAS0H:DMA Size / HDMA Indirect Address (High)
SnesRegister:4307:DAS0B:HDMA Indirect Address (Bank)
SnesRegister:4308:A2A0L:HDMA Mid Frame Table Address (Low)
SnesRegister:4309:A2A0H:HDMA Mid Frame Table Address (High)
SnesRegister:430A:NTLR0:HDMA Line Counter
SnesRegister:4310:DMAP1:(H)DMA Control
SnesRegister:4311:BBAD1:(H)DMA B-Bus Address
SnesRegister:4312:A1T1L:DMA A-Bus Address / HDMA Table Address (Low)
SnesRegister:4313:A1T1H:DMA A-Bus Address / HDMA Table Address (High)
SnesRegister:4314:A1B1:DMA A-Bus Address / HDMA Table Address (Bank)
SnesRegister:4315:DAS1L:DMA Size / HDMA Indirect Address (Low)
SnesRegister:4316:DAS1H:DMA Size / HDMA Indirect Address (High)
SnesRegister:4317:DAS1B:HDMA Indirect Address (Bank)
SnesRegister:4318:A2A1L:HDMA Mid Frame Table Address (Low)
SnesRegister:4319:A2A1H:HDMA Mid Frame Table Address (High)
SnesRegister:431A:NTLR1:HDMA Line Counter
SnesRegister:4320:DMAP2:(H)DMA Control
SnesRegister:4321:BBAD2:(H)DMA B-Bus Address
SnesRegister:4322:A1T2L:DMA A-Bus Address / HDMA Table Address (Low)
SnesRegister:4323:A1T2H:DMA A-Bus Address / HDMA Table Address (High)
SnesRegister:4324:A1B2:DMA A-Bus Address / HDMA Table Address (Bank)
SnesRegister:4325:DAS2L:DMA Size / HDMA Indirect Address (Low)
SnesRegister:4326:DAS2H:DMA Size / HDMA Indirect Address (High)
SnesRegister:4327:DAS2B:HDMA Indirect Address (Bank)
SnesRegister:4328:A2A2L:HDMA Mid Frame Table Address (Low)
SnesRegister:4329:A2A2H:HDMA Mid Frame Table Address (High)
SnesRegister:432A:NTLR2:HDMA Line Counter
SnesRegister:4330:DMAP3:(H)DMA Control
SnesRegister:4331:BBAD3:(H)DMA B-Bus Address
SnesRegister:4332:A1T3L:DMA A-Bus Address / HDMA Table Address (Low)
SnesRegister:4333:A1T3H:DMA A-Bus Address / HDMA Table Address (High)
SnesRegister:4334:A1B3:DMA A-Bus Address / HDMA Table Address (Bank)
SnesRegister:4335:DAS3L:DMA Size / HDMA Indirect Address (Low)
SnesRegister:4336:DAS3H:DMA Size / HDMA Indirect Address (High)
SnesRegister:4337:DAS3B:HDMA Indirect Address (Bank)
SnesRegister:4338:A2A3L:HDMA Mid Frame Table Address (Low)
SnesRegister:4339:A2A3H:HDMA Mid Frame Table Address (High)
SnesRegister:433A:NTLR3:HDMA Line Counter
SnesRegister:4340:DMAP4:(H)DMA Control
SnesRegister:4341:BBAD4:(H)DMA B-Bus Address
SnesRegister:4342:A1T4L:DMA A-Bus Address / HDMA Table Address (Low)
SnesRegister:4343:A1T4H:DMA A-Bus Address / HDMA Table Address (High)
SnesRegister:4344:A1B4:DMA A-Bus Address / HDMA Table Address (Bank)
SnesRegister:4345:DAS4L:DMA Size / HDMA Indirect Address (Low)
SnesRegister:4346:DAS4H:DMA Size / HDMA Indirect Address (High)
SnesRegister:4347:DAS4B:HDMA Indirect Address (Bank)
SnesRegister:4348:A2A4L:HDMA Mid Frame Table Address (Low)
SnesRegister:4349:A2A4H:HDMA Mid Frame Table Address (High)
SnesRegister:434A:NTLR4:HDMA Line Counter
SnesRegister:4350:DMAP5:(H)DMA Control
SnesRegister:4351:BBAD5:(H)DMA B-Bus Address
SnesRegister:4352:A1T5L:DMA A-Bus Address / HDMA Table Address (Low)
SnesRegister:4353:A1T5H:DMA A-Bus Address / HDMA Table Address (High)
SnesRegister:4354:A1B5:DMA A-Bus Address / HDMA Table Address (Bank)
SnesRegister:4355:DAS5L:DMA Size / HDMA Indirect Address (Low)
SnesRegister:4356:DAS5H:DMA Size / HDMA Indirect Address (High)
SnesRegister:4357:DAS5B:HDMA Indirect Address (Bank)
SnesRegister:4358:A2A5L:HDMA Mid Frame Table Address (Low)
SnesRegister:4359:A2A5H:HDMA Mid Frame Table Address (High)
SnesRegister:435A:NTLR5:HDMA Line Counter
SnesRegister:4360:DMAP6:(H)DMA Control
SnesRegister:4361:BBAD6:(H)DMA B-Bus Address
SnesRegister:4362:A1T6L:DMA A-Bus Address / HDMA Table Address (Low)
SnesRegister:4363:A1T6H:DMA A-Bus Address / HDMA Table Address (High)
SnesRegister:4364:A1B6:DMA A-Bus Address / HDMA Table Address (Bank)
SnesRegister:4365:DAS6L:DMA Size / HDMA Indirect Address (Low)
SnesRegister:4366:DAS6H:DMA Size / HDMA Indirect Address (High)
SnesRegister:4367:DAS6B:HDMA Indirect Address (Bank)
SnesRegister:4368:A2A6L:HDMA Mid Frame Table Address (Low)
SnesRegister:4369:A2A6H:HDMA Mid Frame Table Address (High)
SnesRegister:436A:NTLR6:HDMA Line Counter
SnesRegister:4370:DMAP7:(H)DMA Control
SnesRegister:4371:BBAD7:(H)DMA B-Bus Address
SnesRegister:4372:A1T7L:DMA A-Bus Address / HDMA Table Address (Low)
SnesRegister:4373:A1T7H:DMA A-Bus Address / HDMA Table Address (High)
SnesRegister:4374:A1B7:DMA A-Bus Address / HDMA Table Address (Bank)
SnesRegister:4375:DAS7L:DMA Size / HDMA Indirect Address (Low)
SnesRegister:4376:DAS7H:DMA Size / HDMA Indirect Address (High)
SnesRegister:4377:DAS7B:HDMA Indirect Address (Bank)
SnesRegister:4378:A2A7L:HDMA Mid Frame Table Address (Low)
SnesRegister:4379:A2A7H:HDMA Mid Frame Table Address (High)
SnesRegister:437A:NTLR7:HDMA Line Counter
SpcRam:00F0:TEST:Testing functions
SpcRam:00F1:CONTROL:I/O and Timer Control
SpcRam:00F2:DSPADDR:DSP Address
SpcRam:00F3:DSPDATA:DSP Data
SpcRam:00F4:CPUIO0:CPU I/O 0
SpcRam:00F5:CPUIO1:CPU I/O 1
SpcRam:00F6:CPUIO2:CPU I/O 2
SpcRam:00F7:CPUIO3:CPU I/O 3
SpcRam:00F8:RAMREG1:Memory Register 1
SpcRam:00F9:RAMREG2:Memory Register 2
SpcRam:00FA:T0TARGET:Timer 0 scaling target
SpcRam:00FB:T1TARGET:Timer 1 scaling target
SpcRam:00FC:T2TARGET:Timer 2 scaling target
SpcRam:00FD:T0OUT:Timer 0 output
SpcRam:00FE:T1OUT:Timer 1 output
SpcRam:00FF:T2OUT:Timer 2 output
"""

# opens and closes areas that contain only label data
# (also used at the end of the compilation stats)
MAGIC_LABEL_ZONE = "-----------------------------------------------------------------\n"

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("summary")
    parser.add_argument("output")
    args = parser.parse_args()
    
    labels = {}
    
    with open(args.summary) as summary:
        i = summary.readline()
        while i:
            if i == MAGIC_LABEL_ZONE:
                i = summary.readline()
                while i != MAGIC_LABEL_ZONE and i != "\n":
                    clean = i.replace(" ", "").replace("\n", "")
                    name = clean.split("$")[0]
                    addr = clean.split("$")[1].strip()
                    if len(addr) == 6:
                        labels[name] = int(addr, 16)-0xC00000
                    i = summary.readline()
            i = summary.readline()

    with open(args.output, "w") as output:
        for name, addr in labels.items():
            output.write(f"SnesPrgRom:{hex(addr)[2:].upper()}:{name}\n")
        output.write(SNES_MLB_BASE)
    
    print(f"Created {len(labels)} debug symbols at {args.output}")