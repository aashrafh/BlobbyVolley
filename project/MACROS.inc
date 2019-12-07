CLEAR MACRO COLOR, X, Y, WIDTH, HIGHT
	LOCAL outerloopclear, innerloopclear
	 mov  bh , 0   ;DisplayPage doesn't change	 
     mov  Dx , Y ;start Y for player1
	
	
	 mov  DI , X; limit for x
	 add  DI , WIDTH 
	 sub  DI , 1
	 
     mov  BX , Y	 ; limit for y
     add  BX , HIGHT
     Sub  BX , 1
outerloopclear:
       mov cx , X ;start x for player1
	   
	innerloopclear:	 
			mov al , COLOR ;color for this cell
			mov ah ,0ch ;Draw command
			int 10h     ;int fo Draw pixel
			inc cx
			cmp cx ,DI ;the end X for Ball
			jbe innerloopclear
			
        inc dx
        cmp dx  ,BX ; the end Y for player1
        jbe  outerloopclear
EndM CLEAR
;---------------------------------------------------------------------------
DRAW MACRO COLOR, X, Y, WIDTH, HIGHT
	LOCAL outerloop, innerloop
	 mov  SI , offset COLOR
     mov  bh , 0   ;DisplayPage doesn't change	 
     mov  Dx , Y;start Y for WALL
	
	 mov  DI , WIDTH
	 add  DI , X
	 sub  DI  ,1
	 
     mov  BX , HIGHT ; limit for y
     add  BX , Y	 
     Sub  BX , 1  
     ;Draw
	
 outerloop:
     mov cx, X ;start x for WALL
    
	 innerloop:	 
			mov al ,[SI] ;color for this cell
			mov ah ,0ch ;Draw command
			int 10h     ;int fo Draw pixel
			inc cx
			inc SI
			cmp cx , DI ;the end X for WALL
			jbe innerloop
			
        inc dx
        cmp dx  ,BX ; the end Y for WALL
        jbe  outerloop	
ENDM DRAW
print MACRO  message,size, x, y ,color

    mov  ah,13h                ;SERVICE TO DISPLAY STRING WITH COLOR.
    mov  bh,0                  ;PAGE (ALWAYS ZERO).
    lea bp, message  ;STRING TO DISPLAY.
    mov  bl,color    ;color   
    mov  cx,size                 ;STRING LENGTH.
    mov  dl,x                  ;X (SCREEN COORDINATE). 
    mov  dh,y                  ;Y (SCREEN COORDINATE). 
    int  10h  
ENDM DRAW