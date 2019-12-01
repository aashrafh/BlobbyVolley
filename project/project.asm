include test.inc
.MODEL SMALL
;-------------------------------------------------------------------------
.STACK 64
;-------------------------------------------------------------------------
.DATA
	WINDOW_WIDTH EQU 320   ;the width of the window (320 pixels)
	WINDOW_WIDTH_HALF EQU 160
	WINDOW_HEIGHT EQU 200  ;the height of the window (200 pixels)
	WINDOW_HALF_HEIGHT EQU 100  	
	BGC EQU 11 ;Light Cyan
	
;------------------------------------------------------------------------	
	TIME_AUX DB 0 ;variable used when checking if the time has changed
;------------------------------------------------------------------------	
	BALL_X DW 170 ;X start position (column) of the ball 
	BALL_Y DW 100 ;Y start position (line) of the ball
	BALL_SIZE EQU 04 ;size of the ball (how many pixels does the ball have in width and height)
	
	;both must be less than ball size
	BALL_VELOCITY_X DW 04 ;X (horizontal) velocity of the ball
	BALL_VELOCITY_Y DW 04 ;Y (vertical) velocity of the ball
;------------------------------------------------------------------------	
	;wall
	WALL_X EQU (WINDOW_WIDTH_HALF - WALL_WIDTH_HALF)
	WALL_Y EQU 100
	WALL_WIDTH EQU 10
	WALL_WIDTH_HALF EQU 5
	WALL_HIGHT EQU 100
	BLACK               EQU         07h ; gray
    BROWN               EQU         04h ; Red
   

WALL                db       BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK 
                    db       BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN
                    db       BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN
                    db       BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN
                    db       BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN
                    db       BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK
                    db       BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK
                    db       BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN
                    db       BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN
                    db       BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN
                    db       BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN
                    db       BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN
                    db       BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN
                    db       BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK
                    db       BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK
                    db       BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN
                    db       BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN 
                    db       BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN
                    db       BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN
                    db       BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK 
                   
                    db       BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK 
                    db       BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN 
                    db       BROWN, BROWN, BROWN,BROWN , BROWN, BROWN, BLACK, BLACK, BROWN, BROWN
                    db       BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN 
                    db       BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN 
                    db       BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK 
                    db       BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK
                    db       BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN 
                    db       BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN 
                    db       BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN 
                    db       BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN 
                    db       BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN 
                    db       BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN 
                    db       BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK
                    db       BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK
                    db       BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN 
                    db       BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BLACK, BLACK, BROWN  
                    db       BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN 
                    db       BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN 
                    db       BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK

                    db       BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK 
                    db       BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN
                    db       BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN
                    db       BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN
                    db       BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN
                    db       BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK
                    db       BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK
                    db       BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN
                    db       BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN
                    db       BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN
                    db       BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN
                    db       BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN
                    db       BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN
                    db       BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK
                    db       BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK
                    db       BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN
                    db       BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN 
                    db       BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN
                    db       BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN
                    db       BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK 
                   
                    db       BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK 
                    db       BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN 
                    db       BROWN, BROWN, BROWN,BROWN , BROWN, BROWN, BLACK, BLACK, BROWN, BROWN
                    db       BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN 
                    db       BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN 
                    db       BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK 
                    db       BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK
                    db       BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN 
                    db       BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN 
                    db       BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN 
                    db       BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN 
                    db       BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN 
                    db       BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN 
                    db       BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK
                    db       BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK
                    db       BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN 
                    db       BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BLACK, BLACK, BROWN  
                    db       BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN 
                    db       BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN 
                    db       BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK
                        
                    db       BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK 
                    db       BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN
                    db       BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN
                    db       BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN
                    db       BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN
                    db       BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK
                    db       BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK
                    db       BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN
                    db       BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN
                    db       BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN
                    db       BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN
                    db       BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN
                    db       BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN
                    db       BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK
                    db       BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK
                    db       BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN
                    db       BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN 
                    db       BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN
                    db       BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN
                    db       BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK 

CB   EQU  13   ; color of the ball
               ; BGC defined back ground color 



BALL         db BGC ,CB ,CB  ,BGC
             db CB  ,CB ,CB  , CB
             db CB  ,CB ,CB  , CB
             db BGC ,CB ,CB  ,BGC
			 
