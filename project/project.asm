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
	
	;player two        
	PLAYER_TWO_X DW 309			;X position of the second player
	PLAYER_TWO_Y DW 0A0H			;Y position of the second player
	
	;player common attributes
	PLAYER_X DW ?
	PLAYER_Y DW ?
	PLAYER_WIDTH DW 0AH 			;size of the player in X direction
	PLAYER_HIGHT DW 20H 			;size of the player in Y direction
	PLAYER_VELOCITY_X DW 0AH      	;X (horizontal) velocity of the player
	PLAYER_VELOCITY_Y DW 0FH      	;Y (vertical) velocity of the player
	
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
	
		CALL ClS ;CALL CLEAR_SCREEN
			
		CHECK_TIME:
		
			MOV AH,2Ch ;get the system time
			INT 21h    ;CH = hour CL = minute DH = second DL = 1/100 seconds
			
			CMP DL,TIME_AUX  ;is the current time equal to the previous one(TIME_AUX)?
			JE CHECK_TIME    ;if it is the same, check again
			;if it's different, then draw, move, etc.
			
			MOV TIME_AUX,DL ;update time
			
			CALL CLS ;CALL CLEAR_SCREEN
			
			CALL DRAW_WALL
			MOV AX, PLAYER_ONE_X
			MOV BX, PLAYER_ONE_Y
			CALL DRAW_PLAYER    ;NOTE: this proc affects the flag registers, BE CAREFULL 
			MOV AX, PLAYER_TWO_X
			MOV BX, PLAYER_TWO_Y
			CALL DRAW_PLAYER    ;NOTE: this proc affects the flag registers, BE CAREFULL 
			CALL DRAW_BALL		; CALL DRAW_BALL 
			
			CALL MOVE_PLAYER_ONE
			CALL MOVE_PLAYER_TWO
			CALL MOVE_BALL
			
			JMP CHECK_TIME ;after everything checks time again
			
		;return the control to the dos
		MOV AH, 4CH
		INT 21H
	MAIN ENDP
	
	CLS PROC NEAR
		MOV AH,00h ;set the configuration to video mode
		MOV AL,13h ;choose the video mode
		INT 10h    ;execute the configuration 

		MOV AH,0Bh ;set the configuration
		MOV BH,00h ;to the background color
		MOV BL,00h ;choose black as background color
		INT 10h    ;execute the configuration
	CLS ENDP
	
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
	
	DRAW_PLAYER PROC NEAR
		MOV PLAYER_X, AX
		MOV PLAYER_Y, BX
		MOV CX, PLAYER_X	;X = COLUMN
		MOV DX, PLAYER_Y	;Y = ROW
			
		Draw:
			;Write graphics pixel
			MOV AH, 0CH 			;SET CONFIGURATION TO WRITE A PIXEL
			MOV AL, 0CH 			;CHOOSE PIXL COLOR
			MOV BH, 00H				;PAGE NUMBER
			INT 10H					;EXECUTE
			
			INC CX 					;CX = CX + 1
			MOV AX, CX				;TMP FOR THE SUBTRACTION
			SUB AX, PLAYER_X  	;AX = AX - PLAYER_ONE_X
			CMP AX, PLAYER_WIDTH 	;If AX - PLAYER_ONE_X > PLAYER_ONE_WIDTH
			JNG Draw 				;Go to the next line if not greater just proceed drawing horizontally
			
			MOV CX, PLAYER_X		;Start drawing from the begining in the second line
			INC DX 					;proceed to the next line i.e. DX = DX + 1
				
			MOV AX, DX				;TMP FOR THE SUBTRACTION
			SUB AX, PLAYER_Y  	;AX = AX - PLAYER_ONE_Y
			CMP AX, PLAYER_HIGHT 	;If AX - PLAYER_ONE_Y > PLAYER_ONE_HIGHT
			JNG Draw 				;exit the proc if not greater just proceed drawing
			
		RET
	DRAW_PLAYER ENDP
	
	MOVE_PLAYER_ONE PROC NEAR
		;READ CHARACTER FROM KEYBOARD
		mov ah,1
		int 16h
		JZ DONE1
		
		;down
		CMP AL, 's'
		JZ DOWN
		;Up
		CMP AL, 'w'
		JZ Up
		;Left
		CMP AL, 'a'
		JZ Left
		;Right
		CMP AL, 'd'
		JZ Right
		
		JMP DEFAULT         ;If there is no key pressed
		;Generate a move to
		Right:         
			MOV AX,PLAYER_VELOCITY_X
			ADD PLAYER_ONE_X,AX
			;avoid crossing the barrier
			MOV AX, 145
			CMP PLAYER_ONE_X, AX
			JG DECREASEX    ;If it above the limits decrease it
			DONE1:
			RET
		Left:
			MOV AX,PLAYER_VELOCITY_X
			SUB PLAYER_ONE_X,AX
			MOV AX, 0
			CMP PLAYER_ONE_X, AX
			JL INCREASEX    ;If it below the limits increase it
			RET
		Up:
			MOV AX,PLAYER_VELOCITY_Y
			SUB PLAYER_ONE_Y,AX
			CMP PLAYER_ONE_Y, 10
			JL INCREASEY   ;If it below the limits increase it
			RET
		DOWN:
			MOV AX, PLAYER_VELOCITY_Y
			ADD PLAYER_ONE_Y,AX
			CMP PLAYER_ONE_Y, 160
			JA DECREASEY   ;If it above the limits decrease it
			RET
		
		DEFAULT:           ;we have nothing to do then return the main loop
			RET
		
		;Utilities for collision correction for player one
		DECREASEX:
			MOV AX, 0AH;
			SUB PLAYER_ONE_X, AX
			RET
		INCREASEX: 
			MOV AX, 0AH;
			ADD PLAYER_ONE_X, AX
			RET
		INCREASEY: 
			ADD PLAYER_ONE_Y, AX
			RET
		DECREASEY:
			SUB PLAYER_ONE_Y, AX
			RET
			
		DONE: RET
	MOVE_PLAYER_ONE ENDP
	
	MOVE_PLAYER_TWO PROC NEAR
		;READ CHARACTER FROM KEYBOARD
		mov ah,1
		int 16h
		JZ OTHER
		mov ah,0
		int 16h
		
		;The only difference here is that we compare scan code not ascii code as previouszaq
		;down
		CMP AH, 80
		JZ DOWN_2
		;Up
		CMP AH, 72
		JZ Up_2
		;Left
		CMP AX, 4B00H
		JZ Left_2
		;Right
		CMP AH, 77
		JZ Right_2
		
		OTHER:
			RET  ;default
		;Generate a move to
		Right_2:         
			MOV AX,PLAYER_VELOCITY_X
			ADD PLAYER_TWO_X,AX
			;avoid crossing the barrier
			MOV AX, 310
			CMP PLAYER_TWO_X, AX
			JG DECREASEX_2    ;If it above the limits decrease it
			JMP DEFAULT_2
		Left_2:
			MOV AX,PLAYER_VELOCITY_X
			SUB PLAYER_TWO_X,AX
			MOV AX, 150
			CMP PLAYER_TWO_X, AX
			JL INCREASEX_2    ;If it below the limits increase it
			JMP DEFAULT_2
		Up_2:
			MOV AX,PLAYER_VELOCITY_Y
			SUB PLAYER_TWO_Y,AX
			CMP PLAYER_TWO_Y, 10
			JL INCREASEY_2    ;If it below the limits increase it
			JMP DEFAULT_2
		DOWN_2:
			MOV AX, PLAYER_VELOCITY_Y
			ADD PLAYER_TWO_Y,AX
			CMP PLAYER_TWO_Y, 160
			JA DECREASEY_2    ;If it above the limits decrease it
			JMP DEFAULT_2
		
		DEFAULT_2: 
			RET
		
		;Utilities for collision correction for player two
		DECREASEX_2:
			MOV AX, 0AH;
			SUB PLAYER_TWO_X, AX
			JMP DEFAULT_2
		INCREASEX_2: 
			MOV AX, 0AH;
			ADD PLAYER_TWO_X, AX
			JMP DEFAULT_2
		INCREASEY_2: 
			ADD PLAYER_TWO_Y, AX
			JMP DEFAULT_2
		DECREASEY_2:
			SUB PLAYER_TWO_Y, AX
			JMP DEFAULT_2
		
			RET
	MOVE_PLAYER_TWO ENDP
	
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
	
	CHECK_PLAYER_TOP_Y PROC NEAR	;Detect collision in the y-axis from top
		MOV PLAYER_X, AX			;X of the specified player (first or second)
		MOV PLAYER_Y, BX			;Y of the specified player (first or second)
		MOV AX, 0					;flag
		
		MOV DX, PLAYER_X
		SUB DX, BALL_SIZE
		CMP BALL_X, DX
		JB RET_CHECK_PLAYER_TOP_Y
		
		MOV DX, PLAYER_X
		ADD DX, PLAYER_WIDTH
		ADD DX, BALL_SIZE
		CMP BALL_X, DX 
		JA RET_CHECK_PLAYER_TOP_Y
		
		MOV DX, PLAYER_Y
		CMP BALL_Y, DX
		JB RET_CHECK_PLAYER_TOP_Y
		
		MOV DX, PLAYER_Y
		ADD DX, BALL_SIZE
		CMP BALL_Y, DX
		JA RET_CHECK_PLAYER_TOP_Y
		
		MOV AX, 1					;there is a collision
		RET_CHECK_PLAYER_TOP_Y:
		RET 
	CHECK_PLAYER_TOP_Y ENDP
	
	CHECK_PLAYER_DOWN_Y PROC NEAR	;Detect collision in the y-axis from top
		MOV PLAYER_X, AX
		MOV PLAYER_Y, BX
		MOV AX, 0
		MOV DX, PLAYER_X
		SUB DX, BALL_SIZE
		CMP BALL_X, DX
		JB RET_CHECK_PLAYER_DOWN_Y
		
		MOV DX, PLAYER_X
		ADD DX, PLAYER_WIDTH
		ADD DX, BALL_SIZE
		CMP BALL_X, DX 
		JA RET_CHECK_PLAYER_DOWN_Y
		
		MOV DX, PLAYER_Y
		ADD DX, PLAYER_HIGHT
		SUB DX, BALL_SIZE
		CMP BALL_Y, DX
		JB RET_CHECK_PLAYER_DOWN_Y
		
		MOV DX, PLAYER_Y
		ADD DX, PLAYER_HIGHT
		CMP BALL_Y, DX
		JA RET_CHECK_PLAYER_DOWN_Y
		
		MOV AX, 1
		RET_CHECK_PLAYER_DOWN_Y:
		RET 
	CHECK_PLAYER_DOWN_Y ENDP
	
	END MAIN
