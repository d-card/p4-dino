;===============================================================================
;
;       P4 Dino Game 
;
;       2020, Diogo Cardoso and Tiago Peralta
;
;       P4 version of the chrome dino game which can be played in chrome://dino
;
;===============================================================================


; I/O addresses
TERM_WRITE      EQU     FFFEh
TERM_CURSOR     EQU     FFFCh
TIMER_CONTROL   EQU     FFF7h
TIMER_COUNTER   EQU     FFF6h
DISP7_D3        EQU     FFF3h
DISP7_D2        EQU     FFF2h
DISP7_D1        EQU     FFF1h
DISP7_D0        EQU     FFF0h
DISP7_D5        EQU     FFEFh
DISP7_D4        EQU     FFEEh
; Other constants
TIMER_SETSTART  EQU     1
TIMER_SETSTOP   EQU     0
TIMER_SPEED     EQU     3
LEN             EQU     80
MAX_ALT         EQU     4
STACK_P         EQU     4000h
SEED_VAL        EQU     5   
INT_MASK        EQU     FFFAh
INT_MASK_VAL    EQU     8009h                       ; 1000 0000 0000 1001 b

;============== Data Region (starting at address 0000h) ========================

                ORIG    0000h
VECTOR          TAB     LEN                         
SEED            WORD    SEED_VAL                   
TIMER_TICK      WORD    0
START           WORD    0
TIME0           WORD    0
TIME1           WORD    0
TIME2           WORD    0
TIME3           WORD    0
TIME4           WORD    0
TIME5           WORD    0
TIME6           WORD    0
DINO_HEIGHT     WORD    0                           ; saves current dino height
JUMPING         WORD    0                           ; saves current dino state (1-jumping, going up; 0-not jumping; -1-jumping, going down)
TERMINAL_STR    STR     0,1,600h,'                                                        Press 0 to start',0,1,800h,'                                                        Press ▲ to jump',0,1,d00h,'                                  Dino Game',0,1,1d00h,'▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓',0,0
GAME_OVER       STR     0,'GAME OVER',0  
GAME_OVER_C     STR     0,'         ',0               
;============== Code Region (starting at address 0000h) ========================               

;-------------- Main Program ---------------------------------------------------

MAIN:           MVI     R6, STACK_P                 ; set stack pointer
                MVI     R1,INT_MASK                     
                MVI     R2,INT_MASK_VAL 
                STOR    M[R1],R2                    ; set iunterrupt mask
                ENI                                 ; enable interrupts

                JAL TERRAIN_SETUP

                ; Check if button 0 has been pressed
.Checkstart:    MVI     R1, START
                LOAD    R1, M[R1]
                CMP     R1, R0
                BR.Z    .Checkstart

                ;Clear 'Game over' text
                MVI     R1, TERM_CURSOR
                MVI     R2, 1322h
                MVI     R3, GAME_OVER_C
                STOR    M[R1], R2
                MVI     R1, TERM_WRITE
.Loop:          INC     R3
                LOAD    R2, M[R3]
                STOR    M[R1], R2
                CMP     R2, R0
                BR.NZ   .Loop

                ; Reset DINO_HEIGHT and JUMPING
                MVI     R1, DINO_HEIGHT
                MVI     R2, 0 
                STOR    M[R1], R2
                MVI     R1, JUMPING
                STOR    M[R1], R2
                
                ; Start timer
                MVI     R2,TIMER_SPEED
                MVI     R1,TIMER_COUNTER
                STOR    M[R1],R2                    ; set timer to count 3x100ms
                MVI     R1,TIMER_CONTROL
                MVI     R2,TIMER_SETSTART
                STOR    M[R1],R2                    ; start timer
                
                ; Wait for timer interrutps
                MVI     R5,TIMER_TICK
.Loop2:         LOAD    R1,M[R5]
                CMP     R1,R0
                BR.NZ   .Update
                BR      .Loop2

.Update:        DSI
                MVI     R2, TIMER_TICK     
                MVI     R1, 0
                STOR    M[R2], R1
                JAL     UPDATE_GAME
                JAL     PRINT_CACTUS
                JAL     PRINT_DINO
                JAL     COLISION
                MVI     R2, JUMPING
                LOAD    R2, M[R2]
                CMP     R2, R0
                JAL.NZ  JUMP
                JAL     UPDATE_DISP
                ENI
                BR      .Loop

