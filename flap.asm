[org 0x0100]

jmp start

bird: db 12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,2Ah,2Ah,2Ah,2Ah,2Ah,2Ah,2Ah,2Ah,2Ah,2Ah,2Ah,2Ah,2Ah,2Ah,2Ah,12h,12h,12h,5Ch,5Ch,5Ch,5Ch,12h,12h,12h,2Ah,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ah,12h,5Ch,5Ch,5Ch,5Ch,5Ch,5Ch,12h,12h,2Ah,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ah,12h,5Ch,5Ch,5Ch,0h,0h,5Ch,12h,12h,2Ah,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ah,12h,5Ch,5Ch,5Ch,0h,0h,5Ch,12h,12h,2Ah,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,12h,5Ch,5Ch,5Ch,5Ch,5Ch,5Ch,12h,12h,12h,12h,12h,12h,12h,12h,12h,2Ah,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ah,12h,5Ch,5Ch,5Ch,5Ch,12h,12h,12h,5Ch,5Ch,5Ch,5Ch,5Ch,5Ch,12h,12h,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,12h,12h,12h,12h,12h,12h,12h,5Ch,5Ch,5Ch,5Ch,5Ch,12h,12h,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ah,12h,12h,12h,12h,12h,12h,12h,12h,12h,2Ah,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ah,2Ah,2Ah,2Ah,2Ah,2Ah,2Ah,2Ah,2Ah,12h,12h,2Ah,2Ah,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ah,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,2Ah,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,12h,29h,29h,29h,29h,29h,29h,29h,29h,29h,12h,12h,2Ah,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ch,2Ah,12h,29h,29h,04h,04h,04h,04h,04h,12h,12h,12h,12h,2Ah,2Ah,2Ah,2Ah,2Ah,2Ah,2Ah,2Ah,2Ah,2Ah,2Ah,2Ah,12h,12h,29h,29h,29h,29h,29h,29h,29h,29h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h
birdy: dw 30
SPACE_KEY equ 20h
;====================================
defSleep:
pusha
jc endSleep
mov cx, 0Fh
mov dx, 4240H
mov al, 0h
mov ah, 86h
int 15h
endSleep:
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
jnz moveBirdup ; If keyboard input , jump to moveBirdup
moveBirddown:
mov ax,[birdy] ; Move [birdy] to ax
sub ax,1 ; Subtract 1 from [birdy]
mov [birdy],ax ; Move ax to [birdy]
jmp endMoveBird ; Jump to endMoveBird
moveBirdup:
mov ah,00h ; Get keyboard input
int 16h ; Get keyboard input
cmp al,SPACE_KEY ; Check if keyboard input is SPACE_KEY
jne moveBirddown ; If keyboard input is not SPACE_KEY, jump to moveBirddown
mov ax,[birdy] ; Move [birdy] to ax
add ax,1 ; Add 1 to [birdy]
mov [birdy],ax ; Move ax to [birdy]
endMoveBird:
popa ; Pop all registers from stack
ret ; Return to mainLoop
;=====================================
mainLoop:

call moveBird
push word [birdy]
call defDrawBird
;call defSleep
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
