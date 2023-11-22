[org 0x0100]

jmp start

;checkCord:
;cmp cx, 320
;jb checkCord2
;mov cx, 0
;inc dx
;checkCord2:
;ret
;--------------------------------------------
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
;---------------------------------------------------
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
;---------------------------------------------------------------------

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
;--------------------------------------------------------------------------

mainLoop:
call drawBackground
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