TERRAIN_SETUP:  ; Save context
                DEC     R6
                STOR    M[R6], R5
                MVI     R1, TERM_WRITE
                MVI     R2, TERM_CURSOR
                MVI     R3, TERMINAL_STR              
.TerminalLoop:  LOAD    R5, M[R3]
                INC     R3
                CMP     R5, R0
                BR.Z    .Control
                STOR    M[R1], R5
                BR      .TerminalLoop
.Control:       LOAD    R5, M[R3]
                INC     R3
                DEC     R5
                BR.Z    .Position
                DEC     R5
                BR      .Skip
.Position:      LOAD    R5, M[R3]
                INC     R3
                STOR    M[R2], R5
                BR      .TerminalLoop
.Skip:          ; Restore context
                LOAD    R5, M[R6]
                INC     R6
                JMP     R7

                
JUMP:           ; Check if dino is going up or down
                MVI     R2, JUMPING
                LOAD    R2, M[R2]
                CMP     R2, R0
                BR.N    .Down  
                ; Increase DINO_HEIGHT each frame until it reaches 5 
                MVI     R3, 5
                MVI     R1, DINO_HEIGHT
                LOAD    R2, M[R1]
                INC     R2
                STOR    M[R1], R2
                CMP     R3, R2
                BR.Z    .Down
                JMP     R7
.Down:          ; Decrease DINO_HEIGHT each frame until it reaches 0
                MVI     R2, JUMPING
                MVI     R1, -1
                STOR    M[R2], R1
                MVI     R3, 0
                MVI     R1, DINO_HEIGHT
                LOAD    R2, M[R1]
                DEC     R2
                STOR    M[R1], R2
                CMP     R3, R2   
                BR.Z    .End
                JMP     R7
.End:           ; Reset JUMPING when jump animation ends
                MVI     R2, JUMPING
                MVI     R1, 0
                STOR    M[R2], R1
                JMP     R7

UPDATE_DISP:    DEC     R6
                STOR    M[R6], R7
                
                MVI     R1, TIME0
                LOAD    R2, M[R1]
                
                ; SHOW TIME ON DISP7_D0
                MVI     R1,9
                CMP     R2,R1
                JAL.P   REGULAR0
                MVI     R1, TIME0
                LOAD    R2, M[R1]
                MVI     R1,DISP7_D0
                STOR    M[R1],R2
                ; SHOW TIME ON DISP7_D1
                MVI     R1, TIME1
                LOAD    R2, M[R1]
                MVI     R1,9
                CMP     R2,R1
                JAL.P   REGULAR1
                MVI     R1, TIME1
                LOAD    R2, M[R1]
                MVI     R1,DISP7_D1
                STOR    M[R1],R2
                ; SHOW TIME ON DISP7_D2
                MVI     R1, TIME2
                LOAD    R2, M[R1]
                MVI     R1,9
                CMP     R2,R1
                JAL.P   REGULAR2
                MVI     R1, TIME2
                LOAD    R2, M[R1]
                MVI     R1,DISP7_D2
                STOR    M[R1],R2
                ; SHOW TIME ON DISP7_D3
                MVI     R1, TIME3
                LOAD    R2, M[R1]
                MVI     R1,9
                CMP     R2,R1
                JAL.P   REGULAR3
                MVI     R1, TIME3
                LOAD    R2, M[R1]
                MVI     R1,DISP7_D3
                STOR    M[R1],R2
                ; SHOW TIME ON DISP7_D4
                MVI     R1, TIME4
                LOAD    R2, M[R1]
                MVI     R1,9
                CMP     R2,R1
                JAL.P   REGULAR4
                MVI     R1, TIME4
                LOAD    R2, M[R1]
                MVI     R1,DISP7_D4
                STOR    M[R1],R2
                ; SHOW TIME ON DISP7_D5
                MVI     R1, TIME5
                LOAD    R2, M[R1]
                MVI     R1,9
                CMP     R2,R1
                JAL.P   REGULAR5
                MVI     R1, TIME5
                LOAD    R2, M[R1]
                MVI     R1,DISP7_D5
                STOR    M[R1],R2
                
                MVI     R1, TIME0
                LOAD    R2, M[R1]
                INC     R2
                STOR    M[R1], R2
                
                LOAD    R7, M[R6]
                INC     R6
                JMP     R7
                