;-------------------------------------------------------------------------	
	;player 1        
	
	PLAYER_ONE_X DW 31   			;X position of the first player
	PLAYER_ONE_Y DW 138			;Y position of the first player
    OLD_X_Player1 DW 00
	OLD_Y_Player1 DW 00 
	
	PLAYER1 DB  11 , 11 , 11 , 11 , 11 , 11 , 11 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 11 , 11 , 11 , 11
			DB  11 , 11 , 11 , 11 , 11 , 11 , 11 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 11 , 11 , 11 , 11
			DB  11 , 11 , 11 , 11 , 11 , 11 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 11
			DB  11 , 11 , 11 , 11 , 11 , 00 , 10 , 00 , 00 , 00 , 00 , 00 , 10 , 00 , 00 , 00 , 00 , 10 , 10 , 00
			DB  11 , 11 , 11 , 11 , 11 , 00 , 10 , 00 , 00 , 00 , 00 , 00 , 10 , 00 , 00 , 00 , 00 , 10 , 10 , 00
			DB  11 , 11 , 11 , 11 , 11 , 00 , 10 , 10 , 10 , 00 , 10 , 10 , 10 , 10 , 00 , 00 , 10 , 10 , 10 , 00
			DB  11 , 11 , 11 , 11 , 11 , 00 , 10 , 10 , 10 , 10 , 10 , 10 , 10 , 10 , 10 , 10 , 10 , 10 , 10 , 00
			DB  11 , 11 , 11 , 11 , 11 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 14 , 14 , 14 , 14 , 00 , 00 , 11
			DB  11 , 11 , 11 , 11 , 11 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 14 , 14 , 14 , 14 , 00 , 00 , 11
			DB  11 , 11 , 11 , 11 , 11 , 11 , 00 , 00 , 00 , 00 , 14 , 14 , 00 , 14 , 00 , 00 , 14 , 00 , 00 , 11
			DB  11 , 11 , 11 , 11 , 11 , 11 , 00 , 10 , 10 , 10 , 14 , 14 , 14 , 14 , 00 , 00 , 14 , 00 , 00 , 11
			DB  11 , 11 , 11 , 11 , 11 , 11 , 00 , 10 , 10 , 10 , 10 , 10 , 14 , 14 , 14 , 14 , 14 , 00 , 00 , 11
			DB  11 , 11 , 11 , 11 , 11 , 11 , 00 , 10 , 10 , 10 , 10 , 10 , 14 , 14 , 14 , 14 , 14 , 00 , 00 , 11
			DB  11 , 11 , 11 , 11 , 11 , 00 , 10 , 10 , 10 , 10 , 10 , 10 , 10 , 10 , 10 , 10 , 10 , 00 , 00 , 11
			DB  11 , 11 , 11 , 00 , 00 , 10 , 10 , 10 , 10 , 10 , 10 , 10 , 10 , 10 , 00 , 00 , 00 , 11 , 11 , 11
			DB  11 , 11 , 11 , 00 , 00 , 10 , 10 , 10 , 10 , 10 , 10 , 10 , 10 , 10 , 00 , 00 , 00 , 11 , 11 , 11
			DB  11 , 11 , 11 , 00 , 00 , 10 , 10 , 10 , 10 , 10 , 00 , 00 , 00 , 00 , 10 , 10 , 00 , 11 , 11 , 11
			DB  11 , 11 , 00 , 10 , 10 , 10 , 10 , 14 , 14 , 14 , 00 , 00 , 00 , 00 , 00 , 00 , 11 , 11 , 11 , 11
			DB  11 , 11 , 00 , 10 , 10 , 10 , 10 , 14 , 14 , 14 , 00 , 00 , 00 , 00 , 11 , 11 , 11 , 11 , 11 , 11
			DB  11 , 11 , 00 , 10 , 10 , 10 , 10 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 11 , 11 , 11 , 11 , 11 , 11
			DB  00 , 00 , 10 , 10 , 10 , 10 , 00 , 00 , 00 , 10 , 10 , 10 , 10 , 10 , 00 , 00 , 11 , 11 , 11 , 11
			DB  00 , 10 , 10 , 00 , 00 , 00 , 11 , 11 , 11 , 00 , 00 , 00 , 00 , 00 , 11 , 11 , 11 , 11 , 11 , 11
			DB  00 , 00 , 00 , 00 , 00 , 00 , 11 , 11 , 11 , 00 , 00 , 00 , 00 , 00 , 11 , 11 , 11 , 11 , 11 , 11  
	
	
