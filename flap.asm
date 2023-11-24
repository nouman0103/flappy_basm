[org 0x0100]

jmp start

bird: db 12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,2Ah,2Ah,2Ah,2Ah,2Ah,2Ah,2Ah,2Ah,2Ah,2Ah,2Ah,2Ah,2Ah,2Ah,2Ah,12h,12h,12h,5Ch,5Ch,5Ch,5Ch,12h,12h,12h,2Ah,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ah,12h,5Ch,5Ch,5Ch,5Ch,5Ch,5Ch,12h,12h,2Ah,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ah,12h,5Ch,5Ch,5Ch,0h,0h,5Ch,12h,12h,2Ah,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ah,12h,5Ch,5Ch,5Ch,0h,0h,5Ch,12h,12h,2Ah,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,12h,5Ch,5Ch,5Ch,5Ch,5Ch,5Ch,12h,12h,12h,12h,12h,12h,12h,12h,12h,2Ah,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ah,12h,5Ch,5Ch,5Ch,5Ch,12h,12h,12h,5Ch,5Ch,5Ch,5Ch,5Ch,5Ch,12h,12h,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,12h,12h,12h,12h,12h,12h,12h,5Ch,5Ch,5Ch,5Ch,5Ch,12h,12h,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ah,12h,12h,12h,12h,12h,12h,12h,12h,12h,2Ah,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ah,2Ah,2Ah,2Ah,2Ah,2Ah,2Ah,2Ah,2Ah,12h,12h,2Ah,2Ah,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ah,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,2Ah,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,12h,29h,29h,29h,29h,29h,29h,29h,29h,29h,12h,12h,2Ah,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ah,12h,29h,29h,04h,04h,04h,04h,04h,12h,12h,12h,12h,2Ah,2Ah,2Ah,2Ah,2Ah,2Ah,2Ah,2Ah,2Ah,2Ah,2Ah,2Ah,12h,12h,29h,29h,29h,29h,29h,29h,29h,29h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h
ground: db 0xEE,48h,31h,31h,31h,31h,31h,79h,2Bh,43h,43h,43h,43h,43h,43h,43h,43h,43h,43h,43h,43h,43h,43h,43h,43h,43h,43h,43h,43h,43h,43h,43h,43h,43h,43h,43h,43h,43h,43h,43h,43h,43h,43h,43h,43h,43h,43h,43h,43h,43h
birdy: dw 30
moveUpCounter: dw 0
pipesX: dw 200
pipesY: dw 50
SPACE_KEY equ 20h
;====================================
defSleep:
pusha
mov cx, 0; keep it 0
mov dx, 0x7530 ; 30000 microseconds
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
push bx ; Save y Cordinate + 15
mov bp, sp ; point bp to y Cordinate + 15
mov bx, bird; point bx to bird


sub dx,1

mov al,35h
mov ah,0ch
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
cmp dx, [bp] ; Check if y Cordinate is equal to y Cordinate
jb drawBird ; If y Cordinate is less than y Cordinate + 15, draw another pixel

mov al,35h
drawBottomSky:
int 10h
inc cx
cmp cx,65
jb drawBottomSky

pop bx ; Restore y Cordinate + 15
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

mov ax, [birdy]
mov [birdy], ax

mov ax, 30
mov [moveUpCounter], ax

moveBirdUp:
mov ax, [moveUpCounter]
cmp ax, 0
je moveBirdDown
sub ax, 1
mov [moveUpCounter], ax
mov ax, [birdy]
sub ax, 1
mov [birdy], ax
jmp endMoveBird
moveBirdDown:
mov ax,[birdy] ; Move [birdy] to ax
add ax,1 ; Add 1 from [birdy]
mov [birdy],ax ; Move ax to [birdy]

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

mov bx, cx ; x Cordinate
add bx, 40 ; x Cordinate + 40

mov al, 02h ; Color
mov ah, 0ch ; Function

drawTopPipe:
int 10h ; Draw pixel
inc cx ; x Cordinate + 1
cmp cx, bx ; Check if x Cordinate is equal to x Cordinate + 40
jb drawTopPipe ; If x Cordinate is less than x Cordinate + 40, draw another pixel
mov cx, [bp+4] ; x Cordinate = x Cordinate
inc dx ; y Cordinate + 1
cmp dx, [bp+6] ; Check if y Cordinate is equal to y Cordinate + 150
jb drawTopPipe ; If y Cordinate is less than y Cordinate + 150, draw another pixel

add dx, 40 ; y Cordinate + 40

drawBottomPipe: ; Draw bottom pipe
int 10h ; Draw pixel
inc cx ; x Cordinate + 1
cmp cx, bx ; Check if x Cordinate is equal to x Cordinate + 40
jb drawBottomPipe ; If x Cordinate is less than x Cordinate + 40, draw another pixel
mov cx, [bp+4] ; x Cordinate = x Cordinate
inc dx ; y Cordinate + 1
cmp dx, 150 ; Check if y Cordinate is equal to 150
jb drawBottomPipe ; If y Cordinate is less than 150, draw another pixel

popa 
pop bp
ret 4
;=====================================
movePipe:
pusha
mov ax, [pipesX] 
sub ax, 1
mov [pipesX], ax

mov cx,ax ; x Cordinate
add cx,41 ; Last x Cordinate + 41
mov dx,0 ; y Cordinate
mov al,35h
mov ah,0ch
drawLastColumnSky:
int 10h
inc dx
cmp dx,150
jb drawLastColumnSky
popa
ret
;=====================================
mainLoop:

call moveBird
call movePipe
push word [birdy]
call defDrawBird
call defSleep

push word [pipesY] ; x Cordinate of pipe
push word [pipesX] ; y Cordinate of pipe
call defDrawPipe
jmp mainLoop
ret

start:

mov ah, 0
mov al, 13h
int 10h

call drawBackground
call mainLoop


mov ah,00
int 16h

mov ax, 0x4c00
int 21h
