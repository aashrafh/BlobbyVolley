PUBLIC WALL
PUBLIC PLAYER1
PUBLIC PLAYER2

.model SMALL
.data 
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

PLAYER1 DB  11 , 11 , 11 , 11 , 11 , 11 , 11 , 11 , 11 , 11 , 11 , 11 , 11 , 11 , 11 , 11 , 11 , 11 , 11 , 11 , 11 
		DB  11 , 11 , 11 , 11 , 11 , 11 , 11 , 11 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 11 , 11 , 11 , 11 
		DB  11 , 11 , 11 , 11 , 11 , 11 , 11 , 11 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 11 , 11 , 11 , 11 
		DB  11 , 11 , 11 , 11 , 11 , 11 , 11 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 11 
		DB  11 , 11 , 11 , 11 , 11 , 11 , 00 , 10 , 00 , 00 , 00 , 00 , 00 , 10 , 00 , 00 , 00 , 00 , 10 , 10 , 00 
		DB  11 , 11 , 11 , 11 , 11 , 11 , 00 , 10 , 00 , 00 , 00 , 00 , 00 , 10 , 00 , 00 , 00 , 00 , 10 , 10 , 00 
		DB  11 , 11 , 11 , 11 , 11 , 11 , 00 , 10 , 10 , 10 , 00 , 10 , 10 , 10 , 10 , 00 , 00 , 10 , 10 , 10 , 00 
		DB  11 , 11 , 11 , 11 , 11 , 11 , 00 , 10 , 10 , 10 , 10 , 10 , 10 , 10 , 10 , 10 , 10 , 10 , 10 , 10 , 00 
		DB  11 , 11 , 11 , 11 , 11 , 11 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 14 , 14 , 14 , 14 , 00 , 00 , 11 
		DB  11 , 11 , 11 , 11 , 11 , 11 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 14 , 14 , 14 , 14 , 00 , 00 , 11 
		DB  11 , 11 , 11 , 11 , 11 , 11 , 11 , 00 , 00 , 00 , 00 , 14 , 14 , 00 , 14 , 00 , 00 , 14 , 00 , 00 , 11 
		DB  11 , 11 , 11 , 11 , 11 , 11 , 11 , 00 , 10 , 10 , 10 , 14 , 14 , 14 , 14 , 00 , 00 , 14 , 00 , 00 , 11 
		DB  11 , 11 , 11 , 11 , 11 , 11 , 11 , 00 , 10 , 10 , 10 , 10 , 10 , 14 , 14 , 14 , 14 , 14 , 00 , 00 , 11 
		DB  11 , 11 , 11 , 11 , 11 , 11 , 11 , 00 , 10 , 10 , 10 , 10 , 10 , 14 , 14 , 14 , 14 , 14 , 00 , 00 , 11 
		DB  11 , 11 , 11 , 11 , 11 , 11 , 00 , 10 , 10 , 10 , 10 , 10 , 10 , 10 , 10 , 10 , 10 , 10 , 00 , 00 , 11 
		DB  11 , 11 , 11 , 11 , 00 , 00 , 10 , 10 , 10 , 10 , 10 , 10 , 10 , 10 , 10 , 00 , 00 , 00 , 11 , 11 , 11 
		DB  11 , 11 , 11 , 11 , 00 , 00 , 10 , 10 , 10 , 10 , 10 , 10 , 10 , 10 , 10 , 00 , 00 , 00 , 11 , 11 , 11 
		DB  11 , 11 , 11 , 11 , 00 , 00 , 10 , 10 , 10 , 10 , 10 , 00 , 00 , 00 , 00 , 10 , 10 , 00 , 11 , 11 , 11 
		DB  11 , 11 , 11 , 00 , 10 , 10 , 10 , 10 , 14 , 14 , 14 , 00 , 00 , 00 , 00 , 00 , 00 , 11 , 11 , 11 , 11 
		DB  11 , 11 , 11 , 00 , 10 , 10 , 10 , 10 , 14 , 14 , 14 , 00 , 00 , 00 , 00 , 11 , 11 , 11 , 11 , 11 , 11 
		DB  11 , 11 , 11 , 00 , 10 , 10 , 10 , 10 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 11 , 11 , 11 , 11 , 11 , 11 
		DB  11 , 00 , 00 , 10 , 10 , 10 , 10 , 00 , 00 , 00 , 10 , 10 , 10 , 10 , 10 , 00 , 00 , 11 , 11 , 11 , 11 
		DB  11 , 00 , 10 , 10 , 00 , 00 , 00 , 11 , 11 , 11 , 00 , 00 , 00 , 00 , 00 , 11 , 11 , 11 , 11 , 11 , 11 
		DB  11 , 00 , 00 , 00 , 00 , 00 , 00 , 11 , 11 , 11 , 00 , 00 , 00 , 00 , 00 , 11 , 11 , 11 , 11 , 11 , 11 
		;DB  11 , 11 , 11 , 11 , 11 , 11 , 11 , 11 , 11 , 11 , 11 , 11 , 11 , 11 , 11 , 11 , 11 , 11 , 11 , 11 , 11 

