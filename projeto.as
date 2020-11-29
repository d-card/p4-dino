LEN             EQU     80
MAX_ALT         EQU     4
STACKBASE       EQU     4000h
; timer
TIMER_CONTROL   EQU     FFF7h
TIMER_COUNTER   EQU     FFF6h
TIMER_SETSTART  EQU     1
TIMER_SETSTOP   EQU     0
TIMER_SPEED     EQU     3
; interruptions
INT_MASK        EQU     FFFAh
INT_MASK_VAL    EQU     8009h ; 1000 0000 0000 1001 b
; terminal
TERM_WRITE      EQU     FFFEh
TERM_CURSOR     EQU     FFFCh
                ORIG    0000h
VECTOR          TAB     LEN
SEED            WORD    5
TIMER_TICK      WORD    0
START           WORD    0
DINO_HEIGHT     WORD    0
JUMPING         WORD    0
TerminalStr     STR     0,1,600h,'                                                        Press 0 to start',0,1,800h,'                                                        Press ▲ to jump',0,1,d00h,'                                  Dino Game',0,1,1d00h,'▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓',0,0
                
                

MAIN:           MVI     R6, STACKBASE
                
                ; CONFIGURE TIMER ROUNTINES
                ; interrupt mask
                MVI     R1,INT_MASK
                MVI     R2,INT_MASK_VAL
                STOR    M[R1],R2
                ; enable interruptions
                ENI

                MVI     R1, TERM_WRITE
                MVI     R2, TERM_CURSOR
                MVI     R4, TerminalStr

TerminalLoop:   LOAD    R5, M[R4]
                INC     R4
                CMP     R5, R0
                BR.Z    .Control
                STOR    M[R1], R5
                BR      TerminalLoop

.Control:       LOAD    R5, M[R4]
                INC     R4
                DEC     R5
                BR.Z    .Position
                DEC     R5
                BR      .CHECKSTART

.Position:      LOAD    R5, M[R4]
                INC     R4
                STOR    M[R2], R5
                BR      TerminalLoop
.CHECKSTART:    MVI     R1, START
                LOAD    R1, M[R1]
                CMP     R1, R0
                BR.Z .CHECKSTART

                ; START TIMER
                MVI     R2,TIMER_SPEED
                MVI     R1,TIMER_COUNTER
                STOR    M[R1],R2          ; set timer to count 10x100ms
                MVI     R1,TIMER_TICK
                STOR    M[R1],R0          ; clear all timer ticks
                MVI     R1,TIMER_CONTROL
                MVI     R2,TIMER_SETSTART
                STOR    M[R1],R2          ; start timer
                
                MVI     R5,TIMER_TICK
.LOOP:          LOAD    R1,M[R5]
                CMP     R1,R0
                BR.NZ   .UPDATE
                BR      .LOOP
.UPDATE:        DSI
                MVI     R2, TIMER_TICK     
                MVI     R1, 0
                STOR    M[R2], R1
                JAL     ATUALIZAJOGO
                JAL     ATUALIZACATOS
                JAL     PRINT_DINO
                MVI     R2, JUMPING
                LOAD    R2, M[R2]
                CMP     R2, R0
                JAL.NZ  SALTAR
                ENI
                BR      .LOOP

                
 SALTAR:        MVI     R2, JUMPING
                LOAD    R2, M[R2]
                CMP     R2, R0
                BR.N    .DOWN   
                MVI     R3, 5
                MVI     R1, DINO_HEIGHT
                LOAD    R2, M[R1]
                INC     R2
                STOR    M[R1], R2
                CMP     R3, R2
                BR.Z    .DOWN
                JMP     R7
.DOWN:          MVI     R2, JUMPING
                MVI     R1, -1
                STOR    M[R2], R1
                MVI     R3, 0
                MVI     R1, DINO_HEIGHT
                LOAD    R2, M[R1]
                DEC     R2
                STOR    M[R1], R2
                CMP     R3, R2   
                BR.Z    .end
                JMP     R7
.end:           MVI     R2, JUMPING
                MVI     R1, 0
                STOR    M[R2], R1
                JMP     R7




                
