.org 0x0
BRA BEGIN

.org 0x10
ADD r6,r0,#69
RETI

.org 0x80
ADD r7,r0,#69
RETI


.org 0x100
LDI r0, #12	//Rise Configuration
LDI r1, #10	//Fall Configuration
LDI r4, #15
ST IR1, r0
ST IR8, r1
ST IR_ENABLE, r4
NOP
NOP
NOP
NOP
NOP
LABEL:
ADD r0, r1, #10
BRA LABEL


IR1 .equ 0x30001
IR8 .equ 0x30008
IR_ENABLE .equ 0x3001f
BEGIN .equ 0x100