PLAYER2 DB   11 , 11 , 11 , 11 , 11 , 11 , 11 , 11 , 11 , 11 , 11 , 11 , 11 , 11 , 11 , 11 , 11 , 11 , 11 , 11 ,11
		DB   11 , 11 , 11 , 11 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 11 , 11 , 11 , 11 , 11 , 11 , 11 ,11
		DB   11 , 11 , 11 , 11 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 11 , 11 , 11 , 11 , 11 , 11 , 11 ,11
		DB   11 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 11 , 11 , 11 , 11 , 11 , 11 ,11
		DB   00 , 12 , 12 , 00 , 00 , 00 , 00 , 12 , 00 , 00 , 00 , 00 , 00 , 12 , 00 , 11 , 11 , 11 , 11 , 11 ,11
		DB   00 , 12 , 12 , 00 , 00 , 00 , 00 , 12 , 00 , 00 , 00 , 00 , 00 , 12 , 00 , 11 , 11 , 11 , 11 , 11 ,11
		DB   00 , 12 , 12 , 12 , 00 , 00 , 12 , 12 , 12 , 12 , 00 , 12 , 12 , 12 , 00 , 11 , 11 , 11 , 11 , 11 ,11
		DB   00 , 12 , 12 , 12 , 12 , 12 , 12 , 12 , 12 , 12 , 12 , 12 , 12 , 12 , 00 , 11 , 11 , 11 , 11 , 11 ,11
		DB   11 , 00 , 00 , 14 , 14 , 14 , 14 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 11 , 11 , 11 , 11 , 11 ,11
		DB   11 , 00 , 00 , 14 , 14 , 14 , 14 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 11 , 11 , 11 , 11 , 11 ,11
		DB   11 , 00 , 00 , 14 , 00 , 00 , 14 , 00 , 14 , 14 , 00 , 00 , 00 , 00 , 11 , 11 , 11 , 11 , 11 , 11 ,11
		DB   11 , 00 , 00 , 14 , 00 , 00 , 14 , 14 , 14 , 14 , 12 , 12 , 12 , 00 , 11 , 11 , 11 , 11 , 11 , 11 ,11
		DB   11 , 00 , 00 , 14 , 14 , 14 , 14 , 14 , 12 , 12 , 12 , 12 , 12 , 00 , 11 , 11 , 11 , 11 , 11 , 11 ,11
		DB   11 , 00 , 00 , 14 , 14 , 14 , 14 , 14 , 12 , 12 , 12 , 12 , 12 , 00 , 11 , 11 , 11 , 11 , 11 , 11 ,11
		DB   11 , 00 , 00 , 12 , 12 , 12 , 12 , 12 , 12 , 12 , 12 , 12 , 12 , 12 , 00 , 11 , 11 , 11 , 11 , 11 ,11
		DB   11 , 11 , 11 , 00 , 00 , 00 , 12 , 12 , 12 , 12 , 12 , 12 , 12 , 12 , 12 , 00 , 00 , 11 , 11 , 11 ,11
		DB   11 , 11 , 11 , 00 , 00 , 00 , 12 , 12 , 12 , 12 , 12 , 12 , 12 , 12 , 12 , 00 , 00 , 11 , 11 , 11 ,11
		DB   11 , 11 , 11 , 00 , 12 , 12 , 00 , 00 , 00 , 00 , 12 , 12 , 12 , 12 , 12 , 00 , 00 , 11 , 11 , 11 ,11
		DB   11 , 11 , 11 , 11 , 00 , 00 , 00 , 00 , 00 , 00 , 14 , 14 , 14 , 12 , 12 , 12 , 12 , 00 , 11 , 11 ,11
		DB   11 , 11 , 11 , 11 , 11 , 11 , 00 , 00 , 00 , 00 , 14 , 14 , 14 , 12 , 12 , 12 , 12 , 00 , 11 , 11 ,11
		DB   11 , 11 , 11 , 11 , 11 , 11 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 12 , 12 , 12 , 12 , 00 , 11 , 11 ,11
		DB   11 , 11 , 11 , 11 , 00 , 00 , 12 , 12 , 12 , 12 , 12 , 00 , 00 , 00 , 12 , 12 , 12 , 12 , 00 , 00 ,11
		DB   11 , 11 , 11 , 11 , 11 , 11 , 00 , 00 , 00 , 00 , 00 , 11 , 11 , 11 , 00 , 00 , 00 , 12 , 12 , 00 ,11
		DB   11 , 11 , 11 , 11 , 11 , 11 , 00 , 00 , 00 , 00 , 00 , 11 , 11 , 11 , 00 , 00 , 00 , 00 , 00 , 00 ,11
		;DB   11 , 11 , 11 , 11 , 11 , 11 , 11 , 11 , 11 , 11 , 11 , 11 , 11 , 11 , 11 , 11 , 11 , 11 , 11 , 11 ,11


END