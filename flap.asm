[org 0x0100]

jmp start

bird: db 12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,2Ah,2Ah,2Ah,2Ah,2Ah,2Ah,2Ah,2Ah,2Ah,2Ah,2Ah,2Ah,2Ah,2Ah,2Ah,12h,12h,12h,5Ch,5Ch,5Ch,5Ch,12h,12h,12h,2Ah,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ah,12h,5Ch,5Ch,5Ch,5Ch,5Ch,5Ch,12h,12h,2Ah,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ah,12h,5Ch,5Ch,5Ch,0h,0h,5Ch,12h,12h,2Ah,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ah,12h,5Ch,5Ch,5Ch,0h,0h,5Ch,12h,12h,2Ah,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,12h,5Ch,5Ch,5Ch,5Ch,5Ch,5Ch,12h,12h,12h,12h,12h,12h,12h,12h,12h,2Ah,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ah,12h,5Ch,5Ch,5Ch,5Ch,12h,12h,12h,5Ch,5Ch,5Ch,5Ch,5Ch,5Ch,12h,12h,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,12h,12h,12h,12h,12h,12h,12h,5Ch,5Ch,5Ch,5Ch,5Ch,12h,12h,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ah,12h,12h,12h,12h,12h,12h,12h,12h,12h,2Ah,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ah,2Ah,2Ah,2Ah,2Ah,2Ah,2Ah,2Ah,2Ah,12h,12h,2Ah,2Ah,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ah,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,2Ah,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,12h,29h,29h,29h,29h,29h,29h,29h,29h,29h,12h,12h,2Ah,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ah,12h,29h,29h,04h,04h,04h,04h,04h,12h,12h,12h,12h,2Ah,2Ah,2Ah,2Ah,2Ah,2Ah,2Ah,2Ah,2Ah,2Ah,2Ah,2Ah,12h,12h,29h,29h,29h,29h,29h,29h,29h,29h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h
ground: db 0xEE,48h,31h,31h,31h,31h,31h,79h,2Bh,43h,43h,43h,43h,43h,43h,43h,43h,43h,43h,43h,43h,43h,43h,43h,43h,43h,43h,43h,43h,43h,43h,43h,43h,43h,43h,43h,43h,43h,43h,43h,43h,43h,43h,43h,43h,43h,43h,43h,43h,43h
pipe: db 0xEE,0xEE,60h,49h,0xEE,0Ah,0xEE,0Ah,2Fh,60h,60h,60h,60h,2Fh,2Fh,2Fh,2Fh,2Fh,2Fh,2Fh,2Fh,2Fh,2Fh,2Fh,2Fh,2Fh,2Fh,2Fh,0xEE,2Fh,2Fh,0xEE,2Fh,02h,02h,79h,79h,0xBF,0xEE,0xEE
birdy: dw 30
pipesX: dw 200
pipesY: dw 50
boolDrawBottomPipe: dw 0
intBottomPipeStart: dw 0
intPipeEndX: dw 0
intBirdBottomY: dw 0
velocityUp: dw 6
velocityUpCounter: dw 0
positionUpCounter: dw 2
velocityDown: dw 5
velocityDownCounter: dw 7
positionDownCounter: dw 5

SPACE_KEY equ 20h
;====================================
defSleep:
pusha
mov cx, 0; keep it 0
mov dx, 0x1388 ; 5000 microseconds
mov ah, 86h ; function 86h
int 15h ; call interrupt 15h
popa
ret

;====================================
defDrawSky: ; Draw a entire row of sky
mov al,35h
mov ah,0ch
mov cx,0
drawSky:
int 10h
inc cx
cmp cx,320
jb drawSky
ret
;====================================
defDrawGround: ; Draw a entire row of ground
mov byte al, [bx]
mov cx,0
drawGround:
int 10h
inc cx
cmp cx,320
jb drawGround
ret
;=====================================
drawBackground:
pusha
mov dx, 0
skyLoop:
call defDrawSky
inc dx
cmp dx, 150
jb skyLoop
mov bx, ground
groundLoop:
call defDrawGround
inc bx
inc dx
cmp dx, 200
jb groundLoop
popa
ret
;=====================================

;Draw Flappy bird, Input: 1 dw element, y Cordinate
defDrawBird:
push bp
mov bp, sp
pusha

mov cx, 40 ; x Cordinate
mov bx, [bp+4] ; y Cordinate
mov dx, bx ; y Cordinate
add bx, 15 ; y Cordinate + 15
mov word [intBirdBottomY], bx ; Save y Cordinate

mov bx, bird; point bx to bird
sub dx,1
mov ah,0ch

mov al,35h
drawTopSky:
int 10h
inc cx
cmp cx,65
jb drawTopSky

mov cx, 40
inc dx