;------------------------------------------------------------------------	
	;player 2        
	
	PLAYER_TWO_X DW  271			;X position of the second player
	PLAYER_TWO_Y DW  138			;Y position of the second player
	OLD_X_Player2 DW 00
	OLD_Y_Player2 DW 00 
    
	PLAYER2 DB  11 , 11 , 11 , 11 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 11 , 11 , 11 , 11 , 11 , 11 , 11
			DB  11 , 11 , 11 , 11 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 11 , 11 , 11 , 11 , 11 , 11 , 11
			DB  11 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 11 , 11 , 11 , 11 , 11 , 11
			DB  00 , 12 , 12 , 00 , 00 , 00 , 00 , 12 , 00 , 00 , 00 , 00 , 00 , 12 , 00 , 11 , 11 , 11 , 11 , 11
			DB  00 , 12 , 12 , 00 , 00 , 00 , 00 , 12 , 00 , 00 , 00 , 00 , 00 , 12 , 00 , 11 , 11 , 11 , 11 , 11
			DB  00 , 12 , 12 , 12 , 00 , 00 , 12 , 12 , 12 , 12 , 00 , 12 , 12 , 12 , 00 , 11 , 11 , 11 , 11 , 11
			DB  00 , 12 , 12 , 12 , 12 , 12 , 12 , 12 , 12 , 12 , 12 , 12 , 12 , 12 , 00 , 11 , 11 , 11 , 11 , 11
			DB  11 , 00 , 00 , 14 , 14 , 14 , 14 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 11 , 11 , 11 , 11 , 11
			DB  11 , 00 , 00 , 14 , 14 , 14 , 14 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 11 , 11 , 11 , 11 , 11
			DB  11 , 00 , 00 , 14 , 00 , 00 , 14 , 00 , 14 , 14 , 00 , 00 , 00 , 00 , 11 , 11 , 11 , 11 , 11 , 11
			DB  11 , 00 , 00 , 14 , 00 , 00 , 14 , 14 , 14 , 14 , 12 , 12 , 12 , 00 , 11 , 11 , 11 , 11 , 11 , 11
			DB  11 , 00 , 00 , 14 , 14 , 14 , 14 , 14 , 12 , 12 , 12 , 12 , 12 , 00 , 11 , 11 , 11 , 11 , 11 , 11
			DB  11 , 00 , 00 , 14 , 14 , 14 , 14 , 14 , 12 , 12 , 12 , 12 , 12 , 00 , 11 , 11 , 11 , 11 , 11 , 11
			DB  11 , 00 , 00 , 12 , 12 , 12 , 12 , 12 , 12 , 12 , 12 , 12 , 12 , 12 , 00 , 11 , 11 , 11 , 11 , 11
			DB  11 , 11 , 11 , 00 , 00 , 00 , 12 , 12 , 12 , 12 , 12 , 12 , 12 , 12 , 12 , 00 , 00 , 11 , 11 , 11
			DB  11 , 11 , 11 , 00 , 00 , 00 , 12 , 12 , 12 , 12 , 12 , 12 , 12 , 12 , 12 , 00 , 00 , 11 , 11 , 11
			DB  11 , 11 , 11 , 00 , 12 , 12 , 00 , 00 , 00 , 00 , 12 , 12 , 12 , 12 , 12 , 00 , 00 , 11 , 11 , 11
			DB  11 , 11 , 11 , 11 , 00 , 00 , 00 , 00 , 00 , 00 , 14 , 14 , 14 , 12 , 12 , 12 , 12 , 00 , 11 , 11
			DB  11 , 11 , 11 , 11 , 11 , 11 , 00 , 00 , 00 , 00 , 14 , 14 , 14 , 12 , 12 , 12 , 12 , 00 , 11 , 11
			DB  11 , 11 , 11 , 11 , 11 , 11 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 12 , 12 , 12 , 12 , 00 , 11 , 11
			DB  11 , 11 , 11 , 11 , 00 , 00 , 12 , 12 , 12 , 12 , 12 , 00 , 00 , 00 , 12 , 12 , 12 , 12 , 00 , 00
			DB  11 , 11 , 11 , 11 , 11 , 11 , 00 , 00 , 00 , 00 , 00 , 11 , 11 , 11 , 00 , 00 , 00 , 12 , 12 , 00
			DB  11 , 11 , 11 , 11 , 11 , 11 , 00 , 00 , 00 , 00 , 00 , 11 , 11 , 11 , 00 , 00 , 00 , 00 , 00 , 00
	
	