REGULAR0:       MVI     R1, TIME0
                MVI     R2, 0
                STOR    M[R1], R2
                MVI     R1, TIME1
                LOAD    R2, M[R1]
                INC     R2
                STOR    M[R1], R2
                JMP     R7
                
REGULAR1:       MVI     R1, TIME1
                MVI     R2, 0
                STOR    M[R1], R2
                MVI     R1, TIME2
                LOAD    R2, M[R1]
                INC     R2
                STOR    M[R1], R2
                JMP     R7
                
REGULAR2:       MVI     R1, TIME2
                MVI     R2, 0
                STOR    M[R1], R2
                MVI     R1, TIME3
                LOAD    R2, M[R1]
                INC     R2
                STOR    M[R1], R2
                JMP     R7
                
REGULAR3:       MVI     R1, TIME2
                MVI     R2, 0
                STOR    M[R1], R2
                MVI     R1, TIME3
                LOAD    R2, M[R1]
                INC     R2
                STOR    M[R1], R2
                JMP     R7
                
REGULAR4:       MVI     R1, TIME3
                MVI     R2, 0
                STOR    M[R1], R2
                MVI     R1, TIME4
                LOAD    R2, M[R1]
                INC     R2
                STOR    M[R1], R2
                JMP     R7
                
REGULAR5:       MVI     R1, TIME4
                MVI     R2, 0
                STOR    M[R1], R2
                MVI     R1, TIME5
                LOAD    R2, M[R1]
                INC     R2
                STOR    M[R1], R2
                JMP     R7


                
UPDATE_GAME:    ; Save context
                DEC 	R6
				STOR 	M[R6], R4	
				DEC		R6
				STOR    M[R6], R5	
                DEC		R6
				STOR    M[R6], R7
                ; Move parameters to registers
                MVI     R1, VECTOR
                MVI     R2, LEN	
                MOV     R5, R2		 
                DEC     R5			
.Loop:          ; Shift all values in vector to the left one by one
                INC     R1			 
                LOAD    R4, M[R1]	
                DEC     R1			
                STOR    M[R1], R4	
                INC     R1			
                DEC     R5			
                CMP     R5, R0		
                BR.NZ   .Loop		
                ; Generate cactus/empty space
                JAL     GEN_CACTUS	
                ; Add generated value to end of vector
                MVI     R1, VECTOR	
                ADD     R1, R1, R2	
                DEC     R1			
                STOR    M[R1], R3	
                ; Restore context
                LOAD 	R7, M[R6]	 
                INC     R6          
                LOAD 	R5, M[R6]   
                INC 	R6              
				LOAD 	R4, M[R6]	 
                INC     R6          
                JMP     R7
                        
GEN_CACTUS:     ; Save context
                DEC 	R6			
                STOR 	M[R6], R4   
				DEC		R6			
                STOR    M[R6], R5   
                ; Move parameters to registers
				MVI     R1, MAX_ALT
                MVI     R4, SEED
                LOAD    R4, M[R4]
                MVI     R5, 1
                AND     R5, R4, R5	            ; bit = x & 1
                SHR     R4			            ; x = x >> 1
                CMP     R5, R0		            ; if bit:
                BR.NZ   .xor
                BR      .Skip              
.xor:       	MVI     R5, b400h	            ;x = XOR(x, 0xb400) 
                XOR     R4, R4, R5               
.Skip:          ; Save new seed value
                MVI     R5, SEED	
                STOR    M[R5], R4
                MVI     R5, 62258
                CMP     R4, R5		            ;if x < 62258:
                BR.C    .Zero
                ; Return (x & (altura - 1)) + 1
                MOV     R5, R1		            
                DEC     R5
                AND     R3, R4, R5
                INC     R3          
                BR      .End                