ATUALIZAJOGO:   MVI     R1, VECTOR
                MVI     R2, LEN
                DEC 	R6
				STOR 	M[R6], R4	;PUSH R4
				DEC		R6
				STOR    M[R6], R5	;PUSH R5
                DEC		R6
				STOR    M[R6], R7	;PUSH R7
                MOV     R5, R2		;move number of required shifts to R5 
                DEC     R5			
.LOOP:          INC     R1			;.loop - shift all values in vector to the 
                LOAD    R4, M[R1]	;left one by one
                DEC     R1			
                STOR    M[R1], R4	
                INC     R1			
                DEC     R5			;decrease shift counter
                CMP     R5, R0		;check if all values have been shifted
                BR.NZ   .LOOP		;repeat if not
                JAL     GERACACTO	;create new terrain
                MVI     R1, VECTOR	
                ADD     R1, R1, R2	
                DEC     R1			;find end of vector
                STOR    M[R1], R3	;add new terrain to end of vector
                MVI     R1, VECTOR	;reset R1 for loop
                LOAD 	R7, M[R6]	 
                INC     R6          ;POP R7
                LOAD 	R5, M[R6]   
                INC 	R6          ;POP R5    
				LOAD 	R4, M[R6]	 
                INC     R6          ;POP R4
                JMP     R7
                        
GERACACTO:      DEC 	R6			
                STOR 	M[R6], R4   ;PUSH R4
				DEC		R6			
                STOR    M[R6], R5   ;PUSH R5
				MVI     R1, MAX_ALT
                MVI     R4, SEED
                LOAD    R4, M[R4]
                MVI     R5, 1
                AND     R5, R4, R5	;bit = x & 1
                SHR     R4			;x = x >> 1
                CMP     R5, R0		;if bit:
                BR.NZ   .XOR
                BR      .SKIP
                
.XOR:       	MVI     R5, b400h	;x = XOR(x, 0xb400) 
                XOR     R4, R4, R5
                
.SKIP:          MVI     R5, SEED	;save new seed value
                STOR    M[R5], R4
                MVI     R5, 62258
                CMP     R4, R5		;if x < 62258:
                BR.C    .ZERO
                MOV     R5, R1		;return (x & (altura - 1)) + 1
                DEC     R5
                AND     R3, R4, R5
                INC     R3          
                BR      .RETURN
                
.ZERO:          MOV     R3, R0		;return 0       
.RETURN:        LOAD 	R5, M[R6]	
                INC 	R6          ;POP R5     
                LOAD 	R4, M[R6]      
                INC     R6          ;POP R4
                JMP     R7

ATUALIZACATOS:  DEC     R6
                STOR    M[R6], R1
                DEC     R6
                STOR    M[R6], R2
                DEC     R6
                STOR    M[R6], R3
                DEC     R6
                STOR    M[R6], R4
                DEC     R6
                STOR    M[R6], R5


                MVI     R1, TERM_CURSOR
                MVI     R4, 1900h
                STOR    M[R1], R4

                MVI     R1, VECTOR
                MVI     R4, TERM_WRITE


                MVI     R4, 5

BIGLOOP:        DEC     R4
                CMP     R4, R0
                BR.Z    RETURN2
                MVI     R1, VECTOR
                MVI     R3, LEN


LOOP:           CMP     R3, R0
                BR.Z    BIGLOOP
                DEC     R3
                LOAD    R2, M[R1]
                INC     R1
                DEC     R6
                STOR    M[R6], R4
                CMP     R4, R2
                BR.Z    ESCREVER
                BR.N    ESCREVER

NADA:           MVI     R4, TERM_WRITE
                MVI     R5, ' '
                STOR    M[R4], R5
                LOAD    R4, M[R6]
                INC     R6
                BR      LOOP

ESCREVER:       MVI     R4, TERM_WRITE
                MVI     R5, '╬'
                STOR    M[R4], R5
                LOAD    R4, M[R6]
                INC     R6
                BR      LOOP


RETURN2:

                LOAD    R5, M[R6]
                INC     R6
                LOAD    R4, M[R6]
                INC     R6
                LOAD    R3, M[R6]
                INC     R6
                LOAD    R2, M[R6]
                INC     R6
                LOAD    R1, M[R6]
                INC     R6

                JMP     R7