drawBird:
mov byte al, [bx] ; Get pixel color
int 10h ; Draw pixel
inc cx ; x Cordinate + 1
inc bx ; point bx to next pixel
cmp cx, 65 ; Check if x Cordinate is 65
jb drawBird ; If x Cordinate is less than 65, draw another pixel
inc dx ; y Cordinate + 1
mov cx, 40 ; x Cordinate = 40
cmp dx, [intBirdBottomY] ; Check if y Cordinate is equal to y Cordinate
jb drawBird ; If y Cordinate is less than y Cordinate + 15, draw another pixel

mov al,35h
drawBottomSky:
int 10h
inc cx
cmp cx,65
jb drawBottomSky

popa 
pop bp
ret 2

;=====================================
moveBird:
pusha; Push all registers to stack
mov ah,01h ; Get keyboard input
int 16h ; Get keyboard input
jz moveBirdUp
mov ah,00h ; Get keyboard input
int 16h ; Get keyboard input
cmp al,SPACE_KEY ; Check if keyboard input is SPACE_KEY
jne moveBirdUp ; If keyboard input is not SPACE_KEY, jump to moveBirddown

mov word [velocityUp], 0
mov word [positionUpCounter], 0

mov word [velocityDown], 5
mov word [velocityDownCounter], 7
mov word [positionDownCounter], 5

moveBirdUp:
cmp word [velocityUp], 6
je moveBirdDown
cmp word [positionUpCounter], 2
ja skipMoveUp
dec word [birdy]
mov bx, [velocityUp]
inc bx
mov [positionUpCounter], bx
skipMoveUp:
cmp word [velocityUpCounter], 0
jne endUpMove
inc word [velocityUp]
mov word [velocityUpCounter], 7
endUpMove:
dec word [positionUpCounter]
dec word [velocityUpCounter]
jmp endMoveBird

moveBirdDown:
cmp word [positionDownCounter], 0
jne skipMoveDown
inc word [birdy]
mov bx, [velocityDown]
mov [positionDownCounter], bx

skipMoveDown:
cmp word [velocityDown], 0
je endMoveBird
cmp word [velocityDownCounter], 0
jne endDownMove
dec word [velocityDown]
mov word [velocityDownCounter], 7
endDownMove:
dec word [velocityDownCounter]
dec word [positionDownCounter]



endMoveBird:

popa ; Pop all registers from stack
ret ; Return to mainLoop
;=====================================

defDrawPipe:
push bp
mov bp, sp
pusha

mov cx, [bp+4] ; x Cordinate
mov dx, 0 ; y Cordinate


mov ah, 0ch ; Function
mov bx, [bp+6]
mov word [intBottomPipeStart], bx ; Save y Cordinate
add word [intBottomPipeStart], 40
mov word [boolDrawBottomPipe], 0 ; boolDrawBottomPipe = 0
mov word [intPipeEndX], cx
add word [intPipeEndX], 40

mov bx, pipe


drawTopPipe:
cmp dx, [bp+6] ; Check if y Cordinate is equal to y Cordinate + 150
je drawBorder
cmp dx, [intBottomPipeStart]
je drawBorder
mov byte al, [bx]
jmp colorSelected
drawBorder:
mov al, 0xEE
colorSelected:

int 10h ; Draw pixel
inc dx ; x Cordinate + 1
cmp dx, [bp+6]
jbe drawTopPipe
cmp dx, [intBottomPipeStart]
ja notSkip
add dx, 39
notSkip:
cmp dx, 150
jb drawTopPipe

inc cx
mov dx, 0
inc bx
cmp cx, [intPipeEndX]
jb drawTopPipe


endDrawPipe:
popa 
pop bp
ret 4

;=====================================
movePipe:
pusha
dec word [pipesX]
mov cx, [pipesX] ; x Cordinate
add cx,41 ; Last x Cordinate + 41
mov dx,0 ; y Cordinate
mov al,35h
mov ah,0ch
drawLastColumnSky:
int 10h
inc dx
cmp dx,150
jb drawLastColumnSky
;Check if pipe is out of screen
sub cx,41 ; Last x Cordinate
cmp cx,0
jne endMovePipe
mov word [pipesX], 320

endMovePipe:
popa
ret
;=====================================

defCheckCollisions:
push bp
mov bp, sp
pusha

; check for collision with ground
mov dx, [birdy] ; y Cordinate
cmp dx, 0
ja topCollisionClear
mov word [moveUpCounter], 0
mov word [birdy], 1

topCollisionClear:
add dx, 15
cmp dx, 150
jb groundCollisionClear
mov ah,00
int 16h

groundCollisionClear:


popa
pop bp
ret

;=====================================
mainLoop:

call moveBird
call movePipe
call defCheckCollisions
push word [birdy]
call defDrawBird

push word [pipesY] ; x Cordinate of pipe
push word [pipesX] ; y Cordinate of pipe
call defDrawPipe

;call defSleep
jmp mainLoop

start:

mov ah, 0
mov al, 13h
int 10h

call drawBackground
jmp mainLoop

mov ax, 0x4c00
int 21h
