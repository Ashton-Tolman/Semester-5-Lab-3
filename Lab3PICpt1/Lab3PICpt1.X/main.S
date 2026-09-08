// Ashton Tolman
// RCET3373
// Lab3PICpt1
// https://github.com/Ashton-Tolman/Semester-5-Lab-3.git
// linker code:-Wl,-presetVect=0000h,-pcode=0008h

; PIC16F883 Configuration Bit Settings

; Assembly source line config statements

; CONFIG1
  CONFIG  FOSC = XT             ; Oscillator Selection bits (XT oscillator: Crystal/resonator on RA6/OSC2/CLKOUT and RA7/OSC1/CLKIN)
  CONFIG  WDTE = OFF            ; Watchdog Timer Enable bit (WDT disabled and can be enabled by SWDTEN bit of the WDTCON register)
  CONFIG  PWRTE = OFF           ; Power-up Timer Enable bit (PWRT disabled)
  CONFIG  MCLRE = ON            ; RE3/MCLR pin function select bit (RE3/MCLR pin function is MCLR)
  CONFIG  CP = OFF              ; Code Protection bit (Program memory code protection is disabled)
  CONFIG  CPD = OFF             ; Data Code Protection bit (Data memory code protection is disabled)
  CONFIG  BOREN = OFF           ; Brown Out Reset Selection bits (BOR disabled)
  CONFIG  IESO = OFF            ; Internal External Switchover bit (Internal/External Switchover mode is disabled)
  CONFIG  FCMEN = OFF           ; Fail-Safe Clock Monitor Enabled bit (Fail-Safe Clock Monitor is disabled)
  CONFIG  LVP = OFF             ; Low Voltage Programming Enable bit (RB3 pin has digital I/O, HV on MCLR must be used for programming)

; CONFIG2
  CONFIG  BOR4V = BOR40V        ; Brown-out Reset Selection bit (Brown-out Reset set to 4.0V)
  CONFIG  WRT = OFF             ; Flash Program Memory Self Write Enable bits (Write protection off)

// config statements should precede project file includes.
#include <xc.inc>

; Reset Vector at 000h. Execution starts here after reset 
PSECT resetVect,class=CODE,delta=2
ResetVector:
    goto Setup
    
    
; Main code section starts at 0008h. User code goes here
PSECT code,class=CODE,delta=2

Setup:
    ; add device setup here
    BSF  0x03, 06    ;
    BSF  0x03, 05    ; Set bank 3 active
    CLRF 0x189	    ; ANSELH analog/digital select portB pins as digital
    
    BSF  0x03, 06    ;
    BCF  0x03, 5    ; Set bank 2 active
    BSF  0x09, 1    ; Turn T1G-not function off
    BCF  0x0B, 0    ; Turn INTCON RBIF flag off, other bits are default off
    
    BCF  0x03, 06    ;
    BSF  0x03, 05    ; Set bank 1 active 
    CLRF 0x06	    ; TristB sets all portB pins as outputs
		    
    BCF  0x03, 06    ;
    BCF  0x03, 05    ; Set bank 0 active
    CLRF 0x07	    ; CCP1CON capture/compare/PWM off
    
		    ; OPTION_REG RBPU-not is default high meaning disabled
		    ; WPUB weak pull ups default disabled
		    ; IOCB portB interrupt-on-change disabled default
    goto Main
    
Main:
    // main goes here
    INCF 0x06, 1    ; Bank 0 is already active, increment portB on a loop
    goto Main
End