PRINT_DINO:     DEC     R6
                STOR    M[R6], R5
                DEC     R6
                STOR    M[R6], R4
                MVI     R1, TERM_WRITE
                MVI     R2, TERM_CURSOR
                MVI     R4, TerminalStr
                MVI     R5, DINO_HEIGHT
                LOAD    R5, M[R5]
                CMP     R5, R0
                BR.NZ   .salto
                MVI     R5, 1C04h
                STOR    M[R2], R5
                MVI     R3, '┴'
                STOR    M[R1], R3
                BR      .skip
.salto:         MVI     R3, 1
                CMP     R5, R3
                BR.Z    .alt1
                MVI     R3, 2
                CMP     R5, R3
                BR.Z    .alt2
                MVI     R3, 3
                CMP     R5, R3
                BR.Z    .alt3
                MVI     R3, 4
                CMP     R5, R3
                BR.Z    .alt4
                MVI     R3, 5
                CMP     R5, R3
                BR.Z    .alt5
.alt1:          MVI     R5, 1B04h
                STOR    M[R2], R5
                MVI     R3, '┴'
                STOR    M[R1], R3
                BR      .skip
.alt2:          MVI     R5, 1A04h
                STOR    M[R2], R5
                MVI     R3, '┴'
                STOR    M[R1], R3
                BR      .skip
.alt3:          MVI     R5, 1904h
                STOR    M[R2], R5
                MVI     R3, '┴'
                STOR    M[R1], R3
                BR      .skip
.alt4:          MVI     R5, 1804h
                STOR    M[R2], R5
                MVI     R3, '┴'
                STOR    M[R1], R3
                BR      .skip
.alt5:          MVI     R5, 1704h
                STOR    M[R2], R5
                MVI     R3, '┴'
                STOR    M[R1], R3
.skip:          MVI     R3, 100h
                SUB     R5, R5, R3
                STOR    M[R2], R5
                MVI     R3, '╞'
                STOR    M[R1], R3
                MVI     R3, 100h
                SUB     R5, R5, R3
                STOR    M[R2], R5
                MVI     R3, '○'
                STOR    M[R1], R3
                MVI     R3, 100h
                SUB     R5, R5, R3
                STOR    M[R2], R5
                MVI     R3, ' '
                STOR    M[R1], R3
                LOAD    R4, M[R6]
                INC     R6
                LOAD    R5, M[R6]
                INC     R6
                JMP R7



AUX_TIMER_ISR:  ; SAVE CONTEXT
                DEC     R6
                STOR    M[R6],R1
                DEC     R6
                STOR    M[R6],R2
                ; RESTART TIMER
                MVI     R2,TIMER_SPEED
                MVI     R1,TIMER_COUNTER
                STOR    M[R1],R2          ; set timer to count value
                MVI     R1,TIMER_CONTROL
                MVI     R2,TIMER_SETSTART
                STOR    M[R1],R2          ; start timer
                ; INC TIMER FLAG
                MVI     R2,TIMER_TICK
                LOAD    R1,M[R2]
                INC     R1
                STOR    M[R2],R1
                ; RESTORE CONTEXT
                LOAD    R2,M[R6]
                INC     R6
                LOAD    R1,M[R6]
                INC     R6
                JMP     R7                
                
                
                ORIG    7FF0h
TIMER_ISR:      ; SAVE CONTEXT
                DEC     R6
                STOR    M[R6],R7
                ; CALL AUXILIARY FUNCTION
                JAL     AUX_TIMER_ISR
                ; RESTORE CONTEXT
                LOAD    R7,M[R6]
                INC     R6
                RTI

                ORIG    7F00h
KEYZERO:        ; SAVE CONTEXT
                DEC     R6
                STOR    M[R6],R1
                DEC     R6
                STOR    M[R6],R2
                MVI     R1, 1
                MVI     R2, START
                STOR    M[R2], R1
                LOAD    R2,M[R6]
                INC     R6
                LOAD    R1,M[R6]
                INC     R6
                RTI

                ORIG    7F30h
KEYUP:          ; SAVE CONTEXT
                DEC     R6
                STOR    M[R6],R1
                DEC     R6
                STOR    M[R6],R2
                MVI     R1,1
                MVI     R2, JUMPING
                STOR    M[R2], R1
                ; RESTORE CONTEXT
                LOAD    R2,M[R6]
                INC     R6
                LOAD    R1,M[R6]
                INC     R6
                RTI