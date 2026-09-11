// Ashton Tolman
// RCET3373
// Lab3PICpt4
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
    BSF  0x03, 6    ;
    BSF  0x03, 5    ; Set bank 3 active
    CLRF 0x89	    ; ANSELH set low to make portB digital
    
    BSF  0x03, 6    ;
    BCF  0x03, 5    ; Set bank 2 active
    BSF  0x09, 1    ; Turn T1G-not function off
    
    BCF  0x03, 6    ;
    BSF  0x03, 5    ; Set bank 1 active 
    CLRF 0x87	    ; TristC sets all portC pins as outputs
    CLRF 0x95	    ; Set WPUB low to turn pull ups off
    
    BCF  0x03, 6    ;
    BCF  0x03, 5    ; Set bank 0 active
    CLRF 0x06	    ; Clear portB
    MOVLW 0x30      ; Select the character set for display 0
    MOVWF 0x07      ; Send W to PortC
		    ; OPTION_REG RBPU-not is default high meaning disabled
		    ; IOCB portB interrupt-on-change disabled default
		    ; 	
    goto Main
    
mainCount    EQU 0x20   ;use data memory address 0x20 as an 8-bit loop counter  
outCount    EQU 0x21	;use data memory address 0x21 as an 8-bit loop counter  
inCount    EQU 0x22	;use data memory address 0x22 as an 8-bit loop counter  
    
Main:
    MOVLW 0x01		;1 TCY Set the bit to be toggled by XOR
    XORWF 0x06,1	;1 TCY Toggle RB0

    NOP
    
    MOVLW 0x05		;1 TCY set the lower bits to 5. Upper bits unaffected by XOR
    XORWF 0x07,1	;1 TCY toggle between 5 & 0
    
    CALL LargeDelayLoop	;2 TCY
    
    goto Main		;2 TCY 
    
LargeDelayLoop:
    MOVLW 0x08		;1 TCY delay overhead
    MOVWF mainCount	;1 TCY delay overhead
    
MainDelay:
    MOVLW 0xF9		;1 TCY delay overhead
    MOVWF outCount	;1 TCY delay overhead
    
OutDelay:
    CALL SingleDelayLoop;2 TCY
    
    DECFSZ outCount,1	;1(2) 1TCY if not zero, 2 TCY if zero
    goto OutDelay	;2 TCY
    
    DECFSZ mainCount,1	;1(2) 1TCY if not zero, 2 TCY if zero
    goto MainDelay	;2 TCY

    RETURN		;2 TCY code not part of delay
    
SingleDelayLoop:
    MOVLW 0x51		;1 TCY delay overhead
    MOVWF inCount	;1 TCY delay overhead
    
InDelay:    
    DECFSZ inCount,1	;1(2) 1 TCY if not zero, 2 TCY if zero
    goto InDelay	;2 TCY
    
    RETURN		;2 TCY
    
End