.Zero:          ;Return 0
                MOV     R3, R0		      
.End:           ; Restore context
                LOAD 	R5, M[R6]	
                INC 	R6              
                LOAD 	R4, M[R6]      
                INC     R6          
                JMP     R7

PRINT_CACTUS:   DEC     R6
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

.BIGLOOP:       DEC     R4
                CMP     R4, R0
                BR.Z    .RETURN2
                MVI     R1, VECTOR
                MVI     R3, LEN


.LOOP:          CMP     R3, R0
                BR.Z    .BIGLOOP
                DEC     R3
                LOAD    R2, M[R1]
                INC     R1
                DEC     R6
                STOR    M[R6], R4
                CMP     R4, R2
                BR.Z    .ESCREVER
                BR.N    .ESCREVER

.NADA:          MVI     R4, TERM_WRITE
                MVI     R5, ' '
                STOR    M[R4], R5
                LOAD    R4, M[R6]
                INC     R6
                BR      .LOOP

.ESCREVER:      MVI     R4, TERM_WRITE
                MVI     R5, '╬'
                STOR    M[R4], R5
                LOAD    R4, M[R6]
                INC     R6
                BR      .LOOP


.RETURN2:       LOAD    R5, M[R6]
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

PRINT_DINO:     ; Save context
                DEC     R6
                STOR    M[R6], R5
                DEC     R6
                STOR    M[R6], R4
                ; Move requires constants to registers
                MVI     R1, TERM_WRITE
                MVI     R2, TERM_CURSOR
                MVI     R5, DINO_HEIGHT
                ; Check if DINO_HEIGHT is != 0
                LOAD    R5, M[R5]
                CMP     R5, R0
                BR.NZ   .Jump
                ; Draw dino's feet at height 0
                MVI     R5, 1C04h
                STOR    M[R2], R5
                MVI     R3, '┴'
                STOR    M[R1], R3
                BR      .Skip
.Jump:          ; Check DINO_HEIGHT
                MVI     R3, 1
                CMP     R5, R3
                BR.Z    .Height1
                INC     R3
                CMP     R5, R3
                BR.Z    .Height2
                INC     R3
                CMP     R5, R3
                BR.Z    .Height3
                INC     R3
                CMP     R5, R3
                BR.Z    .Height4
                INC     R3
                CMP     R5, R3
                BR.Z    .Height5
                ; Draw dino's feet at the appropriate height, depending on DINO_HEIGHT
.Height1:       MVI     R5, 1B04h
                STOR    M[R2], R5
                MVI     R3, '┴'
                STOR    M[R1], R3
                BR      .Skip
.Height2:       MVI     R5, 1A04h
                STOR    M[R2], R5
                MVI     R3, '┴'
                STOR    M[R1], R3
                BR      .Skip
.Height3:          MVI     R5, 1904h
                STOR    M[R2], R5
                MVI     R3, '┴'
                STOR    M[R1], R3
                BR      .Skip
.Height4:          MVI     R5, 1804h
                STOR    M[R2], R5
                MVI     R3, '┴'
                STOR    M[R1], R3
                BR      .Skip
.Height5:          MVI     R5, 1704h
                STOR    M[R2], R5
                MVI     R3, '┴'
                STOR    M[R1], R3
.Skip:          ; Draw dino's arms and head above its feet
                MVI     R3, 100h
                SUB     R5, R5, R3
                STOR    M[R2], R5
                MVI     R4, '╞'
                STOR    M[R1], R4
                SUB     R5, R5, R3
                STOR    M[R2], R5
                MVI     R4, '○'
                STOR    M[R1], R4
                SUB     R5, R5, R3
                STOR    M[R2], R5
                ; Clear space above dino's head 
                MVI     R4, ' '
                STOR    M[R1], R4
                ; Restore context
                LOAD    R4, M[R6]
                INC     R6
                LOAD    R5, M[R6]
                INC     R6
                JMP R7
                
COLISION:       MVI     R1, VECTOR
                MVI     R2, 4
                ADD     R1, R1, R2
                LOAD    R2, M[R1]
                DEC     R2
                MVI     R1, DINO_HEIGHT
                LOAD    R1, M[R1]
                CMP     R1, R2
                BR.NP   .Game_over
                JMP     R7

