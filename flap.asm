[org 0x0100]

jmp start

checkCord:
cmp cx, 320
jb checkCord2
mov cx, 0
inc dx
checkCord2:
ret


drawBackground:


mov cx, 0
mov dx, 0
mov al, 35h
drawBackground2:
mov ah, 0ch
int 10h
call checkCord
cmp dx, 200
inc cx
jb drawBackground2
ret


mainLoop:
call drawBackground
jmp mainLoop
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
