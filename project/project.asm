.MODEL SMALL
.STACK 64
.DATA
	WINDOW_WIDTH EQU 320   ;the width of the window (320 pixels)
	WINDOW_WIDTH_HALF EQU 160
	WINDOW_HEIGHT EQU 200  ;the height of the window (200 pixels)
	WINDOW_HALF_HEIGHT EQU 100  	
	
	TIME_AUX DB 0 ;variable used when checking if the time has changed
	
	BALL_X DW 170 ;X start position (column) of the ball 
	BALL_Y DW 100 ;Y start position (line) of the ball
	BALL_SIZE EQU 08h ;size of the ball (how many pixels does the ball have in width and height)
	
	;both must be less than ball size
	BALL_VELOCITY_X DW 04H ;X (horizontal) velocity of the ball
	BALL_VELOCITY_Y DW 02H ;Y (vertical) velocity of the ball
	
	;wall
	WALL_X EQU (WINDOW_WIDTH_HALF - WALL_WIDTH_HALF)
	WALL_Y EQU 100
	WALL_WIDTH EQU 10
	WALL_WIDTH_HALF EQU 5
	WALL_HIGHT EQU 100
	
	;player one        
	PLAYER_ONE_X DW 0H   			;X position of the first player
	PLAYER_ONE_Y DW 0A0H			;Y position of the first player
	PLAYER_ONE_WIDTH DW 0AH 		;size of the first player in X direction
	PLAYER_ONE_HIGHT DW 14H 		;size of the first player in Y direction
	PLAYER_VELOCITY_X DW 0AH      ;X (horizontal) velocity of the player
	PLAYER_VELOCITY_Y DW 0FH      ;Y (vertical) velocity of the player
	
	;player one playground
	PLAYER_ONE_PLAYGROUND_X_START EQU BALL_SIZE
	PLAYER_ONE_PLAYGROUND_X_END EQU (WALL_X - BALL_SIZE)
	;player two playground
	PLAYER_TWO_PLAYGROUND_X_START EQU (WALL_X + WALL_WIDTH + BALL_SIZE)
	PLAYER_TWO_PLAYGROUND_X_END EQU (WINDOW_WIDTH - BALL_SIZE)
	
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
			CALL DRAW_FIRST_PLAYER    ;NOTE: this proc affects the flag registers, BE CAREFULL 
			CALL MOVE_PLAYER			;get move from the user using the keyboard
			JMP CHECK_TIME ;after everything checks time again
			
		;return the control to the dos
		MOV AH, 4CH
		INT 21H
	MAIN ENDP
	
	MOVE_BALL PROC NEAR
		
		MOV AX,BALL_VELOCITY_X    
		ADD BALL_X,AX             ;move the ball horizontally
		MOV AX,BALL_VELOCITY_Y
		ADD BALL_Y,AX             ;move the ball vertically
		
		;check x
		
		;check window
		MOV AX,
		CMP BALL_X,AX                         
		JL NEG_VELOCITY_X         ;BALL_X < 0 +  
		
		MOV AX,WINDOW_WIDTH
		SUB AX,BALL_SIZE
		SUB AX,
		CMP BALL_X,AX	          ;BALL_X > WINDOW_WIDTH - BALL_SIZE  -  (Y -> collided)
		JG NEG_VELOCITY_X
		
		;check wall
		CALL CHECK_WALL_X
		CMP AX, 1
		JE NEG_VELOCITY_X
		
		JMP CHECK_Y
		
		NEG_VELOCITY_X:
			NEG BALL_VELOCITY_X   ;BALL_VELOCITY_X = - BALL_VELOCITY_X
		
		CHECK_Y:
		
		;check window
		MOV AX,
		CMP BALL_Y,AX   ;BALL_Y < 0 +  (Y -> collided)
		JL NEG_VELOCITY_Y                          
		
		;check player one playground
		CALL CHECK_PLAYER_ONE_PLAYGROUND
		CMP AX, 1
		JE NEG_VELOCITY_Y
		
		;check player two playground
		CALL CHECK_PLAYER_TWO_PLAYGROUND
		CMP AX, 1
		JE NEG_VELOCITY_Y
		
		JMP RET_MOVE_BALL
				

		NEG_VELOCITY_Y:
			NEG BALL_VELOCITY_Y   ;BALL_VELOCITY_Y = - BALL_VELOCITY_Y
		
		RET_MOVE_BALL:
		RET
		
		HALT1:
		HLT
		
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
			CMP AX,WALL_WIDTH
			JNG DRAW_WALL_HORIZONTAL
			
			MOV CX,WALL_X ;the CX register goes back to the initial column
			INC DX        ;we advance one line
			
			MOV AX,DX              ;DX - WALL_Y > WALL_SIZE (Y -> we exit this procedure,N -> we continue to the next line
			SUB AX,WALL_Y
			CMP AX,WALL_HIGHT
			JNG DRAW_WALL_HORIZONTAL
		
		RET
	DRAW_WALL ENDP
	
	DRAW_FIRST_PLAYER PROC NEAR
		MOV CX, PLAYER_ONE_X	;X = COLUMN
		MOV DX, PLAYER_ONE_Y	;Y = ROW
			
		Draw:
			;Write graphics pixel
			MOV AH, 0CH 			;SET CONFIGURATION TO WRITE A PIXEL
			MOV AL, 0CH 			;CHOOSE PIXL COLOR
			MOV BH, 00H				;PAGE NUMBER
			INT 10H					;EXECUTE
			
			INC CX 					;CX = CX + 1
			MOV AX, CX				;TMP FOR THE SUBTRACTION
			SUB AX, PLAYER_ONE_X  	;AX = AX - PLAYER_ONE_X
			CMP AX, PLAYER_ONE_WIDTH 	;If AX - PLAYER_ONE_X > PLAYER_ONE_WIDTH
			JNG Draw 				;Go to the next line if not greater just proceed drawing horizontally
			
			MOV CX, PLAYER_ONE_X		;Start drawing from the begining in the second line
			INC DX 					;proceed to the next line i.e. DX = DX + 1
				
			MOV AX, DX				;TMP FOR THE SUBTRACTION
			SUB AX, PLAYER_ONE_Y  	;AX = AX - PLAYER_ONE_Y
			CMP AX, PLAYER_ONE_HIGHT 	;If AX - PLAYER_ONE_Y > PLAYER_ONE_HIGHT
			JNG Draw 				;exit the proc if not greater just proceed drawing
			
		RET
	DRAW_FIRST_PLAYER ENDP
	
	MOVE_PLAYER PROC NEAR
		;READ CHARACTER FROM KEYBOARD
		 
		mov ah,1
		int 16h
		jz DONE
		;MOV AH, 01H
		;INT 21H
		
		mov ah,0
		int 16h
		
		CMP AL, 'w'
		JZ Up
		;Left
		CMP AL, 'a'
		JZ Left
		;Right
		CMP AL, 'd'
		JZ Right
		
		JMP DEFAULT
		;Generate a move to
		Right:         
			MOV AX,PLAYER_VELOCITY_X
			ADD PLAYER_ONE_X,AX
			MOV AX, 100
			CMP PLAYER_ONE_X, AX
			JG DECREASEX
			RET
		Left:
			MOV AX,PLAYER_VELOCITY_X
			SUB PLAYER_ONE_X,AX
			MOV AX, 5
			CMP PLAYER_ONE_X, AX
			JL INCREASEX
			RET
		Up:
			MOV AX,PLAYER_VELOCITY_Y
			SUB PLAYER_ONE_Y,AX
			MOV AX, 5
			CMP PLAYER_ONE_Y, AX
			JL INCREASEY
			RET
		
		DEFAULT: 
			RET
		
		DECREASEX:
			MOV AX, 0AH;
			SUB PLAYER_ONE_X, AX
			RET
		INCREASEX: 
			MOV AX, 0AH;
			ADD PLAYER_ONE_X, AX
			RET
		INCREASEY: 
			MOV AX, 0AH;
			ADD PLAYER_ONE_Y, AX
			RET
			
		DONE: RET
	MOVE_PLAYER ENDP
	
	CHECK_WALL_X PROC NEAR
	MOV AX, 0
	CMP BALL_X, (WALL_X - BALL_SIZE)
	JB RETURN
	CMP BALL_X, (WALL_X + WALL_WIDTH + BALL_SIZE) 
	JA RETURN
	CMP BALL_Y, WALL_Y
	JB RETURN
	MOV AX, 1
	RETURN:
	RET 
	CHECK_WALL_X ENDP
		
	CHECK_PLAYER_ONE_PLAYGROUND PROC NEAR
	MOV AX, 0
	CMP BALL_X, PLAYER_ONE_PLAYGROUND_X_START
	JB RET_CHECK_PLAYER_ONE_PLAYGROUND
	CMP BALL_X, PLAYER_ONE_PLAYGROUND_X_END 
	JA RET_CHECK_PLAYER_ONE_PLAYGROUND
	CMP BALL_Y, (WINDOW_HEIGHT - BALL_SIZE)	
	JB RET_CHECK_PLAYER_ONE_PLAYGROUND
	MOV AX, 1
	RET_CHECK_PLAYER_ONE_PLAYGROUND:
	RET 
	CHECK_PLAYER_ONE_PLAYGROUND ENDP
	
	CHECK_PLAYER_TWO_PLAYGROUND PROC NEAR
	MOV AX, 0
	CMP BALL_X, PLAYER_TWO_PLAYGROUND_X_START
	JB RET_CHECK_PLAYER_TWO_PLAYGROUND
	CMP BALL_X, PLAYER_TWO_PLAYGROUND_X_END 
	JA RET_CHECK_PLAYER_TWO_PLAYGROUND
	CMP BALL_Y, (WINDOW_HEIGHT - BALL_SIZE)	
	JB RET_CHECK_PLAYER_TWO_PLAYGROUND
	MOV AX, 1
	RET_CHECK_PLAYER_TWO_PLAYGROUND:
	RET 
	CHECK_PLAYER_TWO_PLAYGROUND ENDP
	
	
END MAIN 
