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
	
	;;;;;;;;;;;;;;;;;           Player One           ;;;;;;;;;;;;;;;;;         
	PlayerOneX DW 0H   			;X position of the first player
	PlayerOneY DW 0A0H			;Y position of the first player
	PlayerOneXSize DW 0AH 		;size of the first player in X direction
	PlayerOneYSize DW 14H 		;size of the first player in Y direction
	PlayerVelocityX DW 0AH      ;X (horizontal) velocity of the player
	PlayerVelocityY DW 0FH      ;Y (vertical) velocity of the player
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
			CALL DrawFirstPlayer    ;NOTE: this proc affects the flag registers, BE CAREFULL 
			CALL movePLayer			;get move from the user using the keyboard
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
	
	DrawFirstPlayer PROC NEAR
		MOV CX, PlayerOneX	;X = COLUMN
		MOV DX, PlayerOneY	;Y = ROW
			
		Draw:
			;Write graphics pixel
			MOV AH, 0CH 			;SET CONFIGURATION TO WRITE A PIXEL
			MOV AL, 0CH 			;CHOOSE PIXL COLOR
			MOV BH, 00H				;PAGE NUMBER
			INT 10H					;EXECUTE
			
			INC CX 					;CX = CX + 1
			MOV AX, CX				;TMP FOR THE SUBTRACTION
			SUB AX, PlayerOneX  	;AX = AX - PlayerOneX
			CMP AX, PlayerOneXSize 	;If AX - PlayerOneX > PlayerOneXSize
			JNG Draw 				;Go to the next line if not greater just proceed drawing horizontally
			
			MOV CX, PlayerOneX		;Start drawing from the begining in the second line
			INC DX 					;proceed to the next line i.e. DX = DX + 1
				
			MOV AX, DX				;TMP FOR THE SUBTRACTION
			SUB AX, PlayerOneY  	;AX = AX - PlayerOneY
			CMP AX, PlayerOneYSize 	;If AX - PlayerOneY > PlayerOneYSize
			JNG Draw 				;exit the proc if not greater just proceed drawing
			
		RET
	DrawFirstPlayer ENDP
	
	movePLayer PROC NEAR
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
			MOV AX,PlayerVelocityX
			ADD PlayerOneX,AX
			MOV AX, 100
			CMP PlayerOneX, AX
			JG DECREASEX
			RET
		Left:
			MOV AX,PlayerVelocityX
			SUB PlayerOneX,AX
			MOV AX, 5
			CMP PlayerOneX, AX
			JL INCREASEX
			RET
		Up:
			MOV AX,PlayerVelocityY
			SUB PlayerOneY,AX
			MOV AX, 5
			CMP PlayerOneY, AX
			JL INCREASEY
			RET
		
		DEFAULT: 
			RET
		
		DECREASEX:
			MOV AX, 0AH;
			SUB PlayerOneX, AX
			RET
		INCREASEX: 
			MOV AX, 0AH;
			ADD PlayerOneX, AX
			RET
		INCREASEY: 
			MOV AX, 0AH;
			ADD PlayerOneY, AX
			RET
			
		DONE: RET
	movePlayer ENDP
	
	PUSHA_UD PROC NEAR
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX
	
	PUSHF
	
	RET
	PUSHA_UD ENDP
	
	POPA_UD PROC NEAR
	POPF
	
	PUSH DX
	PUSH CX
	PUSH BX
	PUSH AX
	
	RET
	POPA_UD ENDP
	
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
