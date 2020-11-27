len             EQU     80
max_alt         EQU     4
STACKBASE       EQU     4000h
; timer
TIMER_CONTROL   EQU     FFF7h
TIMER_COUNTER   EQU     FFF6h
TIMER_SETSTART  EQU     1
TIMER_SETSTOP   EQU     0
TIMER_SPEED     EQU     3
; interruptions
INT_MASK        EQU     FFFAh
INT_MASK_VAL    EQU     8000h ; 1000 0000 0000 0000 b

                ORIG    0000h
vector          TAB     len
seed            WORD    5
TIMER_TICK      WORD    0

MAIN:           MVI     R6, STACKBASE
                
                ; CONFIGURE TIMER ROUNTINES
                ; interrupt mask
                MVI     R1,INT_MASK
                MVI     R2,INT_MASK_VAL
                STOR    M[R1],R2
                ; enable interruptions
                ENI

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
                JAL.NZ  atualizajogo
                ENI
                BR      .LOOP
                
atualizajogo:   DSI
                MVI     R2,TIMER_TICK     
                LOAD    R1,M[R2]
                DEC     R1
                STOR    M[R2],R1
                ENI
                MVI     R1, vector
                MVI     R2, len
                DEC 	R6
				STOR 	M[R6], R4	;PUSH R4
				DEC		R6
				STOR    M[R6], R5	;PUSH R5
                DEC		R6
				STOR    M[R6], R7	;PUSH R7
                MOV     R5, R2		;move number of required shifts to R5 
                DEC     R5			
.loop:          INC     R1			;.loop - shift all values in vector to the 
                LOAD    R4, M[R1]	;left one by one
                DEC     R1			
                STOR    M[R1], R4	
                INC     R1			
                DEC     R5			;decrease shift counter
                CMP     R5, R0		;check if all values have been shifted
                BR.NZ   .loop		;repeat if not
                JAL     geracacto	;create new terrain
                MVI     R1, vector	
                ADD     R1, R1, R2	
                DEC     R1			;find end of vector
                STOR    M[R1], R3	;add new terrain to end of vector
                MVI     R1, vector	;reset R1 for loop
                LOAD 	R7, M[R6]	 
                INC     R6          ;POP R7
                LOAD 	R5, M[R6]   
                INC 	R6          ;POP R5    
				LOAD 	R4, M[R6]	 
                INC     R6          ;POP R4
                JMP     R7
                
                
geracacto:      DEC 	R6			
                STOR 	M[R6], R4   ;PUSH R4
				DEC		R6			
                STOR    M[R6], R5   ;PUSH R5
				MVI     R1, max_alt
                MVI     R4, seed
                LOAD    R4, M[R4]
                MVI     R5, 1
                AND     R5, R4, R5	;bit = x & 1
                SHR     R4			;x = x >> 1
                CMP     R5, R0		;if bit:
                BR.NZ   .xor
                BR      .next
                
.xor:       	MVI     R5, b400h	;x = XOR(x, 0xb400) 
                XOR     R4, R4, R5
                
.next:          MVI     R5, seed	;save new seed value
                STOR    M[R5], R4
                MVI     R5, 62258
                CMP     R4, R5		;if x < 62258:
                BR.C    .zero
                MOV     R5, R1		;return (x & (altura - 1)) + 1
                DEC     R5
                AND     R3, R4, R5
                INC     R3          
                BR      .return
                
.zero:          MOV     R3, R0		;return 0       
.return:        LOAD 	R5, M[R6]	
                INC 	R6          ;POP R5     
                LOAD 	R4, M[R6]      
                INC     R6          ;POP R4
                JMP     R7
                
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