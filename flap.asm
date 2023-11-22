[org 0x0100]

jmp start

;checkCord:
;cmp cx, 320
;jb checkCord2
;mov cx, 0
;inc dx
;checkCord2:
;ret
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
mov al,06h
mov ah,0ch
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
groundLoop:
call defDrawGround
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

mov al, 2ch ; Yellow
mov cx, 40 ; x Cordinate
mov bx, [bp+4] ; y Cordinate
mov dx, bx ; y Cordinate
add bx, 15 ; y Cordinate + 15

drawBird:
mov ah, 0ch ; Draw pixel
int 10h ; Draw pixel
inc cx ; x Cordinate + 1
cmp cx, 65 ; Check if x Cordinate is 65
jb drawBird ; If x Cordinate is less than 65, draw another pixel
inc dx ; y Cordinate + 1
mov cx, 40 ; x Cordinate = 40
cmp dx, bx ; Check if y Cordinate is equal to y Cordinate + 15
jb drawBird ; If y Cordinate is less than y Cordinate + 15, draw another pixel

popa 
pop bp
ret 2

;=====================================

mainLoop:
call drawBackground
push 30
call defDrawBird
;jmp mainLoop
ret

start:

mov ah, 0
mov al, 13h
int 10h


call mainLoop


mov ah,00
int 16h

mov ax, 0x4c00
int 21h
