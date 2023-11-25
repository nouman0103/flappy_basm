bits 16
	org 100h

section .text

	start:

			; print 'A' in the screen
			mov ah, 0eh
			mov al, 'A'
			int 10h

		.loop:

			; send DSP Command 10h
			mov bl, 10h
			call sb_write_dsp

			; send byte audio sample
			mov si, [sound_index]
			mov bl, [sound_data + si]
			call sb_write_dsp	

			mov cx, 100 ; <-- change this value according to the speed of your computer
		.delay:
			nop
			loop .delay

			inc word [sound_index]
			cmp word [sound_index], 51529
			jb .loop

			; return to DOS
			mov ah, 4ch
			int 21h
	
	sb_write_dsp:
			mov dx, 22ch
		.busy:
			in al, dx
			test al, 10000000b
			jnz .busy
			mov al, bl
			out dx, al
			ret

section .data

	sound_index dw 0

	sound_data:
			incbin "kingsv.wav" ; 51.529 bytes