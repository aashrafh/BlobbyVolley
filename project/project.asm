	
	INCLUDE MACROS.inc
;	INCLUDE SyncMacros.inc

	;wall object
	EXTRN WALL:BYTE
	;player 1 object
	EXTRN PLAYER1:BYTE
	;player 2 object
	EXTRN PLAYER2:BYTE

	; INCLUDE SyncMacros.inc
	.MODEL SMALL
	.STACK 64
	.386
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
	PLAYER_SCORE db 0


	MAX_SCORE EQU  4

	COUNTER_END1 DB   MAX_SCORE            ;use for check who get max score
	COUNTER_END2 DB   MAX_SCORE            ;use for check who get max score


	CAHT_SIZE       EQU 24   
	CHAT1           DB ':CHAT WILL BE IN PHASE 2'
	CHAT2           DB ':CHAT WILL BE IN PHASE 2'


	WON_SIZE        EQU 10
 
	
	player1WON       db 'PLAYER 1 IS WINNER','$' 
	player2WON       db 'PLAYER 2 IS WINNER','$'
	
	; player1WON     db'__________.____                                 ____   __      __'              
                   ; db'\______   \    |   _____  ___.__. ___________  /_   | /  \    /  \____   ____'  
                   ; db'|     ___/    |   \__  \<   |  |/ __ \_  __ \   |   | \   \/\/   /  _ \ /    \ '
                   ; db' |    |   |    |___ / __ \\___  \  ___/|  | \/  |   |  \        (  <_> )   |  \ '
                   ; db' |____|   |_______ (____  / ____|\___  >__|     |___|   \__/\  / \____/|___|  /'
                   ; db'                  \/    \/\/         \/                      \/             \/ ' ,'$'
 

 
	
	 ;player2WON  db'__________.____                                ________    __      __'              
				; db'\______   \    |   _____  ___.__. ___________  \_____  \  /  \    /  \____   ____ ' 
				; db' |     ___/    |   \__  \<   |  |/ __ \_  __ \  /  ____/  \   \/\/   /  _ \ /    \ '
				; db' |    |   |    |___ / __ \\___  \  ___/|  | \/ /       \   \        (  <_> )   |  \ '
				; db' |____|   |_______ (____  / ____|\___  >__|    \_______ \   \__/\  / \____/|___|  / '
				; db'                  \/    \/\/         \/                \/        \/             \/  ','$'

	
	
	
	
	
	
	Border          db '------------------------------------------------------------------------------------------------------'
	CLOSE_GAME      DB 'ENTER F4 TO CLOSE GAME  ' 
	PLAY_AGIAN      DB 'PRESS 1 TO PLAY AGAIN ANY KEY TO MAIN MAINMENUE','$'
	PLAY_AGIAN_SIZE EQU 41	 

    CHOOSE_LEVEL   DB 'CHOOSE LEVEL GAME PRESS 1 TO LEVEL 1  PRESS 2 TO LEVEL 2','$'
	

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
	PLAYER_ONE_Y DW 135		;Y position of the first player
	OLD_X_Player1 DW WIN_LIMIT
	OLD_Y_Player1 DW 135 
	TEMP_movE_1   DW 00

	;player 2        
	PLAYER_TWO_X DW  (269-WIN_LIMIT)			;X position of the second player
	PLAYER_TWO_Y DW  135			;Y position of the second player
	OLD_X_Player2 DW (270-WIN_LIMIT)
	OLD_Y_Player2 DW 135 

	;player common attributes
	PLAYER_X DW ?
	PLAYER_Y DW ?
	PLAYER_WIDTH DW 22 			;size of the player in X direction
	PLAYER_HIGHT DW 25 			;size of the player in Y direction
	PLAYER_VELOCITY_X DW 6     	;X (horizontal) velocity of the player
	PLAYER_VELOCITY_Y DW 3    	;Y (vertical) velocity of the player
    PLAYER_OUTER_VELOCITY DW 10
   


    D_X  DW 00             ;change in x direction
    D_Y  DW 00             ;change in y ditecttion  
	
    D_X_2  DW 00             ;change in x direction
    D_Y_2  DW 00             ;change in y ditecttion  

	;player one playground
	PLAYER_ONE_PLAYGROUND_X_START EQU BALL_SIZE
	PLAYER_ONE_PLAYGROUND_X_END   EQU (WALL_X - BALL_SIZE)

	;player two playground
	PLAYER_TWO_PLAYGROUND_X_START EQU (WALL_X + WALL_WIDTH + BALL_SIZE)
	PLAYER_TWO_PLAYGROUND_X_END   EQU (WINDOW_WIDTH - BALL_SIZE)

	;data for chat
	CharSent db '$'
	CharReceived db '$'
	UpCursorx db 0
	UpCursory db 0
	DownCursorx db 0
	DownCursory db 13
	Up_Chat equ 1
	Down_Chat equ 2

	UpColor equ 77
	DownColor equ 07

	.CODE
	 ; __  __     _     ___   _  _ 
	 ;|  \/  |   /_\   |_ _| | \| |
	 ;| |\/| |  / _ \   | |  | .` |
	 ;|_|  |_| /_/ \_\ |___| |_|\_|
								  
	;MAIN MENUE
MAIN PROC FAR

		mov AX, @DATA
		mov DS, AX	
		mov es,ax 

	LABELBACK:   
		mov ah , 00h  ;change to vedio mode
		mov Al , 13h
		int 10h
		
	;--------------------------------------------------------------read data and draw----------------------------------------------------------------


		CALL OpenFile
		CALL Readdata
		LEA BX , BCGBALLData ; BL contains index at the current drawn pixel
		
		
		mov CX,0
		mov DX,0
		mov AH,0ch
		
	; Drawing loop
	drawLoop:
		mov AL,[BX]
		INT 10h 
		INC CX
		INC BX
		cmp CX,BCGBALLWidth
	JNE drawLoop 
		
		mov CX , 0
		INC DX
		cmp DX , BCGBALLHeight
	JNE drawLoop
		call CloseFile

	jmp LBLBACK_dummy
	LBLBACK_dummy0:
	jmp LABELBACK
	LBLBACK_dummy:

	;--------------------------------------------------------------end read data and draw----------------------------------------------------------------
	print COMMAND_ONE,CMD,3,1,04
	print COMMAND_ONE_C,CMD,2,3,04
	print COMMAND_TWO,CMD,3,10,04
	print COMMAND_TWO_C,CMD,2,12,04	
			
	CALL InitializUART
	DEFAULTG:   
			

        lop1: 
		    call Receive_Action
			cmp CharReceived ,'$'
			jne lop2 
			
			call Send_Action
			cmp CharReceived ,'$'
			jne lop3 

			jmp lop1 

        lop2:
		    call Send_Action
			mov al , CharSent 
			cmp al ,CharReceived
			je start_game 
			jmp lop2


		lop3:
		    call Receive_Action
			mov al , CharReceived 
			cmp al ,CharSent
			je start_game 
			jmp lop3	
				
	CHAT_MODE:         ;Change to Text MODE

		;initialize
		call InitializScreen
		; call InitializUART
		
		;(
			mov si, 0
		Again:	
			call send
			cmp si, 1
			je LBLBACK_dummy0
			call Receive
			cmp si, 1
			je LBLBACK_dummy0
			jmp Again
		;)	
	
		
		
		
		
	VIDEO_MODE:
		;text mode to take names
		mov AH,0          
		mov AL,03h
	
	LEVEL_GAME:	
		MOV AH,0          
		MOV AL,03h
		INT 10h
		MOV AH,9
		LEA DX,CHOOSE_LEVEL
        INT 21H		

		MOV AH,0
		INT 16H
		
		CMP AL,31H
		JE LEVEL1
		CMP AL,32H
		JE LEVEL2
		
		JMP LEVEL_GAME
		
		LEVEL1:
		MOV BALL_VELOCITY_X,2
		MOV BALL_VELOCITY_Y,2
		
		MOV PLAYER_VELOCITY_X,6
		MOV PLAYER_VELOCITY_Y,6
		
		
		JMP TAKE_NAMES
		LEVEL2:
		MOV BALL_VELOCITY_X,4
		MOV BALL_VELOCITY_Y,4
		
		MOV PLAYER_VELOCITY_X,1
		MOV PLAYER_VELOCITY_Y,1
		
		
		;text mode to take names
	TAKE_NAMES:
	     MOV AH,0          
		MOV AL,03h
		INT 10h
      
		CALL TAKE_PLAYER_NAME
		
		mov ah , 00h  ;change to vedio mode
		mov Al , 13h
		int 10h
		
	start_game:
     	mov ah , 00h  ;change to vedio mode
		mov Al , 13h
		int 10h
		CALL INITIALIZE_SCREEN 
		CALL INTIALIZE_SCORE
	   
		 ;print player names and chat
		 print PLAYERNAME_1,NAME_SIZE,0,0,10
		 print PLAYERNAME_2,NAME_SIZE,23,0,110
		 
		 PRINT PLAYERNAME_1,NAME_SIZE,0,21,10
		 PRINT CHAT1,CAHT_SIZE,NAME_SIZE,21,10
		 
		 PRINT PLAYERNAME_2,NAME_SIZE,0,22,110
		 PRINT CHAT2,CAHT_SIZE,NAME_SIZE,22,110	
		 PRINT BORDER,40,0,23,01
		 PRINT CLOSE_GAME,24,0,24,04

	CHECK_TIME:
		; add f4=>check to exit game(3Eh)
		;Uncomment for F4 feature
		
	    ; call InitializUART

		mov ah,1
		int 16h

		JNZ DUMMY2

		CHECK_TIME_CONTINUE:

		mov AH,2Ch ;get the system time
		INT 21h    ;CH = hour CL = minute DH = second DL = 1/100 seconds
		
		cmp DL,TIME_AUX  ;is the current time equal to the previous one(TIME_AUX)?
		JE CHECK_TIME    ;if it is the same, check again
						 ;if it's different, then draw, move, etc.
		
		mov TIME_AUX,DL ;update time
		
		;DRAW the Wall
		DRAW WALL, WALL_X, WALL_Y, WALL_WIDTH, WALL_HIGHT     ;Macro to draw wall

		;Uncomment for F4 feature
		JMP CONTINUE
		DUMMY2:
		JMP PRESSED_A_BUTTON
		CONTINUE:
		
		; Draw Players 
		DRAW PLAYER1, PLAYER_ONE_X, PLAYER_ONE_Y, PLAYER_WIDTH, PLAYER_HIGHT    
		DRAW PLAYER2, PLAYER_TWO_X, PLAYER_TWO_Y, PLAYER_WIDTH, PLAYER_HIGHT
		;call DISPLAY_NAME 
		
		;move BALL and Draw it
		CLEAR BGC, BALL_X, BALL_Y, BALL_SIZE, BALL_SIZE      ;clear old poition / Cyan
		CALL MOVE_BALL
		DRAW BALL, BALL_X, BALL_Y, BALL_SIZE, BALL_SIZE		 ; CALL DRAW_BALL / yellow
		
		; move Players
		CALL movePlayer1  ;move for player1 
		CALL movePlayer2  ;move for player2  
		
		cmp COUNTER_END1,0
		JE PLAYERWON
		cmp COUNTER_END2,0
		JE PLAYERWON
		
		JMP CHECK_TIME ;after everything checks time again
		
		;Uncomment for F4 feature
		PRESSED_A_BUTTON:
		cmp AH, 3Eh
		JE IS_F4

		jmp CHECK_TIME_CONTINUE
		
		IS_F4:
		;consume the char
		mov ah, 0
		int 16h
		mov COUNTER_END1,MAX_SCORE
		mov COUNTER_END2,MAX_SCORE

		mov PLAYER1_SCORE,0
		mov PLAYER2_SCORE,0
		
		JMP LABELBACK

		DUMMY0: ;for jump out of range problem
		jmp VIDEO_MODE

		DUMMY1:
		jmp LABELBACK

	PLAYERWON:  
		mov AH,0          
		mov AL,03h
		INT 10h 
		
		mov ah,2        ;move cursor 
		mov dl,5
		mov dh,5
		int 10h 
		

		cmp COUNTER_END1,0
		jne PLAYER1_DIDNT_WIN

		mov AH,9
		LEA DX,player1WON
		INT 21H

		JMP RESET_won
		PLAYER1_DIDNT_WIN:
		
		mov AH,9
		LEA DX,player2WON
		INT 21h
	
		RESET_won:
        mov ah,2        ;move cursor 
		mov dl,10
		mov dh,10
		int 10h 
		
		mov AH,9
		LEA DX,PLAY_AGIAN 
		INT 21H
		
	mov COUNTER_END1,MAX_SCORE
	mov COUNTER_END2,MAX_SCORE

	mov PLAYER1_SCORE,0
	mov PLAYER2_SCORE,0
	
	mov AH,0
	INT 16H

	cmp AL,31H
	je  DUMMY0        ;OUT OF RANGE
	
	jmp  DUMMY1          ;main menue


	;return the control to the dos
	; control_dos:	
		; mov AH, 4CH
		; INT 21H
		
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
	
	mov AH, 06h    ; Scroll up function
	XOR AL, AL     ; Clear entire screen
	XOR CX, CX     ; Upper left corner CH=row, CL=column
	mov CL, 0
	mov CH, 1
	mov DX, 184FH  ; lower right corner DH=row, DL=column 
	mov dl,4fh
	mov dh,13h
	
	mov BH, BGC     ; color 
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
		
		mov AX,BALL_VELOCITY_X    
		add BALL_X,AX             ;move the ball horizontally
		mov AX,BALL_VELOCITY_Y
		add BALL_Y,AX             ;move the ball vertically
		
		;check x
		;check window
		
		mov AX, 4
		mov BX, 0
		mov CX, 8
		mov DX, 160
		CALL CHECK_INSIDE_THIS_AREA 
		cmp SI, 1                         
		JE NEG_VELOCITY_X          
		
		mov AX, 320
		mov BX, 316 ;320 - 4(ball size)
		mov CX, 8
		mov DX, 160
		CALL CHECK_INSIDE_THIS_AREA 
		cmp SI, 1                         
		JE NEG_VELOCITY_X           
		
		;check wall x
		mov AX, (160 + 5 + 4)
		mov BX, (160 + 5)
		mov CX, (90 - 4)
		mov DX, 160
		CALL CHECK_INSIDE_THIS_AREA 
		cmp SI, 1                         
		JE NEG_VELOCITY_X           
		
		mov AX, (160 - 5)
		mov BX, (160 - 5 - 4)
		mov CX, (90 - 4)
		mov DX, 160
		CALL CHECK_INSIDE_THIS_AREA 
		cmp SI, 1                         
		JE NEG_VELOCITY_X           
		
		;CHECK_PLAYER_ONE_X
		mov AX, PLAYER_ONE_X
		mov BX, PLAYER_ONE_Y
		CALL CHECK_COL					;Check collision in the x-axis
		cmp AX, 1
		JE NEG_VELOCITY_X_PLAYER
		
		;CHECK_PLAYER_TWO_X
		mov AX, PLAYER_TWO_X
		mov BX, PLAYER_TWO_Y
		CALL CHECK_COL                ;Check collision in the x-axis
		cmp AX, 1
		JE NEG_VELOCITY_X_PLAYER
		
		JMP CHECK_Y
			
		NEG_VELOCITY_X:
			NEG BALL_VELOCITY_X   ;BALL_VELOCITY_X = - BALL_VELOCITY_X
			mov AX, BALL_VELOCITY_X
			add AX, BALL_VELOCITY_X
			add BALL_X, AX             ;move the ball vertically
		JMP CHECK_Y

		NEG_VELOCITY_X_PLAYER:
		NEG BALL_VELOCITY_X   ;BALL_VELOCITY_X = - BALL_VELOCITY_X
		mov AX,BALL_VELOCITY_X    
		add AX, 1
		add BALL_X,AX             ;move the ball horizontally
		
		CHECK_Y:
		
		;check top of the play window
		mov AX, 320
		mov BX, 0
		mov CX, 8
		mov DX, (8 + 4)
		CALL CHECK_INSIDE_THIS_AREA 
		cmp SI, 1                         
		JE NEG_VELOCITY_Y_1       
		
		;check wall y
		mov AX, (160 + 5 + 4)
		mov BX, (160 - 5 - 4)
		mov CX, (90 - 4)
		mov DX, 90
		CALL CHECK_INSIDE_THIS_AREA 
		cmp SI, 1                         
		JE NEG_VELOCITY_Y_1        
		
		;check player one playground
		mov AX, (160 - 5 - 4)
		mov BX, 4
		mov CX, (160 - 4)
		mov DX, 160
		CALL CHECK_INSIDE_THIS_AREA 
		cmp SI, 1                         
		;je movE_TO_PLAYGROUND_1	;feature
		JE PLAYER_1_PLAYGROUND

		;check player two playground
		mov AX, (320 - 4)
		mov BX, (160 + 5 + 4)
		mov CX, (160 - 4)
		mov DX, 160
		CALL CHECK_INSIDE_THIS_AREA 
		cmp SI, 1                         
		;je movE_TO_PLAYGROUND_2	;feature
		JE PLAYER_2_PLAYGROUND 

		JMP SKIP_1	;FOR JUMP OUT OF RANGE PROBLEM
		NEG_VELOCITY_Y_1:
		JMP NEG_VELOCITY_Y

		SKIP_1:
		;CHECK_PLAYER_ONE_Y
		mov AX, PLAYER_ONE_X
		mov BX, PLAYER_ONE_Y
		CALL CHECK_COL          ;Check collision in the top y-axis
		cmp AX, 1
		JE NEG_VELOCITY_Y_PLAYER
		
		; ;CHECK_PLAYER_ONE_DOWN_Y
		; mov AX, PLAYER_ONE_X
		; mov BX, PLAYER_ONE_Y
		; CALL CHECK_PLAYER_DOWN_Y         ;Check collision in the bottom y-axis
		; cmp AX, 1
		; JE NEG_VELOCITY_Y_PLAYER
		
		;CHECK_PLAYER_TWO_Y
		mov AX, PLAYER_TWO_X
		mov BX, PLAYER_TWO_Y
		CALL CHECK_COL			 ;Check collision in the top y-axis
		cmp AX, 1
		JE NEG_VELOCITY_Y_PLAYER
		
		; ;CHECK_PLAYER_TWO_DOWN_Y
		; mov AX, PLAYER_TWO_X		     
		; mov BX, PLAYER_TWO_Y
		; CALL CHECK_PLAYER_DOWN_Y	     ;Check collision in the bottom y-axis	
		; cmp AX, 1
		; JE NEG_VELOCITY_Y_PLAYER
		
		JMP RET_MOVE_BALL

		PLAYER_1_PLAYGROUND:
			NEG BALL_VELOCITY_Y   ;BALL_VELOCITY_Y = - BALL_VELOCITY_Y
			mov AX, BALL_VELOCITY_Y
			add AX, BALL_VELOCITY_Y
			add BALL_Y,AX             ;move the ball vertically
			CALL INCREASE_SCORE_PLAYER2

		    CALL REC_CHOICE_SYNC
			MOV Al, CharReceived
			MOV PLAYER2_SCORE, AL

			JMP RET_MOVE_BALL

		PLAYER_2_PLAYGROUND:
			NEG BALL_VELOCITY_Y   ;BALL_VELOCITY_Y = - BALL_VELOCITY_Y
			mov AX, BALL_VELOCITY_Y
			add AX, BALL_VELOCITY_Y
			add BALL_Y,AX             ;move the ball vertically
			CALL INCREASE_SCORE_PLAYER1
			MOV AL, PLAYER1_SCORE
			MOV CharSent, AL
			CALL SEND_CHOICE_SYNC

			JMP RET_MOVE_BALL

		;this is a feature for the ball after it hit a player's playground
		;movE_TO_PLAYGROUND_1:
		;mov BALL_X, 30
		;mov BALL_Y, 30
		;JMP RET_MOVE_BALL
		
		;movE_TO_PLAYGROUND_2:
		;mov BALL_X, (WINDOW_WIDTH-30)
		;mov BALL_Y, 30
		;JMP RET_MOVE_BALL
		
		NEG_VELOCITY_Y:
			NEG BALL_VELOCITY_Y   ;BALL_VELOCITY_Y = - BALL_VELOCITY_Y
			mov AX, BALL_VELOCITY_Y
			add AX, BALL_VELOCITY_Y
			add BALL_Y,AX             ;move the ball vertically
		JMP RET_MOVE_BALL

		NEG_VELOCITY_Y_PLAYER:
			NEG BALL_VELOCITY_Y   ;BALL_VELOCITY_Y = - BALL_VELOCITY_Y
			mov AX, BALL_VELOCITY_Y
			add AX, BALL_VELOCITY_Y
			add BALL_Y,AX             ;move the ball vertically
		
		RET_MOVE_BALL:
		mov AL , BALL_X 
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
;------------------------------------------------------------	
movePlayer1 PROC near 
	;READ CHARACTER FROM KEYBOARD
	; mov ah,1
	; int 16h
	; JZ DONE1
	; ; mov ah,0
	; ; int 16h
    call Send_Action
	
	mov bl ,al
	mov al ,CharSent

		cmp al, 115
		JZ DOWN
		;Up
		cmp al, 119
		JZ Up
		;Left
		cmp al, 097
		JZ Left
		;Right
		cmp al, 100
		JZ Right
	
	JMP DEFAULT
	
	Right:
		mov ax , 0
		inc ax
		mov [D_X],ax
		
		
		mov AX ,PLAYER_WIDTH
		add AX ,PLAYER_ONE_X
		
		;check wall
		cmp AX , (WALL_X-5)
		JG DEFAULT
	
		DONE1:
		
		jmp DONE
	Left:
	    mov ax , 0
		dec ax
		mov [D_X],ax
		
		;check left screen
		mov AX ,PLAYER_ONE_X
		cmp AX , 10
		JL DEFAULT
		
		jmp DONE
	Up:
		mov ax , 0
		dec ax
		mov [D_Y],ax
		
		mov AX , PLAYER_ONE_Y
		cmp AX , 20
		
		JL DEFAULT
		
		jmp DONE
	DOWN:
		mov ax , 0
			inc ax
			mov [D_Y],ax
			
			mov AX ,PLAYER_ONE_Y
			add AX ,PLAYER_HIGHT
			cmp AX , 155 
			
			JA DEFAULT
			
			jmp DONE
	DEFAULT: 
		jmp DONEALL
	
	
	DONE:	
	
		
    
	mov cx ,00     ;intialize counter for change loop 
	
	;this loop moves the player pixel by Pixel
	Change:
	        
			
			Draw PLAYER1 , (PLAYER_ONE_X) , (PLAYER_ONE_Y) ,PLAYER_WIDTH ,PLAYER_HIGHT

			mov SI , PLAYER_ONE_X
			add SI , D_X
			mov [PLAYER_ONE_X] , SI
			
		    mov SI , PLAYER_ONE_Y
			add SI , D_Y
			mov [PLAYER_ONE_Y] , SI
			
			inc cx
            cmp cx , PLAYER_OUTER_VELOCITY
			je DONEALL
			
				
            jmp change	
		
		
			
	DONEALL:
	    ;CLEAR 11, OLD_X_Player1 ,OLD_Y_Player1, PLAYER_WIDTH,PLAYER_HIGHT
	    mov ax ,00
	    mov [D_X] ,ax
	    mov [D_Y] ,ax
		RET
movePlayer1 ENDP
;--------------------------------------------------------------------
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
		; mov ah,1
		; int 16h
		; JZ DONE_2
		; mov ah,0
		; int 16h
		
		; mov SI , PLAYER_TWO_X
		; mov DI , PLAYER_TWO_Y
		
		; mov [OLD_X_Player2],SI
		; mov [OLD_Y_Player2],DI
		call Receive_Action
		;The only difference here is that we compare scan code not ascii code as previouszaq
		;down
		; mov AX , CharReceived
		; cmp Ax, 80
		; JZ DOWN2
		; ;Up
		; cmp Ax, 72
		; JZ Up2
		; ;Left
		; cmp AX, 4B00H
		; JZ Left2
		; ;Right
		; cmp Ax, 77
		; JZ Right2
		mov al ,CharReceived

		cmp al, 115
		JZ DOWN2
		;Up
		cmp al, 119
		JZ Up2
		;Left
		cmp al, 097
		JZ Left2
		;Right
		cmp al, 100
		JZ Right2

		JMP DEFAULT2
		
		Right2:
			
			mov ax , 0
			inc ax
			mov [D_X_2],ax
			
			add AX ,PLAYER_TWO_X
			add AX ,PLAYER_WIDTH
			
			;check wall
			cmp AX ,315
			JG DEFAULT2
			
			DONE_2:
			
			jmp DONE2
		Left2:
			
		    mov ax , 0
			dec ax
			mov [D_X_2],ax
			
			;check left screen
			mov AX ,PLAYER_TWO_X
	        
			cmp AX , (WALL_X+WALL_WIDTH+10)
			JL DEFAULT2
			
			jmp DONE2
		Up2:
			
			mov ax , 0
			dec ax
			mov [D_Y_2],ax
			
			mov AX , PLAYER_TWO_Y
			cmp AX , 20
			
		    JL DEFAULT2
		
			jmp DONE2
		DOWN2:
			
			mov ax , 0
			inc ax
			mov [D_Y_2],ax
			
			mov AX ,PLAYER_TWO_Y
			add AX ,PLAYER_HIGHT
			cmp AX , 155 
			
			JA DEFAULT2
			
			jmp DONE2
		
		DEFAULT2: 
			jmp DONEALL2
		
		
		DONE2:		
			
			
		mov cx ,00	
		Change2:
	        
			
			Draw PLAYER2 , (PLAYER_TWO_X) , (PLAYER_TWO_Y) ,PLAYER_WIDTH ,PLAYER_HIGHT

			mov SI , PLAYER_TWO_X
			add SI , D_X_2
			mov [PLAYER_TWO_X] , SI
			
		    mov SI , PLAYER_TWO_Y
			add SI , D_Y_2
			mov [PLAYER_TWO_Y] , SI
			
			inc cx
            cmp cx , PLAYER_OUTER_VELOCITY
			je DONEALL2
			
				
            jmp change2	
			

		DONEALL2:
		  mov ax ,00
	      mov [D_X_2] ,ax
	      mov [D_Y_2] ,ax
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

	mov SI, 0 ;INIT SI WITH 0

	cmp BALL_X, AX
	JA RET_CHECK

	cmp BALL_X, BX
	JB RET_CHECK

	cmp BALL_Y, CX
	JB RET_CHECK

	cmp BALL_Y, DX
	JA RET_CHECK

	mov SI, 1 ;INSIDE!
	RET_CHECK:
	RET

CHECK_INSIDE_THIS_AREA ENDP

;Collision with the wall in the x-axis
CHECK_WALL_X PROC NEAR
	mov AX, 0
	cmp BALL_X, (WALL_X - BALL_SIZE)   ;check collision in the left side
	JB RETURN
	cmp BALL_X, (WALL_X + WALL_WIDTH + BALL_SIZE)   ;check collision in the right side
	JA RETURN
	cmp BALL_Y, WALL_Y                 ;check collision in the top side
	JB RETURN
	mov AX, 1  ;there is a collision
	RETURN:
	RET 
CHECK_WALL_X ENDP
;--------------------------------------------------------------------------	
;Collision with the wall in the y-axis
CHECK_WALL_Y PROC NEAR
	mov AX, 0
	cmp BALL_X, (WALL_X - BALL_SIZE)   ;check collision in the left side
	JB RET_CHECK_WALL_Y
	cmp BALL_X, (WALL_X + WALL_WIDTH + BALL_SIZE)    ;check collision in the right side
	JA RET_CHECK_WALL_Y
	cmp BALL_Y, WALL_Y                 ;check collision in the top side
	JB RET_CHECK_WALL_Y
	cmp BALL_Y, (WALL_Y + BALL_SIZE)   ;check collision in the top side
	JA RET_CHECK_WALL_Y
	mov AX, 1  ;there is a collision
	RET_CHECK_WALL_Y:
	RET 
CHECK_WALL_Y ENDP
;----------------------------------------------------------------------------	
CHECK_PLAYER_ONE_PLAYGROUND PROC NEAR         ;Check if the second player attack the first player
	mov AX, 0
	cmp BALL_X, PLAYER_ONE_PLAYGROUND_X_START ;out of the playground
	JB RET_CHECK_PLAYER_ONE_PLAYGROUND
	cmp BALL_X, PLAYER_ONE_PLAYGROUND_X_END   ;out of the playground
	JA RET_CHECK_PLAYER_ONE_PLAYGROUND
	cmp BALL_Y, (WINDOW_HEIGHT - BALL_SIZE - 44)	  ;if it in the playground but strictly above the ground
	JB RET_CHECK_PLAYER_ONE_PLAYGROUND        ;then no counted points
	mov AX, 1                                 ;there is an attack
	RET_CHECK_PLAYER_ONE_PLAYGROUND:
	RET 
CHECK_PLAYER_ONE_PLAYGROUND ENDP
;-----------------------------------------------------------------------------	
CHECK_PLAYER_TWO_PLAYGROUND PROC NEAR         ;Check if the first player attack the second player
	mov AX, 0
	cmp BALL_X, PLAYER_TWO_PLAYGROUND_X_START ;out of the playground
	JB RET_CHECK_PLAYER_TWO_PLAYGROUND
	cmp BALL_X, PLAYER_TWO_PLAYGROUND_X_END   ;out of the playground
	JA RET_CHECK_PLAYER_TWO_PLAYGROUND 
	cmp BALL_Y, (WINDOW_HEIGHT - BALL_SIZE-44)	  ;if it in the playground but strictly above the ground
	JB RET_CHECK_PLAYER_TWO_PLAYGROUND        ;then no counted points
	mov AX, 1                                 ;there is an attack
	RET_CHECK_PLAYER_TWO_PLAYGROUND:
	RET 
CHECK_PLAYER_TWO_PLAYGROUND ENDP
;-------------------------------------------------------------------------------	
CHECK_COL PROC NEAR
	mov PLAYER_X, AX 		;X of the specified player (first or second)
	mov PLAYER_Y, BX		;Y of the specified player (first or second)
	mov AX, 0				;flag
	;four cases to achieve collision
	;if any of them is false
	;then no collision
	
	;first condition: BALL_X < PLAYER_X + PLAYER_WIDTH
	mov CX, PLAYER_X
	add CX, PLAYER_WIDTH
	cmp CX, BALL_X
	JLE FALSE
	
	;second condition: BALL_X + BALL_SIZE > PLAYER_X
	mov CX, BALL_SIZE
	add CX, BALL_X
	cmp CX, PLAYER_X
	JLE FALSE
	
	;third condition: BALL_Y < PLAYER_Y + PLAYER_HIGHT
	mov CX, PLAYER_Y
	add CX, PLAYER_HIGHT
	cmp CX, BALL_Y
	JLE FALSE
	
	;fourth condition: BALL_Y + BALL_SIZE > PLAYER_Y
	mov CX, BALL_Y
	add CX, BALL_SIZE
	cmp CX, PLAYER_Y
	JLE FALSE
	
	;TRUE
	mov AX, 1
	
	FALSE:
		RET
CHECK_COL ENDP
;intialize score

INTIALIZE_SCORE PROC NEAR

PLAYER1_SCORE_LABEL:
	mov DL,7H             ;COL
	mov DH,0              ;ROW
	mov BH,0              ;PAGE
	mov AH,02H
	INT 10H               ;EXECUTE movE CURSOR
		
	mov BL,7              ;COLOR
	mov AL,PLAYER1_SCORE  ;OFFSET
		
	add AL,'0'
	
	INC PLAYER1_SCORE
	
	mov AH,0EH            ;EXECUTE PRINTING
	INT 10H
	mov ax,1
PLAYER2_SCORE_LABEL:
	mov DL,30             ;COL
	mov DH,0              ;ROW
	mov BH,0              ;PAGE
	mov AH,02H
	INT 10H               ;EXECUTE movE CURSOR
		
	mov BL,7              ;COLOR
	mov AL,PLAYER2_SCORE  ;OFFSET 
	
	add AL,'0'
	INC PLAYER2_SCORE
	mov AH,0EH            ;EXECUTE PRINTING
	INT 10H
	mov ax,1

RET
INTIALIZE_SCORE ENDP

INCREASE_SCORE_PLAYER1 PROC NEAR

	mov DL,7H             ;COL
	mov DH,0              ;ROW
	mov BH,0              ;PAGE
	mov AH,02H
	INT 10H               ;EXECUTE movE CURSOR
		
	mov BL,7              ;COLOR
	mov AL,PLAYER1_SCORE  ;OFFSET 
	INC PLAYER1_SCORE     ;INCREMENT CURSOR
	; MOV AL, PLAYER1_SCORE
	
	; MOV CharSent, AL

	; CALL SEND_CHOICE_SYNC
	
	add AL,'0'
	
	mov AH,0EH            ;EXECUTE PRINTING
	INT 10H
	mov ax,1
	DEC COUNTER_END1
	;CALL CHECK_MAX_SCORE_1

RET
INCREASE_SCORE_PLAYER1 ENDP
	
INCREASE_SCORE_PLAYER2 PROC NEAR
	
	mov DL,30             ;COL
	mov DH,0              ;ROW
	mov BH,0              ;PAGE
	mov AH,02H
	INT 10H               ;EXECUTE movE CURSOR
		
	mov BL,7              ;COLOR
	mov AL,PLAYER2_SCORE  ;OFFSET 
	INC PLAYER2_SCORE     ;INCREMENT CURSOR
	; CALL REC_CHOICE_SYNC
	; MOV AL, CharReceived
	; MOV PLAYER2_SCORE, AL
	add AL,'0'
	
	mov AH,0EH            ;EXECUTE PRINTING
	INT 10H
	mov ax,1
	DEC COUNTER_END2
	
	;CALL CHECK_MAX_SCORE_2
	RET
INCREASE_SCORE_PLAYER2 ENDP

OpenFile PROC 

		; Open file

		mov AH, 3Dh
		mov AL, 0 ; read only
		LEA DX, BCGBALLFilename
		INT 21h
		
		; you should check carry flag to make sure it worked correctly
		; carry = 0 -> successful , file handle -> AX
		; carry = 1 -> failed , AX -> error code
		 
		mov [BCGBALLFilehandle], AX
		RET

OpenFile ENDP

Readdata PROC

		mov AH,3Fh
		mov BX, [BCGBALLFilehandle]
		mov CX,BCGBALLWidth*BCGBALLHeight ; number of bytes to read
		LEA DX, BCGBALLData
		INT 21h
		RET

Readdata ENDP 

CloseFile PROC

		mov AH, 3Eh
		mov BX, [BCGBALLFilehandle]

		INT 21h
		RET

CloseFile ENDP

TAKE_PLAYER_NAME PROC 
		;move cursor
		mov AH,2
		mov DL,30
		mov DH,5
		INT 10h

			mov AH,9
			LEA DX,Enter_max_letters
			INT 21H

	PLAYER1_MESSAGE:

		;move cursor
		mov AH,2
		mov DL,0
		mov DH,10
		INT 10h
				
		mov AH,9
		LEA DX,PLAYERNAME_1_MESSAGE
		INT 21H
		
		;ENTER PLAYER 1 NAME
		mov ah,0AH        ;Read from keyboard
		LEA dx, PLAYERNAME_1                   
		int 21h 
		
		mov ah,2          ;move Cursor
		mov DL,0
		mov DH,11
		int 10h    

		;Display the input data in a new location
		mov dx, offset PLAYERNAME_1 +1
		mov ah, 9
		int 21h
		
		mov ah,2          ;move Cursor
		mov DL,0
		mov DH,14
		int 10h    

	PLAYER2_MESSAGE:

		mov AH,9
		LEA DX,PLAYERNAME_2_MESSAGE
		INT 21H

		mov ah,0AH        ;Read from keyboard
		mov dx,offset PLAYERNAME_2                   
		int 21h 
		
		mov ah,2          ;move Cursor
		mov DL,0
		mov DH,15
		int 10h  	
		
		mov dx, offset PLAYERNAME_2 +1;Display the input data in a new location
		mov ah, 9
		int 21h
		
		mov ah,2          ;move Cursor
		mov DL,0
		mov DH,17
		int 10h  	
			
		mov dx, offset PRESS1_TO_START
		mov ah, 9
		int 21h 
			
		mov AH , 0
		INT 16h
		
	RET
TAKE_PLAYER_NAME ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;chat
InitializScreen proc
	;(
		;open text mode(80*25)
		 mov ah,0
		 mov al,03
		 int 10h 

		;scroll upper half the screen	
		 mov ah,6       ; function 6
		 mov al,13
		 mov bh,77      ; video attribute
		 ;back ground:(0black-1blue-2blue-3green-5lightgreen-6red-7red)
		 mov ch,0       ; upper left Y
		 mov cl,0        ; upper left X
		 mov dh,0ch     ; lower right Y 
		 mov dl,79      ; lower right X 
		 int 10h  
	;)
ret
InitializScreen endp

InitializUART proc 
	;(
		mov dx,3fbh    ; Line Control Register
		mov al,10000000b  ;Set Divisor Latch Access Bit
		out dx,al    ;Out it
		;set the divisor:
		;first byte
		mov dx,3f8h
		mov al,0ch
		out dx,al 
		;second byte
		mov dx,3f9h
		mov al,00h
		out dx,al 
		
		;set the rest of the initialization
		mov dx,3fbh
		mov al,00011011b ;
		out dx,al 
	;)
ret
InitializUART endp

Send proc
	;(
	    
	    check_buffer:
		mov ah,1
		int 16h
		jz RetrunSend
		;if found letter, eat buffer
		mov ah,0
		int 16h
		mov CharSent,al
		
	CheckAgain:	
		;Check that Transmitter Holding Register is Empty
		mov dx , 3FDH  ; Line Status Register
		In al , dx    ;Read Line Status
		test al , 00100000b
		JZ  CheckAgain        ;Not empty 
		;jz RetrunSend
		
		;If empty put the VALUE in Transmit data register
		mov dx , 3F8H  ; Transmit data register
		mov  al,CharSent
		out dx , al 
		
		cmp al,27 ;if user presses (esc)
		jne Not_Esc_T ;end the program for both users
		mov si, 1
		ret
		Not_Esc_T:
		
		;compare with enter
		cmp ah, 1ch
		jne dont_scroll_line
		mov UpCursorx, -1	;because it's incremented in PrintChar
		inc UpCursory

		cmp UpCursory,13;if screen is full
		jne dont_scroll_line
		Scroll_Chat UpColor,0,0,79,12
		dec UpCursory

		jmp Dummy001
		dont_scroll_line:

		;check to remove
		cmp ah, 0eh 	;delete scan code
		jne Dummy001
		cmp UpCursorx, 0
		jne NotInStartX
		;in x = 0
		cmp UpCursory, 0
		jne NotInStartY
		;in x = 0 and y = 0
		ret
		NotInStartY:
		;in x = 0 but y != 0
		mov UpCursorx, 79
		dec UpCursory
		mov ah, 2
		mov dl, UpCursorx
		mov dh, UpCursory
		int 10h
		;print space
		mov ah, 2
		mov dl, 20h
		int 21h
		ret
		NotInStartX:
		dec UpCursorx
		mov ah, 2
		mov dl, UpCursorx
		mov dh, UpCursory
		int 10h
		;print space
		mov ah, 2
		mov dl, 20h
		int 21h
		
		ret
		Dummy001:

		;display
		mov bl,Up_Chat
		call PrintChar
	;)
RetrunSend:
ret
Send endp

Receive proc
	;(
		;Check that Data is Ready
		mov dx , 3FDH  ; Line Status Register
		in al , dx  
		test al , 1
		JZ RetrunReceived            ;Not Ready 
		
		 ;If Ready read the VALUE in Receive data register
		 mov dx , 03F8H     
		 in al , dx      
		 mov CharReceived , al 
		
		 ;if the user presses esc:
		 cmp al,27
		 jne Not_Esc_R ;end the program for both users
	 	mov si, 1
		 ret
	 	Not_Esc_R:

	 	;compare with enter
		cmp al, 0Dh
		jne dont_scroll_line_R
		mov DownCursorx, -1	;because it's incremented in PrintChar
		inc DownCursory

		cmp DownCursory, 25;if screen is full
		jne dont_scroll_line_R
		Scroll_Chat DownColor,0,13,79,24
		dec DownCursory

		jmp Dummy002
		dont_scroll_line_R:

		;check to remove
		cmp al, 08h 	;delete scan code
		jne Dummy002
		cmp DownCursorx, 0
		jne NotInStartX_R
		;in x = 0
		cmp DownCursory, 0
		jne NotInStartY_R
		;in x = 0 and y = 0
		ret
		NotInStartY_R:
		;in x = 0 but y != 0
		mov DownCursorx, 79
		dec DownCursory
		mov ah, 2
		mov dl, DownCursorx
		mov dh, DownCursory
		int 10h
		;print space
		mov ah, 2
		mov dl, 20h
		int 21h
		ret
		NotInStartX_R:
		dec DownCursorx
		mov ah, 2
		mov dl, DownCursorx
		mov dh, DownCursory
		int 10h
		;print space
		mov ah, 2
		mov dl, 20h
		int 21h
		
		ret
		Dummy002:

		 mov bl,Down_Chat
		 call PrintChar
		
	;)
RetrunReceived:
ret
Receive endp

PrintChar proc
	;(	
		
	    cmp bl,Up_Chat  ; prrint up
        JNE DOWN_Cursor		
		
		;mov dl,charsent
		cmp UpCursorx,80 ;end of the line
		 je UpCursoryLine
		
		mov dl,UpCursorx
		mov dh,UpCursory
		inc UpCursorx
		JMP Cursor_move
		
	UpCursoryLine:
        inc UpCursory   ;go to the next line
		cmp UpCursory,13;if screen is full
		jne DonotScrollUp
		Scroll_Chat UpColor,0,0,79,12
		dec UpCursory
	DonotScrollUp:	
		mov UpCursorx,0 ;start from the first column	
		mov dl,UpCursorx
		mov dh,UpCursory
		;for the upcomming character;could be removed from here and line 187 and be placed
		;before mov dl,UpCursorx and y but to initially start from (-1)
		;(each time we want to set the cursor at the begining of the line(x=0))
		inc UpCursorx
		JMP Cursor_move
		
	DOWN_Cursor:
		cmp DownCursorx,80;end of the line
		je DownpCursoryLine
		
		mov dl,DownCursorx
		mov dh,DownCursory 
		inc DownCursorx
		jmp Cursor_move
	DownpCursoryLine:
		inc DownCursory
		cmp DownCursory,25;if screen is full
		jne DonotScrollDown
		Scroll_Chat DownColor,0,13,79,24
		sub DownCursory,2
	DonotScrollDown:
		mov DownCursorx,0	
	    mov dl,DownCursorx
		mov dh,DownCursory
		inc DownCursorx;for the upcomming character
		
		Cursor_move:
		mov ah,2 
		mov bh,0;page;;;;;;;;;;;;;;important
		int 10h   ;excute 
		
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
		;Print the character:
	    cmp bl,Up_Chat  ; print up
        JNE DownPrint
		mov dl,charsent
		jmp PrintLabel	
		
	DownPrint:	
		mov dl,CharReceived
		
	PrintLabel:	
		mov ah, 2
        int 21h 
	;)
ret
PrintChar endp
;------------------------------------------------------
Receive_Action Proc

        ;Check that Data is Ready
		mov dx , 3FDH  ; Line Status Register
		in al , dx  
		test al , 1
		jz RetrunReceived_1           ;Not Ready 
		
		 ;If Ready read the VALUE in Receive data register
		 mov dx , 03F8H     
		 in al , dx      
		 mov CharReceived , al 
		
        RetrunReceived_1:
        ret 

Receive_Action Endp
;------------------------------------------------------------
Send_Action Proc

 check_buffer_1:
		mov ah,1
		int 16h
		jz RetrunSend_1
		;if found letter, eat buffer
		mov ah,0
		int 16h
		mov CharSent,al
		
	CheckAgain_1:	
		;Check that Transmitter Holding Register is Empty
		mov dx , 3FDH  ; Line Status Register
		In al , dx    ;Read Line Status
		test al , 00100000b
		jz  CheckAgain_1        ;Not empty 
		;jz RetrunSend
		
		;If empty put the VALUE in Transmit data register
		mov dx , 3F8H  ; Transmit data register
		mov  al,CharSent
		out dx , al

      RetrunSend_1:
	  ret
Send_Action Endp

SEND_CHOICE_SYNC Proc

	MOV DX, 3FDH
	AGAIN_SUNC:
		IN AL, DX
		AND AL, 00100000b
		JZ AGAIN_SUNC

	MOV DX, 3F8H
	MOV AL, CharSent
	OUT DX, AL
	ret
SEND_CHOICE_SYNC Endp

; SEND_CHOICE_SYNC MACRO VALUE
;     LOCAL AGAIN
;     MOV DX, 3FDH
;     AGAIN:
;         IN AL, DX
;         AND AL, 00100000b
;         JZ AGAIN

;     MOV DX, 3F8H
;     MOV AL, VALUE
;     OUT DX, AL
; ENDM SEND_CHOICE_SYNC


REC_CHOICE_SYNC Proc

	MOV DX, 3FDH
    IN AL, DX
    AND AL, 1
    JNZ READ
    JMP FINISH

    READ: 
        MOV DX, 03F8H
        IN AL, DX
        MOV CharReceived, AL
    FINISH:
	ret
REC_CHOICE_SYNC Endp

; REC_CHOICE_SYNC MACRO VALUE
;     MOV DX, 3FDH
;     IN AL, DX
;     AND AL, 1
;     JNZ READ
;     JMP FINISH

;     READ: 
;         MOV DX, 03F8H
;         IN AL, DX
;         MOV VALUE, AL
;     FINISH:
        
; ENDM REC_CHOICE_SYNC
	END MAIN 
		