;-------------------------------------------------------------------------	
	;player common attributes
	PLAYER_X DW ?
	PLAYER_Y DW ?
	PLAYER_WIDTH DW 20 			;size of the player in X direction
	PLAYER_HIGHT DW 23 			;size of the player in Y direction
	PLAYER_VELOCITY_X DW 20      	;X (horizontal) velocity of the player
	PLAYER_VELOCITY_Y DW 23      	;Y (vertical) velocity of the player
	
	;player one playground
	PLAYER_ONE_PLAYGROUND_X_START EQU BALL_SIZE
	PLAYER_ONE_PLAYGROUND_X_END EQU (WALL_X - BALL_SIZE)
	;player two playground
	PLAYER_TWO_PLAYGROUND_X_START EQU (WALL_X + WALL_WIDTH + BALL_SIZE)
	PLAYER_TWO_PLAYGROUND_X_END EQU (WINDOW_WIDTH - BALL_SIZE)
;--------------------------------------------------------------------------	
.CODE

;------------------------------set the background color--------------------------------------------
INITIALIZE_SCREEN PROC
  
    MOV AH, 06h    ; Scroll up function
	XOR AL, AL     ; Clear entire screen
	XOR CX, CX     ; Upper left corner CH=row, CL=column
	MOV DX, 184FH  ; lower right corner DH=row, DL=column 
	MOV BH, BGC     ; color 
	INT 10H
  
INITIALIZE_SCREEN  ENDP

;----------------------------Moving the ball and its collision detection------------------------------------------	
	MOVE_BALL PROC NEAR
		
	
		MOV AX,BALL_VELOCITY_X    
		ADD BALL_X,AX             ;move the ball horizontally
		MOV AX,BALL_VELOCITY_Y
		ADD BALL_Y,AX             ;move the ball vertically
		
		;check x
		
		;check window
		MOV AX, BALL_SIZE
		CMP BALL_X,AX                         
		JL NEG_VELOCITY_X         ;BALL_X < 0   
		
		MOV AX,WINDOW_WIDTH
		SUB AX,BALL_SIZE
		CMP BALL_X,AX	          ;BALL_X > WINDOW_WIDTH - BALL_SIZE  -  (Y -> collided)
		JG NEG_VELOCITY_X
		
		;check wall
		CALL CHECK_WALL_X
		CMP AX, 1
		JE NEG_VELOCITY_X
		
		;CHECK_PLAYER_ONE_X
		MOV AX, PLAYER_ONE_X
		MOV BX, PLAYER_ONE_Y
		CALL CHECK_PLAYER_X					;Check collision in the x-axis
		CMP AX, 1
		JE NEG_VELOCITY_X_PLAYER
		
		;CHECK_PLAYER_TWO_X
		MOV AX, PLAYER_TWO_X
		MOV BX, PLAYER_TWO_Y
		CALL CHECK_PLAYER_X                ;Check collision in the x-axis
		CMP AX, 1
		JE NEG_VELOCITY_X_PLAYER
		
		JMP CHECK_Y
			
		NEG_VELOCITY_X:
			NEG BALL_VELOCITY_X   ;BALL_VELOCITY_X = - BALL_VELOCITY_X
		
		JMP CHECK_Y

		NEG_VELOCITY_X_PLAYER:
		NEG BALL_VELOCITY_X   ;BALL_VELOCITY_X = - BALL_VELOCITY_X
		MOV AX,BALL_VELOCITY_X    
		ADD AX, 1
		ADD BALL_X,AX             ;move the ball horizontally
		
		
		CHECK_Y:
		
		;check window
		MOV AX, BALL_SIZE
		CMP BALL_Y,AX   ;BALL_Y < 0 +  (Y -> collided)
		JL NEG_VELOCITY_Y                          
		
		;check wall y
		CALL CHECK_WALL_Y
		CMP AX, 1
		JE NEG_VELOCITY_Y
		
		;check player one playground
		CALL CHECK_PLAYER_ONE_PLAYGROUND
		CMP AX, 1
		JE NEG_VELOCITY_Y
		
		;check player two playground
		CALL CHECK_PLAYER_TWO_PLAYGROUND
		CMP AX, 1
		JE NEG_VELOCITY_Y
		
		;CHECK_PLAYER_ONE_TOP_Y
		MOV AX, PLAYER_ONE_X
		MOV BX, PLAYER_ONE_Y
		CALL CHECK_PLAYER_TOP_Y          ;Check collision in the top y-axis
		CMP AX, 1
		JE NEG_VELOCITY_Y_PLAYER
		
		;CHECK_PLAYER_ONE_DOWN_Y
		MOV AX, PLAYER_ONE_X
		MOV BX, PLAYER_ONE_Y
		CALL CHECK_PLAYER_DOWN_Y         ;Check collision in the bottom y-axis
		CMP AX, 1
		JE NEG_VELOCITY_Y_PLAYER
		
		;CHECK_PLAYER_TWO_TOP_Y
		MOV AX, PLAYER_TWO_X
		MOV BX, PLAYER_TWO_Y
		CALL CHECK_PLAYER_TOP_Y			 ;Check collision in the top y-axis
		CMP AX, 1
		JE NEG_VELOCITY_Y_PLAYER
		
		;CHECK_PLAYER_TWO_DOWN_Y
		MOV AX, PLAYER_TWO_X		     
		MOV BX, PLAYER_TWO_Y
		CALL CHECK_PLAYER_DOWN_Y	     ;Check collision in the bottom y-axis	
		CMP AX, 1
		JE NEG_VELOCITY_Y_PLAYER
		
		JMP RET_MOVE_BALL
		
		NEG_VELOCITY_Y:
			NEG BALL_VELOCITY_Y   ;BALL_VELOCITY_Y = - BALL_VELOCITY_Y
		
		JMP RET_MOVE_BALL

		NEG_VELOCITY_Y_PLAYER:
			NEG BALL_VELOCITY_Y   ;BALL_VELOCITY_Y = - BALL_VELOCITY_Y
			MOV AX, BALL_VELOCITY_Y
			ADD AX, 1
			ADD BALL_Y,AX             ;move the ball vertically
		
		RET_MOVE_BALL:
		RET
	MOVE_BALL ENDP
