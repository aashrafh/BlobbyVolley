CLS MACRO
	MOV AH,00h ;set the configuration to video mode
	MOV AL,13h ;choose the video mode
	INT 10h    ;execute the configuration 

	MOV AH,0Bh ;set the configuration
	MOV BH,00h ;to the background color
	MOV BL,00h ;choose black as background color
	INT 10h    ;execute the configuration
ENDM CLS

MOVE_BALL MACRO
		
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
	CALL CHECK_PLAYER_ONE_X
	CMP AX, 1
	JE NEG_VELOCITY_X
	
	JMP CHECK_Y
		
	NEG_VELOCITY_X:
		NEG BALL_VELOCITY_X   ;BALL_VELOCITY_X = - BALL_VELOCITY_X
	
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
	CALL CHECK_PLAYER_ONE_TOP_Y
	CMP AX, 1
	JE NEG_VELOCITY_Y
	
	CALL RET_CHECK_PLAYER_ONE_DOWN_Y
	CMP AX, 1
	JE NEG_VELOCITY_Y
	
	JMP RET_MOVE_BALL
			
	NEG_VELOCITY_Y:
		NEG BALL_VELOCITY_Y   ;BALL_VELOCITY_Y = - BALL_VELOCITY_Y
	
	RET_MOVE_BALL:
ENDM MOVE_BALL

DRAW_BALL MACRO
		
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
ENDM DRAW_BALL