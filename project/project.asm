.MODEL SMALL
.STACK 64
.DATA
	WINDOW_WIDTH DW 140h   ;the width of the window (320 pixels)
	WINDOW_HEIGHT DW 0C8h  ;the height of the window (200 pixels)
	WINDOW_BOUNDS EQU 6    ;variable used to check collisions early
						   ;must be more than the ball size to avoid ball glitching
						   
	TIME_AUX DB 0 ;variable used when checking if the time has changed
	
	BALL_X DW 20 ;X position (column) of the ball
	BALL_Y DW 20 ;Y position (line) of the ball
	BALL_SIZE EQU 08h ;size of the ball (how many pixels does the ball have in width and height)
	BALL_VELOCITY_X DW 04H ;X (horizontal) velocity of the ball
	BALL_VELOCITY_Y DW 02H ;Y (vertical) velocity of the ball
	
	;;;;;;;;;;;;;;;;;
	WALL_X EQU 155
	WALL_Y EQU 100
	WALL_SIZE_X EQU 10
	WALL_SIZE_Y EQU 100
	;;;;;;;;;;;;;;;;;
	
.CODE 
	MAIN PROC FAR
	MOV AX, @DATA
	MOV DS, AX
	
		CALL CLEAR_SCREEN
		
		CHECK_TIME:
		
			MOV AH,2Ch ;get the system time
			INT 21h    ;CH = hour CL = minute DH = second DL = 1/100 seconds
			
			CMP DL,TIME_AUX  ;is the current time equal to the previous one(TIME_AUX)?
			JE CHECK_TIME    ;if it is the same, check again
			;if it's different, then draw, move, etc.
			
			MOV TIME_AUX,DL ;update time
			
			CALL CLEAR_SCREEN
			
			CALL MOVE_BALL
			
			CALL DRAW_WALL
			CALL DRAW_BALL 
			
			JMP CHECK_TIME ;after everything checks time again
			
		;return the control to the dos
		mov ah, 4ch
		int 21h
	MAIN ENDP
	
	MOVE_BALL PROC NEAR
		
		MOV AX,BALL_VELOCITY_X    
		ADD BALL_X,AX             ;move the ball horizontally
		
		;;;;;;;;;;;;;;
		CALL CHECK_WALL_X
		CMP AX, 1
		JE NEG_VELOCITY_X
		
		;TODO: avoid the top barier
		;CALL CHECK_WALL_Y
		;CMP AX, 1
		;JE NEG_VELOCITY_Y
		;;;;;;;;;;;;;;
		
		MOV AX,WINDOW_BOUNDS
		CMP BALL_X,AX                         
		JL NEG_VELOCITY_X         ;BALL_X < 0 + WINDOW_BOUNDS 
		
	    MOV AX,WINDOW_WIDTH
		SUB AX,BALL_SIZE
		SUB AX,WINDOW_BOUNDS
		CMP BALL_X,AX	          ;BALL_X > WINDOW_WIDTH - BALL_SIZE  - WINDOW_BOUNDS (Y -> collided)
		JG NEG_VELOCITY_X
		
		MOV AX,BALL_VELOCITY_Y
		ADD BALL_Y,AX             ;move the ball vertically
		
		MOV AX,WINDOW_BOUNDS
		CMP BALL_Y,AX   ;BALL_Y < 0 + WINDOW_BOUNDS (Y -> collided)
		JL NEG_VELOCITY_Y                          
		
		MOV AX,WINDOW_HEIGHT	
		SUB AX,BALL_SIZE
		SUB AX,WINDOW_BOUNDS
		CMP BALL_Y,AX
		JG NEG_VELOCITY_Y		  ;BALL_Y > WINDOW_HEIGHT - BALL_SIZE - WINDOW_BOUNDS (Y -> collided)
		
		RET
		
		NEG_VELOCITY_X:
			NEG BALL_VELOCITY_X   ;BALL_VELOCITY_X = - BALL_VELOCITY_X
			RET
			
		NEG_VELOCITY_Y:
			NEG BALL_VELOCITY_Y   ;BALL_VELOCITY_Y = - BALL_VELOCITY_Y
			RET
		
	MOVE_BALL ENDP
	
	DRAW_BALL PROC NEAR
		
		MOV CX,BALL_X ;set the initial column (X)
		MOV DX,BALL_Y ;set the initial line (Y)
		
		DRAW_BALL_HORIZONTAL:
			MOV AH,0Ch ;set the configuration to writing a pixel
			MOV AL,0Fh ;choose white as color
			MOV BH,00h ;set the page number 
			INT 10h    ;execute the configuration
			
			INC CX     ;CX = CX + 1
			MOV AX,CX          ;CX - BALL_X > BALL_SIZE (Y -> We go to the next line,N -> We continue to the next column
			SUB AX,BALL_X
			CMP AX,BALL_SIZE
			JNG DRAW_BALL_HORIZONTAL
			
			MOV CX,BALL_X ;the CX register goes back to the initial column
			INC DX        ;we advance one line
			
			MOV AX,DX              ;DX - BALL_Y > BALL_SIZE (Y -> we exit this procedure,N -> we continue to the next line
			SUB AX,BALL_Y
			CMP AX,BALL_SIZE
			JNG DRAW_BALL_HORIZONTAL
		
		RET
	DRAW_BALL ENDP
	
	CLEAR_SCREEN PROC NEAR
			MOV AH,00h ;set the configuration to video mode
			MOV AL,13h ;choose the video mode
			INT 10h    ;execute the configuration 
		
			MOV AH,0Bh ;set the configuration
			MOV BH,00h ;to the background color
			MOV BL,00h ;choose black as background color
			INT 10h    ;execute the configuration
			
			RET
	CLEAR_SCREEN ENDP
	
	DRAW_WALL PROC NEAR
		
		MOV CX,WALL_X ;set the initial column (X)
		MOV DX,WALL_Y ;set the initial line (Y)
		
		DRAW_WALL_HORIZONTAL:
			MOV AH,0Ch ;set the configuration to writing a pixel
			MOV AL,0Fh ;choose white as color
			MOV BH,00h ;set the page number 
			INT 10h    ;execute the configuration
			
			INC CX     ;CX = CX + 1
			MOV AX,CX          ;CX - WALL_X > WALL_SIZE (Y -> We go to the next line,N -> We continue to the next column
			SUB AX,WALL_X
			CMP AX,WALL_SIZE_X
			JNG DRAW_WALL_HORIZONTAL
			
			MOV CX,WALL_X ;the CX register goes back to the initial column
			INC DX        ;we advance one line
			
			MOV AX,DX              ;DX - WALL_Y > WALL_SIZE (Y -> we exit this procedure,N -> we continue to the next line
			SUB AX,WALL_Y
			CMP AX,WALL_SIZE_Y
			JNG DRAW_WALL_HORIZONTAL
		
		RET
	DRAW_WALL ENDP
	
	CHECK_WALL_X PROC NEAR
	MOV AX, 0
	CMP BALL_X, (WALL_X - WINDOW_BOUNDS)
	JB RETURN
	CMP BALL_X, (WALL_X + WALL_SIZE_X + WINDOW_BOUNDS) 
	JA RETURN
	CMP BALL_Y, WALL_Y
	JB RETURN
	MOV AX, 1
	RETURN:
	RET 
	CHECK_WALL_X ENDP
	
	CHECK_WALL_Y PROC NEAR
	MOV AX, 0
	CMP BALL_X, WALL_X
	JB RETURN2
	CMP BALL_X, (WALL_X + WALL_SIZE_X)
	JA RETURN2
	CMP BALL_Y, WALL_Y
	JB RETURN2
	CMP BALL_Y, (WALL_Y + 10)
	JA RETURN2
	MOV AX, 1
	RETURN2:
	RET 
	CHECK_WALL_Y ENDP
	
end MAIN 