;-----------------------------------------------------------------------------------	

movePlayer1 PROC NEAR 
    ;pusha
;READ CHARACTER FROM KEYBOARD
		mov ah,1
		int 16h
		JZ DONE1
		; mov ah,0
		; int 16h
		
	    mov SI , PLAYER_ONE_X
		mov DI , PLAYER_ONE_Y
		
		mov [OLD_X_Player1],SI
		mov [OLD_Y_Player1],DI
		
		;down
		CMP aL, 's'
		JZ DOWN
		;Up
		CMP aL, 'w'
		JZ up
		;Left
		CMP aL, 'a'
		JZ left
		;Right
		CMP aL, 'd'
		JZ Right
		
		JMP DEFAULT
		
		
		 	
		
		Right:
           
			MOV AX,PLAYER_VELOCITY_X
			ADD PLAYER_ONE_X,AX
			;avoid crossing the barrier
			MOV AX, 145
			CMP PLAYER_ONE_X, AX
			JG DECREASEX
		
			DONE1:
			
			jmp DONE
		Left:
		    
			MOV AX,PLAYER_VELOCITY_X
			SUB PLAYER_ONE_X,AX
			MOV AX, 0
			CMP PLAYER_ONE_X, AX
			JL INCREASEX
			
			
			jmp DONE
		Up:
		    
			MOV AX,PLAYER_VELOCITY_Y
			SUB PLAYER_ONE_Y,AX
			CMP PLAYER_ONE_Y, 10
			JL INCREASEY
			
			
			jmp DONE
		DOWN:
            
			MOV AX, PLAYER_VELOCITY_Y
			ADD PLAYER_ONE_Y,AX
			CMP PLAYER_ONE_Y, 160
			JA DECREASEY
			
			
			jmp DONE
		
		DEFAULT: 
			jmp DONEALL
		
		DECREASEX:
			MOV AX, PLAYER_VELOCITY_X;
			SUB PLAYER_ONE_X, AX
			
			
			jmp DONE
		INCREASEX: 
			MOV AX, PLAYER_VELOCITY_Y;
			ADD PLAYER_ONE_X, AX
			
			
			jmp DONE
		INCREASEY: 
			ADD PLAYER_ONE_Y, AX
			
			jmp DONE
		DECREASEY:
			SUB PLAYER_ONE_Y, AX
		
			jmp DONE
			
        DONE:		
		  CLEAR 11, OLD_X_Player1 ,OLD_Y_Player1, PLAYER_WIDTH, PLAYER_HIGHT
		  RET
		
        DONEALL:
		RET
