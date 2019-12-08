	INCLUDE MACROS.inc

	;wall object
	EXTRN WALL:BYTE
	;player 1 object
	EXTRN PLAYER1:BYTE
	;player 2 object
	EXTRN PLAYER2:BYTE

	.MODEL SMALL
	.STACK 64
	.DATA

	;Window data	
	WINDOW_WIDTH EQU 320   ;the width of the window (320 pixels)
	WINDOW_WIDTH_HALF EQU 160
	WINDOW_HEIGHT EQU 200  ;the height of the window (200 pixels)
	WINDOW_HALF_HEIGHT EQU 100  	
	BGC EQU 11 ;Light Cyan
	LIMIT EQU 2
	WIN_LIMIT EQU 10
	TIME_AUX DB 0 ;variable used when checking if the time has changed

	;ball data
	BALL_X DW 30 ;X start position (column) of the ball 
	BALL_Y DW 100 ;Y start position (line) of the ball
	BALL_SIZE EQU 04 ;size of the ball (how many pixels does the ball have in width and height)
	BALL_VELOCITY_X DW 03 ;X (horizontal) velocity of the ball
	BALL_VELOCITY_Y DW 03 ;Y (vertical) velocity of the ball
		
	;wall data
	WALL_X EQU (WINDOW_WIDTH_HALF - WALL_WIDTH_HALF)
	WALL_Y EQU 90
	WALL_WIDTH EQU 10
	WALL_WIDTH_HALF EQU 5
	WALL_HIGHT EQU 70
	BLACK               EQU         07h ; gray
	BROWN               EQU         04h ; Red

	;score and chat data
	PLAYER1_SCORE db 0
	PLAYER2_SCORE db 0
	MAX_SCORE EQU  200
	COUNTER_END1 DB   MAX_SCORE            ;use for check who get max score
	COUNTER_END2 DB   MAX_SCORE            ;use for check who get max score


	CAHT_SIZE       EQU 24   
	CHAT1           DB ':CHAT WILL BE IN PHASE 2'
	CHAT2           DB ':CHAT WILL BE IN PHASE 2'


	WON_SIZE        EQU 10
	player1WON      DB 'PLAYER1 IS WINNWER','$'
	player2WON      DB 'PLAYER2 IS WINNWER','$'
	Border          db '------------------------------------------------------------------------------------------------------'
	CLOSE_GAME      DB 'ENTER F4 TO CLOSE GAME  ' 
	PLAY_AGIAN      DB 'PRESS 1 TO PLAY AGAIN 2 TO MAIN MAINMENUE','$'
	PLAY_AGIAN_SIZE EQU 41	 

	;deal with file
	BCGBALLWidth         EQU 320
	BCGBALLHeight        EQU 195
	BCGBALLFilename      DB 'draw.bin', 0
	BCGBALLFilehandle    DW ?
	BCGBALLData          DB BCGBALLWidth*BCGBALLHeight dup(0)
		
	;commands stings

	COMMAND_ONE   DB 'PRESS 1 TO ','$'
	COMMAND_ONE_C DB '  CHAT MODE','$'
	COMMAND_TWO   DB 'PRESS 2 TO ','$'
	COMMAND_TWO_C DB '  PLAY MODE','$'
	PHASE_2       DB 'CHAT WILL BE IN PHASE 2 PRESS ANY KEY TO START','$'
	Enter_max_letters db 'Enter 5 letters  only','$'
	PRESS1_TO_START DB 'PRESS ANY KEY TO START','$'
	;number of COMMAND 1 and 2 string chars
	CMD EQU 11
	Counter_string db CMD

	;player names
	NAME_SIZE      EQU 7
	PLAYERNAME_1 db NAME_SIZE,?,NAME_SIZE   dup('$')
	PLAYERNAME_1_MESSAGE db 'ENTER PLAYER 1 NAME ','$'
	PLAYERNAME_2 db NAME_SIZE,?,NAME_SIZE   dup('$')
	PLAYERNAME_2_MESSAGE db 'ENTER PLAYER 2 NAME ','$'
	  
	;ball data	
	CB   EQU  13   ; color of the ball
				   ; BGC defined back ground color 

	BALL         db BGC ,CB ,CB  ,BGC
				 db CB  ,CB ,CB  , CB
				 db CB  ,CB ,CB  , CB
				 db BGC ,CB ,CB  ,BGC
				 
	;player 1 data        
	PLAYER_ONE_X DW  WIN_LIMIT			;X position of the first player
	PLAYER_ONE_Y DW 136			;Y position of the first player
	OLD_X_Player1 DW WIN_LIMIT
	OLD_Y_Player1 DW 136 
	TEMP_MOVE_1   DW 00

	;player 2        
	PLAYER_TWO_X DW  (270-WIN_LIMIT)			;X position of the second player
	PLAYER_TWO_Y DW  136			;Y position of the second player
	OLD_X_Player2 DW (270-WIN_LIMIT)
	OLD_Y_Player2 DW 136 

	;player common attributes
	PLAYER_X DW ?
	PLAYER_Y DW ?
	PLAYER_WIDTH DW 21 			;size of the player in X direction
	PLAYER_HIGHT DW 24 			;size of the player in Y direction
	PLAYER_VELOCITY_X DW 21      	;X (horizontal) velocity of the player
	PLAYER_VELOCITY_Y DW 24    	;Y (vertical) velocity of the player

	;player one playground
	PLAYER_ONE_PLAYGROUND_X_START EQU BALL_SIZE
	PLAYER_ONE_PLAYGROUND_X_END   EQU (WALL_X - BALL_SIZE)

	;player two playground
	PLAYER_TWO_PLAYGROUND_X_START EQU (WALL_X + WALL_WIDTH + BALL_SIZE)
	PLAYER_TWO_PLAYGROUND_X_END   EQU (WINDOW_WIDTH - BALL_SIZE)

	.CODE
	 ; __  __     _     ___   _  _ 
	 ;|  \/  |   /_\   |_ _| | \| |
	 ;| |\/| |  / _ \   | |  | .` |
	 ;|_|  |_| /_/ \_\ |___| |_|\_|
								  
	;MAIN MENUE
	MAIN PROC FAR

		MOV AX, @DATA
		MOV DS, AX	
		Mov es,ax 

	LABELBACK:   
		Mov ah , 00h  ;change to vedio mode
		Mov Al , 13h
		int 10h
		
	;--------------------------------------------------------------read data and draw----------------------------------------------------------------
		CALL OpenFile
		CALL ReadData
		
		LEA BX , BCGBALLData ; BL contains index at the current drawn pixel
		
		MOV CX,0
		MOV DX,0
		MOV AH,0ch
		
	; Drawing loop
	drawLoop:
		MOV AL,[BX]
		INT 10h 
		INC CX
		INC BX
		CMP CX,BCGBALLWidth
	JNE drawLoop 
		
		MOV CX , 0
		INC DX
		CMP DX , BCGBALLHeight
	JNE drawLoop
		call CloseFile

	;--------------------------------------------------------------end read data and draw----------------------------------------------------------------
	print COMMAND_ONE,CMD,3,1,01
	print COMMAND_ONE_C,CMD,2,3,01
	print COMMAND_TWO,CMD,3,10,01
	print COMMAND_TWO_C,CMD,2,12,01	
		
		
	DEFAULTG:  

			MOV AH , 0      ;WAIT FOR KEY
			INT 16h
		
			CMP AL, 31h     ;CHAT MODE PHASE 2
			JE CHAT_MODE
			
			CMP AL, 32h
			JE VIDEO_MODE   ;PLAY MODE 
			
			JMP DEFAULTG
				
		CHAT_MODE:         ;Change to Text MODE

		;text mode
		MOV AH,0          
		MOV AL,03h
		INT 10h
		JMP CHAT_PHASE_2
			
		VIDEO_MODE:
		JMP GAME_MODE
			
	CHAT_PHASE_2:
				; mov cursor
				MOV AH,2
				MOV DL,5
				MOV DH,7
				INT 10H
				
				MOV AH,9
				LEA DX,PHASE_2
				INT 21H
				
				mov ah,0
				INT 16h
				jmp LABELBACK
				
	GAME_MODE:
		;text mode to take names
		MOV AH,0          
		MOV AL,03h
		INT 10h

		CALL TAKE_PLAYER_NAME
		
		Mov ah , 00h  ;change to vedio mode
		Mov Al , 13h
		int 10h
		
	start_game:
		CALL INITIALIZE_SCREEN 
		CALL INTIALIZE_SCORE
		 
		 ;print player names and chat
		 print PLAYERNAME_1,NAME_SIZE,0,0,10
		 print PLAYERNAME_2,NAME_SIZE,34,0,110
		 
		 PRINT PLAYERNAME_1,NAME_SIZE,0,21,01
		 PRINT CHAT1,CAHT_SIZE,NAME_SIZE,21,01
		 
		 PRINT PLAYERNAME_2,NAME_SIZE,0,22,01
		 PRINT CHAT2,CAHT_SIZE,NAME_SIZE,22,01	
		 PRINT BORDER,40,0,23,01
		 PRINT CLOSE_GAME,24,0,24,01

	CHECK_TIME:
		; add f4=>check to exit game(3Eh)
			
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
		;call DISPLAY_NAME 
		; Move Players
		CALL movePlayer1  ;move for player1 
		CALL movePlayer2  ;move for player2 
		
		;Move BALL and Draw it
		CLEAR BGC, BALL_X, BALL_Y, BALL_SIZE, BALL_SIZE      ;clear old poition / Cyan
		CALL MOVE_BALL
		DRAW BALL, BALL_X, BALL_Y, BALL_SIZE, BALL_SIZE		 ; CALL DRAW_BALL / yellow 
		
		CMP COUNTER_END1,0
		JE PLAYER1_WON
		CMP COUNTER_END2,0
		JE PLAYER2_WON
		
		JMP CHECK_TIME ;after everything checks time again
	PLAYER1_WON:  
			MOV AH,0          
			MOV AL,03h
			INT 10h 
			
			mov ah,2        ;move cursor 
			mov dl,5
			mov dh,5
			int 10h 
			
			MOV AH,9
			LEA DX,player1WON
			INT 21H
			
			mov ah,2        ;move cursor 
			mov dl,5
			mov dh,6
			int 10h 
		
			MOV AH,9
			LEA DX,PLAY_AGIAN 
			INT 21H
			
			MOV AH,0
			INT 16H
			CMP AL,31H
			;je far start_game       ;OUT OF RANGE
			jmp control_dos

	PLAYER2_WON:
		MOV AH,0          
		MOV AL,03h
		INT 10h 

		mov ah,2        ;move cursor 
		mov dl,5
		mov dh,5
		int 10h 
		
		MOV AH,9
		LEA DX,player2WON
		INT 21H
				
		mov ah,2        ;move cursor 
		mov dl,5
		mov dh,6
		int 10h 

		MOV AH,9
		LEA DX,PLAY_AGIAN 
		INT 21H
		
		MOV AH,0
		INT 16H
		CMP AL,31H
		
		MOV AH,0
		INT 16H
		CMP AL,31H
		;je far start_game        ;OUT OF RANGE
		jmp control_dos
		
	;return the control to the dos
	control_dos:	
		MOV AH, 4CH
		INT 21H
		
	MAIN ENDP

	 ; ___   _  _   ___   _____ 
	 ;|_ _| | \| | |_ _| |_   _|
	 ; | |  | .` |  | |    | |  
	 ;|___| |_|\_| |___|   |_|  
	 ;  ___    ___   ___   ___   ___   _  _ 
	 ;/ __|  / __| | _ \ | __| | __| | \| |
	 ;\__ \ | (__  |   / | _|  | _|  | .` |
	 ;|___/  \___| |_|_\ |___| |___| |_|\_|
																	
	INITIALIZE_SCREEN PROC
	  
		MOV AH, 06h    ; Scroll up function
		XOR AL, AL     ; Clear entire screen
		XOR CX, CX     ; Upper left corner CH=row, CL=column
		MOV CL, 0
		MOV CH, 1
		MOV DX, 184FH  ; lower right corner DH=row, DL=column 
		mov dl,4fh
		mov dh,13h
		
		MOV BH, BGC     ; color 
		INT 10H
	  
	INITIALIZE_SCREEN  ENDP
	 ; __  __    ___   __   __  ___ 
	 ;|  \/  |  / _ \  \ \ / / | __|
	 ;| |\/| | | (_) |  \ V /  | _| 
	 ;|_|  |_|  \___/    \_/   |___|
	 ; ___     _     _      _    
	 ;| _ )   /_\   | |    | |   
	 ;| _ \  / _ \  | |__  | |__ 
	 ;|___/ /_/ \_\ |____| |____|
														   
	MOVE_BALL PROC NEAR
		
		MOV AX,BALL_VELOCITY_X    
		ADD BALL_X,AX             ;move the ball horizontally
		MOV AX,BALL_VELOCITY_Y
		ADD BALL_Y,AX             ;move the ball vertically
		
		;check x
		;check window
		
		MOV AX, 4
		MOV BX, 0
		MOV CX, 8
		MOV DX, 160
		CALL CHECK_INSIDE_THIS_AREA 
		CMP SI, 1                         
		JE NEG_VELOCITY_X          
		
		MOV AX, 320
		MOV BX, 316 ;320 - 4(ball size)
		MOV CX, 8
		MOV DX, 160
		CALL CHECK_INSIDE_THIS_AREA 
		CMP SI, 1                         
		JE NEG_VELOCITY_X           
		
		;check wall x
		MOV AX, (160 + 5 + 4)
		MOV BX, (160 + 5)
		MOV CX, (90 - 4)
		MOV DX, 160
		CALL CHECK_INSIDE_THIS_AREA 
		CMP SI, 1                         
		JE NEG_VELOCITY_X           
		
		MOV AX, (160 - 5)
		MOV BX, (160 - 5 - 4)
		MOV CX, (90 - 4)
		MOV DX, 160
		CALL CHECK_INSIDE_THIS_AREA 
		CMP SI, 1                         
		JE NEG_VELOCITY_X           
		
		;CHECK_PLAYER_ONE_X
		MOV AX, PLAYER_ONE_X
		MOV BX, PLAYER_ONE_Y
		CALL CHECK_COL					;Check collision in the x-axis
		CMP AX, 1
		JE NEG_VELOCITY_X_PLAYER
		
		;CHECK_PLAYER_TWO_X
		MOV AX, PLAYER_TWO_X
		MOV BX, PLAYER_TWO_Y
		CALL CHECK_COL                ;Check collision in the x-axis
		CMP AX, 1
		JE NEG_VELOCITY_X_PLAYER
		
		JMP CHECK_Y
			
		NEG_VELOCITY_X:
			NEG BALL_VELOCITY_X   ;BALL_VELOCITY_X = - BALL_VELOCITY_X
			MOV AX, BALL_VELOCITY_X
			ADD AX, BALL_VELOCITY_X
			ADD BALL_X, AX             ;move the ball vertically
		JMP CHECK_Y

		NEG_VELOCITY_X_PLAYER:
		NEG BALL_VELOCITY_X   ;BALL_VELOCITY_X = - BALL_VELOCITY_X
		MOV AX,BALL_VELOCITY_X    
		ADD AX, 1
		ADD BALL_X,AX             ;move the ball horizontally
		
		CHECK_Y:
		
		;check top of the play window
		MOV AX, 320
		MOV BX, 0
		MOV CX, 8
		MOV DX, (8 + 4)
		CALL CHECK_INSIDE_THIS_AREA 
		CMP SI, 1                         
		JE NEG_VELOCITY_Y_1       
		
		;check wall y
		MOV AX, (160 + 5 + 4)
		MOV BX, (160 - 5 - 4)
		MOV CX, (90 - 4)
		MOV DX, 90
		CALL CHECK_INSIDE_THIS_AREA 
		CMP SI, 1                         
		JE NEG_VELOCITY_Y_1        
		
		;check player one playground
		MOV AX, (160 - 5 - 4)
		MOV BX, 4
		MOV CX, (160 - 4)
		MOV DX, 160
		CALL CHECK_INSIDE_THIS_AREA 
		CMP SI, 1                         
		;je MOVE_TO_PLAYGROUND_1	;feature
		JE PLAYER_1_PLAYGROUND

		;check player two playground
		MOV AX, (320 - 4)
		MOV BX, (160 + 5 + 4)
		MOV CX, (160 - 4)
		MOV DX, 160
		CALL CHECK_INSIDE_THIS_AREA 
		CMP SI, 1                         
		;je MOVE_TO_PLAYGROUND_2	;feature
		JE PLAYER_2_PLAYGROUND 

		JMP SKIP_1	;FOR JUMP OUT OF RANGE PROBLEM
		NEG_VELOCITY_Y_1:
		JMP NEG_VELOCITY_Y

		SKIP_1:
		;CHECK_PLAYER_ONE_Y
		MOV AX, PLAYER_ONE_X
		MOV BX, PLAYER_ONE_Y
		CALL CHECK_COL          ;Check collision in the top y-axis
		CMP AX, 1
		JE NEG_VELOCITY_Y_PLAYER
		
		; ;CHECK_PLAYER_ONE_DOWN_Y
		; MOV AX, PLAYER_ONE_X
		; MOV BX, PLAYER_ONE_Y
		; CALL CHECK_PLAYER_DOWN_Y         ;Check collision in the bottom y-axis
		; CMP AX, 1
		; JE NEG_VELOCITY_Y_PLAYER
		
		;CHECK_PLAYER_TWO_Y
		MOV AX, PLAYER_TWO_X
		MOV BX, PLAYER_TWO_Y
		CALL CHECK_COL			 ;Check collision in the top y-axis
		CMP AX, 1
		JE NEG_VELOCITY_Y_PLAYER
		
		; ;CHECK_PLAYER_TWO_DOWN_Y
		; MOV AX, PLAYER_TWO_X		     
		; MOV BX, PLAYER_TWO_Y
		; CALL CHECK_PLAYER_DOWN_Y	     ;Check collision in the bottom y-axis	
		; CMP AX, 1
		; JE NEG_VELOCITY_Y_PLAYER
		
		JMP RET_MOVE_BALL

		PLAYER_1_PLAYGROUND:
			NEG BALL_VELOCITY_Y   ;BALL_VELOCITY_Y = - BALL_VELOCITY_Y
			MOV AX, BALL_VELOCITY_Y
			ADD AX, BALL_VELOCITY_Y
			ADD BALL_Y,AX             ;move the ball vertically
			CALL INCREASE_SCORE_PLAYER2

			JMP RET_MOVE_BALL

		PLAYER_2_PLAYGROUND:
			NEG BALL_VELOCITY_Y   ;BALL_VELOCITY_Y = - BALL_VELOCITY_Y
			MOV AX, BALL_VELOCITY_Y
			ADD AX, BALL_VELOCITY_Y
			ADD BALL_Y,AX             ;move the ball vertically
			CALL INCREASE_SCORE_PLAYER1

			JMP RET_MOVE_BALL

		;this is a feature for the ball after it hit a player's playground
		;MOVE_TO_PLAYGROUND_1:
		;MOV BALL_X, 30
		;MOV BALL_Y, 30
		;JMP RET_MOVE_BALL
		
		;MOVE_TO_PLAYGROUND_2:
		;MOV BALL_X, (WINDOW_WIDTH-30)
		;MOV BALL_Y, 30
		;JMP RET_MOVE_BALL
		
		NEG_VELOCITY_Y:
			NEG BALL_VELOCITY_Y   ;BALL_VELOCITY_Y = - BALL_VELOCITY_Y
			MOV AX, BALL_VELOCITY_Y
			ADD AX, BALL_VELOCITY_Y
			ADD BALL_Y,AX             ;move the ball vertically
		JMP RET_MOVE_BALL

		NEG_VELOCITY_Y_PLAYER:
			NEG BALL_VELOCITY_Y   ;BALL_VELOCITY_Y = - BALL_VELOCITY_Y
			MOV AX, BALL_VELOCITY_Y
			ADD AX, BALL_VELOCITY_Y
			ADD BALL_Y,AX             ;move the ball vertically
		
		RET_MOVE_BALL:
		RET
	MOVE_BALL ENDP

	 ; __  __    ___   __   __  ___ 
	 ;|  \/  |  / _ \  \ \ / / | __|
	 ;| |\/| | | (_) |  \ V /  | _| 
	 ;|_|  |_|  \___/    \_/   |___|
	 ; ___   _        _    __   __  ___   ___         _ 
	 ;| _ \ | |      /_\   \ \ / / | __| | _ \       / |
	 ;|  _/ | |__   / _ \   \ V /  | _|  |   /       | |
	 ;|_|   |____| /_/ \_\   |_|   |___| |_|_\  ___  |_|
	 ;                                         |___|                                  
	movePlayer1 PROC near 
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
		
		mov bl ,al
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
			MOV AX, PLAYER_ONE_X
			ADD AX, WIN_LIMIT
			CMP AX, 135
			JG DECREASEX
		
			DONE1:
			
			jmp DONE
		Left:
			
			MOV AX,PLAYER_VELOCITY_X
			SUB PLAYER_ONE_X,AX
			MOV AX, WIN_LIMIT
			CMP PLAYER_ONE_X, AX
			JL INCREASEX
			
			jmp DONE
		Up:
			
			MOV AX,PLAYER_VELOCITY_Y
			SUB PLAYER_ONE_Y,AX
			CMP PLAYER_ONE_Y, WIN_LIMIT
			JL INCREASEY
			
			jmp DONE
		DOWN:
			
			MOV AX, PLAYER_VELOCITY_Y
			ADD PLAYER_ONE_Y,AX
			MOV BX, 159
			SUB BX, WIN_LIMIT
			CMP PLAYER_ONE_Y, BX
			JA DECREASEY
			
			jmp DONE
		
		DEFAULT: 
			jmp DONEALL
		
		DECREASEX:
			MOV AX, PLAYER_VELOCITY_X;
			SUB PLAYER_ONE_X, AX
			
			jmp DONEALL
		INCREASEX: 
			MOV AX, PLAYER_VELOCITY_X;
			ADD PLAYER_ONE_X, AX
			
			jmp DONEALL
		INCREASEY: 
			ADD PLAYER_ONE_Y, AX
			
			jmp DONEALL
		DECREASEY:
			SUB PLAYER_ONE_Y, AX
		
			jmp DONEALL
			
		DONE:	
			mov ax , PLAYER_ONE_X 
			add ax , PLAYER_ONE_Y
			
			sub ax , OLD_X_Player1
			sub ax , OLD_Y_Player1		  
		
			and ax ,ax 
			
			jz DONEALL  
			CLEAR 11, OLD_X_Player1 ,OLD_Y_Player1, PLAYER_WIDTH, PLAYER_HIGHT
				
		DONEALL:
			RET
	movePlayer1 ENDP
	; __  __    ___   __   __  ___ 
	 ;|  \/  |  / _ \  \ \ / / | __|
	 ;| |\/| | | (_) |  \ V /  | _| 
	 ;|_|  |_|  \___/    \_/   |___|
	 ; ___   _        _    __   __  ___   ___         ___ 
	 ;| _ \ | |      /_\   \ \ / / | __| | _ \       |_  )
	 ;|  _/ | |__   / _ \   \ V /  | _|  |   /        / / 
	 ;|_|   |____| /_/ \_\   |_|   |___| |_|_\  ___  /___|
	 ;                                         |___|      

	movePlayer2 PROC NEAR

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
			MOV BX, PLAYER_TWO_X
			ADD BX, WIN_LIMIT
			CMP BX, 310
			JG DECREASEX2
		
			DONE_2:
			
			jmp DONE2
		Left2:
			
			MOV AX,PLAYER_VELOCITY_X
			sub PLAYER_TWO_X,AX
			MOV AX, 165
			ADD AX, WIN_LIMIT
			CMP PLAYER_TWO_X, AX
			JL INCREASEX2
			
			jmp DONE2
		Up2:
			
			MOV AX,PLAYER_VELOCITY_Y
			SUB PLAYER_TWO_Y,AX
			CMP PLAYER_TWO_Y, WIN_LIMIT
			JL INCREASEY2
			
			jmp DONE2
		DOWN2:
			
			MOV AX, PLAYER_VELOCITY_Y
			ADD PLAYER_TWO_Y,AX
			MOV BX, 159
			SUB BX, WIN_LIMIT
			CMP PLAYER_TWO_Y, BX
			JA DECREASEY2
			
			jmp DONE2
		
		DEFAULT2: 
			jmp DONEALL2
		
		DECREASEX2:
			MOV AX, PLAYER_VELOCITY_X;
			sub PLAYER_TWO_X, AX
			
			jmp DONE2
		INCREASEX2: 
			MOV AX, PLAYER_VELOCITY_X;
			ADD PLAYER_TWO_X, AX
			
			
			jmp DONE2
		INCREASEY2: 
			ADD PLAYER_TWO_Y, AX
			
			jmp DONE2
		DECREASEY2:
			SUB PLAYER_TWO_Y, AX
		
			jmp DONE2
			
		DONE2:		
			
			mov ax , PLAYER_TWO_X 
			add ax , PLAYER_TWO_Y
			
			sub ax , OLD_X_Player2
			sub ax , OLD_Y_Player2		  
		
			and ax ,ax 
			
			jz DONEALL2  
			CLEAR 11, OLD_X_Player2 ,OLD_Y_Player2, PLAYER_WIDTH, PLAYER_HIGHT

		DONEALL2:
		RET
	movePlayer2 ENDP
	;---------------------------------------------------------------------------	
	;   ___   _  _   ___    ___   _  __
	;  / __| | || | | __|  / __| | |/ /
	; | (__  | __ | | _|  | (__  | ' < 
	;  \___| |_||_| |___|  \___| |_|\_\
	;CHECK_BALL_INSIDE_THIS_AREA
	;INPUT: 
	;AX = WINDOW X RIGHT
	;BX = WINDOW X LEFT
	;CX = WINDOW Y UP
	;DX = WINDOW Y DOWN
	;OUTPUT:
	;SI = 1 -> INSIDE
	;SI = 0 -> OUTSIDE

	CHECK_INSIDE_THIS_AREA PROC NEAR

	MOV SI, 0 ;INIT SI WITH 0

	CMP BALL_X, AX
	JA RET_CHECK

	CMP BALL_X, BX
	JB RET_CHECK

	CMP BALL_Y, CX
	JB RET_CHECK

	CMP BALL_Y, DX
	JA RET_CHECK

	MOV SI, 1 ;INSIDE!
	RET_CHECK:
	RET

	CHECK_INSIDE_THIS_AREA ENDP

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
		CMP BALL_Y, (WINDOW_HEIGHT - BALL_SIZE - 44)	  ;if it in the playground but strictly above the ground
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
		CMP BALL_Y, (WINDOW_HEIGHT - BALL_SIZE-44)	  ;if it in the playground but strictly above the ground
		JB RET_CHECK_PLAYER_TWO_PLAYGROUND        ;then no counted points
		MOV AX, 1                                 ;there is an attack
		RET_CHECK_PLAYER_TWO_PLAYGROUND:
		RET 
	CHECK_PLAYER_TWO_PLAYGROUND ENDP
	;-------------------------------------------------------------------------------	
	CHECK_COL PROC NEAR
		MOV PLAYER_X, AX 		;X of the specified player (first or second)
		MOV PLAYER_Y, BX		;Y of the specified player (first or second)
		MOV AX, 0				;flag
		;four cases to achieve collision
		;if any of them is false
		;then no collision
		
		;first condition: BALL_X < PLAYER_X + PLAYER_WIDTH
		MOV CX, PLAYER_X
		ADD CX, PLAYER_WIDTH
		CMP CX, BALL_X
		JLE FALSE
		
		;second condition: BALL_X + BALL_SIZE > PLAYER_X
		MOV CX, BALL_SIZE
		ADD CX, BALL_X
		CMP CX, PLAYER_X
		JLE FALSE
		
		;third condition: BALL_Y < PLAYER_Y + PLAYER_HIGHT
		MOV CX, PLAYER_Y
		ADD CX, PLAYER_HIGHT
		CMP CX, BALL_Y
		JLE FALSE
		
		;fourth condition: BALL_Y + BALL_SIZE > PLAYER_Y
		MOV CX, BALL_Y
		ADD CX, BALL_SIZE
		CMP CX, PLAYER_Y
		JLE FALSE
		
		;TRUE
		MOV AX, 1
		
		FALSE:
			RET
	CHECK_COL ENDP
	;intialize score

	INTIALIZE_SCORE PROC NEAR

	PLAYER1_SCORE_LABEL:
		MOV DL,9H             ;COL
		MOV DH,0              ;ROW
		MOV BH,0              ;PAGE
		MOV AH,02H
		INT 10H               ;EXECUTE MOVE CURSOR
			
		MOV BL,7              ;COLOR
		MOV AL,PLAYER1_SCORE  ;OFFSET
			
		ADD AL,'0'
		
		INC PLAYER1_SCORE
		
		MOV AH,0EH            ;EXECUTE PRINTING
		INT 10H
		mov ax,1
	PLAYER2_SCORE_LABEL:
		MOV DL,30             ;COL
		MOV DH,0              ;ROW
		MOV BH,0              ;PAGE
		MOV AH,02H
		INT 10H               ;EXECUTE MOVE CURSOR
			
		MOV BL,7              ;COLOR
		MOV AL,PLAYER2_SCORE  ;OFFSET 
		
		ADD AL,'0'
		INC PLAYER2_SCORE
		MOV AH,0EH            ;EXECUTE PRINTING
		INT 10H
		mov ax,1

	RET
	INTIALIZE_SCORE ENDP

	INCREASE_SCORE_PLAYER1 PROC NEAR

		MOV DL,9H             ;COL
		MOV DH,0              ;ROW
		MOV BH,0              ;PAGE
		MOV AH,02H
		INT 10H               ;EXECUTE MOVE CURSOR
			
		MOV BL,7              ;COLOR
		MOV AL,PLAYER1_SCORE  ;OFFSET 
		INC PLAYER1_SCORE     ;INCREMENT CURSOR
		ADD AL,'0'
		
		MOV AH,0EH            ;EXECUTE PRINTING
		INT 10H
		mov ax,1
		DEC COUNTER_END1
		;CALL CHECK_MAX_SCORE_1

	RET
	INCREASE_SCORE_PLAYER1 ENDP
	 
	INCREASE_SCORE_PLAYER2 PROC NEAR
		
		MOV DL,30             ;COL
		MOV DH,0              ;ROW
		MOV BH,0              ;PAGE
		MOV AH,02H
		INT 10H               ;EXECUTE MOVE CURSOR
			
		MOV BL,7              ;COLOR
		MOV AL,PLAYER2_SCORE  ;OFFSET 
		INC PLAYER2_SCORE     ;INCREMENT CURSOR
		ADD AL,'0'
		
		MOV AH,0EH            ;EXECUTE PRINTING
		INT 10H
		mov ax,1
		DEC COUNTER_END2
		
		;CALL CHECK_MAX_SCORE_2
		RET
	INCREASE_SCORE_PLAYER2 ENDP

	OpenFile PROC 

		; Open file

		MOV AH, 3Dh
		MOV AL, 0 ; read only
		LEA DX, BCGBALLFilename
		INT 21h
		
		; you should check carry flag to make sure it worked correctly
		; carry = 0 -> successful , file handle -> AX
		; carry = 1 -> failed , AX -> error code
		 
		MOV [BCGBALLFilehandle], AX
		RET

	OpenFile ENDP

	ReadData PROC

		MOV AH,3Fh
		MOV BX, [BCGBALLFilehandle]
		MOV CX,BCGBALLWidth*BCGBALLHeight ; number of bytes to read
		LEA DX, BCGBALLData
		INT 21h
		RET

	ReadData ENDP 

	CloseFile PROC

		MOV AH, 3Eh
		MOV BX, [BCGBALLFilehandle]

		INT 21h
		RET

	CloseFile ENDP

	TAKE_PLAYER_NAME PROC 
		;move cursor
		MOV AH,2
		MOV DL,30
		MOV DH,5
		INT 10h

			MOV AH,9
			LEA DX,Enter_max_letters
			INT 21H

	PLAYER1_MESSAGE:

		;move cursor
		MOV AH,2
		MOV DL,0
		MOV DH,10
		INT 10h
				
		MOV AH,9
		LEA DX,PLAYERNAME_1_MESSAGE
		INT 21H
		
		;ENTER PLAYER 1 NAME
		mov ah,0AH        ;Read from keyboard
		LEA dx, PLAYERNAME_1                   
		int 21h 
		
		mov ah,2          ;Move Cursor
		MOV DL,0
		MOV DH,11
		int 10h    

		;Display the input data in a new location
		mov dx, offset PLAYERNAME_1 +2
		mov ah, 9
		int 21h
		
		mov ah,2          ;Move Cursor
		MOV DL,0
		MOV DH,14
		int 10h    

	PLAYER2_MESSAGE:

		MOV AH,9
		LEA DX,PLAYERNAME_2_MESSAGE
		INT 21H

		mov ah,0AH        ;Read from keyboard
		mov dx,offset PLAYERNAME_2                   
		int 21h 
		
		mov ah,2          ;Move Cursor
		MOV DL,0
		MOV DH,15
		int 10h  	
		
		mov dx, offset PLAYERNAME_2 +2;Display the input data in a new location
		mov ah, 9
		int 21h
		
		mov ah,2          ;Move Cursor
		MOV DL,0
		MOV DH,17
		int 10h  	
			
		mov dx, offset PRESS1_TO_START
		mov ah, 9
		int 21h 
			
		MOV AH , 0
		INT 16h
		
	RET
	TAKE_PLAYER_NAME ENDP

	END MAIN 
		