.Game_over:     ; Clear terminal
                MVI     R1, TERM_CURSOR
                MVI     R2, FFFFh
                STOR    M[R1], R2
                ; Write 'Game Over on terminal'
                MVI     R3, GAME_OVER
                MVI     R2, 1322h
                STOR    M[R1], R2
                MVI     R1, TERM_WRITE
.Loop:          INC     R3
                LOAD    R2, M[R3]
                STOR    M[R1], R2
                CMP     R2, R0
                BR.NZ   .Loop
                ; Reset score holders
                MVI     R1, TIME0
                MVI     R2, 0
                STOR    M[R1], R2
                MVI     R1, TIME1
                STOR    M[R1], R2
                MVI     R1, TIME2
                STOR    M[R1], R2
                MVI     R1, TIME3
                STOR    M[R1], R2
                MVI     R1, TIME4
                STOR    M[R1], R2
                MVI     R1, TIME5
                STOR    M[R1], R2
                ;Reset START variable
                MVI     R1, START
                MVI     R2, 0
                STOR    M[R1], R2
                ;Stop timer and clear timer ticks
                MVI     R1,TIMER_TICK
                STOR    M[R1],R0          
                MVI     R1,TIMER_CONTROL
                MVI     R2,TIMER_SETSTOP
                STOR    M[R1],R2
                ;Reset VECTOR
                MVI     R1, VECTOR
                MOV     R2, R0
                MVI     R3, 80
.Loop2:         STOR    M[R1], R2
                INC     R1
                DEC     R3
                CMP     R3, R0
                BR.NZ   .Loop2 
                JMP     MAIN
                
;-------------- Interrupts -----------------------------------------------------

AUX_TIMER:      ; Save context
                DEC     R6
                STOR    M[R6],R1
                DEC     R6
                STOR    M[R6],R2
                ; Restart timer
                MVI     R2,TIMER_SPEED
                MVI     R1,TIMER_COUNTER
                STOR    M[R1],R2          ; set timer to count value
                MVI     R1,TIMER_CONTROL
                MVI     R2,TIMER_SETSTART
                STOR    M[R1],R2          ; start timer
                ; Increase timer flag
                MVI     R2,TIMER_TICK
                LOAD    R1,M[R2]
                INC     R1
                STOR    M[R2],R1
                ; Restore context
                LOAD    R2,M[R6]
                INC     R6
                LOAD    R1,M[R6]
                INC     R6
                JMP     R7                

AUX_KEYUP:      ; Save context
                DEC     R6
                STOR    M[R6],R1
                DEC     R6
                STOR    M[R6],R2
                ; Change JUMPING variable if not jumping already
                MVI     R2, JUMPING
                LOAD    R1, M[R2]
                CMP     R1, R0
                BR.NZ   .Skip
                MVI     R1,1
                STOR    M[R2], R1
.Skip:          ; Restore context
                LOAD    R2,M[R6]
                INC     R6
                LOAD    R1,M[R6]
                INC     R6
                JMP     R7

                ; TIMER
                ORIG    7FF0h
                ; Save context
                DEC     R6
                STOR    M[R6],R7
                ; Call auxiliary function
                JAL     AUX_TIMER
                ; Restore context
                LOAD    R7,M[R6]
                INC     R6
                RTI

                ; KEY ZERO 
                ORIG    7F00h
                ; Save context
                DEC     R6
                STOR    M[R6],R1
                DEC     R6
                STOR    M[R6],R2
                ; Change START variable
                MVI     R1, 1
                MVI     R2, START
                STOR    M[R2], R1
                ; Restore context
                LOAD    R2,M[R6]
                INC     R6
                LOAD    R1,M[R6]
                INC     R6
                RTI

                ; KEY UP
                ORIG    7F30h
                ; Save context
                DEC     R6
                STOR    M[R6],R7
                ; Call auxiliary function
                JAL     AUX_KEYUP
                ; Restore context
                LOAD    R7,M[R6]
                INC     R6
                RTI

;===============================================================================