movePlayer1 ENDP
;-----------------------------------------------------------------------------------	

movePlayer2 PROC NEAR
    ;pusha
;READ CHARACTER FROM KEYBOARD
		mov ah,1
		int 16h
		JZ DONE_2
		mov ah,0
		int 16h
		
	    mov SI , PLAYER_TWO_X
		mov DI , PLAYER_TWO_Y
		
		mov [OLD_X_Player2],SI
		mov [OLD_Y_Player2],DI
		
		;The only difference here is that we compare scan code not ascii code as previouszaq
		;down
		CMP AH, 80
		JZ DOWN2
		;Up
		CMP AH, 72
		JZ Up2
		;Left
		CMP AX, 4B00H
		JZ Left2
		;Right
		CMP AH, 77
		JZ Right2
		
		JMP DEFAULT2
		
		
		 	
		
		Right2:
           
			MOV AX,PLAYER_VELOCITY_X
			ADD PLAYER_TWO_X,AX
			;avoid crossing the barrier
			MOV AX, 310
			CMP PLAYER_TWO_X, AX
			JG DECREASEX2
		
			DONE_2:
			
			jmp DONE2
		Left2:
		    
			MOV AX,PLAYER_VELOCITY_X
			SUB PLAYER_TWO_X,AX
			MOV AX, 150
			CMP PLAYER_TWO_X, AX
			JL INCREASEX2
			
			
			jmp DONE2
		Up2:
		    
			MOV AX,PLAYER_VELOCITY_Y
			SUB PLAYER_TWO_Y,AX
			CMP PLAYER_TWO_Y, 10
			JL INCREASEY2
			
			
			jmp DONE2
		DOWN2:
            
			MOV AX, PLAYER_VELOCITY_Y
			ADD PLAYER_TWO_Y,AX
			CMP PLAYER_TWO_Y, 160
			JA DECREASEY2
			
			
			jmp DONE2
		
		DEFAULT2: 
			jmp DONEALL2
		
		DECREASEX2:
			MOV AX, PLAYER_VELOCITY_X;
			SUB PLAYER_TWO_X, AX
			
			
			jmp DONE2
		INCREASEX2: 
			MOV AX, PLAYER_VELOCITY_Y;
			ADD PLAYER_TWO_X, AX
			
			
			jmp DONE2
		INCREASEY2: 
			ADD PLAYER_TWO_Y, AX
			
			jmp DONE2
		DECREASEY2:
			SUB PLAYER_TWO_Y, AX
		
			jmp DONE2
			
        DONE2:		
		  CLEAR 11, OLD_X_Player2 ,OLD_Y_Player2, PLAYER_WIDTH, PLAYER_HIGHT
		  RET 
		
        DONEALL2:
        RET
movePlayer2 ENDP
;---------------------------------------------------------------------------	
	;Collision with the wall in the x-axis
	CHECK_WALL_X PROC NEAR
		MOV AX, 0
		CMP BALL_X, (WALL_X - BALL_SIZE)   ;check collision in the left side
		JB RETURN
		CMP BALL_X, (WALL_X + WALL_WIDTH + BALL_SIZE)   ;check collision in the right side
		JA RETURN
		CMP BALL_Y, WALL_Y                 ;check collision in the top side
		JB RETURN
		MOV AX, 1  ;there is a collision
		RETURN:
		RET 
	CHECK_WALL_X ENDP
;--------------------------------------------------------------------------	
	;Collision with the wall in the y-axis
	CHECK_WALL_Y PROC NEAR
		MOV AX, 0
		CMP BALL_X, (WALL_X - BALL_SIZE)   ;check collision in the left side
		JB RET_CHECK_WALL_Y
		CMP BALL_X, (WALL_X + WALL_WIDTH + BALL_SIZE)    ;check collision in the right side
		JA RET_CHECK_WALL_Y
		CMP BALL_Y, WALL_Y                 ;check collision in the top side
		JB RET_CHECK_WALL_Y
		CMP BALL_Y, (WALL_Y + BALL_SIZE)   ;check collision in the top side
		JA RET_CHECK_WALL_Y
		MOV AX, 1  ;there is a collision
		RET_CHECK_WALL_Y:
		RET 
	CHECK_WALL_Y ENDP
