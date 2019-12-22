Scroll_Chat macro Color,Upx,Upy,Downx,Downy;bytes
pusha
	;(
		;scroll upper half the screen	
		 mov ah,6       ; function 6
		 mov al,1		;scroll one line
		 mov bh,Color      ; video attribute
		 mov ch,Upy      ; upper left Y
		 mov cl,Upx       ; upper left X
		 mov dh,Downy    ; lower right Y 
		 mov dl,Downx      ; lower right X 
		 int 10h  
	;)
popa	
endm Scroll_Chat

.model small
.stack
.386
.data
CharSent db 's'
CharReceived db 'R'
UpCursorx db 0
UpCursory db 0
DownCursorx db 0
DownCursory db 13
Up equ 1
Down equ 2

UpColor equ 77
DownColor equ 07

.code      

main proc far    
	mov ax,@data
	mov ds,ax
	;initialize
	call InitializScreen
	call InitializUART
	
	;(
	Again:	
		call send
		call Receive
		jmp Again
	;)	
Finish:	
mov ah,4Ch
int 21h
main endp

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
;;;;;;;;;;;;;;;;;;;
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
;;;;;;;;;;;;;;;;;;;;;;
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
		je Finish ;end the program for both users
		
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
		mov bl,Up
		call PrintChar
	;)
RetrunSend:
ret
Send endp
;;;;;;;;;;;;;;;
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
		 je Finish ;end the program for both users
	 
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

		 mov bl,Down
		 call PrintChar
		
	;)
RetrunReceived:
ret
Receive endp
;;;;;;;;;;;;
PrintChar proc
	;(	
		
	    cmp bl,Up  ; prrint up
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
		MOV UpCursorx,0 ;start from the first column	
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
		MOV DownCursorx,0	
	    mov dl,DownCursorx
		mov dh,DownCursory
		inc DownCursorx;for the upcomming character
		
		Cursor_move:
		mov ah,2 
		mov bh,0;page;;;;;;;;;;;;;;important
		int 10h   ;excute 
		
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
		;Print the character:
	    cmp bl,Up  ; print up
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

Receive_Action Proc

        ;Check that Data is Ready
		mov dx , 3FDH  ; Line Status Register
		in al , dx  
		test al , 1
		JZ RetrunReceived            ;Not Ready 
		
		 ;If Ready read the VALUE in Receive data register
		 mov dx , 03F8H     
		 in al , dx      
		 mov CharReceived , al 
		
        RetrunReceived
Receive_Action Endp

Send_Ation Proc

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
Send_Ation Endp


end main