;----------------------------------------------------------------------------	
	CHECK_PLAYER_ONE_PLAYGROUND PROC NEAR         ;Check if the second player attack the first player
		MOV AX, 0
		CMP BALL_X, PLAYER_ONE_PLAYGROUND_X_START ;out of the playground
		JB RET_CHECK_PLAYER_ONE_PLAYGROUND
		CMP BALL_X, PLAYER_ONE_PLAYGROUND_X_END   ;out of the playground
		JA RET_CHECK_PLAYER_ONE_PLAYGROUND
		CMP BALL_Y, (WINDOW_HEIGHT - BALL_SIZE)	  ;if it in the playground but strictly above the ground
		JB RET_CHECK_PLAYER_ONE_PLAYGROUND        ;then no counted points
		MOV AX, 1                                 ;there is an attack
		RET_CHECK_PLAYER_ONE_PLAYGROUND:
		RET 
	CHECK_PLAYER_ONE_PLAYGROUND ENDP
;-----------------------------------------------------------------------------	
	CHECK_PLAYER_TWO_PLAYGROUND PROC NEAR         ;Check if the first player attack the second player
		MOV AX, 0
		CMP BALL_X, PLAYER_TWO_PLAYGROUND_X_START ;out of the playground
		JB RET_CHECK_PLAYER_TWO_PLAYGROUND
		CMP BALL_X, PLAYER_TWO_PLAYGROUND_X_END   ;out of the playground
		JA RET_CHECK_PLAYER_TWO_PLAYGROUND 
		CMP BALL_Y, (WINDOW_HEIGHT - BALL_SIZE)	  ;if it in the playground but strictly above the ground
		JB RET_CHECK_PLAYER_TWO_PLAYGROUND        ;then no counted points
		MOV AX, 1                                 ;there is an attack
		RET_CHECK_PLAYER_TWO_PLAYGROUND:
		RET 
	CHECK_PLAYER_TWO_PLAYGROUND ENDP
;-------------------------------------------------------------------------------	
	CHECK_PLAYER_X PROC NEAR    ;Detect collision in the x-axis
		MOV PLAYER_X, AX 		;X of the specified player (first or second)
		MOV PLAYER_Y, BX		;Y of the specified player (first or second)
		MOV AX, 0				;flag
		;Check collision from left
		MOV DX, PLAYER_X		
		SUB DX, BALL_SIZE
		CMP BALL_X, DX			;If there is a left collision then => BALL_X = PLAYER_X - BALL_SIZE
		JB RET_CHECK_PLAYER_X   ;Below = far = no collision
		
		;Check collision from right
		MOV DX, PLAYER_X
		ADD DX, PLAYER_WIDTH	
		ADD DX, BALL_SIZE
		CMP BALL_X, DX			;If there is a left collision then => BALL_X = PLAYER_X + PLAYER_WIDTH + BALL_SIZE
		JA RET_CHECK_PLAYER_X   ;Above = far = no collision
		
		;If there is a collision in the x-axis then we need one more check
		;We have to check the y boundaries
		MOV DX, PLAYER_Y
		CMP BALL_Y, DX			
		JB RET_CHECK_PLAYER_X	;above the the player = no collision
		
		MOV DX, PLAYER_Y
		ADD DX, PLAYER_HIGHT
		CMP BALL_Y, DX
		JA RET_CHECK_PLAYER_X 	;below the the player = no collision
		
		MOV AX, 1				;there is a collision
		RET_CHECK_PLAYER_X:
		RET 
	CHECK_PLAYER_X ENDP
;-------------------------------------------------------------------------------	
	CHECK_PLAYER_TOP_Y PROC NEAR	;Detect collision in the y-axis from top
		MOV PLAYER_X, AX			;X of the specified player (first or second)
		MOV PLAYER_Y, BX			;Y of the specified player (first or second)
		MOV AX, 0					;flag
		
		;Check X boundraies same as CHECK_PLAYER_X
		MOV DX, PLAYER_X
		SUB DX, BALL_SIZE
		CMP BALL_X, DX
		JB RET_CHECK_PLAYER_TOP_Y
		
		MOV DX, PLAYER_X
		ADD DX, PLAYER_WIDTH
		ADD DX, BALL_SIZE
		CMP BALL_X, DX 
		JA RET_CHECK_PLAYER_TOP_Y
		
		;Then we nead to validate the collision in the top y
		;to be a valid collision this satement should be satisfied
		;PLAYER_Y <= BALL_Y <= PLAYER_Y + PLAYER_HIGHT
		;AND
		;PLAYER_Y <= BALL_Y + BALL_SIZE <= PLAYER_Y + PLAYER_HIGHT
		MOV DX, PLAYER_Y
		CMP BALL_Y, DX
		JB RET_CHECK_PLAYER_TOP_Y	;Above the player
		
		MOV DX, PLAYER_Y
		ADD DX, BALL_SIZE
		CMP BALL_Y, DX
		JA RET_CHECK_PLAYER_TOP_Y	;Below the Player
		
		MOV AX, 1					;there is a collision
		RET_CHECK_PLAYER_TOP_Y:
		RET 
	CHECK_PLAYER_TOP_Y ENDP
;------------------------------------------------------------------------------------	
	CHECK_PLAYER_DOWN_Y PROC NEAR	;Detect collision in the y-axis from top
		MOV PLAYER_X, AX			;X of the specified player (first or second)
		MOV PLAYER_Y, BX			;Y of the specified player (first or second)
		MOV AX, 0					;flag
		
		;Check X boundraies same as CHECK_PLAYER_X
		MOV DX, PLAYER_X
		SUB DX, BALL_SIZE
		CMP BALL_X, DX
		JB RET_CHECK_PLAYER_DOWN_Y
		
		MOV DX, PLAYER_X
		ADD DX, PLAYER_WIDTH
		ADD DX, BALL_SIZE
		CMP BALL_X, DX 
		JA RET_CHECK_PLAYER_DOWN_Y
		
		;Then we nead to validate the collision in the top y
		;to be a valid collision this satement should be satisfied
		;PLAYER_Y <= BALL_Y <= PLAYER_Y + PLAYER_HIGHT
		;AND
		;PLAYER_Y <= BALL_Y + BALL_SIZE <= PLAYER_Y + PLAYER_HIGHT
		MOV DX, PLAYER_Y
		ADD DX, PLAYER_HIGHT
		SUB DX, BALL_SIZE
		CMP BALL_Y, DX
		JB RET_CHECK_PLAYER_DOWN_Y	;Above the player
		
		MOV DX, PLAYER_Y
		ADD DX, PLAYER_HIGHT
		CMP BALL_Y, DX
		JA RET_CHECK_PLAYER_DOWN_Y	;Below the player
		
		MOV AX, 1
		RET_CHECK_PLAYER_DOWN_Y:
		RET 
	CHECK_PLAYER_DOWN_Y ENDP
;------------------------------------------------------------------------------------	
MAIN PROC FAR

	MOV AX, @DATA
	MOV DS, AX	
	

    Mov ah , 00h  ;change to vedio mode
	Mov Al , 13h
	int 10h
	
	CALL INITIALIZE_SCREEN 
		;CALL ClS ;CALL CLEAR_SCREEN
			
		CHECK_TIME:
		
			MOV AH,2Ch ;get the system time
			INT 21h    ;CH = hour CL = minute DH = second DL = 1/100 seconds
			
			CMP DL,TIME_AUX  ;is the current time equal to the previous one(TIME_AUX)?
			JE CHECK_TIME    ;if it is the same, check again
			                 ;if it's different, then draw, move, etc.
			
			MOV TIME_AUX,DL ;update time
			
			
			;DRAW the Wall
		    DRAW WALL, WALL_X, WALL_Y, WALL_WIDTH, WALL_HIGHT     ;Macro to draw wall
			
			; Draw Players 
			DRAW PLAYER1, PLAYER_ONE_X, PLAYER_ONE_Y, PLAYER_WIDTH, PLAYER_HIGHT    
			DRAW PLAYER2, PLAYER_TWO_X, PLAYER_TWO_Y, PLAYER_WIDTH, PLAYER_HIGHT 
			
			; Move Players
			CALL movePlayer1  ;move for player1 
			CALL movePlayer2  ;move for player2 
			
			; Move BALL and Draw it
			CLEAR BGC, BALL_X, BALL_Y, BALL_SIZE, BALL_SIZE      ;clear old poition / Cyan
			CALL MOVE_BALL
		    DRAW BALL, BALL_X, BALL_Y, BALL_SIZE, BALL_SIZE		; CALL DRAW_BALL / yellow              
			
			JMP CHECK_TIME ;after everything checks time again
			
		;return the control to the dos
		;MOV AH, 4CH
		;INT 21H
			
MAIN ENDP
END MAIN
;---------------------------------------------------------------------	